# v0.7.4 live test plan

Execute only the ZIP downloaded from the published `v0.7.4` GitHub prerelease on BeamNG 0.39.4. Start every case as **Pending owner validation**. Record the release asset SHA-256 before enabling it.

## Stop conditions

Stop immediately on any P0: an unrelated/player vehicle is deleted or mutated; player focus is not restored immediately; an accepted Race slot is deleted by a later slot; physical cardinality leaks; lineup storage is corrupted; or preview creates, removes, focuses, moves, or changes physics on a vehicle.

## Smoke gate A — UI (8)

- UI-A01: mount/remount, all four tabs, 320/360/400/440/520/560/640/720 app widths.
- UI-A02: Garage Grid/List at every required width, long translated names and technical disclosure.
- UI-A03: compact lock summary and full drawer; mouse, keyboard, UINav Back/Escape, focus and scroll.
- UI-A04: known parts, deep leaf/ancestor conflicts, and authored mod-brand labels.
- UI-A05: EN/PT/ES normal flow contains no raw phase/policy/reason code or backend English sentence.
- UI-A06: every SmartSelect opens, flips/stays within AppHost bounds, scrolls selected/disabled options, and closes with Back/Escape.
- UI-A07: compact content and internal geometry on every tab over 50 compact/expand cycles.
- UI-A08: idle footer absent; transient scoped status expires without hiding active failure/progress.

## Smoke gate B — Random Car (4)

- RANDOM-B01: five sequential verified replacements with no false cardinality failure.
- RANDOM-B02: successful replacement retains `SUCCESS` or `SUCCESS_WITH_WARNING` after late diagnostics.
- RANDOM-B03: spawn/remove an unrelated vehicle during settling; preserve it and classify it as external.
- RANDOM-B04: refused spawn/cancel/timeout preserves the source and removes only owned temporaries.

## Smoke gate C — Scramble (4)

- SCRAMBLE-C01: five sequential runs retain the same concrete vehicle ID and perform zero spawn/replace.
- SCRAMBLE-C02: delayed/transient part trees settle to a bounded terminal result without premature rollback.
- SCRAMBLE-C03: unrelated world add/remove is diagnostic and never cleaned by Scramble.
- SCRAMBLE-C04: cancel, instability and unsupported mod telemetry remain ownership-safe and outcome-coherent.

## Smoke gate D — Full Random (6)

- FULL-D01: official vehicle, maximum chaos; record integrity, drivability and policy decisions separately.
- FULL-D02: mod vehicle with unknown/not-applicable fluid probes is not rejected as confirmed unsafe.
- FULL-D03: record parts reload, readback, repair reload, phase and longest-step metrics.
- FULL-D04: recovery/rollback keeps focus and identity explicit and does not create a clone leak.
- FULL-D05: a structurally valid but non-drivable chaotic result can be accepted when policy permits.
- FULL-D06: strict policy rejection rolls back only the operation-owned target and reaches a stable terminal outcome.

## Smoke gate E — Race with player (9)

Configure four total vehicles: player plus three opponents.

- RACE-E01: pre-generation summary shows four total and three opponents; during/after summaries stay semantic.
- RACE-E02: player remains `P`; each background focus steal is restored immediately.
- RACE-E03: `A` survives creation of `B`; `A` and `B` survive creation of `C`.
- RACE-E04: fail slot B; A remains, C continues, and no cross-slot cleanup occurs.
- RACE-E05: failed/cancelled/skipped slot DNA is nil; ready DNA saves and reloads as a partial lineup.
- RACE-E06: strict and permissive chaos-acceptance policies produce the documented ready/warning/reject states.
- RACE-E07: P/A/B/C staging transforms and footprints are pairwise distinct.
- RACE-E08: configured/ready/failed/accepted/world counts match physical vehicles after each slot.
- RACE-E09: final placement moves only ready/accepted exact IDs and managed AI never targets P.

## Smoke gate F — Spectator Race (4)

- RACE-F01: four opponents are planned and generated; player is outside all managed ownership.
- RACE-F02: player is never used as staging, mutation target, fallback or AI member.
- RACE-F03: one slot failure remains local and the other accepted competitors survive.
- RACE-F04: cancel/map change/unload cleans only owned temporaries and preview overlays.

## Preview matrix (4)

- PREVIEW-P01: generation preview appears before any opponent spawn; world vehicle IDs and focus/physics remain unchanged.
- PREVIEW-P02: final-grid preview is visually and semantically distinct and does not teleport vehicles.
- PREVIEW-P03: origin, camera/player/road/destination heading, formation, spacing, margin and custom point update live.
- PREVIEW-P04: planned/generating/ready/failed states, actual/fallback footprints and cleanup update without vehicle IDs in telemetry.

## Compatibility/performance extension (9)

- COMPAT-X01/X02/X03: en-US, pt-BR and es-ES, including actual runtime locale IDs and fallback.
- COMPAT-X04: default/D3D11 renderer.
- COMPAT-X05: D3D12 renderer; record GPU/VRAM and keep Intel OOM classification separate.
- COMPAT-X06: Vulkan renderer.
- COMPAT-X07: UI scale, alignment, safe-zone and controller/UINav matrix.
- COMPAT-X08: comparable idle/Chaos/4-car Race FPS, 1% low, CEF memory and phase timing.
- COMPAT-X09: restart round-trip for settings, compact mode, Garage DNA, partial lineup and preview preferences.

Total live cases: **48**. Missing hardware or a non-applicable renderer must be recorded case-by-case as `Not applicable`, never silently passed.
