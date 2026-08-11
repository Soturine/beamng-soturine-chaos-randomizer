local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local KINDS = {preview_generation = true, lineup_generation = true}
local TERMINAL = {succeeded = true, failed = true, cancelled = true, superseded = true}

local function create()
  return {
    sequence = 0,
    generations = {preview_generation = 0, lineup_generation = 0},
    current = {},
    recoverable = {},
    history = {},
  }
end

local function archive(state, attempt)
  state.history[#state.history + 1] = util.deepCopy(attempt)
  while #state.history > 16 do table.remove(state.history, 1) end
end

local function begin(state, kind, options)
  if type(state) ~= "table" or not KINDS[kind] then return nil, "race_attempt_kind_invalid" end
  options = type(options) == "table" and options or {}
  local previous = state.current[kind]
  if previous and previous.active == true then
    previous.active = false
    previous.status = "superseded"
    previous.phase = "terminal"
    previous.terminalState = "superseded"
    previous.endedAt = tonumber(options.now) or previous.startedAt
    previous.callbackDisposition = "callbacks_invalidated"
    archive(state, previous)
  end
  state.sequence = state.sequence + 1
  state.generations[kind] = (state.generations[kind] or 0) + 1
  local startedAt = tonumber(options.now) or 0
  local attempt = {
    kind = kind,
    domain = "race",
    operationId = "race:" .. kind .. ":" .. tostring(state.sequence),
    generation = state.generations[kind],
    phase = "validating",
    phaseSequence = 1,
    callbackSequence = 0,
    consumedCallbacks = {},
    staleCallbacksPrevented = 0,
    active = true,
    status = "active",
    terminalState = nil,
    cancelled = false,
    startedAt = startedAt,
    deadline = startedAt + math.max(1, tonumber(options.deadlineSeconds) or 10),
    desired = util.deepCopy(options.desired or {}),
    callbackDisposition = "pending",
  }
  state.current[kind] = attempt
  return attempt, previous
end

local function isCurrent(state, attempt)
  if type(state) ~= "table" or type(attempt) ~= "table" or not KINDS[attempt.kind] then return false end
  local current = state.current[attempt.kind]
  return current == attempt
    and current.operationId == attempt.operationId
    and current.generation == attempt.generation
end

local function setPhase(state, attempt, phase)
  if not isCurrent(state, attempt) or attempt.active ~= true then return false, "race_attempt_stale" end
  phase = tostring(phase or "")
  if phase == "" then return false, "race_attempt_phase_invalid" end
  if attempt.phase ~= phase then
    attempt.phase = phase
    attempt.phaseSequence = attempt.phaseSequence + 1
  end
  return true, attempt
end

local function callbackToken(state, attempt, kind)
  if not isCurrent(state, attempt) or attempt.active ~= true then return nil, "race_attempt_stale" end
  attempt.callbackSequence = attempt.callbackSequence + 1
  return {
    domain = "race",
    attemptKind = attempt.kind,
    operationId = attempt.operationId,
    generation = attempt.generation,
    phase = attempt.phase,
    phaseSequence = attempt.phaseSequence,
    callbackToken = attempt.operationId .. ":" .. tostring(attempt.generation)
      .. ":" .. tostring(attempt.phaseSequence) .. ":" .. tostring(attempt.callbackSequence),
    kind = tostring(kind or "callback"),
  }
end

local function validateCallback(state, token, consume)
  if type(token) ~= "table" or not KINDS[token.attemptKind] then return false, "race_attempt_callback_invalid" end
  local current = state.current[token.attemptKind]
  local valid = current and current.active == true
    and current.operationId == token.operationId
    and current.generation == token.generation
    and current.phaseSequence == token.phaseSequence
  if not valid then
    if current then current.staleCallbacksPrevented = current.staleCallbacksPrevented + 1 end
    return false, "race_attempt_callback_stale"
  end
  if current.consumedCallbacks[token.callbackToken] then
    current.staleCallbacksPrevented = current.staleCallbacksPrevented + 1
    return false, "race_attempt_callback_consumed"
  end
  if consume == true then current.consumedCallbacks[token.callbackToken] = true end
  return true, current
end

local function finish(state, attempt, status, options)
  if not isCurrent(state, attempt) or attempt.active ~= true then return false, "race_attempt_stale" end
  if not TERMINAL[status] then return false, "race_attempt_terminal_invalid" end
  options = type(options) == "table" and options or {}
  attempt.active = false
  attempt.status = status
  attempt.phase = "terminal"
  attempt.phaseSequence = attempt.phaseSequence + 1
  attempt.terminalState = status
  attempt.cancelled = status == "cancelled"
  attempt.endedAt = tonumber(options.now) or attempt.startedAt
  attempt.errorCode = options.errorCode
  attempt.recoverable = options.recoverable == true
  attempt.retryAction = options.retryAction
  attempt.callbackDisposition = "callbacks_invalidated"
  if status == "succeeded" then
    state.recoverable[attempt.kind] = nil
  elseif attempt.recoverable then
    state.recoverable[attempt.kind] = {
      kind = attempt.kind,
      operationId = attempt.operationId,
      generation = attempt.generation,
      code = tostring(attempt.errorCode or "race_attempt_failed"),
      retryAction = tostring(attempt.retryAction or ""),
      desired = util.deepCopy(attempt.desired),
      createdAt = attempt.endedAt,
    }
  end
  archive(state, attempt)
  return true, attempt
end

local function dismiss(state, kind)
  if not KINDS[kind] then return false end
  state.recoverable[kind] = nil
  return true
end

local function snapshot(state)
  local current, recoverable = {}, {}
  for _, kind in ipairs({"preview_generation", "lineup_generation"}) do
    local attempt = state.current[kind]
    if attempt then
      current[kind] = {
        kind = kind, operationId = attempt.operationId, generation = attempt.generation,
        phase = attempt.phase, phaseSequence = attempt.phaseSequence, active = attempt.active,
        status = attempt.status, terminalState = attempt.terminalState,
        deadline = attempt.deadline, staleCallbacksPrevented = attempt.staleCallbacksPrevented,
      }
    end
    if state.recoverable[kind] then recoverable[kind] = util.deepCopy(state.recoverable[kind]) end
  end
  return {current = current, recoverable = recoverable}
end

M.KINDS = KINDS
M.create = create
M.begin = begin
M.isCurrent = isCurrent
M.setPhase = setPhase
M.callbackToken = callbackToken
M.validateCallback = validateCallback
M.finish = finish
M.dismiss = dismiss
M.snapshot = snapshot

return M
