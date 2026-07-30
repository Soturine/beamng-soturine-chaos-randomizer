# Requirements matrix — v0.6.8

| P0 | Requirement | Implementation evidence | Automated | Live cases/status |
|---|---|---|---|---|
| P0.1 | Central metadata/runtime version | `COMPATIBILITY.json`, `compatibility.lua`, manifest | Passed | L01–L02 Pending |
| P0.2 | Registry readiness/retry/cache | `registryReadiness.lua`, atomic `contentIndex.build` | Passed | L03–L07 Pending |
| P0.3 | Technical config/model identity | registry keys, families/groups, aliases | Passed | L08–L12 Pending |
| P0.4 | Exact/comparison paths | `pathIdentity.lua`, traversal tests | Passed | L13–L14 Pending |
| P0.5 | Transactional spawn/cardinality | `spawnOutcome.lua`, operation contexts | Passed | L15–L20 Pending |
| P0.6 | Safe spawn denial | low-memory false contract; bounded outcomes | Passed | L21–L23 Pending |
| P0.7 | Instability/removal/recovery | generation-bound tracker/recovery | Passed | L24–L26 Pending |
| P0.8 | Quarantine taxonomy | content/domain transient policy | Passed | L27–L28 Pending |
| P0.9 | Ternary safety | validator, fuel/fluid guards | Passed | L29–L34 Pending |
| P0.10 | Explicit AI lane state | `aiAdapter.lua`, failed-start handling | Passed | L35–L36 Pending |
| P0.11 | Legacy HUD compatibility | Angular host contract, resize/timer observers | Passed | L37–L41 Pending |
| P0.12 | Translation-independent behavior | technical IDs in selection/DNA/Race/locks | Passed | L42–L44 Pending |
| P0.13 | User-data migration | schema 7, backups/readback/rollback/report | Passed | L45–L48 Pending |
| P0.14 | External conflicts | structured warning-only records | Passed | L49–L52 Pending |
| P0.15 | Package/release | deterministic ZIP/SHA/manifest/gates | Passed | L53–L54 Pending |
| Mods | Required/other mod matrix | dynamic discovery and honest degradation | Passed fixtures | L55–L60 Pending |

P1/P2 work is recorded in the roadmap and compatibility dossier; it is not
misrepresented as implemented P0 scope.
