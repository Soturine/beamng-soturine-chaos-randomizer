# Bounded Gallery

Garage cards use paginated summaries, grid/list views, search, filters, sort, pins, favorites, rating, tags, collection, notes, lineage, compatibility status, and timestamps. Full Vehicle DNA details are emitted only after an explicit details request; thumbnail bytes and full DNA are not included in periodic public state.

## Managed images

Installed BeamNG 0.38.6 source proves the optional `render_renderViews.takeScreenshot` and `util_screenshotCreator.frameVehicle` chain. Capture therefore occurs only after an explicit button press, only when the loaded model matches the DNA, and only under the adapter-owned thumbnail directory.

The captured PNG is re-read and accepted only at or below 500x281 and 256 KiB. IDs are normalized to a 96-character `[A-Za-z0-9_-]` basename, managed images are capped at 100, a capture replaces the same DNA's prior image, deletion removes it best-effort, and deleting DNA cleans its managed image. Cards load only the current page's image URLs. A missing file falls back in the UI.

When capture is unavailable or no image was requested, a deterministic inert fallback uses the model label plus source/primary-paint metadata. Imported JSON cannot supply a local thumbnail path. The project never copies a thumbnail, texture, screenshot, JBeam, or other asset out of an installed mod.

An explicitly captured managed image may be included as the optional `thumbnail.png` in a share package only after the same PNG bounds are revalidated. No third-party thumbnail is discovered or copied automatically.
