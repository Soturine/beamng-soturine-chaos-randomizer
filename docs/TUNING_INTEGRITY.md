# Tuning integrity

Tuning is a central Scramble stage and therefore also belongs to Full Random
and every Race Car. It starts after the current parts tree has converged.

## Runtime discovery and eligibility

The pipeline reads the loaded vehicle's public variables at runtime and does
not use an English-name allowlist. A normalized variable needs a name, finite
numeric range/current or default value, valid step when present, and evidence
that it is neither hidden, internal, action-like, nor locked. Invalid metadata
is classified without aborting unrelated variables.

Variables are rescanned to a bounded fixed point. Each wave randomizes eligible
stable identities not already processed, applies them to the confirmed target,
reads back, and scans again. New variables, disappearance, bounds/step changes,
metadata revisions, repeated signatures, cycles, pass limits, clamps, and
rejected writes all receive explicit ledger reasons. Chaos 100 selects every
eligible variable discovered within the protection bounds.

## Selection, correlation, and read-back

Chaos controls selection coverage and amplitude. When alternatives exist,
discrete choices avoid the current value and continuous values respect range,
step, and metadata-derived tolerance. Extreme Tuning increases preference for
valid extremes but never writes outside reported bounds.

Retries use variable-specific deterministic substreams. Correlation occurs only
when explicit metadata names a group and selects the supported
`shared_normalized_sample` strategy; similar display names never create a
group. Every requested value is reread and recorded as confirmed, unchanged,
clamped, rejected, disappeared, skipped, or rolled back.

## Locks and Vehicle DNA

Global, individual, category, and subcategory locks are derived from current
metadata and bound to the relevant model/configuration. Unresolved locks are
reported instead of silently migrated.

Vehicle DNA schema 1 captures the observed final values after fuel protection
and final validation. Generator 6 and `SCR6-...` remain current; generator-4/5
snapshots retain their recorded semantics. Compatible restore may clamp only
with an explicit deviation and verified read-back.

Automated tests cover initial and multi-wave discovery, malformed/non-finite
metadata, metadata changes, disappearance, clamp/rejection, fixed points,
cycles, Chaos 100, deterministic intermediate Chaos, and seed replay. Actual
third-party tuning behavior remains Pending in the [live test
plan](testing/v0.6.4/LIVE_TEST_PLAN.md).
