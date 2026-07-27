# Requirements Matrix 0.6.2

This matrix traces the v0.6.2 master prompt to implementation and evidence. `Pending implementation` is the initial WIP state. `Automated verified` may be used only after the named test passes on the final commit. `Interactive Pending` is not a gameplay-success claim.

## Mandatory automated requirements

| ID | Requirement | Responsible file | Function/module | Test | Status |
|---|---|---|---|---|---|
| R01 | Random Car without pause. | `main.lua` | Random Car lifecycle | `v062_random_car_without_pause` | Pending implementation |
| R02 | Scramble without pause. | `main.lua` | Scramble lifecycle | `v062_scramble_without_pause` | Pending implementation |
| R03 | Full Random without pause. | `main.lua` | Full Random lifecycle | `v062_full_random_without_pause` | Pending implementation |
| R04 | Race generation without pause. | `main.lua` | Race generation | `v062_race_generation_without_pause` | Pending implementation |
| R05 | Confirm identity before tree convergence. | `vehicleTargetTracker.lua` | ownership milestone | `v062_identity_precedes_tree` | Pending implementation |
| R06 | Tree change does not lose target. | `vehicleTargetTracker.lua` | identity/tree split | `v062_tree_change_preserves_target` | Pending implementation |
| R07 | Reject stale callback. | `operationState.lua`, `main.lua` | generation guards | `v062_stale_callback_rejected` | Pending implementation |
| R08 | Reject stale timer. | `operationState.lua`, `main.lua` | timer guards | `v062_stale_timer_rejected` | Pending implementation |
| R09 | Cancel during target tracking. | `main.lua` | cancel lifecycle | `v062_cancel_target_tracking` | Pending implementation |
| R10 | Cancel during parts reload. | `main.lua` | cancel lifecycle | `v062_cancel_parts_reload` | Pending implementation |
| R11 | Busy releases at every terminal. | `operationState.lua`, `main.lua` | terminal cleanup | `v062_busy_all_terminals` | Pending implementation |
| R12 | Wall deadline works with zero `dtSim`. | `timeSource.lua`, `operationState.lua` | monotonic deadline | `v062_wall_deadline_zero_dtsim` | Pending implementation |
| R13 | Pause toggle does not change generation. | `operationState.lua`, `main.lua` | lifecycle generations | `v062_pause_preserves_generation` | Pending implementation |
| R14 | Pause toggle does not change target. | `vehicleTargetTracker.lua`, `main.lua` | ownership | `v062_pause_preserves_target` | Pending implementation |
| R15 | Pause toggle is not required for progress. | `main.lua` | update pipeline | `v062_progress_without_pause_toggle` | Pending implementation |
| R16 | Housekeeping is never blocked by phase work. | `main.lua` | `onUpdate` | `v062_housekeeping_always_runs` | Pending implementation |
| R17 | Map unload clears runtime. | `main.lua` | unload hook | `v062_map_unload_terminal_cleanup` | Pending implementation |
| R18 | Extension unload clears runtime. | `main.lua` | unload hook | `v062_extension_unload_terminal_cleanup` | Pending implementation |
| R19 | Clean spawn does not promote recovery snapshot. | `main.lua`, `vehicleRecovery.lua` | snapshot roles | `v062_clean_spawn_not_promoted` | Pending implementation |
| R20 | Rejected partial does not promote snapshot. | `main.lua`, `vehicleRecovery.lua` | promotion gate | `v062_partial_not_promoted` | Pending implementation |
| R21 | Completed operation promotes snapshot. | `main.lua`, `vehicleRecovery.lua` | promotion gate | `v062_completed_promotes_snapshot` | Pending implementation |
| R22 | Recovery invalidates all plans. | `vehicleRecovery.lua` | recovery isolation | `v062_recovery_invalidates_plans` | Pending implementation |
| R23 | Recovery cannot execute old tuning. | `vehicleRecovery.lua`, `main.lua` | stale-plan guard | `v062_recovery_rejects_old_tuning` | Pending implementation |
| R24 | Recovery cannot execute old paint. | `vehicleRecovery.lua`, `main.lua` | stale-plan guard | `v062_recovery_rejects_old_paint` | Pending implementation |
| R25 | Recovery restores the explicitly selected snapshot. | `vehicleRecovery.lua`, `main.lua` | tiered recovery | `v062_recovery_explicit_snapshot` | Pending implementation |
| R26 | Detect recovery loop. | `recoveryCycleDetector.lua` | state fingerprint | `v062_recovery_loop_detected` | Pending implementation |
| R27 | Recovery loop terminates operation. | `main.lua` | hard terminal | `v062_recovery_loop_terminal` | Pending implementation |
| R28 | Failed candidate enters quarantine. | `blacklist.lua`, `main.lua` | candidate quarantine | `v062_failed_candidate_quarantine` | Pending implementation |
| R29 | New operation does not reuse stale candidate. | `main.lua` | operation isolation | `v062_new_operation_candidate_isolation` | Pending implementation |
| R30 | Failure cannot contaminate the next operation. | `main.lua`, `vehicleRecovery.lua` | cleanup | `v062_failure_next_operation_isolation` | Pending implementation |
| R31 | New operation creates a new RNG. | `main.lua`, `rng.lua` | `operationSeed` | `v062_fresh_rng_per_operation` | Pending implementation |
| R32 | Random seed changes. | `apiAdapter.lua`, `main.lua` | entropy seed | `v062_random_seed_changes` | Pending implementation |
| R33 | Fixed seed reproduces. | `settings.lua`, `main.lua` | fixed seed | `v062_fixed_seed_reproduces` | Pending implementation |
| R34 | Anti-repeat avoids immediate repeat. | `main.lua`, selectors | recent selection | `v062_anti_repeat` | Pending implementation |
| R35 | Anti-repeat does not affect replay. | `main.lua` | replay exception | `v062_replay_anti_repeat_exception` | Pending implementation |
| R36 | Recovery is not a new selection. | `main.lua` | result history | `v062_recovery_not_selection` | Pending implementation |
| R37 | Retry has an isolated substream. | `rng.lua`, `lineupManager.lua` | substreams | `v062_retry_substream` | Pending implementation |
| R38 | Scramble keeps its target. | `main.lua` | target-bound pipeline | `v062_scramble_target_isolation` | Pending implementation |
| R39 | Full Random keeps the new target. | `main.lua` | target-bound pipeline | `v062_full_random_target_isolation` | Pending implementation |
| R40 | Parent-first mutation rescans. | `main.lua`, `slotScanner.lua` | parts pipeline | `v062_parent_first_rescan` | Pending implementation |
| R41 | Tuning is read after parts. | `main.lua` | ordered pipeline | `v062_tuning_after_parts` | Pending implementation |
| R42 | Paint has bounded readback. | `paintVerification.lua`, `main.lua` | paint phase | `v062_paint_readback` | Pending implementation |
| R43 | Completed requires closed ledgers. | `main.lua`, coverage ledgers | completion gate | `v062_completion_requires_closed_ledgers` | Pending implementation |
| R44 | Partial is classified honestly. | `main.lua` | completion gate | `v062_partial_terminal` | Pending implementation |
| R45 | Critical failure terminates. | `main.lua`, `validator.lua` | safety terminal | `v062_critical_failure_terminal` | Pending implementation |
| R46 | Balanced preset applies real policy. | `lineupManager.lua` | Race presets | `v062_balanced_preset` | Pending implementation |
| R47 | Maximum Chaos applies real policy. | `lineupManager.lua` | Race presets | `v062_maximum_chaos_preset` | Pending implementation |
| R48 | Mods Showcase applies real policy. | `lineupManager.lua` | Race presets | `v062_mods_showcase_preset` | Pending implementation |
| R49 | Edited preset becomes Custom. | `app.js` | Race settings | `v062_race_custom_preset` | Pending implementation |
| R50 | Competitor leaves Pending. | `lineupManager.lua`, `main.lua` | Race state | `v062_competitor_leaves_pending` | Pending implementation |
| R51 | Competitor timeout terminates. | `lineupManager.lua`, `main.lua` | deadline | `v062_competitor_timeout_terminal` | Pending implementation |
| R52 | Race cancel terminates. | `lineupManager.lua`, `main.lua` | cancel | `v062_race_cancel_terminal` | Pending implementation |
| R53 | Race failure does not contaminate next. | `lineupManager.lua`, `main.lua` | per-car isolation | `v062_race_failure_isolation` | Pending implementation |
| R54 | Placement requires Ready car. | `app.js`, `spawnDirector.lua` | capability gate | `v062_placement_requires_ready` | Pending implementation |
| R55 | Drive requires Spawned/Managed car. | `app.js`, `aiDirector.lua` | capability gate | `v062_drive_requires_managed` | Pending implementation |
| R56 | Start and Stop AI work. | `main.lua`, `aiDirector.lua` | AI lifecycle | `v062_start_stop_ai` | Pending implementation |
| R57 | Unavailable capability is explained. | `capabilityModel.lua`, UI | degradation | `v062_capability_explanation` | Pending implementation |
| R58 | Managed vehicle ownership is enforced. | `managedVehicleRegistry.lua` | ownership | `v062_managed_vehicle_ownership` | Pending implementation |
| R59 | Save Vehicle DNA. | `vehicleDNA*.lua`, `main.lua` | Garage save | `v062_save_dna` | Pending implementation |
| R60 | Restore snapshot. | `vehicleDNARestore.lua`, `main.lua` | Garage restore | `v062_restore_snapshot` | Pending implementation |
| R61 | Replay generation. | `vehicleDNA.lua`, `main.lua` | Garage replay | `v062_replay_generation` | Pending implementation |
| R62 | Import compatibility. | `vehicleDNAImport.lua` | Garage import | `v062_import_compatibility` | Pending implementation |
| R63 | Export works. | `vehicleDNAPackage.lua` | Garage export | `v062_export_dna` | Pending implementation |
| R64 | Compare works. | `vehicleDNACompare.lua` | Garage compare | `v062_compare_dna` | Pending implementation |
| R65 | Share works. | `vehicleDNAPackage.lua` | Garage share | `v062_share_dna` | Pending implementation |
| R66 | Lineage is preserved. | `vehicleDNASchema.lua` | ancestry | `v062_dna_lineage` | Pending implementation |
| R67 | Mutation is target-isolated. | `main.lua`, `vehicleDNAMutations.lua` | Garage mutation | `v062_mutation_target_isolation` | Pending implementation |
| R68 | Reroll is target-isolated. | `main.lua`, `vehicleDNAMutations.lua` | Garage reroll | `v062_reroll_target_isolation` | Pending implementation |
| R69 | All locks default unlocked. | `settings.lua`, `defaults.json` | defaults | `v062_locks_default_unlocked` | Pending implementation |
| R70 | Remember locks defaults Off. | `settings.lua`, `defaults.json` | defaults | `v062_remember_locks_default_off` | Pending implementation |
| R71 | Fixed seed warning is shown. | `app.html`, `app.js` | warning | `v062_fixed_seed_warning` | Pending implementation |
| R72 | Clear seed restores random mode. | `app.js`, `settings.lua` | seed action | `v062_clear_seed` | Pending implementation |
| R73 | Safety flags map to backend. | `app.js`, `settings.lua`, `main.lua` | settings bridge | `v062_safety_flag_mapping` | Pending implementation |
| R74 | Diagnostics are available. | `diagnostics.lua`, UI | export/details | `v062_diagnostics_available` | Pending implementation |
| R75 | No dead vertical space. | `app.css`, `app.html` | layout | `v062_no_dead_vertical_space` | Pending implementation / Interactive Pending |
| R76 | Status follows slider. | `app.html`, `app.css` | Chaos composition | `v062_status_follows_slider` | Pending implementation / Interactive Pending |
| R77 | Expanded height is dynamic. | `app.js`, `app.json` | resize | `v062_dynamic_height` | Pending implementation / Interactive Pending |
| R78 | Collapsed height is compact. | `app.js`, `app.css` | collapsed mode | `v062_collapsed_height` | Pending implementation / Interactive Pending |
| R79 | Slider fill at 0%. | `app.js`, `app.css` | `--chaos-percent` | `v062_slider_fill_0` | Pending implementation / Interactive Pending |
| R80 | Slider fill at 50%. | `app.js`, `app.css` | `--chaos-percent` | `v062_slider_fill_50` | Pending implementation / Interactive Pending |
| R81 | Slider fill at 100%. | `app.js`, `app.css` | `--chaos-percent` | `v062_slider_fill_100` | Pending implementation / Interactive Pending |
| R82 | Thumb endpoint at 0%. | `app.css` | range geometry | `v062_thumb_endpoint_0` | Pending implementation / Interactive Pending |
| R83 | Thumb endpoint at 100%. | `app.css` | range geometry | `v062_thumb_endpoint_100` | Pending implementation / Interactive Pending |
| R84 | Responsive at 300/340/400 px. | `app.css` | media/layout | `v062_responsive_widths` | Pending implementation / Interactive Pending |
| R85 | UI scales at 125/150/200%. | `app.css` | scaling | `v062_ui_scaling` | Pending implementation / Interactive Pending |
| R86 | Fox SVG is valid. | `fox-mark.svg` | local asset | `v062_fox_svg_valid` | Pending implementation / Interactive Pending |
| R87 | Fox is visible. | `fox-mark.svg`, `app.css` | header brand | `v062_fox_visible` | Pending implementation / Interactive Pending |
| R88 | Fox does not overlap title. | `app.css`, `app.html` | header layout | `v062_fox_no_overlap` | Pending implementation / Interactive Pending |
| R89 | Exactly four top tabs. | `app.html`, `app.js` | navigation | `v062_four_top_tabs` | Pending implementation / Interactive Pending |
| R90 | No horizontal overflow. | `app.css` | responsive layout | `v062_no_horizontal_overflow` | Pending implementation / Interactive Pending |
| R91 | Temporary nil parts degrades/retries safely. | `main.lua`, `apiAdapter.lua` | bounded read | `v062_temporary_parts_nil` | Pending implementation |
| R92 | Persistent nil parts terminates. | `main.lua`, `apiAdapter.lua` | bounded read | `v062_persistent_parts_nil` | Pending implementation |
| R93 | Missing callback terminates. | `vehicleTargetTracker.lua`, `main.lua` | wall deadline | `v062_missing_callback` | Pending implementation |
| R94 | External error cannot steal target. | `vehicleTargetTracker.lua`, `main.lua` | ownership guard | `v062_external_error_target_guard` | Pending implementation |
| R95 | Degraded capability disables action. | `capabilityModel.lua`, UI | capability gate | `v062_degraded_capability_disables_action` | Pending implementation |

