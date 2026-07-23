#!/usr/bin/env python3
"""Run non-gating synthetic Lua performance fixtures in BeamNG's shipped console."""

from __future__ import annotations

import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import uuid


ROOT = Path(__file__).resolve().parents[1]
PROFILE = ROOT / "tests" / "lua" / "profile.lua"


def find_console() -> Path:
    configured = os.environ.get("BEAMNG_CONSOLE")
    candidates = [
        Path(configured) if configured else None,
        Path(r"D:\SteamLibrary\steamapps\common\BeamNG.drive\Bin64\console.x64.exe"),
        Path(r"C:\Program Files (x86)\Steam\steamapps\common\BeamNG.drive\Bin64\console.x64.exe"),
    ]
    console = next((path for path in candidates if path and path.is_file()), None)
    if not console:
        raise FileNotFoundError("BeamNG console not found; set BEAMNG_CONSOLE")
    return console


def run_profile() -> str:
    console = find_console()
    game_root = console.parent.parent
    stage = game_root / f"scr_profile_{os.getpid()}_{uuid.uuid4().hex[:8]}"
    if stage.parent.resolve() != game_root.resolve():
        raise RuntimeError("Profile staging path escaped the BeamNG root")
    try:
        shutil.copytree(ROOT / "lua", stage / "lua")
        shutil.copytree(ROOT / "tests" / "lua", stage / "tests" / "lua")
        bootstrap = stage / "profile_bootstrap.lua"
        virtual_root = "/" + stage.name
        bootstrap.write_text(
            "SCR_TEST_ROOT = " + json.dumps(virtual_root) + "\n"
            + "dofile(" + json.dumps(virtual_root + "/tests/lua/profile.lua") + ")\n",
            encoding="utf-8",
            newline="\n",
        )
        result = subprocess.run(
            [str(console), "file", str(bootstrap)],
            cwd=game_root,
            text=True,
            capture_output=True,
            check=False,
        )
        output = result.stdout + result.stderr
        match = re.search(r"^SCR_PROFILE .+$", output, re.MULTILINE)
        if result.returncode != 0 or not match:
            raise RuntimeError(output)
        return match.group(0)
    finally:
        if stage.exists():
            if stage.parent.resolve() != game_root.resolve():
                raise RuntimeError("Refusing to remove an unexpected profile path")
            shutil.rmtree(stage)


def main() -> int:
    print(run_profile())
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
