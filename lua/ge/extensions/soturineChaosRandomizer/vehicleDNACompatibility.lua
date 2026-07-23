local util = require("ge/extensions/soturineChaosRandomizer/util")
local fingerprint = require("ge/extensions/soturineChaosRandomizer/vehicleDNAFingerprint")

local M = {}

local function resolveSlot(saved, scan, modelKey)
  local candidates = {}
  for _, current in ipairs(type(scan) == "table" and scan.slots or {}) do
    local parentMatches = saved.parentPart == nil or saved.parentPart == current.parentPart
    if current.path == saved.path and current.id == saved.slotId and parentMatches then
      return current, "exact_path_slot_parent"
    end
  end
  for _, current in ipairs(type(scan) == "table" and scan.slots or {}) do
    if current.path == saved.path and current.id == saved.slotId then
      return current, "exact_path_slot"
    end
  end
  for _, current in ipairs(type(scan) == "table" and scan.slots or {}) do
    if current.id == saved.slotId and (saved.parentPart == nil or saved.parentPart == current.parentPart) then
      candidates[#candidates + 1] = current
    end
  end
  if #candidates == 1 and modelKey then return candidates[1], "unique_slot_parent_model" end
  if #candidates > 1 then return nil, "slot_resolution_ambiguous" end
  return nil, "slot_missing"
end

local function contains(values, expected)
  for _, value in ipairs(values or {}) do if value == expected then return true end end
  return false
end

local function normalizedPath(value)
  return tostring(value or ""):gsub("\\", "/"):gsub("/+", "/"):lower()
end

local function evaluate(entry, environment, mode)
  entry = type(entry) == "table" and entry or {}
  environment = type(environment) == "table" and environment or {}
  mode = mode == "compatible" and "compatible" or "exact"
  local report = {
    mode = mode,
    status = "exact",
    model = {expected = entry.base and entry.base.modelKey, available = false},
    configuration = {expected = entry.base and (entry.base.configPath or entry.base.configKey), available = false, confirmed = false},
    slots = {}, tuning = {}, paints = {}, dependencies = {}, warnings = {}, actions = {},
    environment = {},
    missing = 0, changed = 0, ambiguous = 0,
    blocking = 0,
  }
  local models = environment.modelsByKey or {}
  report.model.available = models[report.model.expected] ~= nil
  if not report.model.available then report.missing = report.missing + 1 end
  for _, config in ipairs(environment.configs or {}) do
    if config.modelKey == report.model.expected and (
      (entry.base.configPath and config.path == entry.base.configPath) or (entry.base.configKey and config.key == entry.base.configKey)
    ) then report.configuration.available = true; break end
  end
  if not report.configuration.available then report.missing = report.missing + 1 end
  local expectedConfig = normalizedPath(report.configuration.expected)
  local currentConfig = normalizedPath(environment.currentConfigPath)
  report.configuration.confirmed = expectedConfig ~= "" and currentConfig ~= "" and currentConfig == expectedConfig

  local slotEvidence = type(environment.scan) == "table"
  for _, saved in ipairs(entry.final and entry.final.slots or {}) do
    if not slotEvidence then
      report.slots[#report.slots + 1] = {savedPath = saved.path, slotId = saved.slotId, partName = saved.partName, available = nil, strategy = "target_not_loaded"}
    else
    local current, strategy = resolveSlot(saved, environment.scan, report.model.expected)
    local available = current ~= nil and (saved.partName == "" or contains(current.candidates, saved.partName) or current.currentPart == saved.partName)
    local item = {
      savedPath = saved.path, resolvedPath = current and current.path, slotId = saved.slotId,
      partName = saved.partName, strategy = strategy, available = available,
      required = saved.required == true or saved.coreSlot == true,
    }
    if not current then
      if strategy == "slot_resolution_ambiguous" then report.ambiguous = report.ambiguous + 1 else report.missing = report.missing + 1 end
      if item.required then report.blocking = report.blocking + 1 end
      report.actions[#report.actions + 1] = {phase = "parts", path = saved.path, action = "omit", reason = strategy}
    elseif not available then
      report.missing = report.missing + 1
      if item.required then report.blocking = report.blocking + 1 end
      report.actions[#report.actions + 1] = {phase = "parts", path = saved.path, action = "omit", reason = "part_missing"}
    end
    report.slots[#report.slots + 1] = item
    end
  end
  if slotEvidence and #(environment.scan.slots or {}) ~= #(entry.final and entry.final.slots or {}) then
    report.changed = report.changed + 1
    report.warnings[#report.warnings + 1] = "Loaded slot topology differs from the saved DNA."
  end

  local variables = environment.variables or {}
  for _, saved in ipairs(entry.final and entry.final.tuning or {}) do
    local metadata = variables[saved.name]
    local available = type(metadata) == "table" and tonumber(metadata.min) ~= nil and tonumber(metadata.max) ~= nil
    local inRange = available and saved.value >= tonumber(metadata.min) and saved.value <= tonumber(metadata.max)
    if not available then
      report.missing = report.missing + 1
      report.actions[#report.actions + 1] = {phase = "tuning", name = saved.name, action = "omit", reason = "tuning_missing"}
    elseif not inRange then
      report.changed = report.changed + 1
      report.actions[#report.actions + 1] = {phase = "tuning", name = saved.name, action = "clamp", reason = "tuning_out_of_range"}
    end
    report.tuning[#report.tuning + 1] = {name = saved.name, available = available, inRange = inRange}
  end
  local paintCount = #(environment.paints or {})
  for index, _ in ipairs(entry.final and entry.final.paints or {}) do
    local available = index <= paintCount
    if not available then
      report.missing = report.missing + 1
      report.actions[#report.actions + 1] = {phase = "paint", layer = index, action = "omit", reason = "paint_layer_missing"}
    end
    report.paints[#report.paints + 1] = {layer = index, available = available}
  end
  if paintCount ~= #(entry.final and entry.final.paints or {}) then report.changed = report.changed + 1 end

  local availableModIDs = environment.availableModIDs or {}
  local baseDependency = entry.dependencies and entry.dependencies.baseConfiguration
  if type(baseDependency) == "table" and next(baseDependency) ~= nil then
    local baseID = baseDependency.modID and tostring(baseDependency.modID) or tostring(baseDependency.configPath or baseDependency.configKey or "")
    local baseAvailable = report.configuration.available
    if baseDependency.sourceKind == "mod" and baseDependency.modID ~= nil then
      baseAvailable = baseAvailable and availableModIDs[tostring(baseDependency.modID)] == true
    end
    report.dependencies[#report.dependencies + 1] = {
      kind = "baseConfiguration", id = baseID, label = baseDependency.sourceLabel, available = baseAvailable,
    }
    if not baseAvailable then report.actions[#report.actions + 1] = {
      phase = "dependencies", id = baseID, action = "report_missing", reason = "base_configuration_missing",
    } end
  end
  for _, dependency in ipairs(entry.dependencies and entry.dependencies.mods or {}) do
    local dependencyId = tostring(dependency.modID or dependency.id or "")
    local available = dependencyId ~= "" and availableModIDs[dependencyId] == true
    report.dependencies[#report.dependencies + 1] = {
      kind = "mod", id = dependencyId, label = dependency.label, available = available,
    }
    if not available then
      report.missing = report.missing + 1
      report.actions[#report.actions + 1] = {phase = "dependencies", id = dependencyId, action = "report_missing", reason = "mod_missing"}
    end
  end
  for _, dependency in ipairs(entry.dependencies and entry.dependencies.unknown or {}) do
    report.dependencies[#report.dependencies + 1] = {
      kind = "unknown", id = dependency.id, label = dependency.label, available = nil,
    }
  end

  local currentEnvironment = {
    beamNGVersion = tostring(environment.gameVersion or "unknown"),
    extensionVersion = tostring(environment.extensionVersion or "unknown"),
    targetBeamNG = tostring(environment.targetBeamNG or "0.38.6.0.19963"),
    schemaVersion = tonumber(entry.schemaVersion),
    generatorVersion = tonumber(environment.generatorVersion),
  }
  local currentFingerprint = fingerprint.fingerprint(currentEnvironment)
  report.environment = {
    savedBeamNG = entry.environment and entry.environment.beamNGVersion,
    currentBeamNG = currentEnvironment.beamNGVersion,
    savedExtension = entry.environment and entry.environment.extensionVersion,
    currentExtension = currentEnvironment.extensionVersion,
    savedGenerator = entry.generation and entry.generation.generatorVersion,
    currentGenerator = currentEnvironment.generatorVersion,
    savedFingerprint = entry.fingerprints and entry.fingerprints.environment,
    currentFingerprint = currentFingerprint,
  }
  if report.environment.savedBeamNG ~= report.environment.currentBeamNG then
    report.changed = report.changed + 1
    report.warnings[#report.warnings + 1] = "BeamNG version differs from the saved DNA environment."
  end
  if report.environment.savedExtension ~= report.environment.currentExtension then
    report.changed = report.changed + 1
    report.warnings[#report.warnings + 1] = "Chaos Randomizer version differs from the saved DNA environment."
  end
  if tonumber(report.environment.savedGenerator) ~= tonumber(report.environment.currentGenerator) then
    report.changed = report.changed + 1
    report.warnings[#report.warnings + 1] = "Generator version differs; Replay Seed is unavailable for this algorithm."
  end

  if not slotEvidence and report.model.available and report.configuration.available then report.status = "unverified"
  elseif slotEvidence and not report.configuration.confirmed then report.status = "unverified"
  elseif report.ambiguous > 0 or report.blocking > 0 then report.status = "incompatible"
  elseif report.missing == 0 and report.changed == 0 then report.status = "exact"
  elseif mode == "compatible" and report.model.available and report.configuration.available then
    report.status = report.missing > 0 and "partial" or "compatible"
  else report.status = "incompatible" end
  return report
end

M.resolveSlot = resolveSlot
M.evaluate = evaluate

return M
