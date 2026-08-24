# Multiplayer-compatible ownership model

v0.7.8 does not depend on BeamMP and does not claim BeamMP support. It carries a
future-compatible identity envelope:

```text
environment, localVehicleId, ownerPlayerId?, networkVehicleId?, authority, origin
```

`LOCAL` and `SERVER_GRANTED` authority may be mutated or cleaned when operation
ownership is also proven. `REMOTE` and `UNKNOWN` authority may not. Two objects
with the same local vehicle ID but different owner/network identity are not the
same identity. Unrelated traffic or world changes remain external diagnostics.

Single-player entries default to local authority. Non-single-player entries
without explicit authority default to unknown, which fails cleanup closed.
Race slot lineage is also required before cleanup, regeneration or placement.
Network discovery, replication, server arbitration and a BeamMP adapter remain
future work and require their own integration and live evidence.
