# v0.7.5 live findings carried into v0.7.6

Status: **Executed live by the repository owner against the published v0.7.5 ZIP; failures observed**.

These observations are the ground truth for v0.7.6. They do not modify the frozen v0.7.5 tag or release, and they do not prove any v0.7.6 correction live. Logs, seeds, vehicle names, renderer/backend details, and timings not supplied by the owner are not invented.

| ID | Severity | Owner-observed behavior | v0.7.6 invariant |
| --- | --- | --- | --- |
| LIVE-075-UI-01 | P0 | Normal AppHost content opens usable and then shrinks by itself until tabs or content clip | Normal geometry is stable and cannot be rewritten by an internal-content feedback loop |
| LIVE-075-UI-02 | P0 | Compact mode is more usable than normal after the collapse | Normal and compact remain explicit, independently usable layouts |
| LIVE-075-UI-03 | P1 | Tabs/header and horizontal regions overflow after collapse | The shell keeps safe normal minima and scrolls content without application-level horizontal overflow |
| LIVE-075-UI-04 | P1 | Geometry appears to feed its own reduced measurement back into sizing | Application-caused child measurements never become persisted user AppHost size |
| LIVE-075-UI-05 | P1 | Locks still need lower visual priority | Locks remain a concise summary plus an explicit manager action |
| LIVE-075-EVT-01 | P0 | Preview `Position blocked` leaves no working recovery path | Preview failure releases its attempt and exposes persistent Retry |
| LIVE-075-EVT-02 | P0 | `Lineup staging unsafe` leaves generation in a dead end | Generation failure preserves setup and a new attempt starts with fresh identity |
| LIVE-075-EVT-03 | P1 | Recoverable errors disappear without an action | Recoverable errors persist until dismiss, success, or explicit clear |
| LIVE-075-EVT-04 | P0 | Preview can say ready while no marker is visible | Data readiness and a successfully drawn frame are separate states |
| LIVE-075-EVT-05 | P1 | Preview toggle/runtime/schema values can disagree | UI preference, public state, renderer state, and formation enums share one normalized protocol |
| LIVE-075-EVT-06 | P0 | Background generation can steal the player/camera focus | The player is restored immediately and is never a staging target |
| LIVE-075-EVT-07 | P0 | A lineup can remain Planned at 0/N indefinitely | Active planned work advances or terminates explicitly within a bounded update count |
| LIVE-075-EVT-08 | P1 | Lineup storage failure stops or obscures recovery | Typed persistence failure is contained from valid in-memory state and can be retried |
| LIVE-075-EVT-09 | P1 | Retrying can inherit stale generation state | Every retry has a new operation/generation; old callbacks have no authority |
| LIVE-075-EVT-10 | P1 | The Behavior stage appears hidden or inert | Behavior has clear presets, current state, Start/Stop actions, and a route forward |
| LIVE-074-OUT-01 | P1 | Successful Scramble can be called partial too broadly | Warnings and verification confidence do not mean an incomplete mutation |
| LIVE-074-OUT-02 | P1 | Random configuration can be called partial for skipped or unknown probes | Skips, warnings, timeout, stall, and incomplete application use distinct outcomes |
| LIVE-074-OUT-03 | P1 | Full Random can be called partial too broadly | Partial-applied is reserved for actually abandoned planned mutation work |
| LIVE-074-RUN-01 | P1 | Watchdog can stall legitimate slow mod loads | Semantic, phase-aware progress tolerates a bounded slow load and detects true deadlock |
| LIVE-074-RUN-02 | P1 | Full Random can exceed its operation deadline | Reload/readback/repair work is bounded and its terminal cause is explicit |
| LIVE-074-RUN-03 | P1 | Raw phase IDs can reach normal UI | The frontend translates stable codes; raw IDs remain in Details only |
| LIVE-074-RUN-04 | P1 | Progress/recovery can appear to regress or become ambiguous | Overall user-facing progress is structured and monotonic |
| LIVE-075-I18N-01 | P1 | Technical terms such as Seed/DNA/HUD are translated literally | A shared termbase preserves product and technical terms in every catalog |
| LIVE-075-I18N-02 | P1 | Full English diagnostic/status sentences leak into localized normal UI | Normal UI renders catalog text; backend prose is diagnostics-only |
| BRAND-076-01 | P1 | The geometric vector fox is not the intended quality bar | A generated transparent PNG with legible small-size variants is the primary UI mark |

## Evidence boundary

All v0.7.6 corrections start as **Live pending owner validation**. Automated fixtures cannot approve BeamNG.drive gameplay, renderer visibility, controller behavior, UI scale/safe zones, third-party mods, language rendering, or performance. Live approval must use the exact published v0.7.6 ZIP.
