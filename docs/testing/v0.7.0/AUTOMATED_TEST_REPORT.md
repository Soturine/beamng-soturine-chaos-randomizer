# v0.7.0 automated test report

Status: **Passed**. The final pre-release gate records 45 Python test methods,
398 unique Lua cases, 9,217 Lua assertions, 664 Lua requirement mappings, 779
JavaScript/Vue assertions, and compilation of 55 Vue SFC files. The release
manifest derives and records the same counts.

Validated layers:

- Python static, architecture, JavaScript-runner, and package tests;
- production Lua 5.1 cases plus release requirement mappings;
- JavaScript assertions over the actual command bridge, state protocol, domain
  store, i18n, UI layout, and lifecycle services;
- compilation of all 55 Vue SFC files with pinned Vue 3.5 compiler tooling;
- 23 full/diff feature-parity fixtures;
- 100 layout cycles and 100 lifecycle registry cycles;
- en-US/pt-BR key parity, fallback, interpolation, plurals, long strings, and
  translation-independent technical IDs;
- roles, labels, UINav, focus, reduced motion, forced colors, responsive tokens,
  and cleanup contracts;
- unchanged P0/P1 Lua suites and deterministic seed/Race vectors;
- deterministic ZIP, checksum, manifest, installable root, and forbidden-file
  checks.

Real screenshots are not available in this headless repository gate. DOM/static
component checks are not described as screenshot tests. Visual regression
cases remain Pending in the live plan.

Live BeamNG 0.39 validation later failed before mount with the `/stores` 404;
1 case failed and 81 were blocked. Automated success did not prove AppHost loading.
