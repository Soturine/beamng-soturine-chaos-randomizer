# v0.7.3 automated results

Final source/test status: **Passed** at commit `5baf0c9`. The first frozen package
was built from evidence commit `176f7b9`; the final tag rebuild changes only the
manifest commit field, not deterministic ZIP bytes.

Environment: Windows 10 19045, PowerShell, Node 24-compatible toolchain, Python
3, and the BeamNG 0.39.4.0 console as the Lua 5.1-compatible runner.

| Command | Result | Duration | Commit | Notes |
| --- | --- | ---: | --- | --- |
| `npm ci --ignore-scripts` | Passed | 4.311 s | `5baf0c9` | 171 installed; 172 audited; 0 vulnerabilities |
| `npm run validate:version` | Passed | 0.711 s | `5baf0c9` | `VERSION_SYNC_OK 0.7.3` |
| `npm run validate:sfc` | Passed | 2.295 s | `5baf0c9` | 57 SFC files |
| `npm run validate:graph` | Passed | 0.825 s | `5baf0c9` | 84 scanned; 80 reachable; 227 imports; 0 errors |
| `npm run validate:styles` | Passed | 0.811 s | `5baf0c9` | 1 runtime CSS; 0 SCSS paths/source maps/errors |
| `npm run test:ui` | Passed | 21.572 s | `5baf0c9` | 911 service checks + 11 mounted tests |
| `python -m unittest discover -s tests -v` | Passed | 19.575 s | `5baf0c9` | 63 methods, including 409 Lua cases / 10,417 assertions |
| `python tools/package_mod.py` | Passed | 5.353 s | `176f7b9` | 197 entries; 467,527 bytes; ZIP/SHA/manifest |
| `python tools/validate_package.py` | Passed | 1.510 s | `176f7b9` | structure, checksum, UTF-8 names, forbidden files, graph/style, rebuild |

Additional recorded metrics: 707 Lua requirement mappings; mounted synthetic
tab p95 13.205 ms and button p95 8.354 ms; 12 runtime aliases, 177 project
imports, no directory imports/cycles/missing modules/case/export errors. Direct
`sass` dependency check (`npm ls sass --depth=0`) is empty; any Sass names left
in the lockfile are optional peer declarations of development tooling, not an
installed or packaged runtime dependency.

The first full Python attempt correctly failed one historical test expectation
that still required target `0.39`; the assertion was updated to the canonical
`0.39.4` target, committed as `5baf0c9`, and the entire 63-test suite was rerun
successfully. No failing gate was waived.

Package SHA-256:
`b89bfc2fc12e41d33557a4571f50b7f28b1b76a987a54eacc340409ff87a451b`.
The package contains 197 normalized UTF-8 entries rooted at `lua/`, `ui/`,
`settings/`, and `locales/` plus compatibility/legal/version files. The package
tests and validator rebuild the ZIP and compare bytes, reject development files,
wrapper/nested archives, `node_modules`, source maps, malformed paths, and
non-normalized metadata.

Live BeamNG validation is separate and remains **Pending owner validation**.
