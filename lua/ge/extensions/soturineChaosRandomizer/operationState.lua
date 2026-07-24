local M = {}

local TERMINAL = {
  completed = true,
  partial = true,
  cancelled = true,
  failed = true,
}

local PHASES = {
  idle = {terminal = true, pauseIndependent = true},
  capturing_original = {pauseIndependent = true},
  selecting = {pauseIndependent = true},
  issuing_spawn = {pauseIndependent = true},
  tracking_target_identity = {pauseIndependent = true},
  waiting_for_simulation_resume = {requiresSimulationProgress = true},
  stabilizing_tree = {requiresSimulationProgress = true},
  planning_parts = {pauseIndependent = true},
  applying_parts = {pauseIndependent = true},
  waiting_parts_reload = {requiresSimulationProgress = true},
  verifying_parts = {pauseIndependent = true},
  isolating_failed_candidate = {pauseIndependent = true},
  rolling_back_batch = {requiresSimulationProgress = true},
  retrying_candidate = {pauseIndependent = true},
  rescanning_tree = {pauseIndependent = true},
  planning_tuning = {pauseIndependent = true},
  applying_tuning = {pauseIndependent = true},
  waiting_tuning_reload = {requiresSimulationProgress = true},
  verifying_tuning = {pauseIndependent = true},
  applying_paint = {pauseIndependent = true},
  verifying_paint = {pauseIndependent = true},
  final_validation = {pauseIndependent = true},
  completed = {terminal = true, pauseIndependent = true},
  partial = {terminal = true, pauseIndependent = true},
  cancelling = {pauseIndependent = true},
  cancelled = {terminal = true, pauseIndependent = true},
  rolling_back_operation = {requiresSimulationProgress = true},
  recovering_previous = {requiresSimulationProgress = true},
  recovering_last_completed_good = {requiresSimulationProgress = true},
  recovering_fallback = {requiresSimulationProgress = true},
  failed = {terminal = true, pauseIndependent = true},
}

-- Legacy transitions remain as an internal compatibility surface while phase is
-- the authoritative lifecycle state exposed to new code.
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
  partial = {idle = true},
}

local LEGACY_PHASE = {
  idle = "idle",
  indexing = "selecting",
  selecting = "selecting",
  spawning = "issuing_spawn",
  waitingForVehicle = "tracking_target_identity",
  scanning = "rescanning_tree",
  mutating = "planning_parts",
  waitingForReload = "tracking_target_identity",
  tuning = "planning_tuning",
  painting = "applying_paint",
  validating = "final_validation",
  rollingBack = "rolling_back_operation",
  completed = "completed",
  partial = "partial",
  cancelled = "cancelled",
  failed = "failed",
}

local function deriveBusy(state)
  local definition = PHASES[state.phase] or {}
  return state.phase ~= "idle" and definition.terminal ~= true
end

local function refreshBusy(state)
  state.busy = deriveBusy(state)
  return state.busy
end

local function create(clock, defaultTimeout)
  return {
    clock = clock or os.clock,
    defaultTimeout = tonumber(defaultTimeout) or 20,
    sequence = 0,
    operationId = nil,
    operationToken = nil,
    operationGeneration = 0,
    phaseGeneration = 0,
    targetGeneration = 0,
    state = "idle",
    phase = "idle",
    previousPhase = nil,
    phaseReason = nil,
    busy = false,
    token = nil,
    kind = nil,
    vehicleId = nil,
    expectedTarget = nil,
    deadline = nil,
    operationDeadline = nil,
    error = nil,
    staleCallbackCount = 0,
    invalidationReason = nil,
  }
end

local function operationToken(state)
  return string.format("%s-G%04d", state.operationId or "SCR-00000000", state.operationGeneration)
end

local function setPhase(state, phase, timeout, reason)
  if not PHASES[phase] then return false, "unknown_phase:" .. tostring(phase) end
  state.previousPhase = state.phase
  if state.phase ~= phase then state.phaseGeneration = state.phaseGeneration + 1 end
  state.phase = phase
  state.phaseReason = reason
  if timeout == false then
    state.deadline = nil
  elseif timeout ~= nil then
    state.deadline = state.clock() + (tonumber(timeout) or state.defaultTimeout)
  end
  refreshBusy(state)
  return true
end

local function begin(state, kind, vehicleId, timeout)
  if deriveBusy(state) then return false, "busy" end
  state.sequence = state.sequence + 1
  state.operationGeneration = state.operationGeneration + 1
  state.phaseGeneration = state.phaseGeneration + 1
  state.targetGeneration = state.targetGeneration + 1
  state.operationId = string.format("SCR-%08d", state.sequence)
  state.operationToken = operationToken(state)
  state.token = state.operationToken
  state.state = "idle"
  state.phase = "capturing_original"
  state.previousPhase = "idle"
  state.kind = kind
  state.vehicleId = vehicleId
  state.expectedTarget = vehicleId and {vehicleId = vehicleId} or nil
  state.error = nil
  state.invalidationReason = nil
  state.deadline = state.clock() + (tonumber(timeout) or state.defaultTimeout)
  state.operationDeadline = state.deadline
  refreshBusy(state)
  return true, state.token
