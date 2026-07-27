# Race

Race generates 2–16 competitors sequentially through the central Full Random pipeline. Each competitor receives independent deterministic substreams, target generations, bounded retries, acceptance policy, checkpointed status, and a terminal result.

`raceManager.lua` is canonical. Historical Lineup JSON/storage keys and public methods remain compatible through `compat/legacyLineupFacade.lua`.

See the detailed [Race guide](../RACE.md), [Placement](PLACEMENT.md), and [AI Director](AI_DIRECTOR.md).
