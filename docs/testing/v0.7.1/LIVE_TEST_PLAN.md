# v0.7.1 live BeamNG test plan

Status: **Pending owner validation**. Execute against the exact downloaded
v0.7.1 release ZIP with no older copy of the mod active.

## Gate A — graph loading and AppHost mount (A01–A08)

| ID | Check |
|---|---|
| A01 | App appears exactly once in the HUD App selector |
| A02 | App is added without a 404 |
| A03 | `app.vue` mounts |
| A04 | No module error appears in the console |
| A05 | Full state arrives from Lua |
| A06 | Tabs appear |
| A07 | Compact/expand works |
| A08 | Removing and adding again does not duplicate subscriptions |

## Gate B — hotfix smoke and lifecycle (B01–B08)

| ID | Check |
|---|---|
| B01 | Random Car |
| B02 | Scramble |
| B03 | Full Random |
| B04 | Garage opens |
| B05 | Race opens |
| B06 | Settings opens |
| B07 | Brazilian Portuguese loads |
| B08 | English loads |

## Gate C — inherited regression plan

Execute the 81 cases left blocked by the v0.7.0 graph failure, using the
[v0.7.0 plan](../v0.7.0/LIVE_TEST_PLAN.md) as the case definitions and omitting
the already-attempted initial load case.

Total: **97 cases** (8 Gate A + 8 Gate B + 81 Gate C).
