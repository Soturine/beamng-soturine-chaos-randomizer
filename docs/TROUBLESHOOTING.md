# Troubleshooting

## The app does not appear

1. Install the versioned mod ZIP, not a GitHub source archive.
2. Confirm `lua/`, `ui/`, and `settings/` are at the ZIP root.
3. Enable the mod, reload UI, and add **Soturine's Chaos Randomizer** from UI Apps.
4. Check `beamng.log` for `SoturineChaosRandomizer`, invalid app data, or JavaScript errors.
5. Validate a local build with `python tools/validate_package.py`.

## One or more actions are disabled

Open Advanced and read **Capability notes**.

- Random Car needs registry, spawn/replace, and lifecycle confirmation. Its internal operation remains `randomConfig`.
- Scramble needs hierarchical parts read/write and lifecycle confirmation.
- Full Random needs both sets.
- Missing tuning or paint APIs do not disable parts; those optional stages are skipped with a warning.

After a BeamNG update, an internal API may have changed. Do not continue destructive testing until `apiAdapter.lua` is re-audited.

## No content matches the filter

- `Everything` includes official, mod, user, and unknown sources.
- `Official only` and `Mods only` intentionally exclude unknown metadata.
- Exact Automation, trailer, and prop types are opt-in.
- Press **Reindex Content** after content changes.
- Advanced shows the unknown-source count and separate blacklist counts.

An arbitrary source title is no longer guessed to be a mod. A pack needs `modID`/`modId` or the exact current mod marker to appear in Mods-only.

## A write was rejected immediately

Phase-specific codes include:

- `vehicle_replace_rejected`;
- `parts_apply_rejected`;
- `tuning_apply_rejected`;
- `paint_apply_rejected`.

These mean the synchronous call returned an explicit rejection or threw. A missing/changed intermediate ID alone is not rejection; the tracker can bind a later stable player target. The randomizer does not wait 25 seconds after a known rejection. Diagnostic context retains the thrown detail when available.

## A reload event arrived but the operation failed

`post_event_state_unconfirmed` means `onVehicleSpawned` arrived but the current model/config/parts/tuning did not match the active phase's request. A spawn hook alone is not success. The operation rolls back when a destructive write had begun.

Check the `lifecycle_event_received` record for expected event, phase, verification reason, and elapsed time.

`config_identity_unverified` is narrower: the model loaded, but the selected configuration could not be proved by normalized path, model-scoped registry key, or its minimal part/tuning signature. Model identity alone is deliberately insufficient.

## Vehicle replacement could not be correlated

Replacement callbacks nominate candidates; they do not force success or cancellation. The tracker accepts a returned ID, callback IDs, and player-0 observations, rejects auxiliary/wrong candidates, and waits for five stable frames plus two coherent scans. `vehicle_stabilization_timeout` means the final model/configuration/parts never became coherent in time. A real unrelated player switch still cancels safely.

Wait for BeamNG to settle, inspect `vehicle_target_candidate`, `vehicle_target_rebound`, `vehicle_target_stable`, and lifecycle diagnostics, and retry with no simultaneous vehicle-manager action. Undo is intentionally refused outside the vehicle context that created its history entry.

## Paint remains on Confirming read-back

The installed 0.38 source applies `setConfigPaints(..., false)` without a vehicle respawn. The extension therefore performs a short, bounded, tolerant cache read-back on `onUpdate`; it does not wait for `onVehicleSpawned`.

`paint_apply_unconfirmed` means the requested fields did not appear before that bounded window expired. Extra fields and layers do not cause failure, and only requested supported fields are compared. A failed confirmation triggers rollback when a destructive write began.

## An operation timed out

The code identifies the exact wait: vehicle replace, parts reload, tuning reload, rollback, or Undo. After a timeout:

1. let the game finish any outstanding load;
2. inspect whether rollback completed;
3. enable diagnostics and reproduce once;
4. test the selected configuration/part directly in normal BeamNG tools;
5. Reindex;
6. retry in a clean profile with the smallest mod set.

Do not rapidly start more operations while the game is still loading.

## A part candidate is blacklisted

Advanced shows the last blocked ID, reason, failure count, and seed. Part IDs include model, slot path, and candidate; they do not share the configuration namespace.

A multi-candidate batch is initially recorded only as suspect because the extension cannot prove which member caused the failure. Repeated independent failure fingerprints can temporarily suppress the candidate and later promote it; a confirmed successful application reduces or clears its suspicion. Suspect storage, fingerprints, and age are bounded. Reindex clears all session model/config/part/tuning failures, suspects, and blacklists.

## Scramble changes little or nothing

- Increase Chaos.
- Confirm the current slots expose alternatives.
- Protected critical concepts retain current/default parts.
- Blacklisted candidates are filtered.
- A parent change defers descendants until the next pass.
- Optional tuning/paint stages may be unavailable; read Capability notes.

A safe zero-change result is valid and does not create an Undo entry unless another stage actually writes.

## A part failed after reload

