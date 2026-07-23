# Troubleshooting

## The app does not appear in UI Apps

1. Confirm the mod is enabled in Mod Manager.
2. Open the ZIP and verify `lua/`, `ui/`, and `settings/` are at the root.
3. Ensure the UI manifest is exactly `ui/modules/apps/soturineChaosRandomizer/app.json`.
4. Do not install GitHub's source archive or a ZIP containing an enclosing project folder.
5. Reload the UI, clear cache through the BeamNG launcher if appropriate, and restart the game.
6. Search `beamng.log` for `invalid app data`, `soturineChaosRandomizer`, or JavaScript errors.

Use `python tools/validate_package.py` on a locally built archive before installing it.

## Buttons remain disabled

- Wait for the extension state to load; the app requests it twice during startup.
- Spawn or enter a player vehicle.
- If only some buttons remain disabled, the adapter did not find a required 0.38 API. Confirm the exact game version against [Compatibility](COMPATIBILITY.md).
- Check `beamng.log` for an extension load error.

The UI intentionally disables every action while another operation is busy.

## “No vehicles match the current content filters”

- Switch **Content** to **Everything**.
- Enable Automation, trailers, or props if that is the content you expect.
- Press **Reindex Content** after enabling/disabling mods.
- Confirm the vehicle has at least one configuration in BeamNG's normal selector.
- A repeatedly failing configuration can be session-blacklisted after three failures; reindexing clears that list.

## Random Config or Full Random times out

Large/complex vehicles can take longer, but every wait is deliberately bounded. After a timeout:

1. Let BeamNG finish any outstanding load.
2. Check whether automatic rollback restored the previous vehicle.
3. Enable diagnostic logging and reproduce once.
4. Reindex content.
5. Test the selected configuration directly in BeamNG's vehicle selector.
6. Disable conflicting mods and retry in a clean profile.

Do not repeatedly press actions during a stalled vehicle load.

## Scramble changes little or nothing

- Increase Chaos.
- Confirm the vehicle exposes alternative compatible parts.
- Enable **Allow Missing Parts** if optional removals are desired.
- Disable **Keep Vehicle Drivable** only if you accept non-running or incomplete results.
- A vehicle with few slots or one candidate per slot can legitimately produce no part changes.

## The result does not drive

Chaos intentionally permits mechanically poor combinations. Enable **Keep Vehicle Drivable** for conservative protection, but understand that it is metadata-based and cannot guarantee compatibility for every custom drivetrain.

Use **Undo** immediately to restore the most recent pre-operation snapshot. If Undo is unavailable after a restart, load a saved configuration through BeamNG's normal vehicle tools; history is session-only.

## The same seed gives a different result

Verify all of these are unchanged:

- BeamNG version/build;
- enabled mods and their versions/load metadata;
- randomizer version;
- all Advanced settings;
- starting model/configuration for Scramble;
- content index and blacklist state.

The seed governs random choices, not external scripts, physics timing, or changes in installed content.

## Settings do not persist

The extension reads packaged defaults from:

```text
/settings/soturineChaosRandomizer/defaults.json
```

It writes validated user settings through BeamNG's VFS to:

```text
/settings/soturineChaosRandomizer/settings.json
```

Check user-folder permissions and JSON/log errors. To reset, close BeamNG and remove only that user settings file from the active versioned user folder; do not delete the packaged defaults.

## Diagnostics

Enable **Advanced → Diagnostic logging**, reproduce one bounded operation, then inspect `beamng.log` for the tag:

```text
SoturineChaosRandomizer
```

Normal logging records lifecycle, index counts, and final summaries. Diagnostic mode adds per-pass counts without dumping full JBeam/configuration data or local paths.

## After a BeamNG update

If the app loads but actions report `unsupported_api`, stop using destructive actions and open a compatibility issue. The internal adapter must be compared against the new installed source before support is claimed.

## Useful issue report

Provide the details listed in [Compatibility](COMPATIBILITY.md), the smallest reproducible mod set, and relevant log excerpts. Do not upload paid/private mod files or personal paths. Security-sensitive reports should follow [Security](../SECURITY.md).
