local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local AUTHORITIES = {
  LOCAL = true, SERVER_GRANTED = true, REMOTE = true, UNKNOWN = true,
}

local function normalize(value, fallbackLocalId)
  value = type(value) == "table" and value or {}
  local localId = tonumber(value.localVehicleId or fallbackLocalId)
  return {
    environment = tostring(value.environment or "single_player"),
    localVehicleId = localId,
    ownerPlayerId = value.ownerPlayerId ~= nil and tostring(value.ownerPlayerId) or nil,
    networkVehicleId = value.networkVehicleId ~= nil and tostring(value.networkVehicleId) or nil,
    authority = AUTHORITIES[value.authority] and value.authority or "LOCAL",
    origin = tostring(value.origin or "local_runtime"),
  }
end

local function key(value)
  value = normalize(value)
  return table.concat({value.environment, value.ownerPlayerId or "-",
    value.networkVehicleId or "-", tostring(value.localVehicleId or "-")}, "\31")
end

local function same(left, right)
  return key(left) == key(right)
end

local function canMutate(value)
  value = normalize(value)
  return value.authority == "LOCAL" or value.authority == "SERVER_GRANTED"
end

local function canCleanup(value)
  return canMutate(value)
end

M.AUTHORITIES = AUTHORITIES
M.normalize = normalize
M.key = key
M.same = same
M.canMutate = canMutate
M.canCleanup = canCleanup
M.copy = function(value) return util.deepCopy(normalize(value)) end

return M
