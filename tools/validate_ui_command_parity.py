"""Validate literal Runtime UI commands against both protocol registries."""

from __future__ import annotations

from pathlib import Path
import re
import sys


ROOT = Path(__file__).resolve().parents[1]
APP = ROOT / "ui/modules/apps/soturineChaosRandomizer"
BRIDGE = APP / "services/commandBridge.js"
BACKEND = ROOT / "lua/ge/extensions/soturineChaosRandomizer/main.lua"

RACE_COMMANDS = {
    "previewRaceGeneration", "createChaosLineup", "cancelRaceGeneration",
    "retryLineupPersistence", "renameLineupCompetitor", "reorderLineupCompetitor",
    "resolveLineupFailure", "exportChaosLineup", "importChaosLineup",
    "previewLineupSpawn", "startLineupSpawn", "cancelLineupSpawn",
    "removeManagedVehicle", "respawnManagedVehicle", "focusManagedVehicle",
    "placeAIDestination", "confirmAIDestination", "clearAIDestination",
    "addAIRoutePoint", "editAIRoute", "startManagedAI", "startAIQuickPreset",
    "pauseManagedAI", "resumeManagedAI", "stopManagedAI", "resetManagedAI",
    "setAIRecording",
}


def section(source: str, start: str, end: str) -> str:
    offset = source.find(start)
    if offset < 0:
        raise ValueError(f"missing section marker: {start}")
    limit = source.find(end, offset + len(start))
    if limit < 0:
        raise ValueError(f"missing section terminator: {end}")
    return source[offset:limit]


def main() -> int:
    bridge_source = BRIDGE.read_text(encoding="utf-8")
    backend_source = BACKEND.read_text(encoding="utf-8")
    bridge_block = section(bridge_source, "COMMAND_SCHEMAS", "const safeView")
    backend_block = section(backend_source, "production.uiCommandHandlers = {", "\n}\n\nM.dispatchUICommand")
    bridge_commands = set(re.findall(r"\b([A-Za-z][A-Za-z0-9_]*)\s*:\s*\[", bridge_block))
    backend_commands = set(re.findall(r"(?m)^\s{2}([A-Za-z][A-Za-z0-9_]*)\s*=", backend_block))
    emitted_commands: set[str] = set()
    for path in sorted(APP.rglob("*.vue")):
        source = path.read_text(encoding="utf-8")
        emitted_commands.update(re.findall(
            r"\b(?:[A-Za-z_$][A-Za-z0-9_$]*\.)*command\.send\s*\(\s*['\"]([A-Za-z][A-Za-z0-9_]*)['\"]",
            source,
        ))
        helper_forwards_command = re.search(
            r"(?:const\s+send\s*=\s*(?:async\s*)?(?:\([^)]*\bcommand\b[^)]*\)|\bcommand\b)|"
            r"function\s+send\s*\([^)]*\bcommand\b)",
            source,
        )
        if helper_forwards_command:
            emitted_commands.update(re.findall(
                r"(?<![.\w])send\s*\(\s*['\"]([A-Za-z][A-Za-z0-9_]*)['\"]", source
            ))

    failures: list[str] = []
    for label, missing in (
        ("UI commands missing from commandBridge", emitted_commands - bridge_commands),
        ("UI commands missing from backend handlers", emitted_commands - backend_commands),
        ("bridge commands missing from backend handlers", bridge_commands - backend_commands),
        ("required Race commands missing from commandBridge", RACE_COMMANDS - bridge_commands),
        ("required Race commands missing from backend handlers", RACE_COMMANDS - backend_commands),
    ):
        if missing:
            failures.append(f"{label}: {', '.join(sorted(missing))}")

    if failures:
        print("UI_COMMAND_PARITY_FAILED")
        for failure in failures:
            print(f"- {failure}")
        return 1
    print(
        "UI_COMMAND_PARITY_OK "
        f"emitted={len(emitted_commands)} bridge={len(bridge_commands)} "
        f"backend={len(backend_commands)} race={len(RACE_COMMANDS)}"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
