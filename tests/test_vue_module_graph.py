from __future__ import annotations

import json
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest
import zipfile

from tools import package_mod, validate_package


ROOT = Path(__file__).resolve().parents[1]
APP = ROOT / "ui/modules/apps/soturineChaosRandomizer"
VALIDATOR = ROOT / "tools/validate_vue_module_graph.mjs"


class VueModuleGraphTests(unittest.TestCase):
    def run_graph(self, app: Path, *, mode: str = "source") -> subprocess.CompletedProcess[str]:
        return subprocess.run(
            ["node", str(VALIDATOR), str(app), f"--mode={mode}", "--json"],
            cwd=ROOT,
            text=True,
            capture_output=True,
            check=False,
        )

    def copy_app(self, destination: Path) -> Path:
        app = destination / "soturineChaosRandomizer"
        shutil.copytree(APP, app)
        return app

    def test_static_runtime_ui_module_graph_validation(self) -> None:
        result = self.run_graph(APP)
        self.assertEqual(result.returncode, 0, result.stderr or result.stdout)
        report = json.loads(result.stdout)
        self.assertGreater(report["filesScanned"], 0)
        self.assertGreater(report["importsScanned"], 0)
        self.assertEqual(
            report["projectVueImports"] + report["projectJavaScriptImports"]
            + report["projectJsonImports"] + report["projectCssImports"]
            + report["projectScssImports"],
            report["projectImports"],
        )
        self.assertEqual(report["projectCssImports"], 1)
        self.assertEqual(report["projectScssImports"], 0)
        self.assertEqual(report["directoryImports"], 0)
        self.assertEqual(report["missingModules"], 0)
        self.assertEqual(report["caseMismatches"], 0)
        self.assertEqual(report["cycles"], 0)
        self.assertEqual(report["namedExportErrors"], 0)

    def test_directory_import_is_rejected_even_when_index_exists(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            app = self.copy_app(Path(temporary))
            entry = app / "app.vue"
            entry.write_text(
                entry.read_text(encoding="utf-8").replace('"./stores/index.js"', '"./stores"'),
                encoding="utf-8",
            )
            result = self.run_graph(app)
            self.assertNotEqual(result.returncode, 0)
            report = json.loads(result.stdout)
            self.assertEqual(report["directoryImports"], 1)
            self.assertIn("directory_import", {item["reason"] for item in report["issues"]})

    def test_case_mismatch_is_rejected_on_windows_and_linux(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            app = self.copy_app(Path(temporary))
            entry = app / "app.vue"
            entry.write_text(
                entry.read_text(encoding="utf-8").replace("stores/index.js", "stores/Index.js"),
                encoding="utf-8",
            )
            result = self.run_graph(app)
            self.assertNotEqual(result.returncode, 0)
            report = json.loads(result.stdout)
            self.assertEqual(report["caseMismatches"], 1)
            self.assertIn("case_mismatch", {item["reason"] for item in report["issues"]})

    def test_missing_module_and_named_export_are_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            app = self.copy_app(Path(temporary))
            entry = app / "app.vue"
            source = entry.read_text(encoding="utf-8")
            entry.write_text(
                source.replace(
                    'import { createStores, STORES_KEY } from "./stores/index.js"',
                    'import { createStores, MISSING_EXPORT } from "./stores/index.js"\n'
                    'import MissingModule from "./services/missing.js"',
                ),
                encoding="utf-8",
            )
            result = self.run_graph(app)
            self.assertNotEqual(result.returncode, 0)
            report = json.loads(result.stdout)
            reasons = {item["reason"] for item in report["issues"]}
            self.assertIn("missing_module", reasons)
            self.assertIn("missing_named_export", reasons)

    def test_extracted_zip_module_graph_validation(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            archive, _ = package_mod.package(root / "dist", ROOT)
            extracted = root / "extracted"
            with zipfile.ZipFile(archive) as value:
                value.extractall(extracted)
            app = extracted / "ui/modules/apps/soturineChaosRandomizer"
            result = self.run_graph(app, mode="zip")
            self.assertEqual(result.returncode, 0, result.stderr or result.stdout)
            report = json.loads(result.stdout)
            self.assertEqual(report["zipMissingModules"], 0)
            self.assertGreater(report["projectImports"], 0)
            integrated = validate_package.validate_extracted_vue_module_graph(archive)
            self.assertEqual(integrated["importsScanned"], report["importsScanned"])


if __name__ == "__main__":
    unittest.main()
