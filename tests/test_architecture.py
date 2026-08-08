from __future__ import annotations

from collections import deque
from pathlib import Path
import re
import unittest


ROOT = Path(__file__).resolve().parents[1]
ENTRYPOINT = ROOT / "lua/ge/extensions/soturineChaosRandomizer.lua"
MODULE_ROOT = ROOT / "lua/ge/extensions/soturineChaosRandomizer"
MODULE_PREFIX = "ge/extensions/soturineChaosRandomizer"
ENTRYPOINT_MODULES = (
    MODULE_PREFIX,
    # Deliberate compatibility entrypoint for historical third-party imports.
    f"{MODULE_PREFIX}/lineupManager",
)
REQUIRE_PATTERN = re.compile(
    r'''\brequire\s*\(?\s*["'](ge/extensions/soturineChaosRandomizer(?:/[A-Za-z0-9_./-]+)?)["']'''
)


def module_name(path: Path) -> str:
    relative = path.relative_to(MODULE_ROOT).with_suffix("").as_posix()
    return f"{MODULE_PREFIX}/{relative}"


class ProductionModuleGraphTests(unittest.TestCase):
    def test_every_production_module_is_reachable_from_beamng_entrypoint(self) -> None:
        sources = {MODULE_PREFIX: ENTRYPOINT}
        sources.update({module_name(path): path for path in MODULE_ROOT.rglob("*.lua")})

        graph: dict[str, set[str]] = {}
        unresolved: list[str] = []
        for source_name, path in sources.items():
            dependencies = set(REQUIRE_PATTERN.findall(path.read_text(encoding="utf-8")))
            graph[source_name] = dependencies
            unresolved.extend(
                f"{source_name} -> {dependency}"
                for dependency in sorted(dependencies)
                if dependency not in sources
            )

        self.assertEqual(unresolved, [], "internal require(s) without a production module")

        reachable: set[str] = set()
        pending = deque(ENTRYPOINT_MODULES)
        while pending:
            current = pending.popleft()
            if current in reachable:
                continue
            reachable.add(current)
            pending.extend(graph.get(current, ()))

        production = set(sources) - {MODULE_PREFIX}
        orphaned = sorted(production - reachable)
        self.assertEqual(
            orphaned,
            [],
            "orphaned Lua production module(s); wire them into the entrypoint graph or remove them",
        )

    def test_race_generation_uses_id_bound_background_writes(self) -> None:
        adapter = (MODULE_ROOT / "apiAdapter.lua").read_text(encoding="utf-8")
        main = (MODULE_ROOT / "main.lua").read_text(encoding="utf-8")

        self.assertIn("core_vehicle_partmgmt.setConfigOfVehicle", adapter)
        self.assertIn("backgroundTarget = true", main)
        self.assertIn('"background_owned"', adapter)

        candidate_block = main[
            main.index("local function recordReplacementCandidate"):
            main.index("local function issueReplacement")
        ]
        self.assertIn("productionModules.raceFocusGuard.restore", candidate_block)
        self.assertIn("playerVehicleId = active.lineupPlayerVehicleId", candidate_block)
        self.assertIn("candidateVehicleId = result.vehicleId", candidate_block)
        self.assertEqual(candidate_block.count("adapter.enterVehicle"), 1)
        self.assertIn("enterVehicle = adapter.enterVehicle", candidate_block)
        self.assertNotIn("lineupFocusSwitchInFlight", candidate_block)


if __name__ == "__main__":
    unittest.main()
