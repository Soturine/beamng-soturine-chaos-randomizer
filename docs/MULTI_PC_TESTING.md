# Multi-PC and Beta Gate Testing

This checklist prepares a possible future `0.5.0-beta.1`; it is not evidence that the beta gate passed. Do not change VERSION, create a beta tag, or publish a beta prerelease until the exact alpha ZIP has real results.

## Required machines

- PC A and PC B with documented OS, BeamNG full build, active user folder, enabled-mod inventory, and randomizer commit.
- At least one clean 0.38.6 profile.
- The exact attached `soturine_chaos_randomizer_0.5.0-alpha.1.zip`, verified against its attached `.sha256` on both machines.

## Required evidence

1. Install the ZIP without extracting it and confirm Mod Manager/UI loading.
2. Create and explicitly save DNA on PC A from official, deep-tree, tuning-rich, and multi-paint content.
3. Restart BeamNG and prove the library survives with the same entry/fingerprints.
4. Export/copy `.vdna.json`, transfer only that JSON to PC B, import it, and compare schema/fingerprints/origin metadata.
5. Export `.vdna.zip` on PC A, record its SHA-256/entries/thumbnail state, place it at PC B's fixed `/settings/soturineChaosRandomizer/vehicleDNA/inbox/import.vdna.zip`, review preview/dependencies/privacy, confirm import, and prove the local ID is unique while origin ID/importedAt survive.
6. With matching game/content, run Exact preflight and Restore Exact; record every phase hook, final strict read-back, seed, duration, logs, and screenshot.
7. Remove or change one optional dependency, rerun Compatible preflight, confirm the visible deviation, and validate the reported partial result.
8. Remove a required/core dependency and prove Exact blocks before writes.
9. Corrupt a disposable copy of the primary library and validate last-known-good recovery without overwriting the evidence.
10. Repeat locks/reroll/mutation/compare/gallery, restore/replay/Undo, manual vehicle/map/mod changes, cancellation, busy lock, resizing, keyboard/controller focus, and copy/import limits.
11. Inspect `beamng.log`; no fatal Lua/JavaScript error or unexplained timeout may remain.

## Beta publication gate

The gate requires all applicable alpha interactive cases Passed, exact attached-asset hash verification, at least one successful cross-PC Exact and `.vdna.zip` case with matching content, compatible/partial evidence with changed content, restart/corruption recovery evidence, UI scaling/input evidence, repeated-operation stress, and a documented clean log. Any Pending blocker forbids a beta tag/release. Published alpha artifacts remain evidence-gathering software and are not promoted in place.

The alpha release workflow validates tag/VERSION identity, package/checksum/manifest consistency, and refuses release overwrite. `.github/workflows/beta-readiness.yml` is manual and non-publishing: it runs the full Ubuntu suite, portable Windows static/package checks, builds both artifacts, and requires byte-identical ZIP/checksum/manifest outputs. A green run still does not satisfy this interactive gate. Cross-platform artifact comparison and beta notes must be recorded from the actual final beta commit—not inferred from alpha builds.
