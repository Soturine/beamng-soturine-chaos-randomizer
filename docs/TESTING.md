# Testing

Automated and installed-source evidence is kept separate from interactive BeamNG evidence. A green CI run does not prove UI rendering, physics readiness, or compatibility with a third-party mod.

## Test environment

| Item | Value |
| --- | --- |
| Date | 2026-07-23 |
| Operating system | Windows 10 build 19045 |
| BeamNG executable | `0.38.6.0.19963` |
| Steam build | `23007233` |
| BeamNG console | shipped Lua 5.1 runtime |
| Python | local Python 3; CI Python 3.12 |
| Node.js | local 24.11.1; CI 24 |
| Interactive 0.38 profile/world | unavailable |

No 0.38 world/UI session was launched. All interactive rows below remain **Pending**.

## Automated commands

```powershell
python -m unittest discover -s tests -v
node --check ui/modules/apps/soturineChaosRandomizer/app.js
python tools/package_mod.py
python tools/validate_package.py
python tools/profile_fixtures.py
```

CI additionally runs:

```bash
find lua -type f -name '*.lua' -print0 | xargs -0 luac5.1 -p
```

On 2026-07-23, every workflow SHA was resolved again through the official `actions/checkout`, `actions/setup-python`, `actions/setup-node`, and `actions/upload-artifact` GitHub repositories. Each pinned SHA matched its commented tag, and those tags were the repositories' latest releases at inspection time.

Current suite structure after the creative Vehicle DNA implementation:

- **39 Python `unittest` methods**;
- one Python method runs **264 named Lua behavior/syntax/pipeline/performance cases** against BeamNG's shipped Lua 5.1 console when no standalone Lua is available;
- **27 repository/static methods**, including real `node --check`, JSON/YAML parsing, links, versions, API boundary, UI atomicity/host/DNA/share boundary, accessibility/responsiveness, icon limits, action pins, credentials, paths, and whitespace;
- **11 package methods**, including two-build equality, SHA, root layout, normalized metadata, version, manifest consistency, and machine-path checks;
- **1 JavaScript file** syntax-checked;
- **2 project JSON files** decoded;
- **3 workflow YAML files** decoded.

These counts must be rechecked in the final report from the final committed tree.

## Mandatory regression coverage

Named Lua cases cover:

