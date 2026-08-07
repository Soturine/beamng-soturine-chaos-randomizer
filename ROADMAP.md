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
- Replace remaining compatibility facades after migration and live evidence.

## Later

- Execute larger property/fault campaigns without raising interactive budgets.
- Expand verified compatibility only when owner-supplied live artifacts exist.
- Evaluate additional Runtime UI host capabilities through public BeamNG APIs.
- Improve Garage and Race authoring workflows while preserving data schemas and
  deterministic replay.

These items are not implemented or promised for a particular date.
