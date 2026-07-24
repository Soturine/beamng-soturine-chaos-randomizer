from __future__ import annotations

from pathlib import Path
import re
import unittest

from tools.lua_metrics import run_lua_suite


ROOT = Path(__file__).resolve().parents[1]
class LuaLogicTests(unittest.TestCase):
    def test_actual_lua_modules(self) -> None:
        output, metrics = run_lua_suite(ROOT)
        self.assertRegex(output, re.compile(r"^SCR_TESTS_OK \d+\s*$", re.MULTILINE), msg=output)
        self.assertEqual(metrics["luaTestFunctionsUnique"], metrics["luaExecutedCases"])
        self.assertGreaterEqual(metrics["luaRequirementMappings"], 217)
        self.assertGreater(metrics["luaAssertions"], metrics["luaExecutedCases"])


if __name__ == "__main__":
    unittest.main()
