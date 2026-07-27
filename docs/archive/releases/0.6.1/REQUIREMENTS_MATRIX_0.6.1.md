# Requirements Matrix 0.6.1

This matrix traces the v0.6.1 master prompt to implementation and evidence. `Automated verified` means the named test passed locally on 2026-07-26. It is not a claim of live gameplay validation. UI rows that require visual judgment remain `Automated verified / interactive Pending`. Release rows remain Pending until their external action has actually completed.

## Automated requirements

| ID | Requirement | Responsible file | Function/module | Test | Status |
|---|---|---|---|---|---|
| R01 | Random Car completes without a pause toggle. | `main.lua`, `operationState.lua` | spawn lifecycle | `v061_paused_pipeline_finishes_without_toggle` | Automated verified |
| R02 | Scramble completes without a pause toggle. | `main.lua`, `operationState.lua` | mutation lifecycle | `v061_paused_pipeline_finishes_without_toggle` | Automated verified |
| R03 | Full Random completes without a pause toggle. | `main.lua`, `operationState.lua` | full pipeline | `v061_paused_pipeline_finishes_without_toggle` | Automated verified |
| R04 | An operation started paused does not deadlock. | `main.lua` | `onUpdate`, phase processing | `v061_paused_pipeline_finishes_without_toggle` | Automated verified |
| R05 | A pause toggle does not change the target. | `vehicleTargetTracker.lua` | target identity | `v060_pause_mid_pipeline_and_frame_step_contract` | Automated verified |
| R06 | A pause toggle is never required to make progress. | `main.lua` | pause-independent phases | `v061_paused_pipeline_finishes_without_toggle` | Automated verified |
| R07 | Target identity stays stable while the parts tree changes. | `vehicleTargetTracker.lua` | identity/tree separation | `v060_target_identity_tree_separation_contract` | Automated verified |
| R08 | Lifecycle housekeeping continues during target tracking. | `main.lua` | `onUpdate` | `v060_onupdate_housekeeping_contract` | Automated verified |
| R09 | Cancel works during a wait phase. | `main.lua` | `cancelCurrentOperation` | `v060_busy_cancel_and_diagnostics_contract` | Automated verified |
| R10 | Busy clears for every terminal result. | `operationState.lua`, `main.lua` | terminal cleanup | `v060_busy_cancel_and_diagnostics_contract` | Automated verified |
| R11 | `dtSim = 0` does not invalidate a target. | `main.lua`, `vehicleTargetTracker.lua` | dual-clock tracking | `v061_paused_pipeline_finishes_without_toggle` | Automated verified |
| R12 | Wall-clock deadlines continue while simulation is paused. | `vehicleTargetTracker.lua` | tracker deadline | `v061_target_deadline_uses_wall_clock_while_paused` | Automated verified |
| R13 | Old callbacks are rejected. | `main.lua` | lifecycle generations | `v060_explicit_lifecycle_generations_contract` | Automated verified |
| R14 | A recovery generation blocks old writes. | `main.lua`, `vehicleRecovery.lua` | recovery isolation | `v060_recovery_stale_callback_isolation_contract` | Automated verified |
| R15 | Timeout does not automatically restart the same cycle. | `main.lua` | bounded read failure | `v061_persistent_parts_read_fails_terminally` | Automated verified |
| R16 | Every new click receives fresh RNG state. | `apiAdapter.lua`, `main.lua` | `entropy`, `operationSeed` | `v061_seed_modes_refresh_or_reproduce` | Automated verified |
| R17 | An empty manual seed produces fresh entropy. | `settings.lua`, `main.lua` | random seed mode | `v061_seed_modes_refresh_or_reproduce` | Automated verified |
| R18 | A fixed seed reproduces the result. | `settings.lua`, `main.lua` | fixed seed mode | `v061_seed_modes_refresh_or_reproduce` | Automated verified |
| R19 | Random Car avoids an immediate repeat when alternatives exist. | `main.lua`, `selection.lua` | recent-result filter | `anti_repeat_selection` | Automated verified |
| R20 | Recovery is not recorded as a new random result. | `main.lua` | snapshot/result promotion | `v060_recovery_snapshot_roles_contract` | Automated verified |
| R21 | Retry uses its own deterministic substream. | `lineupManager.lua` | race domain seed | `v060_lineup_variety_substreams_and_failure_actions` | Automated verified |
| R22 | Plans from the previous operation are cleared. | `vehicleRecovery.lua` | `invalidateForRecovery` | `v061_recovery_invalidation_drops_all_old_plans` | Automated verified |
| R23 | Same model/config selection has explicit provenance/reason. | `main.lua` | selection provenance | `v061_seed_modes_refresh_or_reproduce` | Automated verified |
| R24 | Recent-result filtering respects manual seed and replay exceptions. | `main.lua` | recent windows | `v061_seed_modes_refresh_or_reproduce` | Automated verified |
| R25 | A clean spawn is not promoted to `lastCompletedGood`. | `main.lua` | snapshot roles | `v060_recovery_snapshot_roles_contract` | Automated verified |
| R26 | An unaccepted partial result is not promoted. | `main.lua` | snapshot roles | `v060_recovery_snapshot_roles_contract` | Automated verified |
| R27 | Only the final completed result is promoted. | `main.lua` | terminal snapshot promotion | `v060_recovery_snapshot_roles_contract` | Automated verified |
| R28 | Recovery terminates the operation. | `main.lua`, `vehicleRecovery.lua` | recovery terminal | `v060_recovery_stale_callback_isolation_contract` | Automated verified |
| R29 | Recovery cannot execute an old tuning plan. | `vehicleRecovery.lua` | plan invalidation | `v061_recovery_invalidation_drops_all_old_plans` | Automated verified |
| R30 | Recovery cannot execute an old paint plan. | `vehicleRecovery.lua` | plan invalidation | `v061_recovery_invalidation_drops_all_old_plans` | Automated verified |
| R31 | Recovery loops reach a bounded terminal limit. | `main.lua` | read retry/deadline | `v061_persistent_parts_read_fails_terminally` | Automated verified |
| R32 | A failed candidate enters quarantine. | `main.lua`, `blacklist.lua` | candidate isolation | `alpha2_recovery_contract` | Automated verified |
| R33 | Settings migration clears legacy persisted locks. | `settings.lua` | schema-6 migration | `v061_settings_locks_and_seed_migration` | Automated verified |
| R34 | A new session begins unlocked. | `settings.lua`, `default.json` | lock defaults | `v061_settings_locks_and_seed_migration` | Automated verified |
| R35 | Remember locks defaults to Off. | `settings.lua`, `default.json` | persistence policy | `v061_settings_locks_and_seed_migration` | Automated verified |
| R36 | Active-lock warning appears only when locks exist. | `app.html` | Chaos warning | `v061_compact_ui_contract`, `test_v061_chaos_seed_slider_and_brand_contract` | Automated verified / interactive Pending |
| R37 | Unlock All remains available. | `app.html`, `app.js` | `unlockAll` | `v061_compact_ui_contract` | Automated verified |
| R38 | Fixed-seed warning is visible. | `app.html` | Chaos warning | `v061_compact_ui_contract` | Automated verified / interactive Pending |
| R39 | Clearing a fixed seed restores random-every-run mode. | `app.js`, `settings.lua` | `clearFixedSeed` | `v061_settings_locks_and_seed_migration` | Automated verified |
| R40 | Balanced applies real policy values. | `lineupManager.lua` | `presetOptions` | `v061_race_presets_apply_real_policy` | Automated verified |
| R41 | Maximum Chaos applies real policy values. | `lineupManager.lua` | `presetOptions` | `v061_race_presets_apply_real_policy` | Automated verified |
| R42 | Mods Showcase applies real policy values. | `lineupManager.lua` | `presetOptions` | `v061_race_presets_apply_real_policy` | Automated verified |
| R43 | Manual Race policy changes mark the preset Custom. | `app.js` | `markRaceCustom` | `v061_compact_ui_contract` | Automated verified |
| R44 | A competitor leaves Pending when processing starts. | `lineupManager.lua` | `nextCompetitor`, `setPhase` | `v061_race_statuses_and_cancel_are_terminal` | Automated verified |
| R45 | Competitor timeout terminates as Failed. | `main.lua`, `lineupManager.lua` | failure record | `v061_persistent_parts_read_fails_terminally` | Automated verified |
| R46 | Cancel gives every open competitor a terminal status. | `lineupManager.lua` | `cancel` | `v061_race_statuses_and_cancel_are_terminal` | Automated verified |
| R47 | Competitor generation does not depend on pause. | `main.lua` | Race pipeline | `v061_paused_pipeline_finishes_without_toggle` | Automated verified |
| R48 | One competitor failure does not contaminate the next. | `lineupManager.lua`, `main.lua` | per-competitor state | `v060_lineup_variety_substreams_and_failure_actions` | Automated verified |
| R49 | No Ready cars blocks Placement with an explanation. | `app.html`, `app.js` | Race gating | `v061_compact_ui_contract`, `test_v061_race_workflow_and_presets_are_visible` | Automated verified / interactive Pending |
| R50 | No managed cars blocks Drive with an explanation. | `app.html`, `app.js` | Race gating | `v061_compact_ui_contract`, `test_v061_race_workflow_and_presets_are_visible` | Automated verified / interactive Pending |
| R51 | Race seed uses independent substreams. | `lineupManager.lua` | `domainSeed` | `v060_lineup_variety_substreams_and_failure_actions` | Automated verified |
| R52 | A recovery result cannot be accepted as a competitor. | `main.lua`, `lineupManager.lua` | result acceptance | `v060_recovery_snapshot_roles_contract` | Automated verified |
| R53 | The top navigation has exactly Chaos, Garage, Race, Settings. | `app.js`, `app.html` | navigation | `v061_compact_ui_contract`, `test_v061_navigation_is_exact_and_compact` | Automated verified / interactive Pending |
| R54 | Chaos has no seed input. | `app.html` | Chaos/Settings separation | `v061_compact_ui_contract`, `test_v061_chaos_seed_slider_and_brand_contract` | Automated verified |
| R55 | Chaos has no lock category chips. | `app.html` | Chaos/Settings separation | `v061_compact_ui_contract` | Automated verified |
| R56 | Garage contains Saved, Compare and Share. | `app.html` | Garage sub-navigation | `v061_compact_ui_contract`, `test_v061_navigation_is_exact_and_compact` | Automated verified |
| R57 | Race contains Cars, Placement and Drive. | `app.html` | Race sub-navigation | `v061_compact_ui_contract`, `test_v061_navigation_is_exact_and_compact` | Automated verified |
| R58 | Ambiguous C and S header controls are removed. | `app.html` | header tools | `v061_compact_ui_contract` | Automated verified |
| R59 | Collapsed mode materially reduces height. | `app.css`, `app.js` | collapsed layout | `v061_compact_ui_contract`, `test_v061_compact_size_and_mode_contract` | Automated verified / interactive Pending |
| R60 | Expanded Chaos fits the 340×320 default without normal scrolling. | `app.json`, `app.css` | expanded layout | `v061_compact_ui_contract`, `test_v061_compact_size_and_mode_contract` | Automated verified / interactive Pending |
| R61 | Essential UI text is at least 12 px. | `app.css` | typography | `v061_compact_ui_contract` | Automated verified / interactive Pending |
| R62 | Primary buttons are at least 44 px high. | `app.css` | action sizing | `v061_compact_ui_contract` | Automated verified / interactive Pending |
| R63 | Slider thumb aligns at 0%. | `app.css` | WebKit range styling | `v061_compact_ui_contract`, `test_v061_chaos_seed_slider_and_brand_contract` | Automated verified / interactive Pending |
| R64 | Slider thumb aligns at 50%. | `app.css` | WebKit range styling | `v061_compact_ui_contract` | Automated verified / interactive Pending |
| R65 | Slider thumb aligns at 100%. | `app.css` | WebKit range styling | `v061_compact_ui_contract`, `test_v061_chaos_seed_slider_and_brand_contract` | Automated verified / interactive Pending |
| R66 | Slider layout works at 125%, 150% and 200%. | `app.css` | responsive range layout | `v061_compact_ui_contract` | Automated verified / interactive Pending |
| R67 | The fox SVG loads from a packaged local asset. | `fox-mark.svg`, `app.css` | brand asset | `v061_compact_ui_contract`, `test_v061_chaos_seed_slider_and_brand_contract` | Automated verified / interactive Pending |
| R68 | The fox does not block the title. | `app.css`, `app.html` | header layout | `v061_compact_ui_contract` | Automated verified / interactive Pending |
| R69 | The fox is decorative. | `app.html`, `fox-mark.svg` | `aria-hidden`, safe SVG | `v061_compact_ui_contract`, `test_v061_chaos_seed_slider_and_brand_contract` | Automated verified / interactive Pending |
| R70 | Busy status shows the current phase. | `app.html`, `main.lua` | public lifecycle state | `v061_compact_ui_contract`, `test_v061_lifecycle_controls_remain_available` | Automated verified |
| R71 | Cancel is visible while Busy. | `app.html` | operation controls | `v061_compact_ui_contract`, `test_v061_lifecycle_controls_remain_available` | Automated verified |
| R72 | Details are available after failure. | `app.html` | diagnostics controls | `v061_compact_ui_contract` | Automated verified |
| R73 | A temporary nil parts tree recovers via bounded retry. | `main.lua` | mutation read retry | `v061_bounded_parts_read_recovers` | Automated verified |
| R74 | A persistent nil parts tree fails terminally with a reason. | `main.lua` | mutation read deadline | `v061_persistent_parts_read_fails_terminally` | Automated verified |
| R75 | An external error cannot change target ownership. | `vehicleTargetTracker.lua`, `main.lua` | target generations | `v060_target_identity_tree_separation_contract` | Automated verified |
| R76 | A missing callback cannot leave Busy infinite. | `vehicleTargetTracker.lua`, `main.lua` | wall-clock timeout | `v061_target_deadline_uses_wall_clock_while_paused` | Automated verified |

