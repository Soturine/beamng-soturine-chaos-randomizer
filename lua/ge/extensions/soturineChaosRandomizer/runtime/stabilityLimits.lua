local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local DEFAULTS = {
  maxConcurrentVehicleBuilds = 1,
  maxOwnedTemporaryVehicles = 1,
  maxRetriesPerTarget = 3,
  maxRetriesPerRaceSlot = 3,
  maxStaleCallbacksPerOperation = 64,
  maxOperationWallClockMs = 240000,
  maxRaceGenerationWallClockMs = 2880000,
  maxSpawnAttemptsPerFrame = 1,
  maxHeavyReloadsPerFrame = 1,
}

local function boundedInteger(value, fallback, minimum, maximum)
  return math.floor(util.clamp(tonumber(value) or fallback, minimum, maximum))
end

local function normalize(values)
  values = type(values) == "table" and values or {}
  return {
    maxConcurrentVehicleBuilds = boundedInteger(values.maxConcurrentVehicleBuilds,
      DEFAULTS.maxConcurrentVehicleBuilds, 1, 2),
    maxOwnedTemporaryVehicles = boundedInteger(values.maxOwnedTemporaryVehicles,
      DEFAULTS.maxOwnedTemporaryVehicles, 1, 4),
    maxRetriesPerTarget = boundedInteger(values.maxRetriesPerTarget,
      DEFAULTS.maxRetriesPerTarget, 0, 10),
    maxRetriesPerRaceSlot = boundedInteger(values.maxRetriesPerRaceSlot,
      DEFAULTS.maxRetriesPerRaceSlot, 0, 10),
    maxStaleCallbacksPerOperation = boundedInteger(values.maxStaleCallbacksPerOperation,
      DEFAULTS.maxStaleCallbacksPerOperation, 1, 256),
    maxOperationWallClockMs = boundedInteger(values.maxOperationWallClockMs,
      DEFAULTS.maxOperationWallClockMs, 10000, 600000),
    maxRaceGenerationWallClockMs = boundedInteger(values.maxRaceGenerationWallClockMs,
      DEFAULTS.maxRaceGenerationWallClockMs, 30000, 7200000),
    maxSpawnAttemptsPerFrame = boundedInteger(values.maxSpawnAttemptsPerFrame,
      DEFAULTS.maxSpawnAttemptsPerFrame, 1, 2),
    maxHeavyReloadsPerFrame = boundedInteger(values.maxHeavyReloadsPerFrame,
      DEFAULTS.maxHeavyReloadsPerFrame, 1, 2),
  }
end

local function allows(state, metric, current)
  local limit = state and state[metric]
  if type(limit) ~= "number" then return false, "stability_limit_unknown" end
  if (tonumber(current) or 0) >= limit then return false, metric .. "_reached" end
  return true
end

M.DEFAULTS = DEFAULTS
M.normalize = normalize
M.allows = allows

return M
