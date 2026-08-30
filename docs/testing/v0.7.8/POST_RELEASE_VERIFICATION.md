# v0.7.8 post-release verification

Verified on 2026-08-24 UTC against the public experimental prerelease:
<https://github.com/Soturine/beamng-soturine-chaos-randomizer/releases/tag/v0.7.8>.

## Publication identity

| Field | Verified value |
| --- | --- |
| Annotated tag | `v0.7.8` |
| Tag object | `3664e4e24e4ffb19b9443ba48d2ccc2e6fa11d39` |
| Peeled/package commit | `7316cc78e8d6831e03d073ae21adbb4140cc58a6` |
| Release state | public, prerelease, not draft |
| Published at | `2026-08-24T02:03:20Z` |
| Main CI | [32681592560](https://github.com/Soturine/beamng-soturine-chaos-randomizer/actions/runs/32681592560) - passed in 1m12s |
| Package and prerelease | [32681683251](https://github.com/Soturine/beamng-soturine-chaos-randomizer/actions/runs/32681683251) - package passed in 1m24s; release passed in 6s |

## Public assets

Only the supported three assets are attached:

| Asset | Bytes | GitHub SHA-256 digest |
| --- | ---: | --- |
| `soturine_chaos_randomizer_0.7.8.zip` | 1432154 | `c885b11ecaf1dbb32fc4ab7699f6529b6b431ef0a7a39676f6a82fcd980e8d4c` |
| `soturine_chaos_randomizer_0.7.8.zip.sha256` | 102 | `f58a87d3129655e0690f76c0ccf570f94049316250077770329d9be242a2e39f` |
| `soturine_chaos_randomizer_0.7.8.manifest.json` | 2877 | `34c8be81757b50c2278facd134459e228cafd3198c6d2f12e17dcbc8a9af169c` |

## Independent download checks

The three assets were downloaded again into a fresh temporary directory.
Their SHA-256 digests matched the local tagged candidates byte-for-byte. The
checksum named the exact ZIP and matched its content. The manifest reported:

- version `0.7.8`, tag `v0.7.8`, branch `main` and manifest schema 3;
- experimental-prerelease, published and `prerelease: true`;
- commit `7316cc78e8d6831e03d073ae21adbb4140cc58a6`;
- 210 entries, 1,432,154 bytes and the ZIP digest above;
- automated gates passed and seven live cases pending.

`tools/validate_package.py` accepted the downloaded ZIP, including its root,
version, checksum, manifest, extracted Vue module graph and Runtime CSS/assets.
The public and local ZIP, checksum and manifest hashes were identical.

This publication verification is not BeamNG gameplay, renderer, controller,
UI-scale, vehicle/mod, AI or performance validation. Live status remains
**Pending owner validation** for all seven v0.7.8 cases.
