# Multi-PC and Beta Gate Testing

This checklist prepares `0.4.0-beta.1`; it is not evidence that the beta gate passed. Do not change VERSION, create `v0.4.0-beta.1`, or publish a beta prerelease until the exact alpha ZIP has real results.

## Required machines

- PC A and PC B with documented OS, BeamNG full build, active user folder, enabled-mod inventory, and randomizer commit.
- At least one clean 0.38.6 profile.
- The exact attached `soturine_chaos_randomizer_0.4.0-alpha.2.zip`, verified against its attached `.sha256` on both machines.

## Required evidence

1. Install the ZIP without extracting it and confirm Mod Manager/UI loading.
2. Create and explicitly save DNA on PC A from official, deep-tree, tuning-rich, and multi-paint content.
3. Restart BeamNG and prove the library survives with the same entry/fingerprints.
4. Export/copy JSON, transfer only that JSON to PC B, import it, and compare schema/fingerprints.
5. With matching game/content, run Exact preflight and Restore Exact; record every phase hook, final strict read-back, seed, duration, logs, and screenshot.
6. Remove or change one optional dependency, rerun Compatible preflight, confirm the visible deviation, and validate the reported partial result.
7. Remove a required/core dependency and prove Exact blocks before writes.
8. Corrupt a disposable copy of the primary library and validate last-known-good recovery without overwriting the evidence.
9. Repeat restore/replay/Undo, manual vehicle/map/mod changes, cancellation, busy lock, resizing, keyboard/controller focus, and copy/import limits.
10. Inspect `beamng.log`; no fatal Lua/JavaScript error or unexplained timeout may remain.

## Beta publication gate

The gate requires all applicable alpha interactive cases Passed, exact attached-asset hash verification, at least one successful cross-PC Exact case with matching content, compatible/partial evidence with changed content, restart/corruption recovery evidence, UI scaling/input evidence, repeated-operation stress, and a documented clean log. Any Pending blocker forbids the beta tag/release. Published `0.4.0-alpha.2` remains evidence-gathering software and is not promoted in place.

The alpha release workflow validates tag/VERSION identity, package/checksum/manifest consistency, and refuses release overwrite. `.github/workflows/beta-readiness.yml` is manual and non-publishing: it runs the full Ubuntu suite, portable Windows static/package checks, builds both artifacts, and requires byte-identical ZIP/checksum/manifest outputs. A green run still does not satisfy this interactive gate. Cross-platform artifact comparison and beta notes must be recorded from the actual final beta commit—not inferred from alpha builds.
