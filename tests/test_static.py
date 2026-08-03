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
APP = ROOT / "ui/modules/apps/soturineChaosRandomizer"
PACKAGE_ROOTS = (ROOT / "lua", ROOT / "ui", ROOT / "settings")


def frontend_source() -> str:
    return "\n".join(
        path.read_text(encoding="utf-8")
        for path in sorted(APP.rglob("*"))
        if path.is_file() and path.suffix.lower() in {".css", ".js", ".scss", ".vue"}
    )


class StaticValidationTests(unittest.TestCase):
    def test_json_files_parse(self) -> None:
        files = sorted(ROOT.rglob("*.json"))
        self.assertTrue(files)
        for path in files:
            if "node_modules" not in path.parts:
                with self.subTest(path=path.relative_to(ROOT)):
                    json.loads(path.read_text(encoding="utf-8"))

    def test_javascript_syntax(self) -> None:
        node = shutil.which("node")
        self.assertIsNotNone(node, "Node.js 24 is required")
        files = sorted((ROOT / "ui").rglob("*.js")) + sorted((ROOT / "tests/js").glob("*.mjs"))
        for path in files:
            with self.subTest(path=path.relative_to(ROOT)):
                result = subprocess.run([node, "--check", str(path)], text=True, capture_output=True)
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_vue_sfc_files_compile(self) -> None:
        node = shutil.which("node")
        compiler = ROOT / "node_modules/@vue/compiler-sfc"
        self.assertIsNotNone(node, "Node.js 24 is required")
        self.assertTrue(compiler.is_dir(), "run npm ci before the automated suite")
        result = subprocess.run(
            [node, str(ROOT / "tools/validate_vue_sfc.mjs"), str(APP), str(ROOT)],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("Validated 55 Vue SFC files.", result.stdout)

    def test_no_trailing_whitespace(self) -> None:
        extensions = {".js", ".json", ".lua", ".md", ".mjs", ".py", ".scss", ".svg", ".txt", ".vue", ".yml", ""}
        ignored = {".git", "dist", "node_modules", "__pycache__"}
        for path in sorted(ROOT.rglob("*")):
            if not path.is_file() or path.suffix.lower() not in extensions or any(part in ignored for part in path.parts):
                continue
            with self.subTest(path=path.relative_to(ROOT)):
                for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
                    self.assertIsNone(re.search(r"[ \t]+$", line), f"trailing whitespace on line {number}")

    def test_internal_markdown_links_resolve(self) -> None:
        link_pattern = re.compile(r"!?\[[^\]]*\]\(([^)]+)\)")
        for document in sorted(ROOT.rglob("*.md")):
            if any(part in {".git", "dist", "node_modules"} for part in document.parts):
                continue
            for target in link_pattern.findall(document.read_text(encoding="utf-8")):
                target = target.strip().split(" ", 1)[0].strip("<>")
                if not target or target.startswith(("#", "http://", "https://", "mailto:")):
                    continue
                with self.subTest(document=document.relative_to(ROOT), target=target):
                    self.assertTrue((document.parent / target.split("#", 1)[0]).resolve().exists())

    def test_beamng_api_boundary(self) -> None:
        unstable = re.compile(
            r"\b(?:core_[a-zA-Z_]+\s*[.:]|guihooks\s*[.:]|jsonReadFile\s*\(|"
            r"jsonWriteFile\s*\(|getPlayerVehicle\s*\(|be\s*:)"
        )
        allowed = {
            APP_PATH
            for APP_PATH in (
                ROOT / "lua/ge/extensions/soturineChaosRandomizer/apiAdapter.lua",
                ROOT / "lua/ge/extensions/soturineChaosRandomizer/spawnApiAdapter.lua",
                ROOT / "lua/ge/extensions/soturineChaosRandomizer/aiAdapter.lua",
                ROOT / "lua/ge/extensions/soturineChaosRandomizer/destinationMarker.lua",
            )
        }
        for path in sorted((ROOT / "lua").rglob("*.lua")):
            if path not in allowed:
                with self.subTest(path=path.relative_to(ROOT)):
                    self.assertIsNone(unstable.search(path.read_text(encoding="utf-8")))

    def test_version_and_compatibility_are_consistent(self) -> None:
        version = (ROOT / "VERSION").read_text(encoding="utf-8").strip()
        app = json.loads((APP / "app.json").read_text(encoding="utf-8"))
        package = json.loads((ROOT / "package.json").read_text(encoding="utf-8"))
        compatibility = json.loads((ROOT / "COMPATIBILITY.json").read_text(encoding="utf-8"))
        main = (ROOT / "lua/ge/extensions/soturineChaosRandomizer/main.lua").read_text(encoding="utf-8")
        notes = ROOT / "docs/RELEASE NOTES" / f"RELEASE_NOTES_{version}.md"
        self.assertEqual(version, "0.7.1")
        self.assertEqual(app["version"], version)
        self.assertEqual(package["version"], version)
        self.assertEqual(compatibility["modVersion"], version)
        self.assertEqual(compatibility["schemaVersion"], 2)
        self.assertEqual(compatibility["minimumBeamNGVersion"], "0.39")
        self.assertEqual(compatibility["uiRuntime"], "native-runtime-ui-vue")
        self.assertIn(f'EXTENSION_VERSION = "{version}"', main)
        self.assertTrue(notes.is_file())

    def test_native_vue_ui_identity_is_single(self) -> None:
        manifests = [json.loads(path.read_text(encoding="utf-8")) for path in (ROOT / "ui").rglob("app.json")]
        self.assertEqual(len(manifests), 1)
        self.assertEqual(manifests[0]["directive"], "soturineChaosRandomizer")
        self.assertIs(manifests[0]["vue"], True)
        self.assertTrue((APP / "app.vue").is_file())
        for legacy in ("app.js", "app.html", "app.css"):
            self.assertFalse((APP / legacy).exists())

    def test_vue_component_and_store_topology_is_modular(self) -> None:
        expected_components = {
            "AppShell", "AppHeader", "AppNavigation", "CompatibilityBadge", "OperationProgress",
            "GlobalStatus", "CompactToggle", "ChaosPanel", "ChaosActions", "ChaosResult",
            "ChaosProgress", "ChaosAdvanced", "LockControls", "MutationControls", "GaragePanel",
            "GarageToolbar", "GarageGrid", "GarageList", "VehicleDNACard", "VehicleDNADetails",
            "VehicleDNACompare", "VehicleDNAImportExport", "ThumbnailViewer", "MetadataEditor",
            "RacePanel", "RaceStepper", "RaceCarsStep", "RacePlacementStep", "RaceDriveStep",
            "RacePolicyPanel", "CompetitorList", "CompetitorCard", "FormationControls",
            "PlacementPreviewSummary", "ManagedVehicleControls", "AIDirectorControls", "SettingsPanel",
            "SeedSettings", "ContentSettings", "SafetySettings", "PerformanceSettings",
            "PersistenceSettings", "CompatibilitySettings", "DetailsPanel", "StatusBanner",
            "EmptyState", "ErrorState", "LoadingState", "ConfirmDialog", "Tooltip", "IconButton",
            "SegmentedControl", "NumericInput", "ToggleField",
        }
        components = {path.stem for path in (APP / "components").rglob("*.vue")}
        self.assertEqual(components, expected_components)
        self.assertEqual(len(list(APP.rglob("*.vue"))), 55)
        stores = {path.stem for path in (APP / "stores").glob("*.js")}
        self.assertTrue({"core", "chaos", "garage", "race", "settings", "compatibility", "diagnostics", "performance", "uiLayout"} <= stores)

    def test_bridge_is_allowlisted_versioned_and_serialized_once(self) -> None:
        source = (APP / "services/commandBridge.js").read_text(encoding="utf-8")
        router = (ROOT / "lua/ge/extensions/soturineChaosRandomizer/uiCommandRouter.lua").read_text(encoding="utf-8")
        protocol = (ROOT / "lua/ge/extensions/soturineChaosRandomizer/uiProtocol.lua").read_text(encoding="utf-8")
        self.assertIn("UI_PROTOCOL_VERSION = 2", source)
        self.assertIn("COMMAND_SCHEMAS", source)
        self.assertIn("serializeToLua(envelope)", source)
        self.assertIn("dispatchUICommand(${serialized})", source)
        self.assertNotIn("dispatchUICommand(${command}", source)
        self.assertIn("command_not_allowed", router)
        self.assertIn("command_payload_oversize", protocol)
        self.assertIn("MAX_DEPTH = 12", protocol)

    def test_state_protocol_handles_full_diff_stale_gap_and_domains(self) -> None:
        source = (APP / "services/stateProtocol.js").read_text(encoding="utf-8")
        for fragment in (
            "appliedVersion", "stateVersion <= appliedVersion", "stateVersion !== appliedVersion + 1",
            'recover("state_version_gap")', "applyFull", "applyDiff(envelope.domain", "DOMAINS.has",
        ):
            self.assertIn(fragment, source)
        app = (APP / "app.vue").read_text(encoding="utf-8")
        self.assertEqual(app.count('subscribe("SoturineChaosRandomizerState"'), 1)
        self.assertEqual(app.count('subscribe("SoturineChaosRandomizerStateDiff"'), 1)
        self.assertIn("returnedCleanup", app)
        self.assertIn("events.off?.(name, handler)", app)
        self.assertEqual(app.count('command.send("requestState")'), 2)

    def test_feature_parity_fixtures_cover_all_required_states(self) -> None:
        fixture = json.loads((ROOT / "tests/fixtures/v0.7.0/ui-states.json").read_text(encoding="utf-8"))
        expected = {
            "idle", "busy", "random-car", "scramble", "full-random", "failure", "partial-success",
            "rollback", "stale-callback-ignored", "garage-empty", "garage-populated", "dna-details",
            "dna-compare", "race-idle", "race-generating", "race-partial", "race-ready",
            "placement-preview", "drive-active", "ai-failure", "settings", "compatibility-warning",
            "performance-profiling",
        }
        fixtures = {item["id"]: item for item in fixture["fixtures"]}
        self.assertEqual(set(fixtures), expected)
        self.assertEqual(fixture["protocolVersion"], 2)
        for name, item in fixtures.items():
            with self.subTest(fixture=name):
                self.assertIn(item["envelope"]["eventType"], {"full", "diff"})
                self.assertTrue({"features", "actions", "disabled", "labels", "compact", "details"} <= set(item["expected"]))

    def test_race_policy_preserves_every_technical_field(self) -> None:
        panel = (APP / "components/race/RacePolicyPanel.vue").read_text(encoding="utf-8")
        preferences = (ROOT / "lua/ge/extensions/soturineChaosRandomizer/uiPreferences.lua").read_text(encoding="utf-8")
        fields = (
            "avoidDuplicateModels", "avoidDuplicateConfigurations", "avoidDuplicateFamilies",
            "maximumSameFamily", "diversifyVehicleClasses", "diversifyPropulsion", "diversifyDrivetrain",
            "diversifySource", "diversifyWheelStyles", "diversifyBodyTypes", "allowOfficialVehicles",
            "allowModVehicles", "allowAutomationVehicles", "allowTrailers", "allowProps", "acceptPartial",
            "acceptMetadataUncertain", "acceptPotentiallyUndrivable", "maxAttemptsPerCompetitor",
            "maxConsecutiveFailures", "retainAcceptedOnCancel",
        )
        for field in fields:
            with self.subTest(field=field):
                self.assertIn(field, panel)
                self.assertIn(field, preferences)
        self.assertIn('options.preset = "Custom"', panel)
        self.assertIn('command.send("updateUIPreferences"', panel)

    def test_i18n_catalogs_are_complete_and_safe(self) -> None:
        en = json.loads((APP / "i18n/en-US.json").read_text(encoding="utf-8"))
        pt = json.loads((APP / "i18n/pt-BR.json").read_text(encoding="utf-8"))
        self.assertEqual(set(en), set(pt))
        self.assertGreaterEqual(len(en), 200)
        for locale, catalog in (("en-US", en), ("pt-BR", pt)):
            with self.subTest(locale=locale):
                self.assertFalse(any(re.search(r"<[^>]+>", value) for value in catalog.values()))
                self.assertIn("race.competitors.one", catalog)
                self.assertIn("race.competitors.other", catalog)
        service = (APP / "services/i18n.js").read_text(encoding="utf-8")
        self.assertIn('messages["en-US"][key] ?? key', service)
        self.assertIn("Intl.NumberFormat", service)

    def test_accessibility_and_controller_navigation_contracts(self) -> None:
        source = frontend_source()
        css = (APP / "styles/app.css").read_text(encoding="utf-8")
        for fragment in (
            'role="tablist"', 'role="tab"', 'role="progressbar"', 'aria-live="polite"',
            "v-bng-scoped-nav", "v-bng-on-ui-nav:back", "bng-nav-item", "autofocus",
        ):
            self.assertIn(fragment, source)
        for fragment in (":focus-visible", "prefers-reduced-motion", "forced-colors: active"):
            self.assertIn(fragment, css)
        self.assertNotIn("window.prompt", source)
        self.assertNotIn("window.confirm", source)

    def test_responsive_and_lifecycle_cleanup_contracts(self) -> None:
        layout = (APP / "stores/uiLayout.js").read_text(encoding="utf-8")
        responsive = (APP / "composables/useResponsiveLayout.js").read_text(encoding="utf-8")
        garage = (APP / "components/garage/GarageToolbar.vue").read_text(encoding="utf-8")
        for field in ("activeTab", "compact", "details", "expandedSizeByTab", "compactSizeByTab", "resizeModeByTab", "userSizeByTab"):
            self.assertIn(field, layout)
        for cleanup in ("observer?.disconnect()", 'removeEventListener?.("change"'):
            self.assertIn(cleanup, responsive)
        self.assertIn("onUnmounted(() => clearTimeout(timer))", garage)
        self.assertIn("onUnmounted", (APP / "app.vue").read_text(encoding="utf-8"))
        self.assertIn("requestAnimationFrame", responsive)
        self.assertIn("cancelAnimationFrame", responsive)
        self.assertIn("pendingSize", responsive)

    def test_frontend_security_has_no_remote_or_executable_content(self) -> None:
        source = frontend_source()
        for pattern in (r"\bv-html\b", r"\beval\s*\(", r"new\s+Function\s*\(", r"https?://", r"//cdn\."):
            self.assertIsNone(re.search(pattern, source, re.IGNORECASE))
        self.assertIn("JSON.parse(importText.value)", source)
        self.assertIn('maxlength="131072"', source)
        self.assertNotIn("engineLua(text", source)

    def test_brand_assets_are_local_transparent_and_bounded(self) -> None:
        width, height, size = validate_package.validate_icon(APP / "app.png")
        self.assertEqual((width, height), (250, 120))
        self.assertLess(size, 100_000)
        fox = (APP / "assets/fox-mark.svg").read_text(encoding="utf-8")
        ET.fromstring(fox)
        self.assertLess(len(fox.encode()), 2048)
        self.assertNotRegex(fox.lower(), r"<script|<image|<filter|base64|https?://(?!www\.w3\.org/2000/svg)")
        expected = {"fox-mark-24.png": (24, 24), "fox-mark-32.png": (32, 32), "fox-mark-48.png": (48, 48)}
        for name, dimensions in expected.items():
            data = (APP / "assets" / name).read_bytes()
            self.assertEqual(validate_package.png_dimensions(data), dimensions)
            self.assertEqual(data[25], 6)

    def test_packaging_source_enforces_native_vue_topology(self) -> None:
        package_source = (ROOT / "tools/package_mod.py").read_text(encoding="utf-8")
        validation = (ROOT / "tools/validate_package.py").read_text(encoding="utf-8")
        for suffix in ('".vue"', '".css"', '".scss"', '".mjs"'):
            self.assertIn(suffix, package_source)
        for required in ("app.vue", "en-US.json", "pt-BR.json", "uiProtocol.lua"):
            self.assertIn(required, validation)
        self.assertIn("FORBIDDEN_RUNTIME_PATHS", validation)
        self.assertIn("validate_extracted_vue_module_graph", validation)
        self.assertIn("validate_extracted_vue_style_graph", validation)
        self.assertTrue((ROOT / "tools/validate_vue_module_graph.mjs").is_file())
        self.assertTrue((ROOT / "tools/validate_vue_style_graph.mjs").is_file())
        self.assertIn('GENERATOR_VERSION = 8', package_source)

    def test_workflow_yaml_parses_and_uses_pinned_actions(self) -> None:
        try:
            import yaml
        except ImportError:
            self.fail("PyYAML is required")
        uses = re.compile(r"^\s*uses:\s*([^\s#]+)", re.MULTILINE)
        for path in sorted((ROOT / ".github/workflows").glob("*.yml")):
            source = path.read_text(encoding="utf-8")
            self.assertIsInstance(yaml.safe_load(source), dict)
            for action in uses.findall(source):
                self.assertRegex(action, r"^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+@[0-9a-f]{40}$")
        ci = (ROOT / ".github/workflows/ci.yml").read_text(encoding="utf-8")
        beta = (ROOT / ".github/workflows/beta-readiness.yml").read_text(encoding="utf-8")
        self.assertIn("npm ci --ignore-scripts", ci)
        self.assertIn("npm run validate:sfc", ci)
        self.assertIn("npm run validate:graph", ci)
        self.assertIn("npm run validate:styles", ci)
        self.assertIn("--module-graph-only", ci)
        self.assertIn("--style-graph-only", ci)
        package_workflow = (ROOT / ".github/workflows/package.yml").read_text(encoding="utf-8")
        self.assertIn("npm run validate:graph", package_workflow)
        self.assertIn("npm run validate:styles", package_workflow)
        self.assertIn("--module-graph-only", package_workflow)
        self.assertIn("--style-graph-only", package_workflow)
        self.assertIn("npm run test:ui", beta)

    def test_p0_and_p1_contract_modules_remain_packaged(self) -> None:
        p0 = (
            "registryReadiness.lua", "pathIdentity.lua", "spawnOutcome.lua", "transactionalJSON.lua",
            "coherentStateGate.lua", "runtime/domainOperations.lua",
        )
        p1 = (
            "performanceMetrics.lua", "frameBudget.lua", "vehicleIterator.lua", "vehicleBufferPool.lua",
            "dimensionCache.lua", "registryCache.lua", "incrementalIndexer.lua", "uiPublisher.lua",
            "adaptivePolling.lua", "aiModeConfirmation.lua",
        )
        module_root = ROOT / "lua/ge/extensions/soturineChaosRandomizer"
        for module in p0 + p1:
            self.assertTrue((module_root / module).is_file(), module)
        main = (module_root / "main.lua").read_text(encoding="utf-8")
        self.assertIn("race_generation_isolated_from_chaos", main)
        self.assertIn("uiPublisher", main)
        self.assertIn("performanceMetrics", main)

    def test_required_vue_release_documentation_exists_and_is_honest(self) -> None:
        required = (
            "README.md", "CHANGELOG.md", "ROADMAP.md", "docs/ARCHITECTURE.md",
            "docs/UI_VUE_ARCHITECTURE.md", "docs/UI_MIGRATION_0.7.0.md", "docs/UI_PROTOCOL.md",
            "docs/I18N.md", "docs/ACCESSIBILITY.md", "docs/PERFORMANCE.md",
            "docs/BEAMNG_0.39_COMPATIBILITY.md", "docs/POST_V070_AUDIT_PLAN.md",
            "docs/testing/v0.7.0/README.md", "docs/testing/v0.7.0/AUTOMATED_TEST_REPORT.md",
            "docs/testing/v0.7.0/LIVE_TEST_PLAN.md", "docs/testing/v0.7.0/LIVE_TEST_REPORT.md",
            "docs/testing/v0.7.0/FEATURE_PARITY_MATRIX.md", "docs/testing/v0.7.0/ACCESSIBILITY_REPORT.md",
            "docs/testing/v0.7.0/I18N_REPORT.md", "docs/testing/v0.7.0/PERFORMANCE_REPORT.md",
            "docs/testing/v0.7.0/REQUIREMENTS_MATRIX.md", "docs/testing/v0.7.0/RELEASE_CHECKLIST.md",
            "docs/RELEASE NOTES/RELEASE_NOTES_0.7.0.md",
            "docs/testing/v0.7.1/README.md", "docs/testing/v0.7.1/AUTOMATED_TEST_REPORT.md",
            "docs/testing/v0.7.1/MODULE_GRAPH_REPORT.md", "docs/testing/v0.7.1/LIVE_TEST_PLAN.md",
            "docs/testing/v0.7.1/LIVE_TEST_REPORT.md", "docs/testing/v0.7.1/REQUIREMENTS_MATRIX.md",
            "docs/testing/v0.7.1/RELEASE_CHECKLIST.md", "docs/RELEASE NOTES/RELEASE_NOTES_0.7.1.md",
        )
        for relative in required:
            with self.subTest(path=relative):
                self.assertTrue((ROOT / relative).is_file())
        corpus = "\n".join((ROOT / path).read_text(encoding="utf-8") for path in required if (ROOT / path).suffix == ".md")
        v070_live = (ROOT / "docs/testing/v0.7.0/LIVE_TEST_REPORT.md").read_text(encoding="utf-8")
        self.assertIn("Failed — Vue module graph could not load", v070_live)
        for row in ("| Executed | 1 |", "| Passed | 0 |", "| Failed | 1 |", "| Pending | 0 |", "| Blocked | 81 |"):
            self.assertIn(row, v070_live)
        v071_live = (ROOT / "docs/testing/v0.7.1/LIVE_TEST_REPORT.md").read_text(encoding="utf-8")
        self.assertIn("Runtime UI mounted, but UI and gameplay rescue gates failed", v071_live)
        for row in ("| Executed | 9 |", "| Passed | 3 |", "| Failed | 6 |", "| Pending | 0 |", "| Blocked | 88 |"):
            self.assertIn(row, v071_live)
        self.assertNotRegex(corpus.lower(), r"fully validated|confirmed compatible|performance proven")

    def test_repository_and_package_have_no_machine_paths_or_credentials(self) -> None:
        machine = re.compile(r"(?:[A-Za-z]:\\(?:Users|home)\\|/" + r"Users/|/" + r"home/)")
        credentials = re.compile(r"(?:ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9]{20,})")
        ignored = {".git", "dist", "node_modules", "__pycache__"}
        for path in sorted(ROOT.rglob("*")):
            if not path.is_file() or path.suffix.lower() in {".png", ".zip"} or any(part in ignored for part in path.parts):
                continue
            text = path.read_text(encoding="utf-8", errors="ignore")
            self.assertIsNone(machine.search(text), path)
            self.assertIsNone(credentials.search(text), path)
        for package_root in PACKAGE_ROOTS:
            self.assertTrue(package_root.is_dir())


if __name__ == "__main__":
    unittest.main()
