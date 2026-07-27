#!/usr/bin/env python3
"""Validate experimental prerelease or fully live-validated release evidence."""

from __future__ import annotations

import argparse
import hashlib
import re
import sys
from pathlib import Path

try:
    from tools import validate_package
    from tools.package_mod import (
        ARCHIVE_PREFIX,
        REPOSITORY_ROOT,
        get_commit_sha,
        read_version,
        release_identity,
    )
except ModuleNotFoundError:  # Direct execution: python tools/validate_release_gate.py
    import validate_package
    from package_mod import ARCHIVE_PREFIX, REPOSITORY_ROOT, get_commit_sha, read_version, release_identity


class ReleaseGateError(RuntimeError):
    """Raised when release evidence is absent, inconsistent, or dishonest."""


REPORT_STATUSES = ("Executed", "Passed", "Failed", "Pending", "Blocked")
MANIFEST_STATUS_KEYS = {
    "Executed": "interactiveExecuted",
    "Passed": "interactivePassed",
    "Failed": "interactiveFailed",
    "Pending": "interactivePending",
    "Blocked": "interactiveBlocked",
}


def _release_documents(root: Path, version: str) -> tuple[Path, Path]:
    documentation_version = str(release_identity(version)["documentationVersion"])
    report = root / "docs" / "testing" / f"v{documentation_version}" / "LIVE_TEST_REPORT.md"
    notes = root / "docs" / "RELEASE NOTES" / f"RELEASE_NOTES_{version}.md"
    if not report.is_file():
        raise ReleaseGateError(f"Live report does not exist: {report}")
    if not notes.is_file():
        raise ReleaseGateError(f"Release notes do not exist: {notes}")
    return report, notes


def _read_report_counts(source: str) -> dict[str, int]:
    counts: dict[str, int] = {}
    for status in REPORT_STATUSES:
        matches = re.findall(rf"^\|\s*{status}\s*\|\s*(\d+)\s*\|\s*$", source, re.MULTILINE)
        if len(matches) != 1:
            raise ReleaseGateError(f"Live report must contain exactly one {status} total")
        counts[status] = int(matches[0])
    expected_executed = counts["Passed"] + counts["Failed"] + counts["Blocked"]
    if counts["Executed"] != expected_executed:
        raise ReleaseGateError("Live report totals are internally inconsistent")
    if counts["Executed"] + counts["Pending"] <= 0:
        raise ReleaseGateError("Live report contains no cases")
    return counts


def _validate_candidate_artifacts(archive: Path, root: Path, counts: dict[str, int]) -> dict[str, object]:
    version = read_version(root)
    validate_package.validate_archive(archive, version)
    validate_package.validate_checksum(archive)
    validate_package.validate_reproducible(archive, root)
    manifest = validate_package.validate_release_manifest(archive, root)

    if manifest.get("manifestVersion") != 3:
        raise ReleaseGateError("Release manifest version must be 3")
    expected_commit = get_commit_sha(root)
    if expected_commit == "unknown" or manifest.get("commit") != expected_commit:
        raise ReleaseGateError("Release manifest commit does not match the current checkout")
    identity = release_identity(version)
    for key in ("tag", "releaseStage", "publicationAllowed", "releaseStatus", "prerelease"):
        if manifest.get(key) != identity[key]:
            raise ReleaseGateError(f"Release manifest {key} does not match the publication stage")
    if manifest.get("branch") != "main":
        raise ReleaseGateError("Release manifest branch must be main")

    manifest_tests = manifest.get("tests")
    if not isinstance(manifest_tests, dict):
        raise ReleaseGateError("Release manifest test metrics are missing")
    for status, key in MANIFEST_STATUS_KEYS.items():
        if manifest_tests.get(key) != counts[status]:
            raise ReleaseGateError(f"Release manifest {key} does not match the live report")
    return manifest


def _reject_false_live_claims(source: str) -> None:
    false_claims = (
        r"live (?:beamng )?validation\s*:\s*(?:passed|complete)",
        r"definitively fixed in gameplay",
        r"110\s*/\s*110[^\n]*passed",
    )
    normalized = source.casefold()
    for pattern in false_claims:
        if re.search(pattern, normalized):
            raise ReleaseGateError(f"Release notes contain an unsupported live-validation claim: {pattern}")


