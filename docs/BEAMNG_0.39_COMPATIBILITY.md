# BeamNG.drive 0.39 compatibility — v0.7.0

Status: **P0 and P1 automated contracts preserved; P2 native Vue implemented;
live owner validation Pending**.

Live BeamNG 0.39 validation: Pending owner validation

## Declared compatibility

`COMPATIBILITY.json` schema 2 is the source for packaging and documentation:

- mod version `0.7.0`;
- primary target `0.39`;
- minimum version `0.39`;
- native runtime `native-runtime-ui-vue`;
- no packaged Angular fallback;
- no claimed tested build (`testedGameVersions` is empty);
- experimental prerelease stage.

Version 0.6.9 remains the last release for the Angular host and the last to
declare a 0.38.6 minimum. Source inspection of an installed 0.39.2.1 build is
contract evidence, not live mod execution.

## Official and installed evidence

Public sources inspected include official UI/HUD App creation, programming
language/translation guidance, and release information. The public App Creation
page still centers the Angular workflow. Installed 0.39 source supplies the
newer HUD App contract: app discovery recognizes a colocated `app.vue`, and
AppHost selects it ahead of the Angular slot for the same one app record.

Installed native apps and services established the SFC, bridge, event cleanup,
settings locale, component, tooltip, UINav, and responsive-host conventions.
The migration decision and documentation divergence are recorded in
[UI_MIGRATION_0.7.0.md](UI_MIGRATION_0.7.0.md).

Official references:

- <https://documentation.beamng.com/modding/ui/>
- <https://documentation.beamng.com/modding/ui/app_creation/>
- <https://documentation.beamng.com/modding/programming/languages/>
- <https://www.beamng.com/game/news/patch/beamng-drive-v0-38/>

## Preserved P0 contracts

- registry readiness is bounded and retains the last complete index;
- registry keys, exact physical path case, normalized comparison paths, display
  labels, and technical IDs stay separate;
- replacement/spawn uses coherent stable readback and exact cardinality;
- cleanup can remove only transaction-owned objects;
- operation/phase/target/recovery generations reject stale callbacks;
- temporary failures do not quarantine catalog content;
- settings, lineups, and Vehicle DNA use backup/readback/rollback persistence;
- safety uses valid/invalid/unknown decisions rather than promoting uncertainty;
- conflicts remain warnings with explicit recommended action.

## Preserved P1 contracts

- opt-in bounded profiler with p50/p95/p99;
- configurable frame and UI/index budgets;
- low-GC vehicle iteration and owned reusable buffers;
- generation-aware OOBB dimension and registry caches;
- cancellable/restartable incremental indexing;
- full initial state plus bounded dirty diffs;
- aggregate diagnostics and hook/byte counters;
- adaptive polling and AI mode confirmation;
- unchanged deterministic vectors and generator version 6.

## Runtime UI capability

The package has one app manifest and one Vue entry. No Angular runtime file is
present. The bridge has a fixed frontend command schema and a Lua allowlist;
state carries protocol, sequence, domain, and lifecycle generations. Remount
requests state without restarting the backend. Private runtime APIs are not used
for outer-window resizing.

## Pending live evidence

Registration, cache behavior, rendering, physics, input hardware, 80–200%
scaling, HDR, ultrawide, multi-monitor, Garage 500, Race 12, AI/NavGraph,
third-party content, mount/unmount memory, and v0.6.9 performance comparison all
remain Pending in the live report. No stronger compatibility or performance
claim is made from automation alone.
