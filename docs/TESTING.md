# Testing

This document separates automated/runtime validation from interactive BeamNG gameplay testing. A passing Lua console suite does not imply that a UI App rendered correctly or that a vehicle survived an in-game mutation.

## Test environment

| Item | Value |
| --- | --- |
| Date | 2026-07-23 |
| Operating system | Windows 10 build 19045 |
| BeamNG executable | 0.38.6.0.19963 |
| BeamNG console runtime | Lua 5.1, BeamNG 0.38.6.0 |
| Steam build | 23007233 |
| Python | Local Python 3 |
| Node.js | 24.11.1 |
| Lua parser | `luaparse` 0.3.1 |

BeamNG 0.38 had not created a versioned 0.38 user profile in this environment, so no interactive world/UI session was launched. Pure Lua tests were executed with BeamNG's shipped console after staging only the test runner and Lua source beneath the game VFS. The test harness removes that temporary staging directory afterward.

## Automated tests executed

Command:

```powershell
python -m unittest discover -s tests -v
```

Result: **12 Python `unittest` test methods passed**. One method runs **20 named Lua behavior tests against the actual project modules**.

The Lua cases cover:

- deterministic PRNG sequences and seed normalization;
- integer/float ranges and weighted selection;
- recent vehicle/config anti-repeat behavior;
- Chaos policy boundaries and optional-empty probability;
- immutable candidate copying;
- required/core-slot empty filtering;
- selection of a different compatible candidate;
- detection of newly exposed nested paths;
- tuning range clamping and step quantization;
- default-centered and extreme-biased tuning;
- legal operation transitions and deadline expiration;
- stale token/callback rejection;
- bounded circular history;
- three-failure session blacklist threshold;
- settings schema migration;
- Mods-only discovery of a mod config pack on an official model.

The Python cases cover:

- invoking a Lua 5.1-compatible runtime or BeamNG's console;
- deterministic package construction and byte-for-byte rebuild;
- ZIP root/path safety, backslash rejection, and development-content rejection;
- SHA-256 verification;
- JSON parsing;
- JavaScript syntax through `node --check`;
- trailing whitespace;
- unique UI directive IDs;
- package-content machine-path checks;
- version consistency;
- enforcement of the BeamNG API adapter boundary.

## Static validation executed

- All 18 Lua files parsed successfully with `luaparse`.
- The actual Lua modules compiled and ran in BeamNG's Lua 5.1 console.
- `app.js` passed `node --check`.
- Project JSON loaded successfully.
- Both workflow YAML files parsed successfully with PyYAML.
- `git diff --check` passed during each implementation/commit stage.
- The test suite checked trailing whitespace, internal UI IDs, version values, local machine paths, and API-boundary patterns.

CI repeats these checks on Ubuntu with Python 3.12, Node.js 20, and `lua5.1`; it also runs `luac5.1 -p` over every Lua source file.

## Package validation executed

Commands:

```powershell
python tools/package_mod.py
python tools/validate_package.py
```

The validator checks that:

- the versioned ZIP and SHA-256 file exist;
- `lua/`, `ui/`, and `settings/` are ZIP roots, without a wrapper folder;
- required extension and UI files exist;
- JSON files parse;
- paths are unique, case-safe, relative, and slash-normalized;
- no symlinks or development-only paths are included;
- packaged `VERSION` matches the artifact name;
- the SHA-256 file matches;
- rebuilding from unchanged inputs produces byte-identical ZIP bytes.

Final validated artifact:

- ZIP: `dist/soturine_chaos_randomizer_0.1.0-alpha.1.zip`
- Entries: 27
- Size: 1,131,701 bytes
- SHA-256: `e9ad10e56b6252e6980942cc0964c70b2e9962a3db44784eb9fa9054877abe80`

The matching `.sha256` file was generated and verified. Development documentation and tests are intentionally excluded, so subsequent documentation-only edits do not alter these package bytes.

## Interactive in-game matrix

None of the following cases was executed in a live BeamNG world/UI session. Every status is deliberately **Pending**.

| # | Case | Status |
| ---: | --- | --- |
| 1 | Official vehicle only | Pending |
| 2 | Official configuration | Pending |
| 3 | Config pack | Pending |
| 4 | Full mod vehicle | Pending |
| 5 | Mod part pack | Pending |
| 6 | Mod wheel pack | Pending |
| 7 | Unusual wheels | Pending |
| 8 | Automation vehicle | Pending |
| 9 | Trailer | Pending |
| 10 | Prop | Pending |
| 11 | Vehicle with few slots | Pending |
| 12 | Vehicle with many nested slots | Pending |
| 13 | Electric vehicle | Pending |
| 14 | Drivetrain with several differentials | Pending |
| 15 | Invalid configuration | Pending |
| 16 | Mod disabled after indexing | Pending |
| 17 | Random Config repeated 25 times | Pending |
| 18 | Scramble repeated 25 times | Pending |
| 19 | Full Random repeated 25 times | Pending |
| 20 | Chaos 0 | Pending |
| 21 | Chaos 25 | Pending |
| 22 | Chaos 50 | Pending |
| 23 | Chaos 75 | Pending |
| 24 | Chaos 100 | Pending |
| 25 | Allow Missing Parts off/on | Pending |
| 26 | Keep Vehicle Drivable off/on | Pending |
| 27 | Manual vehicle switch during operation | Pending |
| 28 | Map switch during operation | Pending |
| 29 | Repeated rapid button presses | Pending |
| 30 | Undo after Scramble | Pending |
| 31 | Undo after Full Random | Pending |
| 32 | Same seed with unchanged content | Pending |
| 33 | Content reindex | Pending |
| 34 | UI scaling | Pending |
| 35 | Packaged ZIP installed normally | Pending |

## Required interactive procedure

For each applicable case:

1. Use a clean versioned 0.38 user profile and retain `beamng.log`.
2. Record the exact model, configuration, enabled mods, settings, and seed.
3. Confirm the busy state clears on success, cancellation, timeout, and error.
4. Check console errors before judging the visible result.
5. Verify Undo restores model, configuration tree, tuning, and paints.
6. Re-run deterministic cases after restarting with unchanged content.
7. File failures with diagnostics and the smallest reproducible content set.

Do not mark a row passed merely because the operation produced a vehicle. Compatibility, error-free reload, controls, Undo, UI state, and log output must all be checked.

## Stress diagnostics

No automatic stress command is included in this alpha. Repetition tests must be performed manually with delays between operations until a bounded developer diagnostic is implemented. This avoids an uncontrolled spawn/reload loop in a live game.
