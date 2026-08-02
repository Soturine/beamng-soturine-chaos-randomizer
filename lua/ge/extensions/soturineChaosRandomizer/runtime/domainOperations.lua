local util = require("ge/extensions/soturineChaosRandomizer/util")

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
  }
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
    phase = "created",
    status = "active",
    expectedSlot = options.expectedSlot,
    expectedLogicalTarget = util.deepCopy(options.expectedLogicalTarget),
    logicalTarget = util.deepCopy(options.expectedLogicalTarget),
    concreteVehicleId = nil,
    sourceVehicleId = tonumber(options.sourceVehicleId),
    sourceStillExists = options.sourceVehicleId ~= nil,
    candidateVehicleIds = {},
    candidateById = {},
    createdVehicleIds = {},
    removedVehicleIds = {},
    ownedVehicleIds = {},
    acceptedVehicleId = nil,
    restoredVehicleId = nil,
    playerVehicleIdAfter = nil,
    pendingCallbacks = {},
    pendingCallbackCount = 0,
    pendingTimers = 0,
    timeoutState = "idle",
    recoveryState = "idle",
    rollbackReason = nil,
    rollbackApplied = false,
    terminalState = nil,
    expectedModel = options.expectedModel,
    expectedConfig = options.expectedConfig,
    seed = options.seed,
    rng = options.rng,
    catalogQuarantine = {},
    callbackDisposition = "pending",
    cleanupResult = {removed = {}, failed = {}, skipped = {}},
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
  return {
    domain = context.domain,
    operationId = context.operationId,
    generation = context.generation,
    kind = kind or "callback",
    expectedSlot = values.expectedSlot or context.expectedSlot,
    expectedLogicalTarget = util.deepCopy(values.expectedLogicalTarget or context.expectedLogicalTarget),
    vehicleId = tonumber(values.vehicleId),
  }
end

local function validateCallback(state, token)
  if type(token) ~= "table" or not DOMAINS[token.domain] then
    return false, "callback_token_invalid"
  end
  local context = active(state, token.domain)
  if not context or context.operationId ~= token.operationId
    or context.generation ~= token.generation
  then return false, "ignored_stale_callback" end
  if TERMINAL[context.terminalState] then return false, "ignored_stale_callback" end
  if token.expectedSlot ~= nil and context.expectedSlot ~= nil
    and tostring(token.expectedSlot) ~= tostring(context.expectedSlot)
  then return false, "callback_slot_mismatch" end
  return true, context
end

local function setPhase(context, phase, status)
  if TERMINAL[context.terminalState] then return false, "operation_terminal" end
  context.phase = tostring(phase or context.phase)
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
  local replacing = current and (current.domain ~= metadata.domain
    or current.operationId ~= metadata.operationId
    or current.generation ~= metadata.generation)
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
  local valid, contextOrReason = validateCallback(state, token)
  if not valid then return false, contextOrReason end
  local context = contextOrReason
  local key, numeric = vehicleKey(vehicleId)
  if not key then return false, "candidate_id_invalid" end
  metadata = type(metadata) == "table" and metadata or {}
  if not context.candidateById[key] then
    context.candidateById[key] = {
      vehicleId = numeric, source = metadata.source or token.kind,
      observedAt = tonumber(metadata.observedAt) or 0,
    }
    context.candidateVehicleIds[#context.candidateVehicleIds + 1] = numeric
  end
  local sourceId = tonumber(context.sourceVehicleId)
  local created = metadata.created ~= false and numeric ~= sourceId
  local role = context.domain == "race" and "race_candidate" or "player_candidate"
  local owned, result = ownVehicle(state, numeric, {
    domain = context.domain, operationId = context.operationId, generation = context.generation,
    role = metadata.role or role, slot = token.expectedSlot, managed = created,
    created = created, accepted = false, updatedAt = metadata.observedAt,
  })
  if not owned then return false, result end
  context.callbackDisposition = "candidate_recorded"
  return true, context.candidateById[key]
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
  local owned, entry = ownVehicle(state, numeric, {
    domain = context.domain, operationId = context.operationId, generation = context.generation,
    role = role, managed = context.domain == "race" or numeric ~= tonumber(context.sourceVehicleId),
    created = numeric ~= tonumber(context.sourceVehicleId), accepted = true,
  })
  if not owned then return false, entry end
  context.acceptedVehicleId = numeric
  context.concreteVehicleId = numeric
  context.playerVehicleIdAfter = tonumber(playerVehicleIdAfter) or numeric
  entry.accepted = true
  return true, entry
end

local function canMutate(state, context, vehicleId)
  local entry = ownership(state, vehicleId)
  if not entry then return true, "external_unregistered" end
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
  context.status = terminalState
  context.phase = "terminal"
  context.endedAt = tonumber(options.endedAt) or context.createdAt
  context.rollbackReason = options.rollbackReason or context.rollbackReason
  context.restoredVehicleId = tonumber(options.restoredVehicleId) or context.restoredVehicleId
  context.sourceStillExists = options.sourceStillExists == true
  context.playerVehicleIdAfter = tonumber(options.playerVehicleIdAfter) or context.playerVehicleIdAfter
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
      sourceVehicleId = context and context.sourceVehicleId or nil,
      acceptedVehicleId = context and context.acceptedVehicleId or nil,
      candidateVehicleIds = context and util.deepCopy(context.candidateVehicleIds) or {},
      ownedVehicleIds = context and util.deepCopy(context.ownedVehicleIds) or {},
      orphanVehicleIds = context and util.deepCopy(context.orphanVehicleIds or {}) or {},
      pendingCallbacks = context and context.pendingCallbackCount or 0,
      pendingTimers = context and context.pendingTimers or 0,
      quarantineCount = countEntries(domainState.sessionQuarantine),
    }
  end
  local owned, orphan = 0, 0
  for _, entry in pairs(state.vehicleOwnership) do
    if not entry.removed then owned = owned + 1 end
    if entry.role == "orphan" and not entry.removed then orphan = orphan + 1 end
  end
  return {domains = domains, ownedVehicles = owned, orphanVehicles = orphan}
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
M.addPendingCallback = addPendingCallback
M.resolvePendingCallback = resolvePendingCallback
M.acceptVehicle = acceptVehicle
M.canMutate = canMutate
M.markOrphan = markOrphan
M.recordRemoval = recordRemoval
M.reap = reap
M.terminal = terminal
M.rollback = rollback
M.quarantine = quarantine
M.isQuarantined = isQuarantined
M.clearQuarantine = clearQuarantine
M.summary = summary

return M