- adapter rejection of `false`, explicit normal-`nil` contracts, thrown details, phase codes, and unconfirmed writes;
- stable hierarchy order, parent deferral, multiple ancestors, siblings, new-tree candidates, pass cap, and stale-candidate rejection;
- required/core absence and non-empty critical replacement protection, current/default preference, migration, and reason codes;
- per-type blacklist keys/counts/details, part filtering, phase attribution, config isolation, suspect batches, and reindex clearing;
- phase-specific lifecycle expectations, stale/wrong events, post-event verification, and exact timeout reasons;
- unknown/mod/user/official precedence plus exact Automation/trailer/prop classification;
- independent tuning, explicit group substreams, per-member ranges/steps, missing-group behavior, and seed determinism;
- bounded/cancellable/non-overlapping stress state, stop policy, phase summary, deterministic iteration seeds, and asynchronous scheduling state;
- delayed first-write history commit, one entry across passes, Undo behavior, and successful-rollback cleanup;
- granular capability derivation and optional-stage warnings;
- deterministic PRNG, selection fairness, tuning distributions, state transitions, package-independent utility behavior, and compilation of every Lua source.
- bounded suspect promotion/suppression/decay/fingerprint/storage policy;
- exact target-object writes and returned replacement correlation, queued synchronous switch handling, unrelated switch rejection, and restore-target safety;
- tolerant paint normalization and immediate/bounded deferred confirmation without a spawn event;
- mounted config path ownership, layered config identity proof, and per-candidate part provenance;
- safety profiles for combustion/electric/hybrid-like/trailer/prop/unknown, direct drive, two wheels, multi-motor, multi-differential, and differential-free layouts;
- mocked Random Config, Scramble, Full Random, rollback, Undo, timeout, stress, map/mod cancellation, and failure attribution pipelines;
- deterministic 5,000-config registries, 100/160-level trees, diagnostics/suspect bounds, and index-cache reuse.
- schema-v1 required fields, future-version rejection, idempotent current migration, JSON-only bounds, duplicate path/tuning rejection, and canonical finite/cycle/depth/string/element handling;
- change detection for slot/tuning/paint edits, field-fingerprint revalidation, and the rule that fingerprints never replace final field comparison;
- bounded library add/rename/favorite/delete/page/limit behavior, primary/last-known-good adapter writes, explicit backup loading, and confirmed persistence read-back;
- read-only exact/compatible preflight, conservative path/slot/parent resolution, missing/ambiguous/out-of-range reporting, dependency/environment warnings, and zero preflight writes;
- parent-first Exact restore, compatible clamp/deviation/read-back, DNA-specific safety/final verification, one history transaction, and rollback on rejected writes;
- explicit save only after successful final capture, no pending DNA after a failed operation, legacy/new seed parsing, and separate Replay/Restore APIs;
- parsed-before-bridge import, fixed method allowlist, restore/delete confirmation, detailed favorite controls, five-view navigation, eight-item Garage pagination, one-off full-detail/export events, and controlled file export;
- vehicle/config/category/slot/part/tuning/paint locks, evidence classification, unresolved locks, settings migration, restore lock independence, and explicit replay current-lock deviations;
- Reroll Unlocked lock preservation/no-op capture, independent category/slot/tuning/paint substreams, deterministic mutation strengths/seeds/indices, parent immutability, unique children, bounded lineage, and missing-parent behavior;
- pins/ratings/tags/notes/collections, filtered/sorted/paginated Garage queries, field-level comparison, fallback/PNG limits, safe managed IDs, and thumbnail count/cleanup policy;
- `.vdna.json` envelopes plus stored-ZIP CRC/manifest/SHA/schema/allowlist/bounds, traversal/backslash/duplicate/symlink/flag/gap/offset/bomb rejection, missing-thumbnail validity, and origin/local-ID behavior;
- release manifest version/tag/commit/package/schema/generator/test-count validation and non-publishing cross-platform beta-readiness workflow structure.

Named Python UI cases cover `action_flushes_pending_settings`, immediate manual seed/filter use, destroy cancellation, and server-state non-resend. Package cases use the exact acceptance names for reproducibility, checksum, version, machine paths, root layout, and normalized metadata.

## License-safe fixture catalog

`tests/lua/fixtures/content.lua` contains only small original values and field shapes needed for regression. It includes no complete JBeam, brand, artwork, screenshot, or third-party asset.

| Fixture | Why it exists |
| --- | --- |
| official vehicle + official config | exact official source baseline |
| official vehicle + mod config pack | config source overrides official parent |
| external mounted config ownership | config becomes mod only from confirmed path ownership |
| full mod vehicle + config | model/config mod identity |
| nested part-pack accessory | compatible third-party candidate behavior |
| wheel → tire hierarchy | descendant deferral after wheel/ancestor changes |
| user-saved config | `Custom`/player source evidence |
| arbitrary source label | unknown remains unknown |
| missing Source + `modID` | mod identity without display label |
| `slots2` required/core metadata | empty-selection protection |
| legacy `slots` table | older metadata shape retained by 0.38 conversion |
| engine/intake nested replacement | stale-tree regression |
| electric energy/motor metadata | no combustion-only assumption |
| three differential-like branches | no one/two-differential assumption |
| malformed config record | safe normalization rejection |
| malformed tuning variable | nonnumeric metadata rejection |
| one and three paint layers | dynamic paint-count handling |
| normalized paint with extra field | requested-field/tolerant read-back behavior |
| combustion/electric/differential part sections | evidence graph and dynamic profiles |
| explicit synthetic tuning group | future proven-group architecture without claiming current content evidence |

The conceptual field shapes came from installed `core/vehicles.lua`, `core/vehicle/partmgmt.lua`, `jbeam/io.lua`, `jbeam/slotSystem.lua`, and `jbeam/variables.lua` inspection.

## Source-observed write hooks

