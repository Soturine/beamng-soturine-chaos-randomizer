# v0.7.2 Race slot report

Automated status: **Passed for 1/4/8/12-slot fixtures**. Live status: **Pending
owner validation**.

Each slot has a unique slot ID, seed derived from episode seed plus slot index,
target vehicle ID, ownership set, retry count, start/deadline clock, and terminal
result. Exact-ID background configuration uses the slot vehicle object. The
player is never entered or mutated as a staging target.

The coordinator schedules one bounded heavy unit at a time, preserves accepted
competitors when another slot fails, ignores stale callbacks, and cleans only
temporaries owned by the affected generation. Race publishes only Race-domain
events. Player participation is an explicit final lineup role; spectator mode
leaves the player outside the generated competitor set.

