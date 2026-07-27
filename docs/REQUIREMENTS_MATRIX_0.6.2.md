# Requirements Matrix 0.6.2

This matrix traces the v0.6.2 master prompt to implementation and evidence. `Automated verified` means the named fixture/static contract passes; it is not a gameplay-success claim. `Interactive Pending` means the required final-ZIP BeamNG run has not occurred.

## Mandatory automated requirements

| ID | Requirement | Responsible file | Function/module | Test | Status |
|---|---|---|---|---|---|
| R01 | Random Car without pause. | `main.lua` | Random Car lifecycle | `v062_random_car_without_pause` | Automated verified |
| R02 | Scramble without pause. | `main.lua` | Scramble lifecycle | `v062_scramble_without_pause` | Automated verified |
| R03 | Full Random without pause. | `main.lua` | Full Random lifecycle | `v062_full_random_without_pause` | Automated verified |
| R04 | Race generation without pause. | `main.lua` | Race generation | `v062_race_generation_without_pause` | Automated verified |
| R05 | Confirm identity before tree convergence. | `vehicleTargetTracker.lua` | ownership milestone | `v062_identity_precedes_tree` | Automated verified |
| R06 | Tree change does not lose target. | `vehicleTargetTracker.lua` | identity/tree split | `v062_tree_change_preserves_target` | Automated verified |
| R07 | Reject stale callback. | `operationState.lua`, `main.lua` | generation guards | `v062_stale_callback_rejected` | Automated verified |
| R08 | Reject stale timer. | `operationState.lua`, `main.lua` | timer guards | `v062_stale_timer_rejected` | Automated verified |
| R09 | Cancel during target tracking. | `main.lua` | cancel lifecycle | `v062_cancel_target_tracking` | Automated verified |
| R10 | Cancel during parts reload. | `main.lua` | cancel lifecycle | `v062_cancel_parts_reload` | Automated verified |
| R11 | Busy releases at every terminal. | `operationState.lua`, `main.lua` | terminal cleanup | `v062_busy_all_terminals` | Automated verified |
| R12 | Wall deadline works with zero `dtSim`. | `timeSource.lua`, `operationState.lua` | monotonic deadline | `v062_wall_deadline_zero_dtsim` | Automated verified |
| R13 | Pause toggle does not change generation. | `operationState.lua`, `main.lua` | lifecycle generations | `v062_pause_preserves_generation` | Automated verified |
| R14 | Pause toggle does not change target. | `vehicleTargetTracker.lua`, `main.lua` | ownership | `v062_pause_preserves_target` | Automated verified |
| R15 | Pause toggle is not required for progress. | `main.lua` | update pipeline | `v062_progress_without_pause_toggle` | Automated verified |
| R16 | Housekeeping is never blocked by phase work. | `main.lua` | `onUpdate` | `v062_housekeeping_always_runs` | Automated verified |
| R17 | Map unload clears runtime. | `main.lua` | unload hook | `v062_map_unload_terminal_cleanup` | Automated verified |
| R18 | Extension unload clears runtime. | `main.lua` | unload hook | `v062_extension_unload_terminal_cleanup` | Automated verified |
| R19 | Clean spawn does not promote recovery snapshot. | `main.lua`, `vehicleRecovery.lua` | snapshot roles | `v062_clean_spawn_not_promoted` | Automated verified |
| R20 | Rejected partial does not promote snapshot. | `main.lua`, `vehicleRecovery.lua` | promotion gate | `v062_partial_not_promoted` | Automated verified |
| R21 | Completed operation promotes snapshot. | `main.lua`, `vehicleRecovery.lua` | promotion gate | `v062_completed_promotes_snapshot` | Automated verified |
| R22 | Recovery invalidates all plans. | `vehicleRecovery.lua` | recovery isolation | `v062_recovery_invalidates_plans` | Automated verified |
| R23 | Recovery cannot execute old tuning. | `vehicleRecovery.lua`, `main.lua` | stale-plan guard | `v062_recovery_rejects_old_tuning` | Automated verified |
| R24 | Recovery cannot execute old paint. | `vehicleRecovery.lua`, `main.lua` | stale-plan guard | `v062_recovery_rejects_old_paint` | Automated verified |
| R25 | Recovery restores the explicitly selected snapshot. | `vehicleRecovery.lua`, `main.lua` | tiered recovery | `v062_recovery_explicit_snapshot` | Automated verified |
| R26 | Detect recovery loop. | `vehicleRecovery.lua` | state fingerprint | `v062_recovery_loop_detected` | Automated verified |
| R27 | Recovery loop terminates operation. | `main.lua` | hard terminal | `v062_recovery_loop_terminal` | Automated verified |
| R28 | Failed candidate enters quarantine. | `vehicleRecovery.lua`, `partBatchRecovery.lua`, `main.lua` | candidate quarantine | `v062_failed_candidate_quarantine` | Automated verified |
| R29 | New operation does not reuse stale candidate. | `main.lua` | operation isolation | `v062_new_operation_candidate_isolation` | Automated verified |
| R30 | Failure cannot contaminate the next operation. | `main.lua`, `vehicleRecovery.lua` | cleanup | `v062_failure_next_operation_isolation` | Automated verified |
| R31 | New operation creates a new RNG. | `main.lua`, `rng.lua` | `operationSeed` | `v062_fresh_rng_per_operation` | Automated verified |
| R32 | Random seed changes. | `apiAdapter.lua`, `main.lua` | entropy seed | `v062_random_seed_changes` | Automated verified |
| R33 | Fixed seed reproduces. | `settings.lua`, `main.lua` | fixed seed | `v062_fixed_seed_reproduces` | Automated verified |
| R34 | Anti-repeat avoids immediate repeat. | `main.lua`, selectors | recent selection | `v062_anti_repeat` | Automated verified |
| R35 | Anti-repeat does not affect replay. | `main.lua` | replay exception | `v062_replay_anti_repeat_exception` | Automated verified |
| R36 | Recovery is not a new selection. | `main.lua` | result history | `v062_recovery_not_selection` | Automated verified |
| R37 | Retry has an isolated substream. | `rng.lua`, `lineupManager.lua` | substreams | `v062_retry_substream` | Automated verified |
| R38 | Scramble keeps its target. | `main.lua` | target-bound pipeline | `v062_scramble_target_isolation` | Automated verified |
| R39 | Full Random keeps the new target. | `main.lua` | target-bound pipeline | `v062_full_random_target_isolation` | Automated verified |
| R40 | Parent-first mutation rescans. | `main.lua`, `slotScanner.lua` | parts pipeline | `v062_parent_first_rescan` | Automated verified |
| R41 | Tuning is read after parts. | `main.lua` | ordered pipeline | `v062_tuning_after_parts` | Automated verified |
| R42 | Paint has bounded readback. | `paintVerification.lua`, `main.lua` | paint phase | `v062_paint_readback` | Automated verified |
| R43 | Completed requires closed ledgers. | `main.lua`, coverage ledgers | completion gate | `v062_completion_requires_closed_ledgers` | Automated verified |
| R44 | Partial is classified honestly. | `main.lua` | completion gate | `v062_partial_terminal` | Automated verified |
| R45 | Critical failure terminates. | `main.lua`, `validator.lua` | safety terminal | `v062_critical_failure_terminal` | Automated verified |
| R46 | Balanced preset applies real policy. | `lineupManager.lua` | Race presets | `v062_balanced_preset` | Automated verified |
| R47 | Maximum Chaos applies real policy. | `lineupManager.lua` | Race presets | `v062_maximum_chaos_preset` | Automated verified |
| R48 | Mods Showcase applies real policy. | `lineupManager.lua` | Race presets | `v062_mods_showcase_preset` | Automated verified |
| R49 | Edited preset becomes Custom. | `app.js` | Race settings | `v062_race_custom_preset` | Automated verified |
| R50 | Competitor leaves Pending. | `lineupManager.lua`, `main.lua` | Race state | `v062_competitor_leaves_pending` | Automated verified |
| R51 | Competitor timeout terminates. | `lineupManager.lua`, `main.lua` | deadline | `v062_competitor_timeout_terminal` | Automated verified |
| R52 | Race cancel terminates. | `lineupManager.lua`, `main.lua` | cancel | `v062_race_cancel_terminal` | Automated verified |
| R53 | Race failure does not contaminate next. | `lineupManager.lua`, `main.lua` | per-car isolation | `v062_race_failure_isolation` | Automated verified |
| R54 | Placement requires Ready car. | `app.js`, `spawnDirector.lua` | capability gate | `v062_placement_requires_ready` | Automated verified |
| R55 | Drive requires Spawned/Managed car. | `app.js`, `aiDirector.lua` | capability gate | `v062_drive_requires_managed` | Automated verified |
| R56 | Start and Stop AI work. | `main.lua`, `aiDirector.lua` | AI lifecycle | `v062_start_stop_ai` | Automated verified |
| R57 | Unavailable capability is explained. | `capabilities.lua`, UI | degradation | `v062_capability_explanation` | Automated verified |
| R58 | Managed vehicle ownership is enforced. | `managedVehicleRegistry.lua` | ownership | `v062_managed_vehicle_ownership` | Automated verified |
| R59 | Save Vehicle DNA. | `vehicleDNA*.lua`, `main.lua` | Garage save | `v062_save_dna` | Automated verified |
| R60 | Restore snapshot. | `vehicleDNARestore.lua`, `main.lua` | Garage restore | `v062_restore_snapshot` | Automated verified |
| R61 | Replay generation. | `vehicleDNA.lua`, `main.lua` | Garage replay | `v062_replay_generation` | Automated verified |
| R62 | Import compatibility. | `vehicleDNAImport.lua` | Garage import | `v062_import_compatibility` | Automated verified |
| R63 | Export works. | `vehicleDNAPackage.lua` | Garage export | `v062_export_dna` | Automated verified |
| R64 | Compare works. | `vehicleDNACompare.lua` | Garage compare | `v062_compare_dna` | Automated verified |
| R65 | Share works. | `vehicleDNAPackage.lua` | Garage share | `v062_share_dna` | Automated verified |
| R66 | Lineage is preserved. | `vehicleDNASchema.lua` | ancestry | `v062_dna_lineage` | Automated verified |
| R67 | Mutation is target-isolated. | `main.lua`, `vehicleDNAMutations.lua` | Garage mutation | `v062_mutation_target_isolation` | Automated verified |
| R68 | Reroll is target-isolated. | `main.lua`, `vehicleDNAMutations.lua` | Garage reroll | `v062_reroll_target_isolation` | Automated verified |
| R69 | All locks default unlocked. | `settings.lua`, `defaults.json` | defaults | `v062_locks_default_unlocked` | Automated verified |
| R70 | Remember locks defaults Off. | `settings.lua`, `defaults.json` | defaults | `v062_remember_locks_default_off` | Automated verified |
| R71 | Fixed seed warning is shown. | `app.html`, `app.js` | warning | `v062_fixed_seed_warning` | Automated verified |
| R72 | Clear seed restores random mode. | `app.js`, `settings.lua` | seed action | `v062_clear_seed` | Automated verified |
| R73 | Safety flags map to backend. | `app.js`, `settings.lua`, `main.lua` | settings bridge | `v062_safety_flag_mapping` | Automated verified |
| R74 | Diagnostics are available. | `diagnostics.lua`, UI | export/details | `v062_diagnostics_available` | Automated verified |
| R75 | No dead vertical space. | `app.css`, `app.html` | layout | `v062_no_dead_vertical_space` | Automated verified / Interactive Pending |
| R76 | Status follows slider. | `app.html`, `app.css` | Chaos composition | `v062_status_follows_slider` | Automated verified / Interactive Pending |
| R77 | Expanded height is dynamic. | `app.js`, `app.json` | resize | `v062_dynamic_height` | Automated verified / Interactive Pending |
| R78 | Collapsed height is compact. | `app.js`, `app.css` | collapsed mode | `v062_collapsed_height` | Automated verified / Interactive Pending |
| R79 | Slider fill at 0%. | `app.js`, `app.css` | `--chaos-percent` | `v062_slider_fill_0` | Automated verified / Interactive Pending |
| R80 | Slider fill at 50%. | `app.js`, `app.css` | `--chaos-percent` | `v062_slider_fill_50` | Automated verified / Interactive Pending |
| R81 | Slider fill at 100%. | `app.js`, `app.css` | `--chaos-percent` | `v062_slider_fill_100` | Automated verified / Interactive Pending |
| R82 | Thumb endpoint at 0%. | `app.css` | range geometry | `v062_thumb_endpoint_0` | Automated verified / Interactive Pending |
| R83 | Thumb endpoint at 100%. | `app.css` | range geometry | `v062_thumb_endpoint_100` | Automated verified / Interactive Pending |
| R84 | Responsive at 300/340/400 px. | `app.css` | media/layout | `v062_responsive_widths` | Automated verified / Interactive Pending |
| R85 | UI scales at 125/150/200%. | `app.css` | scaling | `v062_ui_scaling` | Automated verified / Interactive Pending |
| R86 | Fox SVG is valid. | `fox-mark.svg` | local asset | `v062_fox_svg_valid` | Automated verified / Interactive Pending |
| R87 | Fox is visible. | `fox-mark.svg`, `app.css` | header brand | `v062_fox_visible` | Automated verified / Interactive Pending |
| R88 | Fox does not overlap title. | `app.css`, `app.html` | header layout | `v062_fox_no_overlap` | Automated verified / Interactive Pending |
| R89 | Exactly four top tabs. | `app.html`, `app.js` | navigation | `v062_four_top_tabs` | Automated verified / Interactive Pending |
| R90 | No horizontal overflow. | `app.css` | responsive layout | `v062_no_horizontal_overflow` | Automated verified / Interactive Pending |
| R91 | Temporary nil parts degrades/retries safely. | `main.lua`, `apiAdapter.lua` | bounded read | `v062_temporary_parts_nil` | Automated verified |
| R92 | Persistent nil parts terminates. | `main.lua`, `apiAdapter.lua` | bounded read | `v062_persistent_parts_nil` | Automated verified |
| R93 | Missing callback terminates. | `vehicleTargetTracker.lua`, `main.lua` | wall deadline | `v062_missing_callback` | Automated verified |
| R94 | External error cannot steal target. | `vehicleTargetTracker.lua`, `main.lua` | ownership guard | `v062_external_error_target_guard` | Automated verified |
| R95 | Degraded capability disables action. | `capabilities.lua`, UI | capability gate | `v062_degraded_capability_disables_action` | Automated verified |

