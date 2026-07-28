# Race Workflow

Race is the public three-stage workflow: **Cars → Placement → Drive**. Older saved data and historical documentation may call Cars a “Lineup”; that remains a compatibility/storage term, not a top-level UI destination.

## Cars

Balanced, Maximum Chaos, Mods Showcase, and Custom policies feed the same Full Random pipeline used by Chaos. Generate Cars reserves one immutable competitor identity, spawns a new physical target at its own staging transform, binds and randomizes that exact ID, retains it in the managed registry, restores player focus, and only then advances. It never counts a failed/nonexistent ID. Each competitor owns its own operation/generation/current-ID/spawn/randomization/validation/placement/terminal state. Retry derives an attempt-specific seed domain; fallback, skip, cancel and stop are explicit actions.

## Placement

Only retained Ready cars (or explicitly accepted Partial cars) are eligible. The tab reports why it is unavailable. Front, Behind, Left, Right, diagonal, Line, Grid, Circle, and Custom point plans use ground raycast, slope limits, heading validation and collision spacing. Reordering assigns unique positions. Applying Placement teleports the already managed concrete IDs through BeamNG's safe placement path and requires two position read-backs; it does not spawn duplicates.

## Drive

AI commands operate only on confirmed managed vehicles. Destination and Route require a reachable NavGraph; Chase and Follow require a distinct existing target; Traffic requires Vehicle Lua queue support. Scripted mode is visibly unsupported because no bounded portable path-transfer contract is enabled. Start, pause, resume, stop, reset, and damaged respawn are bounded and do not rely on simulation pause toggles.

Capabilities are reported as `available`, `degraded`, `unavailable`, or `unsupported`. A disabled control includes a reason rather than claiming an API exists.
# v0.6.7 Race lifecycle

Race generation uses explicit `planning → validating_slots → spawning → binding
→ placing → ready/partial_ready/failed/cancelled` states. Each AI competitor has
independent selection/mutation/placement/retry seeds and one managed vehicle ID.
The player can participate in a total-vehicle count or remain a spectator while
exactly N independent AI competitors are generated.

Placement requires a complete preview before confirmation. Automatic Best Fit
uses known vehicle width/length plus a safety margin and reports its effective
layout/fallback. A narrow or width-unknown area uses explicit single-file
fallback. Confirm moves retained managed IDs; generation cleanup and cancel are
Race-scoped.

The full option/default inventory is in
[v0.6.7 Race policy inventory](testing/v0.6.7/RACE_POLICY_INVENTORY.md).
