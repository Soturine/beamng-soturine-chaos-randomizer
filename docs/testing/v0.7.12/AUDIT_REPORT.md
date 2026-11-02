# v0.7.12 audit report

Baseline: v0.7.11 (`7277456`). Audit date: 2026-11-02. Game: BeamNG.drive
**0.40.4.0, build 296339** installed (Steam build 26298565). The launcher
recorded the 0.39.4 → 0.40.4 user-folder upgrade on 2026-11-02 00:16, but the
game itself never wrote a 0.40 `beamng.log` with this mod, so **no live 0.40
evidence exists**. Everything below is source, contract or tool evidence.

Related: [0.40 API impact matrix](../../BEAMNG_0.40_COMPATIBILITY.md),
[Lua module inventory](LUA_MODULE_INVENTORY.md),
[live checklist](LIVE_RESULTS.md),
[Assertiva/Derivanta dogfood](../../assurance/ASSERTIVA_DOGFOOD_v0.7.12.md).

Status vocabulary: WORKS_WITH_EVIDENCE, PARTIAL, BLOCKED_BY_UPSTREAM, BROKEN,
STUB/WIRING_ONLY, UNSUPPORTED_BY_ENGINE, UNVERIFIED_LIVE, DEAD/LEGACY, UNKNOWN.
"After" is never better than UNVERIFIED_LIVE without an owner session.

## Functional matrix

| Feature | Before (v0.7.11) | Cause | Change in v0.7.12 | After | Live |
| --- | --- | --- | --- | --- | --- |
| Random Car / Full Random | UNVERIFIED_LIVE | could target the walking `unicycle` | refused with `player_on_foot`; shared car refused | UNVERIFIED_LIVE | pending (11, 12, 14) |
| Scramble | UNVERIFIED_LIVE; BROKEN in 0.40 split-screen | implicit part API follows `core_vehicle_configTarget` | ID-bound write when the target is foreign | UNVERIFIED_LIVE | pending (11, 16) |
| Verification readback | false-green risk in 0.40 | foreign config accepted as `player_partmgmt` candidate | foreign implicit read refused | contract-tested | pending (16) |
| Undo / rollback / cancel | UNVERIFIED_LIVE | - | none | UNVERIFIED_LIVE | pending (11) |
| Locks (UI) | PARTIAL | configuration, category, slot and presets have controls; part/tuning/paint locks are console API only | none (documented public API, kept) | PARTIAL | - |
| Garage / Vehicle DNA | UNVERIFIED_LIVE | - | none; 0.40 APIs it uses unchanged in source | UNVERIFIED_LIVE | pending (15) |
| Race generation | UNVERIFIED_LIVE (0.7.10 failures fixed in 0.7.11, never retested) | - | none | UNVERIFIED_LIVE | pending (4) |
| Formation preview | renderer seen live in 0.7.10; follow unverified | - | none | UNVERIFIED_LIVE | pending (2, 3) |
| Position All | UNVERIFIED_LIVE | - | teleport refuses a car with a player aboard | UNVERIFIED_LIVE | pending (5) |
| Remove / Regenerate / cleanup | BROKEN under 0.40 occupants | only `lineup.playerVehicleId` was protected | any local player or seat presence blocks delete | contract-tested, 7 mutants killed | pending (6, 17) |
| AI presets (Follow, Convoy, Chase, Flee, Traffic, Roam, Swarm) | STUB-like status | `readMode` probed GE getters BeamNG lacks, so every dispatch showed "running" | Vehicle Lua `ai.mode` probe; mismatch fails, silence = unconfirmed | probe executed as Lua text in tests | pending (7) |
| Destination / Route | as above + wrong mapping | expected `traffic`, BeamNG sets `manual` | mapping fixed; old test corrected | contract-tested | pending |
| Pause / Resume / Stop | UNVERIFIED_LIVE | - | none | UNVERIFIED_LIVE | pending (8) |
| Reset AI | STUB/WIRING_ONLY | handler without a control | button in Start step | UNVERIFIED_LIVE | pending (8) |
| Recording toggle | STUB/WIRING_ONLY | recorded on the NPC (its AI switched off), path discarded, state never published | replaced by Record my route on the player's car | contract-tested | pending (9) |
| Recorded playback | "unsupported" | claimed no contract; 0.40.4 `scriptai` provides one | implemented; each car starts from its slot | contract-tested | pending (10) |
| Scripted path | UNSUPPORTED | - | still not offered: Route covers user points (reason text corrected) | not offered | - |
| Tag / Pega-Pega | DEAD (modules removed in 0.7.10) | README still described it | README corrected; ROADMAP keeps it as future work | DEAD/LEGACY doc fixed | - |
| "Transfer ownership" hint | BROKEN guidance | no transfer command existed | message names the real action; dead `transferVehicle` removed | fixed | - |
| Split-screen safety | not modelled | only player 0 known | occupancy model, see 0.40 matrix | contract-tested | pending (16, 17) |
| Percheron / new 0.40 content | UNKNOWN | - | none needed by source (`slots2` normalised by the engine, core slots never emptied) | UNVERIFIED_LIVE | pending (13) |
| Ctrl+L / reload | UNVERIFIED_LIVE | - | none | UNVERIFIED_LIVE | pending (18) |

