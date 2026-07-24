local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}
local validateGeneration

local function create(limit)
  return {
    limit = math.max(1, math.min(64, tonumber(limit) or 32)),
    entries = {}, order = {}, sequence = 0, generationSequence = 0,
  }
end

local function register(state, vehicleId, metadata)
  if type(vehicleId) ~= "number" or vehicleId < 0 then return nil, "managed_vehicle_id_invalid" end
  if #state.order >= state.limit then return nil, "managed_vehicle_limit" end
  state.sequence = state.sequence + 1
  state.generationSequence = state.generationSequence + 1
  local handle = "managed-" .. string.format("%06d", state.sequence)
  local entry = {
    handle = handle, vehicleId = vehicleId,
    status = metadata and metadata.targetConfirmed == false and "loading" or "active",
    createdAt = os.time(),
    metadata = util.deepCopy(metadata or {}), idHistory = {vehicleId},
    targetGeneration = state.generationSequence,
    targetConfirmed = not metadata or metadata.targetConfirmed ~= false,
    pendingWrites = 0, pendingTimers = 0, pendingCallbacks = 0,
    validated = not metadata or metadata.validated ~= false,
    lineupCompetitorId = metadata and (metadata.lineupCompetitorId or metadata.competitorId),
    dnaId = metadata and metadata.dnaId,
    modelKey = metadata and metadata.modelKey,
    configIdentity = metadata and util.deepCopy(metadata.configIdentity),
    spawnTransform = metadata and util.deepCopy(metadata.spawnTransform),
    aiState = {status = "idle"},
    lastKnownState = metadata and util.deepCopy(metadata.lastKnownState),
    auxiliaryIds = {},
  }
  state.entries[handle] = entry
  state.order[#state.order + 1] = handle
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
  state.generationSequence = state.generationSequence + 1
  entry.targetGeneration = state.generationSequence
  entry.idHistory[#entry.idHistory + 1] = newId
  entry.status = "loading"
  entry.targetConfirmed = false
  entry.validated = false
  return true
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
  if not state.entries[handle] then return false end
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
