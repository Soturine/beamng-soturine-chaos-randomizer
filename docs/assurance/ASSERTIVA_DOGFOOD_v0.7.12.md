# Assertiva and Derivanta-Engine dogfood - v0.7.12

Cross-dogfood run on 2026-11-02 against the Randomizer at `e1610ed` (the
v0.7.12 tree before docs and version metadata). Both instruments ran from
isolated environments outside the project; neither is a dependency of the mod,
its CI or its ZIP. The project tree was checked clean (`git status`) after every
run.

Machine-readable findings: [ASSERTIVA_FEEDBACK_v0.7.12.json](ASSERTIVA_FEEDBACK_v0.7.12.json).

## Instruments

| Instrument | Version | Source | Environment |
| --- | --- | --- | --- |
| Assertiva | 0.10.1 (`2618d95`, tag v0.10.1) | GitHub release tag, cloned with `core.longpaths` | isolated venv, Python 3.12.6, Windows 10 |
| Derivanta-Engine | 0.1.0, M3 closed (`17fa564`) | owner's local checkout and its own `.venv` | read-only `inspect` / `compare` |

## A. Assertiva auditing the Randomizer

| Command | Result | Time |
| --- | --- | --- |
| `assertiva audit <repo>` (static) | exit 0, FINDINGS, run `979406beddba4089` | 49 s |
| `assertiva audit <repo> --execute --python <python.exe> --timeout-s 600 --ctrf` | exit 0; pytest-native 51 PASS, Vitest 38 PASS; run `d45ddf58bf63486c` | 49 s |
| `assertiva audit <repo> --junit-xml lua-junit.xml` | 458 Lua cases ingested as PASS with provenance "not executed by Assertiva" (sha256 `492f6380…4394b81`); run `4c7ce0f7efb74c9c` | - |

What the suite really contains: 458 Lua cases (custom runner on BeamNG's
LuaJIT console), 51 Python unittest cases, 38 mounted Vitest cases, a 1190-check
Node contract script, the UI command parity, module and style graph checks on
source and on the extracted ZIP, and the deterministic package build.

Assertiva finding review (each confirmed or rejected by reading the code and,
where cheap, by a negative control in a disposable copy):

| Finding | Verdict | Evidence |
| --- | --- | --- |
| LOCAL_CHECK_NOT_OBSERVED_IN_CI [HIGH]: `verify` not in CI | **false positive** | `ci.yml` runs `npm run verify`; Assertiva's own NESTED_SCRIPT_REPETITION lists that CI step |
| CI_PYTEST_NOT_OBSERVED | **false positive** | the suite is unittest, run by `npm run verify` → `tools/verify.py` → `unittest discover` |
| FALSE_GREEN_CANDIDATE `test_beamng_api_boundary` (conditional assertion) | **rejected** | the condition skips only 4 allowed adapters of ~106 files; negative control (engine call added to `raceManager.lua` in a copy): unmodified exit 0, mutated exit 1 → KILLED |
| NESTED_SCRIPT_REPETITION | **false positive** | the three `verify` invocations are separate workflows (push, tag, manual) |
| CI_ONLY_CHECK | partly valid | byte-identity compare and tag/VERSION checks are CI-only by design; `npm run verify` is not CI-only |
| UNCLASSIFIED_VERIFICATION | valid limitation | `npm run verify` kept UNKNOWN rather than guessed |
| ARTIFACT_LINEAGE_UNKNOWN | partly valid lead | the release uploads the artifact of the job that ran `verify:release`, and the manifest binds commit and SHA-256 (checked by `validate_release_gate.py`); Assertiva does not read that binding, and post-download verification is manual |

What the manual audit found that no instrument reported (all fixed in
v0.7.12, see the [audit report](../testing/v0.7.12/AUDIT_REPORT.md)):

1. A mock accepted an API the engine does not have: `readMode` probed
   `getAIMode`/`getAiMode`/`getAIState` on GE objects, so every AI dispatch was
   shown as running.
2. A test encoded the wrong engine contract (Destination confirmed by `traffic`;
   `ai.driveUsingPath` sets `manual`).
