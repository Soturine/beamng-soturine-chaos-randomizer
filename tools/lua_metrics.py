"""Run the Lua suite and parse its self-reported, de-duplicated metrics."""

from __future__ import annotations

import json
from functools import lru_cache
import os
from pathlib import Path
import re
import shutil
import subprocess
import uuid


METRICS_PATTERN = re.compile(
    r"^SCR_TEST_METRICS functions=(\d+) mappings=(\d+) cases=(\d+) assertions=(\d+)\s*$",
    re.MULTILINE,
)
SUCCESS_PATTERN = re.compile(r"^SCR_TESTS_OK (\d+)\s*$", re.MULTILINE)


def find_beamng_console() -> Path | None:
    configured = os.environ.get("BEAMNG_CONSOLE")
    candidates = [
        Path(configured) if configured else None,
        Path(r"D:\SteamLibrary\steamapps\common\BeamNG.drive\Bin64\console.x64.exe"),
        Path(r"C:\Program Files (x86)\Steam\steamapps\common\BeamNG.drive\Bin64\console.x64.exe"),
    ]
    return next((path for path in candidates if path and path.is_file()), None)


@lru_cache(maxsize=4)
def run_lua_suite(root: Path) -> tuple[str, dict[str, int]]:
    runner = root / "tests" / "lua" / "run.lua"
    lua_command = os.environ.get("LUA") or next(
        (command for command in ("lua5.1", "lua", "luajit") if shutil.which(command)),
        None,
    )
    if lua_command:
        result = subprocess.run(
            [lua_command, str(runner)], cwd=root, text=True, capture_output=True, check=False,
        )
    else:
        console = find_beamng_console()
        if not console:
            raise RuntimeError("No Lua 5.1-compatible interpreter found; set LUA or BEAMNG_CONSOLE")
        game_root = console.parent.parent
        stage = game_root / f"scr_metrics_{os.getpid()}_{uuid.uuid4().hex[:8]}"
        if stage.parent.resolve() != game_root.resolve():
            raise RuntimeError("Lua test staging path escaped the BeamNG root")
        try:
            shutil.copytree(root / "lua", stage / "lua")
            shutil.copytree(root / "tests" / "lua", stage / "tests" / "lua")
            bootstrap = stage / "run_tests.lua"
            virtual_root = "/" + stage.name
            bootstrap.write_text(
                "SCR_TEST_ROOT = " + json.dumps(virtual_root) + "\n"
                + "dofile(" + json.dumps(virtual_root + "/tests/lua/run.lua") + ")\n",
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
        finally:
            if stage.exists():
                if stage.parent.resolve() != game_root.resolve():
                    raise RuntimeError("Refusing to remove an unsafe Lua test staging path")
                shutil.rmtree(stage)

    output = result.stdout + result.stderr
    success = SUCCESS_PATTERN.search(output)
    metrics_match = METRICS_PATTERN.search(output)
    if not success or not metrics_match:
        raise RuntimeError("Lua suite did not complete successfully:\n" + output)
    metrics = {
        "luaTestFunctionsUnique": int(metrics_match.group(1)),
        "luaRequirementMappings": int(metrics_match.group(2)),
        "luaExecutedCases": int(metrics_match.group(3)),
        "luaAssertions": int(metrics_match.group(4)),
    }
    if int(success.group(1)) != metrics["luaExecutedCases"]:
        raise RuntimeError("Lua success count does not match the runner metrics")
    return output, metrics