One transient incomplete tree is rescanned. When the same structural absence persists across coherent scans, alpha.2 restores the pre-batch snapshot, verifies that rollback, quarantines the model/configuration/slot/candidate combination, and tries a bounded alternative. Look for `part_batch_rollback`, `part_candidate_quarantined`, and retry-budget diagnostics.

If localized rollback itself fails or the bounded budget is exhausted, the full operation rolls back. Reindex clears session quarantine; do not repeatedly select a known broken part while BeamNG is still reloading.

## A broken configuration left no active vehicle

The recovery ladder tries the operation's previous snapshot, then the session last-known-good configuration, then a safe official configuration. Three consecutive load failures open an official-only circuit breaker. Locks do not block recovery; incompatible model-bound locks become visibly unresolved afterward.

Random Car and Full Random can start without an active player vehicle. Scramble cannot infer a model in that state, so use **Spawn safe vehicle** or Random Car. Even if every automatic recovery step fails, the busy flag, operation token, timers, and tracker should be cleared. Use **Copy diagnostics**, retry the quarantine when appropriate, and report any permanently disabled UI as a regression.

## Thumbnail capture reports a state mismatch or invalid PNG

Default capture requires the selected DNA's exact model, normalized configuration, slots, tuning, and paints both before and after the screenshot. Restore the entry first, or choose the explicit non-exact override; that result is marked non-exact in metadata.

Imported/captured PNGs must pass signature, chunk order/length, CRC, IHDR/IDAT/IEND, trailing-payload, and chunk-count validation. A same-size file or valid header alone is insufficient.

## The result does not drive

**Protect Critical Parts is not a drivability guarantee.** It prevents detectable required/core absence and blocks unproven critical substitutions, but it cannot understand every mechanical relationship or third-party script.

The result safety status can be `validated`, `uncertain`, or `not_applicable`. Evidence profiles cover standard road, electric, hybrid-like, Automation, trailer, prop, special, and unknown shapes without assuming fuel, a gearbox, four wheels, steering, or exactly one differential. `uncertain` is an honest lack of sufficient metadata, not a successful physics validation.

Use Undo immediately. If history is unavailable after restart, use BeamNG's normal saved/default configuration tools; history is session-only.

## Undo is unavailable after an early failure

This is intentional when failure happened before the first destructive write. The original snapshot is not committed to history until immediately before that write. A failed scan/selection therefore creates no no-op Undo entry.

If a write began, the entry is retained unless automatic rollback succeeds. Successful rollback removes the redundant entry; failed rollback preserves evidence.

## Immediate click used the wrong setting

Version `0.5.0-alpha.2` sends the displayed action and complete settings snapshot in one Lua call. If the result reports a different manual seed/filter/Chaos value, collect the UI state and JavaScript log because that is a regression. Settings/search timers are cancelled on action or app destroy.

For `.vdna.zip`, place exactly one package at `/settings/soturineChaosRandomizer/vehicleDNA/inbox/import.vdna.zip`. General-purpose compressed ZIPs are intentionally unsupported; export a package from this mod. A validation error should identify archive, directory, entry, checksum, manifest, schema, or thumbnail bounds before confirmation becomes available.

If a managed Gallery image is missing or rejected, the card should fall back without affecting Vehicle DNA. Load the DNA's model before capture, keep the current vehicle visible, and check capability notes plus `beamng.log`. Capture remains interactive Pending for this alpha.

## Developer stress stopped

Expected stop reasons include manual cancellation, iteration limit, duration limit, stop-on-failure, map change, vehicle change, and mod-state change. Stress never overlaps a normal action. Inspect `getDeveloperStressState()` and tagged logs for aggregate counts/failure seeds.

The diagnostic is developer-only; do not expose it as an unattended gameplay loop.

## Settings do not persist

Packaged defaults are read from:

```text
/settings/soturineChaosRandomizer/defaults.json
```

Validated user settings are written through BeamNG VFS to:

```text
/settings/soturineChaosRandomizer/settings.json
```

If persistence is unavailable, Advanced shows a capability warning. The settings snapshot can still apply for the current action/session.

## Save Vehicle DNA is unavailable

The button appears only after a successful operation also completes a fresh final capture, fresh hierarchical scan, normalization, schema validation, and fingerprints. It stays unavailable after an operation failure or DNA capture failure. Check the tagged `dna_capture_failed` diagnostic; the gameplay result can still be valid even when it could not be serialized.

Saving is explicit and `autoSaveDNA` is fixed off. A persistence failure leaves the pending entry available for retry and does not silently report success.

## Preflight says target inspection is required

Registry preflight never changes the vehicle. Installed 0.38.6 APIs do not expose a proven hierarchical slot tree for an arbitrary unloaded target, so a different active model produces `target_inspection_required`. Starting Restore Exact or Restore Compatible captures the current vehicle, loads the saved normalized/model-scoped base, and runs the target-tree preflight. Any Exact mismatch—or an unauthorized Compatible partial—rolls back to the captured vehicle.

## Restore stops on pass budget or no progress

