from __future__ import annotations

from pathlib import Path
import hashlib
import re
import tempfile
import unittest
from unittest import mock
import zipfile

from tools import package_mod, validate_package, validate_release_gate


ROOT = Path(__file__).resolve().parents[1]


class PackageTests(unittest.TestCase):
    def test_release_branch_falls_back_to_main_for_detached_tag_checkout(self) -> None:
        detached = mock.Mock(returncode=0, stdout="")
        with mock.patch.object(package_mod.subprocess, "run", return_value=detached):
            with mock.patch.dict("os.environ", {}, clear=True):
                self.assertEqual(package_mod.get_branch_name(ROOT), "main")

    def test_package_paths_and_reproducibility(self) -> None:
        version = package_mod.read_version(ROOT)
        with tempfile.TemporaryDirectory() as temporary:
            output = Path(temporary)
            archive, checksum = package_mod.package(output, ROOT)
            names = validate_package.validate_archive(archive, version)
            validate_package.validate_checksum(archive)
            validate_package.validate_reproducible(archive, ROOT)
            self.assertTrue(checksum.is_file())
            self.assertIn("lua/ge/extensions/soturineChaosRandomizer.lua", names)
            self.assertIn("ui/modules/apps/soturineChaosRandomizer/app.png", names)
            self.assertIn("ui/modules/apps/soturineChaosRandomizer/assets/fox-mark.svg", names)
            self.assertIn("locales/translations/en-US/main.translation.json", names)
            self.assertIn("locales/translations/pt-BR/main.translation.json", names)
            self.assertIn("locales/translations/es-ES/main.translation.json", names)
            self.assertFalse(any(name.startswith("soturine_chaos_randomizer/") for name in names))

    def test_rejects_backslash_paths(self) -> None:
        version = package_mod.read_version(ROOT)
        with tempfile.TemporaryDirectory() as temporary:
            archive = Path(temporary) / f"{package_mod.ARCHIVE_PREFIX}{version}.zip"
            with zipfile.ZipFile(archive, "w") as value:
                value.writestr("lua\\unsafe.lua", "return {}")
            with self.assertRaises(validate_package.PackageValidationError):
                validate_package.validate_archive(archive, version)

    def test_rejects_development_content(self) -> None:
        with self.assertRaises(validate_package.PackageValidationError):
            validate_package._validate_member_name("tests/test_something.py")

    def test_package_is_reproducible_twice(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            output = Path(temporary)
            first, _ = package_mod.package(output / "first", ROOT)
            second, _ = package_mod.package(output / "second", ROOT)
            self.assertEqual(first.read_bytes(), second.read_bytes())

    def test_sha256_file_matches_zip(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            archive, checksum = package_mod.package(Path(temporary), ROOT)
            expected = hashlib.sha256(archive.read_bytes()).hexdigest()
            self.assertEqual(checksum.name, f"{archive.name}.sha256")
            self.assertEqual(checksum.read_text(encoding="ascii"), f"{expected}  {archive.name}\n")

    def test_package_contains_expected_version(self) -> None:
        version = package_mod.read_version(ROOT)
        with tempfile.TemporaryDirectory() as temporary:
            archive, _ = package_mod.package(Path(temporary), ROOT)
            with zipfile.ZipFile(archive) as value:
                self.assertEqual(value.read("VERSION").decode("utf-8").strip(), version)

    def test_package_contains_no_machine_paths(self) -> None:
        pattern = re.compile(rb"(?:[A-Za-z]:\\|/" + rb"Users/|/" + rb"home/)")
        with tempfile.TemporaryDirectory() as temporary:
            archive, _ = package_mod.package(Path(temporary), ROOT)
            with zipfile.ZipFile(archive) as value:
                for info in value.infolist():
                    if not info.filename.endswith(".png"):
                        self.assertIsNone(pattern.search(value.read(info)), info.filename)

    def test_package_root_has_no_wrapper(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            archive, _ = package_mod.package(Path(temporary), ROOT)
            names = validate_package.validate_archive(archive, package_mod.read_version(ROOT))
            roots = {name.split("/", 1)[0] for name in names}
            self.assertTrue({"lua", "ui", "settings", "locales"}.issubset(roots))
            self.assertNotIn("soturine_chaos_randomizer", roots)

    def test_package_metadata_is_normalized(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            archive, _ = package_mod.package(Path(temporary), ROOT)
            with zipfile.ZipFile(archive) as value:
                names = [info.filename for info in value.infolist()]
                self.assertEqual(names, sorted(names))
                for info in value.infolist():
                    self.assertEqual(info.date_time, package_mod.FIXED_TIMESTAMP)
                    self.assertEqual(info.create_system, 3)
                    self.assertEqual(info.external_attr >> 16, 0o100644)
                    path = Path(info.filename)
                    if path.suffix.lower() in package_mod.TEXT_SUFFIXES or info.filename in package_mod.TEXT_FILENAMES:
                        self.assertNotIn(b"\r", value.read(info))

    def test_release_manifest_matches_zip(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            archive, _ = package_mod.package(Path(temporary), ROOT)
            manifest_path = package_mod.write_release_manifest(archive, root=ROOT)
            self.assertEqual(manifest_path.name, f"{archive.stem}.manifest.json")
            manifest = validate_package.validate_release_manifest(archive)
            identity = package_mod.release_identity(package_mod.read_version(ROOT))
            self.assertEqual(manifest["tag"], identity["tag"])
            self.assertEqual(manifest["publicationAllowed"], identity["publicationAllowed"])
            self.assertEqual(manifest["releaseStatus"], "published")
            self.assertTrue(manifest["prerelease"])
            self.assertEqual(manifest["branch"], "main")
            self.assertEqual(manifest["generatorVersion"], 8)
            self.assertEqual(manifest["vehicleDNASchemaVersion"], 1)
            self.assertEqual(manifest["vehicleDNAGeneratorVersion"], 6)
            expected_counts = package_mod.test_counts(ROOT)
            self.assertEqual(manifest["tests"], expected_counts)
            self.assertEqual(manifest["tests"]["luaTestFunctionsUnique"], manifest["tests"]["luaExecutedCases"])
            self.assertGreater(manifest["tests"]["luaRequirementMappings"], 0)
            self.assertGreater(manifest["tests"]["javaScriptChecks"], 0)
            self.assertGreater(manifest["tests"]["vueModuleGraphFiles"], 0)
            self.assertGreater(manifest["tests"]["vueModuleGraphReachableFiles"], 0)
            self.assertGreater(manifest["tests"]["vueModuleGraphImports"], 0)
            self.assertGreater(manifest["tests"]["vueModuleGraphProjectImports"], 0)
            self.assertEqual(manifest["tests"]["vueModuleGraphDirectoryImports"], 0)
            self.assertEqual(manifest["tests"]["vueModuleGraphMissingModules"], 0)
            self.assertEqual(manifest["tests"]["vueModuleGraphCaseMismatches"], 0)
            self.assertEqual(manifest["tests"]["vueModuleGraphCycles"], 0)
            self.assertEqual(manifest["tests"]["vueModuleGraphNamedExportErrors"], 0)
            self.assertGreater(manifest["tests"]["luaAssertions"], manifest["tests"]["luaExecutedCases"])
            self.assertEqual(manifest["tests"]["interactiveExecuted"], 0)
            self.assertEqual(manifest["tests"]["interactivePassed"], 0)
            self.assertEqual(manifest["tests"]["interactiveFailed"], 0)
            self.assertEqual(manifest["automatedValidation"]["status"], "passed")
            self.assertEqual(manifest["liveValidation"]["status"], "pending_owner_validation")
            self.assertEqual(manifest["liveValidation"]["executed"], 0)
            for field in (
                "modVersion", "commit", "branch", "tag", "releaseStage",
                "primaryBeamNGTarget", "minimumBeamNGVersion",
                "detectedOrDeclaredCompatibility", "automatedTests", "liveTests",
                "fileCount", "zipSize", "zipSha256", "buildTimestamp",
            ):
                self.assertIn(field, manifest)
            self.assertEqual(manifest["primaryBeamNGTarget"], "0.39.4")
            self.assertEqual(manifest["minimumBeamNGVersion"], "0.39")
            self.assertEqual(manifest["liveTests"]["status"], "Pending owner validation")
            if package_mod.read_version(ROOT) == "0.6.3":
                self.assertEqual(manifest["tests"]["interactivePending"], 110)
            if package_mod.read_version(ROOT) == "0.6.7":
                self.assertEqual(manifest["tests"]["interactivePending"], 48)
            self.assertEqual(manifest["tests"]["interactiveBlocked"], 0)

    def test_release_manifest_is_reproducible(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            first_dir = Path(temporary) / "first"
            second_dir = Path(temporary) / "second"
            first, _ = package_mod.package(first_dir, ROOT)
            second, _ = package_mod.package(second_dir, ROOT)
            first_manifest = package_mod.write_release_manifest(first, root=ROOT)
            second_manifest = package_mod.write_release_manifest(second, root=ROOT)
            self.assertEqual(first_manifest.read_bytes(), second_manifest.read_bytes())

    def _write_release_gate_fixture(
        self,
        root: Path,
        counts: dict[str, int],
        *,
        pending_owner: bool,
        include_identity: bool = True,
    ) -> Path:
        (root / "VERSION").write_text("0.6.3\n", encoding="utf-8")
        report_dir = root / "docs/testing/v0.6.3"
        notes_dir = root / "docs/RELEASE NOTES"
        report_dir.mkdir(parents=True)
        notes_dir.mkdir(parents=True)
        archive = root / "soturine_chaos_randomizer_0.6.3.zip"
        archive.write_bytes(b"exact-candidate")
        identity = ()
        if include_identity:
            identity = (
                f"| Exact artifact | {archive.name} |",
                f"| Bytes | {archive.stat().st_size} |",
                f"| SHA-256 | {hashlib.sha256(archive.read_bytes()).hexdigest()} |",
            )
        status = "Pending owner validation; not executed" if pending_owner else "executed and complete"
        report_dir.joinpath("LIVE_TEST_REPORT.md").write_text(
            "\n".join((
                "# Live test report — 0.6.3",
                f"Status: **{status}**.",
                "| Field | Value |",
                "| --- | --- |",
                "| Release version | 0.6.3 |",
                "| Target commit | fixture commit |",
                "| Validation owner | repository owner |",
                *identity,
                "| Result | Count |",
                "| --- | ---: |",
                *(f"| {name} | {counts[name]} |" for name in validate_release_gate.REPORT_STATUSES),
            )) + "\n",
            encoding="utf-8",
        )
        notes_dir.joinpath("RELEASE_NOTES_0.6.3.md").write_text(
            "\n".join((
                "# Soturine's Chaos Randomizer 0.6.3",
                "Status: **Experimental prerelease — live validation pending owner test**.",
                "Automated validation: Passed",
                "Live BeamNG validation: Pending owner validation",
                "Live cases: 0 executed / 0 passed / 0 failed / 110 pending / 0 blocked",
            )) + "\n",
            encoding="utf-8",
        )
        return archive

    def test_prerelease_gate_accepts_pending_owner_validation(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            counts = {"Executed": 0, "Passed": 0, "Failed": 0, "Pending": 110, "Blocked": 0}
            archive = self._write_release_gate_fixture(root, counts, pending_owner=True)
            with mock.patch.object(validate_release_gate, "_validate_candidate_artifacts", return_value={}):
                self.assertEqual(validate_release_gate.validate_prerelease_candidate(archive, root), counts)

    def test_prerelease_gate_rejects_failed_cases(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            counts = {"Executed": 1, "Passed": 0, "Failed": 1, "Pending": 109, "Blocked": 0}
            archive = self._write_release_gate_fixture(root, counts, pending_owner=True)
            with self.assertRaises(validate_release_gate.ReleaseGateError):
                validate_release_gate.validate_prerelease_candidate(archive, root)

    def test_prerelease_gate_rejects_blocked_cases(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            counts = {"Executed": 1, "Passed": 0, "Failed": 0, "Pending": 109, "Blocked": 1}
            archive = self._write_release_gate_fixture(root, counts, pending_owner=True)
            with self.assertRaises(validate_release_gate.ReleaseGateError):
                validate_release_gate.validate_prerelease_candidate(archive, root)

    def test_prerelease_gate_rejects_inconsistent_counts(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            counts = {"Executed": 0, "Passed": 1, "Failed": 0, "Pending": 109, "Blocked": 0}
            archive = self._write_release_gate_fixture(root, counts, pending_owner=True)
            with self.assertRaises(validate_release_gate.ReleaseGateError):
                validate_release_gate.validate_prerelease_candidate(archive, root)

    def test_validated_gate_rejects_pending_report(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            counts = {"Executed": 0, "Passed": 0, "Failed": 0, "Pending": 110, "Blocked": 0}
            archive = self._write_release_gate_fixture(root, counts, pending_owner=True)
            with self.assertRaises(validate_release_gate.ReleaseGateError):
                validate_release_gate.validate_live_release(archive, root)

    def test_validated_gate_requires_exact_artifact_identity(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            counts = {"Executed": 2, "Passed": 2, "Failed": 0, "Pending": 0, "Blocked": 0}
            archive = self._write_release_gate_fixture(
                root, counts, pending_owner=False, include_identity=False,
            )
            with self.assertRaises(validate_release_gate.ReleaseGateError):
                validate_release_gate.validate_live_release(archive, root)

    def test_validated_gate_accepts_complete_exact_live_evidence(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            counts = {"Executed": 2, "Passed": 2, "Failed": 0, "Pending": 0, "Blocked": 0}
            archive = self._write_release_gate_fixture(root, counts, pending_owner=False)
            with mock.patch.object(validate_release_gate, "_validate_candidate_artifacts", return_value={}):
                self.assertEqual(validate_release_gate.validate_live_release(archive, root), counts)


if __name__ == "__main__":
    unittest.main()
