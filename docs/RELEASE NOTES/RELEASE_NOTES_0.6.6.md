# Soturine's Chaos Randomizer 0.6.6

Status: **Experimental prerelease**.

Version 0.6.6 is published for additional live validation. Pending interactive
cases remain documented and are not represented as successful gameplay tests.

Automated validation: Passed

Live BeamNG validation: Pending owner validation

Live cases: 0 executed / 0 passed / 0 failed / 99 pending / 0 blocked

## Main corrections

- Separates original player, selected candidate, clean baseline, last accepted
  generated result, and current mutation attempt.
- Prefers the last accepted result during recovery and gives critical-part
  protection precedence over optional missing-part freedom.
- Requires coherent generation/ID-bound tree, tuning, powertrain and energy
  evidence, including two stable samples where applicable.
- Repairs exact critical dependency paths before full rollback while retaining
  unrelated randomized parts, tuning and paint.
- Separates fuel, engine oil and coolant evidence and classifies combustion,
  electric, hybrid, trailer, prop and intentional shell targets.
- Spawns and retains one independent managed ID per Race competitor and makes
  Placement reorder and reposition the existing managed vehicles.
- Warns about BeamLR and Driver Assistance without disabling third-party mods.
- Preserves responsive tab sizing and replaces the ambiguous mark with the
  original fox SVG plus transparent 24/32/48/250×120 PNG assets.

## Automated validation

- Python: 60 tests and 904 subtests.
- Lua: 366 executed cases, 7,911 assertions and 451 requirement mappings.
- JavaScript: syntax validation plus 27 UI checks.
- Package, checksum, manifest, version, assets and prerelease gate: Passed.
- Reproducibility: three independent builds with identical bytes and SHA-256.

These results are not a claim that all behavior was proven in a running BeamNG
world. The 99 interactive cases remain available in the versioned live plan.

## Installation

1. Remove or disable older Chaos Randomizer ZIPs.
2. Clear BeamNG UI/mod cache if an old app or asset remains visible.
3. Install only `soturine_chaos_randomizer_0.6.6.zip` from this release without
   extracting it.
4. Keep only one version active and add the UI App in BeamNG.
5. Report conflicts with `beamng.log`, diagnostics, seed, vehicle/configuration,
   map, mod list and the exact ZIP SHA-256.

## Integrity

- ZIP: `soturine_chaos_randomizer_0.6.6.zip`
- Bytes: `342933`
- SHA-256: `bac1d6026bc758bd0ffd419b83cfa6456fe14e7e0ab4b8c236d835ac4efb5278`
- Commit: recorded in `release-manifest.json`
- Tag: `v0.6.6`
- Target: BeamNG.drive `0.38.6.0.19963`
