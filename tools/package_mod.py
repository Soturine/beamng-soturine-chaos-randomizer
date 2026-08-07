#!/usr/bin/env python3
"""Build a deterministic BeamNG mod archive from the repository sources."""

from __future__ import annotations

import argparse
import json
import hashlib
import os
from pathlib import Path
import subprocess
import zipfile
import re
import shutil

try:
    from tools.lua_metrics import run_lua_suite
except ModuleNotFoundError:  # Direct execution: python tools/package_mod.py
    from lua_metrics import run_lua_suite


REPOSITORY_ROOT = Path(__file__).resolve().parents[1]
CONTENT_ROOTS = ("lua", "ui", "settings", "locales")
OPTIONAL_CONTENT_ROOTS = ("mod_info",)
PACKAGE_FILES = ("COMPATIBILITY.json", "LICENSE", "NOTICE", "VERSION")
ARCHIVE_PREFIX = "soturine_chaos_randomizer_"
FIXED_TIMESTAMP = (2026, 1, 1, 0, 0, 0)
TEXT_SUFFIXES = {".css", ".html", ".js", ".json", ".lua", ".md", ".mjs", ".scss", ".svg", ".txt", ".vue", ".xml"}
TEXT_FILENAMES = {"LICENSE", "NOTICE", "VERSION"}
GENERATOR_VERSION = 8
DNA_SCHEMA_VERSION = 1
DNA_GENERATOR_VERSION = 6
LIVE_RESULTS = ("Executed", "Passed", "Failed", "Pending", "Blocked", "Not applicable")


def get_commit_sha(root: Path = REPOSITORY_ROOT) -> str:
    result = subprocess.run(
        ["git", "rev-parse", "HEAD"],
        cwd=root,
        text=True,
        capture_output=True,
        check=False,
    )
    return result.stdout.strip() if result.returncode == 0 else "unknown"


def get_branch_name(root: Path = REPOSITORY_ROOT) -> str:
    result = subprocess.run(
        ["git", "branch", "--show-current"],
        cwd=root,
        text=True,
        capture_output=True,
        check=False,
    )
    branch = result.stdout.strip() if result.returncode == 0 else ""
    if branch:
        return branch
    # Actions checks out annotated release tags in detached-HEAD mode. This
    # project publishes only from main, and the workflow verifies tag/version
    # identity before building the manifest.
    return os.environ.get("SCR_RELEASE_BRANCH", "main")


