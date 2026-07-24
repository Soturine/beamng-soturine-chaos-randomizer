# Roadmap

The roadmap is evidence-driven. A feature is not considered stable until it has been exercised against representative official and third-party content in the target BeamNG version.

## 0.6.0 — Full Coverage, Tuning Integrity, Chaos Lineup & AI Director

Implemented in the 0.6.0 release: Chaos-100 coverage ledgers, generic
post-parts tuning integrity, sequential 2–16 competitor Lineup, bounded Spawn
Director/managed generations, capability-gated NavGraph/AI Director, and the
priority pause-state lifecycle fix with target/tree separation, dual clocks,
generation guards, recovery-only isolation, correct snapshot roles, watchdog,
and cancellable phase UI.

The version intentionally has no alpha/beta/RC suffix but remains Experimental,
pre-1.0, and best-effort with mods. Automated and installed-source evidence is
green for the release tree. The dedicated plan remains 0 Passed / 0 Failed / 60
Pending and is explicitly disclosed rather than promoted to gameplay evidence.
Next work is live BeamNG execution and fixes for any failures found there.

## 0.5.0-alpha.2 — lifecycle and compact UI hotfix

Implemented on `main`: bounded multi-ID target tracking and stabilization; post-spawn Full Random completion; transient/deep-tree rescans; localized part-batch rollback/retry/quarantine; failed-load previous/last-known-good/official recovery; no-active-vehicle Random Car/Full Random; parent-final creative operations; model-bound locks; receiver-local import compatibility; structural PNG validation; compact/collapsed/expanded UI; and generator 5 `SCR5-...` seeds with schema-1/generator-4 snapshot compatibility.

All 113 requested automated regressions are registered. The alpha.1 maintainer observations remain historical evidence; the alpha.2 interactive plan is 0 Passed / 0 Failed / 50 Pending, so no beta, stable release, `1.0`, or Repository submission is authorized.

## 0.5.0-alpha.1 — creative Vehicle DNA

Implemented on `main`: persisted vehicle/config/category/slot/part/tuning/paint locks; independent creative RNG substreams; Reroll Unlocked; deterministic Small/Medium/Wild child mutations and bounded lineage; pins, ratings, tags, notes, collections, filters and sort; paginated grid/list gallery with explicit bounded capture and fallback; field comparison; `.vdna.json` and validated fixed-inbox `.vdna.zip`; five-view responsive UI; schema-compatible optional DNA fields and settings schema 4 migration.

Automated, source-inspection, and deterministic package evidence is implemented. Clean-profile gameplay, actual thumbnail capture, UI scaling/input, representative mods, restart recovery, and cross-PC transfer remain 0 Passed / 100 Pending, so this milestone is alpha only.

## 0.4.0-alpha.2 — restore hotfix

Implemented on `main`: normalized/model-scoped configuration identity; cross-model Exact and Compatible target inspection; frozen-base Replay Generation; explicit Pure Seed Replay; adaptive parent-first pass budgets with timeout/no-progress/oscillation guards; optional-slot deviations; durable write recovery; visible storage metrics; and user cancellation with rollback. Interactive BeamNG evidence remains Pending, so this milestone is an alpha prerelease only.

## 0.1.0-alpha — foundation

Implemented on `main`:

- BeamNG 0.38.6 API research and compatibility adapter;
- AngularJS UI App foundation and original icon;
- mounted content registry index and source filters;
- Random Config, Scramble, and Full Random;
- deterministic Chaos policy and seeds;
- bounded hierarchical/nested-slot mutation;
- numeric tuning and dynamic paint-layer randomization;
- best-effort core/critical-slot protection;
- operation state, timeout, cancellation, rollback, history, Undo, and blacklist;
- automated/static tests and reproducible package tooling;
- CI and documentation.

Before an alpha release:

- complete the documented interactive test matrix on BeamNG 0.38.6;
- capture real UI/gameplay screenshots;
- resolve any load, layout, or API issues found by that pass;
- validate the packaged ZIP in a clean 0.38 profile.

## 0.2.0-alpha — content hardening

- **Pending interactive evidence:** validate representative config packs, full mod vehicles, part packs, and wheel packs. License-safe fixtures and the evidence template are implemented, but no live third-party content was available.
- **Implemented:** classify user/mod/official/unknown sources and Automation/trailer/prop types only from explicit current metadata evidence.
- **Partially implemented:** explicit correlated tuning-group architecture and tests exist, but installed 0.38.6 metadata exposes no proven correlation group. Current variables remain independent; no relationship was invented.
- **Implemented:** phase-aware errors, separated session blacklists, conservative batch suspects, candidate filtering, and compact Advanced details.
- **Implemented:** safe developer stress diagnostics with iteration/duration/operation limits, deterministic seeds, cancellation, no overlap, and aggregate results.
- **Implemented:** license-safe synthetic registry/config/slots/tree/tuning/paint fixtures covering official, config-pack, full-mod, part-pack, wheel-pack, user, unknown, legacy, malformed, electric-style, and multi-differential shapes.

