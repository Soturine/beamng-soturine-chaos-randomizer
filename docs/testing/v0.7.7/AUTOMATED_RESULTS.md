# v0.7.7 automated results

Recorded on 2026-08-13 for release candidate commit
`1cedc4efd8d0db99c2243e5f4a0639dce809b6ef`.

## Result

Automated validation: **Passed**.

Automation cannot prove live BeamNG gameplay, rendering, controller input, UI
scale/safe-zone behavior, language rendering, third-party compatibility or
performance. `LIVE_RESULTS.md` remains authoritative for live status.

## Executed commands

| Command | Result | Evidence |
| --- | --- | --- |
| `npm ci --ignore-scripts` | Passed | 162 packages installed, 163 audited, 0 known vulnerabilities |
| `npm run validate:sfc` | Passed | 58 Vue SFC files compiled |
| `npm run validate:graph` | Passed | 88 files scanned, 83 reachable, 245 imports; 0 missing/case/cycle/export errors |
| `npm run validate:styles` | Passed | 84 source files, 58 Vue files, 1 Runtime CSS and 1 local asset; 0 missing/remote/raw-Sass/source-map failures |
| `npm run test:ui` | Passed | 1,067 JavaScript contract assertions and 31 mounted Vitest cases; synthetic tab/button p95 below the 50 ms test budget |
| `python -m unittest discover -s tests -v` | Passed | 66 Python-discovered tests, including package and Lua wrapper checks |
| Lua fixture suite | Passed | 435 unique functions/cases, 813 requirement mappings, 14,084 assertions |
| `python tools/package_mod.py` twice | Passed | both runs emitted 209 entries, 1,427,722 bytes and SHA-256 `466e01b616330c3c923836cb325a1fdc6c880bfaf410ceb046bad1e55edee475` |
| `python tools/validate_package.py` | Passed | allowlist, version/legal metadata, transparent fox PNGs, locales and extracted Vue/style graphs validated |
| `python tools/validate_release_gate.py --channel prerelease` | Passed | 0 executed, 0 passed, 0 failed, 11 pending, 0 blocked live cases |

Observed wall-clock durations were about 4 seconds for install, 27 seconds for
the four frontend gates, 27 seconds for the full Python suite, 6 seconds for the
explicit Lua metrics run and 18 seconds for the two package builds plus package
and prerelease validation. These machine timings are not BeamNG performance
claims.

The evidence-only commit that records these results is followed by a final
package regeneration and gate pass. Documentation is not included in the mod
ZIP; the external manifest binds the final tagged commit.
