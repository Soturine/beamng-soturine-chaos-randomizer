local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}
local validateGeneration

local function slotKey(lineupId, competitorId)
  if lineupId == nil or competitorId == nil then return nil end
  return tostring(lineupId) .. "\31" .. tostring(competitorId)
end

local function create(limit)
  return {
    limit = math.max(1, math.min(64, tonumber(limit) or 32)),
    entries = {}, order = {}, slotOwners = {}, sequence = 0, generationSequence = 0,
  }
end

local function register(state, vehicleId, metadata)
  if type(vehicleId) ~= "number" or vehicleId < 0 then return nil, "managed_vehicle_id_invalid" end
  if #state.order >= state.limit then return nil, "managed_vehicle_limit" end
  metadata = type(metadata) == "table" and metadata or {}
  local bindingKey = slotKey(metadata.lineupId, metadata.lineupCompetitorId or metadata.competitorId)
  if bindingKey and state.slotOwners[bindingKey] then return nil, "managed_slot_already_bound" end
  for _, existingHandle in ipairs(state.order) do
    local existing = state.entries[existingHandle]
    if existing and existing.vehicleId == vehicleId then return nil, "managed_vehicle_already_bound" end
  end
  state.sequence = state.sequence + 1
  state.generationSequence = state.generationSequence + 1
  local handle = "managed-" .. string.format("%06d", state.sequence)
  local entry = {
    handle = handle, vehicleId = vehicleId,
    status = metadata.targetConfirmed == false and "loading" or "active",
    createdAt = os.time(),
    metadata = util.deepCopy(metadata), idHistory = {vehicleId},
    targetGeneration = state.generationSequence,
    targetConfirmed = metadata.targetConfirmed ~= false,
    pendingWrites = 0, pendingTimers = 0, pendingCallbacks = 0,
    validated = metadata.validated ~= false,
    lineupId = metadata.lineupId,
    lineupCompetitorId = metadata.lineupCompetitorId or metadata.competitorId,
    slotId = metadata.slotId,
    generationId = metadata.generationId or metadata.lineupId,
    episodeSeed = metadata.episodeSeed,
    slotSeed = metadata.slotSeed,
    concreteVehicleId = vehicleId,
    dnaId = metadata.dnaId,
    modelKey = metadata.modelKey,
    configIdentity = util.deepCopy(metadata.configIdentity),
    spawnTransform = util.deepCopy(metadata.spawnTransform),
    aiState = {status = "idle"},
    lastKnownState = util.deepCopy(metadata.lastKnownState),
    auxiliaryIds = {},
  }
  state.entries[handle] = entry
  state.order[#state.order + 1] = handle
  if bindingKey then state.slotOwners[bindingKey] = handle end
  return entry
end

local function rebind(state, handle, oldId, newId, expectedGeneration)
  local entry = state.entries[handle]
  if not entry or entry.vehicleId ~= oldId or type(newId) ~= "number" then return false, "managed_rebind_mismatch" end
  if expectedGeneration ~= nil and entry.targetGeneration ~= expectedGeneration then
    return false, "stale_callback_ignored"
  end
  for _, otherHandle in ipairs(state.order) do
    local other = state.entries[otherHandle]
    if otherHandle ~= handle and other and other.vehicleId == newId then return false, "managed_cross_rebind_blocked" end
  end
  entry.vehicleId = newId
  entry.concreteVehicleId = newId
  state.generationSequence = state.generationSequence + 1
  entry.targetGeneration = state.generationSequence
  entry.idHistory[#entry.idHistory + 1] = newId
  entry.status = "loading"
  entry.targetConfirmed = false
  entry.validated = false
  return true
end

local function beginReplacement(state, handle, sourceVehicleId, candidateVehicleId, generation)
  local ok, entry = validateGeneration(state, handle, generation)
  if not ok then return false, entry end
  if entry.vehicleId ~= sourceVehicleId then return false, "managed_replacement_source_mismatch" end
  if type(candidateVehicleId) ~= "number" or candidateVehicleId < 0
    or candidateVehicleId == sourceVehicleId
  then return false, "managed_replacement_candidate_invalid" end
  for _, otherHandle in ipairs(state.order) do
    local other = state.entries[otherHandle]
    if otherHandle ~= handle and other and other.vehicleId == candidateVehicleId then
      return false, "managed_replacement_candidate_owned"
    end
  end
  entry.pendingReplacement = {
    sourceVehicleId = sourceVehicleId,
    candidateVehicleId = candidateVehicleId,
    targetGeneration = generation,
  }
  return true, entry.pendingReplacement
end

local function rebindReplacementCandidate(state, handle, oldCandidateId, newCandidateId, generation)
  local ok, entry = validateGeneration(state, handle, generation)
  if not ok then return false, entry end
  local pending = entry.pendingReplacement
  if not pending or pending.candidateVehicleId ~= oldCandidateId or type(newCandidateId) ~= "number" then
    return false, "managed_replacement_candidate_mismatch"
  end
  for _, otherHandle in ipairs(state.order) do
    local other = state.entries[otherHandle]
    if otherHandle ~= handle and other and other.vehicleId == newCandidateId then
      return false, "managed_replacement_candidate_owned"
    end
  end
  pending.candidateVehicleId = newCandidateId
  return true, pending
end

local function commitReplacement(state, handle, generation)
  local ok, entry = validateGeneration(state, handle, generation)
  if not ok then return false, entry end
  local pending = entry.pendingReplacement
  if not pending or pending.targetGeneration ~= generation
    or entry.vehicleId ~= pending.sourceVehicleId
  then return false, "managed_replacement_transaction_mismatch" end
  entry.vehicleId = pending.candidateVehicleId
  entry.concreteVehicleId = pending.candidateVehicleId
  entry.idHistory[#entry.idHistory + 1] = pending.candidateVehicleId
  entry.pendingReplacement = nil
  entry.status = "loading"
  entry.targetConfirmed = false
  entry.validated = false
  return true, entry
end

local function abortReplacement(state, handle, generation, reason)
  local ok, entry = validateGeneration(state, handle, generation)
  if not ok then return false, entry end
  local pending = entry.pendingReplacement
  entry.pendingReplacement = nil
  entry.status = "ready"
  entry.targetConfirmed = true
  entry.validated = true
  entry.pendingWrites, entry.pendingTimers, entry.pendingCallbacks = 0, 0, 0
  entry.failureReason = reason
  return true, pending
end

local function binding(state, handle)
  local entry = state.entries[handle]
  if not entry then return nil, "managed_vehicle_unknown" end
  local key = slotKey(entry.lineupId, entry.lineupCompetitorId)
  if not key or state.slotOwners[key] ~= handle then return nil, "managed_slot_binding_unproven" end
  if entry.concreteVehicleId ~= entry.vehicleId then return nil, "managed_concrete_identity_mismatch" end
  return entry
end

local function matchesSlot(state, handle, expected)
  local entry, reason = binding(state, handle)
  if not entry then return false, reason end
  expected = type(expected) == "table" and expected or {}
  if expected.lineupId ~= nil and tostring(entry.lineupId) ~= tostring(expected.lineupId)
    or expected.competitorId ~= nil and tostring(entry.lineupCompetitorId) ~= tostring(expected.competitorId)
    or expected.slotId ~= nil and tostring(entry.slotId) ~= tostring(expected.slotId)
    or expected.vehicleId ~= nil and tonumber(entry.vehicleId) ~= tonumber(expected.vehicleId)
  then return false, "managed_slot_binding_mismatch" end
  return true, entry
end

local function findByVehicle(state, vehicleId)
  for _, handle in ipairs(state.order) do
    local entry = state.entries[handle]
    if entry and entry.vehicleId == vehicleId then return entry end
    for _, auxiliaryId in ipairs(entry and entry.auxiliaryIds or {}) do
      if auxiliaryId == vehicleId then return entry, "auxiliary" end
    end
  end
  return nil, "managed_vehicle_unknown"
end

local function attachAuxiliary(state, handle, auxiliaryId, ownership)
  local entry = state.entries[handle]
  if not entry then return false, "managed_vehicle_unknown" end
  if type(auxiliaryId) ~= "number" or auxiliaryId < 0 then return false, "managed_auxiliary_id_invalid" end
  if type(ownership) ~= "table" or ownership.proven ~= true
    or ownership.ownerVehicleId ~= entry.vehicleId
  then
    return false, "managed_auxiliary_ownership_unproven"
  end
  local existing = findByVehicle(state, auxiliaryId)
  if existing then return false, "managed_auxiliary_already_owned" end
  entry.auxiliaryIds[#entry.auxiliaryIds + 1] = auxiliaryId
  return true
end

local function updateState(state, handle, generation, value)
  local ok, entry = validateGeneration(state, handle, generation)
  if not ok then return false, entry end
  entry.lastKnownState = util.deepCopy(value)
  entry.lastStateAt = os.time()
  return true
end

local function setAIState(state, handle, generation, value)
  local ok, entry = validateGeneration(state, handle, generation)
  if not ok then return false, entry end
  entry.aiState = util.deepCopy(type(value) == "table" and value or {status = tostring(value)})
  return true
end

local function readyEntry(state, handle, expectedGeneration)
  local entry = state.entries[handle]
  if not entry then return nil, "managed_vehicle_unknown" end
  if expectedGeneration ~= nil and entry.targetGeneration ~= expectedGeneration then return nil, "stale_callback_ignored" end
  if entry.status ~= "ready" or not entry.targetConfirmed or not entry.validated
    or entry.pendingWrites > 0 or entry.pendingTimers > 0 or entry.pendingCallbacks > 0
  then
    return nil, "managed_vehicle_not_ready"
  end
  return entry
end

local function beginGeneration(state, handle, reason)
  local entry = state.entries[handle]
  if not entry then return nil, "managed_vehicle_unknown" end
  state.generationSequence = state.generationSequence + 1
  entry.targetGeneration = state.generationSequence
  entry.generationReason = reason
  entry.targetConfirmed = false
  entry.validated = false
  entry.status = "loading"
  return entry.targetGeneration
end

validateGeneration = function(state, handle, generation)
  local entry = state.entries[handle]
  if not entry then return false, "managed_vehicle_unknown" end
  if entry.targetGeneration ~= generation then return false, "stale_callback_ignored" end
  return true, entry
end

local function setPending(state, handle, counts)
  local entry = state.entries[handle]
  if not entry then return false, "managed_vehicle_unknown" end
  counts = type(counts) == "table" and counts or {}
  entry.pendingWrites = math.max(0, math.floor(tonumber(counts.writes) or entry.pendingWrites or 0))
  entry.pendingTimers = math.max(0, math.floor(tonumber(counts.timers) or entry.pendingTimers or 0))
  entry.pendingCallbacks = math.max(0, math.floor(tonumber(counts.callbacks) or entry.pendingCallbacks or 0))
  return true
end

local function markReady(state, handle, generation, options)
  local ok, entry = validateGeneration(state, handle, generation)
  if not ok then return false, entry end
  options = type(options) == "table" and options or {}
  if options.busy == true or entry.pendingWrites > 0 or entry.pendingTimers > 0 or entry.pendingCallbacks > 0
    or options.targetConfirmed ~= true or options.validated ~= true
  then
    return false, "managed_vehicle_not_ready"
  end
  entry.targetConfirmed = true
  entry.validated = true
  entry.status = "ready"
  return true
end

local function destroyed(state, vehicleId)
  for _, handle in ipairs(state.order) do
    local entry = state.entries[handle]
    if entry and entry.vehicleId == vehicleId then
      entry.status = "destroyed"
      entry.destroyedAt = os.time()
      return true, entry
    end
  end
  return false, "managed_vehicle_unknown"
end

local function remove(state, handle)
  local entry = state.entries[handle]
  if not entry then return false end
  local bindingKey = slotKey(entry.lineupId, entry.lineupCompetitorId)
  if bindingKey and state.slotOwners[bindingKey] == handle then state.slotOwners[bindingKey] = nil end
  state.entries[handle] = nil
  for index, value in ipairs(state.order) do if value == handle then table.remove(state.order, index); break end end
  return true
end

local function list(state)
  local result = {}
  for _, handle in ipairs(state.order) do if state.entries[handle] then result[#result + 1] = util.deepCopy(state.entries[handle]) end end
  return result
end

M.create = create
M.register = register
M.rebind = rebind
M.respawn = rebind
M.beginReplacement = beginReplacement
M.rebindReplacementCandidate = rebindReplacementCandidate
M.commitReplacement = commitReplacement
M.abortReplacement = abortReplacement
M.binding = binding
M.matchesSlot = matchesSlot
M.beginGeneration = beginGeneration
M.validateGeneration = validateGeneration
M.setPending = setPending
M.markReady = markReady
M.findByVehicle = findByVehicle
M.attachAuxiliary = attachAuxiliary
M.updateState = updateState
M.setAIState = setAIState
M.readyEntry = readyEntry
M.destroyed = destroyed
M.remove = remove
M.list = list

return M
