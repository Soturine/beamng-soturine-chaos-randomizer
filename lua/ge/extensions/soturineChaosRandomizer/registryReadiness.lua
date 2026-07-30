local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local STATES = {
  unavailable = true, warming_up = true, partial = true, ready = true, failed_confirmed = true,
}

local function create(options)
  options = type(options) == "table" and options or {}
  return {
    state = "unavailable",
    attempt = 0,
    startedAt = nil,
    lastAttemptAt = nil,
    nextAttemptAt = nil,
    retryInterval = tonumber(options.retryInterval) or 0.35,
    timeout = tonumber(options.timeout) or 8,
    maxAttempts = math.max(1, math.floor(tonumber(options.maxAttempts) or 12)),
    lastIssues = {},
    lastCounts = {models = 0, configurations = 0},
  }
end

local function begin(readiness, now, reason)
  now = tonumber(now) or 0
  readiness.state = "warming_up"
  readiness.attempt = 0
  readiness.startedAt = now
  readiness.lastAttemptAt = nil
  readiness.nextAttemptAt = now
  readiness.reason = reason or "initial_load"
  readiness.lastIssues = {}
  return readiness
end

local function due(readiness, now)
  return readiness.state ~= "ready" and readiness.state ~= "failed_confirmed"
    and tonumber(now) >= tonumber(readiness.nextAttemptAt or 0)
end

local function observe(readiness, snapshot, now)
  now = tonumber(now) or 0
  snapshot = type(snapshot) == "table" and snapshot or {}
  readiness.attempt = readiness.attempt + 1
  readiness.lastAttemptAt = now
  readiness.lastIssues = util.deepCopy(snapshot.issues or {})
  readiness.lastCounts = {
    models = tonumber(snapshot.modelCount) or 0,
    configurations = tonumber(snapshot.configCount) or 0,
  }
  local complete = snapshot.modelsReady == true and snapshot.configsReady == true
    and readiness.lastCounts.models > 0 and readiness.lastCounts.configurations > 0
  if complete then
    readiness.state = "ready"
    readiness.nextAttemptAt = nil
    return "ready"
  end
  local elapsed = now - tonumber(readiness.startedAt or now)
  if readiness.attempt >= readiness.maxAttempts or elapsed >= readiness.timeout then
    readiness.state = "failed_confirmed"
    readiness.nextAttemptAt = nil
    return "failed_confirmed"
  end
  readiness.state = (snapshot.modelsReady == true or snapshot.configsReady == true) and "partial" or "warming_up"
  readiness.nextAttemptAt = now + readiness.retryInterval
  return readiness.state
end

local function summary(readiness)
  local result = util.deepCopy(readiness)
  if not STATES[result.state] then result.state = "unavailable" end
  return result
end

M.STATES = STATES
M.create = create
M.begin = begin
M.due = due
M.observe = observe
M.summary = summary

return M
