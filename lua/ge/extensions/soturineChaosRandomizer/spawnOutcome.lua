local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local REASONS = {
  DENIED_LOW_MEMORY = true,
  DENIED_NO_SPACE = true,
  TEMPORARY_REGISTRY = true,
  INVALID_CONTENT = true,
  INSTABILITY_CONFIRMED = true,
  UNKNOWN_FAILURE = true,
}

local function normalizedIds(values)
  local result, seen = {}, {}
  for _, value in ipairs(type(values) == "table" and values or {}) do
    local id = tonumber(value)
    if id and id >= 0 and not seen[tostring(id)] then
      seen[tostring(id)] = true
      result[#result + 1] = id
    end
  end
  table.sort(result)
  return result
end

local function difference(before, after)
  local seen, result = {}, {}
  for _, id in ipairs(normalizedIds(before)) do seen[tostring(id)] = true end
  for _, id in ipairs(normalizedIds(after)) do
    if not seen[tostring(id)] then result[#result + 1] = id end
  end
  return result
end

local function begin(options)
  options = type(options) == "table" and options or {}
  return {
    requestedModel = options.requestedModel,
    requestedConfig = util.deepCopy(options.requestedConfig),
    requestedPlacement = util.deepCopy(options.requestedPlacement),
    sourceVehicleId = tonumber(options.sourceVehicleId),
    worldVehicleIdsBefore = normalizedIds(options.worldVehicleIdsBefore),
    worldVehicleIdsAfter = {},
    worldVehicleIdsCreated = {},
    returnedVehicleId = nil,
    returnedObjectEvidence = false,
    candidateVehicleIds = {},
    acceptedVehicleId = nil,
    rejectedVehicleIds = {},
    outcome = "pending",
    reason = nil,
  }
end

local function finish(transaction, evidence)
  evidence = type(evidence) == "table" and evidence or {}
  transaction.worldVehicleIdsAfter = normalizedIds(evidence.worldVehicleIdsAfter)
  transaction.worldVehicleIdsCreated = difference(
    transaction.worldVehicleIdsBefore, transaction.worldVehicleIdsAfter
  )
  transaction.returnedVehicleId = tonumber(evidence.returnedVehicleId)
  transaction.returnedObjectEvidence = evidence.returnedObjectEvidence == true
  local candidates, seen = {}, {}
  local function add(value)
    local id = tonumber(value)
    if id and id >= 0 and not seen[tostring(id)] then
      seen[tostring(id)] = true
      candidates[#candidates + 1] = id
    end
  end
  add(transaction.returnedVehicleId)
  for _, id in ipairs(transaction.worldVehicleIdsCreated) do add(id) end
  transaction.candidateVehicleIds = candidates

  if evidence.thrown == true then
    transaction.outcome, transaction.reason = "rejected", "UNKNOWN_FAILURE"
  elseif evidence.apiResult == false then
    -- BeamNG 0.39 core_vehicles.spawnNewVehicle returns false specifically
    -- when canSpawnAnotherVehicle() denies the request for low memory.
    transaction.outcome, transaction.reason = "denied", "DENIED_LOW_MEMORY"
  elseif #candidates == 1 then
    transaction.outcome = "observed_candidate"
  elseif #candidates > 1 then
    transaction.outcome, transaction.reason = "rejected", "UNKNOWN_FAILURE"
    transaction.rejectedVehicleIds = util.deepCopy(candidates)
  elseif evidence.apiResult == nil then
    transaction.outcome, transaction.reason = "rejected", "UNKNOWN_FAILURE"
  elseif transaction.returnedObjectEvidence then
    transaction.outcome = "awaiting_identity"
  else
    transaction.outcome, transaction.reason = "rejected", "UNKNOWN_FAILURE"
  end
  return transaction
end

local function accept(transaction, vehicleId)
  vehicleId = tonumber(vehicleId)
  if not vehicleId or vehicleId < 0 then return false, "accepted_vehicle_id_invalid" end
  transaction.acceptedVehicleId = vehicleId
  transaction.outcome = "accepted"
  transaction.reason = nil
  transaction.rejectedVehicleIds = {}
  for _, id in ipairs(transaction.worldVehicleIdsCreated or {}) do
    if id ~= vehicleId then transaction.rejectedVehicleIds[#transaction.rejectedVehicleIds + 1] = id end
  end
  return true, transaction
end

local function cleanupIds(transaction)
  local result, seen = {}, {}
  for _, id in ipairs(transaction and transaction.rejectedVehicleIds or {}) do
    if id ~= transaction.acceptedVehicleId and not seen[tostring(id)] then
      seen[tostring(id)] = true
      result[#result + 1] = id
    end
  end
  if transaction and transaction.acceptedVehicleId == nil then
    for _, id in ipairs(transaction.worldVehicleIdsCreated or {}) do
      if not seen[tostring(id)] then seen[tostring(id)] = true; result[#result + 1] = id end
    end
  end
  table.sort(result)
  return result
end

local function blacklistEligible(reason)
  return reason == "INVALID_CONTENT" or reason == "INSTABILITY_CONFIRMED"
end

M.REASONS = REASONS
M.normalizedIds = normalizedIds
M.difference = difference
M.begin = begin
M.finish = finish
M.accept = accept
M.cleanupIds = cleanupIds
M.blacklistEligible = blacklistEligible

return M
