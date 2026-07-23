local M = {}

M.MINIMUM_PASSES = 12
M.MAXIMUM_PASSES = 128
M.DEFAULT_SAFETY_MARGIN = 4
M.DEFAULT_TIMEOUT = 120

local function calculate(savedMaxDepth, currentMaxDepth, safetyMargin)
  local depth = math.max(0, math.floor(tonumber(savedMaxDepth) or 0), math.floor(tonumber(currentMaxDepth) or 0))
  local requiredPasses = depth + math.max(0, math.floor(tonumber(safetyMargin) or M.DEFAULT_SAFETY_MARGIN))
  return {
    requiredPasses = requiredPasses,
    passLimit = math.min(math.max(requiredPasses, M.MINIMUM_PASSES), M.MAXIMUM_PASSES),
    absoluteLimit = M.MAXIMUM_PASSES,
  }
end

local function create(savedMaxDepth, currentMaxDepth, startedAt, timeout, safetyMargin)
  local budget = calculate(savedMaxDepth, currentMaxDepth, safetyMargin)
  budget.startedAt = tonumber(startedAt) or 0
  budget.timeout = math.max(1, tonumber(timeout) or M.DEFAULT_TIMEOUT)
  budget.pass = 0
  budget.lastFingerprint = nil
  budget.lastPending = nil
  budget.seen = {}
  return budget
end

local function observe(state, scanFingerprint, pendingCount, now)
  state.pass = state.pass + 1
  pendingCount = math.max(0, math.floor(tonumber(pendingCount) or 0))
  if (tonumber(now) or 0) - state.startedAt > state.timeout then return false, "dna_restore_timeout" end
  if state.pass > state.passLimit then return false, "dna_restore_pass_limit" end
  if pendingCount == 0 then
    state.lastFingerprint, state.lastPending = scanFingerprint, 0
    return true, "complete"
  end
  if scanFingerprint and state.lastFingerprint == scanFingerprint and state.lastPending and pendingCount >= state.lastPending then
    return false, "dna_restore_no_progress"
  end
  if scanFingerprint and state.seen[scanFingerprint] then return false, "dna_restore_repeated_state" end
  if scanFingerprint then state.seen[scanFingerprint] = true end
  state.lastFingerprint, state.lastPending = scanFingerprint, pendingCount
  return true, "continue"
end

M.calculate = calculate
M.create = create
M.observe = observe

return M
