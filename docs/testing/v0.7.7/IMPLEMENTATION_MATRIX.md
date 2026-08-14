# v0.7.7 implementation matrix

Scope is limited to owner-observed v0.7.6 behavior on BeamNG 0.39.4.0.20972
(D3D11 screenshots) plus explicit regression guards. `Automated passed` below
means fixture/mounted coverage only. Every correction remains **Live pending
owner validation** against the exact published v0.7.7 ZIP.

| ID | Sev. | Live evidence | Root cause | Files | Correction / invariant | Automated reproduction | Live retest | Status | Commit |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| LIVE-076-GARAGE-01 | P0 | Compare threw `entries.value.map is not a function`; tab boundary contained it. | Untrusted Garage entries crossed ingress without one canonical array projector. | Garage store/projector/components, mounted tests | Normalize array/map/empty/invalid shapes once; components remain defensive; distinct database/filter empty states. | 10 shape vectors, dynamic update, Saved/Compare/remount. | A | Implemented; automated passed; Live pending owner validation | `ab26eee` |
| LIVE-076-SEED-02 | P0 | Blank explicit generations repeated episode/slot results. | Blank intent reused stable prior/default seed material instead of minting an episode. | `raceManager.lua`, `main.lua`, Race UI/tests | `new`, `explicit` and `repeat` are distinct; blank New mints unique episode seed; explicit seed is preserved. | Blank A/B inequality, explicit repeat, retry substream. | B | Implemented; automated passed; Live pending owner validation | `1ced41e`, `81dc8b8` |
| LIVE-076-OWNERSHIP-03 | P0 | Later lineups accumulated earlier Race vehicles. | New generation did not reconcile the prior lineage through exact owned bindings before replacing state. | `main.lua`, registry/domain operations | Reconcile exact prior lineup/slot/generation bindings with local authority; refuse unsafe replacement; never infer by proximity/recency. | Owned cleanup, unrelated/player protection, late/reused-ID guards. | C | Implemented; automated passed; Live pending owner validation | `1ced41e` |
| LIVE-076-MANAGED-04 | P0 | Regenerate left source and candidate in the world. | Regenerate used additive respawn semantics without a source-to-candidate transaction. | `main.lua`, `managedVehicleRegistry.lua` | Source stays until candidate verifies; success removes source then commits rebind; failure/cancel removes candidate and keeps source. | Success/failure/cancel/late callback plus 20-cycle cardinality. | D | Implemented; automated passed; Live pending owner validation | `1ced41e` |
| LIVE-076-MANAGED-05 | P0 | Lineup, managed UI and physical counts disagreed. | Slot owner and physical-ID registries allowed parallel identity without uniqueness across both directions. | lineup schema, registry, Race manager/main | One slot binding contains lineup/generation/episode/slot/concrete/managed identity; both slot and physical ID are unique. | 1:1 bind/rebind/abort and exact-match properties. | C, D, G | Implemented; automated passed; Live pending owner validation | `1ced41e` |
| LIVE-076-POSITION-05 | P0 | First/next/all had no observable effect when Preview was absent. | Physical positioning was gated by Preview-render lifecycle instead of fresh placement calculation. | `main.lua`, `raceManager.lua`, formation UI | Recalculate placement for exact ready bindings on every physical action; first/next/all have explicit selectors; renderer is optional. | Placement without renderer and canonical selector fixtures. | H | Implemented; automated passed; Live pending owner validation | `1ced41e`, `81dc8b8` |
| LIVE-076-STAGING-06 | P0 | Candidates appeared behind/near camera or generic spawn. | Automatic staging could fall into a behind-camera formation instead of a dedicated forward staging plan. | `main.lua`, `raceManager.lua` | Generation uses a forward staggered staging plan derived from player transform; unsafe calculation returns a typed failure before arbitrary spawn. | Staging/placement plan and player-focus/ownership guards. | C, H | Implemented; automated passed; Live pending owner validation | `1ced41e` |
| LIVE-076-PRESET-01 | P0 | Balanced processed candidates then collapsed to generic chaos-policy rejection. | Warning/unknown optional evidence was conflated with proven drivability/runtime rejection and the decision lacked structured disclosure. | Race manager/main, details/i18n | Balanced accepts non-critical uncertain/optional evidence with warning, remains strict on proven failure; publish profile/rule/severity/evidence/decision. | Warning-only acceptance and strict-failure profile fixtures. | E | Implemented; automated passed; Live pending owner validation | `1ced41e`, `81dc8b8` |
| LIVE-076-PRESET-02 | P1 | Mods Showcase created doomed slots in a no-mod profile. | Pool cardinality was checked after slot scheduling. | `raceManager.lua`, `main.lua`, Race UI | Preflight candidate index/pool; zero pool creates no slots and offers localized alternatives/retry. | Zero-pool preset fixture and mounted action state. | F | Implemented; automated passed; Live pending owner validation | `1ced41e`, `81dc8b8` |
| LIVE-076-DETAILS-01 | P0 | Global Details CTA produced no visible action. | Global state toggled details, but the only drawer lived inside a different tab/component path. | App shell, global status, shared drawer | One shell-owned drawer renders only for a real result and exposes human summary, scoped identity, recovery, technical disclosure and copy. | Exact Race payload, copy, open/close and no-data CTA absence. | J | Implemented; automated passed; Live pending owner validation | `81dc8b8` |
| LIVE-076-PREVIEW-01 | P0 | Marker counts/completion appeared although no world markers were visible. | Placement data/readiness leaked into renderer-visible presentation. | Preview runtime/state, summary, i18n | Keep data, capability, render attempt, drawn frame, fallback and error independent; fallback lists placements. | Renderer unavailable/error/success and fallback mounted tests. | H, J | Implemented; automated passed; Live pending owner validation | `81dc8b8` |
| LIVE-076-PREVIEW-02 | P1 | Formation preview reported unavailable and blocked useful flow. | Visual capability and placement capability shared the same affordance semantics. | Formation controls/summary | Visual action explains capability or calculates fallback; physical first/next/all remain enabled from placement readiness. | Mounted renderer-unavailable formation case. | H | Implemented; automated passed; Live pending owner validation | `81dc8b8` |
| LIVE-076-RACE-ORDER-04 | P1 | Move Up/Down had no visible downstream effect. | Presentation relied on incidental array order rather than canonical position. | Race manager/list/cards | Canonical position is sorted and consumed by cards, placement and behavior selection. | Reorder and placement/AI-order fixtures. | I | Implemented; automated passed; Live pending owner validation | `1ced41e`, `81dc8b8` |
| LIVE-076-RACE-STATE-01 | P1 | Partial/warning meaning varied by preset. | Applied mutation and verification/capability axes were compressed into one label. | Race manager/main/UI/i18n | Preserve outcome/applied/confidence separately and derive generation/placement/drivable/AI readiness. | Balanced/Maximum/Custom outcome/readiness fixtures. | E, G | Implemented; automated passed; Live pending owner validation | `1ced41e`, `81dc8b8` |
| LIVE-076-AI-READY-01 | P0 | Generated/managed counts did not prove drivable or AI-ready. | Accepted vehicle existence was treated as readiness before capability and command readback. | `main.lua`, Race Drive UI | Separate generated, placement-ready, drivable and AI-ready; proven non-drivable slots cannot schedule AI. | Readiness-axis and non-drivable dispatch refusal tests. | E, G | Implemented; automated passed; Live pending owner validation | `1ced41e`, `81dc8b8` |
| LIVE-076-AI-COMMAND-01 | P1 | Behavior/Start could appear ready without proof of real dispatch. | Public state lacked per-slot dispatch/readback outcome. | `main.lua`, Race Drive UI | Publish behavior, target, command, dispatch, readback and failure; AI-ready only after confirmation. | Dispatch/readback success/failure fixtures. | G | Implemented; automated passed; Live pending owner validation | `1ced41e`, `81dc8b8` |
| LIVE-076-SEED-UX-01 | P1 | New vs Repeat seed intent was ambiguous. | One field/action silently carried prior seed semantics. | Race Cars UI/i18n | Separate Generate and Repeat; show/copy used seed and preserve explicit input. | Mounted blank/explicit/repeat command payloads. | B | Implemented; automated passed; Live pending owner validation | `81dc8b8` |
| LIVE-076-UI-01 | P1 | Compatibility warning was large and persistent in ordinary play. | Warning surface was unconditional and not persisted as scoped preference. | compatibility badge, UI preferences, i18n | Show only detected conflict/unsupported state; localized evidence, Details and persistent Dismiss. | Conflict/dismiss/remount mounted test. | K | Implemented; automated passed; Live pending owner validation | `81dc8b8` |
| LIVE-076-UI-02 | P1 | Short tabs retained excessive vertical dead space. | Per-tab preferred heights and normal pinning retained a larger generic shell target. | `uiLayout.js`, CSS | Safer per-tab normal targets; user-sized AppHost preference remains authoritative; compact stays explicit. | Width/tab/remount/observer mounted cycles. | K | Implemented; automated passed; Live pending owner validation | `81dc8b8` |
| LIVE-076-UI-03 | P1 | Long localized selector labels overflowed. | Selected label lacked constrained ellipsis/title and popup width contract. | `ScrSelect.vue`, CSS | Flexible width, ellipsis/reflow, full title and bounded dropdown. | 320-720 px across three locales. | K | Implemented; automated passed; Live pending owner validation | `81dc8b8` |
| LIVE-076-I18N-01 | P1 | Backend English/raw result text appeared in localized normal flow. | New Race causes/readiness lacked catalog presentation keys. | three catalogs, result components | Stable codes map to localized human labels; raw backend prose stays in technical Details. | Catalog parity plus mounted locale variants. | K | Implemented; automated passed; Live pending owner validation | `81dc8b8` |
| LIVE-076-UI-TECH-01 | P1 | Managed/model/config technical IDs leaked into primary labels. | Identity fallback preferred internal keys. | competitor/managed UI, Details | Normal flow uses human/official fallback labels; technical IDs stay in explicit disclosure. | Mounted normal/details separation. | J, K | Implemented; automated passed; Live pending owner validation | `81dc8b8` |
| LIVE-076-VEHICLE-ERROR-01 | P1 | Vanilla-looking load failure could be described as a mod failure. | Failure record omitted candidate source and spawn resolution context. | `main.lua`, Details/i18n | Record source, model/config, candidate/spawn action, operation/generation/preset and typed resolution cause. | Structured failure-record fixtures. | E, J | Implemented; automated passed; Live pending owner validation | `1ced41e`, `81dc8b8` |
| LIVE-076-GARAGE-UX-01 | P2 | Empty Garage wording was unnatural and ambiguous. | One empty state covered empty database and filtered-empty collection. | Garage UI/i18n | Distinct saved-empty and no-filter-match copy. | Mounted empty-state cases. | A, K | Implemented; automated passed; Live pending owner validation | `ab26eee` |
| LIVE-076-LOCKS-UX-01 | P2 | Lock manager needed i18n/navigation polish. | Dense controls amplify label-width and focus issues. | existing Lock manager, selectors/CSS/i18n tests | Preserve grouped/count/filter/keyboard manager; apply shared selector width, focus and localized-label guards. | Narrow/long-label and navigation regressions. | K | Regression guard strengthened; Live pending owner validation | `81dc8b8` |
| LIVE-076-STATUS-01 | P1 | Global completion messages were vague and unscoped. | One generic completion string summarized slot, lineup and capability warnings. | global status/details/i18n | Localized action/outcome and scoped readiness counts; Details binds exact result. | Exact Race result mounted payload. | J | Implemented; automated passed; Live pending owner validation | `81dc8b8` |
| LIVE-076-PRESET-03 | P1 | Preset failures shared vague causes. | Pool, resolution, policy and exhaustion collapsed late. | Race manager/main/Details | Preset-specific preflight and typed decision/recovery context. | Preset pool/policy/readiness fixtures. | E, F, G | Implemented; automated passed; Live pending owner validation | `1ced41e`, `81dc8b8` |
| LIVE-076-RACE-RECOVERY-01 | P0 | A failed Race attempt could remain semi-locked without a transactional retry. | Recoverable failure did not consistently release transient lock while retaining requested setup/action. | `main.lua`, Race UI | Failure releases attempt lock, preserves setup, exposes persistent retry; retry receives new operation/generation and stale callbacks stay inert. | Recovery/new-generation/stale callback fixtures. | J | Implemented; automated passed; Live pending owner validation | `1ced41e`, `81dc8b8` |
| LIVE-076-RACE-RECOVERY-UX-01 | P1 | Slot fallback/regenerate semantics were ambiguous. | Generic action labels hid whether source, candidate or verified fallback was affected. | Race Cars/managed controls/i18n | Explicit retry, skip, stop and verified-official fallback labels/actions. | Mounted action dispatch tests. | J | Implemented; automated passed; Live pending owner validation | `81dc8b8` |
| LIVE-076-RACE-ERROR-SEMANTICS-01 | P1 | Slot, lineup, preset and global warnings shared one scope. | Public summaries lacked structured scope/readiness counters. | Race public state/UI/i18n | Publish slot and lineup results independently; renderer warning never becomes lineup failure. | Multi-slot mixed-result mounted/fixture coverage. | E, G, J | Implemented; automated passed; Live pending owner validation | `1ced41e`, `81dc8b8` |
| LIVE-076-ELIGIBILITY-DIAGNOSTICS-01 | P1 | `No eligible vehicles` also appeared beside a selected model/config. | Zero pool, resolution failure, policy rejection and exhaustion collapsed to one message. | Race manager/main/Details/i18n | Preserve `ZERO_POOL`, candidate resolution/policy rejection and slot/lineup exhaustion distinctions with source evidence. | Zero-pool and policy/failure record fixtures. | E, F, J | Implemented; automated passed; Live pending owner validation | `1ced41e`, `81dc8b8` |
| LIVE-076-PREVIEW-RECOVERY-01 | P1 | Re-clicking Preview did not clearly recover or refresh. | Visual attempt completion was retained as generic completed-with-details state. | preview/formation UI and state | Reuse/recalculate placement idempotently, report unavailable renderer immediately, retry rendering if capability returns, never create a lineup. | Repeated unavailable/toggle/retry mounted cycles. | H, J | Implemented; automated passed; Live pending owner validation | `81dc8b8` |
| LIVE-076-CHAOSMAX-GUARD-01 | Guard | Maximum Chaos produced intentionally extreme, distinct vehicles. | Not a defect. | preset policy/tests | Preserve permissive chaos acceptance while runtime integrity/ownership remain strict. | Maximum profile fixture. | G | Preserved; Live pending owner validation | `1ced41e` |
| LIVE-076-CUSTOM-GUARD-01 | Guard | Custom generated vehicles in observed runs. | Not a defect. | preset manager/tests | Preserve user values and usable generation path. | Custom profile preservation fixture. | E, G | Preserved; Live pending owner validation | `1ced41e` |
| LIVE-076-MANAGED-GUARD-01 | Guard | Focus found/switched to managed vehicle. | Not a defect. | managed controls/main | Focus path preserved; identity strengthening does not replace it. | Existing managed action regressions. | D | Preserved; Live pending owner validation | `1ced41e`, `81dc8b8` |
| LIVE-076-ERROR-BOUNDARY-GUARD-01 | Guard | Garage error boundary isolated failure without unmounting shell. | Not a defect. | existing boundaries/mounted tests | Boundary retained; ingress normalization prevents the known Compare crash. | Component error isolation regression. | A | Preserved; Live pending owner validation | `ab26eee` |
| LIVE-076-BALANCED-CLEANUP-GUARD-01 | Guard | Rejected Balanced candidates appeared to be cleaned up. | Positive behavior requiring preservation. | operation/registry/main tests | Rejected candidates remain cleanup-owned and cannot persist as accepted DNA/vehicle. | Policy rejection cleanup fixture. | E | Preserved; Live pending owner validation | `1ced41e` |

