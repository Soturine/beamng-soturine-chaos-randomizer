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

local function evidenceStates(state)
  if type(state) ~= "table" then return {} end
  local result = {}
  for _, candidate in ipairs(state.configCandidates or {}) do
    if type(candidate) == "table" then
      local merged = util.shallowMerge(state, candidate)
      merged.configCandidates = nil
      merged.evidenceSource = candidate.source or "config_candidate"
      result[#result + 1] = merged
    end
  end
  if #result == 0 then result[1] = state end
  return result
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
    expectedVehicleId = options.vehicleId,
    expectedConfigIdentity = util.deepCopy(options.configIdentity),
    expectedParts = util.deepCopy(options.parts or {}),
    expectedTuning = util.deepCopy(options.tuning or {}),
    expectedTuningMetadata = util.deepCopy(options.tuningMetadata or {}),
    requirePartsReadable = options.requirePartsReadable == true,
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
    callbackSeen = false,
    spawnCallbackSeen = false,
    switchCallbackSeen = false,
    lastObservedAt = nil,
    lastReason = "target_identity_unstable",
    lastState = nil,
    status = "vehicle_target_stabilizing",
    identityStatus = "tracking_target_identity",
    treeStatus = (next(options.parts or {}) or options.requirePartsReadable == true) and "pending" or "not_required",
    identityConfirmed = false,
    identityReported = false,
    identityConfirmedAt = nil,
    fingerprintReason = "identity_not_confirmed",
    finalReadAttempted = false,
    finalReadAccepted = false,
    stabilizer = vehicleStabilizer.create(options.stabilizer),
    treeStabilizer = vehicleStabilizer.create(options.treeStabilizer or {
      minimumFrames = 2, minimumScans = 2, pollInterval = 0,
    }),
  }
end

