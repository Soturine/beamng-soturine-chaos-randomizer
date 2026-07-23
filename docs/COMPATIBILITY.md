# Compatibility

## Current target

Version `0.2.0-alpha.1` targets BeamNG.drive `0.38.6.0.19963`, Steam build `23007233`.

| BeamNG version | Status | Evidence |
| --- | --- | --- |
| 0.38.6 | Alpha target | installed source inspected; Lua console/static/package tests pass; gameplay/UI Pending |
| Other 0.38 builds | Unknown | internal contracts may differ |
| 0.37 and older | Unsupported | hierarchical API assumptions are not backported |
| Newer versions | Unknown | re-audit `apiAdapter.lua` before claiming support |

Source compatibility is not interactive compatibility. No vehicle/mod row below should be read as Passed until [Testing](TESTING.md) contains reproducible live evidence.

## Content classes

| Content | Discovery and hardening | Interactive status |
| --- | --- | --- |
| Official vehicles/configs | mounted registry; exact official source marker | Pending |
| Config packs on official models | configuration `modID` keeps source `mod`; base-model blacklist remains separate | Pending |
| Full mod vehicles | mounted registry; mod identity when provided | Pending |
| Part packs | exact loaded-slot candidates; per-model/path/candidate blacklist | Pending |
| Wheel/tire packs | same hierarchy rules; ancestor wheel change defers tire | Pending |
| User-saved configs | exact `Custom`/user/player evidence | Pending |
| Unknown metadata | included by Everything; excluded by Official-only/Mods-only | Pending |
| Automation / trailer / prop | exact explicit metadata or exact current `Type` | Pending |
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

If tuning or paint is unavailable, compatible-parts mutation can continue with a visible capability warning. Missing parts write disables Scramble and Full Random. Missing registry/replace disables Random Config.

## Source classification

`official`, `mod`, and `user` require current evidence. Arbitrary non-empty `Source` labels remain `unknown`. A mod configuration on an official model is classified from its own metadata, so `modID` keeps it in Mods-only results. A model with incomplete ownership metadata is never promoted to official merely because its configuration or key looks familiar.

## Safety boundary

`Protect Critical Parts` prevents detectable required/core removal and conservatively retains current/default critical concepts. It is not a drivability guarantee. BeamNG remains the final loader/compatibility authority, and a third-party candidate advertised as suitable can still fail during reload.

## Determinism boundary

Equal seeds reproduce project choices only when all inputs match:

- BeamNG build;
- randomizer version;
- enabled content and metadata;
- settings and starting vehicle/configuration;
- session blacklist/suspect state.

External mod scripts, physics timing, and changed mounted content are outside this guarantee.

## Reporting results

Include BeamNG build, randomizer commit/version, content name/version/source/license, operation, settings, seed, result, and tagged log excerpts. Do not attach paid/private content. State whether Reindex and a clean profile change the result.
