local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local DECISIONS = {
  VALID = "VALID",
  INVALID_CONFIRMED = "INVALID_CONFIRMED",
  UNKNOWN_OR_PENDING = "UNKNOWN_OR_PENDING",
}

local function withDecision(report)
  if report.valid == false then report.decision = DECISIONS.INVALID_CONFIRMED
  elseif report.valid == nil or report.status == "uncertain" or report.status == "unavailable"
    or report.status == "combustion_engine_runtime_missing"
  then report.decision = DECISIONS.UNKNOWN_OR_PENDING
  else report.decision = DECISIONS.VALID end
  return report
end

local function text(variable)
  variable = type(variable) == "table" and variable or {}
  return util.normalizeText(table.concat({
    tostring(variable.name or ""), tostring(variable.title or ""),
    tostring(variable.description or ""), tostring(variable.category or ""),
    tostring(variable.subCategory or ""), tostring(variable.sourcePart or ""),
    tostring(variable.unit or ""),
  }, " "))
end

local function contains(value, token)
  return value:find(token, 1, true) ~= nil
end

local function classifyVariable(name, raw)
  raw = type(raw) == "table" and util.deepCopy(raw) or {}
  raw.name = raw.name or name
  local evidence = text(raw)
  if contains(evidence, "temperature") or contains(evidence, "temp")
    or contains(evidence, "pressure") or contains(evidence, "viscosity")
  then return "other", {"excluded_measurement"} end
  if contains(evidence, "engine oil") or contains(evidence, "oil volume")
    or contains(evidence, "oil level") or contains(evidence, "oil capacity")
    or util.normalizeText(name) == "oilvolume"
  then return "engine_oil", {"engine_oil_volume_metadata"} end
  if contains(evidence, "coolant volume") or contains(evidence, "coolant level")
    or contains(evidence, "coolant capacity")
  then return "engine_coolant", {"engine_coolant_volume_metadata"} end
  return "other", {}
end

local function safeValue(raw)
  raw = type(raw) == "table" and raw or {}
  local minimum, maximum = tonumber(raw.min), tonumber(raw.max)
  if not util.isFinite(minimum) or not util.isFinite(maximum) or maximum <= 0 or maximum < minimum then return nil end
  local default = tonumber(raw.default)
  if util.isFinite(default) and default > 0 then return util.clamp(default, minimum, maximum), "metadata_default" end
  local step = tonumber(raw.step or raw.stepDis)
  local floor = util.isFinite(step) and step > 0 and math.max(step, maximum * 0.25) or maximum * 0.75
  return util.clamp(floor, math.max(0, minimum), maximum), "positive_range_fallback"
end

local function protectTuning(values, variables, currentValues, classification)
  values = util.deepCopy(values or {})
  variables = type(variables) == "table" and variables or {}
  currentValues = type(currentValues) == "table" and currentValues or {}
  local report = {classification = classification, protected = {}, unavailable = {}, applicable = false}
  if classification ~= "drivable_combustion" and classification ~= "drivable_hybrid" then
    report.status = "not_applicable"
    return values, report
  end
  report.applicable = true
  for _, name in ipairs(util.sortedKeys(variables)) do
    local kind, evidence = classifyVariable(name, variables[name])
    if kind == "engine_oil" or kind == "engine_coolant" then
      local requested = tonumber(values[name])
      local current = tonumber(currentValues[name])
      local replacement, source = safeValue(variables[name])
      local needsProtection = not util.isFinite(requested) or requested <= 0
      if not needsProtection and util.isFinite(current) and current > 0 and requested < current * 0.05 then
        needsProtection = true
      end
      if needsProtection and util.isFinite(replacement) and replacement > 0 then
        values[name] = replacement
        report.protected[#report.protected + 1] = {
          name = name, kind = kind, previous = current, requested = requested,
          restored = replacement, source = source, evidence = evidence,
        }
      elseif needsProtection then
        report.unavailable[#report.unavailable + 1] = {name = name, kind = kind, evidence = evidence}
      end
    end
  end
  report.status = #report.unavailable > 0 and "metadata_unavailable"
    or #report.protected > 0 and "protected" or "no_unsafe_fluid_tuning"
  return values, report
end

local function assess(evidence, classification)
  if classification ~= "drivable_combustion" and classification ~= "drivable_hybrid" then
    return withDecision({valid = true, status = "not_applicable", classification = classification, engines = {}})
  end
  if type(evidence) ~= "table" or evidence.available ~= true then
    return withDecision({valid = nil, status = "unavailable", classification = classification,
      source = evidence and evidence.source, confidence = evidence and evidence.confidence})
  end
  local engines = type(evidence.engines) == "table" and evidence.engines or {}
  if #engines == 0 then
    return withDecision({valid = nil, status = "combustion_engine_runtime_missing", classification = classification,
      source = evidence.source, confidence = evidence.confidence, engines = {}})
  end
  local failures, warnings = {}, {}
  for _, engine in ipairs(engines) do
    local oilMass, minimum = tonumber(engine.oilMass), tonumber(engine.minimumSafeOilMass)
    if engine.disabled == true then
      failures[#failures + 1] = {engine = engine.name, reason = "combustion_engine_disabled"}
    end
    if engine.oilLevelCritical == true then
      failures[#failures + 1] = {engine = engine.name, reason = "engine_oil_level_critical", observed = oilMass, minimum = minimum}
    elseif not util.isFinite(oilMass) then
      warnings[#warnings + 1] = {engine = engine.name, reason = "oil_mass_unavailable"}
    elseif oilMass <= 0 then
      failures[#failures + 1] = {engine = engine.name, reason = "engine_oil_zero", observed = oilMass, minimum = minimum}
    elseif util.isFinite(minimum) and minimum > 0 and oilMass < minimum then
      failures[#failures + 1] = {engine = engine.name, reason = "engine_oil_below_safe_mass", observed = oilMass, minimum = minimum}
    end
    local coolantMass = tonumber(engine.coolantMass)
    if engine.coolantExposed == true and util.isFinite(coolantMass) and coolantMass <= 0 then
      failures[#failures + 1] = {engine = engine.name, reason = "engine_coolant_zero", observed = coolantMass}
    end
  end
  return withDecision({
    valid = #failures == 0, status = #failures > 0 and "unsafe" or (#warnings > 0 and "uncertain" or "safe"),
    classification = classification, source = evidence.source, confidence = evidence.confidence,
    vehicleId = evidence.vehicleId, engines = util.deepCopy(engines),
    failures = failures, warnings = warnings,
  })
end

local function signature(evidence)
  local values = {tostring(evidence and evidence.vehicleId), tostring(evidence and evidence.available)}
  for _, engine in ipairs(type(evidence) == "table" and evidence.engines or {}) do
    values[#values + 1] = table.concat({
      tostring(engine.name), tostring(engine.oilMass), tostring(engine.minimumSafeOilMass),
      tostring(engine.maximumSafeOilMass), tostring(engine.coolantMass), tostring(engine.disabled),
      tostring(engine.oilLevelCritical),
    }, ":")
  end
  return table.concat(values, "|")
end

M.classifyVariable = classifyVariable
M.safeValue = safeValue
M.protectTuning = protectTuning
M.assess = assess
M.signature = signature
M.DECISIONS = DECISIONS

return M
