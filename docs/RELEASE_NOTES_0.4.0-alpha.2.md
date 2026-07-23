# Soturine's Chaos Randomizer 0.4.0-alpha.2

> Download `soturine_chaos_randomizer_0.4.0-alpha.2.zip` from this release's **Assets**. GitHub's automatically generated **Source code** archives are not installable BeamNG mod packages.

This hotfix prerelease repairs Vehicle DNA restoration across different active models and configuration path/key forms. Restore now loads the saved normalized, model-scoped base inside one rollback transaction, inspects the confirmed target, and then completes Exact/Compatible restoration or safely restores the previous vehicle. Parent-first work uses a depth-derived bounded budget with deadline, no-progress, and repeated-state guards.

Replay Generation is now the primary deterministic replay contract: it freezes the saved base and replays only recorded parts/tuning/paint generation. Base-reselecting Pure Seed Replay is separate and explicitly warned. The Garage also reports storage usage and durable-write recovery, and active work can be cancelled with rollback.

Automated tests and deterministic package validation pass. Interactive BeamNG world/UI, representative-content, restart/corruption, and multi-PC validation remains **0 Passed / 60 Pending**. This is an alpha evidence artifact, not a stable or gameplay-validated release.
