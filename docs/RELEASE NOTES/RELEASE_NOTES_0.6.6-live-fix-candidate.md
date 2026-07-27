# Soturine's Chaos Randomizer 0.6.6-live-fix-candidate

Status: **Unpublished live-fix candidate**.

Publication gate: Closed. Future public tag `v0.6.6` requires owner approval of
the exact candidate live matrix. No tag or GitHub release belongs to Stage A.

Automated validation: Passed

Live BeamNG validation: Pending owner validation

Live cases: 0 executed / 0 passed / 0 failed / 99 pending / 0 blocked

## Candidate changes

- Separates original, selected, clean, accepted and current-attempt baselines.
- Gives critical protection precedence over optional missing-part freedom using
  loaded structure/powertrain/energy evidence where available.
- Requires two coherent generation/ID-bound post-reload reads.
- Repairs exact critical paths or the nearest missing dependency ancestor before
  full rollback, preserving unrelated chaos changes.
- Prevents unsafe exposed oil/coolant tuning and probes actual combustion
  thermal oil state without inventing an unsupported setter.
- Spawns, randomizes and retains one independent managed vehicle per Race
  competitor, restores player focus, and repositions existing IDs in Placement.
- Adds explicit Placement disabled reasons, ordering controls and conflict-only
  warnings for BeamLR and Driver Assistance.
- Replaces the ambiguous canine mark with an original angular fox SVG and
  transparent 24/32/48/250×120 PNG assets.

These are implementation and automated-test statements, not a claim that the
bugs are fixed in live BeamNG gameplay.
