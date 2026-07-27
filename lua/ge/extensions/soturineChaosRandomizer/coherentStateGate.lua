local configVerification = require("ge/extensions/soturineChaosRandomizer/configVerification")
local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local function stableValue(value, depth)
  depth = depth or 0
  if type(value) ~= "table" then return tostring(value) end
  if depth > 10 then return "<depth>" end
  local out = {"{"}
  for _, key in ipairs(util.sortedKeys(value)) do
    out[#out + 1] = tostring(key)
    out[#out + 1] = "="
    out[#out + 1] = stableValue(value[key], depth + 1)
    out[#out + 1] = ";"
  end
  out[#out + 1] = "}"
  return table.concat(out)
end

local function create(options)
  options = type(options) == "table" and options or {}
  return {
    operationId = options.operationId,
    operationGeneration = options.operationGeneration,
    targetGeneration = options.targetGeneration,
    vehicleId = tonumber(options.vehicleId),
    logicalTarget = util.deepCopy(options.logicalTarget or {}),
    requireParts = options.requireParts == true,
    requireTuning = options.requireTuning == true,
    requirePowertrain = options.requirePowertrain == true,
    requireEnergyStorage = options.requireEnergyStorage == true,
    minimumSamples = math.max(2, math.floor(tonumber(options.minimumSamples) or 2)),
    fingerprint = nil,
    stableSamples = 0,
    samples = 0,
    resets = 0,
    lastReason = "coherent_state_pending",
    lastEvidence = nil,
  }
end

local function generationsMatch(state, context)
  context = type(context) == "table" and context or {}
  return (context.operationId == nil or context.operationId == state.operationId)
    and (context.operationGeneration == nil or context.operationGeneration == state.operationGeneration)
    and (context.targetGeneration == nil or context.targetGeneration == state.targetGeneration)
end

local function validate(state, evidence, context)
  context = type(context) == "table" and context or {}
  if not generationsMatch(state, context) then return false, "coherent_state_stale_generation" end
  if type(evidence) ~= "table" or type(evidence.vehicleId) ~= "number" then
    return false, "coherent_state_vehicle_unbound"
  end
  local contextualVehicleId = tonumber(context.concreteVehicleId
    or context.vehicleId
    or (type(context.expectedTarget) == "table" and context.expectedTarget.vehicleId))
  local expectedVehicleId = contextualVehicleId or state.vehicleId
  if expectedVehicleId and evidence.vehicleId ~= expectedVehicleId then
    return false, "coherent_state_concrete_vehicle_mismatch"
  end
  local logical = state.logicalTarget or {}
  if logical.modelKey and evidence.modelKey ~= logical.modelKey then return false, "coherent_state_model_mismatch" end
  local expectedConfig = configVerification.stableKey(
    logical.configKey or logical.selectedConfiguration
      or (logical.configIdentity and logical.configIdentity.path)
  )
  local actualConfig = configVerification.stableKey(
    evidence.configKey or (evidence.configIdentity and evidence.configIdentity.path)
  )
  if expectedConfig and actualConfig and expectedConfig ~= actualConfig then
    return false, "coherent_state_config_mismatch"
  end
  local readiness = type(evidence.readiness) == "table" and evidence.readiness or {
    config = evidence.configKey ~= nil or evidence.configIdentity ~= nil,
    parts = type(evidence.parts) == "table",
    tuning = type(evidence.tuning) == "table",
    powertrain = evidence.coherentTargetRead == true,
    energyStorage = evidence.coherentTargetRead == true,
    replacementInProgress = false,
    newerReloadInProgress = false,
  }
  if readiness.replacementInProgress == true or readiness.newerReloadInProgress == true then
    return false, "coherent_state_newer_reload_in_progress"
  end
  if readiness.config ~= true then return false, "coherent_state_config_pending" end
  if state.requireParts and (readiness.parts ~= true or type(evidence.parts) ~= "table") then
    return false, "coherent_state_parts_pending"
  end
  if state.requireTuning and (readiness.tuning ~= true or type(evidence.tuning) ~= "table") then
    return false, "coherent_state_tuning_pending"
  end
  if state.requirePowertrain and readiness.powertrain ~= true then
    return false, "coherent_state_powertrain_pending"
  end
  if state.requireEnergyStorage and readiness.energyStorage ~= true then
    return false, "coherent_state_energy_storage_pending"
  end
  -- New adapter snapshots set this explicitly. Older direct callers remain
  -- compatible, while an explicit false always fails closed.
  if evidence.coherentTargetRead == false then return false, "coherent_state_read_incoherent" end
  return true
end

local function fingerprint(evidence)
  return table.concat({
    tostring(evidence.vehicleId), tostring(evidence.modelKey),
    tostring(configVerification.stableKey(evidence.configKey or (evidence.configIdentity and evidence.configIdentity.path))),
    stableValue(evidence.parts or {}), stableValue(evidence.tuning or {}),
    stableValue(evidence.powertrainEvidence or {}), stableValue(evidence.energyStorages or {}),
  }, "\30")
end

local function observe(state, evidence, context)
  state.samples = state.samples + 1
  local valid, reason = validate(state, evidence, context)
  if not valid then
    state.fingerprint, state.stableSamples = nil, 0
    state.resets = state.resets + 1
    state.lastReason = reason
    return false, reason
  end
  local current = fingerprint(evidence)
  if current == state.fingerprint then state.stableSamples = state.stableSamples + 1
  else
    state.fingerprint = current
    state.stableSamples = 1
    state.resets = state.resets + 1
  end
  state.lastEvidence = util.deepCopy(evidence)
  if state.stableSamples >= state.minimumSamples then
    state.lastReason = "coherent_state_stable"
    return true, state.lastReason
  end
  state.lastReason = "coherent_state_stabilizing"
  return false, state.lastReason
end

local function summary(state)
  return {
    stableSamples = state.stableSamples, minimumSamples = state.minimumSamples,
    samples = state.samples, resets = state.resets, reason = state.lastReason,
    fingerprint = state.fingerprint,
  }
end

M.create = create
M.validate = validate
M.observe = observe
M.fingerprint = fingerprint
M.summary = summary

return M