end

local function transition(state, target, timeout)
  if not deriveBusy(state) and target ~= "idle" then return false, "not_busy" end
  if not (ALLOWED[state.state] and ALLOWED[state.state][target]) then
    return false, "invalid_transition:" .. tostring(state.state) .. "->" .. tostring(target)
  end
  state.state = target
  local phase = LEGACY_PHASE[target]
  if phase then setPhase(state, phase, timeout, "legacy:" .. target)
  elseif timeout == false then state.deadline = nil
  elseif timeout ~= nil then state.deadline = state.clock() + (tonumber(timeout) or state.defaultTimeout) end
  refreshBusy(state)
  return true
end

local function nextTarget(state, expected)
  state.targetGeneration = state.targetGeneration + 1
  state.expectedTarget = type(expected) == "table" and expected or nil
  return state.targetGeneration
end

local function invalidate(state, reason, options)
  options = type(options) == "table" and options or {}
  state.phaseGeneration = state.phaseGeneration + 1
  if options.target ~= false then state.targetGeneration = state.targetGeneration + 1 end
  if options.operation == true then
    state.operationGeneration = state.operationGeneration + 1
    state.operationToken = operationToken(state)
    state.token = state.operationToken
  end
  state.invalidationReason = reason or "invalidated"
  return state.token
end

local function captureContext(state, expectedTarget)
  return {
    operationId = state.operationId,
    operationToken = state.operationToken,
    operationGeneration = state.operationGeneration,
    phaseGeneration = state.phaseGeneration,
    targetGeneration = state.targetGeneration,
    expectedTarget = expectedTarget or state.expectedTarget,
  }
end

local function validateContinuation(state, context, observedTarget)
  if type(context) ~= "table" then return false, "missing_callback_context" end
  if context.operationId ~= state.operationId
    or context.operationToken ~= state.operationToken
    or context.operationGeneration ~= state.operationGeneration
    or context.phaseGeneration ~= state.phaseGeneration
    or context.targetGeneration ~= state.targetGeneration
  then
    state.staleCallbackCount = state.staleCallbackCount + 1
    return false, "stale_callback_ignored"
  end
  local expected = context.expectedTarget
  if type(expected) == "table" and type(observedTarget) == "table" then
    if expected.vehicleId and observedTarget.vehicleId ~= expected.vehicleId then return false, "wrong_vehicle_target" end
    if expected.modelKey and observedTarget.modelKey ~= expected.modelKey then return false, "wrong_vehicle_target" end
    if expected.configKey and observedTarget.configKey and expected.configKey ~= observedTarget.configKey then
      return false, "wrong_vehicle_target"
    end
  end
  return true
end

local function isCurrent(state, token, context)
  if not deriveBusy(state) or state.token == nil or state.token ~= token then return false end
  if context then return validateContinuation(state, context) end
  return true
end

local function phasePolicy(state)
  local definition = PHASES[state.phase] or {}
  return {
    pauseIndependent = definition.pauseIndependent == true,
    requiresSimulationProgress = definition.requiresSimulationProgress == true,
    unknown = definition.pauseIndependent ~= true and definition.requiresSimulationProgress ~= true,
  }
end

local function isExpired(state, now)
  return deriveBusy(state) and state.deadline ~= nil and (now or state.clock()) >= state.deadline
end

local function finish(state, terminalState, errorValue)
  terminalState = terminalState or "completed"
  if not TERMINAL[terminalState] then return false, "not_terminal" end
  state.state = terminalState
  setPhase(state, terminalState, false, "finished")
  state.error = errorValue
  state.deadline = nil
  state.operationDeadline = nil
  refreshBusy(state)
  return true
end

local function reset(state)
  if deriveBusy(state) then return false, "busy" end
  state.state = "idle"
  setPhase(state, "idle", false, "reset")
  state.kind = nil
  state.vehicleId = nil
  state.expectedTarget = nil
  state.deadline = nil
  state.operationDeadline = nil
  state.error = nil
  state.token = nil
  state.operationToken = nil
  return true
end

local function summary(state)
  return {
    operationId = state.operationId,
    operationToken = state.operationToken,
    operationGeneration = state.operationGeneration,
    phase = state.phase,
    previousPhase = state.previousPhase,
    phaseReason = state.phaseReason,
    phaseGeneration = state.phaseGeneration,
    targetGeneration = state.targetGeneration,
    busy = deriveBusy(state),
    deadline = state.deadline,
    staleCallbackCount = state.staleCallbackCount,
    invalidationReason = state.invalidationReason,
    policy = phasePolicy(state),
  }
end

M.create = create
M.begin = begin
M.transition = transition
M.setPhase = setPhase
M.nextTarget = nextTarget
M.invalidate = invalidate
M.captureContext = captureContext
M.validateContinuation = validateContinuation
M.isCurrent = isCurrent
M.phasePolicy = phasePolicy
M.deriveBusy = deriveBusy
M.isExpired = isExpired
M.finish = finish
M.reset = reset
M.summary = summary
M.allowedTransitions = ALLOWED
M.phases = PHASES

return M
