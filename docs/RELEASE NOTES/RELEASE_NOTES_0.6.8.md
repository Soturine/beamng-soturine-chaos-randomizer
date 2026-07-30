# Soturine's Chaos Randomizer 0.6.8

Status: **Experimental prerelease — BeamNG.drive 0.39 compatibility, live
validation pending**.

Automated validation: Passed

Live BeamNG validation: Pending owner validation

Live cases: 0 executed / 0 passed / 0 failed / 60 pending / 0 blocked

## Highlights

- Central compatibility metadata declares 0.39 as the primary target and 0.38.6
  as the minimum, with runtime detection/classification and visible warnings.
- Registry warm-up/partial states retry by wall clock and preserve the last
  complete cache instead of replacing it with a temporary empty read.
- Configuration identity separates registry keys, exact case paths, comparison
  paths, basenames, families, display groups, aliases, and translated labels.
- Spawn/replacement uses before/after world snapshots, returned-object evidence,
  stable acceptance, cardinality enforcement, and owned-only cleanup.
- Confirmed low-memory denial is distinct from unknown/no-space outcomes;
  temporary/unknown conditions never blacklist content or loop forever.
- Removal callbacks are generation/ID correlated; stale callbacks are ignored
  and recovery remains bounded/idempotent.
- Ternary safety covers combustion/electric/hybrid, multiple fuel tanks, N2O,
  engine fluids, optional content, and confirmed core failures.
- AI sends `driveInLane` explicitly and does not mark a failed initial command
  as started.
- The legacy Angular HUD App remains hosted by BeamNG 0.39 Runtime UI; resize,
  remount, timer, and observer lifecycle cleanup is explicit.
- Settings schema 7 and lineup writes use last-known-good backup, readback, and
  verified rollback; DNA/lineups are preserved and migration is reported.
- BeamLR, Driver Assistance, other randomizers, and multiplayer sync are
  warning-only conflicts; nothing is disabled automatically.
- The deterministic manifest derives target/minimum versions from
  `COMPATIBILITY.json` and binds all required artifact/test/live fields.

## Validation boundary

Automated tests execute production Lua through the BeamNG 0.39 console and
cover package/static/JavaScript contracts. They do not prove live spawning,
physics, memory pressure, rendering, performance, or third-party mod behavior.
All 60 owner cases remain Pending.

## Assets

- `soturine_chaos_randomizer_0.6.8.zip`
- `soturine_chaos_randomizer_0.6.8.zip.sha256`
- `soturine_chaos_randomizer_0.6.8.manifest.json`

Install the attached ZIP, not GitHub's automatic source archive. Verify the
checksum and manifest, and keep only one Randomizer version enabled.