| Write | Installed-source finding | Live observation |
| --- | --- | --- |
| `replaceVehicle` | object return, then `onVehicleSpawned` | Pending |
| `setPartsTreeConfig(..., true)` | normal `nil`; `vehicle:respawn` → `onVehicleSpawned` | Pending |
| `setConfigVars(..., true)` | normal `nil`; `vehicle:respawn` → `onVehicleSpawned` | Pending |
| `setConfigPaints(..., false)` | normal `nil`; live update, no respawn hook; tolerant bounded read-back | Pending |

Automated mocks prove routing/verification behavior. The table does not claim that hook timing was observed in a world.

## Representative content matrix

No third-party content was installed or redistributed. Fixture coverage is automated; every live result is Pending.

| Content | Required live evidence | Status |
| --- | --- | --- |
| Official simple vehicle | Random Config, Chaos 0/100, no fatal log | Pending |
| Official deep tree | parent deferral, bounded passes, Undo | Pending |
| Official multiple paints | dynamic paint count/read-back | Pending |
| Official broad tuning | range/step and tuning reload confirmation | Pending |
| Config pack on official model | Mods-only includes; Official-only excludes; base model not blocked | Pending |
| Full mod vehicle | discovery, source class, Random Config, Full Random, attribution | Pending |
| Part pack | nested candidate after reload; candidate blacklist without config block | Pending |
| Wheel pack | wheel compatibility; tire deferred; no stale tire candidate | Pending |
| User config | `user`, Everything inclusion, filter behavior | Pending |
| Unknown metadata | `unknown`, diagnostics count, no arbitrary mod promotion | Pending |
| Automation vehicle | opt-in discovery; all actions; safety profile; optional-stage limits; Undo/rollback | Pending |
| Trailer | opt-in discovery; no engine requirement; Full Random; Undo/rollback | Pending |
| Prop | opt-in discovery; no road-system requirement; honest control limit | Pending |
| Electric/direct-drive/dual-motor | energy profile; no fuel/gearbox assumption; protected group | Pending |
| Multi-differential/differential-free | required role preservation without exactly-one assumption | Pending |

For a real content result, record:

```text
content name and version
license/source URL
BeamNG full version
randomizer commit/version
operation and settings
seed
result
beamng.log status
screenshot reference, if captured
```

## Required interactive smoke procedure

Use the exact final ZIP without extracting it and record the result of every row.

