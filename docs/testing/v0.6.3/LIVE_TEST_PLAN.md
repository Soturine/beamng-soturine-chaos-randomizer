# Live test plan — 0.6.3

Execute only with the exact final candidate ZIP. Record filename, bytes, SHA-256, commit, full BeamNG build, profile, map, enabled mods, seed, start/end time, terminal code/phase, concrete ID chain, rebind count, stale callbacks, recovery tier, fuel report, Busy outcome, screenshot/log references, and pause interaction for every row.

Required baseline: clean profile, Small Grid, game running, no manual pause unless the row explicitly asks for it, old Randomizer copies disabled, locks cleared, diagnostic logging enabled. The 80 v0.6.2 rows are retained and must be re-executed; 30 v0.6.3-specific rows follow.

## A — 30 unpaused smoke runs

| ID | Action/run | Expected | Status |
| --- | --- | --- | --- |
| A-RC01 | Random Car 1 | Correct target retained; Busy ends | Pending |
| A-RC02 | Random Car 2 | Same | Pending |
| A-RC03 | Random Car 3 | Same | Pending |
| A-RC04 | Random Car 4 | Same | Pending |
| A-RC05 | Random Car 5 | Same | Pending |
| A-RC06 | Random Car 6 | Same | Pending |
| A-RC07 | Random Car 7 | Same | Pending |
| A-RC08 | Random Car 8 | Same | Pending |
| A-RC09 | Random Car 9 | Same | Pending |
| A-RC10 | Random Car 10 | Same | Pending |
| A-SC01 | Scramble 1 | Parts/tuning/paint/fuel readback; Busy ends | Pending |
| A-SC02 | Scramble 2 | Same | Pending |
| A-SC03 | Scramble 3 | Same | Pending |
| A-SC04 | Scramble 4 | Same | Pending |
| A-SC05 | Scramble 5 | Same | Pending |
| A-SC06 | Scramble 6 | Same | Pending |
| A-SC07 | Scramble 7 | Same | Pending |
| A-SC08 | Scramble 8 | Same | Pending |
| A-SC09 | Scramble 9 | Same | Pending |
| A-SC10 | Scramble 10 | Same | Pending |
| A-FR01 | Full Random 1 | New target retained through final readback | Pending |
| A-FR02 | Full Random 2 | Same | Pending |
| A-FR03 | Full Random 3 | Same | Pending |
| A-FR04 | Full Random 4 | Same | Pending |
| A-FR05 | Full Random 5 | Same | Pending |
| A-FR06 | Full Random 6 | Same | Pending |
| A-FR07 | Full Random 7 | Same | Pending |
| A-FR08 | Full Random 8 | Same | Pending |
| A-FR09 | Full Random 9 | Same | Pending |
| A-FR10 | Full Random 10 | Same | Pending |

## P — pause, timing, and UI-state variants

| ID | Scenario | Expected | Status |
| --- | --- | --- | --- |
| P01 | Game running normally | Progress without pause manipulation | Pending |
| P02 | Already paused before click | Pause-independent phases terminate | Pending |
| P03 | Pause immediately after click | Generations and target remain coherent | Pending |
| P04 | Pause immediately after spawn | Ownership remains bound | Pending |
| P05 | Pause during parts reload | No wrong-target write; bounded terminal | Pending |
| P06 | Pause during tuning | Honest readback/terminal | Pending |
| P07 | Pause during paint | Honest readback/terminal | Pending |
| P08 | Unpause genuine simulation wait | Only pending phase resumes | Pending |
| P09 | Slow motion | Seed result independent of time scale | Pending |
| P10 | Frame step | No false switch/generation reset | Pending |
| P11 | Menu open | Housekeeping and Cancel remain live | Pending |
| P12 | Menu closed | Same lifecycle result | Pending |
| P13 | App expanded | Operation/controls usable | Pending |
| P14 | App collapsed | Operation/Cancel usable | Pending |

## B — third-party content

| ID | Scenario | Expected | Status |
| --- | --- | --- | --- |
| B01 | Simple vehicle mod | Complete or explicit bounded reason | Pending |
| B02 | Vehicle with controllers | External failure isolated | Pending |
| B03 | Mod that changes vehicle ID | Validated rebind or safe terminal | Pending |
| B04 | Deep/dynamic part tree | Parent-first convergence within bounds | Pending |
| B05 | Broken configuration | Quarantine and bounded recovery | Pending |
| B06 | Trailer/auxiliary entity | Auxiliary callbacks cannot steal target | Pending |
| B07 | Automation vehicle | Honest metadata/safety result | Pending |

## L — historical loop regression

| ID | Scenario | Expected | Status |
| --- | --- | --- | --- |
| L01 | Randomized A → Random Car → Full Random → Random Car → Full Random → Scramble | No repeated restoration/reapplication of A; cycles terminate | Pending |

## R — Race

| ID | Scenario | Expected | Status |
| --- | --- | --- | --- |
| R01 | Balanced 2 cars; place, spawn, drive, stop | Every competitor terminal; ownership preserved | Pending |
| R02 | Maximum Chaos 4 cars; complete flow | Same | Pending |
| R03 | Mods Showcase 4 cars; complete flow | Same or explicit degraded capability | Pending |

## G — Garage

| ID | Scenario | Expected | Status |
| --- | --- | --- | --- |
| G01 | Save | Final readback stored | Pending |
| G02 | Restore | Exact/compatible target-bound result | Pending |
| G03 | Replay | Recorded generator respected | Pending |
| G04 | Small mutation | Child lineage and target isolation | Pending |
| G05 | Medium mutation | Child lineage and target isolation | Pending |
| G06 | Wild mutation | Child lineage and target isolation | Pending |
| G07 | Reroll unlocked | Locks and independent domains honored | Pending |
| G08 | Compare | Stored fields compared | Pending |
| G09 | Export | Valid JSON/package | Pending |
| G10 | Import | Local compatibility recalculated | Pending |
| G11 | Share | Inert transferable payload | Pending |

