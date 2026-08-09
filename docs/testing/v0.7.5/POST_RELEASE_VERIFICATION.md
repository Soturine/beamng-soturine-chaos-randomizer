# v0.7.5 post-release verification

Recorded on 2026-08-09. This is publication evidence, not live BeamNG evidence.

## Release identity

| Field | Verified value |
| --- | --- |
| Release | <https://github.com/Soturine/beamng-soturine-chaos-randomizer/releases/tag/v0.7.5> |
| Channel | GitHub prerelease, not draft |
| Tag | annotated `v0.7.5` |
| Tag object | `51ddf1ab969f8e7cff3c6e4b630405e2a2226fc5` |
| Package/tag commit | `e63467a00914df982fd178aea0d1b3389a3630de` |
| v0.7.4 tag commit, unchanged | `050aba81786f6d8f69468f382ea7e47a7faf12c5` |

The post-tag commits on `main` contain evidence/documentation only. The v0.7.5
tag was not moved after publication.

## Published assets

| Asset | Bytes |
| --- | ---: |
| `soturine_chaos_randomizer_0.7.5.zip` | 492976 |
| `soturine_chaos_randomizer_0.7.5.zip.sha256` | 102 |
| `soturine_chaos_randomizer_0.7.5.manifest.json` | 2875 |

ZIP SHA-256:
`7b30caf18033b881739e3b4ee204cb6a9a1f25bbeb479399ea75b3e4682cebdc`.

## Downloaded-asset checks

All three assets were downloaded from the release into a fresh system temporary
directory. The checks below used the downloaded files rather than `dist/`:

1. the computed ZIP SHA matched the `.zip.sha256` file;
2. the computed ZIP SHA and byte size matched the manifest;
3. the manifest reported version `0.7.5`, tag `v0.7.5`, 208 entries and the
   package/tag commit above;
4. `python tools/validate_package.py <downloaded-zip>` passed;
5. the archive root contained the allowlisted runtime roots/files only;
6. `VERSION` was `0.7.5`, and `LICENSE` plus `NOTICE` were present;
7. en-US, pt-BR and es-ES locale metadata were present;
8. no wrapper directory, `node_modules`, source maps, `.git` data or other junk
   was present;
9. the extracted Vue module and style graphs passed with no missing runtime
   imports/assets;
10. GitHub Actions runs
    [31334200283](https://github.com/Soturine/beamng-soturine-chaos-randomizer/actions/runs/31334200283)
    and
    [31334290359](https://github.com/Soturine/beamng-soturine-chaos-randomizer/actions/runs/31334290359)
    completed successfully.

Live BeamNG.drive 0.39.4 validation: **Pending owner validation**. No gameplay,
renderer, controller, UI-scale, safe-zone, language-rendering or performance
approval is inferred from these checks.