Additional 0.2 remediation implemented:

- explicit BeamNG write return contracts and phase/state confirmation;
- ancestor-change descendant deferral and stale-candidate prevention;
- honest **Protect Critical Parts** migration and conservative replacement policy;
- atomic UI action/settings snapshots;
- first-write history commit and consistent rollback cleanup;
- granular capabilities and optional-stage warnings;
- UI custom-element host sizing;
- optimized selector icon and automated limits;
- normalized deterministic ZIP/checksum validation;
- official GitHub Actions pinned by commit SHA.

The milestone remains a content-hardening alpha artifact until its interactive matrix has evidence.

## 0.3.0-alpha — safety and compatibility

- **Implemented:** evidence-based safety graph and dynamic standard-road/electric/hybrid-like/Automation/trailer/prop/special/unknown profiles, without rigid engine/fuel/gearbox/wheel/differential assumptions.
- **Pending interactive evidence:** Automation vehicles, trailers, props, electric drivetrains, and multi-differential layouts have license-safe fixtures and mocked regressions, but no world/UI result is claimed.
- **Implemented:** bounded suspect evolution, success decay, candidate suppression/isolation, and stale-state cleanup.
- **Implemented:** replacement writes pass the exact recorded target object and correlate the returned vehicle ID; unrelated switches cannot retarget spawn, rollback, or Undo.
- **Implemented:** tolerant requested-field paint read-back with bounded update-driven confirmation and no paint spawn wait.
- **Implemented:** external config ownership through the mounted VFS/mod-manager path and layered config identity verification.
- **Implemented:** per-candidate part provenance, including separate previous/selected sources.
- **Implemented:** one-click Full Random transaction through selection, spawn, bounded parts passes, optional tuning/paint, final safety validation, one history entry, and whole-pipeline rollback.
- **Implemented:** mocked `main.lua` success/failure pipeline coverage plus deterministic 5,000-config and 120-level/2,400-candidate performance fixtures.
- **Implemented:** installed adapter/UI source revalidation for BeamNG 0.38.6.0 build 19963 and an evidence-backed compatibility matrix.

The milestone remains a safety-and-compatibility alpha artifact until the interactive matrix has real evidence.

## 0.4.0-alpha — Vehicle DNA and Persistence

- **Implemented:** schema-v1 Vehicle DNA created from fresh post-operation read-back, normalized slots/tuning/paints, categorized dependency evidence, generator context, and field-validated fingerprints.
- **Implemented:** explicit Save Vehicle DNA, bounded single-store persistence, controlled last-known-good recovery, rename/favorite/delete/pagination, JSON import/copy, and fixed-path file export.
- **Implemented:** read-only registry reports plus distinct Restore Exact, Restore Compatible, Replay Generation, and Pure Seed Replay contracts. Restore uses one token/history transaction, target inspection, adaptive parent-first fresh-tree passes, safety validation, final read-back, and rollback.
- **Implemented:** settings schema 3, generator version 4 seed display, legacy seed parsing, granular DNA capabilities, compact Garage/Compatibility UI, release manifest, and prerelease workflow.
- **Implemented:** license-safe automated schema, fingerprint, storage, compatibility, pipeline, UI-boundary, and packaging regressions.
- **Pending interactive evidence:** clean-profile install, live UI/input, persistence across restart, in-game corruption recovery, Exact/Compatible results, representative mod content, and multi-PC import/export.

The alpha may be published as an evidence-gathering prerelease. It is not a gameplay-validated release.

## 0.5.0-beta — release preparation

- **Prepared, not published:** manual Windows/Ubuntu byte-comparison workflow and the multi-PC evidence checklist.
- **Blocked on interactive evidence:** UI scaling, keyboard/controller and accessibility validation; restart/corruption recovery; Exact and Compatible restores on matching/changed content; repeated-operation and conflict stress; community compatibility reports.
- Fix every alpha lifecycle, restore, storage, sharing, or UI regression found by that evidence before changing VERSION or creating any beta tag.
- Prepare localization and BeamNG Repository assets only after fallback labels, package behavior, and current submission requirements are revalidated.

## 1.0.0 — stable

- stable release against a documented current BeamNG version;
- complete clean-profile package validation;
- broad official and representative mod-content coverage;
- stable settings migration and backward-compatibility policy;
- complete end-user and maintainer documentation.

Milestones may change when BeamNG APIs or test evidence require a different order.
