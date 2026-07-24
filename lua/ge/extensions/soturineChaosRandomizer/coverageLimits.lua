local M = {}

-- Centralized hard stops. They are deliberately independent of Chaos: the
-- slider selects work, while these limits only prevent runaway mod content.
local DEFAULTS = {
  maxTotalPasses = 48,
  maxOperationTime = 120,
  maxReloads = 48,
  maxNoProgressPasses = 4,
  coherentScansRequired = 2,
  maxDiscoveredSlots = 2048,
  maxCandidateAttempts = 4096,
  maxTuningVariables = 2048,
  maxPaintFields = 64,
  maxLineupCompetitors = 16,
  maxManagedVehicles = 32,
  maxAIRouteNodes = 512,
  maxAIDiagnostics = 256,
}

local function copy(source)
  local result = {}
  for key, value in pairs(source) do result[key] = value end
  return result
end

local function derive(scanMetrics, overrides)
  local result = copy(DEFAULTS)
  local slotCount = math.max(1, math.floor(tonumber(scanMetrics and scanMetrics.slotCount) or 1))
  local depth = math.max(1, math.floor(tonumber(scanMetrics and scanMetrics.maxDepth) or 1))
  -- Deep trees need more passes, but never more than the audited hard stop.
  result.maxTotalPasses = math.min(DEFAULTS.maxTotalPasses, math.max(12, depth * 3 + 6))
  result.maxReloads = math.min(DEFAULTS.maxReloads, math.max(12, depth * 3 + 8))
  result.maxCandidateAttempts = math.min(DEFAULTS.maxCandidateAttempts, math.max(128, slotCount * 12))
  for key, value in pairs(type(overrides) == "table" and overrides or {}) do
    if result[key] ~= nil and type(value) == "number" and value > 0 then
      result[key] = math.min(DEFAULTS[key], math.floor(value))
    end
  end
  return result
end

local function exceeded(limits, metrics, now)
  limits = limits or DEFAULTS
  metrics = metrics or {}
  local checks = {
    {"maxTotalPasses", metrics.passesUsed},
    {"maxReloads", metrics.reloadsUsed},
    {"maxNoProgressPasses", metrics.noProgressPasses},
    {"maxDiscoveredSlots", metrics.slotsDiscovered},
    {"maxCandidateAttempts", metrics.candidateAttempts},
  }
  for _, check in ipairs(checks) do
    if tonumber(check[2]) and check[2] >= limits[check[1]] then return check[1] end
  end
  if metrics.startedAt and now and now - metrics.startedAt >= limits.maxOperationTime then
    return "maxOperationTime"
  end
  return nil
end

M.DEFAULTS = DEFAULTS
M.derive = derive
M.exceeded = exceeded
M.copyDefaults = function() return copy(DEFAULTS) end

return M
