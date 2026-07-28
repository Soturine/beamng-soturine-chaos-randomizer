local configVerification = require("ge/extensions/soturineChaosRandomizer/configVerification")
local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local CANDIDATE_LIMIT = 24

local function configKey(target)
  target = type(target) == "table" and target or {}
  return configVerification.stableKey(
    target.configKey or target.selectedConfiguration
      or (target.configIdentity and target.configIdentity.path)
  )
end

local function generations(state)
  return {
    operationId = state.operationId,
    operationGeneration = state.operationGeneration,
    phaseGeneration = state.phaseGeneration,
    targetGeneration = state.targetGeneration,
  }
end

local function sync(context, state)
  local current = generations(state)
  context.operationId = current.operationId
  context.operationGeneration = current.operationGeneration
  context.phaseGeneration = current.phaseGeneration
  context.targetGeneration = current.targetGeneration
  context.cancellationToken = state.operationToken or state.token
  return context
end

local function create(state, cancellationToken, now, options)
  options = type(options) == "table" and options or {}
  local context = {
    domain = options.domain or "chaos",
    action = options.action,
    generation = options.generation or state.operationGeneration,
    expectedSlot = options.expectedSlot,
    expectedLogicalTarget = util.deepCopy(options.expectedLogicalTarget),
    sourceVehicleId = options.sourceVehicleId,
    sourceStillExists = options.sourceVehicleId ~= nil,
    candidateVehicleIds = {},
    acceptedVehicleId = nil,
    restoredVehicleId = nil,
    removedVehicleIds = {},
    playerVehicleIdAfter = nil,
    terminalState = nil,
    recoveryGeneration = 0,
    cancellationToken = cancellationToken,
    logicalTarget = nil,
    concreteTarget = nil,
    candidates = {},
    candidateById = {},
    destroyed = {},
    originalSnapshot = nil,
    lastAcceptedCheckpoint = "operation_started",
    wait = nil,
    rebindCount = 0,
    ownershipReleaseCount = 0,
    staleCandidateCount = 0,
    candidateDrops = 0,
    createdAt = tonumber(now) or 0,
  }
  return sync(context, state)
end

local function beginLogicalTarget(context, state, target, now)
  sync(context, state)
  target = type(target) == "table" and target or {}
  context.logicalTarget = {
    modelKey = target.modelKey,
    configKey = configKey(target),
    configIdentity = util.deepCopy(target.configIdentity),
    operationId = context.operationId,
    operationGeneration = context.operationGeneration,
    targetGeneration = context.targetGeneration,
    createdAt = tonumber(now) or 0,
  }
  context.concreteTarget = nil
  context.candidates = {}
  context.candidateById = {}
  context.destroyed = {}
  return context.logicalTarget
end

