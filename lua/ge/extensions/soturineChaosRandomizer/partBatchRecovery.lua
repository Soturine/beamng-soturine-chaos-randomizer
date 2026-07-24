local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local DEFAULTS = {
  retriesPerSlot = 2,
  retriesPerPass = 8,
  batchRollbacks = 4,
  operationRetries = 12,
  quarantineLimit = 128,
}

local function create(options)
  options = type(options) == "table" and options or {}
  return {
    limits = {
      retriesPerSlot = tonumber(options.retriesPerSlot) or DEFAULTS.retriesPerSlot,
      retriesPerPass = tonumber(options.retriesPerPass) or DEFAULTS.retriesPerPass,
      batchRollbacks = tonumber(options.batchRollbacks) or DEFAULTS.batchRollbacks,
      operationRetries = tonumber(options.operationRetries) or DEFAULTS.operationRetries,
      quarantineLimit = tonumber(options.quarantineLimit) or DEFAULTS.quarantineLimit,
    },
    slotRetries = {},
    passRetries = {},
    operationRetries = 0,
    rollbacks = 0,
    quarantine = {},
    quarantineOrder = {},
    currentBatch = nil,
  }
end

local function scopeKey(modelKey, configKey, slotPath, candidate)
  return table.concat({tostring(modelKey or ""), tostring(configKey or ""), tostring(slotPath or ""), tostring(candidate or "")}, "\31")
end

local function slotKey(modelKey, configKey, slotPath)
  return scopeKey(modelKey, configKey, slotPath, "")
end

local function beginBatch(state, context)
  state.currentBatch = {
    modelKey = context.modelKey,
    configKey = context.configKey,
    pass = tonumber(context.pass) or 1,
    treeBefore = util.deepCopy(context.treeBefore or {}),
    changes = util.deepCopy(context.changes or {}),
  }
  return state.currentBatch
end

local function isQuarantined(state, modelKey, configKey, slotPath, candidate)
  return state.quarantine[scopeKey(modelKey, configKey, slotPath, candidate)] ~= nil
end

local function quarantine(state, context, reason)
  local key = scopeKey(context.modelKey, context.configKey, context.slotPath, context.candidate)
  if state.quarantine[key] then return false, state.quarantine[key] end
  if #state.quarantineOrder >= state.limits.quarantineLimit then return false, "quarantine_limit" end
  local entry = {
    modelKey = context.modelKey,
    configKey = context.configKey,
    slotPath = context.slotPath,
    candidate = context.candidate,
    reason = reason or "part_candidate_quarantined",
  }
  state.quarantine[key] = entry
  state.quarantineOrder[#state.quarantineOrder + 1] = key
  return true, entry
end

local function recordFailure(state, context, reason)
  context = type(context) == "table" and context or {}
  local pass = tonumber(context.pass) or 1
  local key = slotKey(context.modelKey, context.configKey, context.slotPath)
  state.slotRetries[key] = (state.slotRetries[key] or 0) + 1
  state.passRetries[pass] = (state.passRetries[pass] or 0) + 1
  state.operationRetries = state.operationRetries + 1
  quarantine(state, context, reason)
  if state.slotRetries[key] > state.limits.retriesPerSlot then return false, "part_slot_retry_budget_exhausted" end
  if state.passRetries[pass] > state.limits.retriesPerPass then return false, "part_pass_retry_budget_exhausted" end
  if state.operationRetries > state.limits.operationRetries then return false, "part_operation_retry_budget_exhausted" end
  return true, "part_candidate_quarantined"
end

local function beginRollback(state)
  state.rollbacks = state.rollbacks + 1
  if state.rollbacks > state.limits.batchRollbacks then return false, "part_batch_rollback_budget_exhausted" end
  if not state.currentBatch then return false, "part_batch_snapshot_missing" end
  return true, util.deepCopy(state.currentBatch.treeBefore)
end

local function finishRollback(state, success)
  if success then
    state.currentBatch = nil
    return true, "part_batch_rollback_completed"
  end
  return false, "part_batch_rollback_failed"
end

local function filterCandidates(state, modelKey, configKey, slotPath, candidates)
  local result = {}
  for _, candidate in ipairs(candidates or {}) do
    if not isQuarantined(state, modelKey, configKey, slotPath, candidate) then result[#result + 1] = candidate end
  end
  return result
end

local function metrics(state)
  return {
    partRetries = state.operationRetries,
    batchRollbacks = state.rollbacks,
    quarantinedCandidates = #state.quarantineOrder,
  }
end

M.DEFAULTS = DEFAULTS
M.create = create
M.scopeKey = scopeKey
M.beginBatch = beginBatch
M.isQuarantined = isQuarantined
M.quarantine = quarantine
M.recordFailure = recordFailure
M.beginRollback = beginRollback
M.finishRollback = finishRollback
M.filterCandidates = filterCandidates
M.metrics = metrics

return M
