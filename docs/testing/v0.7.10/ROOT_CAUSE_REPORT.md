# v0.7.10 root cause report

Source evidence: the owner's v0.7.9 live session on BeamNG.drive
0.39.4.0.20972 / Direct3D 11 (2026-09-27), the game log `beamng.log` from that
session and the persisted lineup library entry `lineup-015B3BDA` (Race Custom,
4 vehicles, player participating). Every cause below was reproduced by a
contract test before it was fixed; none is claimed as live-verified.

## 1. Preview calculated but never visible

**Observed.** Four markers in the UI, `PREVIEW_DATA_READY`, then
`PREVIEW_FAILED` "renderer unavailable". The log shows
`race_preview_state_changed ... preview_renderer_unavailable, attemptedFrames:
1227, renderedMarkerCount: 0` — `onPreRender` ran every frame.

**Cause.** The renderer considered itself available only when
`type(ColorF) == "function"`. BeamNG binds `ColorF`/`ColorI` as C++ LuaIntf
classes: callable tables, not Lua functions. The check was always false, so no
frame was ever drawn. The AI destination marker used the same check and never
drew either. Tests passed because every mock defined `ColorF` as a plain Lua
function. A dead second copy of the draw code also lived in `spawnApiAdapter`.

**Fix.** `racePreviewRenderer` receives `debugDrawer`, `ColorF`, `ColorI` and
`vec3` from the GE caller and proves them once with a behavioral probe that
calls each binding; each missing binding is named
(`preview_debug_drawer_missing`, `preview_color_api_missing`,
`preview_vector_api_missing`, `preview_draw_method_missing`). Geometry draws
first; text is optional. Probe results are logged once per change as
`race_preview_runtime_probe`. Tests now model `ColorF` as a callable table and
drive `previewRaceGeneration → onPreRender` end to end. The duplicate draw
code was removed; draw lists and colors are cached per preview change.

## 2. Race Custom ended with 0 usable opponents

**Observed.** Slot 1 `Partial`, slots 2–3 `Failed` with
`no_eligible_vehicles`; 0 ready, 0 placeable, 0 AI-ready.

**Causes (a chain).**

1. *Custom had no state of its own.* Choosing Custom applied no template, so it
   silently kept the previous preset's policy — Mods Showcase's
   `allowOfficialVehicles = false`. With no mods installed, only the five user
   configurations remained, all `vivace`.
2. *A rejected slot constrained the pool.* Slot 1 was a policy-rejected partial
   (undrivable, `acceptPartial = false`) but was still passed to later slots as
   an accepted competitor, so `avoidDuplicateModels` excluded `vivace`.
3. *No relaxation and no recovery.* An empty pool failed immediately; retry and
   official fallback required manual clicks per slot, and every failed attempt
   counted toward the consecutive-failure stop.
4. *The rejected vehicle stayed in the world.* The run completed and was
   domain-accepted before the Race policy rejected it; the cleanup guard
   required `owner.accepted ~= true`, so it never deleted the vehicle.

**Fix.** Diversity references come only from slots holding an accepted, bound
vehicle. An empty strict pool relaxes variety only, deterministically:
traits/family, then repeated model, then repeated configuration; source,
trailer, prop, integrity, drivability and ownership rules never relax. A slot
without an accepted vehicle retries with a new attempt substream, then uses one
verified official fallback when official vehicles are allowed; rejected
candidates are not offered again and only terminal slot failures count toward
the stop. A policy-rejected candidate is removed after `authorizeDiscard`
proves it came from this exact operation and generation, or is queued as an
orphan. Fixed presets are backend templates (`PRESET_POLICIES`); Custom
persists `customPolicy`; editing a fixed preset converts it to Custom. The
global Randomizer content filter no longer narrows a Race. Preferences saved by
v0.7.9 with preset Custom are adopted as the Custom policy.

## 3. Position All did not position everyone

**Observed.** Nothing to position in the last case (cause 2), and slow,
incomplete placement earlier.

**Causes.** With zero generated opponents there was nothing to place — an
upstream failure presented as a button failure. Independently, placement
readback demanded bit-identical positions on two consecutive scans; a car
settling on its suspension moves a few centimetres per frame, so it could wait
for the 25 s spawn timeout, receive a second teleport and fail. Mixed selections
could also send existing vehicles through the sequential spawn pipeline.

**Fix.** A single reposition executor (`racePlacement`) teleports every slot in
one step, reads all of them back in parallel, accepts 5 cm settling between
scans, bounds one attempt at 5 s and retries only the slot that failed. Existing
vehicles are always repositioned as that batch. Zero placeable opponents now
disables placement and offers "Fix generation".

## 4. Line/Grid deformed even on an empty map

**Cause.** Formation neighbours were "blocked" when closer than
`0.6 × spacing`, where `spacing` is sized for the longitudinal gap (6.3 m →
3.78 m) while Line's width-based lateral gap is 3.5 m. Every side-by-side
neighbour was rejected, the rigid-group solver exhausted its attempts and the
per-slot fallback deformed the formation.

**Fix.** Members of one formation are compared by footprint along the
formation axes (half widths/lengths plus half the safety margin); external
objects keep their radial clearance. Line, Grid, Single File Ahead and Behind
now plan rigidly and undegraded around a participating player in an empty map.

## 5. Behavior blocked, unclear cause

**Causes.** AI refused to start whenever `generationState` was
`lineup_partial` (some slots failed) unless partial *vehicles* were accepted —
two different concepts — so two good NPCs could not start because a third
failed. Readiness was also re-derived differently in `main.lua`, the summary
and the Vue components.

**Fix.** Canonical `isGenerationUsable`, `isPlacementUsable` and `isAIUsable`
drive the summary, placement availability, AI eligibility and the published
per-slot flags. AI starts when generation has finished and at least one
opponent is AI-usable; per-slot failures are reported as
"2/3 NPCs started · 1 could not start". The Events UI presents backend counts.

## Simplification carried out

- Removed: `lineupManager.lua` + `compat/legacyLineupFacade.lua` (alias-only),
  `playgroundMode.lua` + `contactDetector.lua` (no call site; required only to
  satisfy the reachability gate), `lineupStorage.lua` (merged into
  `lineupPersistence`), the duplicate preview draw code, three Race Vue
  components, 62 orphaned translation keys per locale and dead CSS.
- Added: `racePlacement.lua` (placement executor extracted from `main.lua`),
  `RaceStartStep.vue`, `useRaceReadiness.js`, `racePolicy.js`.
- One authorization primitive (`authorizeManagedMutation`) with cleanup,
  placement, replacement and discard wrappers replaced placement's reuse of the
  cleanup check; both placement paths share `authorizeSlotPlacement`.
- Published state no longer deep-copies unused per-slot operation payloads or a
  second copy of the Preview.
- `npm run verify` replaces overlapping gates. The documented local sequence
  took 51 s; `verify` takes about 27 s on the same machine. CI's validation job
  went from about 75 s to 38 s. Packaging no longer re-runs test suites.
