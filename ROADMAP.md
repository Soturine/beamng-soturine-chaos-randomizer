# Roadmap

This roadmap describes direction, not release evidence. Completed changes are
recorded in [CHANGELOG.md](CHANGELOG.md).

## Release sequence

- **v0.6.8 — P0:** essential BeamNG 0.39 compatibility.
- **v0.6.9 — P1:** performance, profiling, and efficiency.
- **v0.7.0 — P2:** native Runtime UI Vue migration, i18n, accessibility, and UI
  architecture modernization. Its first live case failed before mount because
  the Runtime UI could not resolve a directory-style import.
- **v0.7.1 — P2 hotfix:** explicit native Vue module graph paths and source/ZIP
  graph gates. Implemented as an experimental prerelease; live validation is
  Pending owner validation.
- **Post-v0.7.0:** fresh audit after BeamNG 0.39.x hotfixes. The audit is planned
  in [POST_V070_AUDIT_PLAN.md](docs/POST_V070_AUDIT_PLAN.md) and is intentionally
  not executed as part of v0.7.0.

## Current validation

- Execute the v0.7.1 live matrix against the downloaded release ZIP on a clean
  BeamNG 0.39 profile.
- Record visual, controller, scaling, Garage 500, Race 12, lifecycle, and
  performance comparison evidence without converting source inspection into a
  live result.
- Keep the release experimental until owner evidence supports promotion.

## After v0.7.1

- Reinspect the then-current 0.39.x release notes, official docs, installed
  runtime source, APIs, deprecations, known issues, and representative mod
  interactions.
- Re-audit physics, AI, HUD/Runtime UI, performance, architecture, dead code,
  regressions, and compatibility.
- Decide the next scope from fresh evidence rather than expanding this hotfix.

## 1.0 exit criteria

- No known P0 lifecycle, ownership, recovery, Busy, fuel, or data-integrity
  defect.
- Repeated clean-profile testing against exact published artifacts.
- Representative official/mod content coverage and honest capability
  degradation.
- Stable settings, Vehicle DNA, Race, UI protocol, and compatibility policy.
- Reproducible assets, green CI, immutable release history, and current owner,
  architecture, security, troubleshooting, and validation documentation.
