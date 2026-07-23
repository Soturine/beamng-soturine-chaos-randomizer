# Vehicle DNA Schema v1

The canonical format is `SoturineVehicleDNA`, the internal kind is `soturineVehicleDNA`, `schemaVersion` is `1`, and generator version is `4` at both the top level and in `generation`. Future schema versions are rejected as read-only/unsupported rather than partially interpreted.

```json
{
  "format": "SoturineVehicleDNA",
  "kind": "soturineVehicleDNA",
  "schemaVersion": 1,
  "generatorVersion": 4,
  "id": "dna-...",
  "name": "Vehicle DNA",
  "description": "",
  "createdAt": 0,
  "updatedAt": 0,
  "favorite": false,
  "tags": [],
  "environment": {
    "beamNGVersion": "0.38.6.0",
    "extensionVersion": "0.4.0-alpha.1",
    "targetBeamNG": "0.38.6.0.19963",
    "schemaVersion": 1,
    "generatorVersion": 4
  },
  "generation": {
    "generatorVersion": 4,
    "operation": "fullRandom",
    "seed": "SCR4-XXXX-XXXX",
    "settings": {},
    "selectionContext": {},
    "recentPolicy": "ignored_for_manual_seed",
    "blacklistPolicy": "session_state_recorded_not_replayed",
    "suspectPolicy": "session_state_recorded_not_replayed",
    "startingStateFingerprint": "scrfp1-..."
  },
  "operation": "fullRandom",
  "seed": {"display": "SCR4-XXXX-XXXX", "legacy": false},
  "base": {
    "modelKey": "model",
    "configKey": "config",
    "configPath": "/vehicles/model/config.pc",
    "configName": "Base configuration",
    "registryIdentity": true,
    "sourceKind": "official",
    "sourceLabel": "BeamNG - Official",
    "sourceStrategy": "explicit_official"
  },
  "final": {
    "modelKey": "model",
    "configIdentity": "/vehicles/model/config.pc",
    "slots": [
      {
        "path": "/slot/",
        "slotId": "slot",
        "parentPath": null,
        "parentPart": "root",
        "partName": "selected_part",
        "defaultPart": "default_part",
        "sourceKind": "official",
        "sourceLabel": "BeamNG - Official",
        "required": false,
        "coreSlot": false,
        "resolutionStrategy": "exact_path_slot_parent"
      }
    ],
    "tuning": [
      {
        "name": "variable",
        "value": 0,
        "minimum": -1,
        "maximum": 1,
        "default": 0,
        "step": 0.1
      }
    ],
    "paints": [
      {
        "baseColor": [0, 0, 0, 1],
        "metallic": 0,
        "roughness": 0.5,
        "clearcoat": 1,
        "clearcoatRoughness": 0
      }
    ]
  },
  "safety": {},
  "warnings": [],
  "metrics": {},
  "dependencies": {
    "baseConfiguration": {},
    "parts": [],
    "wheelTire": [],
    "mods": [],
    "official": [],
    "user": [],
    "unknown": []
  },
  "fingerprints": {
    "settings": "scrfp1-...",
    "environment": "scrfp1-...",
    "base": "scrfp1-...",
    "final": "scrfp1-...",
    "dependencies": "scrfp1-..."
  },
  "validation": {
    "status": "captured",
    "source": "fresh_post_operation_readback",
    "interactive": false
  },
  "lineage": {}
}
```

The example uses `null` only to explain optional JSON fields; Lua omits non-applicable keys in generated entries. `final.slots` is the project-owned normalized slot array, never a raw `getConfig()` table. Paints contain only supported fields. Dependencies contain identities/labels, not third-party bytes. Unknown imported top-level fields are discarded, with `extensions` reserved for bounded JSON-only future data.

Strict equality is field-based. `fingerprints.final` is used for change detection and diagnostics but never substitutes for slot, tuning, and paint read-back.
