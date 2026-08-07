local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local DEFAULTS = {
  maxConcurrentVehicleBuilds = 1,
  maxOwnedTemporaryVehicles = 1,
  maxRetriesPerTarget = 2,
  maxRetriesPerRaceSlot = 2,
  maxStaleCallbacksPerOperation = 64,
  maxOperationWallClockMs = 120000,
  maxRaceGenerationWallClockMs = 360000,
  randomCarWallClockMs = 30000,
  scrambleWallClockMs = 60000,
  fullRandomWallClockMs = 120000,
  raceSlotWallClockMs = 120000,
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
      DEFAULTS.maxConcurrentVehicleBuilds, 1, 1),
    maxOwnedTemporaryVehicles = boundedInteger(values.maxOwnedTemporaryVehicles,
      DEFAULTS.maxOwnedTemporaryVehicles, 1, 1),
    maxRetriesPerTarget = boundedInteger(values.maxRetriesPerTarget,
      DEFAULTS.maxRetriesPerTarget, 0, 3),
    maxRetriesPerRaceSlot = boundedInteger(values.maxRetriesPerRaceSlot,
      DEFAULTS.maxRetriesPerRaceSlot, 0, 3),
    maxStaleCallbacksPerOperation = boundedInteger(values.maxStaleCallbacksPerOperation,
      DEFAULTS.maxStaleCallbacksPerOperation, 1, 256),
    maxOperationWallClockMs = boundedInteger(values.maxOperationWallClockMs,
      DEFAULTS.maxOperationWallClockMs, 10000, 120000),
    maxRaceGenerationWallClockMs = boundedInteger(values.maxRaceGenerationWallClockMs,
      DEFAULTS.maxRaceGenerationWallClockMs, 30000, 360000),
    randomCarWallClockMs = boundedInteger(values.randomCarWallClockMs,
      DEFAULTS.randomCarWallClockMs, 10000, 45000),
    scrambleWallClockMs = boundedInteger(values.scrambleWallClockMs,
      DEFAULTS.scrambleWallClockMs, 15000, 90000),
    fullRandomWallClockMs = boundedInteger(values.fullRandomWallClockMs,
      DEFAULTS.fullRandomWallClockMs, 30000, 120000),
    raceSlotWallClockMs = boundedInteger(values.raceSlotWallClockMs,
      DEFAULTS.raceSlotWallClockMs, 30000, 120000),
    maxSpawnAttemptsPerFrame = boundedInteger(values.maxSpawnAttemptsPerFrame,
      DEFAULTS.maxSpawnAttemptsPerFrame, 1, 2),
    maxHeavyReloadsPerFrame = boundedInteger(values.maxHeavyReloadsPerFrame,
      DEFAULTS.maxHeavyReloadsPerFrame, 1, 2),
  }
end

local function operationTimeoutMs(state, kind, domain)
  if domain == "race" then return state.raceSlotWallClockMs end
  if kind == "randomConfig" then return state.randomCarWallClockMs end
  if kind == "scramble" then return state.scrambleWallClockMs end
  if kind == "fullRandom" then return state.fullRandomWallClockMs end
  return state.maxOperationWallClockMs
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
M.operationTimeoutMs = operationTimeoutMs

return M
