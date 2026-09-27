#!/usr/bin/env python3
"""Single validation entry point: every essential check runs exactly once.

    npm run verify           static checks, UI, Lua and Python tests, package
    npm run verify:release   the above plus release-evidence checks for a tag

Order: cheap static checks first, then behavior tests, then the package that
is actually published (built once, validated once, rebuilt once to prove
reproducibility).
"""

from __future__ import annotations

import argparse
from pathlib import Path
import shutil
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[1]
APP = "ui/modules/apps/soturineChaosRandomizer"


def steps(release: bool) -> list[tuple[str, list[str]]]:
    node = shutil.which("node") or "node"
    python = sys.executable
    result = [
        ("version metadata", [python, "tools/sync_version.py"]),
        ("Vue SFC compile", [node, "tools/validate_vue_sfc.mjs", APP, "."]),
        ("UI command parity", [python, "tools/validate_ui_command_parity.py"]),
        ("Vue module graph", [node, "tools/validate_vue_module_graph.mjs"]),
        ("Vue style graph", [node, "tools/validate_vue_style_graph.mjs"]),
        ("UI runtime contracts", [node, "tests/js/vue_runtime.test.mjs"]),
        ("UI mounted contracts", [node, "node_modules/vitest/vitest.mjs", "run", "--config", "vitest.config.mjs"]),
    ]
    luac = shutil.which("luac5.1")
    if luac:
        lua_files = sorted(str(path) for path in (ROOT / "lua").rglob("*.lua"))
        result.append(("Lua 5.1 syntax", [luac, "-p", *lua_files]))
    result += [
        ("Python and Lua tests", [python, "-m", "unittest", "discover", "-s", "tests"]),
        ("package build", [python, "tools/package_mod.py"]),
        ("package validation", [python, "tools/validate_package.py"]),
    ]
    if release:
        result.append(("release evidence", [python, "tools/validate_release_gate.py", "--channel", "prerelease"]))
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--release", action="store_true", help="also validate release evidence")
    args = parser.parse_args()
    started = time.monotonic()
    for name, command in steps(args.release):
        step_started = time.monotonic()
        result = subprocess.run(command, cwd=ROOT, text=True, capture_output=True)
        elapsed = time.monotonic() - step_started
        if result.returncode != 0:
            print(f"FAIL {name} ({elapsed:.1f}s)")
            print(result.stdout[-8000:])
            print(result.stderr[-8000:], file=sys.stderr)
            return 1
        print(f"ok   {name} ({elapsed:.1f}s)")
    print(f"VERIFY_OK in {time.monotonic() - started:.1f}s")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
