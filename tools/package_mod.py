#!/usr/bin/env python3
"""Build a deterministic BeamNG mod archive from the repository sources."""

from __future__ import annotations

import argparse
import hashlib
import os
from pathlib import Path
import subprocess
import zipfile


REPOSITORY_ROOT = Path(__file__).resolve().parents[1]
CONTENT_ROOTS = ("lua", "ui", "settings")
OPTIONAL_CONTENT_ROOTS = ("mod_info",)
PACKAGE_FILES = ("LICENSE", "NOTICE", "VERSION")
ARCHIVE_PREFIX = "soturine_chaos_randomizer_"
FIXED_TIMESTAMP = (2026, 1, 1, 0, 0, 0)
TEXT_SUFFIXES = {".css", ".html", ".js", ".json", ".lua", ".md", ".txt", ".xml"}
TEXT_FILENAMES = {"LICENSE", "NOTICE", "VERSION"}


def get_commit_sha(root: Path = REPOSITORY_ROOT) -> str:
    result = subprocess.run(
        ["git", "rev-parse", "HEAD"],
        cwd=root,
        text=True,
        capture_output=True,
        check=False,
    )
    return result.stdout.strip() if result.returncode == 0 else "unknown"


def read_version(root: Path = REPOSITORY_ROOT) -> str:
    version = (root / "VERSION").read_text(encoding="utf-8").strip()
    if not version or any(character in version for character in "\\/\0"):
        raise ValueError("VERSION must contain one safe, non-empty version string")
    return version


def collect_files(root: Path = REPOSITORY_ROOT) -> list[tuple[Path, str]]:
    entries: list[tuple[Path, str]] = []
    for directory in CONTENT_ROOTS + OPTIONAL_CONTENT_ROOTS:
        source = root / directory
        if not source.exists():
            if directory in CONTENT_ROOTS:
                raise FileNotFoundError(f"Required package directory is missing: {directory}")
            continue
        for path in source.rglob("*"):
            if path.is_file():
                entries.append((path, path.relative_to(root).as_posix()))

    for filename in PACKAGE_FILES:
        path = root / filename
        if not path.is_file():
            raise FileNotFoundError(f"Required package file is missing: {filename}")
        entries.append((path, filename))

    entries.sort(key=lambda entry: entry[1])
    names = [name for _, name in entries]
    if len(names) != len(set(names)):
        raise ValueError("Duplicate package paths were collected")
    return entries


def packaged_bytes(source: Path, name: str) -> bytes:
    data = source.read_bytes()
    if source.suffix.lower() in TEXT_SUFFIXES or name in TEXT_FILENAMES:
        return data.replace(b"\r\n", b"\n").replace(b"\r", b"\n")
    return data


def build_archive(output: Path, root: Path = REPOSITORY_ROOT) -> Path:
    output.parent.mkdir(parents=True, exist_ok=True)
    entries = collect_files(root)
    with zipfile.ZipFile(output, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
        for source, name in entries:
            info = zipfile.ZipInfo(name, date_time=FIXED_TIMESTAMP)
            info.compress_type = zipfile.ZIP_DEFLATED
            info.create_system = 3
            info.external_attr = 0o100644 << 16
            archive.writestr(info, packaged_bytes(source, name), compress_type=zipfile.ZIP_DEFLATED, compresslevel=9)
    return output


def write_checksum(archive: Path) -> Path:
    digest = hashlib.sha256(archive.read_bytes()).hexdigest()
    checksum = archive.with_suffix(".sha256")
    checksum.write_text(f"{digest}  {archive.name}\n", encoding="ascii", newline="\n")
    return checksum


def package(output_dir: Path, root: Path = REPOSITORY_ROOT) -> tuple[Path, Path]:
    version = read_version(root)
    archive = output_dir / f"{ARCHIVE_PREFIX}{version}.zip"
    build_archive(archive, root)
    checksum = write_checksum(archive)
    return archive, checksum


def build_report(archive: Path, root: Path = REPOSITORY_ROOT) -> dict[str, object]:
    digest = hashlib.sha256(archive.read_bytes()).hexdigest()
    with zipfile.ZipFile(archive, "r") as value:
        entries = len(value.infolist())
    return {
        "version": read_version(root),
        "commit": get_commit_sha(root),
        "filename": archive.name,
        "entries": entries,
        "bytes": archive.stat().st_size,
        "sha256": digest,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=Path(os.environ.get("SCR_OUTPUT_DIR", REPOSITORY_ROOT / "dist")),
        help="Artifact directory (default: dist)",
    )
    args = parser.parse_args()
    archive, checksum = package(args.output_dir)
    report = build_report(archive)
    print(f"Version: {report['version']}")
    print(f"Commit: {report['commit']}")
    print(f"Filename: {report['filename']}")
    print(f"Entries: {report['entries']}")
    print(f"Bytes: {report['bytes']}")
    print(f"SHA-256: {report['sha256']}")
    print(f"Checksum: {checksum.name}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
