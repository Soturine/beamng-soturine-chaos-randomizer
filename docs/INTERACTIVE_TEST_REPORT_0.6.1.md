# Interactive Test Report 0.6.1

No v0.6.1 live BeamNG gameplay or UI execution has been performed in this delivery environment. The exact candidate has automated coverage and installed BeamNG Lua-console execution, but those are not interactive gameplay evidence.

## v0.6.1 result

| Status | Count |
|---|---:|
| Passed | 0 |
| Failed | 0 |
| Pending | 50 |
| Blocked | 0 |
| Total | 50 |

The 50 Pending cases are enumerated in [Interactive Test Plan 0.6.1](INTERACTIVE_TEST_PLAN_0.6.1.md). No screenshot was reused and no harness result was promoted to Passed.

## Historical observations that motivated the hotfix

These are v0.6.0 observations supplied with the v0.6.1 brief, not v0.6.1 executions. They therefore remain separate from the totals above.

| Historical workflow | Status on observed v0.6.0 behavior | v0.6.1 verification |
|---|---|---|
| Random Car without toggling pause | Failed | Pending |
| Scramble without toggling pause | Failed | Pending |
| Full Random without toggling pause | Failed | Pending |
| Race competitor generation without toggling pause | Failed | Pending |
| Race preset selector interaction/policy | Failed | Pending |
| Spawn/AI workflow | Blocked by missing successful Race cars | Pending |

An external `driver_assistance_angelo234` Lua error was also reported. v0.6.1 treats unrelated errors as insufficient evidence against the selected Randomizer configuration and preserves target ownership, but that mod remains a live compatibility case rather than a claimed fix.

## Automated evidence

- Local Python suite: **44/44 passed**.
- Lua suite executed by the installed BeamNG 0.38.6 console: **304/304 passed**.
- The Lua registry contains all **76** v0.6.1 mandatory automated requirement mappings.

This evidence supports implementation correctness under deterministic fixtures only. Gameplay validation remains Pending.
