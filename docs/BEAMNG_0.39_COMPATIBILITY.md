# BeamNG.drive 0.39 compatibility — v0.6.9

Status: **P0 preserved; P1 performance implementation complete; live owner validation Pending**.

This dossier records compatibility decisions preserved by the 0.6.9
Experimental prerelease. It distinguishes official documentation/source inspection,
automated production-code tests, and live gameplay. No live world, physics,
rendering, performance, or representative-mod case was executed in this Codex
run.

## Sources inspected

- BeamNG.drive 0.39 official release notes:
  <https://www.beamng.com/game/news/patch/beamng-drive-v0-39/>
- Official UI documentation:
  <https://documentation.beamng.com/modding/ui/>
- Official UI App creation documentation:
  <https://documentation.beamng.com/modding/ui/app_creation/>
- Installed 0.39 source for the vehicle registry, config preparation,
  replacement/spawn, safe placement, memory guard, part management, vehicle
  manager, Runtime UI Angular host, and UI App overlay.

Source inspection establishes contracts to test; it is not live proof.

## Relevant 0.39 changes and v0.6.8 response

| 0.39 change | P0 response |
|---|---|
| Vehicle-selector configuration subgroups | Registry model/config keys, physical paths, basenames, families, and display groups are separate. Aliases are data-driven. Ambiguity stays explicit. |
| Configuration display name may differ from `.pc` filename | Display labels never replace technical registry/config/path identity. |
| Translation extended to vehicle/config/part/tuning fields | Seeds, DNA, locks, Race policy, comparisons, and compatibility use internal keys only. |
| Case-sensitive read-only watchers and case-preserving unpack | Physical paths preserve exact case; a separate lowercase path is comparison-only; traversal/URI/drive paths fail closed. |
| Instabilities can remove vehicles without pausing | Destroy events are correlated to current domain/generation/ID. Only an explicit instability cause becomes `INSTABILITY_CONFIRMED`; an unqualified disappearance is `UNKNOWN_FAILURE` and cannot blacklist content. |
| Safe placement may decline a vehicle | Absence of a returned object is not labeled “no space” without stronger evidence. World snapshots and bounded readback decide whether a candidate exists. |
| Low-memory guard denies additional vehicle/traffic spawns | The inspected 0.39 `false` contract maps to `DENIED_LOW_MEMORY`; it stops immediately and does not blacklist or retry forever. |
| UI Apps renamed HUD Apps; Runtime UI is Vue | The existing Angular directive remains supported through the Runtime UI Angular host. v0.6.8 adds bounded timer/observer teardown and 50-cycle sizing tests. |
| `driveInLane` defaults changed outside Traffic | Every AI request sends an explicit lane value; capability/reason is public and a failed initial command remains `failed`. |
| Engine/controller/powertrain/fuel/N2O reset fixes | Existing ternary guards and reset fixtures were expanded/preserved. Gameplay revalidation remains live Pending and broader adoption is P1. |

## Compatibility metadata and runtime states

`COMPATIBILITY.json` declares:

- mod version `0.6.9`;
- primary BeamNG target `0.39`;
- minimum BeamNG version `0.38.6`;
- no fabricated live-tested build list;
- live status `Pending owner validation`.

Runtime classification is `primary_target`, `supported_legacy`,
`newer_unverified`, `older_unsupported`, or `unknown`, with detected version,
target, minimum, and warnings exposed to the HUD/diagnostics.

The content registry progresses through `unavailable`, `warming_up`, `partial`,
`ready`, and `failed_confirmed`. Retry count and wall-clock timeout are bounded.
A complete prior index survives temporary empty/partial reads. Mod state changes
mark it stale and schedule reindexing without erasing valid content first.

## Technical identity

Every indexed configuration may carry:

- `registryModelKey` and `registryConfigKey`;
- `physicalPathExact` and `comparisonPathNormalized`;
- basename key and scoped key;
- display name and optional display group;
- vehicle family and data-driven alias;
- source kind/label/ownership evidence;
- translation-independent `technicalId`.

Path, registry key, and state signature are independent verification strategies.
One match may confirm identity; multiple signature matches return an ambiguous
result rather than selecting silently.

## Spawn, replacement, removal, and quarantine

A transaction records requested content/placement, world IDs before/after,
created IDs, returned object/ID, candidates, accepted ID, rejected IDs, outcome,
and cleanup. Stable readback is required before acceptance. Zero or multiple
accepted candidates fail the cardinality contract. Cleanup is restricted to
IDs proven created and unaccepted by that transaction.

Failure reasons are `DENIED_LOW_MEMORY`, `DENIED_NO_SPACE`,
`TEMPORARY_REGISTRY`, `INVALID_CONTENT`, `INSTABILITY_CONFIRMED`, and
`UNKNOWN_FAILURE`. Only confirmed invalid content or correlated instability is
eligible for catalog penalty. Memory, placement pressure, registry warm-up,
unqualified destruction, and isolated unknown failures are never persistent
blacklist evidence. Manual Retry clears temporary/domain quarantine explicitly.

## Persistence and coexistence

Settings schema 8, Vehicle DNA schema 1, and Lineup schema 1 are retained or
migrated transactionally. Settings and lineup writes back up the last readable
value, write the candidate, read it back deeply, and restore/read back the
previous value on mismatch. Vehicle DNA keeps its equivalent existing protocol.
Temporary read failure never creates or overwrites an empty library. A migration
report records each store and source/target schema.

Detected BeamLR, Driver Assistance (angelo234), other randomizers, and
multiplayer vehicle synchronization produce structured warning-only records:
`conflictId`, loaded extension or mounted-path evidence, recommended action, and
`disabledByRandomizer=false`. v0.6.9 never disables another mod automatically.

## v0.6.9 P1 compatibility constraints

P1 adds low-GC iterator capability detection with `getAllVehicles()` fallback,
OOBB XYZ capability detection with bounded box fallback, registry cache
fingerprinting that includes game/mod/schema state, incremental indexing, and
AI mode readback when available. Missing optional iterator, OOBB XYZ, profiler,
or AI readback capabilities degrade to the preserved v0.6.8 behavior; they do
not disable Chaos, Race, or Garage.

P2 remains v0.7.0: migrate Angular to Runtime UI-native Vue, internationalize,
and modernize architecture only with parity and migration evidence. After
v0.7.0, perform a fresh full audit against then-current BeamNG 0.39.x hotfixes,
documentation, APIs, and compatibility reports.

## Evidence status

Automated production-code, fixture, static, JavaScript, packaging, checksum,
manifest, and release-gate tests are Passed. The exact 64-case v0.6.9 owner
performance matrix is 0 executed / 0 passed / 0 failed / 64 pending / 0 blocked.
