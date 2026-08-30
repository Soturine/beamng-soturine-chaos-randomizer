# Testing

v0.7.9 live-derived regressions are mapped in
the focused [`testing/v0.7.9/LIVE_TEST_PLAN.md`](testing/v0.7.9/LIVE_TEST_PLAN.md).
The exact-package live plan and aggregate results remain separate. Automated
Lua/UI/package evidence never upgrades renderer, AppHost, controller, gameplay
or performance rows to live-passed.

Testing is reported by evidence category. Counts from different categories are not added together as if they were equivalent independent tests.

## Commands

```powershell
npm ci --ignore-scripts
npm run validate:sfc
npm run validate:graph
npm run validate:styles
npm run test:ui
python -m unittest discover -s tests -v
python tools/package_mod.py
python tools/validate_package.py
python tools/validate_release_gate.py --channel prerelease
```

The Python Lua wrapper uses a local Lua 5.1-compatible interpreter when available, otherwise the installed BeamNG console. The Lua suite prints unique function count, requirement mappings, executed cases, and assertion count separately.

## Evidence categories

| Category | What it proves | What it does not prove |
| --- | --- | --- |
| Behavioral Lua unit tests | deterministic domain functions, limits, schemas, normalization | BeamNG world behavior |
| Mocked BeamNG pipeline tests | orchestration, callbacks, reloads, readback, rollback, target ownership | real engine timing or a particular mod |
| Property/state-machine tests | invariants across many transitions and candidates | exhaustive state space |
| Static source-contract tests | boundary, links, versions, UI/source requirements | rendered layout or gameplay |
| JavaScript/Vue tests | bridge, store, state, i18n, layout and lifecycle contracts | CEF pixels, DPI, real controller input |
| JSON/schema tests | manifest/settings/schema validity and migration | persistent game storage behavior |
| Workflow/package tests | deterministic ZIP, root layout, manifests, release gates | successful live installation |
| Requirement mappings | traceability to executed tests | additional executions |
| Live BeamNG tests | actual packaged gameplay/UI/mod evidence | untested builds or content |

Current exact automated results are recorded in
[the v0.7.9 report](testing/v0.7.9/AUTOMATED_RESULTS.md). The mandatory live
plan and report remain separate.

v0.7.0 preserves the v0.6.9 profiling/budgets, iterators/buffers, OOBB
dimensions, catalog cache, incremental indexing, UI diffs, diagnostics
aggregation, adaptive polling, AI mode readback, Race scaling, and deterministic
seed vectors. Its native Vue tests add bridge, domain isolation, stale/gap
recovery, i18n, accessibility, responsive and mount/unmount contracts. The
v0.6.8 compatibility foundation continues to cover metadata/version classification,
registry warm-up/partial reads, technical identity and case-sensitive paths,
spawn cardinality and typed denial evidence, migration rollback, legacy HUD
runtime teardown, independent configuration evidence, callback-free
public flows, callback order/duplication, preserved uncertain fuel/parts
results, explicit terminal outcomes, automatic/user/collapsed sizing, repeated
tab cycles, and the shared fox identity. See the
[requirements matrix](testing/v0.7.0/REQUIREMENTS_MATRIX.md).

## Honesty rules

- A case is Passed only if it was executed and its assertions or observations passed.
- `0 Failed` is always accompanied by the number executed.
- Compilation is not evidence of physics, scaling, overflow, readability, or mod compatibility.
- Automated target simulations do not become live BeamNG results.
- Live rows remain Pending until run with the exact candidate ZIP whose checksum is recorded in the report.
- The Experimental prerelease gate permits Pending owner validation only when Failed and Blocked are zero and the disclosure, package, checksum, manifest, version, commit, and reproducibility contracts pass.
- The separate live-validated gate remains closed while any mandatory live row is Pending, Failed, or Blocked.

## Adding tests

Prefer the lowest-level deterministic test that proves the contract, then add a mocked end-to-end case when orchestration matters. Lifecycle changes should include stale/current generations, target identity, wall-time behavior, terminal Busy cleanup, and wrong-target write rejection. UI visual claims always retain a live row.

Historical live plans and reports are preserved under [archive/releases](archive/releases/).