## Delivery and compatibility requirements

| ID | Requirement | Responsible file/action | Module | Test/evidence | Status |
|---|---|---|---|---|---|
| D01 | Preserve Vehicle DNA schema 1, generator 6 and `SCR6` compatibility. | `vehicleDNASchema.lua`, `rng.lua`, `VERSION` | compatibility | full automated suite | Automated verified |
| D02 | Preserve legacy lineup/race schema and `.lineup.json` reads. | `lineupManager.lua`, UI bridge | compatibility | lineup import tests | Automated verified |
| D03 | Maintain an exact 50-case v0.6.1 live evidence plan and honest report. | `INTERACTIVE_TEST_PLAN_0.6.1.md`, `INTERACTIVE_TEST_REPORT_0.6.1.md` | live evidence | document review | Implemented; 50 Pending |
| D04 | Update all named user and maintainer documentation using public Race terminology. | README, CHANGELOG, ROADMAP, named `docs/` files | documentation | link/static tests | Implemented |
| D05 | Produce 0.6.1 ZIP, checksum and manifest pointing to the final commit. | `tools/package.py`, `tools/package_mod.py`, `dist/` | packaging | package suite and asset audit | Pending |
| D06 | Push directly to `origin/main`, without PR, public branch or force push. | Git/GitHub | delivery | remote SHA audit | Pending |
| D07 | Wait for green CI before creating the annotated v0.6.1 tag. | GitHub Actions | CI/release gate | checks URL and tag timestamps | Pending |
| D08 | Publish the exact title, disclosure and three new assets. | GitHub Release | release | re-download/hash/manifest validation | Pending |
| D09 | Do not alter v0.6.0 or any earlier tag, release or asset. | Git/GitHub | historical integrity | before/after object and asset audit | Verified before work; final audit Pending |

## Evidence summary

- Local automated run: **44/44 Python tests passed**, including **304/304 Lua cases**.
- v0.6.1 interactive execution: **0 Passed / 0 Failed / 50 Pending / 0 Blocked**.
- Historical v0.6.0 observed failures are retained as historical evidence in the v0.6.1 report; they are not counted as v0.6.1 executions.
