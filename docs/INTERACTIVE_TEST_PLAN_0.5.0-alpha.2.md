# Interactive Test Plan — 0.5.0-alpha.2

Target: BeamNG.drive `0.38.6.0.19963`, Steam build `23007233`.

Current result: **0 Passed / 0 Failed / 50 Pending**. None of these rows is satisfied by alpha.1 screenshots or automated mocks.

For every executed row, record machine/profile, active mod set, model/configuration, seed, settings, start/end state, result/reason code, relevant `beamng.log` excerpt, screenshot/video reference, duration, and whether Undo/rollback/recovery was verified. A vehicle merely appearing is not a Full Random pass.

## Lifecycle and primary actions

| ID | Case | Pass evidence | Status |
| --- | --- | --- | --- |
| I01 | Vanilla Random Car | Existing configuration loads; no post-spawn part/tuning/paint mutation | Pending |
| I02 | Simple mod Random Car | Final player target stabilizes despite mod lifecycle | Pending |
| I03 | Multi-controller mod Random Car | Correct player target; auxiliary/controller objects ignored | Pending |
| I04 | Multi-ID mod chain | All intermediate IDs observed; final target rebound; no false cancel | Pending |
| I05 | Trailer-capable spawn | Trailer/auxiliary object cannot steal the target | Pending |
| I06 | Prop-capable spawn | Prop/auxiliary object cannot steal the target | Pending |
| I07 | Manual switch during replacement | Truly unrelated player switch cancels and cleans state | Pending |
| I08 | Vanilla Scramble | Same model, effective changes, correlated reloads, final read-back | Pending |
| I09 | Deep-tree Scramble | New descendants appear and are processed on a later pass | Pending |
| I10 | Few-alternative Scramble | Finite no-progress/no-content result, no hang | Pending |
| I11 | Incompatible part candidate | Local batch rollback, quarantine, alternative, continuation | Pending |
| I12 | Chaos 100 unsafe-valid settings | Optional absence allowed; required/core remains enforced | Pending |
| I13 | Vanilla Full Random | New base stabilizes, then effective Scramble and final read-back | Pending |
| I14 | Simple mod Full Random | Post-spawn mutation completes or returns truthful Partial | Pending |
| I15 | Multi-ID mod Full Random | Rebind metrics present and pipeline continues after final spawn | Pending |
| I16 | No mutable content Full Random | Specific no-mutable-content code, never spawn-only success | Pending |
| I17 | Tuning unavailable | Stage omitted with reason; parts result remains truthful | Pending |
| I18 | Paint unavailable | Stage omitted with reason; parts result remains truthful | Pending |
| I19 | Undo after successful operation | Exact pre-write state is restored and confirmed | Pending |
| I20 | Total structural rollback | Original state restored; history/busy/token cleanup verified | Pending |

## Failed-load recovery

| ID | Case | Pass evidence | Status |
| --- | --- | --- | --- |
| I21 | Broken mod configuration | Failure attributed; candidate quarantined for session | Pending |
| I22 | Previous target disappears | Previous snapshot recovery succeeds | Pending |
| I23 | Previous snapshot also fails | Last-known-good recovery succeeds | Pending |
| I24 | No restorable snapshot | Safe official fallback succeeds | Pending |
| I25 | Three consecutive load failures | Circuit breaker restricts automatic selection safely | Pending |
| I26 | All automatic recovery fails | UI usable; busy/token/timers cleared | Pending |
| I27 | Random Car with no active vehicle | New vehicle spawns and stabilizes | Pending |
| I28 | Full Random with no active vehicle | New target spawns and post-spawn mutation executes | Pending |
| I29 | Scramble with no active vehicle | Disabled/explained; safe-vehicle action available | Pending |
| I30 | Locks during recovery | Recovery is not blocked; incompatible locks become unresolved | Pending |

## Representative content

| ID | Case | Pass evidence | Status |
| --- | --- | --- | --- |
| I31 | Official config pack | Source/fairness/config identity correct | Pending |
| I32 | Wheel/tire pack | Compatible wheel/tire choices; no forced unreported part | Pending |
| I33 | Drag configuration | Critical evidence and deep descendants remain coherent | Pending |
| I34 | Electric vehicle | Dynamic safety roles avoid combustion assumptions | Pending |
| I35 | Truck | Deep/large tree finishes within bounds | Pending |
| I36 | Automation vehicle | Random Car, Scramble, Full Random, Undo/rollback | Pending |
| I37 | Vehicle with its own UI | Randomizer UI/lifecycle does not steal or deadlock controls | Pending |

## Creative, sharing, and gallery

| ID | Case | Pass evidence | Status |
| --- | --- | --- | --- |
| I38 | Reroll Unlocked from another active model | Parent final restored first; locked fields exact; true child lineage | Pending |
| I39 | Small mutation | Starts from parent final; parent unchanged | Pending |
| I40 | Medium mutation | Starts from parent final; parent unchanged | Pending |
| I41 | Wild without locks | Starts from parent final and may change eligible model/config | Pending |
| I42 | Wild with part/config lock | Bound model/config preserved or unresolved explicitly | Pending |
| I43 | Cross-PC/package import | Exporter metadata retained; local compatibility recomputed | Pending |
| I44 | Exact thumbnail | Exact model/config/slots/tuning/paint captured | Pending |
| I45 | Non-exact thumbnail override | Explicit warning and non-exact metadata persist | Pending |

## Compact UI and metadata

| ID | Case | Pass evidence | Status |
| --- | --- | --- | --- |
| I46 | Default/compact/collapsed/expanded | Modes persist, direct actions remain reachable | Pending |
| I47 | 300×340 and long mod names | No clipped critical action; intentional scroll/ellipsis | Pending |
| I48 | 125%, 150%, and 200% UI scaling | Readable controls and no destructive overlap | Pending |
| I49 | Keyboard/focus/context | Visible focus; Advanced closed; mutations hidden without DNA | Pending |
| I50 | Mod Manager and diagnostics | UI App icon/description correct; outer metadata limitation recorded; copied report inert | Pending |

## Completion rules

Any executed mismatch is Failed until reproduced/fixed or explicitly accepted as a documented limitation. Skipped or unavailable content stays Pending. Update the counts and compatibility matrix only from committed evidence; never infer third-party mod support from automated fixtures.
