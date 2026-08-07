local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local DECISIONS = {
  VALID = "VALID",
  INVALID_CONFIRMED = "INVALID_CONFIRMED",
  UNKNOWN_OR_PENDING = "UNKNOWN_OR_PENDING",
}

local function create(options)
  options = type(options) == "table" and options or {}
  return {
    maxAttempts = math.max(1, math.min(5, math.floor(tonumber(options.maxAttempts) or 3))),
    retryWindow = util.clamp(tonumber(options.retryWindow) or 1.5, 0.1, 5),
    retryDelay = util.clamp(tonumber(options.retryDelay) or 0.1, 0.02, 0.5),
    attempts = 0,
    firstAttemptAt = nil,
    lastAttemptAt = nil,
    lastDecision = nil,
    terminal = false,
  }
end

local function observe(state, result, now, allowPartial)
  now = tonumber(now) or 0
  result = type(result) == "table" and result or {
    decision = DECISIONS.UNKNOWN_OR_PENDING, status = "pending", reason = "validation_result_missing",
  }
  local decision = result.decision or DECISIONS.UNKNOWN_OR_PENDING
  state.lastDecision = decision
  state.lastResult = util.deepCopy(result)
  state.lastAttemptAt = now
  if decision == DECISIONS.VALID then
    state.attempts = 0
    state.firstAttemptAt = nil
    state.terminal = true
    return "accept", result
  end
  if decision == DECISIONS.INVALID_CONFIRMED then
    state.terminal = true
    return "invalid_confirmed", result
  end

  state.attempts = state.attempts + 1
  state.firstAttemptAt = state.firstAttemptAt or now
  local elapsed = math.max(0, now - state.firstAttemptAt)
  if state.attempts < state.maxAttempts and elapsed < state.retryWindow then
    return "retry", {
      decision = DECISIONS.UNKNOWN_OR_PENDING,
      attempt = state.attempts,
      maxAttempts = state.maxAttempts,
      retryAt = now + state.retryDelay,
      elapsed = elapsed,
      reason = result.reason or "safety_evidence_pending",
    }
  end
  state.terminal = true
  if allowPartial == true then return "accept_partial", result end
  return "unconfirmed", result
end

local function reset(state)
  state.attempts = 0
  state.firstAttemptAt = nil
  state.lastAttemptAt = nil
  state.lastDecision = nil
  state.lastResult = nil
  state.terminal = false
  return true
end

local function snapshot(state)
  return {
    maxAttempts = state.maxAttempts,
    retryWindow = state.retryWindow,
    retryDelay = state.retryDelay,
    attempts = state.attempts,
    firstAttemptAt = state.firstAttemptAt,
    lastAttemptAt = state.lastAttemptAt,
    lastDecision = state.lastDecision,
    terminal = state.terminal,
  }
end

M.DECISIONS = DECISIONS
M.create = create
M.observe = observe
M.reset = reset
M.snapshot = snapshot

return M
