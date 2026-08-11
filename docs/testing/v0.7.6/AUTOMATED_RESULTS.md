# v0.7.6 automated results

Recorded on 2026-08-11 for the v0.7.6 release candidate.

## Result

Automated validation: **In progress until the final release freeze**.

Automation cannot prove live BeamNG gameplay, rendering, controller input, UI scale/safe-zone behavior, language rendering, third-party compatibility or performance. `LIVE_RESULTS.md` remains authoritative for live status.

## Required commands

| Command | Release-freeze result | Evidence to record |
| --- | --- | --- |
| `npm ci --ignore-scripts` | Pending final freeze | installed package/audit summary |
| `npm run validate:sfc` | Pending final freeze | compiled Vue SFC count |
| `npm run validate:graph` | Pending final freeze | files/imports and graph errors |
| `npm run validate:styles` | Pending final freeze | Runtime CSS/assets and forbidden references |
| `npm run test:ui` | Pending final freeze | JS contract assertions and mounted cases |
| `python -m unittest discover -s tests -v` | Pending final freeze | Python-discovered tests including Lua harness |
| Lua fixture suite | Passed during implementation | adversarial v0.7.6 ownership property suite included |
| `python tools/package_mod.py` twice | Pending final freeze | deterministic SHA-256 and byte equality |
| `python tools/validate_package.py` | Pending final freeze | allowlist, metadata and extracted graphs |
| `python tools/validate_release_gate.py --channel prerelease` | Pending final freeze | factual 0/0/0/54/0 live totals |

The tested runtime commit and final package/tag commit will be recorded after the freeze. Documentation-only post-release evidence does not change the tagged package.
