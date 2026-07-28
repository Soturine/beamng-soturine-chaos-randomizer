# Automated test report — 0.6.6

Status: **Passed on the committed v0.6.6 release source**.

This report is deliberately separate from live validation. The automated gates
prove deterministic source behavior and package contracts; they do not prove
behavior in a running BeamNG world.

## Results

| Gate | Result |
| --- | --- |
| `python -m pytest -q` | Passed: 60 tests, 898 subtests |
| Lua production runner | Passed: 366 unique/executed cases, 7,911 assertions, 451 requirement mappings |
| `node --check ui/modules/apps/soturineChaosRandomizer/app.js` | Passed |
| `node tests/js/ui_math.test.js` | Passed: 27 checks |
| `python tools/validate_package.py` | Passed: 89 ZIP entries; PNG 250x120 RGBA |
| `python tools/validate_release_gate.py --channel prerelease` | Passed: experimental prerelease with live Pending disclosed |
| Three independent deterministic builds | Passed: identical byte count and SHA-256 |

## Release artifact

| Field | Value |
| --- | --- |
| Filename | `soturine_chaos_randomizer_0.6.6.zip` |
| Bytes | `FINAL_ZIP_BYTES` |
| SHA-256 | `FINAL_ZIP_SHA256` |
| Entries | 89 |
| Reproducibility | Three builds with identical bytes and SHA-256 |
| Manifest | `dist/release-manifest.json`; final source commit is recorded at build time |

The manifest also records 60 unique Python test methods, 18 package-test
methods, one Node syntax file, two JSON files and three YAML files.

Live BeamNG gameplay: **0 executed / 0 passed / 0 failed / 99 pending / 0 blocked**.
