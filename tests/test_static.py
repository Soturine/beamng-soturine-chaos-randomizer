from __future__ import annotations

import json
from pathlib import Path
import re
import shutil
import subprocess
import unittest


ROOT = Path(__file__).resolve().parents[1]
PACKAGE_ROOTS = (ROOT / "lua", ROOT / "ui", ROOT / "settings")


class StaticValidationTests(unittest.TestCase):
    def test_json_files_parse(self) -> None:
        files = sorted(ROOT.rglob("*.json"))
        self.assertTrue(files)
        for path in files:
            with self.subTest(path=path.relative_to(ROOT)):
                json.loads(path.read_text(encoding="utf-8"))

    def test_javascript_syntax(self) -> None:
        node = shutil.which("node")
        if not node:
            self.skipTest("Node.js is not installed")
        for path in sorted((ROOT / "ui").rglob("*.js")):
            with self.subTest(path=path.relative_to(ROOT)):
                result = subprocess.run([node, "--check", str(path)], text=True, capture_output=True)
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_no_trailing_whitespace(self) -> None:
        extensions = {".css", ".html", ".js", ".json", ".lua", ".md", ".py", ".txt", ""}
        ignored = {".git", "dist", "__pycache__"}
        for path in sorted(ROOT.rglob("*")):
            if not path.is_file() or path.suffix.lower() not in extensions:
                continue
            if any(part in ignored for part in path.parts):
                continue
            with self.subTest(path=path.relative_to(ROOT)):
                for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
                    self.assertIsNone(re.search(r"[ \t]+$", line), f"trailing whitespace on line {number}")

    def test_internal_markdown_links_resolve(self) -> None:
        link_pattern = re.compile(r"!?\[[^\]]*\]\(([^)]+)\)")
        for document in sorted(ROOT.rglob("*.md")):
            if any(part in {".git", "dist"} for part in document.parts):
                continue
            for target in link_pattern.findall(document.read_text(encoding="utf-8")):
                target = target.strip().split(" ", 1)[0].strip("<>")
                if not target or target.startswith(("#", "http://", "https://", "mailto:")):
                    continue
                relative = target.split("#", 1)[0]
                with self.subTest(document=document.relative_to(ROOT), target=target):
                    self.assertTrue((document.parent / relative).resolve().exists())

    def test_beamng_api_boundary(self) -> None:
        unstable = re.compile(r"\b(?:core_[a-zA-Z_]+|guihooks|jsonReadFile|jsonWriteFile|getPlayerVehicle|\bbe:)")
        allowed = {
            ROOT / "lua" / "ge" / "extensions" / "soturineChaosRandomizer" / "apiAdapter.lua",
            ROOT / "lua" / "ge" / "extensions" / "soturineChaosRandomizer" / "main.lua",
        }
        for path in sorted((ROOT / "lua").rglob("*.lua")):
            if path in allowed:
                continue
            with self.subTest(path=path.relative_to(ROOT)):
                self.assertIsNone(unstable.search(path.read_text(encoding="utf-8")))

    def test_package_content_has_no_machine_paths(self) -> None:
        pattern = re.compile(r"(?:[A-Za-z]:\\|/Users/|/home/)")
        for root in PACKAGE_ROOTS:
            for path in sorted(root.rglob("*")):
                if path.is_file() and path.suffix.lower() != ".png":
                    with self.subTest(path=path.relative_to(ROOT)):
                        self.assertIsNone(pattern.search(path.read_text(encoding="utf-8")))

    def test_version_is_consistent(self) -> None:
        version = (ROOT / "VERSION").read_text(encoding="utf-8").strip()
        app = json.loads((ROOT / "ui/modules/apps/soturineChaosRandomizer/app.json").read_text(encoding="utf-8"))
        main = (ROOT / "lua/ge/extensions/soturineChaosRandomizer/main.lua").read_text(encoding="utf-8")
        self.assertEqual(app["version"], version)
        self.assertIn(f'EXTENSION_VERSION = "{version}"', main)

    def test_ui_identity_is_unique(self) -> None:
        manifests = [json.loads(path.read_text(encoding="utf-8")) for path in (ROOT / "ui").rglob("app.json")]
        directives = [manifest["directive"] for manifest in manifests]
        self.assertEqual(len(directives), len(set(directives)))
        self.assertIn("soturineChaosRandomizer", directives)


if __name__ == "__main__":
    unittest.main()
