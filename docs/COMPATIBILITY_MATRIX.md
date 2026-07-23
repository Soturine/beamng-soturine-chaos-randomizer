# Compatibility Matrix

This matrix separates installed-source inspection, license-safe automated evidence, mocked pipeline evidence, and real interactive evidence. `Automated` never means gameplay-validated.

Target: Soturine's Chaos Randomizer `0.4.0-alpha.2`; BeamNG.drive `0.38.6.0.19963`; Steam build `23007233`.

| Content class | Registry/source evidence | Safety behavior | Automated evidence | Interactive evidence |
| --- | --- | --- | --- | --- |
| Official road vehicle | exact official source and model type | standard-road profile; baseline-proven roles | registry, selection, Full Random pipeline, safety fixtures | Pending |
| Official deep tree | loaded `partsTree` and per-slot candidates | parent defers descendants; fresh graph each pass | nested/deep-tree and stale-candidate regressions | Pending |
| External config pack on official model | explicit identity or confirmed `pcFilename` ownership | selected model profile | path-ownership/filter/config-verification regressions | Pending |
| Full mod vehicle | model evidence plus independent config ownership | evidence-derived profile; unknown stays conservative | full-mod registry fixture and mocked pipeline | Pending |
| Part pack | exact selected candidate metadata | role-equivalent candidates only when protection applies | per-candidate source, suspect decay/isolation, rollback | Pending |
| Wheel/tire pack | selected wheel/tire candidate source | no four-wheel assumption; ancestor deferral | wheel/tire hierarchy, source, two-wheel regressions | Pending |
| User config | explicit Custom/user/player evidence | signature fallback when filename is unusual | user source/path/signature regressions | Pending |
| Unknown metadata | no promotion without evidence | unknown profile returns uncertain unless unsafe structural evidence exists | source and safety fallback regressions | Pending |
| Automation vehicle | exact Automation type; opt-in | Automation profile; missing optional stages can warn/skip | type/filter/profile and optional-capability fixtures | Pending |
| Trailer | exact Trailer type; opt-in | no propulsion/engine requirement | profile, filters, mutation, Full Random optional-stage pipeline | Pending |
| Prop | exact Prop type; opt-in | road systems not applicable | profile, filters, real-slot mutation, control-limit result | Pending |
| Electric / dual motor | loaded motor/storage sections | electric energy/propulsion preserved; no fuel/gearbox assumption | electric, direct-drive, dual-motor regressions | Pending |
| Hybrid-like | both electric and combustion loaded evidence | preserves both baseline-proven paths | graph profile/invariant fixtures | Pending |
| Multi-differential / driven axles | loaded powertrain sections | preserves required role counts; no exactly-one assumption | front/rear/center/multi-axle/differential-free regressions | Pending |
| Multi-vehicle config | registry exposure only | no special validated policy | none beyond generic registry normalization | Unknown |

## Vehicle DNA evidence

| Case | Automated evidence | Interactive evidence |
| --- | --- | --- |
| Fresh capture after Random Config/Scramble/Full Random | final capture/scan/normalize/schema/fingerprint and failed-operation exclusion | Pending |
| Exact preflight/restore | no-write registry preflight, saved-base load, target inspection, adaptive parent-first passes, strict read-back, rollback harness | Pending |
| Compatible/partial restore | cross-model target inspection, explicit partial authorization, no random fallback, clamp/omission/remap records, applied-subset read-back | Pending |
| Replay Generation / Pure Seed Replay | frozen saved-base generation and separate base-reselecting advanced replay harnesses | Pending |
| Restart persistence and last-known-good recovery | bounded store/schema/fingerprint/backup mocks | Pending |
| JSON import/export | capped JSON-data bridge, schema/fingerprint rejection, fixed export path | Pending |
| Cross-PC transfer | schema/fingerprint and environment report logic | Pending |

## API evidence

| Operation | Installed source | Automated orchestration | Interactive observation |
| --- | --- | --- | --- |
| Replace | object return plus spawned hook; returned ID required | exact switch correlation, wrong-switch cancellation, rollback/Undo target tests | Pending |
| Parts | normal `nil`, respawn, spawned hook | phase read-back, timeout attribution, suspects, safety rollback | Pending |
| Tuning | normal `nil`, respawn, spawned hook | phase read-back, optional skip, rollback | Pending |
| Paint | normal `nil`, live update, no spawn | normalized immediate/deferred read-back and rollback | Pending |

## Evidence record template

For each real row, record content name/version, source/download category and license, BeamNG full version, randomizer commit/version, operation, settings, seed, result, safety profile/status, log status, and screenshot reference when available. Do not redistribute third-party content.
