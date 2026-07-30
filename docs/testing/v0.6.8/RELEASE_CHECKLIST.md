# Release checklist — v0.6.8

## Source and evidence

- [ ] `main` is clean, synchronized, and all intended commits are present.
- [ ] `VERSION`, app metadata, HTML fallback, release notes, and
  `COMPATIBILITY.json` all say 0.6.8.
- [ ] Python, Lua, Node syntax, JS checks, package validation, reproducibility,
  and prerelease gate pass from the final commit.
- [ ] Live report remains exactly 0 executed / 0 passed / 0 failed / 60 pending /
  0 blocked until the repository owner tests the downloaded asset.

## Artifact and publication

- [ ] Build `soturine_chaos_randomizer_0.6.8.zip` deterministically.
- [ ] Verify root layout, file count, ZIP size, and SHA-256.
- [ ] Verify `.zip.sha256` names the exact ZIP and matches its bytes.
- [ ] Verify `.manifest.json` includes all v0.6.8 required fields and matches the
  final commit, branch `main`, annotated tag `v0.6.8`, compatibility metadata,
  automated counts, and live counts.
- [ ] Push final `main`, create/push annotated `v0.6.8`, and create a non-draft
  prerelease with exactly the three required assets.
- [ ] Download all release assets into a fresh directory and re-verify name,
  size, SHA-256, manifest, and ZIP contents.

## Owner handoff

- [ ] Install only the downloaded ZIP on BeamNG 0.39.
- [ ] Execute L01–L60 and attach exact evidence.
- [ ] Keep failures visible and open follow-up issues; do not promote live
  compatibility while Pending, Failed, or Blocked is nonzero.
