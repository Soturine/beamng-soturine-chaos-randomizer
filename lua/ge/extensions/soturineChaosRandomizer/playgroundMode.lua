local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local STATES = {
  IDLE = true, SETUP = true, RUNNING = true, PAUSED = true,
  COMPLETED = true, FAILED = true, CANCELLED = true,
}

local TERMINAL = {COMPLETED = true, FAILED = true, CANCELLED = true}
local TRANSITIONS = {
  IDLE = {SETUP = true},
  SETUP = {RUNNING = true, CANCELLED = true, FAILED = true},
  RUNNING = {PAUSED = true, COMPLETED = true, CANCELLED = true, FAILED = true},
  PAUSED = {RUNNING = true, CANCELLED = true, FAILED = true},
}

local function create(mode, identity)
  return {
    mode = tostring(mode or "none"), state = "IDLE", generation = 0,
    identity = util.deepCopy(identity), participants = {}, events = {},
  }
end

local function transition(state, target, reason)
  if not STATES[target] then return false, "playground_state_invalid" end
  if TERMINAL[state.state] then return false, "playground_terminal_immutable" end
  if not (TRANSITIONS[state.state] and TRANSITIONS[state.state][target]) then
    return false, "playground_transition_invalid"
  end
  state.state = target
  state.reason = reason
  state.generation = state.generation + 1
  return true
end

local function addParticipant(state, identity)
  if state.state ~= "SETUP" then return false, "playground_setup_required" end
  identity = type(identity) == "table" and util.deepCopy(identity) or {}
  local key = tostring(identity.ownerPlayerId or "local") .. ":"
    .. tostring(identity.networkVehicleId or identity.localVehicleId or "missing")
  if state.participants[key] then return false, "playground_participant_duplicate" end
  state.participants[key] = identity
  return true, key
end

M.STATES = STATES
M.create = create
M.transition = transition
M.addParticipant = addParticipant

return M