def validate_prerelease_candidate(archive: Path, root: Path = REPOSITORY_ROOT) -> dict[str, int]:
    version = read_version(root)
    identity = release_identity(version)
    report, notes = _release_documents(root, version)
    report_source = report.read_text(encoding="utf-8")
    notes_source = notes.read_text(encoding="utf-8")
    counts = _read_report_counts(report_source)

    if counts["Failed"] != 0:
        raise ReleaseGateError(f"Prerelease report contains {counts['Failed']} failed live case(s)")
    if counts["Blocked"] != 0:
        raise ReleaseGateError(f"Prerelease report contains {counts['Blocked']} blocked live case(s)")
    report_normalized = report_source.casefold()
    if "pending owner validation" not in report_normalized:
        raise ReleaseGateError("Live report must declare Pending owner validation")
    if "not executed" not in report_normalized and counts["Executed"] == 0:
        raise ReleaseGateError("Live report must state clearly that live validation was not executed")
    version_label = "release version"
    if version_label not in report_normalized or version not in report_source:
        raise ReleaseGateError(f"Live report must identify the {version_label}")
    if "validation owner" not in report_normalized or "repository owner" not in report_normalized:
        raise ReleaseGateError("Live report must identify the repository owner as validation owner")

    notes_normalized = notes_source.casefold()
    stage_disclosure = "experimental prerelease"
    required_notes = (
        stage_disclosure,
        "automated validation: passed",
        "live beamng validation: pending owner validation",
        f"0 executed / 0 passed / 0 failed / {counts['Pending']} pending / 0 blocked",
    )
    for required in required_notes:
        if required not in notes_normalized:
            raise ReleaseGateError(f"Release notes are missing required prerelease disclosure: {required}")
    _reject_false_live_claims(notes_source)
    _validate_candidate_artifacts(archive, root, counts)
    return counts


def validate_live_release(archive: Path, root: Path = REPOSITORY_ROOT) -> dict[str, int]:
    version = read_version(root)
    report, _ = _release_documents(root, version)
    source = report.read_text(encoding="utf-8")
    normalized = source.casefold()
    counts = _read_report_counts(source)

    if "not executed" in normalized or "pending owner validation" in normalized:
        raise ReleaseGateError("Live BeamNG report is not marked as completed validation")
    if counts["Executed"] <= 0:
        raise ReleaseGateError("Live report contains no executed cases")
    for status in ("Failed", "Pending", "Blocked"):
        if counts[status] != 0:
            raise ReleaseGateError(f"Live report still contains {counts[status]} {status} case(s)")
    if counts["Passed"] != counts["Executed"]:
        raise ReleaseGateError("Every executed live case must be Passed for validated release")

    digest = hashlib.sha256(archive.read_bytes()).hexdigest()
    required_identity = (archive.name, digest, str(archive.stat().st_size))
    for value in required_identity:
        if value not in source:
            raise ReleaseGateError(f"Live report is not bound to exact artifact value: {value}")
    _validate_candidate_artifacts(archive, root, counts)
    return counts


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("archive", type=Path, nargs="?", help="Release ZIP to validate")
    parser.add_argument(
        "--channel",
        choices=("prerelease", "validated"),
        default="validated",
        help="Evidence policy to enforce (default: validated)",
    )
    args = parser.parse_args()
    version = read_version()
    archive = args.archive or REPOSITORY_ROOT / "dist" / f"{ARCHIVE_PREFIX}{version}.zip"
    validator = validate_prerelease_candidate if args.channel == "prerelease" else validate_live_release
    try:
        counts = validator(archive)
    except (ReleaseGateError, validate_package.PackageValidationError) as error:
        print(f"Release gate failed ({args.channel}): {error}", file=sys.stderr)
        return 1
    print(
        f"Release gate passed ({args.channel}): "
        f"{counts['Executed']} executed, {counts['Passed']} passed, "
        f"{counts['Failed']} failed, {counts['Pending']} pending, {counts['Blocked']} blocked"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
