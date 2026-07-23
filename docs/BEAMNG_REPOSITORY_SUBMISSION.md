# BeamNG Repository Submission Preparation

This is a preparation checklist, not evidence of submission or approval. No BeamNG Repository upload, Git tag, or GitHub Release has been created for this alpha.

## Proposed listing

- **Title:** Soturine's Chaos Randomizer
- **Short name:** Chaos Randomizer
- **Author:** Soturine
- **Version candidate:** `0.2.0-alpha.1`
- **Tagline:** Dynamic seeded vehicle, configuration, compatible-parts, tuning, wheel, and paint randomization.
- **Category:** UI Apps / Gameplay (choose the closest current Repository category at submission time)
- **License:** Apache License 2.0

Suggested description:

> Choose a complete installed configuration, scramble the current vehicle through BeamNG-reported compatible slots, or run the complete pipeline. A single Chaos slider controls bounded part, tuning, missing-part, and paint behavior. Includes deterministic seeds, content filters, phase-aware diagnostics, rollback, and Undo. Protect Critical Parts is a conservative metadata safeguard, not a drivability guarantee.

## Blocking work before submission

- Complete all applicable cases in [Testing](TESTING.md), including normal ZIP installation in a clean 0.38 profile.
- Resolve all console errors attributable to the mod.
- Validate official vehicles plus representative config, vehicle, part, and wheel mods with permission-safe test content.
- Confirm UI layout, overflow, keyboard focus, common scaling, and app-selector preview.
- Capture representative original screenshots with no private/paid content.
- Confirm the supported BeamNG version immediately before upload.
- Review current Repository rules, allowed categories/tags, image dimensions, file-size limits, and moderation requirements.
- Decide explicitly whether `0.2.0-alpha.1` is ready to tag/release; do not infer that decision from the `VERSION` file alone.

## Package checklist

- [ ] Build with `python tools/package_mod.py`.
- [ ] Validate with `python tools/validate_package.py`.
- [ ] Install the exact generated ZIP without extracting it.
- [ ] Confirm `lua/`, `ui/`, and `settings/` are ZIP roots.
- [ ] Confirm no `.git`, `.github`, `docs`, `tests`, `tools`, `dist`, caches, logs, or machine paths are present.
- [ ] Confirm `LICENSE`, `NOTICE`, and `VERSION` are present.
- [ ] Confirm the SHA-256 file matches the uploaded ZIP.
- [ ] Confirm the in-game title is **Soturine's Chaos Randomizer**.

BeamNG's mod manager recognizes Repository-generated `mod_info/<id>/info.json` metadata when present. Do not invent a Repository resource ID or server fields before the platform assigns/provides them. Recheck the current submission workflow and use platform-generated metadata where required.

## Media checklist

- [ ] App icon is original and legible as a small selector thumbnail.
- [ ] Main screenshot shows the compact default panel.
- [ ] Advanced screenshot shows filters, seed, Undo, and index state.
- [ ] Gameplay screenshots show both plausible and high-Chaos outcomes.
- [ ] Images contain no copied artwork, brand impersonation, or unlicensed private mod content.
- [ ] Captions accurately label Alpha limitations.

## Description accuracy checklist

- [ ] Do not promise guaranteed drivability.
- [ ] Do not claim support for BeamNG versions not tested.
- [ ] Do not claim every mod is compatible.
- [ ] State that skin/paint-design selection is not yet implemented.
- [ ] State that seeds require unchanged inputs.
- [ ] State that the project is independent and not endorsed by BeamNG GmbH.

## License and attribution

The package contains original project code and an original generated icon under the repository's Apache-2.0 license. Historical randomizers informed behavior research only; their code/assets are not included. Preserve `LICENSE` and `NOTICE` in the submission archive.

## After acceptance

Record the assigned resource ID, approved version, listing URL, exact ZIP SHA-256, supported BeamNG build, and submission date in the changelog/release notes. Keep GitHub and Repository descriptions aligned without claiming later compatibility until it is tested.
