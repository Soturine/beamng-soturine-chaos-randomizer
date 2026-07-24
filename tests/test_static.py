from __future__ import annotations

import json
from pathlib import Path
import re
import shutil
import subprocess
import unittest

from tools import validate_package


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
        pattern = re.compile(r"(?:[A-Za-z]:\\|/" + r"Users/|/" + r"home/)")
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

    def test_action_flushes_pending_settings(self) -> None:
        source = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.js").read_text(encoding="utf-8")
        run_body = source[source.index("scope.chaos.run = function"):source.index("scope.chaos.toggleAdvanced")]
        self.assertLess(run_body.index("cancelSettingsTimer()"), run_body.index("angular.copy"))
        self.assertIn("callWithArgs('runAction', [action, settings])", run_body)

    def test_manual_seed_clicked_immediately_is_used(self) -> None:
        source = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.js").read_text(encoding="utf-8")
        self.assertIn("angular.copy(scope.chaos.state.settings || {})", source)
        self.assertIn("callWithArgs('runAction', [action, settings])", source)
        self.assertIn("manualSeed", source)

    def test_filter_clicked_immediately_is_used(self) -> None:
        html = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.html").read_text(encoding="utf-8")
        source = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.js").read_text(encoding="utf-8")
        self.assertIn("settings.contentFilter", html)
        self.assertIn("angular.copy(scope.chaos.state.settings || {})", source)

    def test_destroy_cancels_pending_timer(self) -> None:
        source = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.js").read_text(encoding="utf-8")
        destroy = source[source.index("scope.$on('$destroy'"):]
        self.assertIn("cancelSettingsTimer()", destroy)

    def test_server_state_update_does_not_resend_settings(self) -> None:
        source = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.js").read_text(encoding="utf-8")
        apply_state = source[source.index("function applyState"):source.index("function persistSettings")]
        self.assertNotIn("updateSettings", apply_state)
        self.assertNotIn("scheduleSettings", apply_state)

    def test_vehicle_dna_navigation_is_compact(self) -> None:
        html = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.html").read_text(encoding="utf-8")
        source = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.js").read_text(encoding="utf-8")
        for label in ("Randomize", "Locks", "Garage", "Compare", "Share"):
            self.assertIn(f"label: '{label}'", source)
        self.assertIn("scr-nav", html)

    def test_ui_bridge_has_a_fixed_public_method_allowlist(self) -> None:
        source = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.js").read_text(encoding="utf-8")
        self.assertIn("if (!allowed[method]) return", source)
        self.assertNotIn("callWithArgs(scope.", source)
        self.assertNotIn("engineCall(scope.", source)
        for method in (
            "rerollUnlocked", "mutateVehicleDNA", "compareVehicleDNA", "exportVehicleDNAJson",
            "exportVehicleDNAPackage", "importVehicleDNAPackage", "captureVehicleDNAThumbnail",
        ):
            self.assertIn(f"{method}: true", source)

    def test_ui_exposes_accessible_responsive_operation_feedback(self) -> None:
        html = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.html").read_text(encoding="utf-8")
        css = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.css").read_text(encoding="utf-8")
        for fragment in ('aria-live="polite"', 'role="progressbar"', "Cancel and roll back", "scr-storage"):
            self.assertIn(fragment, html)
        for fragment in (":focus-visible", "@media (max-width:", "prefers-reduced-motion", "overflow-y: auto"):
            self.assertIn(fragment, css)

    def test_ui_sharing_and_thumbnail_paths_are_controlled(self) -> None:
        source = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.js").read_text(encoding="utf-8")
        html = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.html").read_text(encoding="utf-8")
        self.assertIn("/settings/soturineChaosRandomizer/vehicleDNA/thumbnails/", source)
        self.assertIn("/^[A-Za-z0-9_-]{1,96}$/", source)
        self.assertIn("scr-image-fallback", html)
        self.assertIn("sharePreview", html)
        self.assertIn("packageSha256", html)

    def test_vehicle_dna_save_is_explicit(self) -> None:
        html = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.html").read_text(encoding="utf-8")
        source = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.js").read_text(encoding="utf-8")
        self.assertIn("Save Vehicle DNA", html)
        self.assertIn("scope.chaos.saveDNA", source)
        self.assertNotIn("autoSaveDNA: true", source)

    def test_vehicle_dna_import_is_parsed_before_bridge_serialization(self) -> None:
        source = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.js").read_text(encoding="utf-8")
        body = source[source.index("scope.chaos.importDNA"):source.index("scope.chaos.dnaPage")]
        self.assertLess(body.index("JSON.parse(text)"), body.index("callWithArgs('importVehicleDNA', [parsed])"))
        self.assertNotIn("engineLua(text", body)
        self.assertNotIn("serializeToLua(text)", body)
        self.assertIn("text.length > 131072", body)

    def test_vehicle_dna_destructive_actions_confirm(self) -> None:
        source = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.js").read_text(encoding="utf-8")
        delete_body = source[source.index("scope.chaos.deleteDNA"):source.index("scope.chaos.exportDNA")]
        restore_body = source[source.index("scope.chaos.restoreDNA"):source.index("scope.chaos.replayDNA")]
        self.assertIn("window.confirm", delete_body)
        self.assertIn("window.confirm", restore_body)
        self.assertIn("preflightVehicleDNA", restore_body)
        self.assertIn("setVehicleDNAFavorite", source)

    def test_vehicle_dna_pagination_is_bounded(self) -> None:
        html = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.html").read_text(encoding="utf-8")
        source = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.js").read_text(encoding="utf-8")
        self.assertIn("garage.pageCount", html)
        self.assertIn("setVehicleDNAPage", source)

    def test_ui_host_fills_container(self) -> None:
        css = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.css").read_text(encoding="utf-8")
        host = css[css.index("soturine-chaos-randomizer {"):css.index("}", css.index("soturine-chaos-randomizer {"))]
        for declaration in ("display: block", "width: 100%", "height: 100%", "min-width: 0", "min-height: 0"):
            self.assertIn(declaration, host)

    def test_app_icon_limits(self) -> None:
        width, height, size = validate_package.validate_icon(
            ROOT / "ui/modules/apps/soturineChaosRandomizer/app.png"
        )
        self.assertEqual((width, height), (250, 120))
        self.assertLess(size, 100_000)

    def test_alpha2_compact_ui_contract(self) -> None:
        app = json.loads((ROOT / "ui/modules/apps/soturineChaosRandomizer/app.json").read_text(encoding="utf-8"))
        html = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.html").read_text(encoding="utf-8")
        css = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.css").read_text(encoding="utf-8")
        source = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.js").read_text(encoding="utf-8")
        self.assertEqual((app["css"]["width"], app["css"]["height"]), ("330px", "430px"))
        self.assertEqual((app["css"]["min-width"], app["css"]["min-height"]), ("300px", "340px"))
        self.assertIn("RANDOM CAR", html)
        self.assertNotIn("RANDOM CONFIG", html)
        self.assertIn("ng-if=\"chaos.state.garage.selectedId\"", html)
        self.assertIn("advancedOpen: false", source)
        for mode in ("collapsed", "compact", "expanded"):
            self.assertIn("scr-mode-" + mode, css)
        self.assertIn("@media (max-width: 310px), (max-height: 350px)", css)
        self.assertIn(":focus-visible", css)
        self.assertIn("setUICompactMode", source)
        self.assertIn("var allowed =", source)

    def test_workflow_yaml_parses(self) -> None:
        try:
            import yaml
        except ImportError:
            self.fail("PyYAML is required so workflow parsing cannot be silently skipped")
        for path in sorted((ROOT / ".github/workflows").glob("*.yml")):
            with self.subTest(path=path.name):
                self.assertIsInstance(yaml.safe_load(path.read_text(encoding="utf-8")), dict)

    def test_workflow_actions_are_sha_pinned(self) -> None:
        uses = re.compile(r"^\s*uses:\s*([^\s#]+)", re.MULTILINE)
        for path in sorted((ROOT / ".github/workflows").glob("*.yml")):
            for action in uses.findall(path.read_text(encoding="utf-8")):
                with self.subTest(path=path.name, action=action):
                    self.assertRegex(action, r"^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+@[0-9a-f]{40}$")

    def test_repository_has_no_machine_paths(self) -> None:
        pattern = re.compile(r"(?:[A-Za-z]:\\(?:Users|home)\\|/" + r"Users/|/" + r"home/)")
        ignored = {".git", "dist", "__pycache__"}
        for path in sorted(ROOT.rglob("*")):
            if not path.is_file() or path.suffix.lower() in {".png", ".zip"}:
                continue
            if any(part in ignored for part in path.parts):
                continue
            with self.subTest(path=path.relative_to(ROOT)):
                self.assertIsNone(pattern.search(path.read_text(encoding="utf-8", errors="ignore")))

    def test_no_obvious_credentials(self) -> None:
        pattern = re.compile(r"(?:ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9]{20,})")
        ignored = {".git", "dist", "__pycache__"}
        for path in sorted(ROOT.rglob("*")):
            if not path.is_file() or path.suffix.lower() in {".png", ".zip"}:
                continue
            if any(part in ignored for part in path.parts):
                continue
            self.assertIsNone(pattern.search(path.read_text(encoding="utf-8", errors="ignore")), path)


if __name__ == "__main__":
    unittest.main()