## U — retained UI evidence

| ID | Capture | Expected | Status |
| --- | --- | --- | --- |
| U01 | Chaos Ready | Compact natural flow | Pending |
| U02 | Chaos Busy | Phase/progress/Cancel/details visible | Pending |
| U03 | Chaos Error | Specific reason and recovery outcome | Pending |
| U04 | Details expanded | Content height grows without clipping | Pending |
| U05 | Collapsed | Compact and usable | Pending |
| U06 | Expanded | Scroll only when content requires it | Pending |
| U07 | Slider 0 | Empty orange fill; aligned endpoint | Pending |
| U08 | Slider 25 | Quarter orange fill | Pending |
| U09 | Slider 50 | Half orange fill | Pending |
| U10 | Slider 75 | Three-quarter orange fill | Pending |
| U11 | Slider 100 | Full orange fill; aligned endpoint | Pending |
| U12 | Race | Cars/Placement/Drive usable | Pending |
| U13 | Garage | Saved/Compare/Share usable | Pending |
| U14 | Settings | All sections usable | Pending |

## L63 — new lifecycle and recovery cases

| ID | Scenario | Expected | Status |
| --- | --- | --- | --- |
| L63-01 | Replacement returns intermediate ID | Returned ID stays candidate until player read validates final ID | Pending |
| L63-02 | Replacement returns no ID | Player-0 discovery validates target | Pending |
| L63-03 | Early `onVehicleSpawned` with incomplete data | Waits for coherent read; no promotion | Pending |
| L63-04 | Spawn callback absent | Polling completes or bounded terminal; no Busy leak | Pending |
| L63-05 | Duplicate spawn/switch callbacks | One logical result; no duplicate write | Pending |
| L63-06 | Old-generation callback during new operation | Rejected and counted stale | Pending |
| L63-07 | ID destroyed/recreated during parts reload | Same logical target rebinds new concrete ID | Pending |
| L63-08 | ID destroyed/recreated during tuning reload | Same logical target rebinds new concrete ID | Pending |
| L63-09 | Correct model/config on different ID at deadline | Final unbound read accepts verified result | Pending |
| L63-10 | Wrong candidate becomes player vehicle | Operation cancels/fails safely; no write | Pending |
| L63-11 | Manual external vehicle switch at 22% | Explicit safe terminal; no old plan on new car | Pending |
| L63-12 | Cancel at 22% and 57% | Busy clears; stale work rejected; bounded recovery | Pending |

## T63 — dynamic parts and tuning

| ID | Scenario | Expected | Status |
| --- | --- | --- | --- |
| T63-01 | Parent reveals slots over 3+ reload waves | All new eligible slots processed/classified | Pending |
| T63-02 | Tuning appears over 3+ discovery waves | Fixed point includes every valid new variable | Pending |
| T63-03 | Variable changes min/max/step after reload | Metadata revision reprocessed and read back | Pending |
| T63-04 | Hidden/internal/action and malformed/nonfinite variables | Skipped with distinct reasons; operation continues | Pending |
| T63-05 | Chaos 100 with transmission, differential, N2O, suspension | Every eligible unlocked variable attempted/classified | Pending |
| T63-06 | Fixed seed replay after dynamic discovery | Project-owned decisions reproduce | Pending |

## E63 — energy storage

| ID | Scenario | Expected | Status |
| --- | --- | --- | --- |
| E63-01 | Gasoline single tank | Final level at least 10% | Pending |
| E63-02 | Diesel plus auxiliary tank | Each fuel tank at least 10% | Pending |
| E63-03 | Hybrid with battery and fuel | Fuel clamped; battery unchanged by fuel floor | Pending |
| E63-04 | N2O, air, and hydraulic storages | None treated as fuel | Pending |
| E63-05 | Fuel tank removed by parts | Not applicable; no invented storage | Pending |
| E63-06 | Save Vehicle DNA after floor correction | DNA contains verified final fuel state | Pending |

## U63 — v0.6.3 visual regressions

| ID | Scenario | Expected | Status |
| --- | --- | --- | --- |
| U63-01 | Compare fox with v0.6.1 at 100/125/150/200% | Exact restored asset renders cleanly | Pending |
| U63-02 | Slider at 0/50/79/100 while dragging | Fill reaches thumb with no pseudo-variable dependency | Pending |
| U63-03 | Default Chaos Ready/Busy/details/long status | Content-sized host; no default unnecessary scroll or clipping | Pending |
| U63-04 | Repeated collapse/expand/manual resize | No resize loop or oscillation | Pending |

## Q63 — performance and package gate

| ID | Scenario | Expected | Status |
| --- | --- | --- | --- |
| Q63-01 | Idle, all Chaos modes, deep tree, many mods, Race/AI | Capture count/p50/p95/p99/max with no event flood | Pending |
| Q63-02 | Clean-profile install of exact ZIP | Root layout valid; no duplicate extension; full smoke uses recorded checksum | Pending |

## Totals

| Status | Count |
| --- | ---: |
| Passed | 0 |
| Failed | 0 |
| Pending | 110 |
| Blocked | 0 |
| Not applicable | 0 |

Release requires all mandatory rows to be executed and acceptance regressions to pass. Update [LIVE_TEST_REPORT.md](LIVE_TEST_REPORT.md) with evidence; never edit this total based on automated tests.
