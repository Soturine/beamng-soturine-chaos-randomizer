# Race workflow

## v0.7.9 retry and containment

The UI presents Race authoring under Events. Player-participation count N means
N-1 generated opponents; spectator count N means N generated NPCs. Each slot
owns one candidate and staging transform. Background callbacks restore player
focus while writes continue against the candidate's explicit ID.

Preview data is not visibility evidence; only a successful drawn marker frame
is visible. The renderer runs from the BeamNG render callback and only consumes
read-only world-space footprint/heading primitives. Persistence checkpoints are
copied and committed transactionally;
typed write failures retain coherent in-memory state and allow bounded retry.
Preview and staging retries receive fresh attempt identities. The scheduler
closes an abandoned open slot locally and continues later slots. Accepted slots
are terminally immutable.

Placement preserves the requested ideal formation first, then tests a bounded,
deterministic whole-group translation and spacing sequence for blocked ground,
missing ground or excessive slope. Per-slot search is an explicit degraded
fallback only after rigid geometry is exhausted. Formation origin and heading
are separate: a participating player is the Automatic origin, Camera is an
explicit option, and player bounds protect the first longitudinal gap. Attempt
counts, rejection reasons, capped samples, selected fallback depth and duration
are diagnostics. Generation uses its own forward staging plan, protects the
player as occupied space and does not depend on the final formation or renderer.

Race is the public three-stage workflow: **Cars → Placement → Drive**. Each
generated competitor is an independent slot transaction. Older saved data may
use “lineup” as a storage term; it is not a separate top-level UI destination.

Blank explicit generations mint a fresh episode seed; Repeat is a separate
intent that reuses a prior seed. Before replacement generation, exact prior
Race-owned bindings are reconciled. Each accepted slot resolves 1:1 to its
concrete vehicle and managed handle, and managed Regenerate commits an atomic
source-to-candidate handoff. Placement is calculated and executable even when
the optional world-preview renderer is unavailable.

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
Any focus change caused by background spawn is restored to the player
immediately; the candidate remains addressable only by its proven slot-owned ID.

## Player and spectator semantics

Spectator mode creates the requested number of AI competitors and leaves the
player outside that set. Participation mode assigns the player only as an
explicit final lineup role; it does not use the player to build AI cars. Player
focus switches during background generation do not change slot targets.

## Placement

Only Ready cars, or explicitly accepted Partial cars, are eligible. Automatic
Best Fit and the directional/line/grid/circle/custom plans perform ground,
slope, heading, distance, and spacing checks. Confirmation moves the already
managed exact IDs through one bounded reposition transaction and performs stable
position readback; it does not spawn replacement clones or inherit the
spawn/load throttle. A repeated Position All request reuses the active
transaction and publishes progress instead of producing a busy failure.

## World preview

Generation preview and final-grid preview are distinct overlays. Generation
preview shows where the player and planned slots will stage before an opponent
is spawned; final-grid preview shows destination footprints before teleport.
Both use pure placement plans and debug drawing only. Controls cover origin,
heading source, formation, spacing, safety margin, and custom position. Preview
cleanup occurs on cancel, map change, and extension unload.

## Drive and domain isolation

AI commands operate only on confirmed managed vehicles with current generation,
physical binding, completed placement, proven drivability and supported
capability. Scheduling eligibility and actual command/readback startup remain
separate evidence. Destination and Route
require reachable NavGraph evidence; Chase and Follow require a distinct target.
Race operations publish Race-domain state and events only, never Chaos action
success/failure events. Capabilities are reported as available, degraded,
unavailable, or unsupported with a visible reason.

Automated 1/4/8/12-slot, partial-failure, stale-callback, player-isolation, and
owned-cleanup fixtures pass. Live BeamNG validation remains Pending owner
validation.
