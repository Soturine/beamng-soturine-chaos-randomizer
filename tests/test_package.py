from __future__ import annotations

from pathlib import Path
import hashlib
import re
import tempfile
import unittest
import zipfile

from tools import package_mod, validate_package, validate_release_gate


ROOT = Path(__file__).resolve().parents[1]


class PackageTests(unittest.TestCase):
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
            self.assertTrue({"lua", "ui", "settings"}.issubset(roots))
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
            package_mod.write_release_manifest(archive, root=ROOT)
            manifest = validate_package.validate_release_manifest(archive)
            self.assertEqual(manifest["tag"], f"v{package_mod.read_version(ROOT)}")
            self.assertEqual(manifest["generatorVersion"], 6)
            self.assertEqual(manifest["vehicleDNASchemaVersion"], 1)
            expected_counts = package_mod.test_counts(ROOT)
            self.assertEqual(manifest["tests"], expected_counts)
            self.assertEqual(manifest["tests"]["luaTestFunctionsUnique"], manifest["tests"]["luaExecutedCases"])
            self.assertEqual(manifest["tests"]["luaRequirementMappings"], 440)
            self.assertGreater(manifest["tests"]["luaAssertions"], manifest["tests"]["luaExecutedCases"])
            self.assertEqual(manifest["tests"]["interactiveExecuted"], 0)
            self.assertEqual(manifest["tests"]["interactivePassed"], 0)
            self.assertEqual(manifest["tests"]["interactiveFailed"], 0)
            if package_mod.read_version(ROOT) == "0.6.3":
                self.assertEqual(manifest["tests"]["interactivePending"], 110)
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

    def test_live_release_gate_rejects_pending_report(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            archive, _ = package_mod.package(Path(temporary), ROOT)
            with self.assertRaises(validate_release_gate.ReleaseGateError):
                validate_release_gate.validate_live_release(archive, ROOT)

    def test_live_release_gate_accepts_complete_exact_artifact_evidence(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            (root / "VERSION").write_text("0.6.3\n", encoding="utf-8")
            report_dir = root / "docs/testing/v0.6.3"
            report_dir.mkdir(parents=True)
            archive = root / "soturine_chaos_randomizer_0.6.3.zip"
            archive.write_bytes(b"exact-candidate")
            digest = hashlib.sha256(archive.read_bytes()).hexdigest()
            report_dir.joinpath("LIVE_TEST_REPORT.md").write_text(
                "\n".join((
                    "# Live test report — 0.6.3",
                    "Status: **executed and complete**.",
                    f"| Exact artifact | {archive.name} |",
                    f"| Bytes | {archive.stat().st_size} |",
                    f"| SHA-256 | {digest} |",
                    "| Result | Count |",
                    "| --- | ---: |",
                    "| Executed | 2 |",
                    "| Passed | 2 |",
                    "| Failed | 0 |",
                    "| Pending | 0 |",
                    "| Blocked | 0 |",
                )) + "\n",
                encoding="utf-8",
            )
            counts = validate_release_gate.validate_live_release(archive, root)
            self.assertEqual(counts["Passed"], 2)


if __name__ == "__main__":
    unittest.main()
