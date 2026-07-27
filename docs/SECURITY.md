# Security

Project vulnerability reporting and supported-version policy are maintained in the repository [SECURITY.md](../SECURITY.md).

The mod treats imported Vehicle DNA and Race data as inert, bounded data. UI method names come from a fixed allowlist. Package import rejects traversal, absolute paths, unknown entries, symlinks, encryption, malformed ZIP structures, CRC/SHA mismatch, oversized entries, and invalid PNG structure. Import and export use controlled paths; arbitrary pasted text cannot select a Lua method or local filename.

Do not include personal filesystem paths, private mod content, credentials, or redistributable third-party assets in diagnostics or issue reports. Public diagnostics redact common Windows user paths, but reporters should still review logs before sharing them.
