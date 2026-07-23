from __future__ import annotations

from pathlib import Path
import tempfile
import unittest
import zipfile

from tools import package_mod, validate_package


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


if __name__ == "__main__":
    unittest.main()
