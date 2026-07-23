local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local MAX_ITERATIONS = 50
local DEFAULT_ITERATIONS = 10
local DEFAULT_MAX_DURATION = 300
local MODES = {randomConfig = true, scramble = true, fullRandom = true, mixed = true}

local function normalizeOptions(options)
  options = type(options) == "table" and options or {}
  local requested = tonumber(options.iterations) or DEFAULT_ITERATIONS
  if requested > MAX_ITERATIONS then return nil, "stress_iteration_limit" end
  local iterations = math.max(1, math.floor(requested))
  local mode = MODES[options.mode] and options.mode or "mixed"
  return {
    iterations = iterations,
    mode = mode,
    maxDuration = util.clamp(options.maxDuration or DEFAULT_MAX_DURATION, 10, DEFAULT_MAX_DURATION),
    operationTimeout = util.clamp(options.operationTimeout or 25, 5, 60),
    stopOnFailure = options.stopOnFailure == true,
    seed = tostring(options.seed or "developer-stress"),
  }
end

local function create(options, startedAt)
  local normalized, err = normalizeOptions(options)
  if not normalized then return nil, err end
  return {
    active = true,
    options = normalized,
    startedAt = startedAt,
    pendingNext = true,
    currentIteration = 0,
    currentSeed = nil,
    summary = {
      attempts = 0,
      successes = 0,
      failures = 0,
      timeouts = 0,
      rollbacks = 0,
      phaseCounts = {},
      blacklists = {},
      totalDuration = 0,
      averageDuration = 0,
      slowestDuration = 0,
      failureSeeds = {},
    },
  }
end

local function operationFor(state, iteration)
  local mode = state.options.mode
  if mode ~= "mixed" then return mode end
  local choices = {"randomConfig", "scramble", "fullRandom"}
  return choices[((iteration - 1) % #choices) + 1]
end

local function iterationSeed(state, generator, iteration)
  return generator:fork("developer-stress:" .. tostring(iteration)).seed
end

local function record(state, result)
  result = type(result) == "table" and result or {}
  local summary = state.summary
  summary.attempts = summary.attempts + 1
  local duration = math.max(0, tonumber(result.duration) or 0)
  summary.totalDuration = summary.totalDuration + duration
  summary.averageDuration = summary.totalDuration / summary.attempts
  summary.slowestDuration = math.max(summary.slowestDuration, duration)
  if result.success then
    summary.successes = summary.successes + 1
  else
    summary.failures = summary.failures + 1
    summary.failureSeeds[#summary.failureSeeds + 1] = result.seed
  end
  if result.timeout then summary.timeouts = summary.timeouts + 1 end
  if result.rollback then summary.rollbacks = summary.rollbacks + 1 end
  if result.phase then summary.phaseCounts[result.phase] = (summary.phaseCounts[result.phase] or 0) + 1 end
  state.pendingNext = result.success or not state.options.stopOnFailure
  if summary.attempts >= state.options.iterations or (not result.success and state.options.stopOnFailure) then
    state.active = false
    state.pendingNext = false
  end
end

local function cancel(state, reason)
  if not state then return false end
  state.active = false
  state.pendingNext = false
  state.cancelReason = reason or "manual"
  return true
end

M.MAX_ITERATIONS = MAX_ITERATIONS
M.DEFAULT_ITERATIONS = DEFAULT_ITERATIONS
M.normalizeOptions = normalizeOptions
M.create = create
M.operationFor = operationFor
M.iterationSeed = iterationSeed
M.record = record
M.cancel = cancel

return M
