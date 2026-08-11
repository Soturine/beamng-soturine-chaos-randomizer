# Generated fox asset

Status: **Automated validated; visual approval Pending owner validation**.

The primary fox was generated as a raster image with the Codex `imagegen`
capability. It was not drawn or synthesized as SVG/code. The generation prompt
was:

> Create a polished game UI mascot asset for "Soturine's Chaos Randomizer": a
> centered, front-facing angular fox head and upper bust, energetic, confident,
> slightly aggressive but friendly enough for a game utility. Strong instantly
> recognizable fox silhouette with expressive eyes, crisp ears, layered fur,
> and subtle automotive/performance/technology cues such as speed-cut shapes
> and restrained mechanical cheek panels. Warm orange fur, white muzzle and
> chest accents, charcoal shadows, very small controlled red accents. High-detail
> professional digital raster illustration, clean hard-edged rendering, readable
> at 24–32 px, generous padding on all sides, centered and symmetrical overall
> while retaining organic detail. No text, no letters, no logo lockup, no
> watermark, no border, no scenery, no ground, no cast shadow. Put the mascot on
> a perfectly flat solid #00ff00 chroma-key background. Absolutely no green
> anywhere on the fox, its accents, highlights, eyes, reflections, or shadows.
> Square 1024×1024 composition.

The generated source was chroma-keyed with the image-generation skill's
`remove_chroma_key.py`, then resized deterministically with Lanczos filtering.
The static runtime outputs are:

- `assets/branding/fox-1024.png`
- `assets/branding/fox-256.png`
- `assets/branding/fox-64.png`
- `app.png`, a transparent 250×120 selector image derived from the same fox

The package gate verifies PNG signatures, exact dimensions, non-interlaced
8-bit RGBA encoding, both transparent and opaque pixels, imports, packaged
presence, and absence of the superseded vector/marker assets. Builds package
these committed binaries and do not regenerate them.
