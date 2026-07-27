# Safety precedence — v0.6.6

This table defines settings precedence. `P` is Protect critical parts, `M` is
Allow missing parts, and `K` is Keep partial result.

| P | M | K | Optional/cosmetic absence | Proven functional/core absence | Drivable candidate | Trailer/prop/shell |
| --- | --- | --- | --- | --- | --- | --- |
| Off | Off | Off | Not intentionally selected; unexpected loss is warning/failure by evidence | Repair, then rollback if unrecoverable | Classification still applies; no safety claim without evidence | No invented engine requirement |
| Off | Off | On | Same selection policy; stable incomplete coverage may be partial | Repair required; K cannot authorize unsafe core | Partial only when functional evidence remains valid | Explicit policy decides eligibility |
| Off | On | Off | May be selected and accepted | Cannot be excused as optional when core/required evidence proves it | Unknown evidence is warning, not proof | Explicit trailer/prop/shell remains non-drivable |
| Off | On | On | May be selected and retained | Repair required; K never overrides proven unsafe state | Stable non-critical gaps may be partial | Explicit policy decides eligibility |
| On | Off | Off | Kept unless another valid candidate is selected | Current/default structurally proven path is protected; repair precedes rollback | Functional chain protection has priority | Only applicable roles are protected |
| On | Off | On | Same as above; ordinary incomplete coverage may be partial | Same strict protection; K cannot authorize loss | Valid repaired result is `success_with_critical_repair` | No combustion-fluid check for EV/trailer/prop/shell |
| On | On | Off | May be empty | **Protection wins:** core/required/evidence-backed functional path cannot be emptied | Visual chaos is allowed without silently deleting the functional chain | Explicit non-drivable classes remain honest |
| On | On | On | May be empty and stable result may be partial | **Protection still wins:** surgical repair, then full rollback only if repair fails | Accepted partial becomes the next repair baseline | Race remains drivable-only unless showcase policy explicitly opts in |

Classification is evaluated before fluid requirements:

- `drivable_combustion`: fuel and engine-oil evidence apply;
- `drivable_electric`: electric energy applies, engine oil does not;
- `drivable_hybrid`: electric/fuel and combustion engine oil apply;
- `trailer`, `prop`, `intentional_non_drivable_shell`: no conventional engine-oil requirement;
- `unknown`: no drivability claim is invented; metadata uncertainty is visible.

Names are fallback hints. Fatal criticality requires a documented root/core/
required path or structural evidence from loaded part/powertrain/energy data.
