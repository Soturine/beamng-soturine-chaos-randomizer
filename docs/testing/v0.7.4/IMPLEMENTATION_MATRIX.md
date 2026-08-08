# v0.7.4 implementation matrix

Status vocabulary: `Automated: Pending/Passed/Failed`; `Live: Pending owner validation/Passed/Failed/Not applicable`.

The cause column distinguishes live-confirmed behavior from implementation hypotheses. A passing fixture does not replace execution against the published ZIP.

| ID | Severity | Description | Evidence | Cause or hypothesis | Files | Invariant | Automated | Live | Status | Commit | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| UI-073-01 | P1 | App-width responsiveness | Owner live | Global viewport breakpoints | UI shell/styles | Layout follows measured AppHost width | Pending | Pending | Open | — | Widths 320–720 px |
| UI-073-02 | P1 | Garage Grid | Owner live | Dense metadata and unsafe wrapping | Garage UI/styles | Human content remains readable at narrow widths | Pending | Pending | Open | — | 2/1-column fallback |
| UI-073-03 | P1 | Chaos lock clutter | Owner live | Manager controls inline | Chaos UI | Main flow shows compact lock summary | Pending | Pending | Open | — | — |
| UI-073-04 | P1 | Lock manager subview | Owner live | No isolated management context | Chaos UI | Search/filter/disclosure preserve context | Pending | Pending | Open | — | — |
| UI-073-05 | P0/P1 | Lock classifier ancestry bug | Owner live | Generic ancestor substring wins | Locks runtime/UI | Specific leaf evidence outranks ancestry | Pending | Pending | Open | — | Deep mod fixtures |
| UI-073-06 | P2 | Human part labels | Owner live | Generic registry labels exposed | i18n/UI | Known generic terms translated; brands preserved | Pending | Pending | Open | — | — |
| UI-073-07 | P1 | Race summary semantics | Owner live | Planned/physical states conflated | Race UI/protocol | Counts represent planned, active, ready, failed | Pending | Pending | Open | — | — |
| UI-073-08 | P2 | Race policy noise | Owner live | Changed-field count is primary copy | Race UI | Preset first, advanced details on demand | Pending | Pending | Open | — | — |
| UI-073-09 | P1 | English leak | Owner live | Raw fallback string | i18n/Race UI | Normal UI is catalog-backed | Pending | Pending | Open | — | — |
| UI-073-10 | P1 | SmartSelect placement | Owner live | Popup boundary/flip contract incomplete | ScrSelect/styles | Popup remains usable inside app bounds | Pending | Pending | Open | — | Mouse/keyboard/UINav |
| UI-073-11 | P1 | Compact content | Owner live | Compact only changed host geometry | All UI tabs | Each tab changes content and internal geometry | Pending | Pending | Open | — | 50 cycles |
| UI-073-12 | P2 | Idle footer | Owner live | Idle status rendered persistently | Shell UI | No persistent idle-ready status | Pending | Pending | Open | — | — |
| LIVE-073-01 | P0 | Random Car false cardinality | Owner live | Absolute world delta used as transaction proof | Runtime operations | Expected remove/add sets define replacement | Pending | Pending | Open | — | Preserve unrelated IDs |
| LIVE-073-02 | P0 | Wrong terminal outcome after commit | Owner live | Warnings overwrite committed result | Runtime result model | Stable terminal outcome codes | Pending | Pending | Open | — | — |
| LIVE-073-03 | P0 | Scramble false cardinality/Safety | Owner live | Global delta/transient reads | Runtime operations | Same ID; zero spawn/replace/remove | Pending | Pending | Open | — | — |
| LIVE-073-04 | P0 | Transient tree promoted to invalid | Owner live | Fixed-count validation before convergence | Safety/convergence | Stable fingerprint pair precedes decision | Pending | Pending | Open | — | — |
| LIVE-073-05 | P0 | Integrity/drivability conflation | Owner live | Single validity axis | Safety/runtime | Integrity alone authorizes destructive rollback | Pending | Pending | Open | — | — |
| LIVE-073-06 | P1 | Engine fluid unknown treated unsafe | Owner live | Unsupported telemetry mapped to unsafe | Fluid guard | Unknown/not-applicable are non-destructive | Pending | Pending | Open | — | — |
| LIVE-073-07 | P1 | Full Random reload churn | Owner live | Reload/readback work not budgeted by purpose | Runtime metrics | Base + one mutation reload; bounded repair | Pending | Pending | Open | — | Synthetic metrics only |
| LIVE-073-08 | P1 | Raw phase codes | Owner live | Stable codes rendered directly | UI protocol/i18n | Codes translated outside diagnostics | Pending | Pending | Open | — | — |
| LIVE-073-09 | P1 | Unlocalized BeamNG notifications | Owner live | Backend English messages | Runtime/i18n | Technical detail only in disclosure | Pending | Pending | Open | — | — |
| LIVE-073-10 | P1 | Recovery lifecycle/churn | Owner live | Recovery identity/focus lifecycle unclear | Runtime recovery | Scramble never spawns; focus remains explicit | Pending | Pending | Open | — | — |
| RACE-073-01 | P0 | Player focus isolation | Owner live | Background spawn steals focus | Race runtime | Restore player immediately; mutate by explicit ID | Pending | Pending | Open | — | — |
| RACE-073-02 | P0 | Accepted slot retention | Owner live | Accepted candidate remains cleanup-eligible | Race ownership | Accepted IDs leave temporary ownership | Pending | Pending | Open | — | — |
| RACE-073-03 | P0 | Failure containment | Owner live | Slot failure aborts/cross-cleans | Race runtime | Later slots continue; prior ready slots survive | Pending | Pending | Open | — | — |
| RACE-073-04 | P0 | Failed DNA persistence | Owner live | Partial DNA persisted before validation | Race storage | Failed/cancelled/skipped DNA is nil | Pending | Pending | Open | — | Validate before persistence |
| RACE-073-05 | P0 | Policy-aware chaos acceptance | Owner live | Drivability treated as integrity | Race policy/Safety | Stable chaos may be ready with warnings | Pending | Pending | Open | — | — |
| RACE-073-06 | P1 | Exclusive slot staging positions | Owner live | Shared/unsafe staging target | Race placement | One exclusive footprint per slot | Pending | Pending | Open | — | — |
| RACE-073-07 | P1 | Counter/world consistency | Owner live | Logical counts lead physical state | Race projection | Ready count equals protected accepted IDs | Pending | Pending | Open | — | — |
| RACE-074-PREVIEW-01 | P1 | Generation world-space preview | Requested | New feature | Preview runtime/UI | Overlay only; zero world mutation | Pending | Pending | Open | — | — |
| RACE-074-PREVIEW-02 | P1 | Final grid preview | Requested | New feature | Preview runtime/UI | Destination footprints without teleport | Pending | Pending | Open | — | — |
| RACE-074-PREVIEW-03 | P2 | Preview controls | Requested | New feature | Race UI/settings | Origin/orientation/formation/spacing controls | Pending | Pending | Open | — | — |
| RACE-074-PREVIEW-04 | P1 | Live slot-state preview | Requested | New feature | Preview/protocol | Markers reflect planned/generating/ready/failed | Pending | Pending | Open | — | — |