| # | Case | Status |
| ---: | --- | --- |
| 1 | clean BeamNG 0.38 profile | Pending |
| 2 | final ZIP appears in Mod Manager and enables | Pending |
| 3 | enter Freeroam and add UI App | Pending |
| 4 | layout, minimum size, resizing, overflow, keyboard focus | Pending |
| 5 | Random Config on official simple vehicle | Pending |
| 6 | Scramble at Chaos 0 | Pending |
| 7 | Scramble at Chaos 100 | Pending |
| 8 | Allow Missing Parts and Protect Critical Parts combinations | Pending |
| 9 | Full Random | Pending |
| 10 | Undo after Scramble and Full Random | Pending |
| 11 | manual vehicle change cancellation | Pending |
| 12 | map change cancellation | Pending |
| 13 | Reindex clears session blacklists | Pending |
| 14 | mod activation/deactivation cancellation and invalidation | Pending |
| 15 | representative config pack | Pending |
| 16 | representative full mod vehicle | Pending |
| 17 | representative part pack | Pending |
| 18 | representative wheel pack | Pending |
| 19 | bounded developer stress and manual cancellation | Pending |
| 20 | immediate click after Chaos change | Pending |
| 21 | immediate click after manual seed change | Pending |
| 22 | immediate click after content filter change | Pending |
| 23 | controlled parts failure and rollback | Pending |
| 24 | exact replace/parts/tuning hooks observed in log | Pending |
| 25 | paint write confirmed without reload hook | Pending |
| 26 | repeated operations release busy lock | Pending |
| 27 | no fatal Lua/JavaScript errors in `beamng.log` | Pending |
| 28 | installed artifact SHA matches recorded final CI artifact | Pending until final CI comparison |
| 29 | Automation vehicle: Random Config, Scramble, Full Random, Undo, rollback | Pending |
| 30 | trailer: opt-in Full Random without engine/tuning/paint assumptions | Pending |
| 31 | prop: opt-in real-slot mutation and honest control status | Pending |
| 32 | electric/direct-drive/dual-motor safety evidence | Pending |
| 33 | center/front/rear multi-differential or multi-axle layout | Pending |
| 34 | external/forum config pack ownership through mounted path | Pending |
| 35 | delayed paint-cache confirmation does not wait for spawn | Pending |
| 36 | successful Random Config exposes explicit Save Vehicle DNA | Pending |
| 37 | successful Scramble and Full Random capture fresh final state, not planned changes | Pending |
| 38 | failed/rolled-back operation exposes no savable DNA | Pending |
| 39 | save, rename, favorite, paginate, delete, and restart persistence | Pending |
| 40 | library survives restart with identical schema and fingerprints | Pending |
| 41 | disposable corrupt primary recovers validated last-known-good copy | Pending |
| 42 | corrupt primary and backup do not prevent normal randomization startup | Pending |
| 43 | Copy DNA JSON and import the same bounded object | Pending |
| 44 | optional fixed-path file export writes only the documented VFS path | Pending |
| 45 | oversized, future-schema, malformed, and fingerprint-mismatched imports show specific errors | Pending |
| 46 | Exact preflight performs no write and lists model/config/slots/tuning/paints/dependencies | Pending |
| 47 | Restore Exact on matching loaded content verifies complete final state | Pending |
| 48 | Exact mismatch/divergence blocks or rolls back and never reports exact | Pending |
| 49 | Compatible preflight shows every omission, clamp, ambiguity, and environment difference | Pending |
| 50 | confirmed Compatible partial applies no random fallback and reports deviations | Pending |
| 51 | parent-first DNA restore reloads before resolving wheel/tire or other descendants | Pending |
| 52 | stale/wrong hook, manual vehicle/map change, and mod-state change cancel DNA restore | Pending |
| 53 | Replay Generation is visibly distinct from Exact and freezes the saved base | Pending |
| 54 | export on PC A and import/Exact preflight on PC B using the exact alpha asset | Pending |
| 55 | Garage/Compatibility minimum size, overflow, keyboard/controller focus, and busy lock | Pending |
| 56 | Restore Exact begins on a different active model and verifies the saved target | Pending |
| 57 | Restore Compatible begins on a different model and reports every target deviation | Pending |
| 58 | partial discovered after target load requires prior authorization or rolls back | Pending |
| 59 | adaptive restore budget handles a legitimately deep tree and stops no-progress/oscillation | Pending |
| 60 | Cancel and Roll Back restores the previous vehicle; Pure Seed Replay remains a separate warned action | Pending |
| 61 | vehicle lock keeps the loaded model during Reroll Unlocked | Pending |
| 62 | configuration lock keeps the loaded base while unlocked stages change | Pending |
| 63 | each evidence category lock preserves its current parts | Pending |
| 64 | slot/part locks resolve after reload and unresolved evidence is visible | Pending |
| 65 | named tuning and paint layer/field locks preserve exact read-back values | Pending |
| 66 | lock profile survives restart and schema-3-to-4 migration | Pending |
| 67 | all-locked Reroll Unlocked is a valid no-op with pending DNA | Pending |
| 68 | locked parent and child slots remain coherent across fresh-tree passes | Pending |
| 69 | Replay Generation visibly distinguishes original and current lock policies | Pending |
| 70 | Restore Snapshot ignores creative locks and restores saved final state | Pending |
| 71 | Reroll Unlocked changes only unlocked model/config/parts/tuning/paint | Pending |
| 72 | unrelated locks do not shift unlocked deterministic substreams | Pending |
| 73 | cancelled/failed reroll rolls back and saves no child | Pending |
| 74 | successful reroll exposes explicit pending child save | Pending |
| 75 | same parent/index/strength repeats mutation choices | Pending |
| 76 | Small/Medium/Wild produce bounded visibly distinct strengths | Pending |
| 77 | saved mutation records parent/root/generation/index/strength/seed lineage | Pending |
| 78 | mutating never edits the saved parent | Pending |
| 79 | repeated child saves receive unique IDs and increasing indices | Pending |
| 80 | depth limit blocks deeper lineage; deleting parent marks surviving children | Pending |
| 81 | favorite, pin, and 0–5 rating survive restart | Pending |
| 82 | tags, notes, and collection edits survive restart and long text wraps | Pending |
| 83 | Garage search/filter/sort/grid/list/pagination and storage meter | Pending |
| 84 | no-capture Garage card renders deterministic fallback | Pending |
| 85 | explicit capture can replace and remove one managed image | Pending |
| 86 | missing managed image falls back without UI failure | Pending |
| 87 | image dimension/byte/count limits reject over-limit captures | Pending |
| 88 | no installed mod thumbnail, texture, or asset is copied/exported | Pending |
| 89 | Compare reports model/config/slots/tuning/paint/dependency/safety/environment/locks/lineage fields | Pending |
| 90 | `.vdna.json` export/copy/import roundtrip with dependency preview | Pending |
| 91 | `.vdna.zip` export/fixed-inbox/import roundtrip without thumbnail | Pending |
| 92 | traversal, backslash, absolute, and unknown ZIP entries are rejected | Pending |
| 93 | duplicate and symlink ZIP entries are rejected | Pending |
| 94 | bomb-shaped size, corrupt CRC, manifest, and SHA mismatch are rejected | Pending |
| 95 | future schema is rejected and missing optional thumbnail is accepted | Pending |
| 96 | import preserves origin ID/importedAt while assigning unique local ID | Pending |
| 97 | five-view UI at minimum size and 100/125/150/200% keyboard focus | Pending |
| 98 | fixed bridge actions, pending-operation disablement, cancel, and rollback message | Pending |
| 99 | Share preview shows dependencies, privacy warning, sizes, and checksum | Pending |
| 100 | exact exported package transfers PC A to PC B and preflights there | Pending |

