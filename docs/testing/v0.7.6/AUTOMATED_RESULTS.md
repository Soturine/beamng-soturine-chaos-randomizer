# v0.7.6 automated results

Recorded on 2026-08-11 for runtime candidate commit `7cd370c0f637ce6ea646e1c51c60c1fba63e14e8`.

## Result

Automated validation: **Passed**.

Automation cannot prove live BeamNG gameplay, rendering, controller input, UI scale/safe-zone behavior, language rendering, third-party compatibility or performance. `LIVE_RESULTS.md` remains authoritative for live status.

## Executed commands

| Command | Result | Evidence |
| --- | --- | --- |
| `npm ci --ignore-scripts` | Passed | 162 packages installed, 163 audited; production and full audit each reported 0 known vulnerabilities |
| `npm run validate:sfc` | Passed | 57 Vue SFC files compiled |
| `npm run validate:graph` | Passed | 87 files scanned, 83 reachable, 240 imports; 0 missing/case/cycle/export errors |
| `npm run validate:styles` | Passed | 83 source files, 57 Vue files, 1 Runtime CSS and 1 local asset; 0 missing/remote/raw-Sass/source-map failures |
| `npm run test:ui` | Passed | 1,057 JavaScript contract assertions and 24 mounted Vitest cases; synthetic tab/button p95 remained below the 50 ms test budget |
| `python -m unittest discover -s tests -v` | Passed | 66 Python-discovered tests, including package and Lua wrapper checks |
| Lua fixture suite | Passed | 430 unique functions/cases, 790 requirement mappings, 13,761 assertions |
| `python tools/package_mod.py` twice | Passed | both runs emitted 208 entries, 1,413,696 bytes and SHA-256 `4b214affb13f4097812516c152f8544175680c42b54b5bff3c4f310a957767e5` |
| `python tools/validate_package.py` | Passed | allowlist, metadata, icon, generated fox PNGs and extracted Vue/style graphs validated |
| `python tools/validate_release_gate.py --channel prerelease` | Passed | 0 executed, 0 passed, 0 failed, 54 pending, 0 blocked live cases |

Observed wall-clock durations were about 5 seconds for install, 4 seconds for the three frontend graph gates, 21 seconds for UI tests, 28 seconds for the full Python suite and 16 seconds for the two package builds plus package/release validation. These are execution records from this machine, not BeamNG performance claims.

The documentation-only evidence commit is followed by a final package regeneration and gate pass. The external manifest and post-release verification bind the final tag/package commit; post-release documentation does not move the tag.
