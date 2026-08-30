# v0.7.9 post-release verification

Verified on 2026-08-30 UTC against the public experimental prerelease:
<https://github.com/Soturine/beamng-soturine-chaos-randomizer/releases/tag/v0.7.9>.

## Publication identity

| Field | Verified value |
| --- | --- |
| Release title | `v0.7.9 — Race end-to-end stabilization` |
| Annotated tag | `v0.7.9` |
| Tag object | `d6640f25720712bd7577b978630360e4c24ab20d` |
| Peeled/package commit | `af60c787b5f3fdc26dad940d23e20f1bdf6f1b5e` |
| Release state | public, prerelease, not draft |
| Published at | `2026-08-30T22:49:13Z` |
| Main CI | [33340010334](https://github.com/Soturine/beamng-soturine-chaos-randomizer/actions/runs/33340010334) - passed in 1m15s |
| Package and prerelease | [33340091273](https://github.com/Soturine/beamng-soturine-chaos-randomizer/actions/runs/33340091273) - package passed in 1m21s; release passed in 9s |

## Public assets

Exactly the supported three assets are attached:

| Asset | Bytes | GitHub SHA-256 digest |
| --- | ---: | --- |
| `soturine_chaos_randomizer_0.7.9.zip` | 1439764 | `5dc38ab61bbd910f9e5ef8f7b7ef8f5126233909e6bd9e2abd71428ff93aa83c` |
| `soturine_chaos_randomizer_0.7.9.zip.sha256` | 102 | `cdc5f7fb36bd531ad7809bc752fb3c104f92f18e562cd7b09933faa8a0d7bf83` |
| `soturine_chaos_randomizer_0.7.9.manifest.json` | 2880 | `36d3050d07a31ab0ac6974b1e23efd388847fd55bdc438489d6f23112f4500b0` |

## Independent download checks

All three assets were downloaded into a fresh temporary directory after
publication. Every downloaded digest matched the local tagged candidate
byte-for-byte. The checksum named the exact ZIP and matched its content.

The downloaded manifest reports version `0.7.9`, tag `v0.7.9`, branch `main`,
manifest schema 3, package commit `af60c787b5f3fdc26dad940d23e20f1bdf6f1b5e`,
212 ZIP entries, 1,439,764 bytes and the ZIP digest above. It records 443 Lua
cases, 838 mappings, 14,261 assertions, 1,190 JavaScript checks and 15 pending
live cases.

`tools/validate_package.py` accepted the downloaded ZIP, including allowlisted
roots, version/legal metadata, transparent PNGs, locales and extracted
Vue/style graphs. `tools/validate_release_gate.py --channel prerelease` also
accepted the downloaded ZIP and adjacent public checksum/manifest.

This verification proves public artifact identity and package structure. It is
not BeamNG gameplay, renderer, controller, UI-scale, AI, vehicle/mod or
performance validation. All 15 v0.7.9 live cases remain **Pending owner
validation**.