local function recordCandidate(context, state, candidate)
  candidate = type(candidate) == "table" and candidate or {}
  sync(context, state)
  if candidate.operationId ~= nil and candidate.operationId ~= context.operationId
    or candidate.operationGeneration ~= nil and candidate.operationGeneration ~= context.operationGeneration
    or candidate.targetGeneration ~= nil and candidate.targetGeneration ~= context.targetGeneration
  then
    context.staleCandidateCount = context.staleCandidateCount + 1
    return false, "stale_callback_rejected"
  end
  local vehicleId = tonumber(candidate.vehicleId)
  if vehicleId == nil or vehicleId < 0 then return false, "candidate_id_invalid" end
  if context.destroyed[tostring(vehicleId)] then return false, "candidate_destroyed" end
  local key = tostring(vehicleId)
  local entry = context.candidateById[key]
  if not entry then
    if #context.candidates >= CANDIDATE_LIMIT then
      context.candidateDrops = context.candidateDrops + 1
      return false, "candidate_limit_reached"
    end
    entry = {
      vehicleId = vehicleId,
      firstSource = candidate.source,
      sources = {},
      observedAt = tonumber(candidate.observedAt) or 0,
      operationId = context.operationId,
      operationGeneration = context.operationGeneration,
      targetGeneration = context.targetGeneration,
    }
    context.candidates[#context.candidates + 1] = entry
    context.candidateById[key] = entry
    context.candidateVehicleIds[#context.candidateVehicleIds + 1] = vehicleId
  end
  local source = tostring(candidate.source or "unknown")
  entry.sources[source] = true
  entry.source = source
  entry.observedAt = math.max(entry.observedAt or 0, tonumber(candidate.observedAt) or 0)
  for field, value in pairs(candidate) do
    if field ~= "sources" and field ~= "vehicleId" then entry[field] = util.deepCopy(value) end
  end
  entry.vehicleId = vehicleId
  entry.operationId = context.operationId
  entry.operationGeneration = context.operationGeneration
  entry.targetGeneration = context.targetGeneration
  return true, entry
end

local function releaseConcreteTarget(context, state, source, now)
  sync(context, state)
  local previous = context.concreteTarget and util.deepCopy(context.concreteTarget) or nil
  if previous then
    previous.source = source or "ownership_released"
    previous.observedAt = tonumber(now) or 0
    recordCandidate(context, state, previous)
  end
  context.concreteTarget = nil
  context.ownershipReleaseCount = context.ownershipReleaseCount + 1
  return previous
end

local function beginWait(context, state, target, reason, now)
  sync(context, state)
  target = type(target) == "table" and target or {}
  local logical = context.logicalTarget
  if logical == nil or logical.targetGeneration ~= context.targetGeneration then
    logical = beginLogicalTarget(context, state, target, now)
  else
    logical.modelKey = target.modelKey or logical.modelKey
    logical.configIdentity = util.deepCopy(target.configIdentity or logical.configIdentity)
    logical.configKey = configKey(target) or logical.configKey
    logical.operationGeneration = context.operationGeneration
    logical.targetGeneration = context.targetGeneration
  end
  local previous = releaseConcreteTarget(context, state, "before_" .. tostring(reason or "reload"), now)
  context.wait = {
    reason = reason,
    startedAt = tonumber(now) or 0,
    operationId = context.operationId,
    operationGeneration = context.operationGeneration,
    phaseGeneration = context.phaseGeneration,
    targetGeneration = context.targetGeneration,
    writeTarget = previous,
  }
  return context.wait, logical
end

local function bindInitial(context, state, target, now)
  sync(context, state)
  target = type(target) == "table" and target or {}
  if context.logicalTarget == nil or context.logicalTarget.targetGeneration ~= context.targetGeneration then
    beginLogicalTarget(context, state, target, now)
  end
  context.concreteTarget = {
    vehicleId = target.vehicleId,
    modelKey = target.modelKey,
    configKey = configKey(target),
    configIdentity = util.deepCopy(target.configIdentity),
    source = target.source or "initial_snapshot",
    observedAt = tonumber(now) or 0,
    operationId = context.operationId,
    operationGeneration = context.operationGeneration,
    targetGeneration = context.targetGeneration,
    playerIndex = 0,
    readStatus = target.readStatus or "ready",
    coherentTargetRead = target.coherentTargetRead ~= false,
  }
  return context.concreteTarget
end

local function rebindConcreteTarget(context, state, candidate, now)
  sync(context, state)
  candidate = type(candidate) == "table" and candidate or {}
  local wait = context.wait
  if type(wait) ~= "table" then return false, "target_wait_missing" end
  if wait.operationId ~= context.operationId
    or wait.operationGeneration ~= context.operationGeneration
    or wait.targetGeneration ~= context.targetGeneration
  then return false, "stale_callback_rejected" end
  local observedAt = tonumber(candidate.observedAt) or tonumber(now) or 0
  if observedAt < (wait.startedAt or 0) then return false, "candidate_before_current_wait" end
  if candidate.playerIndex ~= 0 then return false, "candidate_not_player_zero" end
  if candidate.stable ~= true then return false, "candidate_not_stable" end
  if candidate.coherentTargetRead ~= true then return false, "candidate_read_incoherent" end
  if context.destroyed[tostring(candidate.vehicleId)] then return false, "candidate_destroyed" end
  local logical = context.logicalTarget or {}
  if logical.modelKey and candidate.modelKey ~= logical.modelKey then return false, "target_model_mismatch" end
  if logical.configIdentity then
    local valid = configVerification.verify(logical.configIdentity, candidate)
    if not valid then return false, "target_config_mismatch" end
  elseif logical.configKey and configKey(candidate) and logical.configKey ~= configKey(candidate) then
    return false, "target_config_mismatch"
  end
  local recorded, entry = recordCandidate(context, state, candidate)
  if not recorded then return false, entry end
  context.concreteTarget = {
    vehicleId = entry.vehicleId,
    modelKey = entry.modelKey,
    configKey = configKey(entry),
    configIdentity = util.deepCopy(entry.configIdentity),
    source = entry.source,
    observedAt = entry.observedAt,
    operationId = context.operationId,
    operationGeneration = context.operationGeneration,
    targetGeneration = context.targetGeneration,
    playerIndex = 0,
    readStatus = entry.readStatus,
    coherentTargetRead = true,
    correlationEvidence = util.deepCopy(entry.correlationEvidence),
  }
  context.rebindCount = context.rebindCount + 1
  context.lastAcceptedCheckpoint = "concrete_target_rebound"
  return true, context.concreteTarget
end

local function markDestroyed(context, vehicleId)
  context.destroyed[tostring(vehicleId)] = true
  local entry = context.candidateById[tostring(vehicleId)]
  if entry then entry.destroyed = true end
  if context.concreteTarget and context.concreteTarget.vehicleId == vehicleId then context.concreteTarget = nil end
end

local function markAccepted(context, vehicleId, playerVehicleIdAfter)
  context.acceptedVehicleId = tonumber(vehicleId)
  context.playerVehicleIdAfter = tonumber(playerVehicleIdAfter) or context.acceptedVehicleId
  context.lastAcceptedCheckpoint = "vehicle_accepted"
  return context.acceptedVehicleId ~= nil
end

local function markTerminal(context, terminalState, options)
  options = type(options) == "table" and options or {}
  if context.terminalState ~= nil then return context.terminalState == terminalState end
  context.terminalState = terminalState
  context.restoredVehicleId = tonumber(options.restoredVehicleId)
  context.sourceStillExists = options.sourceStillExists == true
  context.playerVehicleIdAfter = tonumber(options.playerVehicleIdAfter) or context.playerVehicleIdAfter
  context.removedVehicleIds = util.deepCopy(options.removedVehicleIds or context.removedVehicleIds)
  return true
end

local function summary(context)
  return {
    domain = context.domain,
    action = context.action,
    generation = context.generation,
    expectedSlot = context.expectedSlot,
    expectedLogicalTarget = util.deepCopy(context.expectedLogicalTarget),
    sourceVehicleId = context.sourceVehicleId,
    sourceStillExists = context.sourceStillExists,
    candidateVehicleIds = util.deepCopy(context.candidateVehicleIds),
    acceptedVehicleId = context.acceptedVehicleId,
    restoredVehicleId = context.restoredVehicleId,
    removedVehicleIds = util.deepCopy(context.removedVehicleIds),
    playerVehicleIdAfter = context.playerVehicleIdAfter,
    terminalState = context.terminalState,
    operationId = context.operationId,
    operationGeneration = context.operationGeneration,
    phaseGeneration = context.phaseGeneration,
    targetGeneration = context.targetGeneration,
    recoveryGeneration = context.recoveryGeneration,
    cancellationToken = context.cancellationToken,
    logicalTarget = util.deepCopy(context.logicalTarget),
    concreteTarget = util.deepCopy(context.concreteTarget),
    candidates = util.deepCopy(context.candidates),
    lastAcceptedCheckpoint = context.lastAcceptedCheckpoint,
    rebindCount = context.rebindCount,
    ownershipReleaseCount = context.ownershipReleaseCount,
    staleCandidateCount = context.staleCandidateCount,
    candidateDrops = context.candidateDrops,
    wait = util.deepCopy(context.wait),
  }
end

M.CANDIDATE_LIMIT = CANDIDATE_LIMIT
M.create = create
M.sync = sync
M.beginLogicalTarget = beginLogicalTarget
M.beginWait = beginWait
M.bindInitial = bindInitial
M.recordCandidate = recordCandidate
M.releaseConcreteTarget = releaseConcreteTarget
M.rebindConcreteTarget = rebindConcreteTarget
M.markDestroyed = markDestroyed
M.markAccepted = markAccepted
M.markTerminal = markTerminal
M.summary = summary

return M
