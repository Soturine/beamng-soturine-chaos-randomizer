local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local DEFAULTS = {consecutiveFailureLimit = 3, quarantineLimit = 64}

local function create(options)
  options = type(options) == "table" and options or {}
  return {
    consecutiveFailureLimit = tonumber(options.consecutiveFailureLimit) or DEFAULTS.consecutiveFailureLimit,
    quarantineLimit = tonumber(options.quarantineLimit) or DEFAULTS.quarantineLimit,
    consecutiveFailures = 0,
    quarantine = {},
    quarantineOrder = {},
    lastKnownGood = nil,
    circuitOpen = false,
    status = "idle",
  }
end

local function candidateKey(modelKey, configKey)
  return tostring(modelKey or "") .. "\31" .. tostring(configKey or "")
end

local function rememberGood(state, snapshot, preserveFailures)
  if type(snapshot) ~= "table" or type(snapshot.modelKey) ~= "string" then return false end
  state.lastKnownGood = util.deepCopy(snapshot)
  if not preserveFailures then
    state.consecutiveFailures = 0
    state.circuitOpen = false
  end
  state.status = "ready"
  return true
end

local function quarantine(state, modelKey, configKey, reason)
  local key = candidateKey(modelKey, configKey)
  if state.quarantine[key] then return false end
  if #state.quarantineOrder >= state.quarantineLimit then return false end
  state.quarantine[key] = {modelKey = modelKey, configKey = configKey, reason = reason}
  state.quarantineOrder[#state.quarantineOrder + 1] = key
  return true
end

local function isQuarantined(state, modelKey, configKey)
  return state.quarantine[candidateKey(modelKey, configKey)] ~= nil
end

local function recordLoadFailure(state, candidate, reason)
  candidate = type(candidate) == "table" and candidate or {}
  quarantine(state, candidate.modelKey, candidate.configKey, reason or "vehicle_load_failed")
  state.consecutiveFailures = state.consecutiveFailures + 1
  state.circuitOpen = state.consecutiveFailures >= state.consecutiveFailureLimit
  state.status = state.circuitOpen and "circuit_open" or "recovery_required"
  return not state.circuitOpen, state.status
end

local function choosePlan(state, previous, registry)
  local steps = {}
  if type(previous) == "table" and type(previous.modelKey) == "string" then
    steps[#steps + 1] = {kind = "previous", snapshot = util.deepCopy(previous)}
  end
  if type(state.lastKnownGood) == "table" then
    local duplicate = previous and candidateKey(previous.modelKey, previous.selectedConfiguration)
      == candidateKey(state.lastKnownGood.modelKey, state.lastKnownGood.selectedConfiguration)
    if not duplicate then steps[#steps + 1] = {kind = "last_known_good", snapshot = util.deepCopy(state.lastKnownGood)} end
  end
  for _, config in ipairs(registry or {}) do
    if config.sourceKind == "official" and config.isProp ~= true
      and not isQuarantined(state, config.modelKey, config.key)
    then
      steps[#steps + 1] = {
        kind = "safe_official",
        snapshot = {modelKey = config.modelKey, selectedConfiguration = config.path or config.key, config = config},
      }
      break
    end
  end
  return steps
end

local function cleanup(operation)
  if type(operation) ~= "table" then return true end
  operation.wait = nil
  operation.targetTracker = nil
  operation.paintConfirmation = nil
  operation.replaceWriteInFlight = false
  operation.pendingReplacementSwitch = nil
  operation.recoveryTimer = nil
  return true
end

local function metrics(state)
  local quarantined = {}
  for _, key in ipairs(state.quarantineOrder) do quarantined[#quarantined + 1] = util.deepCopy(state.quarantine[key]) end
  return {
    quarantinedConfigurations = #state.quarantineOrder,
    consecutiveLoadFailures = state.consecutiveFailures,
    recoveryCircuitOpen = state.circuitOpen,
    recoveryStatus = state.status,
    quarantined = quarantined,
  }
end

local function retryQuarantined(state)
  state.quarantine = {}
  state.quarantineOrder = {}
  state.consecutiveFailures = 0
  state.circuitOpen = false
  state.status = "ready"
  return true
end

M.DEFAULTS = DEFAULTS
M.create = create
M.candidateKey = candidateKey
M.rememberGood = rememberGood
M.quarantine = quarantine
M.isQuarantined = isQuarantined
M.recordLoadFailure = recordLoadFailure
M.choosePlan = choosePlan
M.cleanup = cleanup
M.metrics = metrics
M.retryQuarantined = retryQuarantined

return M