Interactive cases passed: **0**. Interactive cases pending: **100**.

## 0.5.0-alpha.1 package and release result

Release commit `82da6b69ce794baa5ab8a11aefbcafe06a645d68` has 39 Python methods and 264 named Lua cases green against the shipped Lua 5.1 console path, plus Node syntax, JSON/YAML, static trust-boundary, and package checks. The package was built twice and independently rebuilt by validation with identical bytes.

| Item | Result |
| --- | --- |
| Filename | `soturine_chaos_randomizer_0.5.0-alpha.1.zip` |
| Bytes | `147,578` |
| Entries | `48` |
| SHA-256 | `1b6a0b15e58f07a3fe8d6c480f2145b5a4b18aefc6755a5ac9b7eff3d645e140` |
| Same-environment reproducibility | Passed; byte-identical consecutive and validator rebuilds |
| Manifest inventory | 39 Python methods; 264 Lua cases; 1 JavaScript; 2 JSON; 0 interactive Passed; 100 interactive Pending |

Release commit `82da6b69ce794baa5ab8a11aefbcafe06a645d68` passed branch CI run `30051570087` and tagged package/release run `30051606656`. GitHub published prerelease `v0.5.0-alpha.1`; all three assets were redownloaded to a fresh temporary directory and the ZIP passed `tools/validate_package.py --no-reproducibility-check`. The local package, CI build, GitHub digest metadata, downloaded checksum, downloaded manifest, and downloaded ZIP all agree on SHA-256 `1b6a0b15e58f07a3fe8d6c480f2145b5a4b18aefc6755a5ac9b7eff3d645e140`.

Published prerelease: <https://github.com/Soturine/beamng-soturine-chaos-randomizer/releases/tag/v0.5.0-alpha.1>. Assets verified on 2026-07-23:

- `soturine_chaos_randomizer_0.5.0-alpha.1.zip` - 147,578 bytes, 48 entries;
- `soturine_chaos_randomizer_0.5.0-alpha.1.sha256` - 110 bytes;
- `release-manifest.json` - 627 bytes, manifest commit `82da6b69ce794baa5ab8a11aefbcafe06a645d68`.

The ZIP excludes documentation, so this post-release record does not change package bytes or move the verified tag. This proves packaging and transfer integrity, not live BeamNG behavior. Interactive status remains **0 Passed / 100 Pending**.

