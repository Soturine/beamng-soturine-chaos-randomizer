from __future__ import annotations

import json
from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]
FIXTURE = ROOT / "tests/fixtures/v0.7.3/beamng-0.39.4.json"


class BeamNG0394FixtureTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.value = json.loads(FIXTURE.read_text(encoding="utf-8"))

    def test_registry_identity_is_not_a_display_label_or_filename(self) -> None:
        configuration = self.value["registry"]["configuration"]
        self.assertEqual(self.value["targetBeamNG"], "0.39.4")
        self.assertEqual(len({configuration["registryKey"], configuration["displayName"], configuration["filename"]}), 3)
        self.assertEqual([state["status"] for state in self.value["registry"]["stateSequence"]], ["warming_up", "ready"])

    def test_family_subgroups_and_incomplete_metadata_stay_distinct(self) -> None:
        families = self.value["families"]
        self.assertEqual(families[0]["familyKey"], families[1]["familyKey"])
        self.assertNotEqual(families[0]["subgroupKey"], families[1]["subgroupKey"])
        self.assertNotEqual(families[1]["familyKey"], families[2]["familyKey"])
        self.assertIsNone(self.value["incompleteModConfiguration"]["vars"])

    def test_missing_and_empty_jbeam_descriptions_are_explicit(self) -> None:
        parts = {part["name"]: part for part in self.value["parts"]}
        self.assertNotIn("description", parts["fixture_trim_missing_description"])
        self.assertEqual(parts["fixture_trim_empty_description"]["description"], "")
        self.assertNotIn("slotType", parts["fixture_unknown_slot"])

    def test_failure_identity_and_ai_cases_are_reproducible(self) -> None:
        events = self.value["events"]
        self.assertTrue(events["instability"]["removed"])
        self.assertFalse(events["spawnRefused"]["apiResult"])
        self.assertNotEqual(events["identityDivergence"]["playerVehicleId"], events["identityDivergence"]["playerObjectId"])
        self.assertNotEqual(events["reusedId"]["oldGeneration"], events["reusedId"]["newGeneration"])
        self.assertTrue(self.value["managedAI"]["policy"]["driveInLane"])

    def test_resource_incidents_have_distinct_expected_classifications(self) -> None:
        incidents = self.value["resourceIncidents"]
        self.assertEqual(len({incident["expected"] for incident in incidents}), 3)
        self.assertTrue(all(incident["peakOwnedTemporaryCount"] <= incident["contractLimit"] or incident["expected"] == "mod_cardinality_violation" for incident in incidents))


if __name__ == "__main__":
    unittest.main()
