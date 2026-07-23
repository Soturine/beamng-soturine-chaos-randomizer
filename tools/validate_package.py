#!/usr/bin/env python3
"""Validate structure, content, checksum, and reproducibility of the mod ZIP."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path, PurePosixPath
import re
import stat
import struct
import tempfile
import zipfile

try:
    from package_mod import ARCHIVE_PREFIX, REPOSITORY_ROOT, TEXT_FILENAMES, TEXT_SUFFIXES, build_archive, read_version
except ImportError:  # Imported as tools.validate_package.
    from tools.package_mod import ARCHIVE_PREFIX, REPOSITORY_ROOT, TEXT_FILENAMES, TEXT_SUFFIXES, build_archive, read_version


REQUIRED_PATHS = {
    "LICENSE",
    "NOTICE",
    "VERSION",
    "lua/ge/extensions/soturineChaosRandomizer.lua",
    "lua/ge/extensions/soturineChaosRandomizer/main.lua",
    "lua/ge/extensions/soturineChaosRandomizer/apiAdapter.lua",
    "lua/ge/extensions/soturineChaosRandomizer/configVerification.lua",
    "lua/ge/extensions/soturineChaosRandomizer/paintVerification.lua",
    "lua/ge/extensions/soturineChaosRandomizer/validator.lua",
    "lua/ge/extensions/soturineChaosRandomizer/vehicleDNA.lua",
    "lua/ge/extensions/soturineChaosRandomizer/vehicleDNACompatibility.lua",
    "lua/ge/extensions/soturineChaosRandomizer/vehicleDNAFingerprint.lua",
    "lua/ge/extensions/soturineChaosRandomizer/vehicleDNAImport.lua",
    "lua/ge/extensions/soturineChaosRandomizer/vehicleDNANormalizer.lua",
    "lua/ge/extensions/soturineChaosRandomizer/vehicleDNARestore.lua",
    "lua/ge/extensions/soturineChaosRandomizer/vehicleDNASchema.lua",
    "lua/ge/extensions/soturineChaosRandomizer/vehicleDNAStorage.lua",
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
FIXED_TIMESTAMP = (2026, 1, 1, 0, 0, 0)
EXPECTED_FILE_MODE = 0o100644
ICON_PATH = "ui/modules/apps/soturineChaosRandomizer/app.png"
MAX_ICON_WIDTH = 500
MAX_ICON_HEIGHT = 240
MAX_ICON_BYTES = 100_000


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
        if names != sorted(names):
            raise PackageValidationError("ZIP entries are not in stable path order")
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
            if info.date_time != FIXED_TIMESTAMP:
                raise PackageValidationError(f"Non-normalized timestamp in {info.filename}")
            if info.create_system != 3 or mode != EXPECTED_FILE_MODE:
                raise PackageValidationError(f"Non-normalized permissions in {info.filename}")
            path = PurePosixPath(info.filename)
            if path.suffix.lower() in TEXT_SUFFIXES or info.filename in TEXT_FILENAMES:
                data = archive.read(info)
                if b"\r\n" in data or b"\r" in data:
                    raise PackageValidationError(f"Non-normalized text line endings in {info.filename}")

        machine_path = re.compile(rb"(?:[A-Za-z]:\\|/" + rb"Users/|/" + rb"home/)")
        for info in infos:
            if info.filename.lower().endswith(".png"):
                continue
            if machine_path.search(archive.read(info)):
                raise PackageValidationError(f"Machine path found in {info.filename}")

        packaged_version = archive.read("VERSION").decode("utf-8").strip()
        if packaged_version != expected_version:
            raise PackageValidationError(
                f"Packaged VERSION is {packaged_version!r}, expected {expected_version!r}"
            )

    return names


def png_dimensions(data: bytes) -> tuple[int, int]:
    if len(data) < 24 or data[:8] != b"\x89PNG\r\n\x1a\n" or data[12:16] != b"IHDR":
        raise PackageValidationError("App icon is not a valid PNG")
    return struct.unpack(">II", data[16:24])


def validate_icon(path: Path) -> tuple[int, int, int]:
    data = path.read_bytes()
    width, height = png_dimensions(data)
    if width > MAX_ICON_WIDTH or height > MAX_ICON_HEIGHT:
        raise PackageValidationError(f"App icon dimensions exceed {MAX_ICON_WIDTH}x{MAX_ICON_HEIGHT}")
    if len(data) > MAX_ICON_BYTES:
        raise PackageValidationError(f"App icon exceeds {MAX_ICON_BYTES} bytes")
    expected_ratio = 1810 / 869
    if abs((width / height) - expected_ratio) > 0.01:
        raise PackageValidationError("App icon aspect ratio changed unexpectedly")
    return width, height, len(data)


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


def validate_release_manifest(archive_path: Path) -> dict[str, object]:
    manifest_path = archive_path.parent / "release-manifest.json"
    if not manifest_path.is_file():
        raise PackageValidationError(f"Release manifest does not exist: {manifest_path}")
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    expected_digest = hashlib.sha256(archive_path.read_bytes()).hexdigest()
    with zipfile.ZipFile(archive_path) as archive:
        expected_entries = len(archive.infolist())
    expected = {
        "version": read_version(),
        "tag": f"v{read_version()}",
        "filename": archive_path.name,
        "bytes": archive_path.stat().st_size,
        "entries": expected_entries,
        "sha256": expected_digest,
    }
    for key, value in expected.items():
        if manifest.get(key) != value:
            raise PackageValidationError(f"Release manifest {key} does not match the ZIP")
    return manifest


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("archive", type=Path, nargs="?", help="ZIP to validate")
    parser.add_argument("--no-reproducibility-check", action="store_true")
    args = parser.parse_args()

    version = read_version()
    archive = args.archive or REPOSITORY_ROOT / "dist" / f"{ARCHIVE_PREFIX}{version}.zip"
    names = validate_archive(archive, version)
    icon = validate_icon(REPOSITORY_ROOT / ICON_PATH)
    validate_checksum(archive)
    manifest = validate_release_manifest(archive)
    if not args.no_reproducibility_check:
        validate_reproducible(archive)

    print(f"Validated {archive}")
    print(f"Icon: {icon[0]}x{icon[1]}, {icon[2]} bytes")
    print(f"Entries ({len(names)}):")
    for name in names:
        print(f"  {name}")
    print(f"Manifest commit: {manifest['commit']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
