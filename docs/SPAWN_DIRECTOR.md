# Spawn Director

Spawn Director places accepted Lineup competitors or a selected Vehicle DNA
without issuing multiple concurrent loads. The fixed initial bound is
`maxConcurrentLoads = 1`.

## Placement modes

Supported layouts are Front, Behind, Left, Right, four diagonals, Line, Grid,
Circle, and one Custom world point. Options include count, spacing, rows,
columns, radius, interval, ground offset, minimum clearance, spawn-one versus
spawn-all, next Lineup competitor, and selected DNA.

Heading modes are camera, current player vehicle, nearest road direction,
confirmed destination, and custom yaw. Player and road directions are read
through audited in-game calls. If their evidence is unavailable, preview fails
with a reason; it never silently falls back to camera. Destination heading
requires a confirmed destination.

## Safety preview

Before spawn, the director:

1. computes the deterministic transform;
2. raycasts to ground;
3. rejects excessive slope or vertical displacement;
4. enforces supported-distance bounds and ground offset;
5. checks spacing against all enumerated world vehicles and planned vehicles;
6. draws temporary debug markers when that capability exists.

Failure codes include `ground_not_found`, `slope_too_high`,
`position_blocked`, `outside_supported_area`, and capability-specific heading
errors. Preview markers are visual and require no permanent prop.

## Spawn, restore, and read-back

Each spawn receives the selected configuration plus DNA parts, public tuning,
and supported paints. The returned ID starts a managed target generation.
`Ready` requires two stable matching read-backs of model/configuration, parts,
tuning, and paint, followed by zero pending writes/timers/callbacks.

Spawn/switch callbacks only nominate bounded candidate IDs. A candidate can
rebind the managed handle only after matching read-back and the original target
generation. A stale generation or an ID already owned by another handle is
rejected. This prevents a callback from one vehicle rebinding another.

Spawn-all advances only after the prior target is verified or classified DNS.
Cancellation preserves already spawned vehicles but marks an unverified
pending target failed/DNS; it never promotes it to Ready.

## Managed vehicles

The registry stores runtime ID, Lineup competitor, DNA ID, model/configuration,
spawn transform, target generation, AI state, last known state, status, ID
history, and proven auxiliary IDs. Destroyed entries remain visible. Respawn
creates a new generation and updates the ID only after verification. Remove
deletes and cleans only the selected handle. Player switches do not erase the
registry.

## Evidence status

Transforms, bounds, heading evidence, custom point, overlap, read-back,
ownership, generation gates, rebind, respawn, and isolated removal have
automated coverage. Raycasts, visual previews, ID-changing mods, auxiliary
vehicles, and 16 live spawns remain interactive Pending.