## Cross-cutting, documentation, compatibility, and delivery requirements

| ID | Requirement | Responsible file/action | Function/module | Test/evidence | Status |
|---|---|---|---|---|---|
| X01 | Record all required lifecycle instrumentation and reason codes without personal paths. | `main.lua`, `diagnostics.lua` | public/export diagnostics | diagnostics Lua/static tests | Automated verified |
| X02 | Separate wall, simulation, raw, and frame clocks; pause changes no generation/target. | `timeSource.lua`, `main.lua` | clock architecture | R12-R15 | Automated verified |
| X03 | Separate target identity, mutable tree, write pending, readback, and terminal phases. | `vehicleTargetTracker.lua`, `main.lua` | lifecycle phases | R05-R06, R38-R45 | Automated verified |
| X04 | Implement six bounded recovery tiers and a state-cycle detector. | `vehicleRecovery.lua`, `main.lua` | recovery | R19-R30 | Automated verified |
| X05 | Audit every public Chaos, Garage, Race, Placement, Drive, Settings action and adapter/capability. | `FEATURE_AUDIT_0.6.2.md` | feature audit | documentation/static audit | Automated verified; Interactive Pending |
| X06 | Create an exact enumerated v0.6.2 interactive plan and separate honest report. | `INTERACTIVE_TEST_PLAN_0.6.2.md`, `INTERACTIVE_TEST_REPORT_0.6.2.md` | live evidence | document totals test | 80 enumerated; Interactive Pending |
| X07 | Preserve schema 1, generator 6, SCR6, v0.6.0/v0.6.1 data and legacy lineup/race reads. | schemas, loaders, migrations | compatibility | full suite/package validation | Automated verified |
| X08 | Update and audit all named documentation; obsolete Lineup/Roster terms remain historical only. | README, CHANGELOG, ROADMAP, named `docs/` files | documentation | static/link/package tests | Pending |
| X09 | Produce 10-20 real logical commits directly on local `main`; no PR/public branch/force push. | Git history | delivery | final log audit | In progress |
| X10 | Package exact v0.6.2 ZIP, checksum, and manifest from the final commit. | `tools/package_mod.py`, `dist/` | packaging | package suite/manifest audit | Pending |
| X11 | Push final `main`, wait for green CI, then create annotated `v0.6.2`. | Git/GitHub Actions | release gate | remote SHA/check runs/tag object | Pending |
| X12 | Publish exact prerelease with three assets, redownload, hash, layout, manifest, and byte-compare validation. | GitHub Release | release audit | downloaded asset report | Pending |
| X13 | Preserve v0.6.1 and all earlier tag objects, releases, and asset bytes. | Git/GitHub | historical integrity | before/after audit | Baseline verified; final audit Pending |

## Interactive status rule

The eight supplied v0.6.1 gameplay regressions are historical `Failed` evidence in `INTERACTIVE_TEST_REPORT_0.6.1.md`. v0.6.2 rows can become Passed or Failed only from actual live execution against the exact final artifact. Until then they remain `Pending`; automated fixtures cannot promote them.
