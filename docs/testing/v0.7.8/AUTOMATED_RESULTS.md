# v0.7.8 automated results

Status: **Passed on the release-candidate freeze**.

| Gate | Result |
| --- | ---: |
| Vue SFC files compiled | 58 |
| Vue graph files / reachable files / imports | 89 / 84 / 247 |
| Runtime style graph critical failures | 0 |
| JavaScript contract checks | 1,190 |
| Mounted Runtime UI cases | 33 passed |
| Python test methods | 66 passed |
| Lua unique/executed cases | 436 / 436 passed |
| Lua requirement mappings | 822 |
| Lua assertions | 14,139 |
| Live cases executed | 0 |

The full local command sequence was `npm ci --ignore-scripts`, SFC/module/style
validation, `npm run test:ui`, Python unittest discovery, deterministic package
generation, package validation and prerelease gate validation. Package identity
is recorded in the generated manifest and is verified again after publication.

Automated evidence is not live BeamNG evidence. All seven cases in
`LIVE_RESULTS.md` remain Pending owner validation.
