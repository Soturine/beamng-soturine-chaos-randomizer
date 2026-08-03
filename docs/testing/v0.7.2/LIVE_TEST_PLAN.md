# v0.7.2 live test plan

Target: the downloaded v0.7.2 release ZIP in BeamNG 0.39.2.1 on a clean profile.
Validation owner: repository owner. Record logs, screenshots or video, exact
artifact SHA-256, and the measurements named by each gate.

## Case inventory (138 total)

| Gate | IDs | Cases | Required observation |
| --- | --- | ---: | --- |
| A — mount/CSS | A01-A10 | 10 | selector uniqueness, no 404, mount, CSS, small fox, styled controls, Settings scroll, Race Policy, compact/expand |
| B — UI latency | B01-B08 | 8 | four tabs, Details, compact, remove/re-add, no progressive delay; record local p95 |
| C1 — Random Car | RC01-RC20 | 20 | one accepted replacement, one final player vehicle, zero final temporaries |
| C2 — Scramble | SC01-SC20 | 20 | same concrete ID, no spawn/replace, constant world count |
| C3 — Full Random | FR01-FR10 | 10 | one accepted target, one final player vehicle, zero final temporaries |
| D — Race | D01-D04 | 4 | 1/4/8/12 independent slots, no player staging, partial preservation, owned cleanup |
| E — i18n | E01-E07 | 7 | pt-BR, es-ES, es-MX, en-US, fallback, manual override, return auto |
| F — stability | F01-F59 | 59 | 20 Random Car, 20 Scramble, 10 Full Random, 5 Race generations, cancel, retry, cleanup, remove/re-add |

For every Chaos action record `worldVehicleCountBefore`, `worldVehiclePeak`,
`worldVehicleCountAfter`, `sourceVehicleId`, `acceptedVehicleId`,
`temporaryPeak`, `staleCallbacks`, and `operationDuration`. Stability runs also
record FPS, 1% low, frame time, Lua p95, UI latency p95, and visible freezes.

Pass only observed behavior. A blocked case is executed but prevented by an
external prerequisite; an unexecuted case remains Pending.

