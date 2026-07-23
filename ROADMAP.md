# Roadmap

The roadmap is evidence-driven. A feature is not considered stable until it has been exercised against representative official and third-party content in the target BeamNG version.

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

- strengthen the drivability validator without imposing rigid global vehicle assumptions;
- validate Automation vehicles, trailers, props, electric drivetrains, and multi-differential layouts;
- profile large mod collections and deeply nested slot trees;
- revalidate the API adapter against the then-current BeamNG release;
- publish an evidence-backed compatibility matrix.

## 0.4.0-beta — release preparation

- UI scaling, keyboard/controller, and accessibility polish;
- repeated-operation and conflict stress testing;
- community bug fixes and compatibility reports;
- localization design without broken fallback labels;
- BeamNG Repository submission assets and final checklist.

## 1.0.0 — stable

- stable release against a documented current BeamNG version;
- complete clean-profile package validation;
- broad official and representative mod-content coverage;
- stable settings migration and backward-compatibility policy;
- complete end-user and maintainer documentation.

Milestones may change when BeamNG APIs or test evidence require a different order.