## Simplification

| Item | Evidence | Action |
| --- | --- | --- |
| 10 dead functions (`addPendingCallback`, `resolvePendingCallback`, `transferVehicle`, `allows`, `markMany`, `arrayToSet`, `isCritical`, `validateProtectedScan`, `setLockProfile`, `isDomain`) | definition + export only; internal modules; no dynamic lookup; the pending-callback pair indexed fields never initialised | removed |
| 9 unused export aliases of used internals | name appears only on the `M.x =` line | export removed, internals kept |
| `aiModeConfirmation.unavailable` | no caller after the probe change | removed |
| `vehicleSelector.lua` | same algorithm as `configSelector` | merged; deterministic draw unchanged (test) |
| Old `readMode` getter probing | probed methods that do not exist in BeamNG | replaced by the real contract |
| Three copies of console discovery/staging (`lua_metrics`, `profile_fixtures`, `benchmark_v069`) | identical code | one `run_lua_file`; benchmarks in `tools/lua_benchmarks.py` |
| Public AI list deep-copied route nodes | UI reads `handle`/`status` only | projection |

Counts (measured): Lua modules 106 → 106 (−1 merged, +1 Vehicle Lua recorder),
27,928 → 28,124 lines; Python files 16 → 16 (−2 merged benchmarks, +1 merged
runner, +1 host snapshot generator), 106,464 → 112,713 bytes. None of the
Python, JS or test files enters the ZIP or runs in the game; they cost CI and
maintenance time, not FPS. `main.lua` and `apiAdapter.lua` decomposition stays
ROADMAP v0.8.0 debt: nothing in this release needed it, and splitting
`main.lua` without an integration seam would be riskier than the fixes.

## Toolchain

| Script / job | Purpose | Caller | Decision |
| --- | --- | --- | --- |
| `tools/verify.py` | single validation path | npm scripts, CI, package workflow | KEEP |
| `tools/sync_version.py` | VERSION-derived metadata | verify | KEEP |
| `tools/validate_vue_sfc.mjs` | SFC compile | verify | KEEP |
| `tools/validate_ui_command_parity.py` | UI ⊆ bridge ⊆ backend | verify | KEEP |
| `tools/validate_vue_module_graph.mjs` | import graph; now named host exports | verify, validate_package (ZIP) | KEEP (strengthened) |
| `tools/beamng_host_exports.json` + `snapshot_host_exports.py` | 0.40.4 host export snapshot and its refresher | module graph | NEW |
| `tools/validate_vue_style_graph.mjs` | style graph | verify, validate_package (ZIP) | KEEP |
| `tools/package_mod.py` / `validate_package.py` | deterministic ZIP and its validation | verify | KEEP; version rule fixed |
| ZIP re-run of graph validators | source tree vs shipped artifact are different surfaces | validate_package | KEEP (not duplication) |
| `tools/validate_release_gate.py` | release evidence | verify:release | KEEP; policy fixed |
| `tools/lua_metrics.py` | Lua runner | test_lua, lua_benchmarks | KEEP (merged runner) |
| `tools/lua_benchmarks.py` | non-gating microbenchmarks | manual | MERGED from two scripts |
| `tests/test_v073_fixtures.py` | sanitized 0.39.4 registry fixture | unittest | KEEP (historical fixture) |
| `ci.yml` / `package.yml` | verify on push; verify:release on the tagged commit | GitHub | KEEP; release title fixed |
| `beta-readiness.yml` | manual Windows/Linux byte-identity | manual dispatch | KEEP (unique evidence) |

