from __future__ import annotations

import json
from pathlib import Path
import re
import shutil
import subprocess
import unittest
import xml.etree.ElementTree as ET

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
        unstable = re.compile(
            r"\b(?:core_[a-zA-Z_]+\s*[.:]|guihooks\s*[.:]|jsonReadFile\s*\(|"
            r"jsonWriteFile\s*\(|getPlayerVehicle\s*\(|be\s*:)"
        )
        allowed = {
            ROOT / "lua" / "ge" / "extensions" / "soturineChaosRandomizer" / "apiAdapter.lua",
            ROOT / "lua" / "ge" / "extensions" / "soturineChaosRandomizer" / "spawnApiAdapter.lua",
            ROOT / "lua" / "ge" / "extensions" / "soturineChaosRandomizer" / "aiAdapter.lua",
            ROOT / "lua" / "ge" / "extensions" / "soturineChaosRandomizer" / "destinationMarker.lua",
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
        html = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.html").read_text(encoding="utf-8")
        notes = ROOT / "docs" / "RELEASE NOTES" / f"RELEASE_NOTES_{version}.md"
        self.assertEqual(app["version"], version)
        self.assertIn(f'EXTENSION_VERSION = "{version}"', main)
        self.assertIn(f"extensionVersion || '{version}'", html)
        self.assertTrue(notes.is_file())
        self.assertIn(f"Soturine's Chaos Randomizer {version}", notes.read_text(encoding="utf-8"))

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

    def test_v061_navigation_is_exact_and_compact(self) -> None:
        html = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.html").read_text(encoding="utf-8")
        source = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.js").read_text(encoding="utf-8")
        navigation_start = source.index("navigation: [")
        navigation = source[navigation_start:source.index("],", navigation_start) + 2]
        self.assertEqual(re.findall(r"label: '([^']+)'", navigation), ["CHAOS", "GARAGE", "RACE", "SETTINGS"])
        for label in ("Saved", "Compare", "Share", "Cars", "Placement", "Drive"):
            self.assertIn(f">{label}<", html)
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

    def test_v061_ui_exposes_accessible_responsive_operation_feedback(self) -> None:
        html = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.html").read_text(encoding="utf-8")
        css = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.css").read_text(encoding="utf-8")
        for fragment in ('aria-live="polite"', 'role="progressbar"', "Cancel safely", "Copy diagnostics"):
            self.assertIn(fragment, html)
        for fragment in (":focus-visible", "@media (max-width:", "overflow: auto", "min-height: 32px"):
            self.assertIn(fragment, css)

    def test_v061_lifecycle_controls_remain_available(self) -> None:
        html = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.html").read_text(encoding="utf-8")
        source = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.js").read_text(encoding="utf-8")
        self.assertIn("Phase: {{chaos.state.lifecyclePhase", html)
        self.assertIn("Operation appears stalled", html)
        self.assertIn("Cancel safely", html)
        self.assertIn("Copy diagnostics", html)
        self.assertIn("cancelCurrentOperation: true", source)
        self.assertIn("copyDiagnostics: true", source)

    def test_v061_race_workflow_and_presets_are_visible(self) -> None:
        html = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.html").read_text(encoding="utf-8")
        source = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.js").read_text(encoding="utf-8")
        for label in ("Cars", "Placement", "Drive"):
            self.assertIn(f">{label}<", html)
        for preset in ("Balanced", "Maximum Chaos", "Mods Showcase"):
            self.assertIn(f"'{preset}'", source)
        self.assertIn("GENERATE CARS", html)
        self.assertIn("No race cars are ready yet", html)
        navigation = source[source.index("navigation: ["):source.index("racePresets:")]
        for legacy in ("Lineup", "Spawn", "AI"):
            self.assertNotIn(f"label: '{legacy}'", navigation)

    def test_v061_compact_size_and_mode_contract(self) -> None:
        app = json.loads((ROOT / "ui/modules/apps/soturineChaosRandomizer/app.json").read_text(encoding="utf-8"))
        html = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.html").read_text(encoding="utf-8")
        css = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.css").read_text(encoding="utf-8")
        self.assertEqual((app["css"]["width"], app["css"]["height"]), ("340px", "300px"))
        self.assertEqual((app["css"]["min-width"], app["css"]["min-height"]), ("300px", "120px"))
        self.assertIn("scr-collapsed-actions", html)
        self.assertIn(".scr-mode-collapsed", css)
        self.assertNotIn(".scr-mode-compact", css)
        self.assertIn("overflow: auto", css)

    def test_v061_placement_and_drive_controls_are_capability_honest(self) -> None:
        html = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.html").read_text(encoding="utf-8")
        source = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.js").read_text(encoding="utf-8")
        for fragment in (
            "Formation", "Spacing", "Heading", "Preview", "Spawn all",
            "AI mode", "Destination", "Route", "Speed km/h", "Aggression", "Stagger", "Start", "Stop",
        ):
            self.assertIn(fragment, html)
        self.assertIn("options.speedKph", source)
        self.assertIn("/ 3.6", source)
        self.assertIn("if (!allowed[method]) return", source)

    def test_ui_sharing_and_thumbnail_paths_are_controlled(self) -> None:
        source = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.js").read_text(encoding="utf-8")
        html = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.html").read_text(encoding="utf-8")
        self.assertIn("/settings/soturineChaosRandomizer/vehicleDNA/thumbnails/", source)
        self.assertIn("/^[A-Za-z0-9_-]{1,96}$/", source)
        self.assertIn("scr-image-fallback", html)
        self.assertIn("Prepare JSON", html)
        self.assertIn("Export package", html)
        self.assertIn("Validate import", html)

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

    def test_v061_chaos_seed_slider_and_brand_contract(self) -> None:
        app = json.loads((ROOT / "ui/modules/apps/soturineChaosRandomizer/app.json").read_text(encoding="utf-8"))
        html = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.html").read_text(encoding="utf-8")
        css = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.css").read_text(encoding="utf-8")
        source = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.js").read_text(encoding="utf-8")
        fox_path = ROOT / "ui/modules/apps/soturineChaosRandomizer/assets/fox-mark.svg"
        fox = fox_path.read_text(encoding="utf-8")
        self.assertEqual((app["css"]["width"], app["css"]["height"]), ("340px", "300px"))
        self.assertEqual((app["css"]["min-width"], app["css"]["min-height"]), ("300px", "120px"))
        self.assertIn("RANDOM CAR", html)
        self.assertNotIn("RANDOM CONFIG", html)
        chaos_panel = html[html.index("scr-chaos-view"):html.index("chaos.view === 'garage'")]
        settings_panel = html[html.index("chaos.view === 'settings'"):]
        self.assertNotIn("scr-manual-seed", chaos_panel)
        self.assertIn("scr-manual-seed", settings_panel)
        self.assertIn("scr-mode-collapsed", css)
        self.assertIn("'expanded'", source)
        self.assertNotIn("scr-mode-compact", css)
        self.assertIn(":focus-visible", css)
        self.assertIn("setUICompactMode", source)
        self.assertIn("::-webkit-slider-runnable-track", css)
        self.assertIn("::-webkit-slider-thumb", css)
        self.assertRegex(css, r"scr-chaos-control input\[type=range\][^{]*\{[^}]*padding:\s*0")
        self.assertLess(fox_path.stat().st_size, 2048)
        self.assertNotRegex(fox.lower(), r"<script|base64|https?://(?!www\.w3\.org/2000/svg)")
        ET.fromstring(fox)
        self.assertIn("var allowed =", source)

    def test_v063_responsive_height_uses_rendered_content(self) -> None:
        html = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.html").read_text(encoding="utf-8")
        css = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.css").read_text(encoding="utf-8")
        source = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.js").read_text(encoding="utf-8")
        panel = html[html.index("scr-chaos-view"):html.index("chaos.view === 'garage'")]
        self.assertLess(panel.index("scr-chaos-control"), panel.index("scr-status"))
        self.assertLess(panel.index("scr-status"), panel.index("scr-warning"))
        self.assertNotRegex(css, r"\.scr-status\s*\{[^}]*margin-top:\s*auto")
        self.assertIn("body.scrollHeight", source)
        self.assertIn("SoturineChaosUiMath.contentHeight", source)
        self.assertIn("SoturineChaosUiMath.manualHeight", source)
        self.assertIn("SoturineChaosUiMath.shouldApplyResize", source)
        self.assertIn("window.MutationObserver", source)
        self.assertNotRegex(source, r"view === 'chaos'\s*\?.*270")
        self.assertIn("classList.contains('bng-app')", source)
        self.assertIn("app:resized", source)

    def test_v063_slider_uses_real_fill_track(self) -> None:
        html = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.html").read_text(encoding="utf-8")
        css = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.css").read_text(encoding="utf-8")
        source = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.js").read_text(encoding="utf-8")
        self.assertIn('class="scr-slider-track"', html)
        self.assertIn('class="scr-slider-fill"', html)
        self.assertIn("chaos.sliderPercent", html)
        self.assertNotIn("chaosSliderStyle", source)
        self.assertNotIn("--chaos-percent", css)
        self.assertRegex(css, r"\.scr-slider-fill\s*\{[^}]*pointer-events:\s*none")
        self.assertRegex(css, r"::-webkit-slider-runnable-track\s*\{[^}]*background:\s*transparent")
        self.assertIn("function sliderPercent", source)
        self.assertRegex(css, r"input\[type=range\][^{]*\{[^}]*width:\s*100%[^}]*padding:\s*0")
        self.assertIn("@media (max-width: 319px)", css)
        self.assertIn("@media (min-width: 320px) and (max-width: 359px)", css)
        self.assertIn("@media (min-width: 360px)", css)

    def test_v063_fox_exactly_matches_v061_asset(self) -> None:
        fox_path = ROOT / "ui/modules/apps/soturineChaosRandomizer/assets/fox-mark.svg"
        fox = fox_path.read_text(encoding="utf-8")
        css = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.css").read_text(encoding="utf-8")
        html = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.html").read_text(encoding="utf-8")
        ET.fromstring(fox)
        self.assertLess(fox_path.stat().st_size, 2048)
        self.assertNotRegex(fox.lower(), r"<script|<image|<filter|base64|https?://(?!www\.w3\.org/2000/svg)")
        import hashlib
        packaged_fox = fox_path.read_bytes().replace(b"\r\n", b"\n").replace(b"\r", b"\n")
        self.assertEqual(
            hashlib.sha256(packaged_fox).hexdigest(),
            "22d0e8cba5878582879633c03158aa948388d02aaabe28f380c333f462b20040",
        )
        self.assertIn('class="scr-fox" aria-hidden="true"', html)
        self.assertRegex(css, r"\.scr-fox\s*\{[^}]*32px[^}]*opacity:\s*\.96")

    def test_v062_capability_degradation_is_visible_and_disables_actions(self) -> None:
        html = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.html").read_text(encoding="utf-8")
        source = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.js").read_text(encoding="utf-8")
        capabilities_source = (ROOT / "lua/ge/extensions/soturineChaosRandomizer/capabilities.lua").read_text(encoding="utf-8")
        for status in ("available", "unavailable", "degraded", "unsupported"):
            self.assertIn(f'"{status}"', capabilities_source)
        for name in (
            "vehicleReplaceSpawn", "partsReadWrite", "tuningReadWrite", "paintReadWrite",
            "navgraph", "aiDestination", "aiRoute", "managedMultiVehicle", "scriptAI",
            "raycastCustomPoint", "thumbnail", "clipboard", "fileImportExport",
        ):
            self.assertIn(name, capabilities_source)
        self.assertIn("chaos.capabilityReason('fileImportExport')", html)
        self.assertIn("!chaos.aiModeAvailable(chaos.aiOptions.mode)", html)
        self.assertIn("ng-disabled=\"!chaos.aiModeAvailable('Destination')\"", html)
        self.assertIn("chaos.aiUnavailableReason", source)

    def test_v062_public_feature_controls_cover_garage_race_and_settings(self) -> None:
        html = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.html").read_text(encoding="utf-8")
        source = (ROOT / "ui/modules/apps/soturineChaosRandomizer/app.js").read_text(encoding="utf-8")
        for label in (
            "Restore exact", "Restore compatible", "Replay generation", "Pure seed replay",
            "Small mutation", "Medium mutation", "Wild mutation", "Reroll unlocked",
            "Capture thumbnail", "Compatibility:", "lineage depth",
            "Cancel generation", "Fallback", "Spawn one", "Spawn next", "Spawn all",
            "Front Left", "Behind Right", "Custom point", "Collision",
            "Start all", "Pause all", "Resume all", "Stop all", "Reset all", "Respawn damaged",
            "Speed mode", "Drive in lane", "Avoid vehicles", "Finish action", "Stuck action",
            "General", "Safety", "Seed &amp; Reproducibility", "Locks", "Advanced", "Diagnostics",
        ):
            self.assertIn(label.lower(), html.lower())
        self.assertIn("startSpawnVariant", source)
        self.assertIn("options.spawnAll = variant === 'all'", source)

    def test_v062_evidence_documents_are_exact_and_feature_audit_is_complete(self) -> None:
        archive = ROOT / "docs/archive/releases/0.6.2"
        plan = (archive / "LIVE_TEST_PLAN.md").read_text(encoding="utf-8")
        report = (archive / "LIVE_TEST_REPORT.md").read_text(encoding="utf-8")
        matrix = (archive / "REQUIREMENTS_MATRIX_0.6.2.md").read_text(encoding="utf-8")
        audit = (ROOT / "docs/FEATURE_AUDIT_0.6.2.md").read_text(encoding="utf-8")
        required_columns = (
            "Feature", "Public action", "Backend entry point", "Dependencies",
            "Automated tests", "Interactive status", "Known issue", "Documentation",
        )
        self.assertEqual(len(re.findall(r"^\| (?:A-|P\d|B\d|L\d|R\d|G\d|U\d)", plan, re.MULTILINE)), 80)
        self.assertIn("| Pending | 80 |", plan)
        self.assertIn("| Pending | 80 |", report)
        self.assertEqual(len(re.findall(r"^\| R\d{2} \|", matrix, re.MULTILINE)), 95)
        for column in required_columns:
            self.assertIn(column, audit)

        main = (ROOT / "lua/ge/extensions/soturineChaosRandomizer/main.lua").read_text(encoding="utf-8")
        exported = set(re.findall(r"^M\.([A-Za-z0-9_]+)\s*=", main, re.MULTILINE))
        infrastructure = {"dependencies"}
        for name in sorted(exported - infrastructure):
            with self.subTest(public_entry_point=name):
                self.assertIn(f"`{name}`", audit)

    def test_workflow_yaml_parses(self) -> None:
        try:
            import yaml
        except ImportError:
            self.fail("PyYAML is required so workflow parsing cannot be silently skipped")
        for path in sorted((ROOT / ".github/workflows").glob("*.yml")):
            with self.subTest(path=path.name):
                self.assertIsInstance(yaml.safe_load(path.read_text(encoding="utf-8")), dict)
        ci = (ROOT / ".github/workflows/ci.yml").read_text(encoding="utf-8")
        package = (ROOT / ".github/workflows/package.yml").read_text(encoding="utf-8")
        for source in (ci, package):
            self.assertIn("dist/*.zip", source)
            self.assertIn("dist/*.sha256", source)
            self.assertIn("dist/release-manifest.json", source)
        self.assertIn('expected="v$(tr -d \'\\r\\n\' < VERSION)"', package)
        self.assertIn('notes="docs/RELEASE NOTES/RELEASE_NOTES_${version}.md"', package)
        self.assertIn("Refuse to overwrite an existing release", package)
        self.assertIn("python tools/validate_release_gate.py", package)
        self.assertIn("--verify-tag", package)
        self.assertIn("--prerelease", package)

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
