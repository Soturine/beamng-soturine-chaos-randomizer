local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local TERMINAL = {confirmed = true, unavailable = true, mismatch = true, timeout = true, destroyed = true, stale = true}

local function normalize(mode)
  mode = tostring(mode or ""):lower()
  local aliases = {destination = "traffic", route = "traffic", chase = "chase",
    follow = "follow", flee = "flee", traffic = "traffic", roam = "random", random = "random"}
  return aliases[mode] or mode
end

local function create(vehicleId, generation, expectedMode, now, timeout)
  return {
    vehicleId = tonumber(vehicleId), generation = tonumber(generation) or 0,
    expectedMode = normalize(expectedMode), status = "pending",
    startedAt = tonumber(now) or 0, timeout = util.clamp(tonumber(timeout) or 2, 0.1, 10),
    attempts = 0,
  }
end

local function observe(state, mode, now, generation)
  if TERMINAL[state.status] then return state.status end
  if generation ~= nil and generation ~= state.generation then state.status = "stale"; return state.status end
  now = tonumber(now) or state.startedAt
  if now - state.startedAt >= state.timeout then
    state.status = (state.mismatches or 0) > 0 and "mismatch" or "timeout"
    return state.status
  end
  state.attempts = state.attempts + 1
  if mode == nil then return "pending" end
  state.observedMode = normalize(mode)
  if state.observedMode == state.expectedMode then state.status = "confirmed"; return state.status end
  state.mismatches = (state.mismatches or 0) + 1
  return "pending"
end

local function unavailable(state)
  if not TERMINAL[state.status] then state.status = "unavailable" end
  return state.status
end

local function destroyed(state)
  if not TERMINAL[state.status] then state.status = "destroyed" end
  return state.status
end

M.normalize = normalize
M.create = create
M.observe = observe
M.unavailable = unavailable
M.destroyed = destroyed

return M
