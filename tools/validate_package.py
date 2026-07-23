#!/usr/bin/env python3
"""Validate structure, content, checksum, and reproducibility of the mod ZIP."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path, PurePosixPath
import stat
import tempfile
import zipfile

try:
    from package_mod import ARCHIVE_PREFIX, REPOSITORY_ROOT, build_archive, read_version
except ImportError:  # Imported as tools.validate_package.
    from tools.package_mod import ARCHIVE_PREFIX, REPOSITORY_ROOT, build_archive, read_version


REQUIRED_PATHS = {
    "LICENSE",
    "NOTICE",
    "VERSION",
    "lua/ge/extensions/soturineChaosRandomizer.lua",
    "lua/ge/extensions/soturineChaosRandomizer/main.lua",
    "lua/ge/extensions/soturineChaosRandomizer/apiAdapter.lua",
    "ui/modules/apps/soturineChaosRandomizer/app.json",
    "ui/modules/apps/soturineChaosRandomizer/app.js",
    "ui/modules/apps/soturineChaosRandomizer/app.html",
    "ui/modules/apps/soturineChaosRandomizer/app.css",
    "ui/modules/apps/soturineChaosRandomizer/app.png",
    "settings/soturineChaosRandomizer/defaults.json",
}
REQUIRED_ROOTS = {"lua", "ui", "settings"}
FORBIDDEN_COMPONENTS = {
    ".git",
    ".github",
    ".idea",
    ".vscode",
    "__pycache__",
    "dist",
    "docs",
    "tests",
    "tools",
}
FORBIDDEN_SUFFIXES = {".log", ".pyc", ".pyo", ".tmp", ".bak", ".swp"}


class PackageValidationError(ValueError):
    """Raised when a package violates the release layout contract."""


def _validate_member_name(name: str) -> PurePosixPath:
    if not name or "\\" in name or name.startswith("/"):
        raise PackageValidationError(f"Invalid ZIP path: {name!r}")
    path = PurePosixPath(name)
    if path.is_absolute() or any(part in ("", ".", "..") for part in path.parts):
        raise PackageValidationError(f"Unsafe ZIP path: {name!r}")
    if any(part.lower() in FORBIDDEN_COMPONENTS for part in path.parts):
        raise PackageValidationError(f"Development-only path found: {name}")
    if path.suffix.lower() in FORBIDDEN_SUFFIXES:
        raise PackageValidationError(f"Temporary or generated file found: {name}")
    return path


def validate_archive(archive_path: Path, expected_version: str | None = None) -> list[str]:
    archive_path = Path(archive_path)
    if not archive_path.is_file():
        raise PackageValidationError(f"ZIP does not exist: {archive_path}")

    expected_version = expected_version or read_version()
    expected_name = f"{ARCHIVE_PREFIX}{expected_version}.zip"
    if archive_path.name != expected_name:
        raise PackageValidationError(f"ZIP filename must be {expected_name}")

    with zipfile.ZipFile(archive_path, "r") as archive:
        infos = archive.infolist()
        names = [info.filename for info in infos]
        if len(names) != len(set(names)) or len(names) != len({name.casefold() for name in names}):
            raise PackageValidationError("ZIP contains duplicate or case-colliding paths")

        paths = [_validate_member_name(name) for name in names]
        roots = {path.parts[0] for path in paths}
        missing_roots = REQUIRED_ROOTS - roots
        if missing_roots:
            raise PackageValidationError(f"Missing root content directories: {sorted(missing_roots)}")
        missing_paths = REQUIRED_PATHS - set(names)
        if missing_paths:
            raise PackageValidationError(f"Missing required files: {sorted(missing_paths)}")

        for info in infos:
            mode = info.external_attr >> 16
            if mode and stat.S_ISLNK(mode):
                raise PackageValidationError(f"Symbolic links are not allowed: {info.filename}")
            if info.filename.lower().endswith(".json"):
                try:
                    json.loads(archive.read(info).decode("utf-8"))
                except (UnicodeDecodeError, json.JSONDecodeError) as error:
                    raise PackageValidationError(f"Invalid JSON in {info.filename}: {error}") from error

        packaged_version = archive.read("VERSION").decode("utf-8").strip()
        if packaged_version != expected_version:
            raise PackageValidationError(
                f"Packaged VERSION is {packaged_version!r}, expected {expected_version!r}"
            )

    return names


def validate_checksum(archive_path: Path) -> None:
    checksum_path = archive_path.with_suffix(".sha256")
    if not checksum_path.is_file():
        raise PackageValidationError(f"Checksum does not exist: {checksum_path}")
    expected_line = checksum_path.read_text(encoding="ascii").strip()
    expected_digest, separator, expected_name = expected_line.partition("  ")
    actual_digest = hashlib.sha256(archive_path.read_bytes()).hexdigest()
    if not separator or expected_name != archive_path.name or expected_digest != actual_digest:
        raise PackageValidationError("SHA-256 checksum file does not match the archive")


def validate_reproducible(archive_path: Path, root: Path = REPOSITORY_ROOT) -> None:
    with tempfile.TemporaryDirectory(prefix="scr-package-") as temporary:
        rebuilt = Path(temporary) / archive_path.name
        build_archive(rebuilt, root)
        if rebuilt.read_bytes() != archive_path.read_bytes():
            raise PackageValidationError("Archive is not reproducible from the current inputs")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("archive", type=Path, nargs="?", help="ZIP to validate")
    parser.add_argument("--no-reproducibility-check", action="store_true")
    args = parser.parse_args()

    version = read_version()
    archive = args.archive or REPOSITORY_ROOT / "dist" / f"{ARCHIVE_PREFIX}{version}.zip"
    names = validate_archive(archive, version)
    validate_checksum(archive)
    if not args.no_reproducibility_check:
        validate_reproducible(archive)

    print(f"Validated {archive}")
    print(f"Entries ({len(names)}):")
    for name in names:
        print(f"  {name}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