## 0.4.0-alpha.2 package and release result

The release tree was built twice consecutively on Windows and the byte count and SHA-256 matched. `tools/validate_package.py` then rebuilt independently for its reproducibility check and validated structure, content, root layout, version, checksum, line endings, icon limits, manifest, and absence of machine paths.

| Item | Result |
| --- | --- |
| Filename | `soturine_chaos_randomizer_0.4.0-alpha.2.zip` |
| Bytes | `118,685` |
| Entries | `43` |
| Windows SHA-256 | `6ed58c5801609558383c6c3bffdcd026dea1bff27fd1ca5347fc43be6e1fc9d8` |
| Same-environment two-build equality | Passed; byte-identical consecutive builds |
| ZIP/checksum/manifest validation | Passed |
| Manifest test inventory | 36 Python methods; 240 Lua cases; 1 JavaScript; 2 JSON; 0 interactive Passed; 60 interactive Pending |

Release commit `cdaf227bb8adfd854a7f5263e5351772e4b42c10` passed branch CI run `30048083012` and tagged package/release run `30048122310`. GitHub published prerelease `v0.4.0-alpha.2`; all three assets were redownloaded to a fresh temporary directory and the ZIP passed `tools/validate_package.py --no-reproducibility-check`. The local, CI, GitHub digest metadata, downloaded checksum, and downloaded ZIP all agree on SHA-256 `6ed58c5801609558383c6c3bffdcd026dea1bff27fd1ca5347fc43be6e1fc9d8`.

Published prerelease: <https://github.com/Soturine/beamng-soturine-chaos-randomizer/releases/tag/v0.4.0-alpha.2>. Assets verified on 2026-07-23:

- `soturine_chaos_randomizer_0.4.0-alpha.2.zip` — 118,685 bytes, 43 entries;
- `soturine_chaos_randomizer_0.4.0-alpha.2.sha256` — 110 bytes;
- `release-manifest.json` — 626 bytes, manifest commit `cdaf227bb8adfd854a7f5263e5351772e4b42c10`.

This proves packaging and transfer integrity, not live BeamNG behavior. Interactive status remains **0 Passed / 60 Pending**.

## Historical 0.4.0-alpha.1 package result

The packaged inputs were built twice on Windows after the code, UI, asset, tests, package, and CI commits. Documentation is excluded from the ZIP, so the final documentation commit does not alter these bytes.

| Item | Result |
| --- | --- |
| Filename | `soturine_chaos_randomizer_0.4.0-alpha.1.zip` |
| Bytes | `112,125` |
| Entries | `42` |
| Windows SHA-256 | `75b0bf00d7e701f70c4d8d2de15e594d67845e599d2de326e87a2c45237cc6f2` |
| Same-environment two-build equality | Passed; byte-identical consecutive builds |
| ZIP/checksum validation | Passed |
| Text line-ending normalization | Passed |
| Final CI/Linux and downloaded-release comparison | Passed; byte-identical ZIP and matching checksum |

Release commit `5327a45ff7d65c25625e2cb977dcbc1c738e38fc` passed branch CI run `30042383380` and tagged package/release run `30042477108`. The Actions ZIP and the redownloaded GitHub Release ZIP were both 112,125 bytes with the SHA-256 above. `tools/validate_package.py` passed against the downloaded ZIP beside its downloaded checksum and manifest; the manifest reports 36 Python methods, 222 Lua cases, one JavaScript file, two JSON files, zero interactive passes, and 55 interactive Pending cases.

Published prerelease: `v0.4.0-alpha.1` at <https://github.com/Soturine/beamng-soturine-chaos-randomizer/releases/tag/v0.4.0-alpha.1>. Assets verified on 2026-07-23:

- `soturine_chaos_randomizer_0.4.0-alpha.1.zip` — 112,125 bytes;
- `soturine_chaos_randomizer_0.4.0-alpha.1.sha256` — 110 bytes;
- `release-manifest.json` — 626 bytes.

This asset verification is not a BeamNG install/gameplay pass. Interactive row 28 remains Pending until the exact asset is installed and checked from a real 0.38 profile.
