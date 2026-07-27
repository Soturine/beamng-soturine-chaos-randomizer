# Research Notes 0.6.2

This document records the primary-source runtime contracts used for the v0.6.2 hotfix. It does not claim live gameplay validation.

## Local BeamNG 0.38.6 source audit

Source installation inspected: `D:/SteamLibrary/steamapps/common/BeamNG.drive`. The path is recorded only here as maintainer evidence and must not be emitted in package diagnostics or release assets.

| Contract | Primary source | Finding | Implementation consequence |
|---|---|---|---|
| Player switch callback | `lua/ge/main.lua`, `vehicleSwitched` | BeamNG invalidates its player cache, then dispatches `onVehicleSwitched(oldId, newId, player)`. | Track player 0 only; auxiliary switches cannot acquire target ownership. |
| Spawn callback order | `lua/ge/main.lua`, `vehicleSpawned`; `core/vehicle/manager.lua` | `onVehicleSpawned` is sent during GE construction before the automatic `be:enterVehicle` switch. | A spawn callback is a candidate nomination, not final player-target ownership. |
| Player vehicle data | `core/vehicle/manager.lua`, `getPlayerVehicleData` / `getVehicleData` | The player helper dereferences `vehicles[be:getPlayerVehicleID(0)]`; the ID-specific helper reads `vehicles[id]`. | Verification must read the expected ID-specific bundle and cross-check the player ID before and after the read. |
| Part configuration read | `core/vehicle/partmgmt.lua`, `getConfig` | The public helper reads the current player vehicle bundle globally. | A target-bound verification snapshot must not combine this global read with a different object/ID read in one observation. |
| Part/tuning reload | `core/vehicle/partmgmt.lua`, `setPartsTreeConfig`, `setConfigVars` | Both merge into the current player configuration and may respawn/reload when requested. | Every write needs a same-target precondition; readback is a later phase and must reject stale plans. |
| Replacement result | `core/vehicles.lua`, `replaceVehicle` | The API accepts an explicit vehicle object and returns the replacement object; player entry and callbacks can occur during construction. | Bind the returned object ID immediately, but confirm ownership separately from mutable tree convergence. |
| Extension update clocks | multiple first-party extensions use `onUpdate(dtReal, dtSim, dtRaw)` | Real, simulation, and raw deltas are separate inputs. | Lifecycle deadlines and housekeeping use monotonic real time; simulation time is diagnostic/gameplay-only. |

## Root-cause evidence from v0.6.1

The v0.6.1 adapter assembled one verification observation from three global views: `be:getPlayerVehicleID(0)`, `getPlayerVehicle(0)`, and `core_vehicle_partmgmt.getConfig()`. During replacement/reload, those reads were not proven to refer to the same vehicle ID or generation. A candidate could therefore be rejected for a model/config mismatch even after BeamNG had returned the intended replacement object. The tracker then waited until timeout, while recovery retained older readable/completed snapshots. A pause transition changed scheduling enough for the global views to converge, which explains the observed `tracking_target_identity` stall and why pause sometimes appeared to unlock progress.

The repair direction is therefore contractual rather than delay-based:

- create one coherent target-bound observation;
- accept target ownership before mutable tree convergence;
- guard every deferred write/readback by operation, phase, target, and recovery generations;
- use real monotonic deadlines independent of `dtSim` and pause state;
- promote recovery snapshots only after complete final readback and closed ledgers;
- terminate repeated state cycles instead of restoring indefinitely.

## External-mod boundary

The reported `driver_assistance_angelo234` nil-parts error belongs to another mod and is not modified here. The Randomizer may classify its own temporarily unavailable reads, reject unrelated callbacks, disable unsupported actions, and fail/recover terminally; it must not attribute another mod's exception as proof that the selected target changed.

## Internet research

No internet source was required for the initial diagnosis because the installed BeamNG runtime source exposes the exact callback, manager, replacement, and part-management contracts. If a later implementation decision cannot be resolved from installed first-party source, its official primary-source URL and consequence will be added here before release.
