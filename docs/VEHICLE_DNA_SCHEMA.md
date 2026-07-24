# Vehicle DNA Schema v1

The canonical format is `SoturineVehicleDNA`, the internal kind is
`soturineVehicleDNA`, and `schemaVersion` remains `1`. New 0.6.0 entries record
generator version `6` at both the top level and in `generation`; generator-4/5
schema-v1 entries remain valid snapshots. Future schema versions are rejected
as read-only/unsupported rather than partially interpreted.

```json
{
  "format": "SoturineVehicleDNA",
  "kind": "soturineVehicleDNA",
  "schemaVersion": 1,
  "generatorVersion": 6,
  "id": "dna-...",
  "name": "Vehicle DNA",
  "description": "",
  "createdAt": 0,
  "updatedAt": 0,
  "favorite": false,
  "pinned": false,
  "rating": 0,
  "notes": "",
  "collection": "",
  "sortOrder": 0,
  "tags": [],
  "environment": {
    "beamNGVersion": "0.38.6.0",
    "extensionVersion": "0.6.0",
    "targetBeamNG": "0.38.6.0.19963",
    "schemaVersion": 1,
    "generatorVersion": 6
  },
  "generation": {
    "generatorVersion": 6,
    "operation": "fullRandom",
    "seed": "SCR6-XXXX-XXXX",
    "settings": {},
    "selectionContext": {},
    "recentPolicy": "ignored_for_manual_seed",
    "blacklistPolicy": "session_state_recorded_not_replayed",
    "suspectPolicy": "session_state_recorded_not_replayed",
    "startingStateFingerprint": "scrfp1-..."
  },
  "operation": "fullRandom",
  "seed": {"display": "SCR6-XXXX-XXXX", "legacy": false},
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
  "lineage": {
    "parentId": "dna-parent",
    "rootId": "dna-root",
    "generation": 1,
    "mutationIndex": 1,
    "mutationStrength": "small",
    "mutationSeed": "SCR6-XXXX-XXXX"
  },
  "lockProfile": {
    "kind": "soturineVehicleDNALockProfile",
    "profileVersion": 2,
    "boundModelKey": "model",
    "boundConfigKey": "/vehicles/model/config.pc"
  },
  "thumbnail": {
    "kind": "managed",
    "managedId": "dna-safe-id",
    "width": 500,
    "height": 281,
    "bytes": 12345,
    "exactState": true,
    "capturedFingerprint": "scrfp1-..."
  }
}
```

The example uses `null` only to explain optional JSON fields; Lua omits
non-applicable keys in generated entries. The 0.5 metadata, lineage, lock, and
thumbnail fields remain optional, so Vehicle DNA stays schema 1 and earlier
entries remain valid. Generator-4/5 seeds retain their recorded version and are
never reinterpreted as generator 6; snapshot restore does not require RNG
replay. Imported managed thumbnail metadata is stripped and replaced by
fallback; only locally validated capture/package bytes may create it. Exporter
compatibility may be retained inside bounded `extensions` metadata, while the
receiver always recomputes `localCompatibility`. `final.slots` is the
project-owned normalized slot array, never a raw `getConfig()` table. Paints
contain only supported fields. Dependencies contain identities/labels, not
third-party bytes. Unknown imported top-level fields are discarded, with
`extensions` reserved for bounded JSON-only future data.

Strict equality is field-based. `fingerprints.final` is used for change detection and diagnostics but never substitutes for model, configuration, slot, tuning, and paint read-back.
