# Current validation

Current published source: **0.7.1 Experimental prerelease** on `main`.

Automated v0.7.1 status: **Passed** for its source/module-graph scope. That run
recorded 50 Python methods, 398 unique Lua cases, 9,217 Lua assertions, 664 Lua
requirement mappings, 779 JavaScript/Vue assertions, 55 SFC compilations, and
193 module references with zero graph errors.

Live history supersedes the initial pending reports:

- v0.6.9: visual reference passed; Full Random, Race generation, and stability
  failed. Random Car and Scramble were not executed separately.
- v0.7.0: 1 Executed / 0 Passed / 1 Failed / 0 Pending / 81 Blocked; failed on
  `404 /ui/modules/apps/soturineChaosRandomizer/stores` before mount.
- v0.7.1: 9 Executed / 3 Passed / 6 Failed / 0 Pending / 88 Blocked. Vue mount,
  module graph, and automatic pt-BR passed; CSS/runtime styling, Settings
  usability, UI latency, Full Random, Race Generate Cars, and stability failed.

v0.7.2 is the rescue work in progress. No v0.7.2 live result exists yet, and
automated evidence must not be presented as BeamNG AppHost/gameplay evidence.
