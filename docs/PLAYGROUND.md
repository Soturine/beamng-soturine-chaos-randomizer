# AI behaviors and Playground foundation

The Events area composes managed-vehicle behaviors over the same Race ownership
and scheduler core. The simple v0.7.8 controls expose verified presets for
Follow, Convoy, Chase, Flee, Traffic, Roam and Swarm. Advanced route, speed,
aggression, recovery and destination controls remain in a disclosure.

Convoy targets the player from the first managed NPC and then chains each later
NPC to the previous managed vehicle. Swarm distributes Follow, Chase, Flee,
Roam and Traffic roles deterministically. Stop All remains available and acts
only on managed local-authority vehicles.

## Tag foundation

v0.7.8 packages a reusable `playgroundMode` state machine and
`contactDetector`. Contact evidence distinguishes `started`, `persisted` and
`ended`, carries relative speed and optional severity/impulse, supports a
proximity-plus-relative-speed fallback and applies a bounded cooldown.

Pega-Pega/Tag is **not user-facing in v0.7.8**. The release does not claim role
orchestration, gentle approach behavior or live contact reliability. The button
is withheld because the required Race, AI, contact and live behavior gate has
not been completed against the published ZIP.
