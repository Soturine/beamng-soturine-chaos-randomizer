# Current compatibility matrix

Published: **0.7.12 experimental prerelease**. Primary target: BeamNG 0.40.4
(source-checked against 0.40.4.0 build 296339). Minimum family: 0.39. Live
status: **Pending owner validation** - no 0.40 session has run the mod yet.

| Surface | Automated/source evidence | Live status |
| --- | --- | --- |
| Native Vue UI | SFC/module/style gates, named host imports checked against the 0.40.4 export snapshot, mounted lifecycle tests | Pending owner validation |
| ScrSelect/input | official-component adapter and interaction tests; `BngSmartSelect` present in 0.40.4 | Pending owner validation |
| Chaos identity | generations, callback tokens, cardinality, rollback invariants; 0.40 config-target redirect guarded | Pending owner validation |
| Split-screen / occupants | every `core_multiseat` player and seat presence protected; delete, teleport and AI start refuse occupied cars; 7 killed mutants | Pending owner validation |
| Safety | ternary stable-evidence gate and bounded recovery tests | Pending owner validation |
| Events/Race | Preview frame loop with engine-like bindings, pool relaxation and recovery, discard authorization, canonical readiness, batch reposition and empty-map formation geometry | Pending owner validation |
| AI | command parity, Vehicle Lua `ai.mode` probe executed as Lua text, Recorded route recorder and playback | Pending owner validation |
| Multiplayer readiness | owner/network identity and fail-closed authority; no BeamMP integration claim | Pending owner validation |
| i18n/locales | parity-complete en-US/pt-BR/es-ES; other languages fall back to English | Pending owner validation |
| Registry/content | sanitized 0.39.4 identity/subgroup/failure fixtures; 0.40 `slots2` normalisation verified in game source | Pending owner validation |
| Persistence | settings schema 9, UI preferences 2, Vehicle DNA schema 1 (unchanged) | Pending owner validation |
| Determinism | generator 6 and stable substream vectors; selector merge keeps the single draw | Pending owner validation |
| Package | deterministic ZIP/checksum/manifest; forbidden-content and extracted graph gates | Not applicable (publication evidence) |
| PS5 | mods are not supported on PS5 | Not applicable |

The API-by-API rationale is in
[BeamNG 0.40 compatibility](../BEAMNG_0.40_COMPATIBILITY.md); the 0.39
rationale stays in [BeamNG 0.39 compatibility](../BEAMNG_0.39_COMPATIBILITY.md).
