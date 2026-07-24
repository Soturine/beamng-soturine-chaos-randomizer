local M = {}

local DEFAULTS = {
  warningAfter = 5,
  stalledAfter = 12,
  pauseDependencyWindow = 1,
}

local function create(now, options)
  options = type(options) == "table" and options or {}
  now = tonumber(now) or 0
  return {
    warningAfter = math.max(0.1, tonumber(options.warningAfter) or DEFAULTS.warningAfter),
    stalledAfter = math.max(0.2, tonumber(options.stalledAfter) or DEFAULTS.stalledAfter),
    pauseDependencyWindow = math.max(0.1, tonumber(options.pauseDependencyWindow) or DEFAULTS.pauseDependencyWindow),
    lastProgressAt = now,
    lastProgressReason = "operation_started",
    lastPhaseChangeAt = now,
    lastTargetEvidenceAt = nil,
    lastTreeChangeAt = nil,
    lastSuccessfulWriteAt = nil,
    lastPauseChangeAt = nil,
    paused = false,
    warned = false,
    stalled = false,
    waitingForSimulation = false,
    pauseDependentProgressDetected = false,
    progressCount = 0,
  }
end

local function note(state, kind, reason, now)
  now = tonumber(now) or state.lastProgressAt or 0
  state.lastProgressAt = now
  state.lastProgressReason = reason or kind or "progress"
  state.progressCount = state.progressCount + 1
  state.warned = false
  state.stalled = false
  if kind == "phase" then state.lastPhaseChangeAt = now
  elseif kind == "target" then state.lastTargetEvidenceAt = now
  elseif kind == "tree" then state.lastTreeChangeAt = now
  elseif kind == "write" then state.lastSuccessfulWriteAt = now end
  if state.paused and state.lastPauseChangeAt
    and now - state.lastPauseChangeAt <= state.pauseDependencyWindow
    and state.prePauseStalled
  then
    state.pauseDependentProgressDetected = true
  end
  return true
end

local function observePause(state, paused, now)
  if type(paused) ~= "boolean" then return false end
  now = tonumber(now) or state.lastProgressAt or 0
  if state.paused ~= paused then
    state.prePauseStalled = state.stalled or state.warned
    state.paused = paused
    state.lastPauseChangeAt = now
    return true
  end
  return false
end

local function evaluate(state, now, waitingForSimulation)
  now = tonumber(now) or state.lastProgressAt or 0
  state.waitingForSimulation = waitingForSimulation == true
  local age = math.max(0, now - (state.lastProgressAt or now))
  state.warned = not state.waitingForSimulation and age >= state.warningAfter
  state.stalled = not state.waitingForSimulation and age >= state.stalledAfter
  return state.stalled and "stalled" or state.warned and "warning"
    or state.waitingForSimulation and "waiting_for_simulation_resume" or "progressing"
end

local function snapshot(state, now)
  now = tonumber(now) or state.lastProgressAt or 0
  return {
    lastProgressAt = state.lastProgressAt,
    lastProgressReason = state.lastProgressReason,
    lastPhaseChangeAt = state.lastPhaseChangeAt,
    lastTargetEvidenceAt = state.lastTargetEvidenceAt,
    lastTreeChangeAt = state.lastTreeChangeAt,
    lastSuccessfulWriteAt = state.lastSuccessfulWriteAt,
    progressAge = math.max(0, now - (state.lastProgressAt or now)),
    paused = state.paused,
    waitingForSimulation = state.waitingForSimulation,
    warned = state.warned,
    stalled = state.stalled,
    pauseDependentProgressDetected = state.pauseDependentProgressDetected,
    progressCount = state.progressCount,
  }
end

M.DEFAULTS = DEFAULTS
M.create = create
M.note = note
M.observePause = observePause
M.evaluate = evaluate
M.snapshot = snapshot

return M