## Cross-cutting, documentation, compatibility, and delivery requirements

| ID | Requirement | Responsible file/action | Function/module | Test/evidence | Status |
|---|---|---|---|---|---|
| X01 | Record all required lifecycle instrumentation and reason codes without personal paths. | `main.lua`, `diagnostics.lua` | public/export diagnostics | diagnostics Lua/static tests | Pending implementation |
| X02 | Separate wall, simulation, raw, and frame clocks; pause changes no generation/target. | `timeSource.lua`, `main.lua` | clock architecture | R12-R15 | Pending implementation |
| X03 | Separate target identity, mutable tree, write pending, readback, and terminal phases. | `vehicleTargetTracker.lua`, `main.lua` | lifecycle phases | R05-R06, R38-R45 | Pending implementation |
| X04 | Implement six bounded recovery tiers and a state-cycle detector. | `vehicleRecovery.lua`, `recoveryCycleDetector.lua`, `main.lua` | recovery | R19-R30 | Pending implementation |
| X05 | Audit every public Chaos, Garage, Race, Placement, Drive, Settings action and adapter/capability. | `FEATURE_AUDIT_0.6.2.md` | feature audit | documentation/static audit | Pending |
| X06 | Create an exact enumerated v0.6.2 interactive plan and separate honest report. | `INTERACTIVE_TEST_PLAN_0.6.2.md`, `INTERACTIVE_TEST_REPORT_0.6.2.md` | live evidence | document totals test | Pending |
| X07 | Preserve schema 1, generator 6, SCR6, v0.6.0/v0.6.1 data and legacy lineup/race reads. | schemas, loaders, migrations | compatibility | full suite/package validation | Pending verification |
| X08 | Update and audit all named documentation; obsolete Lineup/Roster terms remain historical only. | README, CHANGELOG, ROADMAP, named `docs/` files | documentation | static/link/package tests | Pending |
| X09 | Produce 10-20 real logical commits directly on local `main`; no PR/public branch/force push. | Git history | delivery | final log audit | In progress |
| X10 | Package exact v0.6.2 ZIP, checksum, and manifest from the final commit. | `tools/package_mod.py`, `dist/` | packaging | package suite/manifest audit | Pending |
| X11 | Push final `main`, wait for green CI, then create annotated `v0.6.2`. | Git/GitHub Actions | release gate | remote SHA/check runs/tag object | Pending |
| X12 | Publish exact prerelease with three assets, redownload, hash, layout, manifest, and byte-compare validation. | GitHub Release | release audit | downloaded asset report | Pending |
| X13 | Preserve v0.6.1 and all earlier tag objects, releases, and asset bytes. | Git/GitHub | historical integrity | before/after audit | Baseline verified; final audit Pending |

## Interactive status rule

The eight supplied v0.6.1 gameplay regressions are historical `Failed` evidence in `INTERACTIVE_TEST_REPORT_0.6.1.md`. v0.6.2 rows can become Passed or Failed only from actual live execution against the exact final artifact. Until then they remain `Pending`; automated fixtures cannot promote them.
