# BeamNG.drive 0.39 compatibility

v0.7.5 retains BeamNG 0.39.4 as its release target and 0.39.3 as the minimum
documented Runtime UI baseline. v0.7.4 owner findings are historical live
failure evidence; every v0.7.5 renderer, AppHost, controller, vehicle and
gameplay correction remains Pending owner validation against the exact
published ZIP.

Declared primary target: **0.39.4**. Minimum declared family: **0.39**. Release
stage: **experimental prerelease**. Live status: **Pending owner validation**.
`COMPATIBILITY.json` is the machine-readable source of these declarations.

## Evidence policy

Source inspection, official notes, sanitized fixtures, and automated tests prove
only their stated contracts. They do not prove that the published ZIP completed
gameplay inside BeamNG. `testedGameVersions` therefore remains empty until the
owner returns complete evidence for the downloaded asset.

The official combined 0.39.3/0.39.4 notes, published on 2026-08-07, were
reviewed again for v0.7.5:

- <https://www.beamng.com/game/news/patch/beamng-drive-v0-39-3/>
- <https://www.beamng.com/game/news/announce/beamng-drive-v0-39-hotfixes/>

The review covered Runtime UI scale/safe-zone/select and UINav changes,
`driveInLane` preservation, empty JBeam description handling, non-UTF8 ZIP
handling, and the documented Intel D3D12 VRAM/OOM limitation. No additional
0.39.4 note invalidated the runtime or package contracts implemented here.

## Version matrix

| BeamNG | Relevant contract | Current claim |
| --- | --- | --- |
| 0.39 | Native Runtime UI/AppHost and minimum supported family | Declared, automated contract only |
| 0.39.1 | Early 0.39 hotfix baseline | No live claim |
| 0.39.2 / 0.39.2.1 | Historical owner evidence and prior failures | Historical baseline only |
| 0.39.3 | HUD scalable metrics, metadata/config fixes, translation fixes, `driveInLane` preservation, known Intel D3D12 VRAM/OOM limitation | Incorporated into design/fixtures; no live claim |
| 0.39.4 | Primary target; combined official 0.39.3/0.39.4 hotfix review | Pending owner validation |

## Runtime UI and locales

The sole frontend is the Vue Runtime UI app beside `app.json`; no Angular
fallback is packaged. `ScrSelect` wraps the inspected 0.39.4 `BngSmartSelect`
contract. BeamNG host catalogs under `locales/translations/en-US`, `pt-BR`, and
`es-ES` provide the app picker name/description, while parity-complete internal
Vue catalogs provide app content. Runtime aliases such as `pt_BR`, `pt_PT`,
`es_ES`, and `es_419` map to the internal language families without becoming
vehicle identity.

Outer HUD coordinates, safe areas, scalable metrics, alignment, and persisted
layout are AppHost-owned. The mod does not call undocumented host resize APIs.

## Registry, configurations, and subgroups

Registry key, display name, and configuration filename are separate fields.
Selection and persistence use stable registry/config keys; translated labels do
not affect seeds. Family and subgroup keys let Race diversify distinct families
without treating every variant as unrelated. Empty or missing JBeam descriptions
fall back to a safe human label; raw slot paths are diagnostic-only.

Temporary empty/partial registry reads retain the last atomic valid index and
retry within a wall-clock budget. Official metadata changes between 0.39.2.1
and 0.39.3 are represented as mutable fixture data, not immutable assumptions.

## Instability, spawn, and identity

Vehicle instability, manual removal, spawn refusal, missing callback, divergent
player ID/object, and recycled IDs are distinct evidence. Future writes stop
when the bound generation disappears. Cleanup is ownership-scoped and cannot
delete a different or externally spawned vehicle. A refused spawn preserves the
source and terminates inside the phase limit.

## Race AI and `driveInLane`

The desired `driveInLane` policy belongs to each managed Race entry. Traffic →
managed → pause → resume → stop transitions do not broadcast commands to
unowned vehicles and do not resend unchanged commands per frame. Because 0.39.3
changed lane-policy preservation, the full transition remains a live case.

## Renderers and memory incidents

The live matrix covers default launcher, D3D11/fallback, forced D3D12, Vulkan,
and Intel+D3D12 when hardware is available. Incident evidence records BeamNG
version, renderer, GPU/VRAM, map, traffic/world/owned counts, peak temporary
ownership, operation, and phase. Classification separates
`mod_cardinality_violation`, `mod_memory_pressure`,
`engine_renderer_known_issue`, and `unknown`. The cardinality contract applies
even when a renderer/driver defect is suspected.

See [the v0.7.4 live plan](testing/v0.7.4/LIVE_TEST_PLAN.md) for cases and
[live results](testing/v0.7.4/LIVE_RESULTS.md) for the current evidence state.
