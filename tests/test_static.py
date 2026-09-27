from __future__ import annotations

import json
from pathlib import Path
import re
import shutil
import subprocess
import sys
import unittest

from tools import validate_package


ROOT = Path(__file__).resolve().parents[1]
APP = ROOT / "ui/modules/apps/soturineChaosRandomizer"
PACKAGE_ROOTS = (ROOT / "lua", ROOT / "ui", ROOT / "settings", ROOT / "locales")


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
        notes = ROOT / "docs" / "releases" / f"v{version}.md"
        self.assertRegex(version, r"^\d+\.\d+\.\d+$")
        self.assertEqual(app["version"], version)
        self.assertEqual(package["version"], version)
        self.assertEqual(compatibility["modVersion"], version)
        self.assertEqual(compatibility["schemaVersion"], 2)
        self.assertEqual(compatibility["minimumBeamNGVersion"], "0.39")
        self.assertEqual(compatibility["uiRuntime"], "native-runtime-ui-vue")
        self.assertEqual(compatibility["license"], "Apache-2.0")
        self.assertEqual(package["license"], "Apache-2.0")
        self.assertIn(f'EXTENSION_VERSION = "{version}"', main)
        self.assertTrue(notes.is_file())

    def test_declared_license_matches_legal_files(self) -> None:
        readme = (ROOT / "README.md").read_text(encoding="utf-8")
        package = json.loads((ROOT / "package.json").read_text(encoding="utf-8"))
        compatibility = json.loads((ROOT / "COMPATIBILITY.json").read_text(encoding="utf-8"))
        license_text = (ROOT / "LICENSE").read_text(encoding="utf-8")
        self.assertEqual(package["license"], "Apache-2.0")
        self.assertEqual(compatibility["license"], "Apache-2.0")
        self.assertIn("Apache License 2.0", readme)
        self.assertIn("Apache License", license_text)
        self.assertTrue((ROOT / "NOTICE").is_file())
        self.assertNotRegex(readme, r"(?i)License:\s*\[MIT\]")

    def test_native_vue_ui_identity_is_single(self) -> None:
        manifests = [json.loads(path.read_text(encoding="utf-8")) for path in (ROOT / "ui").rglob("app.json")]
        self.assertEqual(len(manifests), 1)
        self.assertEqual(manifests[0]["directive"], "soturineChaosRandomizer")
        self.assertIs(manifests[0]["vue"], True)
        self.assertTrue((APP / "app.vue").is_file())
        for legacy in ("app.js", "app.html", "app.css"):
            self.assertFalse((APP / legacy).exists())

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

    def test_preview_renderer_is_read_only_and_receives_engine_bindings(self) -> None:
        # Behavior is covered by the Lua preview contract tests; this guards the
        # architectural boundary: no globals and no vehicle side effects.
        renderer = (ROOT / "lua/ge/extensions/soturineChaosRandomizer/racePreviewRenderer.lua").read_text(encoding="utf-8")
        self.assertNotIn("_G", renderer)
        for forbidden in ("spawnNewVehicle", "deleteVehicle", "enterVehicle", "safeTeleport", "setPosition", "queueLuaCommand"):
            self.assertNotIn(forbidden, renderer)

    def test_balanced_fallback_and_narrow_select_are_generic_and_bounded(self) -> None:
        validator_source = (ROOT / "lua/ge/extensions/soturineChaosRandomizer/validator.lua").read_text(encoding="utf-8")
        styles = (APP / "styles/app.css").read_text(encoding="utf-8")
        self.assertNotIn("wl40", validator_source.lower())
        for token in ("internals", "oilpan", "electricmotor", "controller", "ecu"):
            self.assertRegex(validator_source, rf"\b{token}\s*=")
        self.assertIn(".scr-smart-select { width: 100%; min-width: 0; max-width: 100%", styles)
        self.assertIn("display: block; width: 100%; min-width: 0; max-width: 100%; overflow: hidden", styles)
        self.assertIn("text-overflow: ellipsis; white-space: nowrap", styles)

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

    def test_i18n_catalogs_are_complete_and_safe(self) -> None:
        en = json.loads((APP / "i18n/en-US.json").read_text(encoding="utf-8"))
        pt = json.loads((APP / "i18n/pt-BR.json").read_text(encoding="utf-8"))
        es = json.loads((APP / "i18n/es-ES.json").read_text(encoding="utf-8"))
        self.assertEqual(set(en), set(pt))
        self.assertEqual(set(en), set(es))
        self.assertGreaterEqual(len(en), 200)
        for locale, catalog in (("en-US", en), ("pt-BR", pt), ("es-ES", es)):
            with self.subTest(locale=locale):
                self.assertFalse(any(re.search(r"<[^>]+>", value) for value in catalog.values()))
                self.assertIn("race.competitors.one", catalog)
                self.assertIn("race.competitors.other", catalog)
        service = (APP / "services/i18n.js").read_text(encoding="utf-8")
        self.assertIn('messages["en-US"][key] ?? humanizeKey(key)', service)
        self.assertIn("humanizeKey", service)
        self.assertIn("Intl.NumberFormat", service)
        self.assertIn('language.startsWith("es")', service)
        self.assertIn("localeMode", service)
        self.assertEqual(es["nav.settings"], "Ajustes")

    def test_v075_ai_i18n_layout_and_terminology_contracts(self) -> None:
        catalogs = {
            locale: json.loads((APP / f"i18n/{locale}.json").read_text(encoding="utf-8"))
            for locale in ("en-US", "pt-BR", "es-ES")
        }
        modes = ("Destination", "Route", "Follow", "Chase", "Flee", "Traffic", "Roam")
        presets = ("Follow", "Convoy", "Chase", "Flee", "Traffic", "Roam", "Swarm")
        outcomes = (
            "COMPLETED", "COMPLETED_WITH_SKIPS", "COMPLETED_WITH_WARNING", "PARTIAL_APPLIED",
            "FAILED_TIMEOUT", "FAILED_STALLED", "FAILED_RUNTIME_INTEGRITY", "FAILED_NO_CHANGE",
            "FAILED_SPAWN", "FAILED_BIND", "FAILED_RELOAD", "FAILED_PERSISTENCE",
            "FAILED_ROLLED_BACK", "CANCELLED",
        )
        for locale, catalog in catalogs.items():
            with self.subTest(locale=locale):
                for mode in modes:
                    self.assertIn(f"race.aiModeValue.{mode}", catalog)
                for preset in presets:
                    self.assertIn(f"race.aiPreset.{preset}", catalog)
                for outcome in outcomes:
                    self.assertIn(f"result.{outcome}", catalog)
        pt_values = "\n".join(catalogs["pt-BR"].values())
        for term in ("Seed", "DNA", "Preview", "Grid", "Mod", "Preset"):
            self.assertIn(term, pt_values)
        self.assertNotRegex(pt_values, r"(?i)\bsemente\b|\bprévia\b")

        css = (APP / "styles/app.css").read_text(encoding="utf-8")
        self.assertNotIn("100vw", css)
        self.assertNotIn("100vh", css)
        self.assertIn("height: auto", css)
        self.assertIn(".scr-app.is-normal", css)
        self.assertIn("height: 100%", css)
        termbase = (APP / "i18n/terminology.js").read_text(encoding="utf-8")
        for term in ("Seed", "DNA", "HUD", "Preview", "Grid", "Spawn", "Reload",
                     "Fallback", "ID", "Debug", "Compact", "Preset", "Mod", "Config",
                     "Input", "Output", "AI", "BeamNG", "BeamMP"):
            self.assertIn(f'"{term}"', termbase)
        self.assertIn("Soturine's Chaos Randomizer", termbase)
        self.assertIn("terminology.js", (ROOT / "docs/I18N.md").read_text(encoding="utf-8"))

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
        for field in ("activeTab", "compact", "mode", "details", "normalMinSize", "normalPreferredWidth", "normalPreferredHeightByTab", "userPreferredNormalSize", "expandedSizeByTab", "compactSizeByTab", "resizeModeByTab", "userSizeByTab"):
            self.assertIn(field, layout)
        for cleanup in ("observer?.disconnect()", 'removeEventListener?.("change"'):
            self.assertIn(cleanup, responsive)
        self.assertIn("onUnmounted(() => clearTimeout(timer))", garage)
        self.assertIn("onUnmounted", (APP / "app.vue").read_text(encoding="utf-8"))
        self.assertIn("requestAnimationFrame", responsive)
        self.assertIn("cancelAnimationFrame", responsive)
        self.assertIn("pendingSize", responsive)
        self.assertIn("target.value.parentElement", responsive)

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
        expected = {"fox-1024.png": (1024, 1024), "fox-256.png": (256, 256), "fox-64.png": (64, 64)}
        for name, dimensions in expected.items():
            data = (APP / "assets/branding" / name).read_bytes()
            self.assertEqual(validate_package.png_dimensions(data), dimensions)
            self.assertEqual(data[25], 6)
            self.assertEqual(validate_package.png_alpha_bounds(data), (0, 255))
        header = (APP / "components/shell/AppHeader.vue").read_text(encoding="utf-8")
        self.assertIn("assets/branding/fox-64.png", header)
        for legacy in ("app-icon.svg", "app-icon-250x120.png", "fox-mark.svg",
                       "fox-mark-24.png", "fox-mark-32.png", "fox-mark-48.png"):
            self.assertFalse((APP / "assets" / legacy).exists())

    def test_packaging_source_enforces_native_vue_topology(self) -> None:
        package_source = (ROOT / "tools/package_mod.py").read_text(encoding="utf-8")
        validation = (ROOT / "tools/validate_package.py").read_text(encoding="utf-8")
        for suffix in ('".vue"', '".css"', '".scss"', '".mjs"'):
            self.assertIn(suffix, package_source)
        for required in ("app.vue", "en-US.json", "pt-BR.json", "es-ES.json", "uiProtocol.lua"):
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
        # Every workflow validates through the one verify entry point.
        for name in ("ci.yml", "package.yml"):
            workflow = (ROOT / ".github/workflows" / name).read_text(encoding="utf-8")
            self.assertIn("npm ci --ignore-scripts", workflow)
            self.assertIn("npm run verify", workflow)
        self.assertIn("npm run verify:release", (ROOT / ".github/workflows/package.yml").read_text(encoding="utf-8"))

    def test_p0_and_p1_contract_modules_remain_packaged(self) -> None:
        p0 = (
            "registryReadiness.lua", "pathIdentity.lua", "spawnOutcome.lua", "transactionalJSON.lua",
            "coherentStateGate.lua", "runtime/domainOperations.lua", "operationOutcome.lua",
            "racePreview.lua", "raceScheduler.lua", "lineupPersistence.lua", "vehicleIdentity.lua",
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
