local util = require("ge/extensions/soturineChaosRandomizer/util")
local configVerification = require("ge/extensions/soturineChaosRandomizer/configVerification")
local paintVerification = require("ge/extensions/soturineChaosRandomizer/paintVerification")

local M = {}

local WAIT_REASONS = {
  spawn = "waitingForVehicleReplace",
  parts = "waitingForPartsReload",
  tuning = "waitingForTuningReload",
  rollback = "waitingForRollbackReplace",
  undo = "waitingForUndoReplace",
  dna_base_spawn = "waitingForDNABaseSpawn",
  dna_parts = "waitingForDNAPartsReload",
  dna_tuning = "waitingForDNATuningReload",
  part_batch_rollback = "waitingForPartBatchRollback",
}

local function createExpectation(options)
  options = type(options) == "table" and options or {}
  return {
    token = options.token,
    phase = options.phase,
    reason = WAIT_REASONS[options.phase] or options.reason,
    eventType = options.eventType or "onVehicleSpawned",
    vehicleId = options.vehicleId,
    modelKey = options.modelKey,
    configKey = options.configKey,
    configIdentity = util.deepCopy(options.configIdentity),
    parts = util.deepCopy(options.parts or {}),
    tuning = util.deepCopy(options.tuning or {}),
    paints = options.paints and util.deepCopy(options.paints) or nil,
    startedAt = options.startedAt,
  }
end

local function matches(expectation, event)
  if type(expectation) ~= "table" or type(event) ~= "table" then return false, "missing_expectation" end
  if event.token and expectation.token ~= event.token then return false, "stale_operation_token" end
  if expectation.eventType ~= event.eventType then return false, "unexpected_event_type" end
  if expectation.vehicleId and event.vehicleId ~= expectation.vehicleId then return false, "wrong_vehicle_event" end
  return true
end

local function configKey(value) return configVerification.stableKey(value) end

local function verify(expectation, state)
  state = type(state) == "table" and state or {}
  if expectation.modelKey and state.modelKey ~= expectation.modelKey then
    return false, "model_mismatch"
  end
  local configDetails
  if expectation.configIdentity then
    local confirmed, reason, details = configVerification.verify(expectation.configIdentity, state)
    configDetails = details
    if not confirmed then return false, reason or "config_mismatch", details end
  elseif expectation.configKey then
    local expectedIdentity = configVerification.expectation({
      modelKey = expectation.modelKey,
      key = configKey(expectation.configKey),
      path = expectation.configKey,
    })
    local confirmed, reason, details = configVerification.verify(expectedIdentity, state)
    configDetails = details
    if not confirmed then return false, reason or "config_mismatch", details end
  end
  for path, candidate in pairs(expectation.parts or {}) do
    if not state.parts or state.parts[path] ~= candidate then
      return false, "parts_state_mismatch:" .. tostring(path)
    end
  end
  for name, value in pairs(expectation.tuning or {}) do
    local actual = state.tuning and tonumber(state.tuning[name])
    if not actual or math.abs(actual - value) > 1e-8 then
      return false, "tuning_state_mismatch:" .. tostring(name)
    end
  end
  if expectation.paints then
    local paintsMatch, paintReason = paintVerification.compare(expectation.paints, state.paints or {})
    if not paintsMatch then return false, "paint_state_mismatch:" .. tostring(paintReason), configDetails end
  end
  return true, nil, configDetails
end

M.WAIT_REASONS = WAIT_REASONS
M.createExpectation = createExpectation
M.matches = matches
M.verify = verify
M.configKey = configKey

return M
