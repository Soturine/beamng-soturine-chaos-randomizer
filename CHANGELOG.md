# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- BeamNG 0.38.6 research and a documented compatibility architecture.
- Deterministic seeded selection with isolated sub-streams and recent-item avoidance.
- Dynamic model/configuration indexing with official, mod, user, and unknown source classes.
- Random Config, Scramble, Full Random, bounded nested-slot mutation, tuning, and paint pipelines.
- Metadata-first missing-part and best-effort drivability safeguards.
- Event-driven operation states, deadlines, cancellation tokens, rollback, Undo, and session blacklisting.
- Compact AngularJS UI App with Advanced filters, fairness, seed copying, diagnostics, and an original icon.
- Lua, Python, static, and deterministic package tests.
- Reproducible ZIP/SHA-256 build tooling and GitHub Actions validation/package workflows.
- Complete alpha documentation and BeamNG Repository preparation guidance.

### Changed

- Replaced the initial repository placeholder README with full project documentation.

### Fixed

- Mod configuration packs attached to official vehicle models remain eligible under the Mods-only filter.
- Adapter exceptions during hierarchical slot inspection now produce recoverable operation errors.
- A completed operation's seed remains visible and copyable in the UI.

### Removed

- Nothing.

No tag or public release is created by this work. The versioned alpha artifact remains under `Unreleased` until interactive validation and an explicit release decision.

[Unreleased]: https://github.com/Soturine/beamng-soturine-chaos-randomizer/commits/main
