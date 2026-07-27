# Interactive Test Report 0.6.1

Post-release live BeamNG gameplay was performed by the project owner against v0.6.1 and reproduced eight release-blocking lifecycle failures. The delivery environment itself did not perform the complete 50-case candidate plan. Automated coverage and installed BeamNG Lua-console execution are not interactive gameplay evidence.

## v0.6.1 result

| Status | Count |
|---|---:|
| Passed | 0 |
| Failed | 8 |
| Pending | 50 |
| Blocked | 0 |
| Total | 58 |

The eight Failed rows below are post-release regression evidence supplied by the project owner. The separate 50-case release-candidate plan remains Pending because it was not executed and recorded case by case. No screenshot was reused and no harness result was promoted to Passed.

## Post-release v0.6.1 gameplay failures

| Observed requirement | Status | Evidence |
|---|---|---|
| Pause-independent Random Car | Failed | Buttons remained unavailable; phase stopped at `tracking_target_identity` around 22%; pausing was required for progress. |
| Pause-independent Scramble | Failed | The same Busy/stall behavior required a pause transition. |
| Pause-independent Full Random | Failed | The operation stalled and could recover only after a pause transition. |
| Target ownership after spawn | Failed | A visually selected replacement did not remain the authoritative mutation/recovery target. |
| No return to previous vehicle | Failed | Resuming or recovery could restore the prior vehicle instead of completing on the selected target. |
| Busy/stall recovery | Failed | `Operation appears stalled` remained visible and actions stayed unavailable until a pause transition or timeout/recovery. |
| Recovery loop prevention | Failed | Clean/new and prior-randomized states alternated across attempts, including reuse of an old randomized state. |
| Full Random complete pipeline | Failed / Partial | A new vehicle could load without a verified Parts -> Tuning -> Paint -> final-readback completion on that same target. |

Representative observed content included Wigeon, Jetta Taxi, Golf, Focus, Duster, Peugeot 2008, and other mod vehicles/configurations. Actual messages included target stabilization timeout, critical/required parts missing after reload, partial coverage rejected, and vehicle recovery completed. These outcomes remain historical failures even if v0.6.2 later passes its own separate plan.

## Earlier v0.6.0 observations that also motivated v0.6.1

These are older v0.6.0 observations supplied with the v0.6.1 brief, not the v0.6.1 executions listed above. They remain separate from the totals above.

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
