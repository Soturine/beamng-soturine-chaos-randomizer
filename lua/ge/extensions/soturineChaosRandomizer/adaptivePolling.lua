local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local function create(options, now)
  options = type(options) == "table" and options or {}
  local fast = util.clamp(tonumber(options.fastInterval) or 0.10, 0.01, 10)
  local slow = util.clamp(tonumber(options.slowInterval) or 1.00, fast, 60)
  return {
    fastInterval = fast, slowInterval = slow,
    multiplier = util.clamp(tonumber(options.multiplier) or 1.7, 1.1, 4),
    stableThreshold = math.max(1, math.floor(tonumber(options.stableThreshold) or 3)),
    currentInterval = fast, stableCount = 0, nextAt = tonumber(now) or 0,
    terminal = false, generation = math.floor(tonumber(options.generation) or 0),
  }
end

local function due(state, now, generation)
  if type(state) ~= "table" or state.terminal then return false end
  if generation ~= nil and generation ~= state.generation then return false, "stale_poll" end
  return (tonumber(now) or 0) >= state.nextAt
end

local function observed(state, now, changed, generation)
  if generation ~= nil and generation ~= state.generation then return false, "stale_poll" end
  if state.terminal then return false, "poll_terminal" end
  if changed then
    state.stableCount, state.currentInterval = 0, state.fastInterval
  else
    state.stableCount = state.stableCount + 1
    if state.stableCount >= state.stableThreshold then
      state.currentInterval = math.min(state.slowInterval, state.currentInterval * state.multiplier)
    end
  end
  state.nextAt = (tonumber(now) or 0) + state.currentInterval
  return true
end

local function wake(state, now, generation)
  if generation ~= nil then state.generation = generation end
  state.terminal, state.stableCount, state.currentInterval = false, 0, state.fastInterval
  state.nextAt = tonumber(now) or 0
  return true
end

local function stop(state)
  state.terminal, state.nextAt = true, math.huge
  return true
end

M.create = create
M.due = due
M.observed = observed
M.wake = wake
M.stop = stop

return M
