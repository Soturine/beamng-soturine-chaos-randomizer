from __future__ import annotations

import os
from pathlib import Path
import shutil
import subprocess
import unittest
import uuid


ROOT = Path(__file__).resolve().parents[1]
RUNNER = ROOT / "tests" / "lua" / "run.lua"


def find_beamng_console() -> Path | None:
    configured = os.environ.get("BEAMNG_CONSOLE")
    candidates = [
        Path(configured) if configured else None,
        Path(r"D:\SteamLibrary\steamapps\common\BeamNG.drive\Bin64\console.x64.exe"),
        Path(r"C:\Program Files (x86)\Steam\steamapps\common\BeamNG.drive\Bin64\console.x64.exe"),
    ]
    return next((path for path in candidates if path and path.is_file()), None)


class LuaLogicTests(unittest.TestCase):
    def test_actual_lua_modules(self) -> None:
        lua_command = os.environ.get("LUA") or next(
            (command for command in ("lua5.1", "lua", "luajit") if shutil.which(command)),
            None,
        )
        if lua_command:
            result = subprocess.run(
                [lua_command, str(RUNNER)],
                cwd=ROOT,
                text=True,
                capture_output=True,
                check=False,
            )
        else:
            console = find_beamng_console()
            if not console:
                self.fail("No Lua 5.1-compatible interpreter found; set LUA or BEAMNG_CONSOLE")
            game_root = console.parent.parent
            stage = game_root / f"scr_test_{os.getpid()}_{uuid.uuid4().hex[:8]}"
            self.assertEqual(stage.parent.resolve(), game_root.resolve())
            try:
                shutil.copytree(ROOT / "lua", stage / "lua")
                shutil.copytree(ROOT / "tests" / "lua", stage / "tests" / "lua")
                environment = os.environ.copy()
                environment["SCR_TEST_VFS_ROOT"] = "/" + stage.name
                result = subprocess.run(
                    [str(console), "file", str(stage / "tests" / "lua" / "run.lua")],
                    cwd=game_root,
                    env=environment,
                    text=True,
                    capture_output=True,
                    check=False,
                )
            finally:
                if stage.exists():
                    self.assertEqual(stage.parent.resolve(), game_root.resolve())
                    shutil.rmtree(stage)

        output = result.stdout + result.stderr
        self.assertIn("SCR_TESTS_OK", output, msg=output)


if __name__ == "__main__":
    unittest.main()
