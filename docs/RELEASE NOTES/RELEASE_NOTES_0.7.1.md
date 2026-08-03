# Soturine's Chaos Randomizer 0.7.1

Release type: **Experimental prerelease**.

## Fixed

- Fixed a Runtime UI 404 caused by directory-style imports such as `./stores`.
  v0.7.0 failed with `404 /ui/modules/apps/soturineChaosRandomizer/stores`.
- Replaced directory-style and extensionless project imports with explicit,
  case-correct `.vue`, `.js`, `.json`, and `.scss` paths.

## Validation

- Automated validation: Passed
- Live BeamNG validation: Pending owner validation
- Live totals: 0 Executed / 0 Passed / 0 Failed / 97 Pending / 0 Blocked
- Static source module graph: **Passed**
- Extracted ZIP module graph: **Passed**
- SFC compilation: **Passed**
- Automated regressions: **Passed**
- Live BeamNG mount: **Pending owner validation**
- Added a case-sensitive module graph validator for source and extracted ZIPs.
- Validated 193 import references with zero directory imports, missing modules,
  case mismatches, initialization cycles, or named-export errors.
- Passed 50 Python methods, 398 Lua cases, 9,217 Lua assertions, 664 Lua
  requirement mappings, 779 JavaScript/Vue assertions, and 55 SFC compilations.

Actual mounted Vue component tests are not implemented. Live BeamNG 0.39
AppHost validation remains **Pending owner validation** with 97 pending cases.

## Known v0.7.0 history

The first v0.7.0 live case failed before the HUD mounted. Its final report is
1 Executed / 0 Passed / 1 Failed / 0 Pending / 81 Blocked. v0.7.0 remains
published unchanged as historical evidence.

## Upgrade

Remove the v0.7.0 ZIP, install only
`soturine_chaos_randomizer_0.7.1.zip`, clear the BeamNG UI cache if the old
module URL persists, open HUD Apps, confirm one Randomizer entry, and execute
Gate A.
