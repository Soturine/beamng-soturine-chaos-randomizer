# v0.7.7 post-release verification

Recorded on 2026-08-13 local time / 2026-08-14 UTC. This is publication and
package evidence, not live BeamNG evidence.

## Release identity

| Field | Verified value |
| --- | --- |
| Release | <https://github.com/Soturine/beamng-soturine-chaos-randomizer/releases/tag/v0.7.7> |
| Published | 2026-08-14 01:10:14 UTC |
| Channel | GitHub prerelease, not draft |
| Tag | annotated `v0.7.7` |
| Tag object | `ea922fd1af3f82f7f9c064b8a8e951f83491ba40` |
| Package/tag commit | `b85780f79dfc323db3ee6cf675e8b150fce3c211` |
| Workflow | [Package and prerelease run 31759678653](https://github.com/Soturine/beamng-soturine-chaos-randomizer/actions/runs/31759678653) - passed |

This post-tag documentation commit does not change or move the published tag.

## Published assets

| Asset | Bytes | GitHub/computed digest |
| --- | ---: | --- |
| `soturine_chaos_randomizer_0.7.7.zip` | 1,427,722 | `sha256:466e01b616330c3c923836cb325a1fdc6c880bfaf410ceb046bad1e55edee475` |
| `soturine_chaos_randomizer_0.7.7.zip.sha256` | 102 | `sha256:0b1dc6b9b403f78959d475b3d9474c892c10f2897138905b9ec09eba64d3ddd8` |
| `soturine_chaos_randomizer_0.7.7.manifest.json` | 2,880 | `sha256:b8a5a4b45cc165f6e31376c46afa33c99b57a7b91d2761762bc9db3ac336e71d` |

The release contains exactly these three assets. GitHub source archives are not
supported mod packages.

## Downloaded-asset checks

All assets were downloaded after publication into a new system temporary
directory and validated independently from repository `dist/`:

1. the computed ZIP SHA matched the checksum file, GitHub digest, downloaded
   manifest and local deterministic candidate;
2. the ZIP byte size matched GitHub and manifest metadata;
3. the manifest reported version `0.7.7`, tag `v0.7.7`, branch `main`, 209
   entries and the exact package/tag commit;
4. `python tools/validate_package.py <downloaded-zip>` passed;
5. archive roots were allowlisted and contained no wrapper, `node_modules`,
   development files, source maps, nested ZIP or temporary content;
6. `VERSION`, `COMPATIBILITY.json`, `LICENSE` and `NOTICE` were present and
   consistent;
7. generated transparent fox 1024/256/64 PNGs and the 250x120 selector PNG
   passed package validation; no procedural replacement was introduced;
8. en-US, pt-BR and es-ES host/app locales were packaged;
9. extracted Vue graphs passed with 88 files, 245 imports, one Runtime CSS and
   one local asset reference;
10. the annotated tag resolved remotely to the exact manifest/package commit.

Live BeamNG 0.39.4.x validation: **Pending owner validation**. No gameplay,
renderer, controller, UI-scale, safe-zone, language-rendering, third-party
compatibility or performance approval is inferred from these checks.

