#!/usr/bin/env python3
"""Snapshot the BeamNG Runtime UI host exports the app may import.

    python tools/snapshot_host_exports.py <BeamNG.drive install> tools/beamng_host_exports.json

Run after a BeamNG update; validate_vue_module_graph.mjs rejects any import of
a host name missing from the snapshot.
Directives and base components are exported by generated index files built
from file names (common/directives/Bng*.js -> vBng*, base/bng*.vue -> Bng*);
the three service modules export named functions read from their source.
"""
import json
import re
import sys
from pathlib import Path

game = Path(sys.argv[1])
src = game / "ui" / "ui-vue" / "src"
directives = sorted("v" + p.stem for p in (src / "common" / "directives").glob("Bng*.js"))
components = sorted("B" + p.stem[1:] for p in (src / "common" / "components" / "base").glob("bng*.vue"))


def named_exports(path):
    text = path.read_text(encoding="utf-8")
    names = set(re.findall(r"export\s+(?:async\s+)?(?:function|const|let|class)\s+([A-Za-z_$][\w$]*)", text))
    for group in re.findall(r"export\s*\{([^}]*)\}", text):
        for item in group.split(","):
            parts = item.strip().split(" as ")
            if parts[0]:
                names.add(parts[-1].strip())
    return sorted(names)


bridge = next(p for p in (src / "bridge").glob("index.*"))
# The launcher records the installed build here (Windows user folder).
version = (Path.home() / "AppData/Local/BeamNG/BeamNG.drive.ini").read_text(encoding="utf-8-sig")
snapshot = {
    "source": "BeamNG.drive ui/ui-vue/src",
    "beamngVersion": re.search(r"version = (\S+)", version).group(1),
    "exports": {
        "@/bridge": named_exports(bridge),
        "@/services/events": named_exports(src / "services" / "events.js"),
        "@/services/settings": named_exports(src / "services" / "settings.js"),
        "@/common/directives": directives,
        "@/common/components/base": sorted(set(components) | set(named_exports(src / "common" / "components" / "base" / "index.js"))),
    },
}
Path(sys.argv[2]).write_text(json.dumps(snapshot, indent=2) + "\n", encoding="utf-8")
print({key: len(value) for key, value in snapshot["exports"].items()}, snapshot["beamngVersion"])
