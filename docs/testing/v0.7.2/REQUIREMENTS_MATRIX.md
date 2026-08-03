# v0.7.2 requirements matrix

| Requirement | Implementation | Automated evidence | Live evidence |
| --- | --- | --- | --- |
| Runtime CSS and restored hierarchy | `app.css`, `app.vue` | SFC/style graph/static tests | A01-A10 pending |
| Mounted Vue lifecycle | AppShell/lifecycle/responsive composable | mounted Vitest, 100 cycles | B07 pending |
| local UI latency and diffs | layout/domain stores, protocol | mounted p95/diff tests | B01-B08 pending |
| Random Car cardinality | shared domain operation context | Lua cardinality fixtures | RC01-RC20 pending |
| Scramble same target | same-target action contract | Lua no-spawn/world-delta fixtures | SC01-SC20 pending |
| Full Random binding | concrete target binding state machine | Lua retry/stale/rollback fixtures | FR01-FR10 pending |
| independent Race slots | Race manager/coordinator/scheduler | Lua 1/4/8/12 and failure fixtures | D01-D04 pending |
| stability bounds | limits/watchdog/scheduler | Lua timeout/limit fixtures | F01-F59 pending |
| Spanish and auto locale | three catalogs, i18n service/preferences | parity/mapping/migration tests | E01-E07 pending |
| deterministic release | package and validators | ZIP/checksum/manifest twice | downloaded assets pending |

P0 ownership/cardinality, P1 performance infrastructure, and P2 module/i18n
regressions remain in the full suite. Historical live failures remain unchanged.

