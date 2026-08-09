# v0.7.5 automated results

Recorded on 2026-08-09 for the v0.7.5 release candidate.

## Result

Automated validation: **Passed**.

These results do not prove live BeamNG gameplay, rendering, controller input,
UI scale/safe-zone behavior, language rendering, third-party compatibility or
performance. See `LIVE_RESULTS.md` for the separate live evidence state.

## Executed commands

| Command | Result | Evidence |
| --- | --- | --- |
| `npm ci --ignore-scripts` | Passed | 171 packages installed; production audit has 0 known vulnerabilities |
| `npm run validate:sfc` | Passed | 57 Vue SFC files compiled |
| `npm run validate:graph` | Passed | 85 files scanned, 81 reachable, 234 imports, 0 missing/case/cycle/export errors |
| `npm run validate:styles` | Passed | 1 Runtime CSS file, 1 local asset reference, 0 missing/remote/raw-Sass/source-map failures |
| `npm run test:ui` | Passed | 929 contract assertions and 16 mounted Vitest cases |
| `python -m unittest discover -s tests -v` | Passed | 65 Python-discovered tests |
| Lua fixture suite | Passed | 423 unique cases, 771 requirement mappings, 10,914 assertions |
| `python tools/package_mod.py` | Passed | deterministic ZIP/checksum/manifest emitted |
| `python tools/validate_package.py` | Passed | 208 allowlisted ZIP entries; module/style graphs revalidated from extraction |
| `python tools/validate_release_gate.py --channel prerelease` | Passed | 0 executed, 0 passed, 0 failed, 47 pending, 0 blocked live cases accepted only for prerelease |

The final package identity is recorded in `LIVE_RESULTS.md` after downloading
the published assets. Package identity printed before the release commit is
deliberately not treated as final evidence.
