#!/usr/bin/env python3
"""Synchronize or validate release metadata against the canonical VERSION file."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import re


ROOT = Path(__file__).resolve().parents[1]
JSON_FIELDS = {
    "package.json": (("version",),),
    "package-lock.json": (("version",), ("packages", "", "version")),
    "COMPATIBILITY.json": (("modVersion",),),
    "ui/modules/apps/soturineChaosRandomizer/app.json": (("version",),),
}
TEXT_PATTERNS = {
    "lua/ge/extensions/soturineChaosRandomizer/main.lua": (
        r'(?m)^(local EXTENSION_VERSION = ")[^"]+("\s*)$',
        r"\g<1>{version}\g<2>",
    ),
    "ui/modules/apps/soturineChaosRandomizer/services/defaultState.js": (
        r'(?m)^(\s*extensionVersion:\s*")[^"]+("\s*,\s*)$',
        r"\g<1>{version}\g<2>",
    ),
    "ui/modules/apps/soturineChaosRandomizer/components/shell/AppHeader.vue": (
        r'''(core\.extensionVersion\s*\|\|\s*')[^']+(')''',
        r"\g<1>{version}\g<2>",
    ),
}

# These are current, unversioned documentation surfaces. Historical release
# directories and changelog entries are intentionally absent: their original
# version text is evidence and must never be bulk-rewritten.
CURRENT_DOCUMENT_PATTERNS = {
    "docs/AI_DIRECTOR.md": r"(?m)^v{version} keeps one capability-derived mode list",
    "docs/ARCHITECTURE.md": r"(?m)^## v{version} operation, Event and authority boundaries$",
    "docs/BEAMNG_0.39_COMPATIBILITY.md": r"(?m)^v{version} retains BeamNG 0\.39\.4",
    "docs/COMPATIBILITY.md": r"(?m)^v{version} also carries an authority-aware",
    "docs/I18N.md": r"(?m)^The canonical v{version} terminology policy is$",
    "docs/INSTALLATION.md": r"(?m)^For v{version} install only `soturine_chaos_randomizer_{version}\.zip`",
    "docs/MULTIPLAYER_READINESS.md": r"(?m)^v{version} does not depend on BeamMP",
    "docs/PERFORMANCE.md": r"(?m)^## v{version} Full Random batching and instrumentation$",
    "docs/PLAYGROUND.md": r"(?m)^v{version} packages a reusable `playgroundMode`",
    "docs/RACE.md": r"(?m)^## v{version} retry and containment$",
    "docs/SAFETY_MODEL.md": r"(?m)^v{version} keeps terminal outcome and applied state",
    "docs/TESTING.md": r"(?m)^v{version} live-derived regressions are mapped in$",
    "docs/TROUBLESHOOTING.md": r"(?m)^## v{version} diagnostic distinctions$",
    "docs/UI_DESIGN.md": r"(?m)^## v{version} Events and AppHost geometry$",
    "docs/UI_PROTOCOL.md": r"(?m)^## v{version} stable result and Preview codes$",
    "docs/status/CURRENT_COMPATIBILITY_MATRIX.md": r"(?m)^Published: \*\*{version} experimental prerelease\*\*",
    "docs/status/CURRENT_VALIDATION.md": r"(?m)^Current published release: \*\*{version} experimental prerelease\*\*",
}


def canonical_version(root: Path = ROOT) -> str:
    version = (root / "VERSION").read_text(encoding="utf-8").strip()
    if not re.fullmatch(r"\d+\.\d+\.\d+", version):
        raise ValueError("VERSION must contain MAJOR.MINOR.PATCH")
    return version


def _json_value(document: object, path: tuple[str, ...]) -> object:
    value = document
    for part in path:
        if not isinstance(value, dict) or part not in value:
            raise KeyError(".".join(path))
        value = value[part]
    return value


def _set_json_value(document: object, path: tuple[str, ...], version: str) -> None:
    value = document
    for part in path[:-1]:
        if not isinstance(value, dict) or part not in value:
            raise KeyError(".".join(path))
        value = value[part]
    if not isinstance(value, dict) or path[-1] not in value:
        raise KeyError(".".join(path))
    value[path[-1]] = version


def discrepancies(root: Path = ROOT) -> list[str]:
    version = canonical_version(root)
    errors: list[str] = []
    for relative, paths in JSON_FIELDS.items():
        document = json.loads((root / relative).read_text(encoding="utf-8"))
        for path in paths:
            actual = _json_value(document, path)
            if actual != version:
                errors.append(f"{relative}:{'.'.join(path)}={actual!r}, expected {version!r}")
    for relative, (pattern, _) in TEXT_PATTERNS.items():
        source = (root / relative).read_text(encoding="utf-8")
        match = re.search(pattern, source)
        if not match:
            errors.append(f"{relative}: version field not found")
        elif version not in match.group(0):
            errors.append(f"{relative}: version field does not match {version!r}")
    for relative, pattern_template in CURRENT_DOCUMENT_PATTERNS.items():
        source = (root / relative).read_text(encoding="utf-8")
        pattern = pattern_template.format(version=re.escape(version))
        if not re.search(pattern, source):
            errors.append(f"{relative}: current documentation marker does not match {version!r}")
    return errors


def synchronize(root: Path = ROOT) -> None:
    version = canonical_version(root)
    for relative, paths in JSON_FIELDS.items():
        path = root / relative
        document = json.loads(path.read_text(encoding="utf-8"))
        for field_path in paths:
            _set_json_value(document, field_path, version)
        path.write_text(json.dumps(document, indent=2, ensure_ascii=False) + "\n", encoding="utf-8", newline="\n")
    for relative, (pattern, replacement) in TEXT_PATTERNS.items():
        path = root / relative
        source = path.read_text(encoding="utf-8")
        updated, count = re.subn(pattern, replacement.format(version=version), source)
        if count != 1:
            raise ValueError(f"Expected exactly one version field in {relative}; found {count}")
        path.write_text(updated, encoding="utf-8", newline="\n")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true", help="update derived version fields")
    args = parser.parse_args()
    if args.write:
        synchronize()
    errors = discrepancies()
    if errors:
        for error in errors:
            print(f"VERSION_MISMATCH {error}")
        return 1
    print(f"VERSION_SYNC_OK {canonical_version()}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
