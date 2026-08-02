#!/usr/bin/env python3
"""Run the reproducible v0.6.9 synthetic Lua benchmark matrix."""

from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import uuid


ROOT = Path(__file__).resolve().parents[1]
BENCHMARK = ROOT / "tests" / "lua" / "benchmark_v069.lua"
LINE = re.compile(
    r"^SCR_V069_BENCH\|([^|]+)\|(\d+)\|([\d.]+)\|([\d.]+)\|([\d.]+)\|([\d.]+)\|([\d.]+)\|(\d+)\|(\d+)\|(\d+)\s*$",
    re.MULTILINE,
)


def find_console() -> Path:
    configured = os.environ.get("BEAMNG_CONSOLE")
    candidates = [
        Path(configured) if configured else None,
        Path(r"D:\SteamLibrary\steamapps\common\BeamNG.drive\Bin64\console.x64.exe"),
        Path(r"C:\Program Files (x86)\Steam\steamapps\common\BeamNG.drive\Bin64\console.x64.exe"),
    ]
    console = next((path for path in candidates if path and path.is_file()), None)
    if not console:
        raise FileNotFoundError("BeamNG Lua console not found; set BEAMNG_CONSOLE")
    return console


def run_benchmark() -> list[dict[str, int | float | str]]:
    console = find_console()
    game_root = console.parent.parent
    stage = game_root / f"scr_benchmark_v069_{os.getpid()}_{uuid.uuid4().hex[:8]}"
    if stage.parent.resolve() != game_root.resolve():
        raise RuntimeError("Benchmark staging path escaped the BeamNG root")
    try:
        shutil.copytree(ROOT / "lua", stage / "lua")
        shutil.copytree(ROOT / "tests" / "lua", stage / "tests" / "lua")
        bootstrap = stage / "benchmark_bootstrap.lua"
        virtual_root = "/" + stage.name
        bootstrap.write_text(
            "SCR_TEST_ROOT = " + json.dumps(virtual_root) + "\n"
            + "dofile(" + json.dumps(virtual_root + "/tests/lua/benchmark_v069.lua") + ")\n",
            encoding="utf-8",
            newline="\n",
        )
        result = subprocess.run(
            [str(console), "file", str(bootstrap)], cwd=game_root,
            text=True, capture_output=True, check=False,
        )
        output = result.stdout + result.stderr
        matches = LINE.findall(output)
        if result.returncode != 0 or "SCR_V069_BENCH_OK 11" not in output or len(matches) != 11:
            raise RuntimeError("Synthetic benchmark did not complete:\n" + output)
        rows = []
        for match in matches:
            rows.append({
                "scenario": match[0], "iterations": int(match[1]),
                "totalMs": float(match[2]), "meanMs": float(match[3]),
                "p50Ms": float(match[4]), "p95Ms": float(match[5]), "p99Ms": float(match[6]),
                "bufferReuses": int(match[7]), "guihooksCount": int(match[8]),
                "diagnosticCount": int(match[9]),
            })
        return rows
    finally:
        if stage.exists():
            if stage.parent.resolve() != game_root.resolve():
                raise RuntimeError("Refusing to remove an unexpected benchmark path")
            shutil.rmtree(stage)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, help="Optional JSON output path")
    args = parser.parse_args()
    result = {
        "kind": "synthetic-lua-microbenchmark",
        "version": "0.6.9",
        "fpsClaim": False,
        "rows": run_benchmark(),
    }
    encoded = json.dumps(result, indent=2, sort_keys=True)
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