## P0 root-cause records

### LIVE-076-GARAGE-01

- Symptom/live evidence: Compare failed during render because `entries` was not iterable; the existing error boundary isolated the tab.
- Root cause: confirmed in the frontend state path. A protocol-compatible object map or invalid transitional value could be stored without canonical projection.
- Why v0.7.6 allowed it: consumers assumed the nominal array contract independently.
- Fix/invariant: normalize once at ingress to a canonical array, then keep defensive consumers and the existing boundary.
- Automated reproduction: invalid, changing and realistic Lua payload shapes across navigation/remount pass.
- Live retest: Scenario A; **Pending owner validation**.

### LIVE-076-SEED-02

- Symptom/live evidence: blank explicit generations reused visible slot seeds/results.
- Root cause: confirmed in seed intent handling. Blank input did not represent a fresh-mint command independently from repeat/default state.
- Why v0.7.6 allowed it: UI and backend shared one ambiguous seed path.
- Fix/invariant: New/explicit/repeat intents are explicit; every blank New mints a unique episode, while explicit/repeat remain deterministic.
- Automated reproduction: blank A/B, explicit X/X and retry substream pass.
- Live retest: Scenario B; **Pending owner validation**.

### LIVE-076-OWNERSHIP-03

- Symptom/live evidence: old and new lineup vehicles accumulated.
- Root cause: code path confirmed; exact live vehicle behavior partially confirmed until retest. Replacement generation published new state without first completing exact prior-lineage reconciliation.
- Why v0.7.6 allowed it: accepted entries were durable state but not a mandatory cleanup precondition for replacement.
- Fix/invariant: reconcile only exact Race-owned local-authority bindings, abort new generation if safe cleanup cannot complete, never touch player/unrelated/remote vehicles.
- Automated reproduction: owned/unrelated/reused-ID cleanup cases pass.
- Live retest: Scenario C; **Pending owner validation**.

