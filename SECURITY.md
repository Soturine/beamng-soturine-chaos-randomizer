# Security Policy

## Supported versions

This project is pre-release software.

| Version | Security fixes |
| --- | --- |
| Current `main` / latest alpha | Supported on a best-effort basis |
| Older snapshots | Not supported |

## Reporting a vulnerability

Use GitHub's private **Report a vulnerability** / Security Advisory flow for this repository when available. Do not open a public issue for a vulnerability that could expose users, local files, or credentials before a fix is available.

Include:

- affected commit/version and BeamNG build;
- a concise impact statement;
- reproduction steps using non-sensitive test data;
- relevant logs with personal paths, tokens, and private mod details removed;
- any suggested mitigation.

Please do not include paid/private mod files, authentication tokens, full user-folder archives, or unrelated personal data.

## Scope

Security-relevant examples include:

- unsafe archive path handling in package tools;
- unintended network activity or analytics;
- command injection through UI-to-Lua settings/seed handling;
- local file access outside the documented BeamNG VFS/settings boundary;
- Vehicle DNA import escaping size/type/schema/fingerprint limits or selecting an arbitrary path/method;
- `.vdna.zip` traversal, duplicate/symlink, checksum/schema, hidden-payload, image, or decompression-limit bypass;
- a reproducible denial-of-service caused by an unbounded project loop.

Ordinary randomization outcomes—an undrivable vehicle, a third-party part that fails to load, visual breakage, or a compatibility regression after a BeamNG update—are normally bugs rather than security vulnerabilities unless they cross a trust or data boundary.

## Project safeguards

The in-game package has no network dependency, remote scripts, analytics, or credential handling. UI settings are serialized with BeamNG's bridge, engine actions use fixed method names, mutation/restore passes and timeouts are bounded, and package paths are validated against traversal, absolute drive/UNC paths, backslashes, duplicates, symlinks, and development content.

Vehicle DNA is untrusted data. Pasted input is capped at 128 KiB, parsed as JSON before bridge serialization, limited to JSON-safe finite values and bounded depth/elements/strings/slots/tuning/paints/tags, and validated against schema and field fingerprints. Unknown top-level fields are discarded except the bounded `extensions` area. Imports cannot provide a Lua/JavaScript method, network address, or arbitrary filesystem path. Storage and optional export use adapter-owned constant paths under `/settings/soturineChaosRandomizer/vehicleDNA/`; failed writes immediately attempt to restore the validated last-known-good primary.

Share ZIPs use a five-name allowlist and fixed inbox/export roots. The parser accepts only deterministic stored entries, bounds archive/entry/count/total sizes, requires contiguous local records and matching central metadata, rejects unsafe flags/paths/duplicates/symlinks, verifies CRC plus manifest SHA-256, requires matching schema/generator metadata, and validates optional PNG dimensions. Packages contain no mod bytes or executable content. Imported IDs become unique local IDs while preserving inert origin metadata.

Fingerprints are non-cryptographic change detectors. They are never treated as authentication, mod-file integrity, or a substitute for Exact field read-back.

No response or disclosure deadline is guaranteed for this volunteer alpha project, but valid reports will be assessed as promptly as practical.
