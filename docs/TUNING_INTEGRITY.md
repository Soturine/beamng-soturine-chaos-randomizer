# Tuning Integrity

Tuning is a central Scramble stage and therefore also belongs to Full Random
and every Chaos Lineup competitor. It runs after the final parts tree has
converged.

## Discovery and eligibility

The randomizer reads public variables from the loaded vehicle at runtime. It
normalizes incomplete min/max/default/step/category/subcategory metadata and
does not use an English-name allowlist. A variable is excluded only when
current evidence marks it internal, hidden, locked, non-finite, or not safely
writable.

These are separate concepts:

- public tuning variables may be randomized;
- JBeam slot variables used internally for configuration are not automatically
  public tuning;
- controller actions, equipment toggles, couplers, sirens, hydraulics, and
  vehicle-specific commands are not executed by randomization.

Accessory States remain out of scope unless a future audited contract can
separate safe state data from executable actions and obtain explicit consent.

## Selection and real change

Chaos controls selection coverage and amplitude. When an alternative exists,
discrete choices exclude the current value. Continuous values require a
metadata-derived tolerance and respect range/step quantization. Extreme Tuning
increases preference for valid extremes; it never writes beyond reported
bounds.

Retries use a variable-specific deterministic substream. A fixed variable is
classified with a reason instead of reported as changed.

## Read-back, rescan, and rollback

Every requested value is reread. The tuning ledger records requested,
observed, changed, unchanged, clamped, rejected, rolled-back, category, bounds,
step, pass, retries, and reason. One bounded final rescan can discover variables
created by a new part; vanished variables are classified rather than causing an
unbounded loop.

Rollback is per variable where possible and per category only when required.
A suspension failure does not erase a confirmed engine change. A
`correlationGroup` is honored only when explicit metadata proves the group and
all members share a valid sample/read-back contract. Similar names alone never
create correlation.

## Locks and Vehicle DNA

Global, individual, category, and subcategory locks are derived from current
metadata and bound to the relevant model/configuration. Unresolved locks are
reported, not silently migrated.

Vehicle DNA schema 1 stores the observed final tuning values and metadata.
Version 0.6.0 uses generator 6 and `SCR6-...` seeds. Generator-4 and generator-5
snapshots remain restorable as their recorded versions and are never
reinterpreted as generator 6. Compatible restore may clamp only with an
explicit deviation and verified read-back.

## Evidence status

Generic discovery, selection, read-back, rescan, grouping, rollback, DNA, and
substream contracts have automated coverage. Turbo, nitro, suspension,
transmission, differential, and representative third-party content remain
interactive Pending; see [Testing](TESTING.md).
