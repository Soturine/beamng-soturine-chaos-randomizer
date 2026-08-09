local util = require("ge/extensions/soturineChaosRandomizer/util")
local vehicleIdentity = require("ge/extensions/soturineChaosRandomizer/vehicleIdentity")

local M = {}

local DOMAINS = {chaos = true, race = true, garage = true}
local TERMINAL = {
  completed = true, partial_success = true, failed = true, cancelled = true,
  rolled_back = true, superseded = true,
}
local ROLES = {
  player_source = true, player_candidate = true, player_result = true,
  race_competitor = true, race_candidate = true, orphan = true, external = true,
}

local function vehicleKey(vehicleId)
  local value = tonumber(vehicleId)
  if value == nil or value < 0 or value ~= math.floor(value) then return nil end
  return tostring(value), value
end

local function create(options)
  options = type(options) == "table" and options or {}
  return {
    sequence = 0,
    historyLimit = math.max(8, math.min(128, math.floor(tonumber(options.historyLimit) or 48))),
    domains = {
      chaos = {generation = 0, active = nil, history = {}, sessionQuarantine = {}},
      race = {generation = 0, active = nil, history = {}, sessionQuarantine = {}},
      garage = {generation = 0, active = nil, history = {}, sessionQuarantine = {}},
    },
    vehicleOwnership = {},
    ownershipOrder = {},
    orphanVehicleIds = {},
    orphanQueue = {}, orphanQueueHead = 1, orphanQueued = {},
    cleanupLog = {},
    callbackDiagnostics = {},
  }
end

