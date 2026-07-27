# Soturine's Chaos Randomizer 0.6.4

**Experimental prerelease.**

Automated validation: Passed.

Live BeamNG validation: Pending owner validation.

0 executed / 0 passed / 0 failed / 110 pending / 0 blocked.

This hotfix addresses the live v0.6.3 stalls at 22% target tracking and 57%
parts reload waiting by using coherent multi-source read-back rather than a
callback as completion authority. It also prevents uncertain fuel metadata,
optional/mod missing parts, and transient parts-tree unreadability from causing
destructive fallback by themselves.

Highlights:

- callbacks are advisory; already-applied states can complete from read-back;
- late, early, duplicate, absent, and stale-generation callbacks are bounded;
- logical targets survive concrete ID recreation and reload;
- confirmed combustion fuel below 10% is corrected, while ambiguity is warned;
- only documented core/proven functional loss is fatal for missing parts;
- explicit success/partial/preserved/rollback/cancel terminal outcomes;
- automatic per-tab sizing no longer keeps Settings height stuck on Chaos;
- original friendly flat fox in the header and 250×120 selector icon;
- expanded evergreen README and complete v0.6.4 validation workspace.

Install by downloading `soturine_chaos_randomizer_0.6.4.zip` from this release's
Assets and placing it, unextracted, in the BeamNG user `mods` directory. Remove
older copies and confirm `0.6.4` in the app header.

The attached `.sha256` and `release-manifest.json` identify the exact candidate.
The prerelease is intentionally the owner-validation distribution channel. It
does not claim that gameplay, physics, rendering, performance, clean-profile,
or representative third-party content passed until the repository owner fills
the [live report](../testing/v0.6.4/LIVE_TEST_REPORT.md) against the downloaded
asset.
