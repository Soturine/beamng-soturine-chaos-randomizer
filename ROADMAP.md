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

- validate representative config packs, full mod vehicles, part packs, and wheel packs;
- improve unusual slot/source classification using evidence from current metadata;
- add explicit correlated tuning groups only where metadata proves the relationship;
- improve error attribution and user-visible blacklist details;
- add safe, bounded developer stress diagnostics;
- expand regression fixtures from real, license-safe metadata shapes.

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