local function boundedDiagnostic(state, context, code, token)
  local record = {
    code = tostring(code), domain = token and token.domain or nil,
    operationId = token and token.operationId or nil,
    generation = token and token.generation or nil,
    callbackToken = token and token.callbackToken or nil,
    kind = token and token.kind or nil,
  }
  state.callbackDiagnostics[#state.callbackDiagnostics + 1] = record
  while #state.callbackDiagnostics > 32 do table.remove(state.callbackDiagnostics, 1) end
  if context then
    context.callbackDiagnostics[#context.callbackDiagnostics + 1] = util.deepCopy(record)
    while #context.callbackDiagnostics > 16 do table.remove(context.callbackDiagnostics, 1) end
  end
end

local function archive(state, domainState, context)
  if type(context) ~= "table" then return end
  domainState.history[#domainState.history + 1] = util.deepCopy(context)
  while #domainState.history > state.historyLimit do table.remove(domainState.history, 1) end
end

local function begin(state, options)
  options = type(options) == "table" and options or {}
  local domain = tostring(options.domain or "")
  if not DOMAINS[domain] then return nil, "operation_domain_invalid" end
  local action = tostring(options.action or "")
  if action == "" then return nil, "operation_action_invalid" end
  local domainState = state.domains[domain]
  local superseded
  if domainState.active and not TERMINAL[domainState.active.terminalState] then
    domainState.active.terminalState = "superseded"
    domainState.active.status = "superseded"
    domainState.active.endedAt = tonumber(options.createdAt) or 0
    domainState.active.callbackDisposition = "callbacks_invalidated"
    superseded = util.deepCopy(domainState.active)
    archive(state, domainState, domainState.active)
  end
  state.sequence = state.sequence + 1
  domainState.generation = domainState.generation + 1
  local operationId = options.operationId or (domain .. ":" .. tostring(state.sequence))
  local context = {
    domain = domain,
    operationId = operationId,
    generation = domainState.generation,
    action = action,
    operationKind = action,
    phase = "created",
    status = "active",
    expectedSlot = options.expectedSlot,
    expectedLogicalTarget = util.deepCopy(options.expectedLogicalTarget),
    logicalTarget = util.deepCopy(options.expectedLogicalTarget),
    concreteVehicleId = nil,
    sourceVehicleId = tonumber(options.sourceVehicleId),
    sourceConcreteId = tonumber(options.sourceVehicleId),
    controlledConcreteId = tonumber(options.sourceVehicleId),
    candidateConcreteId = nil,
    acceptedConcreteId = nil,
    sourceStillExists = options.sourceVehicleId ~= nil,
    candidateVehicleIds = {},
    candidateById = {},
    createdVehicleIds = {},
    removedVehicleIds = {},
    ownedVehicleIds = {},
    ownedTemporaryIds = {},
    expectedRemovedIds = {},
    expectedAddedIds = {},
    acceptedIds = {},
    acceptedVehicleId = nil,
    restoredVehicleId = nil,
    playerVehicleIdAfter = nil,
    pendingCallbacks = {},
    pendingCallbackCount = 0,
    pendingTimers = 0,
    phaseSequence = 0,
    semanticProgressSequence = 0,
    callbackSequence = 0,
    consumedCallbackTokens = {},
    callbackDiagnostics = {},
    cancelToken = options.cancelToken,
    timeoutState = "idle",
    recoveryState = "idle",
    rollbackReason = nil,
    rollbackApplied = false,
    terminalState = nil,
    bindingState = "UNBOUND",
    expectedModel = options.expectedModel,
    expectedConfig = options.expectedConfig,
    seed = options.seed,
    rng = options.rng,
    catalogQuarantine = {},
    callbackDisposition = "pending",
    cleanupResult = {removed = {}, failed = {}, skipped = {}},
    worldVehicleIdsBefore = util.deepCopy(options.worldVehicleIdsBefore or {}),
    worldVehicleIdsAfter = {},
    worldVehicleCountBefore = #(options.worldVehicleIdsBefore or {}),
    worldVehicleCountAfter = nil,
    worldVehicleDelta = nil,
    staleCallbackCount = 0,
    staleCallbackSideEffects = 0,
    staleCallbackEffectsPrevented = 0,
    peakOwnedTemporaryCount = 0,
    peakWorldVehicleCount = #(options.worldVehicleIdsBefore or {}),
    worldVehicleIdsCurrent = util.deepCopy(options.worldVehicleIdsBefore or {}),
    unexpectedNewIds = {},
    unexpectedRemovedIds = {},
    missingExpectedAddedIds = {},
    missingExpectedRemovedIds = {},
    transactionCardinalityValid = nil,
    identityChangeReason = nil,
    lastCallbackToken = nil,
    createdAt = tonumber(options.createdAt) or 0,
  }
  domainState.active = context
  return context, superseded
end

local function active(state, domain)
  return state.domains[domain] and state.domains[domain].active or nil
end

local function callbackToken(context, kind, values)
  values = type(values) == "table" and values or {}
  context.callbackSequence = (context.callbackSequence or 0) + 1
  local sequence = context.callbackSequence
  return {
    domain = context.domain,
    operationId = context.operationId,
    generation = context.generation,
    kind = kind or "callback",
    callbackToken = tostring(context.operationId) .. ":" .. tostring(context.generation)
      .. ":" .. tostring(context.phaseSequence or 0) .. ":" .. tostring(sequence),
    phase = context.phase,
    phaseSequence = context.phaseSequence or 0,
    expectedSlot = values.expectedSlot or context.expectedSlot,
    slotId = values.slotId or values.expectedSlot or context.expectedSlot,
    expectedLogicalTarget = util.deepCopy(values.expectedLogicalTarget or context.expectedLogicalTarget),
    expectedVehicleId = tonumber(values.expectedVehicleId or values.vehicleId),
    vehicleId = tonumber(values.vehicleId),
  }
end

local function validateCallback(state, token, observedVehicleId, consume)
  if type(token) ~= "table" or not DOMAINS[token.domain] then
    boundedDiagnostic(state, nil, "callback_token_invalid", token)
    return false, "callback_token_invalid"
  end
  local context = active(state, token.domain)
  if not context or context.operationId ~= token.operationId
    or context.generation ~= token.generation
  then
    if context then
      context.staleCallbackCount = (context.staleCallbackCount or 0) + 1
      context.staleCallbackEffectsPrevented = (context.staleCallbackEffectsPrevented or 0) + 1
    end
    boundedDiagnostic(state, context, "ignored_stale_callback", token)
    return false, "ignored_stale_callback"
  end
  if TERMINAL[context.terminalState] then
    context.staleCallbackCount = (context.staleCallbackCount or 0) + 1
    context.staleCallbackEffectsPrevented = (context.staleCallbackEffectsPrevented or 0) + 1
    boundedDiagnostic(state, context, "ignored_stale_callback", token)
    return false, "ignored_stale_callback"
  end
  if token.phaseSequence ~= nil and tonumber(token.phaseSequence) ~= tonumber(context.phaseSequence) then
    context.staleCallbackCount = (context.staleCallbackCount or 0) + 1
    context.staleCallbackEffectsPrevented = (context.staleCallbackEffectsPrevented or 0) + 1
    boundedDiagnostic(state, context, "callback_phase_mismatch", token)
    return false, "callback_phase_mismatch"
  end
  if token.expectedSlot ~= nil and context.expectedSlot ~= nil
    and tostring(token.expectedSlot) ~= tostring(context.expectedSlot)
  then boundedDiagnostic(state, context, "callback_slot_mismatch", token); return false, "callback_slot_mismatch" end
  local observed = tonumber(observedVehicleId)
  if token.expectedVehicleId ~= nil and observed ~= nil
    and tonumber(token.expectedVehicleId) ~= observed
  then boundedDiagnostic(state, context, "callback_vehicle_mismatch", token); return false, "callback_vehicle_mismatch" end
  local key = token.callbackToken
  if type(key) ~= "string" or key == "" then
    boundedDiagnostic(state, context, "callback_token_missing", token)
    return false, "callback_token_missing"
  end
  if context.consumedCallbackTokens[key] then
    context.staleCallbackCount = (context.staleCallbackCount or 0) + 1
    context.staleCallbackEffectsPrevented = (context.staleCallbackEffectsPrevented or 0) + 1
    boundedDiagnostic(state, context, "callback_already_consumed", token)
    return false, "callback_already_consumed"
  end
  if consume == true then
    context.consumedCallbackTokens[key] = true
    context.lastCallbackToken = key
  end
  return true, context
end

local function setPhase(context, phase, status)
  if TERMINAL[context.terminalState] then return false, "operation_terminal" end
  local nextPhase = tostring(phase or context.phase)
  if nextPhase ~= context.phase then
    context.phaseSequence = (context.phaseSequence or 0) + 1
    context.phase = nextPhase
  end
  context.status = tostring(status or context.status)
  return true
end

local function ownVehicle(state, vehicleId, metadata)
  local key, numeric = vehicleKey(vehicleId)
  if not key then return false, "vehicle_ownership_id_invalid" end
  metadata = type(metadata) == "table" and metadata or {}
  local role = tostring(metadata.role or "external")
  if not ROLES[role] then return false, "vehicle_ownership_role_invalid" end
  local current = state.vehicleOwnership[key]
  local identity = vehicleIdentity.normalize(metadata.identity or current and current.identity, numeric)
  if metadata.managed == true and not vehicleIdentity.canMutate(identity) then
    return false, "vehicle_authority_not_mutable"
  end
  local replacing = current and (current.domain ~= metadata.domain
    or current.operationId ~= metadata.operationId
    or current.generation ~= metadata.generation
    or current.identity and not vehicleIdentity.same(current.identity, identity))
  if replacing and current.role == "race_competitor" and current.accepted == true
    and metadata.transfer ~= true
  then return false, "vehicle_owned_by_other_slot" end
  if replacing and metadata.transfer ~= true and current.terminal ~= true and current.removed ~= true then
    return false, "vehicle_owned_by_other_operation"
  end
  if replacing then
    -- Vehicle ids are reusable in BeamNG.  Once their former operation is
    -- terminal (or the object was removed), the new operation gets a clean
    -- ownership record instead of inheriting managed/accepted flags.
    current = {vehicleId = numeric}
    state.vehicleOwnership[key] = current
  end
  if not current then
    current = {vehicleId = numeric}
    state.vehicleOwnership[key] = current
    state.ownershipOrder[#state.ownershipOrder + 1] = key
  end
  current.domain = metadata.domain or current.domain
  current.identity = util.deepCopy(identity)
  current.operationId = metadata.operationId or current.operationId
  current.generation = metadata.generation or current.generation
  current.role = role
  current.slot = metadata.slot ~= nil and metadata.slot or current.slot
  current.managed = metadata.managed == true or current.managed == true
  current.created = metadata.created == true or current.created == true
  current.accepted = metadata.accepted == true
  current.terminal = metadata.terminal == true
  current.updatedAt = tonumber(metadata.updatedAt) or current.updatedAt or 0
  local domainContext = current.domain and active(state, current.domain)
  if domainContext and domainContext.operationId == current.operationId
    and domainContext.generation == current.generation
  then
    if not util.arrayContains(domainContext.ownedVehicleIds, numeric) then
      domainContext.ownedVehicleIds[#domainContext.ownedVehicleIds + 1] = numeric
    end
    if current.created and not util.arrayContains(domainContext.createdVehicleIds, numeric) then
      domainContext.createdVehicleIds[#domainContext.createdVehicleIds + 1] = numeric
    end
  end
  return true, current
end

local function ownership(state, vehicleId)
  local key = vehicleKey(vehicleId)
  return key and state.vehicleOwnership[key] or nil
end

local function transferVehicle(state, vehicleId, target)
  local current = ownership(state, vehicleId)
  if not current then return false, "vehicle_ownership_missing" end
  target = util.shallowMerge(target or {}, {transfer = true, created = current.created, managed = current.managed})
  return ownVehicle(state, vehicleId, target)
end

local function registerCandidate(state, token, vehicleId, metadata)
  local valid, contextOrReason = validateCallback(state, token, vehicleId, true)
  if not valid then return false, contextOrReason end
  local context = contextOrReason
  local key, numeric = vehicleKey(vehicleId)
  if not key then return false, "candidate_id_invalid" end
  metadata = type(metadata) == "table" and metadata or {}
  local sourceId = tonumber(context.sourceVehicleId)
  local created = metadata.created ~= false and numeric ~= sourceId
  if context.action == "scramble" and numeric ~= sourceId then
    context.identityChangeReason = "scramble_concrete_vehicle_changed"
    boundedDiagnostic(state, context, "scramble_identity_changed", token)
    return false, "scramble_identity_changed"
  end
  if created and context.domain == "chaos" and not context.candidateById[key] then
    local temporaryCount = 0
    for _, ownedId in ipairs(context.ownedTemporaryIds or {}) do
      local entry = ownership(state, ownedId)
      if entry and entry.removed ~= true and entry.accepted ~= true then temporaryCount = temporaryCount + 1 end
    end
    if temporaryCount >= 1 then
      context.cardinalityViolation = "peak_owned_temporary_count"
      boundedDiagnostic(state, context, "owned_temporary_cardinality_violation", token)
      return false, "owned_temporary_cardinality_violation"
    end
  end
  if not context.candidateById[key] then
    context.candidateById[key] = {
      vehicleId = numeric, source = metadata.source or token.kind,
      observedAt = tonumber(metadata.observedAt) or 0,
    }
    context.candidateVehicleIds[#context.candidateVehicleIds + 1] = numeric
  end
  local role = context.domain == "race" and "race_candidate" or "player_candidate"
  local owned, result = ownVehicle(state, numeric, {
    domain = context.domain, operationId = context.operationId, generation = context.generation,
    role = metadata.role or role, slot = token.expectedSlot, managed = created,
    created = created, accepted = false, updatedAt = metadata.observedAt,
    identity = metadata.identity,
  })
  if not owned then return false, result end
  context.candidateConcreteId = numeric
  if created and not util.arrayContains(context.ownedTemporaryIds, numeric) then
    context.ownedTemporaryIds[#context.ownedTemporaryIds + 1] = numeric
  end
  local currentTemporaryCount = 0
  for _, ownedId in ipairs(context.ownedTemporaryIds) do
    local entry = ownership(state, ownedId)
    if entry and entry.removed ~= true and entry.accepted ~= true then currentTemporaryCount = currentTemporaryCount + 1 end
  end
  context.peakOwnedTemporaryCount = math.max(context.peakOwnedTemporaryCount or 0, currentTemporaryCount)
  context.callbackDisposition = "candidate_recorded"
  if context.bindingState == "UNBOUND" or context.bindingState == "BINDING" then
    context.bindingState = "CANDIDATE_DISCOVERED"
  end
  return true, context.candidateById[key]
end

local function canCreateTemporary(state, context, replacingVehicleId)
  if type(context) ~= "table" then return false, "operation_context_missing" end
  local replacing = tonumber(replacingVehicleId)
  local count = 0
  for _, vehicleId in ipairs(context.ownedTemporaryIds or {}) do
    local entry = ownership(state, vehicleId)
    if entry and entry.removed ~= true and entry.accepted ~= true and tonumber(vehicleId) ~= replacing then
      count = count + 1
    end
  end
  if count >= 1 then return false, "owned_temporary_cardinality_violation" end
  return true, "temporary_capacity_available"
end

local function addPendingCallback(context, token)
  local key = tostring(token.kind or "callback") .. ":" .. tostring(context.pendingCallbackCount + 1)
  context.pendingCallbacks[key] = util.deepCopy(token)
  context.pendingCallbackCount = context.pendingCallbackCount + 1
  return key
end

local function resolvePendingCallback(context, key, disposition)
  if context.pendingCallbacks[key] then
    context.pendingCallbacks[key] = nil
    context.pendingCallbackCount = math.max(0, context.pendingCallbackCount - 1)
  end
  context.callbackDisposition = disposition or "callback_resolved"
  return true
end

local function acceptVehicle(state, context, vehicleId, role, playerVehicleIdAfter)
  local key, numeric = vehicleKey(vehicleId)
  if not key then return false, "accepted_vehicle_id_invalid" end
  role = role or (context.domain == "race" and "race_competitor" or "player_result")
  if context.action == "scramble" and numeric ~= tonumber(context.sourceVehicleId) then
    context.identityChangeReason = "scramble_concrete_vehicle_changed"
    return false, "scramble_identity_changed"
  end
  if context.acceptedVehicleId ~= nil and context.acceptedVehicleId ~= numeric then
    return false, "accepted_vehicle_cardinality_violation"
  end
  local owned, entry = ownVehicle(state, numeric, {
    domain = context.domain, operationId = context.operationId, generation = context.generation,
    role = role, managed = context.domain == "race" or numeric ~= tonumber(context.sourceVehicleId),
    created = numeric ~= tonumber(context.sourceVehicleId), accepted = true,
  })
  if not owned then return false, entry end
  context.acceptedVehicleId = numeric
  if not util.arrayContains(context.acceptedIds, numeric) then
    context.acceptedIds[#context.acceptedIds + 1] = numeric
  end
  context.acceptedConcreteId = numeric
  context.concreteVehicleId = numeric
  context.controlledConcreteId = tonumber(playerVehicleIdAfter) or numeric
  context.playerVehicleIdAfter = tonumber(playerVehicleIdAfter) or numeric
  context.bindingState = "BOUND"
  entry.accepted = true
  for index = #context.ownedTemporaryIds, 1, -1 do
    if tonumber(context.ownedTemporaryIds[index]) == numeric then table.remove(context.ownedTemporaryIds, index) end
  end
  return true, entry
end

local function expectId(list, vehicleId)
  local _, numeric = vehicleKey(vehicleId)
  if numeric == nil then return false, "expected_vehicle_id_invalid" end
  if not util.arrayContains(list, numeric) then list[#list + 1] = numeric end
  return true, numeric
end

local function expectRemoval(context, vehicleId)
  if type(context) ~= "table" then return false, "operation_context_missing" end
  return expectId(context.expectedRemovedIds, vehicleId)
end

local function expectAddition(context, vehicleId)
  if type(context) ~= "table" then return false, "operation_context_missing" end
  return expectId(context.expectedAddedIds, vehicleId)
end

local function classifyWorldDelta(context, worldVehicleIds)
  if type(context) ~= "table" or type(worldVehicleIds) ~= "table" then
    return false, "world_vehicle_snapshot_invalid"
  end
  local before, after = {}, {}
  for _, vehicleId in ipairs(context.worldVehicleIdsBefore or {}) do before[tostring(vehicleId)] = tonumber(vehicleId) end
  for _, vehicleId in ipairs(worldVehicleIds) do after[tostring(vehicleId)] = tonumber(vehicleId) end
  local expectedRemoved, expectedAdded = {}, {}
  for _, vehicleId in ipairs(context.expectedRemovedIds or {}) do expectedRemoved[tostring(vehicleId)] = tonumber(vehicleId) end
  for _, vehicleId in ipairs(context.expectedAddedIds or {}) do expectedAdded[tostring(vehicleId)] = tonumber(vehicleId) end
  local observedRemoved, observedAdded = {}, {}
  local unexpectedRemoved, unexpectedAdded = {}, {}
  local missingRemoved, missingAdded = {}, {}
  for key, vehicleId in pairs(before) do
    if not after[key] then
      observedRemoved[#observedRemoved + 1] = vehicleId
      if not expectedRemoved[key] then unexpectedRemoved[#unexpectedRemoved + 1] = vehicleId end
    end
  end
  for key, vehicleId in pairs(after) do
    if not before[key] then
      observedAdded[#observedAdded + 1] = vehicleId
      if not expectedAdded[key] then unexpectedAdded[#unexpectedAdded + 1] = vehicleId end
    end
  end
  for key, vehicleId in pairs(expectedRemoved) do if after[key] then missingRemoved[#missingRemoved + 1] = vehicleId end end
  for key, vehicleId in pairs(expectedAdded) do if not after[key] then missingAdded[#missingAdded + 1] = vehicleId end end
  local acceptedPresent = true
  for _, vehicleId in ipairs(context.acceptedIds or {}) do
    if not after[tostring(vehicleId)] then acceptedPresent = false; break end
  end
  local sourcePresent = context.sourceVehicleId ~= nil and after[tostring(context.sourceVehicleId)] ~= nil
  local scrambleIdentityValid = context.action ~= "scramble"
    or (sourcePresent and tonumber(context.acceptedVehicleId) == tonumber(context.sourceVehicleId))
  local report = {
    expectedRemovedIds = util.deepCopy(context.expectedRemovedIds or {}),
    expectedAddedIds = util.deepCopy(context.expectedAddedIds or {}),
    ownedTemporaryIds = util.deepCopy(context.ownedTemporaryIds or {}),
    acceptedIds = util.deepCopy(context.acceptedIds or {}),
    observedRemovedIds = observedRemoved,
    observedAddedIds = observedAdded,
    unexpectedRemovedIds = unexpectedRemoved,
    unexpectedAddedIds = unexpectedAdded,
    missingExpectedRemovedIds = missingRemoved,
    missingExpectedAddedIds = missingAdded,
    acceptedPresent = acceptedPresent,
    scrambleIdentityValid = scrambleIdentityValid,
    ownedWorldDelta = #observedAdded - #observedRemoved,
    worldVehicleDelta = #worldVehicleIds - #(context.worldVehicleIdsBefore or {}),
  }
  for _, values in ipairs({report.observedRemovedIds, report.observedAddedIds,
    report.unexpectedRemovedIds, report.unexpectedAddedIds,
    report.missingExpectedRemovedIds, report.missingExpectedAddedIds}) do table.sort(values) end
  report.valid = #missingRemoved == 0 and #missingAdded == 0
    and acceptedPresent and scrambleIdentityValid
  report.hasExternalWorldChanges = #unexpectedRemoved > 0 or #unexpectedAdded > 0
  return report.valid, report
end

local function canMutate(state, context, vehicleId)
  local entry = ownership(state, vehicleId)
  if not entry then return true, "external_unregistered" end
  if entry.identity and not vehicleIdentity.canMutate(entry.identity) then
    return false, "vehicle_authority_not_mutable"
  end
  if entry.domain == context.domain and entry.operationId == context.operationId
    and entry.generation == context.generation
  then return true, "owned_by_operation" end
  if context.domain == "chaos" and entry.role == "race_competitor" then
    return false, "race_competitor_requires_explicit_transfer"
  end
  return false, "vehicle_owned_by_other_operation"
end

local function markOrphan(state, vehicleId, reason)
  local entry = ownership(state, vehicleId)
  if not entry or entry.managed ~= true or entry.accepted == true then
    return false, "orphan_cleanup_not_owned"
  end
  if entry.identity and not vehicleIdentity.canCleanup(entry.identity) then
    return false, "orphan_cleanup_authority_denied"
  end
  entry.role = "orphan"
  entry.orphanReason = reason or "operation_ended_without_acceptance"
  local key, numeric = vehicleKey(vehicleId)
  state.orphanVehicleIds[key] = numeric
  if not state.orphanQueued[key] then
    state.orphanQueue[#state.orphanQueue + 1] = numeric
    state.orphanQueued[key] = true
  end
  local context = entry.domain and active(state, entry.domain)
  if context and context.operationId == entry.operationId and context.generation == entry.generation then
    context.orphanVehicleIds = context.orphanVehicleIds or {}
    if not util.arrayContains(context.orphanVehicleIds, numeric) then context.orphanVehicleIds[#context.orphanVehicleIds + 1] = numeric end
  end
  return true, entry
end

local function recordRemoval(state, vehicleId, reason)
  local key, numeric = vehicleKey(vehicleId)
  if not key then return false end
  local entry = state.vehicleOwnership[key]
  if entry then
    local context = entry.domain and active(state, entry.domain)
    if context and context.operationId == entry.operationId and context.generation == entry.generation
      and not util.arrayContains(context.removedVehicleIds, numeric)
    then context.removedVehicleIds[#context.removedVehicleIds + 1] = numeric end
    if context then
      for index = #context.ownedTemporaryIds, 1, -1 do
        if tonumber(context.ownedTemporaryIds[index]) == numeric then table.remove(context.ownedTemporaryIds, index) end
      end
      if entry.accepted ~= true then
        for index = #context.expectedAddedIds, 1, -1 do
          if tonumber(context.expectedAddedIds[index]) == numeric then table.remove(context.expectedAddedIds, index) end
        end
      end
    end
    entry.removed = true
    entry.removalReason = reason
  end
  state.orphanVehicleIds[key] = nil
  state.orphanQueued[key] = nil
  return true
end

local function reap(state, deleteVehicle, options)
  options = type(options) == "table" and options or {}
  local result = {removed = {}, failed = {}, skipped = {}, pending = 0, processed = 0}
  local clock = type(options.clock) == "function" and options.clock or os.clock
  local started = clock()
  local budgetSeconds = math.max(0.00005, (tonumber(options.budgetMs) or 1) / 1000)
  local maxItems = math.max(1, math.floor(tonumber(options.maxItems) or 8))
  local available = math.max(0, #state.orphanQueue - state.orphanQueueHead + 1)
  local scanned = 0
  while state.orphanQueueHead <= #state.orphanQueue and result.processed < maxItems
    and scanned < available and clock() - started < budgetSeconds
  do
    local vehicleId = state.orphanQueue[state.orphanQueueHead]
    state.orphanQueueHead = state.orphanQueueHead + 1
    local key = vehicleKey(vehicleId)
    if key then state.orphanQueued[key] = nil end
    scanned = scanned + 1
    local entry = state.vehicleOwnership[key]
    local matches = entry and entry.role == "orphan" and entry.managed == true and entry.accepted ~= true
      and (not entry.identity or vehicleIdentity.canCleanup(entry.identity))
      and (options.domain == nil or entry.domain == options.domain)
      and (options.operationId == nil or entry.operationId == options.operationId)
    local retryReady = not entry or not entry.cleanupRetryAt or (tonumber(options.now) or 0) >= entry.cleanupRetryAt
    if matches and type(deleteVehicle) == "function" then
      if retryReady then
        result.processed = result.processed + 1
        local deleted, reason = deleteVehicle(vehicleId)
        if deleted or reason == "vehicle_missing" then
          result.removed[#result.removed + 1] = vehicleId
          recordRemoval(state, vehicleId, "orphan_removed")
        else
          result.failed[#result.failed + 1] = {vehicleId = vehicleId, reason = reason}
          entry.cleanupRetryAt = (tonumber(options.now) or 0) + 1
        end
      else
        result.skipped[#result.skipped + 1] = vehicleId
      end
    elseif matches then
      result.failed[#result.failed + 1] = {vehicleId = vehicleId, reason = "delete_callback_missing"}
    else
      result.skipped[#result.skipped + 1] = vehicleId
    end
    if state.orphanVehicleIds[key] and not state.orphanQueued[key] then
      state.orphanQueue[#state.orphanQueue + 1] = vehicleId
      state.orphanQueued[key] = true
    end
  end
  if state.orphanQueueHead > #state.orphanQueue then
    state.orphanQueue, state.orphanQueueHead = {}, 1
  elseif state.orphanQueueHead > 64 then
    local compact = {}
    for index = state.orphanQueueHead, #state.orphanQueue do compact[#compact + 1] = state.orphanQueue[index] end
    state.orphanQueue, state.orphanQueueHead = compact, 1
  end
  for _ in pairs(state.orphanVehicleIds) do result.pending = result.pending + 1 end
  state.cleanupLog[#state.cleanupLog + 1] = util.deepCopy(result)
  while #state.cleanupLog > state.historyLimit do table.remove(state.cleanupLog, 1) end
  return result
end

local function terminal(state, context, terminalState, options)
  if not TERMINAL[terminalState] then return false, "terminal_state_invalid" end
  options = type(options) == "table" and options or {}
  if TERMINAL[context.terminalState] then
    if context.terminalState == terminalState then return true, context end
    return false, "operation_already_terminal"
  end
  context.terminalState = terminalState
  context.bindingState = "TERMINAL"
  context.status = terminalState
  context.phase = "terminal"
  context.endedAt = tonumber(options.endedAt) or context.createdAt
  context.rollbackReason = options.rollbackReason or context.rollbackReason
  context.restoredVehicleId = tonumber(options.restoredVehicleId) or context.restoredVehicleId
  context.sourceStillExists = options.sourceStillExists == true
  context.playerVehicleIdAfter = tonumber(options.playerVehicleIdAfter) or context.playerVehicleIdAfter
  if type(options.worldVehicleIdsAfter) == "table" then
    context.worldVehicleIdsAfter = util.deepCopy(options.worldVehicleIdsAfter)
    context.worldVehicleCountAfter = #options.worldVehicleIdsAfter
    context.worldVehicleDelta = context.worldVehicleCountAfter - context.worldVehicleCountBefore
  end
  context.pendingCallbacks = {}
  context.pendingCallbackCount = 0
  context.pendingTimers = 0
  context.callbackDisposition = "callbacks_invalidated"
  for _, vehicleId in ipairs(context.ownedVehicleIds or {}) do
    local entry = ownership(state, vehicleId)
    if entry and entry.domain == context.domain and entry.operationId == context.operationId
      and entry.generation == context.generation
    then entry.terminal = true end
  end
  for _, vehicleId in ipairs(context.candidateVehicleIds) do
    if tonumber(vehicleId) ~= tonumber(context.acceptedVehicleId) then
      markOrphan(state, vehicleId, terminalState)
    end
  end
  local domainState = state.domains[context.domain]
  if domainState and domainState.active == context then archive(state, domainState, context) end
  return true, context
end

local function rollback(context, restoredVehicleId, reason)
  if context.rollbackApplied then
    return true, "rollback_already_applied", context.restoredVehicleId
  end
  context.rollbackApplied = true
  context.recoveryState = "rolled_back"
  context.rollbackReason = reason
  context.restoredVehicleId = tonumber(restoredVehicleId)
  return true, "rollback_applied", context.restoredVehicleId
end

local function recordWorldAfter(context, worldVehicleIds)
  if type(context) ~= "table" or type(worldVehicleIds) ~= "table" then
    return false, "world_vehicle_snapshot_invalid"
  end
  context.worldVehicleIdsAfter = util.deepCopy(worldVehicleIds)
  context.worldVehicleIdsCurrent = util.deepCopy(worldVehicleIds)
  context.worldVehicleCountAfter = #worldVehicleIds
  context.worldVehicleDelta = context.worldVehicleCountAfter - (context.worldVehicleCountBefore or 0)
  context.peakWorldVehicleCount = math.max(context.peakWorldVehicleCount or 0, #worldVehicleIds)
  local valid, report = classifyWorldDelta(context, worldVehicleIds)
  if type(report) == "table" then
    context.unexpectedNewIds = util.deepCopy(report.unexpectedAddedIds)
    context.unexpectedRemovedIds = util.deepCopy(report.unexpectedRemovedIds)
    context.missingExpectedAddedIds = util.deepCopy(report.missingExpectedAddedIds)
    context.missingExpectedRemovedIds = util.deepCopy(report.missingExpectedRemovedIds)
    context.transactionCardinalityValid = valid
    context.cardinalityReport = util.deepCopy(report)
  end
  return true, context.worldVehicleDelta
end

local function quarantine(state, context, modelKey, configKey, reason, now)
  if type(modelKey) ~= "string" or modelKey == "" or type(configKey) ~= "string" or configKey == "" then
    return false, "quarantine_identity_invalid"
  end
  if reason == "DENIED_LOW_MEMORY" or reason == "DENIED_NO_SPACE"
    or reason == "TEMPORARY_REGISTRY" or reason == "UNKNOWN_FAILURE"
  then return false, "condition_not_catalog_quarantinable" end
  local key = modelKey .. "\31" .. configKey
  if context.catalogQuarantine[key] then return false, "config_already_quarantined" end
  local record = {
    modelKey = modelKey, configKey = configKey, reason = reason,
    domain = context.domain, operationId = context.operationId, generation = context.generation,
    timestamp = tonumber(now) or 0, retryPolicy = "next_configuration_same_generation",
  }
  context.catalogQuarantine[key] = record
  state.domains[context.domain].sessionQuarantine[key] = util.deepCopy(record)
  return true, record
end

local function isQuarantined(state, domain, modelKey, configKey)
  local domainState = state.domains[domain]
  if not domainState then return false end
  return domainState.sessionQuarantine[tostring(modelKey) .. "\31" .. tostring(configKey)] ~= nil
end

local function clearQuarantine(state, domain)
  if not state.domains[domain] then return false end
  state.domains[domain].sessionQuarantine = {}
  local context = state.domains[domain].active
  if context then context.catalogQuarantine = {} end
  return true
end

local function summary(state)
  local function countEntries(values)
    local count = 0
    for _ in pairs(values or {}) do count = count + 1 end
    return count
  end
  local domains = {}
  for _, domain in ipairs({"chaos", "race", "garage"}) do
    local domainState = state.domains[domain]
    local context = domainState.active
    domains[domain] = {
      generation = domainState.generation,
      active = context and not TERMINAL[context.terminalState] or false,
      operationId = context and context.operationId or nil,
      action = context and context.action or nil,
      phase = context and context.phase or "idle",
      terminalState = context and context.terminalState or nil,
      bindingState = context and context.bindingState or "UNBOUND",
      sourceVehicleId = context and context.sourceVehicleId or nil,
      acceptedVehicleId = context and context.acceptedVehicleId or nil,
      candidateVehicleIds = context and util.deepCopy(context.candidateVehicleIds) or {},
      ownedVehicleIds = context and util.deepCopy(context.ownedVehicleIds) or {},
      orphanVehicleIds = context and util.deepCopy(context.orphanVehicleIds or {}) or {},
      pendingCallbacks = context and context.pendingCallbackCount or 0,
      pendingTimers = context and context.pendingTimers or 0,
      worldVehicleCountBefore = context and context.worldVehicleCountBefore or 0,
      worldVehicleCountAfter = context and context.worldVehicleCountAfter or nil,
      worldVehicleDelta = context and context.worldVehicleDelta or nil,
      staleCallbackCount = context and context.staleCallbackCount or 0,
      staleCallbackSideEffects = context and context.staleCallbackSideEffects or 0,
      staleCallbackEffectsPrevented = context and context.staleCallbackEffectsPrevented or 0,
      phaseSequence = context and context.phaseSequence or 0,
      semanticProgressSequence = context and context.semanticProgressSequence or 0,
      ownedTemporaryIds = context and util.deepCopy(context.ownedTemporaryIds) or {},
      peakOwnedTemporaryCount = context and context.peakOwnedTemporaryCount or 0,
      peakWorldVehicleCount = context and context.peakWorldVehicleCount or 0,
      unexpectedNewIds = context and util.deepCopy(context.unexpectedNewIds) or {},
      unexpectedRemovedIds = context and util.deepCopy(context.unexpectedRemovedIds) or {},
      expectedRemovedIds = context and util.deepCopy(context.expectedRemovedIds) or {},
      expectedAddedIds = context and util.deepCopy(context.expectedAddedIds) or {},
      acceptedIds = context and util.deepCopy(context.acceptedIds) or {},
      transactionCardinalityValid = context and context.transactionCardinalityValid or nil,
      cardinalityReport = context and util.deepCopy(context.cardinalityReport) or nil,
      lastCallbackToken = context and context.lastCallbackToken or nil,
      quarantineCount = countEntries(domainState.sessionQuarantine),
    }
  end
  local owned, orphan = 0, 0
  for _, entry in pairs(state.vehicleOwnership) do
    if not entry.removed then owned = owned + 1 end
    if entry.role == "orphan" and not entry.removed then orphan = orphan + 1 end
  end
  return {domains = domains, ownedVehicles = owned, orphanVehicles = orphan,
    callbackDiagnostics = util.deepCopy(state.callbackDiagnostics)}
end

M.DOMAINS = DOMAINS
M.TERMINAL = TERMINAL
M.ROLES = ROLES
M.create = create
M.begin = begin
M.active = active
M.callbackToken = callbackToken
M.validateCallback = validateCallback
M.setPhase = setPhase
M.ownVehicle = ownVehicle
M.ownership = ownership
M.transferVehicle = transferVehicle
M.registerCandidate = registerCandidate
M.canCreateTemporary = canCreateTemporary
M.addPendingCallback = addPendingCallback
M.resolvePendingCallback = resolvePendingCallback
M.acceptVehicle = acceptVehicle
M.expectRemoval = expectRemoval
M.expectAddition = expectAddition
M.classifyWorldDelta = classifyWorldDelta
M.canMutate = canMutate
M.markOrphan = markOrphan
M.recordRemoval = recordRemoval
M.reap = reap
M.terminal = terminal
M.rollback = rollback
M.recordWorldAfter = recordWorldAfter
M.quarantine = quarantine
M.isQuarantined = isQuarantined
M.clearQuarantine = clearQuarantine
M.summary = summary

return M