def get_commit_timestamp(root: Path = REPOSITORY_ROOT) -> str:
    result = subprocess.run(
        ["git", "show", "-s", "--format=%cI", "HEAD"],
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


def read_compatibility(root: Path = REPOSITORY_ROOT) -> dict[str, object]:
    value = json.loads((root / "COMPATIBILITY.json").read_text(encoding="utf-8"))
    required = ("modVersion", "primaryBeamNGTarget", "minimumBeamNGVersion", "liveValidationStatus")
    if not isinstance(value, dict) or any(not isinstance(value.get(key), str) for key in required):
        raise ValueError("COMPATIBILITY.json is missing required string fields")
    if value["modVersion"] != read_version(root):
        raise ValueError("COMPATIBILITY.json modVersion must match VERSION")
    return value


def release_identity(version: str) -> dict[str, object]:
    if not re.fullmatch(r"\d+\.\d+\.\d+", version):
        raise ValueError("Final release VERSION must use MAJOR.MINOR.PATCH")
    return {
        "releaseStage": "experimental-prerelease",
        "tag": f"v{version}",
        "publicationAllowed": True,
        "releaseStatus": "published",
        "prerelease": True,
        "documentationVersion": version,
    }


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
    checksum = archive.with_name(f"{archive.name}.sha256")
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


def live_test_counts(root: Path = REPOSITORY_ROOT) -> dict[str, int]:
    version = read_version(root)
    documentation_version = str(release_identity(version)["documentationVersion"])
    candidates = (
        root / "docs" / "testing" / f"v{documentation_version}" / "LIVE_RESULTS.md",
        root / "docs" / "testing" / f"v{documentation_version}" / "LIVE_TEST_REPORT.md",
        root / "docs" / f"INTERACTIVE_TEST_REPORT_{version}.md",
        root / "docs" / f"INTERACTIVE_TEST_PLAN_{version}.md",
    )
    source = next((path.read_text(encoding="utf-8") for path in candidates if path.is_file()), "")
    counts = {status: 0 for status in LIVE_RESULTS}
    for status in LIVE_RESULTS:
        total = re.search(rf"\|\s*{re.escape(status)}\s*\|\s*(\d+)\s*\|", source)
        counts[status] = int(total.group(1)) if total else 0
    if counts["Executed"] == 0:
        counts["Executed"] = counts["Passed"] + counts["Failed"] + counts["Blocked"]
    return counts


def test_counts(root: Path = REPOSITORY_ROOT) -> dict[str, int]:
    python_methods = 0
    for path in (root / "tests").glob("test_*.py"):
        python_methods += len(re.findall(r"^\s+def test_[A-Za-z0-9_]+\(", path.read_text(encoding="utf-8"), re.MULTILINE))
    _, lua_metrics = run_lua_suite(root.resolve())
    interactive = live_test_counts(root)
    node = shutil.which("node")
    if not node:
        raise RuntimeError("Node.js is required for native Vue release validation")
    javascript = subprocess.run(
        [node, str(root / "tests" / "js" / "vue_runtime.test.mjs")],
        cwd=root, text=True, capture_output=True, check=False,
    )
    if javascript.returncode != 0:
        raise RuntimeError("JavaScript/Vue checks failed:\n" + javascript.stdout + javascript.stderr)
    javascript_total = re.search(r"SCR_UI_JS_TESTS_PASSED\s+(\d+)", javascript.stdout)
    if not javascript_total:
        raise RuntimeError("JavaScript/Vue checks did not report an assertion count")
    graph = subprocess.run(
        [node, str(root / "tools" / "validate_vue_module_graph.mjs"), "--json"],
        cwd=root, text=True, capture_output=True, check=False,
    )
    if graph.returncode != 0:
        raise RuntimeError("Static Runtime UI module graph validation failed:\n" + graph.stdout + graph.stderr)
    try:
        graph_report = json.loads(graph.stdout)
    except json.JSONDecodeError as error:
        raise RuntimeError("Module graph validator did not return JSON") from error
    result = {
        "pythonTestMethodsUnique": python_methods,
        **lua_metrics,
        "nodeSyntaxFiles": len(list((root / "ui").rglob("*.js"))) + len(list((root / "tests" / "js").glob("*.mjs"))),
        "vueSFCFiles": len(list((root / "ui").rglob("*.vue"))),
        "javaScriptChecks": int(javascript_total.group(1)),
        "vueModuleGraphFiles": int(graph_report["filesScanned"]),
        "vueModuleGraphReachableFiles": int(graph_report["reachableFiles"]),
        "vueModuleGraphImports": int(graph_report["importsScanned"]),
        "vueModuleGraphProjectImports": int(graph_report["projectImports"]),
        "vueModuleGraphRuntimeAliases": int(graph_report["runtimeAliases"]),
        "vueModuleGraphDirectoryImports": int(graph_report["directoryImports"]),
        "vueModuleGraphMissingModules": int(graph_report["missingModules"]),
        "vueModuleGraphCaseMismatches": int(graph_report["caseMismatches"]),
        "vueModuleGraphCycles": int(graph_report["cycles"]),
        "vueModuleGraphNamedExportErrors": int(graph_report["namedExportErrors"]),
        "jsonFiles": len([
            path for path in root.rglob("*.json")
            if not any(part in {".git", "dist", "__pycache__"} for part in path.relative_to(root).parts)
        ]),
        "yamlFiles": len(list((root / ".github" / "workflows").glob("*.yml"))),
        "packageTestMethods": len(re.findall(
            r"^\s+def test_[A-Za-z0-9_]+\(",
            (root / "tests" / "test_package.py").read_text(encoding="utf-8"),
            re.MULTILINE,
        )),
        "interactiveExecuted": interactive["Executed"],
        "interactivePassed": interactive["Passed"],
        "interactiveFailed": interactive["Failed"],
        "interactivePending": interactive["Pending"],
        "interactiveBlocked": interactive["Blocked"],
        "interactiveNotApplicable": interactive["Not applicable"],
    }
    return result


def write_release_manifest(archive: Path, output: Path | None = None, root: Path = REPOSITORY_ROOT) -> Path:
    report = build_report(archive, root)
    identity = release_identity(str(report["version"]))
    tests = test_counts(root)
    compatibility = read_compatibility(root)
    automated_tests = {
        "status": "passed",
        "pythonTestMethods": tests["pythonTestMethodsUnique"],
        "luaExecutedCases": tests["luaExecutedCases"],
        "luaRequirementMappings": tests["luaRequirementMappings"],
        "javaScriptChecks": tests["javaScriptChecks"],
        "vueSFCFiles": tests["vueSFCFiles"],
        "vueModuleGraphFiles": tests["vueModuleGraphFiles"],
        "vueModuleGraphImports": tests["vueModuleGraphImports"],
        "vueModuleGraphProjectImports": tests["vueModuleGraphProjectImports"],
    }
    live_tests = {
        "status": "Pending owner validation",
        "executed": tests["interactiveExecuted"],
        "passed": tests["interactivePassed"],
        "failed": tests["interactiveFailed"],
        "pending": tests["interactivePending"],
        "blocked": tests["interactiveBlocked"],
    }
    manifest = {
        "manifestVersion": 3,
        "modVersion": report["version"],
        "version": report["version"],
        "tag": identity["tag"],
        "releaseStage": identity["releaseStage"],
        "publicationAllowed": identity["publicationAllowed"],
        "releaseStatus": identity["releaseStatus"],
        "prerelease": identity["prerelease"],
        "commit": report["commit"],
        "branch": get_branch_name(root),
        "buildTimestamp": get_commit_timestamp(root),
        "filename": report["filename"],
        "bytes": report["bytes"],
        "entries": report["entries"],
        "sha256": report["sha256"],
        "primaryBeamNGTarget": compatibility["primaryBeamNGTarget"],
        "minimumBeamNGVersion": compatibility["minimumBeamNGVersion"],
        "compatibilitySchemaVersion": compatibility.get("schemaVersion"),
        "uiRuntime": compatibility.get("uiRuntime"),
        "detectedOrDeclaredCompatibility": {
            "source": "COMPATIBILITY.json",
            "testedGameVersions": compatibility.get("testedGameVersions", []),
            "liveValidationStatus": compatibility["liveValidationStatus"],
        },
        "targetBeamNG": compatibility["primaryBeamNGTarget"],
        "fileCount": report["entries"],
        "zipSize": report["bytes"],
        "zipSha256": report["sha256"],
        "generatorVersion": GENERATOR_VERSION,
        "vehicleDNASchemaVersion": DNA_SCHEMA_VERSION,
        "vehicleDNAGeneratorVersion": DNA_GENERATOR_VERSION,
        "tests": tests,
        "automatedTests": automated_tests,
        "liveTests": live_tests,
        "automatedValidation": automated_tests,
        "liveValidation": {
            "status": "pending_owner_validation",
            "executed": tests["interactiveExecuted"],
            "passed": tests["interactivePassed"],
            "failed": tests["interactiveFailed"],
            "pending": tests["interactivePending"],
            "blocked": tests["interactiveBlocked"],
        },
    }
    output = output or archive.with_name(f"{archive.stem}.manifest.json")
    output.write_text(json.dumps(manifest, indent=2, sort_keys=True) + "\n", encoding="utf-8", newline="\n")
    return output


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
    manifest = write_release_manifest(archive)
    print(f"Version: {report['version']}")
    print(f"Commit: {report['commit']}")
    print(f"Filename: {report['filename']}")
    print(f"Entries: {report['entries']}")
    print(f"Bytes: {report['bytes']}")
    print(f"SHA-256: {report['sha256']}")
    print(f"Checksum: {checksum.name}")
    print(f"Manifest: {manifest.name}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
