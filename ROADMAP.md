# Roadmap

This file contains future work only. Completed behavior and release evidence
belong in [CHANGELOG.md](CHANGELOG.md) and [versioned testing](docs/testing/).

## v0.8.0 — coordinator decomposition

- Reduce `main.lua` to bootstrap, lifecycle wiring, and public routing.
- Extract `chaosCoordinator`, `raceGenerationCoordinator`, and
  `garageCoordinator` with explicit command boundaries.
- Share one `operationLifecycle` for start, cancel, timeout, cleanup, and
  terminal publication.
- Separate `runtimeUpdateLoop`, `eventRouter`, and `statePublisher`.
- Decompose `apiAdapter` by registry, vehicle identity, mutation, persistence,
  and host integration capability.
- Add a separately validated BeamMP adapter for discovery, server authority and
  replication; the current release only provides the fail-closed identity envelope.
- Replace remaining compatibility facades after migration and live evidence.

## Later

- Execute larger property/fault campaigns without raising interactive budgets.
- Expand verified compatibility only when owner-supplied live artifacts exist.
- Evaluate additional Runtime UI host capabilities through public BeamNG APIs.
- Improve Garage and Race authoring workflows while preserving data schemas and
  deterministic replay.
- Promote Pega-Pega/Tag beyond its contact/state-machine foundation only after
  Race P0, gentle-contact behavior and exact-package live gates pass. Group Tag,
  Infection, Hot Potato and team modes remain later work.

These items are not implemented or promised for a particular date.