### LIVE-076-MANAGED-04 and LIVE-076-MANAGED-05

- Symptom/live evidence: Regenerate duplicated a vehicle and lineup/managed/world counts diverged.
- Root cause: confirmed in lifecycle/registry contracts. Additive respawn had no atomic replacement transaction, and slot/physical uniqueness was not enforced bidirectionally.
- Why v0.7.6 allowed it: source removal and registry rebind were independent steps over parallel identity views.
- Fix/invariant: one slot-to-concrete binding; candidate is temporary until verified; success removes source and commits the prevalidated handoff, failure removes candidate and retains source.
- Automated reproduction: success/failure/cancel/late/reused-ID and 20-cycle cardinality pass.
- Live retest: Scenarios C/D; **Pending owner validation**.

### LIVE-076-POSITION-05 and LIVE-076-STAGING-06

- Symptom/live evidence: physical formation actions appeared inert and candidates spawned behind/near the camera.
- Root cause: confirmed in coordinator selection. Physical movement depended on Preview lifecycle, while Automatic staging could choose a behind-camera formation/generic fallback.
- Why v0.7.6 allowed it: calculation, renderer visibility and movement shared state; generation did not mandate a dedicated forward staging plan.
- Fix/invariant: fresh mathematical plan per movement action and dedicated forward staggered staging; exact slot/authority proof before movement; no arbitrary unsafe spawn.
- Automated reproduction: renderer-free first/next/all, canonical order and authority guards pass.
- Live retest: Scenario H; **Pending owner validation**.

