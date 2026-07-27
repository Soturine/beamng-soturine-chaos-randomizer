# Soturine's Chaos Randomizer 0.6.3

Status: **candidate only — do not publish yet**.

This Experimental pre-1.0 candidate restructures vehicle identity around one
logical target and validated concrete-ID rebinds. It also adds bounded dynamic
tuning discovery, verified combustion-fuel protection, corrected UI rendering,
shared CRC, canonical Race ownership, orphan detection, and subsystem timing
percentiles.

Automated evidence exercises the returned-ID, callback, reload, timeout,
recovery, terminal-state, tuning, energy-storage, UI math, architecture, and
packaging contracts. It does not prove BeamNG gameplay behavior.

## Release gate

Live BeamNG execution: **0 executed / 0 passed / 0 failed / 110 pending / 0
blocked**. No exact candidate ZIP has yet completed the live plan. Therefore:

- no `v0.6.3` tag may be created;
- no GitHub prerelease may be published;
- the 22% and 57% regressions, pause independence, wrong-vehicle recovery,
  fuel behavior, and rendered UI remain live-unverified;
- the tag workflow rejects a pending report or a report that does not contain
  the exact ZIP filename, byte size, and SHA-256.

Use the [candidate validation index](../testing/v0.6.3/README.md), [live test
plan](../testing/v0.6.3/LIVE_TEST_PLAN.md), [live report](../testing/v0.6.3/LIVE_TEST_REPORT.md),
and [automated report](../testing/v0.6.3/AUTOMATED_TEST_REPORT.md). After every
live case passes against the exact artifact, rebuild the byte-identical ZIP and
current-commit manifest, run the release gate, then create the annotated tag and
experimental prerelease.

Vehicle DNA schema 1, generator 6, `SCR6` seeds, prior saved data, and legacy
Lineup storage/API entry points remain supported. Compatibility with third-party
mods remains best effort and evidence-based.
