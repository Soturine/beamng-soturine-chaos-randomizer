# Compatibility

## Current target

Version `0.5.0-alpha.1` targets the currently installed BeamNG.drive `0.38.6.0.19963`, Steam build `23007233`.

| BeamNG version | Status | Evidence |
| --- | --- | --- |
| 0.38.6 | Alpha target | installed source inspected; Lua console/static/package tests pass; gameplay/UI Pending |
| Other 0.38 builds | Unknown | internal contracts may differ |
| 0.37 and older | Unsupported | hierarchical API assumptions are not backported |
| Newer versions | Unknown | re-audit `apiAdapter.lua` before claiming support |

Source compatibility is not interactive compatibility. No vehicle/mod row below should be read as Passed until [Testing](TESTING.md) contains reproducible live evidence.

Creative locks and mutations do not expand BeamNG compatibility: they only preserve or vary choices exposed by the mounted registry, current hierarchical tree, tuning metadata, and supported paint fields. Unknown slot-category evidence remains `other`; an unresolved saved slot/part lock is reported rather than guessed.

Gallery capture, SHA-256, controlled binary paths, and package exchange are granular optional capabilities. If a boundary is absent, core randomization and JSON copy remain available while the affected button is disabled or the Gallery uses fallback. `.vdna.zip` transfers identities/dependencies, not missing mods; the receiving PC must independently install compatible content and run preflight.

## Content classes

| Content | Discovery and hardening | Interactive status |
| --- | --- | --- |
| Official vehicles/configs | mounted registry; exact official source marker | Pending |
| Config packs on official models | explicit mod identity or confirmed config-path ownership; base-model blacklist remains separate | Pending |
| Full mod vehicles | mounted registry; config path must independently prove ownership | Pending |
| Part packs | exact loaded-slot candidates; selected-candidate provenance; bounded suspect/blacklist | Pending |
| Wheel/tire packs | same hierarchy rules; ancestor wheel change defers tire | Pending |
| User-saved configs | exact `Custom`/user/player evidence | Pending |
| Unknown metadata | included by Everything; excluded by Official-only/Mods-only | Pending |
| Automation / trailer / prop | exact current `Type`; dynamic safety profile avoids road-only requirements | Pending |
| Electric / hybrid-like | loaded powertrain/energy evidence; no fuel/gearbox requirement | Pending |
| Multi-differential / differential-free | graph role counts; no exactly-one assumption | Pending |
| Multi-vehicle configs | registry may expose them; behavior not validated | Unknown |

Synthetic license-safe fixtures cover all of these metadata/tree shapes without redistributing JBeam, artwork, brands, or third-party content.

## Required APIs and graceful degradation

| Capability | Needed by |
| --- | --- |
| registry + replace + lifecycle confirmation | Random Config |
| parts read + parts write + lifecycle confirmation | Scramble essential stage |
| tuning read + tuning write + lifecycle confirmation | optional tuning stage |
| paint read + paint write | optional paint stage |
| replace + lifecycle confirmation | Undo/rollback |
| settings persistence | persistent UI settings; operations can still use current-session snapshots |
| DNA read/write | persistent Garage save/list/delete/import; randomization remains available without it |
| DNA file export | optional fixed-path export only; JSON copy remains available without it |
| DNA backup | controlled last-known-good recovery; no transactional atomicity claim |

If tuning or paint is unavailable, compatible-parts mutation can continue with a visible capability warning. Missing parts write disables Scramble and Full Random. Missing registry/replace disables Random Config.

## Source classification

`official`, `mod`, and `user` require current evidence. Arbitrary non-empty `Source` labels remain `unknown`. A mod configuration on an official model is classified from its own explicit identity or mounted `pcFilename` ownership, so it stays in Mods-only results. A config never inherits mod status solely from a mod parent model.

## Safety boundary

`Protect Critical Parts` prevents detectable required/core removal and preserves baseline-proven functional roles through a dynamic evidence graph. Trailer/prop requirements differ from standard road/electric/hybrid-like profiles. `uncertain` is allowed for insufficient unusual metadata and is not a drivability claim; `unsafe` rolls back. BeamNG remains the final loader/compatibility authority, and a reported suitable candidate can still fail during reload.

Replacement compatibility also requires resolving the recorded target object and extracting a target ID from the object returned by `replaceVehicle`. Config identity must be proven by a layered strategy. Paint compatibility is limited to the installed supported fields and a bounded read-back window.

## Determinism boundary

Equal seeds reproduce project choices only when all inputs match:

- BeamNG build;
- randomizer version;
- enabled content and metadata;
- settings and starting vehicle/configuration;
- session blacklist/suspect state.

External mod scripts, physics timing, and changed mounted content are outside this guarantee.

Vehicle DNA separates two different contracts:

- Restore Exact applies a saved snapshot without RNG/recent/blacklist fallback and reports exact only after full slot/tuning/paint/topology read-back.
- Replay Generation freezes the saved base and reruns generator version 4 parts/tuning/paint stages. Pure Seed Replay is explicitly separate and can reselect the base. Legacy seed text is parseable, but an unsupported generator version is not silently replayed.

Restore Compatible never chooses a random substitute. It reports missing/ambiguous slots, absent parts/dependencies, clamps, paint-layer omissions, and environment differences before the user can confirm a partial application. A cross-model registry preflight reports `target_inspection_required`; after the saved base loads, target inspection decides Exact, Compatible, or rollback.

## Reporting results

Include BeamNG build, randomizer commit/version, content name/version/source/license, operation, settings, seed, result, and tagged log excerpts. Do not attach paid/private content. State whether Reindex and a clean profile change the result.

See [Compatibility Matrix](COMPATIBILITY_MATRIX.md) for per-class automated and interactive evidence.
