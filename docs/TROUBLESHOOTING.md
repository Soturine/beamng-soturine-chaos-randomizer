# Troubleshooting

## The app does not appear

1. Install the versioned mod ZIP, not a GitHub source archive.
2. Confirm `lua/`, `ui/`, and `settings/` are at the ZIP root.
3. Enable the mod, reload UI, and add **Soturine's Chaos Randomizer** from UI Apps.
4. Check `beamng.log` for `SoturineChaosRandomizer`, invalid app data, or JavaScript errors.
5. Validate a local build with `python tools/validate_package.py`.

## One or more actions are disabled

Open Advanced and read **Capability notes**.

- Random Config needs registry, replace, and lifecycle confirmation.
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

These mean the synchronous call returned an explicit rejection, no required vehicle object, or threw. The randomizer does not wait 25 seconds after a known rejection. Diagnostic context retains the thrown detail when available.

## A reload event arrived but the operation failed

`post_event_state_unconfirmed` means `onVehicleSpawned` arrived but the current model/config/parts/tuning did not match the active phase's request. A spawn hook alone is not success. The operation rolls back when a destructive write had begun.

Check the `lifecycle_event_received` record for expected event, phase, verification reason, and elapsed time.

`config_identity_unverified` is narrower: the model loaded, but the selected configuration could not be proved by normalized path, model-scoped registry key, or its minimal part/tuning signature. Model identity alone is deliberately insufficient.

## Vehicle replacement could not be correlated

`vehicle_replace_target_ambiguous` means `replaceVehicle` did not return a usable vehicle object/ID. `vehicle_replace_event_ambiguous`, `vehicle_switched`, or a restore target mismatch means switch events did not identify the exact returned replacement target. The extension never retargets an active operation to an unrelated manual switch.

Wait for BeamNG to settle, inspect `replacement_target_bound` and `replacement_switch_*` diagnostics, and retry with no simultaneous vehicle-manager action. Undo is intentionally refused outside the vehicle context that created its history entry.

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

## The result does not drive

**Protect Critical Parts is not a drivability guarantee.** It prevents detectable required/core absence and blocks unproven critical substitutions, but it cannot understand every mechanical relationship or third-party script.

The result safety status can be `validated`, `uncertain`, or `not_applicable`. Evidence profiles cover standard road, electric, hybrid-like, Automation, trailer, prop, special, and unknown shapes without assuming fuel, a gearbox, four wheels, steering, or exactly one differential. `uncertain` is an honest lack of sufficient metadata, not a successful physics validation.

Use Undo immediately. If history is unavailable after restart, use BeamNG's normal saved/default configuration tools; history is session-only.

## Undo is unavailable after an early failure

This is intentional when failure happened before the first destructive write. The original snapshot is not committed to history until immediately before that write. A failed scan/selection therefore creates no no-op Undo entry.

If a write began, the entry is retained unless automatic rollback succeeds. Successful rollback removes the redundant entry; failed rollback preserves evidence.

## Immediate click used the wrong setting

Version `0.3.0-alpha.1` sends the displayed action and complete settings snapshot in one Lua call. If the result reports a different manual seed/filter/Chaos value, collect the UI state and JavaScript log because that is a regression. The pending settings timer is cancelled on action and app destroy.

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

## Useful issue report

Provide BeamNG full build, randomizer version/commit, content name/version/source/license, operation, visible settings, displayed seed, smallest mod set, relevant tagged logs, and whether Reindex/clean profile changes the result. Do not upload paid/private content or personal paths. Follow [Security](../SECURITY.md) for sensitive reports.
