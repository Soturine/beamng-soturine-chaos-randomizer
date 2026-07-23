# Safe Vehicle DNA Sharing

Sharing transfers inert Vehicle DNA metadata and, optionally, one image explicitly captured by this mod. It never transfers a mod, JBeam, texture, script, sound, arbitrary local file, absolute path, or personal data.

## Formats

`.vdna.json` is a JSON envelope with `format=SoturineVehicleDNAShare`, `shareVersion=1`, and one schema-validated Vehicle DNA object. Copy is delivered as a one-off UI event so full DNA is not republished in periodic state. File export writes only:

```text
/settings/soturineChaosRandomizer/vehicleDNA/share/export.vdna.json
```

`.vdna.zip` is a deterministic stored ZIP with two to five allowlisted entries:

```text
manifest.json
vehicle.vdna.json
compatibility.json
thumbnail.png      # optional
README.txt
```

The archive is limited to 512 KiB, five entries, 256 KiB per entry, and 512 KiB total uncompressed. The importer rejects unknown names/extensions, traversal, slashes/backslashes, absolute paths, duplicates, encryption or unexpected flags, unsupported compression, local/central mismatch, gaps/hidden payloads, symlinks, CRC mismatch, manifest mismatch, SHA-256 mismatch, schema mismatch, over-limit PNGs, and bomb-shaped sizes. Package version 1 and payload/manifest schema identity are mandatory.

## Import flow

Pasted JSON is parsed in JavaScript before bridge serialization, capped at 131,072 characters, unwrapped, canonicalized, and schema-validated. Package import reads only the fixed inbox:

```text
/settings/soturineChaosRandomizer/vehicleDNA/inbox/import.vdna.zip
```

The user validates first, reviews dependency/compatibility metadata and checksum, then confirms. Storage creates a unique local ID while lineage preserves `originId`, `importedAt`, and the validation strategy. Optional image bytes are written only after archive/manifest/PNG validation and are removed if library persistence fails.

SHA-256 authenticates transfer integrity against the manifest; it is not a signature of the author or proof that two PCs have identical mods. Inspect dependencies and run preflight before restore.
