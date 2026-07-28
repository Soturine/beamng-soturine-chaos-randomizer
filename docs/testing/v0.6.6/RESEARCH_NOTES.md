# Research notes — v0.6.6

## BeamNG runtime boundaries

The implementation was checked against installed BeamNG.drive
`0.38.6.0.19963` source patterns. Game-engine and Vehicle Lua virtual machines
remain separate: GE queues the generation-bound probe and the vehicle extension
returns serialized thermal evidence through `obj:queueGameEngineLua`.

Combustion devices are discovered with
`powertrain.getDevicesByType("combustionEngine")`. Thermal debug evidence
exposes engine oil mass, safe-minimum metadata, coolant data, disabled state and
oil-critical damage. The inspected implementation contains the field spelling
`miniumSafeOilMass`; the probe also recognizes `minimumSafeOilMass`. No supported
public runtime oil-mass setter was found, so v0.6.6 does not fabricate one.

Vehicle creation uses BeamNG's vehicle manager boundary. Race temporarily enters
the newly spawned owned competitor only where player-global part-management APIs
require it, then restores player focus. Placement uses `spawn.safeTeleport` and
read-back against the retained concrete vehicle ID.

## Conflict boundary

Owner observation showed that removing BeamLR and
`scripts/driver_assistance_angelo234` stopped the former 22%/57% hard freeze and
pause dependency. This establishes an external conflict contribution; it does
not prove either third-party bug was fixed. v0.6.6 detects safe signals, emits a
warning, and does not disable or delete third-party content.

## Evidence limits

Source inspection and mocked execution prove call shapes and state-machine
contracts, not live physics, drivability, UI rendering, performance or broad mod
compatibility. Those results remain in the 99-case live plan.

Primary references:

- [BeamNG Lua virtual machines](https://documentation.beamng.com/modding/programming/virtualmachines/)
- [BeamNG logging](https://documentation.beamng.com/beamng_tech/tools/logging/)
- [JBeam debug tools](https://documentation.beamng.com/modding/vehicle/intro_jbeam/debugtools/)
