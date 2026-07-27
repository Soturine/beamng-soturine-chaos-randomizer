# Soturine's Chaos Randomizer 0.6.3

Status: **Experimental prerelease — live validation pending owner test**.

## Status

Automated validation: Passed

Live BeamNG validation: Pending owner validation

Live cases: 0 executed / 0 passed / 0 failed / 110 pending / 0 blocked

This prerelease deliberately publishes the exact experimental build needed for
the repository owner to perform real BeamNG validation. Automated evidence is
not gameplay evidence, and no targeted regression is claimed definitively fixed
in gameplay before that owner test.

## Main implementation

- Separates one logical operation target from concrete BeamNG vehicle IDs.
- Treats replacement-return IDs and spawn/switch callbacks as candidate evidence.
- Promotes or rebinds an ID only after coherent player-0, model, configuration,
  generation, timing, stability, and destruction checks.
- Performs a final free player read before recovery so a correct visible target
  is not discarded merely because its concrete ID changed.
- Uses real monotonic time for deadlines, watchdogs, retry scheduling,
  cancellation, housekeeping, and Busy release; it never toggles pause.
- Rejects stale generations and bounds repeated recovery signatures.
- Prevents terminal phases from resuming Busy.

## Bugs targeted

Each item below is **implemented and automated; live owner validation pending**:

- Random Car and Full Random stopping at 22%;
- Scramble stopping at 57%;
- progress depending on pause/unpause or menu interaction;
- recovery restoring the previous vehicle after the intended target appeared;
- repeated recovery/old-vehicle loops and permanent Busy;
- combustion configurations ending with empty fuel;
- missing orange Chaos-slider fill;
- regressed fox artwork;
- unnecessary Chaos-tab scrolling or incorrect dynamic height.

## Dynamic randomization

Vehicles and configurations come from the mounted BeamNG registry. Compatible
part slots and mod parts come from the current hierarchical tree and are
rescanned through bounded convergence. Public tuning variables are discovered
at runtime, normalized, applied, read back, and rescanned until a fixed point,
cycle, or protection limit. Chaos 100 selects every eligible unlocked item that
can be processed honestly. Fuel classification combines storage and variable
metadata so only combustion fuel receives the verified 10% capacity floor.

## Installation

1. Remove or disable every older/duplicate Chaos Randomizer ZIP.
2. Download `soturine_chaos_randomizer_0.6.3.zip` from this release's Assets.
3. Put the ZIP, without extracting it, in the active BeamNG user folder's
   `mods` directory. For the target build this is normally
   `%LOCALAPPDATA%\BeamNG.drive\0.38\mods`; use **BeamNG Launcher → Manage User
   Folder → Open in Explorer** if the active folder differs.
4. Enable the mod, enter Freeroam, open UI Apps, and add **Soturine's Chaos
   Randomizer**.

Do not install GitHub's automatic “Source code” archives.

## Owner test request

1. Install the release ZIP above in a clean profile.
2. Load Small Grid and leave the game running.
3. Do not pause or toggle pause as a workaround.
4. Execute Random Car, Scramble, and Full Random.
5. Watch the 22% and 57% phases and confirm Busy always terminates.
6. Use **Copy diagnostics** for any unexpected result.
7. Preserve the relevant `beamng.log` and exact seed/content details.
8. Continue with the [110-case live plan](../testing/v0.6.3/LIVE_TEST_PLAN.md).

## Known limitations

Real BeamNG timing, physics, rendering, UI scaling, performance, and third-party
mod compatibility remain Pending owner validation. Third-party support is best
effort; incomplete or malformed metadata may produce an explicit partial,
unsupported, or failed-safe result.

## Assets and integrity

- ZIP: `soturine_chaos_randomizer_0.6.3.zip`
- ZIP bytes: `241492`
- ZIP SHA-256: `486a66da60bfac75d08f1a9584568142846074c110996962e99af2e610d4e9c7`
- Checksum: `soturine_chaos_randomizer_0.6.3.sha256`
- Manifest: `release-manifest.json`, manifest version 3
- Target commit: the annotated `v0.6.3` target recorded by the manifest

Vehicle DNA schema 1, generator 6, `SCR6` seeds, earlier saved data, and legacy
Lineup storage/API entry points remain supported.
