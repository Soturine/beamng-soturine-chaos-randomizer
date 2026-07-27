# Release audit — 0.6.4

Status: **Experimental prerelease authorized after local/CI gates; live owner
validation remains Pending**.

## Immutable baseline

| Item | Evidence |
| --- | --- |
| v0.6.3 target / original main / original origin main | `ef0cf1a258a234a4ef8f8808e59ae983a0c162a6` |
| v0.6.3 annotated tag object | `fe0a4646ae7bf2ad3e92fb27561d405b09a578f5` |
| v0.6.2 target | `6907473205decf71433a24d72075358011e0da24` |
| v0.6.2 annotated tag object | `d8f57797a344a4a38e67ba3c0c5b6bc71dbeb989` |
| Working branch | `fix/v0.6.4-live-lifecycle` from exact v0.6.3 target |
| History rule | no force push, tag move, release overwrite, or mutation of old assets |

The v0.6.3 GitHub prerelease and all prior tags/releases/assets were inventoried
before changes and must remain untouched after publication.

## Change groups

1. Record actual v0.6.3 owner failures.
2. Accept coherent multi-source target/read-back evidence without callbacks.
3. Preserve uncertain fuel/optional-part results and classify terminals.
4. Replace sticky sizing and refresh fox/app icon.
5. Version, evergreen documentation, research, and release evidence.

## Safety/architecture audit

- Direct BeamNG access remains in adapter modules; orchestration consumes data-
  only evidence.
- Logical target intent and concrete IDs are separate and generation-bound.
- Candidate/event/diagnostic/performance storage is bounded.
- Player/model/config/parts/tuning evidence is phase-specific and coherent.
- No sleep, forced pause, global timeout increase, fixed catalog, broad fallback
  guess, or callback-only success path was added.
- Settings schema 6, DNA schema 1/generator 6, Race storage, legacy Lineup
  facade, imports, seeds, and historical data remain compatible.
- SVGs contain local vector primitives only; PNG is 250×120; no credentials,
  secrets, or absolute local paths are packaged.

## Gates

| Gate | Candidate status |
| --- | --- |
| Python/Lua/JS/static/security tests | Passed locally; exact counts in automated report |
| Node syntax | Passed locally |
| Deterministic ZIP/checksum/manifest | Required after final candidate commit |
| Package validation | Required after final candidate commit |
| Experimental prerelease gate | Must pass with 0/0/0/110/0 live totals |
| Main CI | Must be green before tag |
| Annotated `v0.6.4` | Create once at final main SHA; never move |
| GitHub release | Create once as prerelease; upload ZIP/checksum/manifest |
| Downloaded asset identity | Compare filenames, sizes, hashes and manifest |
| Live-validated gate | Expected to remain closed while 110 Pending |

The release manifest is the canonical final commit/artifact binding. Repository
documents intentionally do not embed a self-referential pre-commit ZIP hash;
the publication report and final handoff record the generated/downloaded values.
