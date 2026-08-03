# v0.7.1 automated test report

Status: **Passed**.

| Layer | Result |
|---|---:|
| Python test methods | 50 passed |
| Unique Lua cases | 398 passed |
| Lua assertions | 9,217 passed |
| Lua requirement mappings | 664 covered |
| JavaScript/Vue assertions | 779 passed |
| Vue SFC files compiled | 55 passed |
| Module references scanned | 193 passed |

JSON parsing, JavaScript syntax, SFC compilation, source module-graph
validation, service/store/protocol tests, static component contracts, Python,
Lua, deterministic packaging, extracted-ZIP graph validation, checksums,
manifest validation, reproducibility, and the prerelease gate pass.

The lifecycle test covers **100 registry cleanup cycles**. It is not a live
BeamNG AppHost mount test. Actual mounted Vue component tests are **not
implemented**; live AppHost validation remains **Pending owner validation**.
