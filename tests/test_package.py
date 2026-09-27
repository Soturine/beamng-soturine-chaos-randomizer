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
    def test_json_manifest_count_ignores_environment_dependencies(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            (root / "ui").mkdir()
            (root / "ui" / "app.json").write_text("{}", encoding="utf-8")
            (root / "node_modules" / "pkg").mkdir(parents=True)
            (root / "node_modules" / "pkg" / "package.json").write_text("{}", encoding="utf-8")
            (root / ".pytest_cache").mkdir()
            (root / ".pytest_cache" / "state.json").write_text("{}", encoding="utf-8")
            self.assertEqual(
                [path.relative_to(root).as_posix() for path in package_mod.project_json_files(root)],
                ["ui/app.json"],
            )

    def test_release_branch_falls_back_to_main_for_detached_tag_checkout(self) -> None:
        detached = mock.Mock(returncode=0, stdout="")
        with mock.patch.object(package_mod.subprocess, "run", return_value=detached):
            with mock.patch.dict("os.environ", {}, clear=True):
                self.assertEqual(package_mod.get_branch_name(ROOT), "main")

    @classmethod
    def setUpClass(cls) -> None:
        # One build serves every artifact assertion; one rebuild proves determinism.
        cls._temporary = tempfile.TemporaryDirectory()
        cls.version = package_mod.read_version(ROOT)
        cls.archive, cls.checksum = package_mod.package(Path(cls._temporary.name) / "first", ROOT)
        cls.manifest_path = package_mod.write_release_manifest(cls.archive, root=ROOT)

    @classmethod
    def tearDownClass(cls) -> None:
        cls._temporary.cleanup()

    def test_package_contents_are_the_mod_allowlist_without_wrapper(self) -> None:
        names = validate_package.validate_archive(self.archive, self.version)
        for required in (
            "lua/ge/extensions/soturineChaosRandomizer.lua",
            "ui/modules/apps/soturineChaosRandomizer/app.png",
            "ui/modules/apps/soturineChaosRandomizer/assets/branding/fox-64.png",
            "locales/translations/pt-BR/main.translation.json",
        ):
            self.assertIn(required, names)
        roots = {name.split("/", 1)[0] for name in names}
        self.assertTrue({"lua", "ui", "settings", "locales"}.issubset(roots))
        self.assertNotIn("soturine_chaos_randomizer", roots)
        with zipfile.ZipFile(self.archive) as value:
            self.assertEqual(value.read("VERSION").decode("utf-8").strip(), self.version)

    def test_package_metadata_is_normalized_and_free_of_machine_paths(self) -> None:
        pattern = re.compile(rb"(?:[A-Za-z]:\\|/" + rb"Users/|/" + rb"home/)")
        with zipfile.ZipFile(self.archive) as value:
            names = [info.filename for info in value.infolist()]
            self.assertEqual(names, sorted(names))
            for info in value.infolist():
                self.assertEqual(info.date_time, package_mod.FIXED_TIMESTAMP)
                self.assertEqual(info.create_system, 3)
                self.assertEqual(info.external_attr >> 16, 0o100644)
                data = value.read(info)
                if not info.filename.endswith(".png"):
                    self.assertIsNone(pattern.search(data), info.filename)
                path = Path(info.filename)
                if path.suffix.lower() in package_mod.TEXT_SUFFIXES or info.filename in package_mod.TEXT_FILENAMES:
                    self.assertNotIn(b"\r", data)

    def test_checksum_and_manifest_describe_the_zip(self) -> None:
        expected = hashlib.sha256(self.archive.read_bytes()).hexdigest()
        self.assertEqual(self.checksum.read_text(encoding="ascii"), f"{expected}  {self.archive.name}\n")
        validate_package.validate_checksum(self.archive)
        manifest = validate_package.validate_release_manifest(self.archive)
        identity = package_mod.release_identity(self.version)
        self.assertEqual(manifest["tag"], identity["tag"])
        self.assertEqual(manifest["sha256"], expected)
        self.assertEqual(manifest["manifestVersion"], 4)
        self.assertEqual(manifest["primaryBeamNGTarget"], "0.39.4")
        self.assertEqual(manifest["minimumBeamNGVersion"], "0.39")
        self.assertEqual(manifest["automatedValidation"]["command"], "npm run verify")
        self.assertEqual(manifest["liveValidation"]["executed"], 0)

    def test_package_and_manifest_are_reproducible(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            second, _ = package_mod.package(Path(temporary), ROOT)
            second_manifest = package_mod.write_release_manifest(second, root=ROOT)
            self.assertEqual(second.read_bytes(), self.archive.read_bytes())
            self.assertEqual(second_manifest.read_bytes(), self.manifest_path.read_bytes())

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
