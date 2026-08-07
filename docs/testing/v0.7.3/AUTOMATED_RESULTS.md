# v0.7.3 automated results

Final status: **release gate in progress**. This file is frozen with exact
commands, durations, counts, commit, package hash, and reproducibility evidence
before the release tag is created.

Environment: Windows 10 19045, PowerShell, Node 24-compatible toolchain, Python
3, and the BeamNG 0.39.4.0 console as the Lua 5.1-compatible runner.

| Command | Result | Duration | Commit | Notes |
| --- | --- | ---: | --- | --- |
| `npm ci --ignore-scripts` | Pending final gate | — | — | clean dependency install |
| `npm run validate:version` | Pending final gate | — | — | canonical metadata |
| `npm run validate:sfc` | Pending final gate | — | — | Vue compilation |
| `npm run validate:graph` | Pending final gate | — | — | module graph |
| `npm run validate:styles` | Pending final gate | — | — | plain CSS/package graph |
| `npm run test:ui` | Pending final gate | — | — | pure and mounted UI |
| `python -m unittest discover -s tests -v` | Pending final gate | — | — | Lua, fixtures, docs, package |
| `python tools/package_mod.py` | Pending final gate | — | — | deterministic ZIP/SHA/manifest |
| `python tools/validate_package.py` | Pending final gate | — | — | structure/checksum/rebuild |

Live BeamNG validation is separate and remains **Pending owner validation**.
