#!/usr/bin/env python3
"""Run the non-gating synthetic Lua benchmarks and print one JSON report.

    python tools/lua_benchmarks.py [--output report.json]

profile.lua measures indexing, slot scanning and planning at scale;
benchmark_v069.lua measures the hot helpers (polling, buffers, UI diff,
dimension cache, index rebuild). These are CPU microbenchmarks of the mod's
own Lua; they make no FPS or live-gameplay claim.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import re
import sys

try:
    from tools.lua_metrics import run_lua_file
except ModuleNotFoundError:  # Direct execution: python tools/lua_benchmarks.py
    from lua_metrics import run_lua_file


ROOT = Path(__file__).resolve().parents[1]
PROFILE_LINE = re.compile(r"^SCR_PROFILE (.+)$", re.MULTILINE)
BENCH_LINE = re.compile(
    r"^SCR_V069_BENCH\|([^|]+)\|(\d+)\|([\d.]+)\|([\d.]+)\|([\d.]+)\|([\d.]+)\|([\d.]+)\|(\d+)\|(\d+)\|(\d+)\s*$",
    re.MULTILINE,
)


def run_profile() -> dict[str, float]:
    code, output = run_lua_file(ROOT, "profile.lua")
    match = PROFILE_LINE.search(output)
    if code != 0 or not match:
        raise RuntimeError("Profile fixture did not complete:\n" + output)
    return {key: float(value) for key, value in (pair.split("=", 1) for pair in match.group(1).split())}


def run_hot_paths() -> list[dict[str, int | float | str]]:
    code, output = run_lua_file(ROOT, "benchmark_v069.lua")
    rows = BENCH_LINE.findall(output)
    if code != 0 or "SCR_V069_BENCH_OK 11" not in output or len(rows) != 11:
        raise RuntimeError("Hot-path benchmark did not complete:\n" + output)
    return [{
        "scenario": row[0], "iterations": int(row[1]),
        "totalMs": float(row[2]), "meanMs": float(row[3]),
        "p50Ms": float(row[4]), "p95Ms": float(row[5]), "p99Ms": float(row[6]),
        "bufferReuses": int(row[7]), "guihooksCount": int(row[8]), "diagnosticCount": int(row[9]),
    } for row in rows]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--output", type=Path, help="optional JSON output path")
    args = parser.parse_args()
    report = {
        "kind": "synthetic-lua-microbenchmark",
        "fpsClaim": False,
        "profile": run_profile(),
        "hotPaths": run_hot_paths(),
    }
    encoded = json.dumps(report, indent=2, sort_keys=True)
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(encoded + "\n", encoding="utf-8", newline="\n")
    print(encoded)
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (FileNotFoundError, RuntimeError) as error:
        print(error, file=sys.stderr)
        raise SystemExit(1)