### LIVE-076-PRESET-01

- Symptom/live evidence: Balanced reached real mutation then all slots ended in generic policy rejection while more extreme presets could succeed.
- Root cause: policy mapping confirmed; exact BeamNG candidate evidence remains partially confirmed. Optional/unknown non-critical evidence could become rejection and the public result discarded the deciding rule.
- Why v0.7.6 allowed it: one coarse chaos acceptance result mixed runtime integrity, drivability, optional capability and verification uncertainty.
- Fix/invariant: Balanced rejects proven runtime/drivability failure only, accepts warning-only optional uncertainty, and publishes the full structured decision without relaxing Maximum Chaos or ownership.
- Automated reproduction: warning acceptance and proven-failure rejection pass.
- Live retest: Scenario E; **Pending owner validation**.

### LIVE-076-DETAILS-01

- Symptom/live evidence: the global CTA was visible but opened nothing.
- Root cause: confirmed in component topology. The global toggle had no shell-owned drawer; a details component existed only in a tab-specific path.
- Why v0.7.6 allowed it: CTA visibility followed generic result text, not availability of a mounted target/payload.
- Fix/invariant: one shell drawer, exact result payload and no CTA without data.
- Automated reproduction: open/copy/exact Race payload/no-data cases pass.
- Live retest: Scenario J; **Pending owner validation**.

