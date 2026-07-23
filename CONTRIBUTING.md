# Contributing

Thank you for helping improve Soturine's Chaos Randomizer. The project is an alpha and values reproducible evidence over assumptions about BeamNG internals or third-party content.

## Before starting

Read:

- [Architecture](docs/ARCHITECTURE.md);
- [API research](docs/RESEARCH.md);
- [Compatibility](docs/COMPATIBILITY.md);
- [Testing](docs/TESTING.md).

For a bug, first search existing issues and reduce the report to the smallest vehicle/mod set that reproduces it. Include the game build, project version/commit, operation, settings, seed, and relevant `SoturineChaosRandomizer` log lines.

## Development environment

Use Python 3.10+, Node.js, and Lua 5.1 (or BeamNG's shipped console). BeamNG 0.38.6 is required for current adapter and interactive testing.

```powershell
python -m unittest discover -s tests -v
python tools/package_mod.py
python tools/validate_package.py
```

For an unpacked install, place the three content roots beneath:

```text
<active BeamNG user folder>/mods/unpacked/soturine_chaos_randomizer/
```

Never write development files into the BeamNG installation's stock content directories.

## Design rules

- Keep direct/internal BeamNG API access in `apiAdapter.lua`.
- Keep pure selection/mutation logic independent from BeamNG globals.
- Do not call or seed global `math.random`.
- Copy registry/slot/config tables before filtering or mutation.
- Use current hierarchical `partsTree` APIs; do not revive flat deprecated calls.
- Keep reload loops bounded, event-driven, token-checked, and timeout-protected.
- Preserve exact seeds and concise diagnostics in bug reports.
- Keep the default UI limited to the three primary actions, Chaos slider, and two visible safety options.
- Do not add a visible control for an unimplemented feature.

## Code and commits

- Match the existing Lua/JavaScript/Python style and `.editorconfig`.
- Add focused tests for pure logic and package rules.
- Use English for code, UI, docs, issues, and commits.
- Use Conventional Commit messages such as `fix(core): reject malformed slot metadata`.
- Keep commits coherent and avoid unrelated formatting churn.

## Testing changes

Run automated tests and package validation for every change. Engine/API, UI, vehicle mutation, tuning, paint, or lifecycle changes also require applicable rows from the interactive matrix in [Testing](docs/TESTING.md).

Do not report an interactive case as passed without recording the exact environment and inspecting `beamng.log`. Never turn a one-off successful spawn into a broad compatibility claim.

## Third-party code, mods, and assets

This is a clean-room implementation. Do not copy source, icons, screenshots, JBeam content, or other assets unless the license is explicitly compatible and every obligation is documented and fulfilled. Treat unlicensed repositories as all-rights-reserved and use them only for behavior research.

Do not commit paid/private mod content, personal paths, game files, generated diagnostic logs, or credentials. Fixtures must be small, original, synthetic, or clearly redistributable.

## Pull requests

Explain the problem, solution, compatibility impact, tests executed, interactive tests pending, and any documentation changes. Keep the working tree clean and ensure CI passes. Maintainers may request a narrower reproduction or adapter evidence before accepting an engine-specific change.

Security vulnerabilities should not be filed publicly; follow [Security](SECURITY.md).