The Lua runner stages the suite in a temporary folder inside the game folder
because the BeamNG console's file system is rooted there; it is removed after
every run. Without a standalone Lua 5.1, this is the only way to run the real
modules on the shipped LuaJIT.

## Performance

| Measurement | Value | Note |
| --- | --- | --- |
| `npm run verify`, v0.7.11 baseline | 36.3 s | first, cold run on this machine |
| `npm run verify`, v0.7.12 | 24.7 s | warm run; no step was removed, so the difference is not claimed as an improvement |
| Lua suite inside verify | 19.5 s → 14.0 s | same caveat |
| Synthetic hot paths (BeamNG 0.40.4 console LuaJIT, 1 run) | idle 0.0002 ms p50; Chaos active 0.11 ms; Race 12 0.011 ms; Garage 500 0.81 ms; index full rebuild 35 ms | `tools/lua_benchmarks.py`; single noisy run; no FPS claim |
| Profile (500 models / 5000 configs) | index 0.07 s; scan 0.003 s; plan 0.004 s | same |
| AI list publish | route nodes/scripts no longer serialised per publish | structural; not timed |

FPS, GPU/VRAM and renderer cost are **not measured**: they need the game.

## Comparable projects

| Project | Version / date | Relevant functions | Code observable? | Learned / adapted | Limits of comparison |
| --- | --- | --- | --- | --- | --- |
| [Vehicle And Part Randomizer](https://www.beamng.com/resources/vehicle-and-part-randomizer.34361/) by _N_S_ | v4, 2026-08-31 | official/mod pools, no-repeat, sub-models, Empty Slot Chance, parts/paint/tuning | resource page only; no licence stated | author states "There is no verification of the final configuration" and powertrain/fuel mismatches; confirms the value of our readback, fuel/energy guards and critical-slot policy | no benchmark run; no code copied |
| [Extra AI Race Mission](https://www.beamng.com/resources/extra-ai-race-mission.24348/) by ますくろ | 0.6.0, 2026-10-15, states 0.37 compatibility; 0.40 update in progress | six race types, rival groups, checkpoint restarts, traffic types | resource page only; no licence stated | checkpoint-restart and "AI sits and revs at start" reports point at start-up confirmation, which our mode probe now provides | not 0.40-compatible yet; not a randomizer |
| [Official AI/Traffic modes](https://www.beamng.com/game/support/portal/gameplay/ai-traffic/) | current | Random, Chase, Flee, Follow, Manual, Span, Traffic | game source | mode names map to Vehicle Lua `ai.mode` values used by the probe | the page does not document script recording; the game source does |
| [Chaos Mod UI](https://www.beamng.com/resources/chaos-mod-ui.30357/) and similar effect mods | 2026 | timed random effects | page only | different scope (effects, not vehicle generation); nothing adopted | - |

No code or assets were copied. No superiority is claimed without a benchmark.

## Remaining gaps

- No live 0.40 evidence of any kind; 18 owner cases pending.
- Split-screen protection rests on 0.40.4 source contracts; two physical players untested.
- The AI Director glue in `main.lua` (dispatch → probe → confirmation) has no integration test seam; the adapter probe and the confirmation state machine are tested separately.
- Lock UI exposes configuration, category and slot locks only.
- Nine of the twelve requested languages fall back to English.
- The published v0.7.11 release carries the v0.7.10 title; the workflow is fixed, the old release was not edited.
