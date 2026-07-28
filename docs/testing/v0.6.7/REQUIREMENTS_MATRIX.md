# Requirements matrix — v0.6.7

| Area | Implementation evidence | Automated status | Live status |
|---|---|---|---|
| Chaos/Race/Garage isolation | `runtime/domainOperations.lua`, operation contexts | Passed | Pending |
| Callback tokens and orphan reaper | ownership registry and terminal callback invalidation | Passed | Pending |
| Cardinality and rollback | terminal acceptance/removal contract | Passed | Pending |
| Logical/concrete target binding | operation context and target tracker | Passed | Pending |
| Independent Race RNG/slots | `raceManager.lua` derived domains | Passed | Pending |
| Ternary safety | validator, energy and engine-fluid guards | Passed | Pending |
| Quarantine | domain/session configuration quarantine | Passed | Pending |
| Race participation and policy | total/AI semantics and policy inventory | Passed | Pending |
| Formation and Placement | dimension-aware preview/confirm planner | Passed | Pending |
| Responsive UI | per-tab expanded/compact/details sizes | Passed | Pending |
| Packaging and release | deterministic named artifacts and prerelease gate | Passed | Pending |

Automated Passed means source/fixture/package evidence only. It does not replace
the 48-case owner plan.
