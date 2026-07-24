local configVerification = require("ge/extensions/soturineChaosRandomizer/configVerification")
local util = require("ge/extensions/soturineChaosRandomizer/util")
local vehicleStabilizer = require("ge/extensions/soturineChaosRandomizer/vehicleStabilizer")

local M = {}

local LIMITS = {candidates = 16, events = 32}

local function boundedAppend(list, value, limit)
  list[#list + 1] = value
  while #list > limit do table.remove(list, 1) end
end

local function scalar(value)
  if value == nil then return "~" end
  if type(value) == "boolean" then return value and "1" or "0" end
  return tostring(value)
end

local function stableTable(value, depth)
  depth = depth or 0
  if type(value) ~= "table" then return scalar(value) end
  if depth > 12 then return "<depth>" end
  local out = {"{"}
  for _, key in ipairs(util.sortedKeys(value)) do
    out[#out + 1] = scalar(key)
    out[#out + 1] = "="
    out[#out + 1] = stableTable(value[key], depth + 1)
    out[#out + 1] = ";"
  end
  out[#out + 1] = "}"
  return table.concat(out)
end

-- Target identity deliberately excludes the parts tree. A mutable tree is
-- evidence for the later convergence phase, never evidence that the target
-- vehicle changed.
local function stateFingerprint(state)
  return table.concat({
    scalar(state.vehicleId),
    scalar(state.modelKey),
    scalar(configVerification.stableKey(state.configKey or (state.configIdentity and state.configIdentity.path))),
  }, "|")
end

local function partsFingerprint(state)
  return stableTable(type(state) == "table" and state.parts or {})
end

local function create(options)
  options = type(options) == "table" and options or {}
  local now = tonumber(options.startedAt) or 0
  return {
    token = options.token,
    operationId = options.operationId,
    operationGeneration = options.operationGeneration,
    phaseGeneration = options.phaseGeneration,
    targetGeneration = options.targetGeneration,
    phase = options.phase,
    expectedModelKey = options.modelKey,
    expectedConfigKey = options.configKey,
    expectedConfigIdentity = util.deepCopy(options.configIdentity),
    expectedParts = util.deepCopy(options.parts or {}),
    originalVehicleId = options.originalVehicleId,
    returnedVehicleId = options.returnedVehicleId,
    currentCandidateId = options.returnedVehicleId,
    recoveryOnly = options.recoveryOnly == true,
    startedAt = now,
    deadline = now + (tonumber(options.timeout) or 25),
    candidates = {},
    events = {},
    candidateSeen = {},
    candidateDrops = 0,
    eventDrops = 0,
    staleCallbackCount = 0,
    destroyed = {},
    rejected = {},
    suspectSwitchId = nil,
    lastState = nil,
    status = "vehicle_target_stabilizing",
    identityStatus = "tracking_target_identity",
    treeStatus = next(options.parts or {}) and "pending" or "not_required",
    identityConfirmed = false,
    identityConfirmedAt = nil,
    fingerprintReason = "identity_not_confirmed",
    stabilizer = vehicleStabilizer.create(options.stabilizer),
    treeStabilizer = vehicleStabilizer.create(options.treeStabilizer or {
      minimumFrames = 2, minimumScans = 2, pollInterval = 0,
    }),
  }
end

local function addCandidate(tracker, vehicleId, source, details)
  if type(vehicleId) ~= "number" or vehicleId < 0 then return false end
  local key = tostring(vehicleId)
  if not tracker.candidateSeen[key] then
    if #tracker.candidates >= LIMITS.candidates then
      tracker.candidateDrops = tracker.candidateDrops + 1
      return false
    end
    tracker.candidateSeen[key] = true
    tracker.candidates[#tracker.candidates + 1] = {
      vehicleId = vehicleId,
      source = source,
      details = util.deepCopy(details),
    }
  end
  tracker.currentCandidateId = vehicleId
  return true
end

local function addEvent(tracker, kind, details)
  if #tracker.events >= LIMITS.events then tracker.eventDrops = tracker.eventDrops + 1 end
  boundedAppend(tracker.events, {kind = kind, details = util.deepCopy(details)}, LIMITS.events)
end

local function staleEvent(tracker, kind, details)
  tracker.staleCallbackCount = tracker.staleCallbackCount + 1
  addEvent(tracker, kind, details)
  return false, "stale_callback_ignored"
end

local function bindReturned(tracker, vehicleId, strategy)
  tracker.returnedVehicleId = vehicleId
  addCandidate(tracker, vehicleId, "replace_return", {strategy = strategy})
  addEvent(tracker, "replace_return", {vehicleId = vehicleId, strategy = strategy})
end

local function onSpawned(tracker, vehicleId)
  if tracker.recoveryOnly and tracker.returnedVehicleId and vehicleId ~= tracker.returnedVehicleId then
    return staleEvent(tracker, "stale_spawn", {
      vehicleId = vehicleId,
      expectedVehicleId = tracker.returnedVehicleId,
      targetGeneration = tracker.targetGeneration,
    })
  end
  addCandidate(tracker, vehicleId, "spawn_callback")
  addEvent(tracker, "spawn", {vehicleId = vehicleId})
  return true, "candidate_recorded"
end

local function onSwitched(tracker, oldId, newId, player, replaceWriteInFlight)
  if player ~= nil and player ~= 0 then
    addEvent(tracker, "auxiliary_switch", {oldId = oldId, newId = newId, player = player})
    return true, "auxiliary_player_ignored"
  end
  local priorCandidateId = tracker.currentCandidateId
  addCandidate(tracker, newId, replaceWriteInFlight and "switch_during_replace" or "player_switch")
  addEvent(tracker, "switch", {oldId = oldId, newId = newId, player = player})
  if not replaceWriteInFlight and newId ~= priorCandidateId and newId ~= tracker.returnedVehicleId then
    tracker.suspectSwitchId = newId
  end
  if not tracker.identityConfirmed then vehicleStabilizer.reset(tracker.stabilizer, "vehicle_switch") end
  return true, "switch_candidate_recorded"
end

local function onDestroyed(tracker, vehicleId)
  tracker.destroyed[tostring(vehicleId)] = true
  addEvent(tracker, "destroyed", {vehicleId = vehicleId})
  if tracker.currentCandidateId == vehicleId then
    tracker.currentCandidateId = nil
    if not tracker.identityConfirmed then vehicleStabilizer.reset(tracker.stabilizer, "candidate_destroyed") end
  end
  return true
end

local function verifyIdentity(tracker, state)
  if tracker.expectedModelKey and state.modelKey ~= tracker.expectedModelKey then
    return false, "model_mismatch"
  end
  if tracker.expectedConfigIdentity then
    local ok, reason, details = configVerification.verify(tracker.expectedConfigIdentity, state)
    if not ok then return false, reason or "config_mismatch", details end
    return true, nil, details
  elseif tracker.expectedConfigKey then
    local expected = configVerification.expectation({
      modelKey = tracker.expectedModelKey,
      key = configVerification.stableKey(tracker.expectedConfigKey),
      path = tracker.expectedConfigKey,
    })
    local ok, reason, details = configVerification.verify(expected, state)
    if not ok then return false, reason or "config_mismatch", details end
    return true, nil, details
  end
  return true
end

local function verifyTree(tracker, state)
  for path, candidate in pairs(tracker.expectedParts or {}) do
    if type(state.parts) ~= "table" or state.parts[path] ~= candidate then
      return false, "parts_state_mismatch:" .. tostring(path)
    end
  end
  return true
end

local function verifyExpected(tracker, state)
  local identity, reason, details = verifyIdentity(tracker, state)
  if not identity then return false, reason, details end
  return verifyTree(tracker, state)
end

local function generationsMatch(tracker, context)
  if type(context) ~= "table" then return true end
  return (context.operationId == nil or context.operationId == tracker.operationId)
    and (context.operationGeneration == nil or context.operationGeneration == tracker.operationGeneration)
    and (context.phaseGeneration == nil or context.phaseGeneration == tracker.phaseGeneration)
    and (context.targetGeneration == nil or context.targetGeneration == tracker.targetGeneration)
end

local function observe(tracker, token, state, now, context)
  now = tonumber(now) or 0
  if token ~= tracker.token or not generationsMatch(tracker, context) then
    tracker.staleCallbackCount = tracker.staleCallbackCount + 1
    tracker.status = "stale_callback_ignored"
    return "failed", "stale_callback_ignored"
  end
  local waitingForSimulation = type(context) == "table" and context.waitingForSimulation == true
  if now >= tracker.deadline and not waitingForSimulation then
    tracker.status = "vehicle_target_timeout"
    return "failed", "vehicle_target_timeout"
  end
  if type(state) ~= "table" or type(state.vehicleId) ~= "number" then
    tracker.status = waitingForSimulation and "waiting_for_simulation_resume" or "vehicle_target_stabilizing"
    return "waiting", tracker.status
  end
  addCandidate(tracker, state.vehicleId, "player_poll", {modelKey = state.modelKey, configKey = state.configKey})

  local expected, reason, verificationDetails = verifyIdentity(tracker, state)
  if not expected then
    tracker.rejected[tostring(state.vehicleId)] = reason
    if tracker.suspectSwitchId == state.vehicleId and reason == "model_mismatch" then
      tracker.status = "external_vehicle_switch"
      return "cancelled", "external_vehicle_switch", {vehicleId = state.vehicleId, reason = reason}
    end
    if not tracker.identityConfirmed then vehicleStabilizer.reset(tracker.stabilizer, reason) end
    tracker.identityStatus = "tracking_target_identity"
    tracker.fingerprintReason = reason
    tracker.status = "vehicle_target_stabilizing"
    return "waiting", reason, verificationDetails
  end

  tracker.suspectSwitchId = nil
  tracker.currentCandidateId = state.vehicleId
  tracker.lastState = util.deepCopy(state)
  if not tracker.identityConfirmed then
    local stable, stableReason = vehicleStabilizer.observe(
      tracker.stabilizer, state.vehicleId, stateFingerprint(state), true
    )
    tracker.identityStatus = stableReason
    tracker.fingerprintReason = "target_identity"
    tracker.status = stableReason
    if not stable then return "waiting", stableReason end
    tracker.identityConfirmed = true
    tracker.identityConfirmedAt = now
    tracker.identityStatus = "target_identity_confirmed"
  end

  if next(tracker.expectedParts or {}) then
    local treeMatches, treeReason = verifyTree(tracker, state)
    if not treeMatches then
      vehicleStabilizer.reset(tracker.treeStabilizer, treeReason)
      tracker.treeStatus = waitingForSimulation and "waiting_for_simulation_resume" or "parts_tree_converging"
      tracker.fingerprintReason = "parts_tree_changed"
      tracker.status = tracker.treeStatus
      return "waiting", tracker.treeStatus, {identityConfirmed = true, treeReason = treeReason}
    end
    local treeStable, treeStableReason = vehicleStabilizer.observe(
      tracker.treeStabilizer, state.vehicleId, partsFingerprint(state), true
    )
    tracker.treeStatus = treeStableReason
    tracker.fingerprintReason = "parts_tree"
    tracker.status = treeStable and "parts_tree_converged" or "parts_tree_converging"
    if not treeStable then
      return "waiting", tracker.status, {identityConfirmed = true}
    end
  else
    tracker.treeStatus = "not_required"
  end

  tracker.status = "vehicle_target_stable"
  return "stable", "vehicle_target_stable", {
    vehicleId = state.vehicleId,
    state = util.deepCopy(state),
    verification = verificationDetails,
    identityConfirmed = true,
    treeStatus = tracker.treeStatus,
  }
end

local function summary(tracker, now)
  local metrics = vehicleStabilizer.metrics(tracker.stabilizer)
  local treeMetrics = vehicleStabilizer.metrics(tracker.treeStabilizer)
  metrics.status = tracker.status
  metrics.identityStatus = tracker.identityStatus
  metrics.identityConfirmed = tracker.identityConfirmed
  metrics.identityConfirmedAt = tracker.identityConfirmedAt
  metrics.treeStatus = tracker.treeStatus
  metrics.treeStabilizationFrames = treeMetrics.stabilizationFrames
  metrics.treeStabilizationScans = treeMetrics.stabilizationScans
  metrics.fingerprintReason = tracker.fingerprintReason
  metrics.candidateCount = #tracker.candidates
  metrics.candidateDrops = tracker.candidateDrops
  metrics.switchEventCount = #tracker.events
  metrics.eventDrops = tracker.eventDrops
  metrics.staleCallbackCount = tracker.staleCallbackCount
  metrics.stabilizationMs = math.max(0, ((tonumber(now) or tracker.startedAt) - tracker.startedAt) * 1000)
  metrics.currentCandidateId = tracker.currentCandidateId
  metrics.returnedVehicleId = tracker.returnedVehicleId
  metrics.operationGeneration = tracker.operationGeneration
  metrics.phaseGeneration = tracker.phaseGeneration
  metrics.targetGeneration = tracker.targetGeneration
  metrics.recoveryOnly = tracker.recoveryOnly
  return metrics
end

M.LIMITS = LIMITS
M.create = create
M.addCandidate = addCandidate
M.addEvent = addEvent
M.bindReturned = bindReturned
M.onSpawned = onSpawned
M.onSwitched = onSwitched
M.onDestroyed = onDestroyed
M.observe = observe
M.verifyIdentity = verifyIdentity
M.verifyTree = verifyTree
M.verifyExpected = verifyExpected
M.stateFingerprint = stateFingerprint
M.partsFingerprint = partsFingerprint
M.summary = summary

return M
