# Race workflow

Race is the public three-stage workflow: **Cars → Placement → Drive**. Each
generated competitor is an independent slot transaction. Older saved data may
use “lineup” as a storage term; it is not a separate top-level UI destination.

## Cars and slot ownership

Each slot owns its slot ID, derived seed, exact target vehicle ID, generation,
temporary IDs, retry count, wall-clock deadline, and terminal result. A slot
cannot bind to a target owned by another slot. Background parts, tuning, and
paint writes address the exact non-player vehicle through audited manager and
part-management contracts. The player is never selected or entered as staging.

One bounded heavy job is scheduled at a time. Stale generation/token callbacks
return before mutation. An accepted slot becomes managed and is removed from
temporary ownership. Failure, retry, cancel, and cleanup affect only the
operation's still-owned temporaries; accepted competitors in other slots remain.

## Player and spectator semantics

Spectator mode creates the requested number of AI competitors and leaves the
player outside that set. Participation mode assigns the player only as an
explicit final lineup role; it does not use the player to build AI cars. Player
focus switches during background generation do not change slot targets.

## Placement

Only Ready cars, or explicitly accepted Partial cars, are eligible. Automatic
Best Fit and the directional/line/grid/circle/custom plans perform ground,
slope, heading, distance, and spacing checks. Confirmation moves the already
managed exact IDs and performs stable position readback; it does not spawn
replacement clones.

## Drive and domain isolation

AI commands operate only on confirmed managed vehicles. Destination and Route
require reachable NavGraph evidence; Chase and Follow require a distinct target.
Race operations publish Race-domain state and events only, never Chaos action
success/failure events. Capabilities are reported as available, degraded,
unavailable, or unsupported with a visible reason.

Automated 1/4/8/12-slot, partial-failure, stale-callback, player-isolation, and
owned-cleanup fixtures pass. Live BeamNG validation remains Pending owner
validation.
