from __future__ import annotations

import json
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

from tools import package_mod, validate_package


ROOT = Path(__file__).resolve().parents[1]
APP = ROOT / "ui/modules/apps/soturineChaosRandomizer"
VALIDATOR = ROOT / "tools/validate_vue_style_graph.mjs"


class VueStyleGraphTests(unittest.TestCase):
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

    def assert_reason(self, result: subprocess.CompletedProcess[str], reason: str) -> dict[str, object]:
        self.assertNotEqual(result.returncode, 0)
        report = json.loads(result.stdout)
        self.assertIn(reason, {item["reason"] for item in report["issues"]})
        return report

    def test_source_style_graph_is_pure_complete_and_runtime_reachable(self) -> None:
        result = self.run_graph(APP)
        self.assertEqual(result.returncode, 0, result.stderr or result.stdout)
        report = json.loads(result.stdout)
        self.assertEqual(report["runtimeCssFiles"], 1)
        self.assertEqual(report["cssFilesScanned"], 1)
        self.assertEqual(report["assetReferences"], 1)
        for field in (
            "missingStyles", "missingAssets", "caseMismatches", "remoteReferences",
            "rawScssRuntimePaths", "emptyCssFiles", "sourceMapReferences",
            "criticalRuleFailures", "zipMissingStyles", "zipMissingAssets",
        ):
            self.assertEqual(report[field], 0, field)

    def test_missing_and_case_mismatched_styles_are_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            app = self.copy_app(Path(temporary))
            entry = app / "app.vue"
            original = entry.read_text(encoding="utf-8")
            entry.write_text(original.replace("styles/app.css", "styles/missing.css"), encoding="utf-8")
            report = self.assert_reason(self.run_graph(app), "missing_style")
            self.assertEqual(report["missingStyles"], 2)

            entry.write_text(original.replace("styles/app.css", "styles/App.css"), encoding="utf-8")
            report = self.assert_reason(self.run_graph(app), "case_mismatch")
            self.assertEqual(report["caseMismatches"], 1)

    def test_remote_asset_raw_scss_and_source_maps_are_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            app = self.copy_app(Path(temporary))
            css = app / "styles/app.css"
            css.write_text(css.read_text(encoding="utf-8") + '\n.x { background: url("https://example.invalid/x.png"); }\n/*# sourceMappingURL=app.css.map */\n', encoding="utf-8")
            report = json.loads(self.run_graph(app).stdout)
            reasons = {item["reason"] for item in report["issues"]}
            self.assertIn("remote_reference", reasons)
            self.assertIn("source_map_reference_forbidden", reasons)

            scss = app / "styles/app.scss"
            css.replace(scss)
            entry = app / "app.vue"
            entry.write_text(entry.read_text(encoding="utf-8").replace("styles/app.css", "styles/app.scss"), encoding="utf-8")
            self.assert_reason(self.run_graph(app), "runtime_scss_import_forbidden")

    def test_critical_visual_rule_regression_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            app = self.copy_app(Path(temporary))
            css = app / "styles/app.css"
            css.write_text(
                css.read_text(encoding="utf-8").replace(
                    "overflow: auto; overscroll-behavior: contain;",
                    "overflow: visible; overscroll-behavior: contain;",
                ),
                encoding="utf-8",
            )
            report = self.assert_reason(self.run_graph(app), "critical_rule_missing")
            self.assertGreaterEqual(report["criticalRuleFailures"], 1)

    def test_extracted_zip_style_graph_validation(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            archive, _ = package_mod.package(Path(temporary) / "dist", ROOT)
            report = validate_package.validate_extracted_vue_style_graph(archive)
            self.assertEqual(report["runtimeCssFiles"], 1)
            self.assertEqual(report["zipMissingStyles"], 0)
            self.assertEqual(report["zipMissingAssets"], 0)


if __name__ == "__main__":
    unittest.main()