The parent-first planner derives its budget from saved/current tree depth, then enforces a 12-pass minimum, 128-pass maximum, 120-second deadline, and repeated/no-progress guards. Codes such as `dna_restore_timeout`, `dna_restore_no_progress`, `dna_restore_repeated_state`, or `dna_restore_pass_limit` mean the transaction stopped safely and attempted rollback; collect the compatibility report and diagnostic log rather than retrying indefinitely.

## Storage reports recovered

`dna_storage_recovered` means a backup/primary write or primary read-back failed and the validated last-known-good document was restored immediately. Preserve the diagnostics and inspect filesystem/antivirus conditions. `dna_storage_recovery_failed` means the restoration attempt also failed; the in-memory library is not silently presented as durable.

Load the matching base/model through normal BeamNG controls, wait for it to settle, then rerun preflight. Do not interpret a matching fingerprint alone as exact compatibility.

## Compatible restore reports partial

Open every preflight section before confirmation. Partial means at least one slot/part/tuning variable/paint layer/dependency is missing or a value will be clamped/omitted. The operation never chooses a random fallback. Required/core parts and ambiguous slot mappings block unsafe application.

The final result lists deviations. If an applied subset fails read-back or safety validation, the entire transaction rolls back.

## The Vehicle DNA library is corrupt

Primary storage is `/settings/soturineChaosRandomizer/vehicleDNA/library.json`; the only recovery copy is `library.last-known-good.json`. Startup schema/fingerprint-validates the primary and then the backup. A recovered library shows `last_known_good_recovered` in Garage state. If both are invalid, normal randomization still loads with an empty/unavailable Garage rather than executing or rewriting unknown data.

Preserve both files before troubleshooting. Never paste private mod content into an issue. In-game restart recovery remains an interactive Pending case for this alpha.

## Import or export was rejected

Pasted import accepts one JSON object up to 131,072 characters and then applies stricter canonical/schema/fingerprint limits. Common codes identify future schema, invalid format, duplicate slot/tuning keys, non-finite values, excessive depth/size, or a fingerprint mismatch. Unknown top-level fields are discarded except bounded `extensions` data.

Copy JSON is independent of file export. Optional file export always writes the adapter-controlled `/settings/soturineChaosRandomizer/vehicleDNA/export.json`; DNA names and IDs never become paths.

## Operation waits while the game is paused

A phase that genuinely needs Vehicle Lua or physics progression shows **Waiting
for the simulation to resume so the vehicle can finish loading**. This is not a
timeout and the mod never changes pause state itself. Cancel, Copy diagnostics,
and operation details must remain available. If progress occurs only after
pausing rather than after resuming, copy diagnostics and report
`pause_dependent_progress_detected`; do not use pause toggling as a workaround
to certify the result.

## Operation appears stalled or remains Busy

Open operation details and record phase, operation/phase/target generations,
target/tree status, clocks, pending counts, and stale callback count. A warning
does not trigger early rollback while the phase is legitimately waiting for
simulation. Use Copy diagnostics, then Cancel and roll back. If Cancel or Copy
is unavailable, treat that as a 0.6.0 lifecycle regression.

## A recovered or previous vehicle changed unexpectedly

Stop further randomization and capture diagnostics. The recovery state must be
`recoveryOnly`; the old mutation plan/current batch/tuning/paint/timers must be
absent. Look for `stale_callback_ignored` and
`recovery_target_received_stale_mutation`. The original snapshot is not
automatically completed-good, and a readable recovery snapshot must not resume
the failed Scramble.

## A Lineup competitor remains Partial

Inspect coverage, lifecycle acceptance, pending counts, DNA, metadata
uncertainty, and potentially-undrivable status. Ready requires final validation,
Busy false, DNA present, and zero pending writes/timers/callbacks. Partial,
metadata-uncertain, and potentially-undrivable acceptance are separate creation
choices. Storage checkpoint failure stops generation; restore storage access
and use Retry slot.

## Spawn preview or managed target failed

`ground_not_found`, `slope_too_high`, `position_blocked`, and
`outside_supported_area` are safety rejections. Player, road, or destination
headings fail explicitly when their evidence is missing; they do not fall back
to camera. An unverified target is failed/DNS, never Ready. For an ID-changing
mod, record the returned ID, callback candidates, final ID, target generation,
and read-back reason.

## AI mode is unavailable or no route exists

Destination/Route require the current map's NavGraph APIs and a reachable path.
NavGraph is not the visual GPS line. Move the destination or add route points
when `navgraph_route_unreachable` is reported. Chase/Follow need a distinct real
vehicle target. Recorded/Scripted playback is intentionally unavailable in the
audited build contract. Include the capability reason in reports.

## Useful issue report

Provide BeamNG full build, randomizer version/commit, content name/version/source/license, operation, visible settings, displayed seed, smallest mod set, relevant tagged logs, and whether Reindex/clean profile changes the result. Do not upload paid/private content or personal paths. Follow [Security](../SECURITY.md) for sensitive reports.
