# Compatibility

Compatibility is evidence-based and version-specific. v0.6.9 declares
BeamNG.drive `0.39` as its primary target and `0.38.6` as its minimum supported
version. `COMPATIBILITY.json` is the single machine-readable source for this
policy. Source/API inspection is complete; live 0.39 owner validation is
Pending and is not implied by automated results.

v0.6.9 reads the current player's part-manager configuration and the ID-specific
manager bundle independently. A matching coherent source may confirm an
already-applied state while another cache is stale. This is not a permissive
fallback: model/configuration and phase evidence must match, the player ID is
rechecked, and one chosen view supplies all mutable-state evidence.

## Content discovery

The mod uses the mounted BeamNG registry and loaded vehicle data. It has no model, part, slot, or tuning catalog. Official vehicles, config packs, full vehicle mods, part packs, wheel packs, user configurations, Automation exports, trailers, and props are classified from current metadata and capabilities.

Source classifications are `official`, `mod`, `user`, and `unknown`. Unknown evidence is never silently promoted. Automation, trailer, and prop participation is opt-in.

## Capability states

| State | Meaning |
| --- | --- |
| `available` | Required API and coherent read/write evidence are present. |
| `degraded` | A bounded alternative exists with reduced behavior. |
| `temporarily_unreadable` | The API exists but current data is not yet coherent; bounded retry is allowed. |
| `unsupported` | The environment exposes no supported path. |
| `failed` | A supported path was attempted and returned or threw a failure. |

One malformed variable, storage, or optional feature does not fail the entire operation. The pipeline prefers BeamNG metadata, then loaded data, generic inference, conservative fallback, and finally an explicit skip with diagnostics. Fuel uncertainty and optional/non-standard mod missing-part metadata are nonfatal warnings; documented core-slot or proven baseline functional loss remains fatal.

## Persistence compatibility

- Settings schema 8 transactionally migrates older supported settings with a
  last-known-good backup, readback, verified rollback, and migration report.
- Vehicle DNA schema 1 retains generator 4/5/6 identity; older seeds are not reinterpreted as generator 6.
- `raceManager.lua` is canonical internally, while historical Lineup storage, methods, and imports remain compatible through a facade.
- Release tags and assets are immutable; older archives remain in their release records.

## Current evidence

See [CURRENT_COMPATIBILITY_MATRIX.md](status/CURRENT_COMPATIBILITY_MATRIX.md) for the candidate status. Real third-party compatibility requires recording the content name/version, source, BeamNG build, mod commit/artifact checksum, settings, seed, terminal result, diagnostics, and log outcome.

Detailed 0.39 findings, preserved P0 decisions, implemented P1 performance
work, and deferred v0.7.0 P2 work are in
[BEAMNG_0.39_COMPATIBILITY.md](BEAMNG_0.39_COMPATIBILITY.md).
