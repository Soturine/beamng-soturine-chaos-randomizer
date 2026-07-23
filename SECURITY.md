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
- a reproducible denial-of-service caused by an unbounded project loop.

Ordinary randomization outcomes—an undrivable vehicle, a third-party part that fails to load, visual breakage, or a compatibility regression after a BeamNG update—are normally bugs rather than security vulnerabilities unless they cross a trust or data boundary.

## Project safeguards

The in-game package has no network dependency, remote scripts, analytics, or credential handling. UI settings are serialized with BeamNG's bridge, engine actions use fixed method names, mutation passes/timeouts are bounded, and package paths are validated against traversal, backslashes, duplicates, symlinks, and development content.

No response or disclosure deadline is guaranteed for this volunteer alpha project, but valid reports will be assessed as promptly as practical.
