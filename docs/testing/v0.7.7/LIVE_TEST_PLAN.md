# v0.7.7 live test plan

Status: **Pending owner validation; not executed**.

Execute only with the exact ZIP downloaded from the public v0.7.7 prerelease.
Record the full BeamNG 0.39.4.x build, renderer, language, installed-mod state,
map, player model/configuration, ZIP filename, byte size and SHA-256 before any
case. Automated results do not satisfy these cases.

| ID | Scenario | Required procedure and acceptance |
| --- | --- | --- |
| A | Garage Compare | Open Garage, Saved and Compare; change filters, return and repeat 20 times while payloads update. No error boundary may fire and saved/filtered empty states must remain distinct. |
| B | Blank and explicit seed | Generate twice with a blank field and record episode/slot seeds; both episodes and their slot streams must differ. Generate twice with the first explicit seed and verify supported deterministic reproduction. Repeat must be a visibly separate intent. |
| C | Generation cleanup | Generate three opponents, count the world, then generate again. Exact prior Race-owned vehicles must be reconciled, temporary count must return to zero, and unrelated/player/remote vehicles must remain untouched. |
| D | Managed Regenerate | Record one slot's concrete ID, Regenerate, verify that the accepted candidate replaces the source and world count is stable. Repeat, then exercise failure and cancellation: source remains and candidate is removed. |
| E | Balanced | Confirm a non-empty pool, generate, capture the exact policy profile/rule/evidence/decision and verify that warning-only optional evidence is accepted while proven runtime/drivability failure remains rejected. Confirm intended AI suitability separately. |
| F | Mods Showcase without mods | In a clean no-mod profile, preflight must stop before slot creation with a localized zero-pool explanation and usable alternative preset/retry actions. |
| G | Maximum Chaos | Generate and preserve visible diversity/extremity. Record generation-ready, placement-ready, drivable and AI-ready independently; warnings must not become false partial application. |
| H | Formation without renderer | With three ready NPCs and World Preview unavailable, calculate placements, then Position first, next and all. Each action moves only its intended exact slots; Cancel affects only the current positioning operation. |
| I | Canonical order | Move competitors up/down and prove the new order is used by cards, placement, AI target/role order, export and reload. |
| J | Details and recovery | Force a warning and a recoverable failure. Details must open for the matching operation/slot, show human and technical evidence, copy diagnostics, and expose a real recovery action; no empty Details CTA may exist. |
| K | UI/i18n/compatibility | Exercise widths 320/360/400/480/600/720 in pt-BR, en-US and es-ES across Garage, Events and Locks. Verify long-label reflow/ellipsis/focus, explicit normal/compact geometry, scoped dismissible compatibility notice, no ordinary-flow technical IDs and no severe overflow/dead space. |

## Cross-case evidence

For Race cases capture generation ID, episode seed, slot/slot seed, preset,
candidate and accepted IDs, managed handle, placement ID, ownership/authority,
policy decision, drivability, AI dispatch/readback, old/new/removed owned IDs,
temporary/peak counts and renderer/fallback state. Capture player/camera focus
before, during and after staging. A timing or screenshot proves only the exact
run it records.

Do not mark a case Passed without reviewed evidence from the published asset.

