# v0.7.5 live results

Authoritative status: **Pending owner validation; not executed**.

| Field | Value |
| --- | --- |
| Release version | 0.7.5 |
| Validation owner | repository owner |
| BeamNG target | 0.39.4 |
| Required artifact | downloaded GitHub prerelease ZIP |
| Release URL | `https://github.com/Soturine/beamng-soturine-chaos-randomizer/releases/tag/v0.7.5` |
| ZIP | `soturine_chaos_randomizer_0.7.5.zip` |
| Bytes | 492976 |
| Entries | 208 |
| SHA-256 | `7b30caf18033b881739e3b4ee204cb6a9a1f25bbeb479399ea75b3e4682cebdc` |
| Package/tag commit | `e63467a00914df982fd178aea0d1b3389a3630de` |

| Result | Count |
| --- | ---: |
| Executed | 0 |
| Passed | 0 |
| Failed | 0 |
| Pending | 47 |
| Blocked | 0 |

| Group | Cases | Status |
| --- | ---: | --- |
| UI | 10 | Pending owner validation |
| Random Car | 5 | Pending owner validation |
| Scramble | 4 | Pending owner validation |
| Full Random | 5 | Pending owner validation |
| Events with player | 9 | Pending owner validation |
| Spectator | 4 | Pending owner validation |
| Regeneration | 3 | Pending owner validation |
| AI | 7 | Pending owner validation |

No v0.7.5 gameplay, renderer, controller, UI-scale, safe-zone, performance,
third-party vehicle, Preview, AI or multiplayer case has passed live.

## Published-asset verification

On 2026-08-09, the GitHub prerelease assets were downloaded into a fresh
temporary directory. The downloaded ZIP passed `tools/validate_package.py`;
its computed SHA-256 matched both the checksum file and manifest, and its size,
entry count, version, tag and commit matched the published manifest. The
release contains exactly the ZIP, `.zip.sha256` and manifest assets.

GitHub Actions run
<https://github.com/Soturine/beamng-soturine-chaos-randomizer/actions/runs/31334200283>
completed successfully for the package/tag commit. This is publication and
automated evidence only; it does not change the live case counts above.
The complete checklist is in
[POST_RELEASE_VERIFICATION.md](POST_RELEASE_VERIFICATION.md).
