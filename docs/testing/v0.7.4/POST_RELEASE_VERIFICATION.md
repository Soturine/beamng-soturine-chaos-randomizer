# v0.7.4 post-release verification

Verified on 2026-08-08 after GitHub Actions run
`https://github.com/Soturine/beamng-soturine-chaos-randomizer/actions/runs/31280570551` completed successfully.

## Release identity

| Field | Value |
| --- | --- |
| Release | `v0.7.4 — Live-derived stabilization` |
| URL | `https://github.com/Soturine/beamng-soturine-chaos-randomizer/releases/tag/v0.7.4` |
| Draft | No |
| Prerelease | Yes |
| Annotated tag commit | `050aba81786f6d8f69468f382ea7e47a7faf12c5` |
| Tag in `origin/main` history | Yes |
| Historical `v0.7.3` commit | `239e576d41935d975a6f58bac3d458716755b603` (unchanged) |

## Downloaded assets

| Asset | Bytes | SHA-256 / declared identity |
| --- | ---: | --- |
| `soturine_chaos_randomizer_0.7.4.zip` | 480,381 | `0d153aa421ab68c5ad87bec8882459f51e3271c8da6a14dd20a46997f80cdb9a` |
| `soturine_chaos_randomizer_0.7.4.zip.sha256` | 102 | Declares the ZIP hash above |
| `soturine_chaos_randomizer_0.7.4.manifest.json` | 2,876 | Manifest v3; commit/tag/ZIP hash above; 201 entries |

The release ZIP digest equals the independently generated Windows ZIP and the
GitHub asset digest. `validate_package.py` passed directly against the downloaded
ZIP and adjacent downloaded checksum/manifest. Internal checks confirmed
`VERSION=0.7.4`, `COMPATIBILITY.modVersion=0.7.4`, BeamNG target 0.39.4,
`LICENSE`, `NOTICE`, en-US/pt-BR/es-ES locale roots, and zero forbidden docs,
tests, `node_modules`, source maps, screenshots, nested ZIPs, or Git files.

The auxiliary manifest metric `tests.jsonFiles` reflects development-environment
inventory (206 in the clean Linux workflow and 215 in the Windows workspace);
release-critical manifest fields, ZIP identity, test counts, tag/commit, and
package contents match and validate. ZIP bytes and same-environment manifests
were reproducible across independent builds. Making auxiliary source inventory
independent of installed development metadata remains packaging-tool debt; it
does not change the published mod ZIP.

This verification executes no BeamNG gameplay case. Live BeamNG 0.39.4 status
remains **Pending owner validation**: 0 executed / 0 passed / 0 failed / 48
pending / 0 blocked.
