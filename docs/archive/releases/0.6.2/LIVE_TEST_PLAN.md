# Interactive Test Plan 0.6.2

This is the exact live-game plan for the final `v0.6.2` artifact. Automated fixtures do not change a row to Passed. Record the final ZIP SHA-256, BeamNG build, enabled-mod set, seed, model/config, duration, terminal phase, result code, recovery tier, whether the old vehicle returned, and whether a pause toggle was needed.

## Required environment

- BeamNG `0.38.6.0.19963`; only the final `v0.6.2` ZIP of this mod installed.
- Older Randomizer versions disabled/removed; cache cleaned; all locks unlocked; Random seed mode.
- Controlled A: `driver_assistance_angelo234` disabled. Environment B: restore third-party mods only in the named groups.
- Any unrelated third-party Lua failure is recorded separately and is not modified by this project.

## Controlled A — 30 unpaused runs

| ID | Action | Run | Expected | Status |
|---|---|---:|---|---|
| A-RC01 | Random Car | 1 | New target retained; model/config final readback; Busy ends | Pending |
| A-RC02 | Random Car | 2 | Same | Pending |
| A-RC03 | Random Car | 3 | Same | Pending |
| A-RC04 | Random Car | 4 | Same | Pending |
| A-RC05 | Random Car | 5 | Same | Pending |
| A-RC06 | Random Car | 6 | Same | Pending |
| A-RC07 | Random Car | 7 | Same | Pending |
| A-RC08 | Random Car | 8 | Same | Pending |
| A-RC09 | Random Car | 9 | Same | Pending |
| A-RC10 | Random Car | 10 | Same | Pending |
| A-SC01 | Scramble | 1 | Current target retained; complete pipeline; Busy ends | Pending |
| A-SC02 | Scramble | 2 | Same | Pending |
| A-SC03 | Scramble | 3 | Same | Pending |
| A-SC04 | Scramble | 4 | Same | Pending |
| A-SC05 | Scramble | 5 | Same | Pending |
| A-SC06 | Scramble | 6 | Same | Pending |
| A-SC07 | Scramble | 7 | Same | Pending |
| A-SC08 | Scramble | 8 | Same | Pending |
| A-SC09 | Scramble | 9 | Same | Pending |
| A-SC10 | Scramble | 10 | Same | Pending |
| A-FR01 | Full Random | 1 | New target retained through parts/tuning/paint/final readback | Pending |
| A-FR02 | Full Random | 2 | Same | Pending |
| A-FR03 | Full Random | 3 | Same | Pending |
| A-FR04 | Full Random | 4 | Same | Pending |
| A-FR05 | Full Random | 5 | Same | Pending |
| A-FR06 | Full Random | 6 | Same | Pending |
| A-FR07 | Full Random | 7 | Same | Pending |
| A-FR08 | Full Random | 8 | Same | Pending |
| A-FR09 | Full Random | 9 | Same | Pending |
| A-FR10 | Full Random | 10 | Same | Pending |

## Pause, timing, and UI-state variants

| ID | Scenario | Expected | Status |
|---|---|---|---|
| P01 | Game running normally | Operation progresses without pause manipulation | Pending |
| P02 | Already paused before click | Pause-independent phases progress and terminate | Pending |
| P03 | Pause immediately after click | Generation and target do not change | Pending |
| P04 | Pause immediately after spawn | Ownership remains bound | Pending |
| P05 | Pause during parts reload | Bounded wall-clock lifecycle; no wrong-target write | Pending |
| P06 | Pause during tuning | Tuning readback completes or terminates honestly | Pending |
| P07 | Pause during paint | Paint readback completes or terminates honestly | Pending |
| P08 | Unpause during a genuine simulation wait | Only the pending phase resumes | Pending |
| P09 | Slow motion | Seed/result are independent of time scale | Pending |
| P10 | Frame step | No false target switch or generation reset | Pending |
| P11 | Menu open | Housekeeping and Cancel remain live | Pending |
| P12 | Menu closed | Same lifecycle result | Pending |
| P13 | UI App expanded | Operation and controls remain usable | Pending |
| P14 | UI App collapsed | Operation and Cancel remain usable | Pending |

## Environment B — third-party groups

| ID | Enabled group | Expected | Status |
|---|---|---|---|
| B01 | Simple vehicle mod | Best-effort complete or explicit terminal reason | Pending |
| B02 | Vehicle with controllers | External failures isolated; no wrong-target write | Pending |
| B03 | Mod that changes vehicle ID | Correlated target or safe terminal | Pending |
| B04 | Deep parts tree | Parent-first rescans converge within bounds | Pending |
| B05 | Broken configuration | Candidate quarantined; bounded recovery | Pending |
| B06 | Trailer/auxiliary entity | Auxiliary callbacks do not steal target | Pending |
| B07 | Automation vehicle | Honest metadata/safety classification | Pending |

## Specific recovery loop

| ID | Sequence | Expected | Status |
|---|---|---|---|
| L01 | Begin with randomized A; repeat Random Car → Full Random → Random Car → Full Random → Scramble | No repeated return/reapplication of A; a cycle terminates | Pending |

## Race

| ID | Scenario | Expected | Status |
|---|---|---|---|
| R01 | Balanced, 2 cars; Placement/Spawn all; Destination/Start all/Stop all | Every competitor terminal; managed ownership maintained | Pending |
| R02 | Maximum Chaos, 4 cars; full Placement and Drive flow | Same | Pending |
| R03 | Mods Showcase, 4 cars; full Placement and Drive flow | Same or explicit capability/degradation reason | Pending |

## Garage

| ID | Action | Expected | Status |
|---|---|---|---|
| G01 | Save | Final readback saved | Pending |
| G02 | Restore | Exact/compatible target-bound lifecycle | Pending |
| G03 | Replay | Saved generator policy respected | Pending |
| G04 | Small mutation | Child lineage; target isolation | Pending |
| G05 | Medium mutation | Child lineage; target isolation | Pending |
| G06 | Wild mutation | Child lineage; target isolation | Pending |
| G07 | Reroll unlocked | Locks honored; independent domains | Pending |
| G08 | Compare | Real stored fields compared | Pending |
| G09 | Export | Valid package/JSON produced | Pending |
| G10 | Import | Local compatibility recalculated | Pending |
| G11 | Share | Inert transferable payload | Pending |

## UI evidence

| ID | Capture | Expected | Status |
|---|---|---|---|
| U01 | Chaos Ready | Compact natural flow | Pending |
| U02 | Chaos Busy | Phase, progress, Cancel and diagnostics visible | Pending |
| U03 | Chaos Error | Specific reason and recovery outcome | Pending |
| U04 | Details expanded | Height grows without clipping | Pending |
| U05 | Collapsed | 120–150 px high and usable | Pending |
| U06 | Expanded | 250–330 px high and scrolls only when needed | Pending |
| U07 | Slider 0% | No active fill; thumb endpoint aligned | Pending |
| U08 | Slider 25% | Quarter fill | Pending |
| U09 | Slider 50% | Half fill | Pending |
| U10 | Slider 75% | Three-quarter high-chaos fill | Pending |
| U11 | Slider 100% | Full fill; thumb endpoint aligned | Pending |
| U12 | Race | Cars/Placement/Drive controls usable | Pending |
| U13 | Garage | Saved/Compare/Share controls usable | Pending |
| U14 | Settings | General/Safety/Seed/Locks/Advanced/Diagnostics usable | Pending |

## Totals

| Status | Count |
|---|---:|
| Passed | 0 |
| Failed | 0 |
| Pending | 80 |
| Blocked | 0 |
| Not applicable | 0 |