local function addCandidate(tracker, vehicleId, source, details)
  if type(vehicleId) ~= "number" or vehicleId < 0 then return false end
  local key = tostring(vehicleId)
  local entry = tracker.candidateSeen[key]
  if not entry then
    if #tracker.candidates >= LIMITS.candidates then
      tracker.candidateDrops = tracker.candidateDrops + 1
      return false
    end
    entry = {
      vehicleId = vehicleId,
      source = source,
      sources = {[source or "unknown"] = true},
      observedAt = details and details.observedAt,
      details = util.deepCopy(details),
    }
    tracker.candidateSeen[key] = entry
    tracker.candidates[#tracker.candidates + 1] = entry
  else
    entry.source = source or entry.source
    entry.sources[source or "unknown"] = true
    entry.observedAt = details and details.observedAt or entry.observedAt
    entry.details = util.shallowMerge(entry.details or {}, util.deepCopy(details or {}))
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
  tracker.lastReason = "stale_callback_rejected"
  return false, tracker.lastReason
end

local function bindReturned(tracker, vehicleId, strategy)
  tracker.returnedVehicleId = vehicleId
  addCandidate(tracker, vehicleId, "replace_return", {strategy = strategy})
  addEvent(tracker, "replace_return", {vehicleId = vehicleId, strategy = strategy})
end

local function onSpawned(tracker, vehicleId)
  tracker.callbackSeen = true
  tracker.spawnCallbackSeen = true
  addCandidate(tracker, vehicleId, "spawn_callback")
  addEvent(tracker, "spawn", {vehicleId = vehicleId})
  return true, "candidate_recorded"
end

local function onSwitched(tracker, oldId, newId, player, replaceWriteInFlight)
  if player ~= nil and player ~= 0 then
    addEvent(tracker, "auxiliary_switch", {oldId = oldId, newId = newId, player = player})
    return true, "auxiliary_player_ignored"
  end
  tracker.callbackSeen = true
  tracker.switchCallbackSeen = true
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
  if tracker.returnedVehicleId == vehicleId then
    tracker.returnedVehicleId = nil
    tracker.expectedVehicleId = nil
    tracker.lastReason = "target_id_changed"
  end
  return true
end

local function verifyIdentity(tracker, state)
  if tracker.destroyed[tostring(state.vehicleId)] then return false, "candidate_destroyed" end
  if tracker.expectedModelKey and state.modelKey ~= tracker.expectedModelKey then
    return false, "target_model_mismatch"
  end
  local views = evidenceStates(state)
  if tracker.expectedConfigIdentity then
    local lastReason, lastDetails
    for _, view in ipairs(views) do
      local ok, reason, details = configVerification.verify(tracker.expectedConfigIdentity, view)
      if ok then
        details = util.shallowMerge(details or {}, {evidenceSource = view.evidenceSource or "primary"})
        return true, nil, details, view
      end
      lastReason, lastDetails = reason, details
    end
    return false, "target_config_mismatch", {
      verificationReason = lastReason, verification = lastDetails,
      evidenceCount = #views,
    }
  elseif tracker.expectedConfigKey then
    local expected = configVerification.expectation({
      modelKey = tracker.expectedModelKey,
      key = configVerification.stableKey(tracker.expectedConfigKey),
      path = tracker.expectedConfigKey,
    })
    local lastReason, lastDetails
    for _, view in ipairs(views) do
      local ok, reason, details = configVerification.verify(expected, view)
      if ok then
        details = util.shallowMerge(details or {}, {evidenceSource = view.evidenceSource or "primary"})
        return true, nil, details, view
      end
      lastReason, lastDetails = reason, details
    end
    return false, "target_config_mismatch", {
      verificationReason = lastReason, verification = lastDetails,
      evidenceCount = #views,
    }
  end
  return true, nil, {strategy = "model_identity", evidenceSource = "identity"}, state
end

local function verifyTree(tracker, state)
  if tracker.requirePartsReadable and (state.partsAvailable == false or type(state.parts) ~= "table") then
    return false, "tree_unavailable", {readStatus = state.readStatus}
  end
  for path, candidate in pairs(tracker.expectedParts or {}) do
    if type(state.parts) ~= "table" or state.parts[path] ~= candidate then
      return false, "tree_changed_legitimately", {
        path = path, expected = candidate, current = type(state.parts) == "table" and state.parts[path] or nil,
      }
    end
  end
  return true
end

local function verifyTuning(tracker, state)
  if not next(tracker.expectedTuning or {}) then return true end
  if type(state.tuning) ~= "table" then return false, "tuning_readback_unavailable" end
  for name, requested in pairs(tracker.expectedTuning) do
    local observed = tonumber(state.tuning[name])
    local expected = tonumber(requested)
    if not util.isFinite(observed) or not util.isFinite(expected) then
      return false, "tuning_readback_mismatch", {name = name, requested = requested, observed = state.tuning[name]}
    end
    local metadata = tracker.expectedTuningMetadata[name] or {}
    local tolerance = tonumber(metadata.tolerance) or 1e-7
    local minimum, maximum = tonumber(metadata.minimum), tonumber(metadata.maximum)
    local exact = math.abs(observed - expected) <= tolerance
    local validClamp = util.isFinite(minimum) and util.isFinite(maximum)
      and observed >= minimum - tolerance and observed <= maximum + tolerance
    if not exact and not validClamp then
      return false, "tuning_readback_mismatch", {name = name, requested = expected, observed = observed}
    end
  end
  return true
end

local function verifyExpected(tracker, state)
  local identity, reason, details, resolved = verifyIdentity(tracker, state)
  if not identity then return false, reason, details end
  resolved = resolved or state
  local tree, treeReason, treeDetails = verifyTree(tracker, resolved)
  if not tree then return false, treeReason, treeDetails end
  local tuning, tuningReason, tuningDetails = verifyTuning(tracker, resolved)
  return tuning, tuningReason, tuningDetails or details, resolved
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
    tracker.status = "stale_callback_rejected"
    tracker.lastReason = tracker.status
    return "failed", tracker.status
  end
  local deadlineReached = now >= tracker.deadline
  if type(state) ~= "table" or type(state.vehicleId) ~= "number" then
    if deadlineReached then
      tracker.status = tracker.callbackSeen and "operation_deadline_exceeded" or "target_callback_missing"
      tracker.lastReason = tracker.status
      return "failed", tracker.status
    end
    tracker.status = "vehicle_target_stabilizing"
    tracker.lastReason = "target_identity_unstable"
    return "waiting", tracker.lastReason
  end
  tracker.lastObservedAt = now
  addCandidate(tracker, state.vehicleId, "player_poll", {
    observedAt = now, modelKey = state.modelKey, configKey = state.configKey,
    playerIndex = state.playerIndex, readStatus = state.readStatus,
  })

  local expected, reason, verificationDetails, resolvedState = verifyIdentity(tracker, state)
  if not expected then
    tracker.rejected[tostring(state.vehicleId)] = reason
    if tracker.suspectSwitchId == state.vehicleId
      and (reason == "target_model_mismatch" or reason == "target_config_mismatch")
    then
      tracker.status = "external_vehicle_switch"
      return "cancelled", "external_vehicle_switch", {vehicleId = state.vehicleId, reason = reason}
    end
    if deadlineReached then
      tracker.finalReadAttempted = true
      tracker.status = "operation_deadline_exceeded"
      tracker.lastReason = tracker.status
      return "failed", tracker.status, {finalReadReason = reason, verification = verificationDetails}
    end
    if not tracker.identityConfirmed then vehicleStabilizer.reset(tracker.stabilizer, reason) end
    tracker.identityStatus = "tracking_target_identity"
    tracker.fingerprintReason = reason
    tracker.lastReason = reason
    tracker.status = "vehicle_target_stabilizing"
    return "waiting", reason, verificationDetails
  end

  if deadlineReached then
    tracker.finalReadAttempted = true
    local finalVerified, finalReason, finalDetails, finalState = verifyExpected(tracker, state)
    local coherent = state.playerIndex == 0 and state.coherentTargetRead == true
    if not finalVerified or not coherent then
      tracker.status = "operation_deadline_exceeded"
      tracker.lastReason = tracker.status
      return "failed", tracker.status, {
        finalReadReason = finalVerified and "candidate_read_incoherent" or finalReason,
        verification = finalDetails,
      }
    end
    tracker.finalReadAccepted = true
    tracker.identityConfirmed = true
    tracker.identityReported = true
    tracker.identityConfirmedAt = now
    tracker.identityStatus = "target_identity_confirmed"
    tracker.treeStatus = (next(tracker.expectedParts or {}) ~= nil or tracker.requirePartsReadable)
      and "parts_tree_converged" or "not_required"
    finalState = finalState or resolvedState or state
    tracker.currentCandidateId = finalState.vehicleId
    tracker.lastState = util.deepCopy(finalState)
    tracker.status = "vehicle_target_stable"
    tracker.lastReason = "final_read_accepted"
    return "stable", "final_read_accepted", {
      vehicleId = finalState.vehicleId, state = util.deepCopy(finalState), verification = finalDetails,
      identityConfirmed = true, treeStatus = tracker.treeStatus, finalReadAccepted = true,
    }
  end

  tracker.suspectSwitchId = nil
  state = resolvedState or state
  tracker.currentCandidateId = state.vehicleId
  tracker.lastState = util.deepCopy(state)
  if not tracker.identityConfirmed then
    local stable, stableReason = vehicleStabilizer.observe(
      tracker.stabilizer, state.vehicleId, stateFingerprint(state), true
    )
    tracker.identityStatus = stableReason
    tracker.fingerprintReason = "target_identity"
    tracker.status = stableReason
    tracker.lastReason = stable and "target_identity_confirmed" or "target_identity_unstable"
    if not stable then return "waiting", tracker.lastReason end
    tracker.identityConfirmed = true
    tracker.identityConfirmedAt = now
    tracker.identityStatus = "target_identity_confirmed"
  end

  -- Identity ownership is a completed lifecycle milestone before any mutable
  -- parts-tree convergence is considered. Reporting it separately prevents a
  -- legitimate reload from being reclassified as a different target.
  if not tracker.identityReported then tracker.identityReported = true end

  if next(tracker.expectedParts or {}) or tracker.requirePartsReadable then
    local treeMatches, treeReason, treeDetails = verifyTree(tracker, state)
    if not treeMatches then
      vehicleStabilizer.reset(tracker.treeStabilizer, treeReason)
      tracker.treeStatus = "parts_tree_converging"
      tracker.fingerprintReason = "parts_tree_changed"
      tracker.status = tracker.treeStatus
      tracker.lastReason = treeReason
      return "waiting", treeReason, {
        identityConfirmed = true, treeReason = treeReason, treeDetails = treeDetails,
      }
    end
    local treeStable, treeStableReason = vehicleStabilizer.observe(
      tracker.treeStabilizer, state.vehicleId, partsFingerprint(state), true
    )
    tracker.treeStatus = treeStableReason
    tracker.fingerprintReason = "parts_tree"
    tracker.status = treeStable and "parts_tree_converged" or "parts_tree_converging"
    if not treeStable then
      tracker.lastReason = "parts_reload_pending"
      return "waiting", tracker.lastReason, {identityConfirmed = true}
    end
  else
    tracker.treeStatus = "not_required"
  end

  tracker.status = "vehicle_target_stable"
  tracker.lastReason = tracker.status
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
  metrics.identityReported = tracker.identityReported
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
  metrics.expectedVehicleId = tracker.returnedVehicleId or tracker.expectedVehicleId
  metrics.returnedVehicleId = tracker.returnedVehicleId
  metrics.operationGeneration = tracker.operationGeneration
  metrics.phaseGeneration = tracker.phaseGeneration
  metrics.targetGeneration = tracker.targetGeneration
  metrics.recoveryOnly = tracker.recoveryOnly
  metrics.callbackSeen = tracker.callbackSeen
  metrics.spawnCallbackSeen = tracker.spawnCallbackSeen
  metrics.switchCallbackSeen = tracker.switchCallbackSeen
  metrics.lastObservedAt = tracker.lastObservedAt
  metrics.lastReason = tracker.lastReason
  metrics.finalReadAttempted = tracker.finalReadAttempted
  metrics.finalReadAccepted = tracker.finalReadAccepted
  metrics.expectedModelKey = tracker.expectedModelKey
  metrics.expectedConfigKey = tracker.expectedConfigKey
  metrics.candidateChain = util.deepCopy(tracker.candidates)
  metrics.stateFingerprint = tracker.lastState and stateFingerprint(tracker.lastState) or nil
  metrics.treeFingerprint = tracker.lastState and partsFingerprint(tracker.lastState) or nil
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
M.verifyTuning = verifyTuning
M.verifyExpected = verifyExpected
M.stateFingerprint = stateFingerprint
M.partsFingerprint = partsFingerprint
M.summary = summary

return M
