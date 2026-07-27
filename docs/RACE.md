# Race Workflow

Race is the public three-stage workflow: **Cars → Placement → Drive**. Older saved data and historical documentation may call Cars a “Lineup”; that remains a compatibility/storage term, not a top-level UI destination.

## Cars

Balanced, Maximum Chaos, Mods Showcase, and Custom policies feed the same Full Random pipeline used by Chaos. Each competitor owns a target generation and must close as Ready, Ready with warnings, Partial, Failed, Skipped, or Cancelled. Selecting, Loading, Randomizing, and Verifying are bounded non-terminal phases. Retry derives an attempt-specific seed domain; fallback, skip, and stop are explicit user actions.

## Placement

Only accepted Ready cars (or explicitly accepted Partial cars) are eligible. Front, Behind, Left, Right, diagonal, Line, Grid, Circle, and Custom point plans use ground raycast, slope limits, heading validation, collision spacing, and one-at-a-time spawn verification. A spawned vehicle is not Ready until its exact managed handle/generation has stable model/config readback.

## Drive

AI commands operate only on confirmed managed vehicles. Destination and Route require a reachable NavGraph; Chase and Follow require a distinct existing target; Traffic requires Vehicle Lua queue support. Scripted mode is visibly unsupported because no bounded portable path-transfer contract is enabled. Start, pause, resume, stop, reset, and damaged respawn are bounded and do not rely on simulation pause toggles.

Capabilities are reported as `available`, `degraded`, `unavailable`, or `unsupported`. A disabled control includes a reason rather than claiming an API exists.

