local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local DEFAULTS = {consecutiveFailureLimit = 3, quarantineLimit = 64, cycleVisitLimit = 1}

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
    recoveryGeneration = 0,
    recoveryOperationId = nil,
    recoveryOperationGeneration = nil,
    recoveryAttempts = 0,
    cycleVisitLimit = tonumber(options.cycleVisitLimit) or DEFAULTS.cycleVisitLimit,
    cycleVisits = {},
    cycleOrder = {},
    lastCycleReason = nil,
  }
end

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

local function targetStateFingerprint(snapshot)
  snapshot = type(snapshot) == "table" and snapshot or {}
  return table.concat({
    tostring(snapshot.modelKey or ""),
    tostring(snapshot.selectedConfiguration or (snapshot.config and snapshot.config.partConfigFilename) or ""),
    stableValue(snapshot.partsTree or (snapshot.config and snapshot.config.partsTree) or {}),
    stableValue(snapshot.tuning or (snapshot.config and snapshot.config.vars) or {}),
    stableValue(snapshot.paints or (snapshot.config and snapshot.config.paints) or {}),
  }, "\30")
end

local function beginRecovery(state, operationId, operationGeneration)
  state.recoveryGeneration = state.recoveryGeneration + 1
  state.recoveryOperationId = operationId
  state.recoveryOperationGeneration = operationGeneration
  state.recoveryAttempts = 0
  state.cycleVisits = {}
  state.cycleOrder = {}
  state.lastCycleReason = nil
  state.status = "recovery_started"
  return state.recoveryGeneration
end

local function observeRecoveryStep(state, operationId, recoveryGeneration, step)
  if operationId ~= state.recoveryOperationId or recoveryGeneration ~= state.recoveryGeneration then
    state.lastCycleReason = "recovery_snapshot_old_generation"
    return false, state.lastCycleReason
  end
  if type(step) ~= "table" or type(step.snapshot) ~= "table" then return true, "hard_failure" end
  local fingerprint = targetStateFingerprint(step.snapshot)
  local visits = (state.cycleVisits[fingerprint] or 0) + 1
  state.cycleVisits[fingerprint] = visits
  state.cycleOrder[#state.cycleOrder + 1] = fingerprint
  state.recoveryAttempts = state.recoveryAttempts + 1
  if visits > state.cycleVisitLimit then
    state.lastCycleReason = "candidate_cycle_detected"
    state.status = "recovery_loop_detected"
    return false, state.lastCycleReason, fingerprint
  end
  return true, "recovery_candidate_accepted", fingerprint
end

local function candidateKey(modelKey, configKey)
  return tostring(modelKey or "") .. "\31" .. tostring(configKey or "")
end

local function rememberReadable(state, snapshot)
  if type(snapshot) ~= "table" or type(snapshot.modelKey) ~= "string" then return false end
  state.lastReadableSnapshot = util.deepCopy(snapshot)
  return true
end

local function rememberCompletedGood(state, snapshot, preserveFailures, metadata)
  if type(snapshot) ~= "table" or type(snapshot.modelKey) ~= "string" then return false end
  local promoted = util.deepCopy(snapshot)
  promoted.recoveryMetadata = util.deepCopy(metadata or snapshot.recoveryMetadata or {})
  promoted.recoveryMetadata.role = "last_completed_good"
  state.lastReadableSnapshot = util.deepCopy(promoted)
  state.lastCompletedGoodSnapshot = util.deepCopy(promoted)
  -- Compatibility alias for the 0.5 API. New code must use the explicit role.
  state.lastKnownGood = util.deepCopy(promoted)
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

local function choosePlan(state, context, registry)
  local legacyPrevious = type(context) == "table" and context.modelKey and context or nil
  context = legacyPrevious and {originalSnapshot = legacyPrevious} or (type(context) == "table" and context or {})
  local steps = {}
  local fingerprints = {}
  local function add(kind, tier, snapshot, details)
    if type(snapshot) ~= "table" or type(snapshot.modelKey) ~= "string" then return false end
    local fingerprint = targetStateFingerprint(snapshot)
    if fingerprints[fingerprint] then return false end
    fingerprints[fingerprint] = true
    local step = {
      kind = kind, tier = tier, snapshot = util.deepCopy(snapshot), fingerprint = fingerprint,
      recoveryGeneration = state.recoveryGeneration,
    }
    for key, value in pairs(details or {}) do step[key] = value end
    steps[#steps + 1] = step
    return true
  end

  if context.transient == true then add("continue_current_target", 1, context.currentTargetSnapshot) end
  -- A generated state that already passed coherent safety validation is the
  -- first whole-snapshot recovery source. The clean candidate and original
  -- player vehicle have distinct meanings and may never alias this role.
  add("last_accepted_generated_result", 2, context.lastAcceptedGeneratedSnapshot)
  add("clean_candidate_baseline", 3, context.candidateBaseSnapshot)
  add("selected_random_candidate", 4, context.selectedCandidateSnapshot)
  add("original_player_vehicle", 5, context.originalSnapshot)
  local completedGood = state.lastCompletedGoodSnapshot or state.lastKnownGood
  add("explicit_safe_baseline", 6, context.explicitBaselineSnapshot or completedGood)
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
    add("safe_official_fallback", 7, {
      modelKey = config.modelKey, selectedConfiguration = config.path or config.key, config = config,
    }, {rank = index, score = official[index].score})
  end
  steps[#steps + 1] = {kind = "hard_failure", tier = 8, recoveryGeneration = state.recoveryGeneration}
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
  operation.readRetry = nil
  operation.readUnavailable = nil
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
  operation.readRetry = nil
  operation.readUnavailable = nil
  operation.selectedModel = nil
  operation.selectedConfig = nil
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
    recoveryGeneration = state.recoveryGeneration,
    recoveryOperationId = state.recoveryOperationId,
    recoveryOperationGeneration = state.recoveryOperationGeneration,
    recoveryAttempts = state.recoveryAttempts,
    recoveryCycleVisits = #state.cycleOrder,
    recoveryCycleReason = state.lastCycleReason,
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
M.targetStateFingerprint = targetStateFingerprint
M.beginRecovery = beginRecovery
M.observeRecoveryStep = observeRecoveryStep
M.choosePlan = choosePlan
M.cleanup = cleanup
M.invalidateForRecovery = invalidateForRecovery
M.metrics = metrics
M.retryQuarantined = retryQuarantined

return M
