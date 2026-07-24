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
    lastReadableSnapshot = nil,
    lastCompletedGoodSnapshot = nil,
    lastKnownGood = nil,
    circuitOpen = false,
    status = "idle",
  }
end

local function candidateKey(modelKey, configKey)
  return tostring(modelKey or "") .. "\31" .. tostring(configKey or "")
end

local function rememberReadable(state, snapshot)
  if type(snapshot) ~= "table" or type(snapshot.modelKey) ~= "string" then return false end
  state.lastReadableSnapshot = util.deepCopy(snapshot)
  return true
end

local function rememberCompletedGood(state, snapshot, preserveFailures)
  if type(snapshot) ~= "table" or type(snapshot.modelKey) ~= "string" then return false end
  state.lastReadableSnapshot = util.deepCopy(snapshot)
  state.lastCompletedGoodSnapshot = util.deepCopy(snapshot)
  -- Compatibility alias for the 0.5 API. New code must use the explicit role.
  state.lastKnownGood = util.deepCopy(snapshot)
  if not preserveFailures then
    state.consecutiveFailures = 0
    state.circuitOpen = false
  end
  state.status = "ready"
  return true
end

local function rememberGood(state, snapshot, preserveFailures)
  return rememberCompletedGood(state, snapshot, preserveFailures)
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
  local completedGood = state.lastCompletedGoodSnapshot or state.lastKnownGood
  if type(completedGood) == "table" then
    local duplicate = previous and candidateKey(previous.modelKey, previous.selectedConfiguration)
      == candidateKey(completedGood.modelKey, completedGood.selectedConfiguration)
    if not duplicate then
      steps[#steps + 1] = {kind = "last_known_good", snapshot = util.deepCopy(completedGood)}
    end
  end
  local official = {}
  for _, config in ipairs(registry or {}) do
    if config.sourceKind == "official" and config.isProp ~= true and config.isTrailer ~= true
      and config.valid ~= false and not isQuarantined(state, config.modelKey, config.key)
    then
      local score = 100
      if config.isDefault then score = score + 40 end
      if config.isStock then score = score + 25 end
      if type(config.path) == "string" and config.path ~= "" then score = score + 10 end
      if config.isAutomation ~= true then score = score + 5 end
      official[#official + 1] = {config = config, score = score}
    end
  end
  table.sort(official, function(a, b)
    if a.score ~= b.score then return a.score > b.score end
    if tostring(a.config.modelKey) ~= tostring(b.config.modelKey) then return tostring(a.config.modelKey) < tostring(b.config.modelKey) end
    return tostring(a.config.key) < tostring(b.config.key)
  end)
  for index = 1, math.min(5, #official) do
    local config = official[index].config
    steps[#steps + 1] = {
      kind = "safe_official",
      rank = index,
      score = official[index].score,
      snapshot = {modelKey = config.modelKey, selectedConfiguration = config.path or config.key, config = config},
    }
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

local function invalidateForRecovery(operation)
  if type(operation) ~= "table" then return false end
  operation.recoveryOnly = true
  operation.operationMutationPlan = nil
  operation.currentBatch = nil
  operation.batchRollbackDecisions = nil
  operation.afterReload = nil
  operation.wait = nil
  operation.targetTracker = nil
  operation.paintConfirmation = nil
  operation.pendingTuningChanges = nil
  operation.pendingTuningPlan = nil
  operation.pendingPaintPlan = nil
  operation.treeRescanAt = nil
  operation.treeRescanContext = nil
  operation.recoveryTimer = nil
  operation.replaceWriteInFlight = false
  operation.pendingReplacementSwitch = nil
  operation.candidateIsolation = nil
  if type(operation.batchRecovery) == "table" then operation.batchRecovery.currentBatch = nil end
  if type(operation.slotLedger) == "table" then
    operation.slotLedger.closed = true
    operation.slotLedger.closeReason = "operation_recovery_started"
  end
  if type(operation.tuningLedger) == "table" then
    operation.tuningLedger.closed = true
    operation.tuningLedger.closeReason = "operation_recovery_started"
  end
  if type(operation.paintLedger) == "table" then
    operation.paintLedger.closed = true
    operation.paintLedger.closeReason = "operation_recovery_started"
  end
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
    lastReadableSnapshot = state.lastReadableSnapshot and {
      modelKey = state.lastReadableSnapshot.modelKey,
      vehicleId = state.lastReadableSnapshot.vehicleId,
      selectedConfiguration = state.lastReadableSnapshot.selectedConfiguration,
    } or nil,
    lastCompletedGoodSnapshot = state.lastCompletedGoodSnapshot and {
      modelKey = state.lastCompletedGoodSnapshot.modelKey,
      vehicleId = state.lastCompletedGoodSnapshot.vehicleId,
      selectedConfiguration = state.lastCompletedGoodSnapshot.selectedConfiguration,
    } or nil,
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
M.rememberReadable = rememberReadable
M.rememberCompletedGood = rememberCompletedGood
M.rememberGood = rememberGood
M.quarantine = quarantine
M.isQuarantined = isQuarantined
M.recordLoadFailure = recordLoadFailure
M.choosePlan = choosePlan
M.cleanup = cleanup
M.invalidateForRecovery = invalidateForRecovery
M.metrics = metrics
M.retryQuarantined = retryQuarantined

return M
