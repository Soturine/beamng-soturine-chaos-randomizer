from __future__ import annotations

import shutil
import subprocess
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class UiJavaScriptTests(unittest.TestCase):
    def test_ui_math_contracts(self) -> None:
        node = shutil.which("node")
        if not node:
            self.skipTest("Node.js is unavailable")
        result = subprocess.run(
            [node, str(ROOT / "tests/js/ui_math.test.js")],
            cwd=ROOT,
            text=True,
            capture_output=True,
            check=False,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("SCR_UI_JS_TESTS_PASSED 27", result.stdout)


if __name__ == "__main__":
    unittest.main()
