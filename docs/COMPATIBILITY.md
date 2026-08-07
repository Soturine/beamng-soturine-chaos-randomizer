# Compatibility

Compatibility is evidence-based. `COMPATIBILITY.json` is the machine-readable
source for the current mod version, BeamNG target/minimum, UI runtime, release
stage, license, and live status. The detailed 0.39 analysis is in
[BeamNG 0.39 compatibility](BEAMNG_0.39_COMPATIBILITY.md).

The current identity is native Runtime UI Vue, UI protocol 2, generator 6,
Vehicle DNA schema 1, settings schema 9, and UI preferences schema 2. These
schema/generator numbers are independent from the release version and were not
incremented without a data-format reason.

## Content discovery

The mod uses the mounted BeamNG registry and loaded vehicle data; it ships no
vehicle catalog. Registry key, display name, and configuration filename are
separate. Official vehicles, config/part/wheel packs, user configurations,
Automation exports, trailers, props, families, and subgroups are classified from
current metadata and capabilities. Source classifications are `official`,
`mod`, `user`, and `unknown`; unknown is never promoted by label heuristics.

## Capability states

| State | Meaning |
| --- | --- |
| `available` | Supported API and coherent evidence are present. |
| `degraded` | A bounded alternative exists with reduced behavior. |
| `temporarily_unreadable` | Current data is not coherent; bounded retry is allowed. |
| `unsupported` | No supported path is exposed. |
| `failed` | A supported path returned or threw a confirmed failure. |

Optional malformed metadata produces a localized warning/skip. Proven loss of a
required structural role remains fatal. Transient reads remain UNKNOWN until
stable evidence confirms valid or invalid.

## Persistence

- Settings schema 9 migrates supported settings transactionally with backup,
  readback, rollback, and a migration report.
- Vehicle DNA schema 1 preserves generator 4/5/6 identity; old seeds are not
  reinterpreted as generator 6.
- `raceManager.lua` is canonical while historical Lineup storage/import methods
  remain data-compatible through a facade.
- Release tags/assets are immutable; historical reports retain their original
  versions and evidence.

Real compatibility requires the downloaded artifact SHA, BeamNG full build,
content/version, renderer, environment, settings, seed, terminal result,
diagnostics, and logs. The [current matrix](status/CURRENT_COMPATIBILITY_MATRIX.md)
remains **Pending owner validation** until the owner supplies that evidence.
