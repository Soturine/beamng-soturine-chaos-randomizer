# v0.7.3 live test plan

Test only the downloaded `v0.7.3` GitHub release ZIP on a clean BeamNG 0.39.4
profile. Record the release SHA-256 before enabling it. All cases start as
**Pending owner validation**.

## Environment and artifact identity (6)

- LIVE-INSTALL-01: checksum, filename, size, tag commit, manifest commit match.
- LIVE-INSTALL-02: clean install with one Randomizer ZIP and no source archive.
- LIVE-INSTALL-03: upgrade from the previous saved layout/preferences/data.
- LIVE-INSTALL-04: ZIP `VERSION`, `LICENSE`, `NOTICE`, and locale roots load.
- LIVE-INSTALL-05: disable/re-enable, UI reload, level change, and app re-add.
- LIVE-INSTALL-06: unload during active work terminates and cleans owned state.

## Languages (4)

- LIVE-LANG-01: `en-US` and the exact locale ID exposed by the runtime.
- LIVE-LANG-02: `pt-BR` and any equivalent `pt_*` runtime form.
- LIVE-LANG-03: `es-ES`.
- LIVE-LANG-04: one actually exposed Latin-American `es-*` variant.

Verify app picker metadata, internal strings, fallback, plural/number formatting,
no raw key in normal UI, no English backend sentence, and language-independent
seed/output identity.

## Renderers and memory (5)

- LIVE-RENDER-01: default launcher renderer.
- LIVE-RENDER-02: forced D3D12.
- LIVE-RENDER-03: D3D11/fallback.
- LIVE-RENDER-04: Vulkan.
- LIVE-RENDER-05: Intel+D3D12 when hardware is available; classify VRAM/OOM
  separately while preserving the temporary-ownership limit.

Record GPU/vendor, VRAM, map, traffic/world/owned counts, peak temporary count,
operation, phase, FPS, 1% low, and diagnostic classification.

## Runtime UI (20)

- LIVE-UI-01 mount; LIVE-UI-02 remount; LIVE-UI-03 development hot reload.
- LIVE-UI-04 safe area; LIVE-UI-05 UI scale; LIVE-UI-06 mouse.
- LIVE-UI-07 keyboard; LIVE-UI-08 controller/UINav; LIVE-UI-09 Back.
- LIVE-UI-10 unfocused HUD does not capture steering/gamepad.
- LIVE-UI-11 focused HUD receives navigation correctly.
- LIVE-UI-12 every ScrSelect opens/changes with every input method.
- LIVE-UI-13 selected option scrolls into view; empty/disabled states are safe.
- LIVE-UI-14 alignment; LIVE-UI-15 safe-zone apply.
- LIVE-UI-16 saved 0.39.2.1 layout migrates through AppHost behavior.
- LIVE-UI-17 compact content/geometry on every tab and locale.
- LIVE-UI-18 50 compact/expand cycles with tab/Details changes.
- LIVE-UI-19 injected/natural view error preserves shell and retry is single.
- LIVE-UI-20 status expiry/scope/dedup and monotonic translated progress.

## Gameplay and lifecycle (13)

- LIVE-GAME-01 Random Car; LIVE-GAME-02 Scramble; LIVE-GAME-03 Full Random.
- LIVE-GAME-04 Race with player; LIVE-GAME-05 spectator Race.
- LIVE-GAME-06 cancellation in every phase; LIVE-GAME-07 phase timeout.
- LIVE-GAME-08 refused spawn preserves source and leaves no clone.
- LIVE-GAME-09 instability stops writes and targets only the affected vehicle.
- LIVE-GAME-10 manual vehicle removal; LIVE-GAME-11 delayed/duplicate callbacks.
- LIVE-GAME-12 sequential Full Random → Scramble keeps new concrete identity.
- LIVE-GAME-13 transient/partial reads produce bounded UNKNOWN/partial behavior.

For Race, repeat 1, 4, 8, and 12 total-vehicle configurations. Verify unique
slot/seed/physical ownership, partial and all-failed outcomes, player exclusion
from managed AI, placement, `driveInLane`, pause/resume/stop, and slot-local
cleanup.

## Content and configurations (8)

- LIVE-CONTENT-01 official vehicle; LIVE-CONTENT-02 subgroup vehicle.
- LIVE-CONTENT-03 simple mod; LIVE-CONTENT-04 incomplete-slot mod.
- LIVE-CONTENT-05 custom configuration where label differs from `.pc`.
- LIVE-CONTENT-06 large parts tree; LIVE-CONTENT-07 incomplete metadata.
- LIVE-CONTENT-08 two models with the same display label but distinct keys.

## Performance and persistence (5)

- LIVE-PERF-01 idle HUD; LIVE-PERF-02 active Chaos; LIVE-PERF-03 12-car Race.
- LIVE-PERF-04 100 mount/remount plus UI reload cycles.
- LIVE-PERF-05 restart round-trip for settings, Garage, lineups, and layout.

Record wall-clock phase timing, time to first progress, state bytes/rate,
callbacks, invalidations, CEF memory, FPS, and 1% low. Do not report an
improvement without a comparable baseline.

Total live cases: **61**. Stop on any P0 ownership, cleanup, crash, or
non-terminal deadline violation and preserve evidence before changing state.
