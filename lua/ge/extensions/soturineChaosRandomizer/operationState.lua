local M = {}

local TERMINAL = {
  completed = true,
  cancelled = true,
  failed = true,
}

local ALLOWED = {
  idle = {indexing = true, selecting = true, scanning = true, spawning = true, rollingBack = true},
  indexing = {selecting = true, scanning = true, failed = true, cancelled = true},
  selecting = {spawning = true, scanning = true, failed = true, cancelled = true},
  spawning = {waitingForVehicle = true, failed = true, rollingBack = true, cancelled = true},
  waitingForVehicle = {scanning = true, completed = true, rollingBack = true, failed = true, cancelled = true},
  scanning = {mutating = true, tuning = true, painting = true, validating = true, completed = true, rollingBack = true, failed = true, cancelled = true},
  mutating = {waitingForReload = true, scanning = true, tuning = true, rollingBack = true, failed = true, cancelled = true},
  waitingForReload = {scanning = true, tuning = true, painting = true, validating = true, completed = true, rollingBack = true, failed = true, cancelled = true},
  tuning = {waitingForReload = true, painting = true, validating = true, completed = true, rollingBack = true, failed = true, cancelled = true},
  painting = {waitingForReload = true, validating = true, completed = true, rollingBack = true, failed = true, cancelled = true},
  validating = {selecting = true, spawning = true, scanning = true, completed = true, rollingBack = true, failed = true, cancelled = true},
  rollingBack = {waitingForVehicle = true, completed = true, failed = true, cancelled = true},
  completed = {idle = true},
  cancelled = {idle = true},
  failed = {idle = true},
}

local function create(clock, defaultTimeout)
  return {
    clock = clock or os.clock,
    defaultTimeout = tonumber(defaultTimeout) or 20,
    sequence = 0,
    state = "idle",
    busy = false,
    token = nil,
    kind = nil,
    vehicleId = nil,
    deadline = nil,
    error = nil,
  }
end

local function begin(state, kind, vehicleId, timeout)
  if state.busy then return false, "busy" end
  state.sequence = state.sequence + 1
  state.state = "idle"
  state.busy = true
  state.kind = kind
  state.vehicleId = vehicleId
  state.error = nil
  state.token = string.format("SCR-%08d", state.sequence)
  state.deadline = state.clock() + (tonumber(timeout) or state.defaultTimeout)
  return true, state.token
end

local function transition(state, target, timeout)
  if not state.busy and target ~= "idle" then return false, "not_busy" end
  if not (ALLOWED[state.state] and ALLOWED[state.state][target]) then
    return false, "invalid_transition:" .. tostring(state.state) .. "->" .. tostring(target)
  end
  state.state = target
  if timeout == false then
    state.deadline = nil
  elseif timeout ~= nil then
    state.deadline = state.clock() + (tonumber(timeout) or state.defaultTimeout)
  end
  return true
end

local function isCurrent(state, token)
  return state.busy and state.token ~= nil and state.token == token
end

local function isExpired(state, now)
  return state.busy and state.deadline ~= nil and (now or state.clock()) >= state.deadline
end

local function finish(state, terminalState, errorValue)
  terminalState = terminalState or "completed"
  if not TERMINAL[terminalState] then return false, "not_terminal" end
  if state.busy and state.state ~= terminalState then
    local ok = transition(state, terminalState, false)
    if not ok then state.state = terminalState end
  else
    state.state = terminalState
  end
  state.error = errorValue
  state.busy = false
  state.deadline = nil
  return true
end

local function reset(state)
  if state.busy then return false, "busy" end
  state.state = "idle"
  state.kind = nil
  state.vehicleId = nil
  state.deadline = nil
  state.error = nil
  state.token = nil
  return true
end

M.create = create
M.begin = begin
M.transition = transition
M.isCurrent = isCurrent
M.isExpired = isExpired
M.finish = finish
M.reset = reset
M.allowedTransitions = ALLOWED

return M