### LIVE-076-PREVIEW-01

- Symptom/live evidence: marker counts and completion appeared without a visible marker frame.
- Root cause: frontend semantics confirmed; exact renderer availability remains live-dependent. Placement-data readiness was presented too close to visual success.
- Why v0.7.6 allowed it: fallback marker count and render capability were not sufficiently distinct in the normal flow.
- Fix/invariant: only successful drawn frame is visible; unavailable renderer produces an immediate explicit fallback list and never blocks physical placement.
- Automated reproduction: unavailable/error/success/retry mounted cases pass.
- Live retest: Scenarios H/J; **Pending owner validation**.

### LIVE-076-AI-READY-01

- Symptom/live evidence: generated/managed counts enabled Behavior without proving that every slot could drive or accept AI commands.
- Root cause: confirmed in readiness derivation; live command behavior remains partially confirmed. Accepted existence was an input to readiness before per-slot dispatch/readback evidence.
- Why v0.7.6 allowed it: generation outcome stood in for drivability and AI capability.
- Fix/invariant: independent readiness axes; a proven non-drivable slot cannot be scheduled; AI-ready requires confirmed command/readback.
- Automated reproduction: axis and dispatch refusal/confirmation cases pass.
- Live retest: Scenarios E/G; **Pending owner validation**.

### LIVE-076-RACE-RECOVERY-01

- Symptom/live evidence: a failed attempt could leave Race semi-locked without a clear transactional continuation.
- Root cause: coordinator recovery semantics confirmed; exact live trigger remains partially confirmed. Attempt lock release and persistent desired setup/action were not one contract.
- Why v0.7.6 allowed it: transient operation state and user recovery state shared lifecycle.
- Fix/invariant: release transient lock on recoverable failure, retain requested setup and a real action, and issue fresh operation/generation on retry.
- Automated reproduction: retry and stale-callback cases pass.
- Live retest: Scenario J; **Pending owner validation**.

