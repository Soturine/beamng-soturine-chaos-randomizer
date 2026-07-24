# AI Director

AI Director controls only Spawn Director managed vehicles through audited
in-game BeamNG APIs. It has no BeamNGpy dependency, external process, Python
server, network service, or imported executable script.

## Audited boundary and capabilities

`aiAdapter.lua` is the only AI command boundary. For BeamNG
0.38.6.0.19963, installed source confirms vehicle-Lua commands for speed,
speed mode, aggression, lane/avoidance settings, path driving, target object,
traffic, stop/disable, and recording; GE Lua confirms NavGraph road/path calls.
Every mode is capability-gated at runtime.

Destination, Route, Chase, Follow, and Traffic are exposed when their required
boundary exists. Recorded playback and Scripted path are deliberately disabled:
the audited build does not give this mod a bounded portable contract for
transferring a recorded path back into these GE-Lua-managed assignments. The UI
shows the reason instead of a working-looking stub.

## Modes

- **Destination** computes a reachable NavGraph path from each managed vehicle
  to the confirmed static destination.
- **Route** computes bounded segments through user points, with add, remove
  last, clear, reverse, and loop controls.
- **Chase** and **Follow** require a real player or managed vehicle ID distinct
  from the controlled vehicle; removal stops with `ai_target_removed`.
- **Traffic** requests the audited vehicle-Lua traffic mode.

AI starts only for a registry entry whose target generation is current,
confirmed, validated, and free of pending writes/timers/callbacks.

## Settings and controls

Target speed is shown in km/h and converted to m/s at the UI boundary. `Set`
asks the AI to target the value; `Limit` lets the AI choose a value up to it,
matching the installed API contract. Aggression is clamped to the audited
0.3–1 range. Lane and vehicle avoidance are passed only as the installed
string flags.

Start delay and stagger produce separate real-time start timestamps so a group
does not start on one frame. Start all, Pause all, Resume all, Stop all, and
Reset all operate across the bounded director registry. Reset also clears the
route editor; stop/reset clean the temporary destination marker. Finish actions
are Stop, Apply brakes (the audited stop behavior), Keep driving, Loop, and
Disable AI.

Recording start/stop is a compact per-vehicle command. It does not imply that
Recorded playback is supported.

## Arrival, stuck, and finish

Each assignment records arrival radius/speed, timeout, progress timestamps,
remaining distance, minimum progress/speed, stuck timeout/action, and bounded
replans. Arrival requires final-destination proximity plus sufficiently low
speed or stopped evidence. Timeout and missing target end with explicit
reasons.

Optional stuck actions are Do nothing, Replan, Reset AI, Respawn from DNA, and
Mark DNF. Replan has a hard count limit. Respawn is never the default. Damaged
vehicles are allowed to continue by default; this mod does not invent a generic
damage threshold.

## Isolation and diagnostics

Commands are addressed to one verified runtime ID. Updating one AI entry does
not alter another, and managed target generations prevent stale respawn
callbacks from controlling a replacement. Diagnostics are bounded and include
mode, status, reason, vehicle/target, destination distance, replans, start
schedule, and recent director events.

## Evidence status

Capability detection, path/no-path, route editing, real target use/removal,
stagger, stop-all, arrival, stuck, replan bounds, marker cleanup, and
cross-vehicle isolation have automated evidence. Actual driving behavior,
traffic integration, arrival, collision recovery, and camera recording remain
interactive Pending.
