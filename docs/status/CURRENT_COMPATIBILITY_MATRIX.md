# Current compatibility matrix

Candidate: **0.7.3 experimental prerelease**. Primary target: BeamNG 0.39.4.
Minimum family: 0.39. Live status: **Pending owner validation**.

| Surface | Automated/source evidence | Live status |
| --- | --- | --- |
| Native Vue UI | SFC/module/style gates and mounted lifecycle tests | Pending owner validation |
| ScrSelect/input | official-component adapter and interaction tests | Pending owner validation |
| Chaos identity | generations, callback tokens, cardinality, rollback invariants | Pending owner validation |
| Safety | ternary stable-evidence gate and bounded recovery tests | Pending owner validation |
| Race | exclusive slot ownership/outcomes/progress for 1/4/8/12 | Pending owner validation |
| i18n/locales | internal parity plus packaged en-US/pt-BR/es-ES metadata | Pending owner validation |
| Registry/content | sanitized 0.39.4 identity/subgroup/failure fixtures | Pending owner validation |
| Persistence | settings schema 9, UI preferences 2, Vehicle DNA schema 1 | Pending owner validation |
| Determinism | generator 6 and stable substream vectors | Pending owner validation |
| Package | deterministic ZIP/checksum/manifest and forbidden-content gates | Pending owner validation |

The detailed compatibility rationale is in
[BeamNG 0.39 compatibility](../BEAMNG_0.39_COMPATIBILITY.md).
