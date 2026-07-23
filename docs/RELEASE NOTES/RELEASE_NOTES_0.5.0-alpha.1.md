# 0.5.0-alpha.1 — Locks, Mutations, Favorites, Gallery and Sharing

This prerelease adds persisted multi-level locks, Reroll Unlocked, deterministic Small/Medium/Wild Vehicle DNA children and lineage, expanded Garage metadata and filters, bounded managed thumbnails with fallback, field comparison, and validated `.vdna.json` / `.vdna.zip` exchange.

The UI now uses Randomize, Locks, Garage, Compare, and Share views. Replay Generation has an explicit original/current lock policy; Restore Snapshot still ignores creative locks and Pure Seed Replay remains separate.

Security boundaries include a fixed bridge allowlist, fixed share/inbox/thumbnail roots, bounded JSON/canonical structures, a five-entry ZIP allowlist, traversal/backslash/absolute/duplicate/symlink/flag/CRC/SHA/schema/bomb/PNG validation, unique local import IDs, origin lineage, and no mod asset redistribution.

Target: BeamNG.drive `0.38.6.0.19963` / Steam build `23007233`.

Automated Lua/Python/static/package checks pass on the release tree. No real BeamNG world/UI, representative third-party mod, restart, screenshot capture, or multi-PC package result is claimed: interactive status remains **0 Passed / 100 Pending**.

Install the attached `soturine_chaos_randomizer_0.5.0-alpha.1.zip`, not GitHub's automatic source archive, and verify the attached SHA-256. This is an alpha prerelease, not beta or stable.
