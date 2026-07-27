# Live test plan — 0.6.4

Execute all 110 cases against the exact downloaded GitHub release ZIP. Before
starting, record ZIP bytes/SHA-256, manifest commit/tag, BeamNG full build,
profile, map, input method, UI scale/resolution, active content and versions.
Start from a clean profile for the first pass, then add representative mods.

For every case capture status (Passed/Failed/Blocked), action/settings/seed,
initial and final model/config/ID, callback/read-back evidence when relevant,
terminal outcome, Busy state, warnings, recovery action, log result, and a
screenshot/video if the UI or timing matters. Pause/unpause must never be used
to make a case pass.

| Group | Count | Exact variants (execute each numbered item once) | Pass contract |
| --- | ---: | --- | --- |
| L01–L10 Random Car | 10 | 1 official; 2 user config; 3 config pack; 4 full vehicle mod; 5 no active vehicle; 6 same-ID replace; 7 recreated ID; 8 slow load; 9 paused before click; 10 repeated five times | Leaves Busy, selected target/config coherent, no pause workaround, no wrong fallback |
| L11–L20 Full Random | 10 | same ten content/lifecycle variants as L01–L10 | Continues past 22%; parts/tuning/paint/fuel/final result terminal |
| L21–L30 Scramble/reload | 10 | 1 official simple; 2 deep tree; 3 parent exposes child; 4 wheel pack; 5 mod part; 6 same-ID respawn; 7 recreated ID; 8 paused; 9 already-visible applied tree; 10 repeated five times | Continues past 57%; callback absence/order does not strand Busy |
| L31–L40 callback/target chaos | 10 | 1 early spawn; 2 late spawn; 3 duplicate spawn; 4 switch before spawn; 5 spawn before switch; 6 returned ID replaced; 7 destroyed intermediate; 8 auxiliary spawn; 9 player-1 switch; 10 unrelated player-0 switch | Hints never prove success; only coherent current player target binds; unrelated switch cancels safely |
| L41–L50 pause/time | 10 | Random Car, Full Random, Scramble each paused before and during wait (6); slow motion 0.25× (3); one frame-step case (1) | GE housekeeping/Cancel/diagnostics remain available; no pause-toggle dependency |
| R01–R10 terminal/recovery | 10 | 1 success; 2 partial success; 3 cancel pre-write; 4 cancel post-write; 5 synchronous replace reject; 6 parts apply reject; 7 tuning reject; 8 paint reject; 9 unrelated switch; 10 forced rollback | Explicit terminal outcome, Busy false, no stale write, rollback only when justified |
| R11–R20 preservation | 10 | 1 optional empty; 2 mod metadata incomplete; 3 fuel unknown; 4 energy read unavailable; 5 parts transient nil; 6 parts persistent nil; 7 tuning optional unavailable; 8 paint unavailable; 9 DNA capture unavailable; 10 coverage limit | Stable usable target remains; warning/partial truthfully describes gap; no stock/previous fallback solely for uncertainty |
| F01–F10 fuel | 10 | 1 gasoline 0%; 2 diesel 5%; 3 fuel 10%; 4 fuel 100%; 5 two tanks below; 6 one of two below; 7 hybrid; 8 electric only; 9 nitrous; 10 pressure/hydraulic | Only combustion fuel corrected to ≥10%; excluded storage unchanged; read-back/details match |
| F11–F20 fuel mods | 10 | 1 explicit variable ref; 2 source-part correlation; 3 storage-name correlation; 4 capacity correlation; 5 ambiguous variables; 6 missing capacity; 7 missing current value; 8 custom fuel name; 9 removed tank; 10 correction not confirmed | Confirmed values corrected; uncertainty warned and preserved, never falsely verified |
| P01–P10 parts | 10 | 1 core empty attempt; 2 functional role loss; 3 optional already empty; 4 Allow Missing selected empty; 5 Allow Missing off; 6 mod `required` hint; 7 unknown metadata; 8 disappearing child; 9 incompatible candidate; 10 localized batch rollback | Core/proven loss blocked; optional/mod uncertainty nonfatal; no unrelated candidate quarantined |
| P11–P20 dynamic content | 10 | 1 1-slot; 2 100+ slots; 3 10+ depth; 4 new descendants; 5 removed descendants; 6 changing candidates; 7 tuning added after reload; 8 tuning metadata revision; 9 clamp; 10 fixed-point/cycle | Bounded convergence, complete/partial coverage honest, no Busy loop or fixed catalog assumption |
| U01–U10 tab sizing | 10 | Settings→Chaos at 300/320/340/360/480px widths (5); repeat 20 cycles at 100%/125%/150%/200%/system scale (5) | Auto mode shrinks/grows to rendered tab without cumulative drift or clipped controls |
| U11–U20 resize/collapse | 10 | 1 user resize tall; 2 user resize short; 3 programmatic echo; 4 mutation burst; 5 open details; 6 close details; 7 collapse from Settings; 8 expand to Chaos; 9 collapse while Busy; 10 viewport-height cap | Only true user resize is sticky; debounce prevents feedback; collapsed always compact |
| U21–U30 visual/input | 10 | slider 0/1/50/99/100 (5); keyboard arrows/Home/End (2); mouse/touch drag (1); fox header at normal/collapsed (1); selector PNG in UI Apps (1) | Orange fill/thumb exact, accessible input works, friendly fox is readable and unbroken |

Total: **110 cases**.

Stop and mark Failed (not Passed with a note) for permanent Busy, progress that
requires pause toggling, wrong-target mutation, state loss after noncritical
uncertainty, fuel below the confirmed floor, empty core/proven infrastructure,
unavailable Cancel/diagnostics while waiting, resize drift, or mismatched asset
identity. Mark Blocked only for an external prerequisite that prevents execution
and describe it precisely.
