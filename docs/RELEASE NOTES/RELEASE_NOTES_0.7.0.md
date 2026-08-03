# Soturine's Chaos Randomizer 0.7.0

## Native Vue Runtime UI and Architecture Modernization

Version 0.7.0 is an experimental prerelease dedicated to P2.

### Highlights

- real native Runtime UI Vue frontend with 55 focused components;
- nine domain/layout stores and centralized typed command bridge;
- versioned full/diff protocol with stale rejection and gap recovery;
- P1 dirty diffs and UI telemetry preserved;
- tab-specific compact summaries and per-tab Details;
- complete Chaos, Garage/Vehicle DNA, Race Cars/Placement/Drive, Race Policy,
  and Settings surfaces;
- en-US and pt-BR with game-locale default and English fallback;
- scoped UINav, keyboard/controller semantics, accessible dialogs, visible
  focus, reduced motion, and forced-colors behavior;
- Lua UI protocol/router/projection/preference responsibilities extracted from
  lifecycle code.

### Compatibility and upgrade

BeamNG.drive 0.39 is both the primary target and minimum version. The installed
0.39 loader supports a colocated native `app.vue` for the existing HUD App
manifest. No supported single-entry Angular fallback exists for older builds,
so v0.7.0 packages Vue only. Version 0.6.9 remains the last Angular/0.38.6
release.

Remove older mod ZIPs, install only the v0.7.0 release ZIP, and clear the BeamNG
UI cache if the app does not refresh. Existing settings, locks, Vehicle DNA,
lineups, and P1 performance settings are preserved. Settings migrate from
schema 8 to 9; Vehicle DNA schema 1 and generator version 6 do not change.

### Validation

Automated validation: Passed for production Lua, JavaScript/Vue services,
stores, 55-SFC compilation, parity fixtures, i18n, accessibility, responsive
layout, lifecycle cycles, security, deterministic packaging, checksum, and
manifest contracts.

Live BeamNG validation: Failed — Vue module graph could not load

Live BeamNG 0.39 validation: **1 Executed / 0 Passed / 1 Failed / 0 Pending /
81 Blocked**. The HUD failed before mounting with
`404 /ui/modules/apps/soturineChaosRandomizer/stores`.

Consequently, screenshots, game rendering, physics, controller hardware, Garage 500,
Race 12, memory, and v0.6.9 performance comparison were not executed by the
automated release run.

### Next

Fresh post-v0.7.0 audit after BeamNG 0.39.x hotfixes, following the documented
audit plan without assuming whether the result should be v0.7.1 or v0.8.0.
