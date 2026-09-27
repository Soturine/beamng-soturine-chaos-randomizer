# AI behaviors

The Events area composes managed-vehicle behaviors over the same Race ownership
and scheduler core. The Behavior step expose verified presets for
Follow, Convoy, Chase, Flee, Traffic, Roam and Swarm. Advanced route, speed,
aggression, recovery and destination controls remain in a disclosure.

Convoy targets the player from the first managed NPC and then chains each later
NPC to the previous managed vehicle. Swarm distributes Follow, Chase, Flee,
Roam and Traffic roles deterministically. Stop All remains available and acts
only on managed local-authority vehicles.

Pega-Pega/Tag is future work tracked in the roadmap; no playground or contact
runtime ships in the mod package.