3. The module graph check allowed host specifiers without checking imported
   names, so a removed host export (0.40's `v-bng-panel`) would stay green.
4. The prerelease gate made a real live failure unpublishable unless relabelled
   Pending.
5. The release workflow hard-coded a title (v0.7.11 shipped with v0.7.10's).

These depend on BeamNG source knowledge; they are recorded as context for
Assertiva, not as its defects. Mutation evidence for the new code came from
seven deliberate Lua defects, all killed (`mutate.py` in the session
scratchpad; not part of the project). Cosmic Ray/Stryker mutation through
Assertiva was **not run**: it needs a mutation tool installed in the project
environment and would rebuild the package per mutant; Lua has no mutation path
in Assertiva.

## B. Assertiva on itself

| Observation | Kind | Reproduction | Proposed fix |
| --- | --- | --- | --- |
| Lua is absent from the technology inventory (project reported as JavaScript 40/56) although 106 Lua modules and the main suite are Lua | false negative (inventory) | static audit of this repo | add Lua by file pattern, like Derivanta does |
| A custom runner nested in one host test (458 Lua cases inside `test_lua`) is counted as one test | granularity loss | `--execute` report: 51 pytest invocations | recognise nested runner summaries, or document `--junit-xml` bridging; proven here with a 30-line converter |
| `npm run verify` is UNKNOWN and its chain to `tools/verify.py` → unittest is not followed, producing the two CI false positives above | false positive | static audit | follow package scripts one level into `python <script>` before concluding a check is absent |
| HIGH finding contradicts an INFO finding of the same run | internal inconsistency | static audit | cross-check script identity between LOCAL_CHECK and NESTED_SCRIPT analyses |
| Repository checkout fails on Windows without `core.longpaths` (longest path 106 chars + typical temp prefix > 260) | install friction | `git clone --branch v0.10.1` into `%TEMP%\...` | shorten fixture paths or document `core.longpaths` |
| `pip install -e .` in a fresh venv fails with `PIP_NO_BUILD_ISOLATION=0` set | install friction | owner's environment | document like Derivanta does, or vendor a build requirement check |
| `--python` rejects a Windows interpreter path without `.exe` | UX | `--python C:\...\python` | resolve with `shutil.which` or try `.exe` |
| Node contract scripts outside Vitest (1190 checks) are not recognised as verification | false negative | static audit | classify `node tests/**/*.test.mjs` invocations from package scripts |

Not judged as Assertiva defects: no BeamNG game execution (out of scope), and
no knowledge of engine APIs (findings 1-2 above).

## C. Derivanta-Engine

`derivanta-engine inspect <repo> --maintainability` (1 s, read-only, clean
tree) and `compare` against a comparable v0.7.11 clone: **COMPARABLE; NEW 0,
PERSISTING 13, ABSENT 2**.

| Item | Verdict |
| --- | --- |
| Lua recognised (INFERRED, 112 files) | correct, better than Assertiva's inventory |
| Maintainability analysed only the 16 Python files | known M3 scope; the real dead code this release removed (10 functions, 9 aliases, 1 duplicated module) is all Lua |
| ABSENT: deadness candidates `profile_fixtures.py`, `benchmark_v069.py` | consistent with the change, but they were working CLI entry points, not dead: they were merged, not deleted |
| PERSISTING duplicate tables in tests vs `package_mod.py` | rejected: tests repeat expected values on purpose (independent oracle) |
| PERSISTING duplicate `copy_app` helper in two test modules | valid but low value (3 lines, separate fixtures); kept |
| Comparison of an extracted tree vs the repository: DIFFERENT_TARGET | correct refusal; message could say how to make a comparable baseline (clone the same remote at the tag) |
| README says "Status: M2" while the tree closes M3 | documentation drift |
| `pip install` fails with `hatchling` when `PIP_NO_BUILD_ISOLATION=0` | known and documented in the README |

Proposed for a future Derivanta milestone (not implemented here): a Lua adapter
for `require` graphs and `M.name =` exports. A 90-line prototype run in this
session flagged 19 dead-export candidates; manual review confirmed 10 dead
functions and 9 unused aliases.

## Limits

Neither instrument executed BeamNG, rendered anything or exercised split-screen.
No pull request, issue or release was created on the Assertiva or
Derivanta-Engine repositories; this file and the JSON are the feedback to carry
over.
