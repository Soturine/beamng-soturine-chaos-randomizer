# v0.7.6 post-release verification

Recorded on 2026-08-11. This is publication/package evidence, not live BeamNG evidence.

## Release identity

| Field | Verified value |
| --- | --- |
| Release | <https://github.com/Soturine/beamng-soturine-chaos-randomizer/releases/tag/v0.7.6> |
| Published | 2026-08-11 22:25:57 UTC |
| Channel | GitHub prerelease, not draft |
| Tag | annotated `v0.7.6` |
| Tag object | `b56a05868e415aa61592840a13811950d92399ed` |
| Package/tag commit | `9c0e745cedf865e981ca3929200e9be37f2358e4` |
| Workflow | [Package and prerelease run 31542278609](https://github.com/Soturine/beamng-soturine-chaos-randomizer/actions/runs/31542278609) - passed |
| v0.7.5 tag object, unchanged | `51ddf1ab969f8e7cff3c6e4b630405e2a2226fc5` |
| v0.7.5 tag commit, unchanged | `e63467a00914df982fd178aea0d1b3389a3630de` |

The post-tag commit on `main` contains status/evidence documentation only. The v0.7.6 tag was not moved after publication.

## Published assets

| Asset | Bytes | GitHub digest |
| --- | ---: | --- |
| `soturine_chaos_randomizer_0.7.6.zip` | 1413696 | `sha256:4b214affb13f4097812516c152f8544175680c42b54b5bff3c4f310a957767e5` |
| `soturine_chaos_randomizer_0.7.6.zip.sha256` | 102 | `sha256:82a7d73b06c53209f48ca56e19c8a4a3814fff0576259a075cbc2cf4564b68ea` |
| `soturine_chaos_randomizer_0.7.6.manifest.json` | 2880 | `sha256:2e21c0c237f5ebce7542d64a91b630cc44671ff421f9e054c42627116816c87f` |

The release contains exactly these three assets. GitHub source archives are not supported mod packages.

## Downloaded-asset checks

All three assets were downloaded from the release into a second fresh system temporary directory after publication. Checks used the downloaded files rather than `dist/`:

1. the computed ZIP SHA matched the `.zip.sha256` file, the GitHub asset digest and the local release candidate;
2. the computed ZIP SHA and byte size matched the downloaded manifest;
3. the manifest reported version `0.7.6`, tag `v0.7.6`, 208 entries and the exact package/tag commit above;
4. `python tools/validate_package.py <downloaded-zip>` passed;
5. the archive root contained only allowlisted runtime roots/files, with no wrapper directory, development dependencies, source maps, `.git` data or temporary content;
6. `VERSION`, `COMPATIBILITY.json`, `LICENSE` and `NOTICE` were present and consistent;
7. the generated 1024/256/64 fox PNGs and transparent 250x120 selector image passed package validation;
8. en-US, pt-BR and es-ES host locale metadata was present;
9. extracted Vue module/style graphs passed with 87 files, 240 imports, one Runtime CSS and one local asset reference;
10. the v0.7.5 annotated tag, target commit, prerelease state and three asset identities remained unchanged.

Live BeamNG.drive 0.39.4 validation: **Pending owner validation**. No gameplay, renderer, controller, UI-scale, safe-zone, language-rendering, third-party compatibility or performance approval is inferred from these checks.
