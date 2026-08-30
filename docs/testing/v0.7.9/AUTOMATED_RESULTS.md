# v0.7.9 automated results

Status: **Passed on the release-candidate freeze**.

## Executed commands

| Command | Exit | Evidence |
| --- | ---: | --- |
| `npm ci --ignore-scripts` | 0 | 162 packages installed, 163 audited, 0 known vulnerabilities |
| `npm run validate:version` | 0 | canonical and derived version metadata synchronized at 0.7.9 |
| `npm run validate:sfc` | 0 | 58 Vue SFC files compiled; command parity: 69 emitted, 76 bridge/backend and 27 required Race commands |
| `npm run validate:graph` | 0 | 89 files scanned, 84 reachable, 248 imports; 0 missing/case/cycle/export errors |
| `npm run validate:styles` | 0 | 85 source files, 58 Vue files, 1 Runtime CSS and 1 local asset; 0 critical failures |
| `npm run test:ui` | 0 | 1,190 JavaScript contract checks and 34 mounted Vitest cases passed |
| `python -m unittest discover -s tests -v` | 0 | 69 Python-discovered tests passed |
| Lua fixture suite | 0 | 443 unique/executed cases, 838 requirement mappings and 14,261 assertions passed |
| `python tools/package_mod.py` twice | 0 | deterministic 212-entry ZIP; identical SHA-256 on both final frozen builds |
| `python tools/validate_package.py` | 0 | allowlist, version/legal metadata, PNGs, locales and extracted Vue/style graphs accepted |
| `python tools/validate_release_gate.py --channel prerelease` | 0 | 0 executed, 0 passed, 0 failed, 15 pending and 0 blocked live cases accepted |

Mounted synthetic tab/button p95 remained below the 50 ms automated test
budget. That timing and the contaminated-clock fixtures are regression signals,
not BeamNG FPS or gameplay-performance claims.

Automated evidence does not prove live gameplay, visible D3D11/D3D12/Vulkan
rendering, physical AI movement, controller/UINav, UI scale/safe zones,
language pixels, third-party compatibility or performance. All 15 v0.7.9 live
cases remain Pending owner validation.

The evidence-only commit that records these results is followed by a clean
package regeneration and gate pass. Documentation is not included in the mod
ZIP; the external manifest binds the final tagged commit.
