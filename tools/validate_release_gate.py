#!/usr/bin/env python3
"""Refuse a release unless its exact ZIP has complete live BeamNG evidence."""

from __future__ import annotations

import argparse
import hashlib
from pathlib import Path

try:
    from tools.package_mod import ARCHIVE_PREFIX, REPOSITORY_ROOT, live_test_counts, read_version
except ModuleNotFoundError:  # Direct execution: python tools/validate_release_gate.py
    from package_mod import ARCHIVE_PREFIX, REPOSITORY_ROOT, live_test_counts, read_version


class ReleaseGateError(RuntimeError):
    """Raised when live release evidence is absent, incomplete, or ambiguous."""


def validate_live_release(archive: Path, root: Path = REPOSITORY_ROOT) -> dict[str, int]:
    version = read_version(root)
    report = root / "docs" / "testing" / f"v{version}" / "LIVE_TEST_REPORT.md"
    if not report.is_file():
        raise ReleaseGateError(f"Live report does not exist: {report}")
    if not archive.is_file():
        raise ReleaseGateError(f"Release archive does not exist: {archive}")

    source = report.read_text(encoding="utf-8")
    normalized = source.casefold()
    if "not executed" in normalized or "não executado" in normalized:
        raise ReleaseGateError("Live BeamNG report is explicitly marked not executed")

    counts = live_test_counts(root)
    if counts["Executed"] <= 0:
        raise ReleaseGateError("Live report contains no executed cases")
    if counts["Executed"] != counts["Passed"] + counts["Failed"] + counts["Blocked"]:
        raise ReleaseGateError("Live report totals are internally inconsistent")
    for status in ("Failed", "Pending", "Blocked"):
        if counts[status] != 0:
            raise ReleaseGateError(f"Live report still contains {counts[status]} {status} case(s)")
    if counts["Passed"] != counts["Executed"]:
        raise ReleaseGateError("Every executed live case must be Passed for release")

    digest = hashlib.sha256(archive.read_bytes()).hexdigest()
    required_identity = (archive.name, digest, str(archive.stat().st_size))
    for value in required_identity:
        if value not in source:
            raise ReleaseGateError(f"Live report is not bound to exact artifact value: {value}")
    return counts


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("archive", type=Path, nargs="?", help="Exact release ZIP tested in BeamNG")
    args = parser.parse_args()
    version = read_version()
    archive = args.archive or REPOSITORY_ROOT / "dist" / f"{ARCHIVE_PREFIX}{version}.zip"
    counts = validate_live_release(archive)
    print(f"Live release gate passed: {counts['Passed']} / {counts['Executed']} cases")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
