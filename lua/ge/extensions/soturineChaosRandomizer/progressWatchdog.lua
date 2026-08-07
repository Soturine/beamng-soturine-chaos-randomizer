local M = {}

local DEFAULTS = {
  warningAfter = 5,
  stalledAfter = 12,
  pauseDependencyWindow = 1,
}

local SEMANTIC_KINDS = {
  phase = true, binding = true, write = true, batch = true, reload = true,
  readback = true, safety = true, candidate_promoted = true, slot_terminal = true,
}

local function classification(kind, reason, explicit)
  if explicit == "semantic_progress" or explicit == "incidental_activity"
    or explicit == "callback_noise" or explicit == "diagnostic_only"
  then return explicit end
  local text = tostring(reason or "")
  if text:find("callback", 1, true) then return "callback_noise" end
  if kind == "diagnostic" then return "diagnostic_only" end
  return SEMANTIC_KINDS[kind] and "semantic_progress" or "incidental_activity"
end

local function create(now, options)
  options = type(options) == "table" and options or {}
  now = tonumber(now) or 0
  return {
    warningAfter = math.max(0.1, tonumber(options.warningAfter) or DEFAULTS.warningAfter),
    stalledAfter = math.max(0.2, tonumber(options.stalledAfter) or DEFAULTS.stalledAfter),
    pauseDependencyWindow = math.max(0.1, tonumber(options.pauseDependencyWindow) or DEFAULTS.pauseDependencyWindow),
    lastProgressAt = now,
    lastSemanticProgressAt = now,
    lastActivityAt = now,
    lastProgressReason = "operation_started",
    lastPhaseChangeAt = now,
    lastStageChangeAt = now,
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
    semanticProgressSequence = 0,
    activityCount = 0,
    callbackNoiseCount = 0,
    diagnosticOnlyCount = 0,
    duplicateSemanticCount = 0,
    lastSemanticKey = "operation_started",
    phaseStartedAt = now,
    phaseDeadline = options.phaseDeadline,
    operationDeadline = options.operationDeadline,
    ownedVehicleCount = 0,
    temporaryVehicleCount = 0,
    callbackCount = 0,
    frameBudgetOverruns = 0,
    status = "healthy",
  }
end

local function note(state, kind, reason, now, explicitClassification)
  now = tonumber(now) or state.lastActivityAt or 0
  local activityClass = classification(kind, reason, explicitClassification)
  state.lastActivityAt = now
  state.activityCount = state.activityCount + 1
  state.lastActivityClass = activityClass
  state.lastActivityReason = reason or kind or "activity"
  if activityClass == "callback_noise" then state.callbackNoiseCount = state.callbackNoiseCount + 1 end
  if activityClass == "diagnostic_only" then state.diagnosticOnlyCount = state.diagnosticOnlyCount + 1 end
  if activityClass ~= "semantic_progress" then return false, activityClass end
  local semanticKey = tostring(kind or "progress") .. ":" .. tostring(reason or "")
  if semanticKey == state.lastSemanticKey then
    state.duplicateSemanticCount = state.duplicateSemanticCount + 1
    return false, "incidental_activity"
  end
  state.lastSemanticKey = semanticKey
  state.lastSemanticProgressAt = now
  state.lastProgressAt = now
  state.lastProgressReason = reason or kind or "progress"
  state.progressCount = state.progressCount + 1
  state.semanticProgressSequence = state.semanticProgressSequence + 1
  state.warned = false
  state.stalled = false
  if kind == "phase" then
    state.lastPhaseChangeAt = now
    state.lastStageChangeAt = now
    state.phaseStartedAt = now
  elseif kind == "target" then state.lastTargetEvidenceAt = now
  elseif kind == "tree" then state.lastTreeChangeAt = now
  elseif kind == "write" then state.lastSuccessfulWriteAt = now end
  if state.paused and state.lastPauseChangeAt
    and now - state.lastPauseChangeAt <= state.pauseDependencyWindow
    and state.prePauseStalled
  then
    state.pauseDependentProgressDetected = true
  end
  return true, activityClass
end

local function setDeadlines(state, phaseDeadline, operationDeadline)
  if phaseDeadline ~= nil then state.phaseDeadline = tonumber(phaseDeadline) end
  if operationDeadline ~= nil then state.operationDeadline = tonumber(operationDeadline) end
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
  local age = math.max(0, now - (state.lastSemanticProgressAt or now))
  local deadlineState = state.operationDeadline and now >= state.operationDeadline and "operation_deadline"
    or state.phaseDeadline and now >= state.phaseDeadline and "phase_deadline" or nil
  state.warned = not state.waitingForSimulation and age >= state.warningAfter
  state.stalled = not state.waitingForSimulation and age >= state.stalledAfter
  if state.status ~= "aborting" and state.status ~= "cleaning" and state.status ~= "terminal" then
    state.status = state.stalled and "stalled" or state.warned and "slow" or "healthy"
  end
  return deadlineState or state.stalled and "stalled" or state.warned and "warning"
    or state.waitingForSimulation and "waiting_for_simulation_resume" or "progressing"
end

local function observeMetrics(state, values)
  values = type(values) == "table" and values or {}
  for _, key in ipairs({
    "ownedVehicleCount", "temporaryVehicleCount", "callbackCount", "frameBudgetOverruns",
  }) do
    if tonumber(values[key]) then state[key] = math.max(0, math.floor(tonumber(values[key]))) end
  end
  return true
end

local function setStatus(state, status)
  local allowed = {healthy = true, slow = true, stalled = true, aborting = true,
    cleaning = true, terminal = true}
  if not allowed[status] then return false end
  state.status = status
  return true
end

local function snapshot(state, now)
  now = tonumber(now) or state.lastProgressAt or 0
  return {
    lastProgressAt = state.lastProgressAt,
    lastSemanticProgressAt = state.lastSemanticProgressAt,
    lastActivityAt = state.lastActivityAt,
    lastActivityClass = state.lastActivityClass,
    lastActivityReason = state.lastActivityReason,
    lastProgressReason = state.lastProgressReason,
    lastPhaseChangeAt = state.lastPhaseChangeAt,
    lastStageChangeAt = state.lastStageChangeAt,
    lastTargetEvidenceAt = state.lastTargetEvidenceAt,
    lastTreeChangeAt = state.lastTreeChangeAt,
    lastSuccessfulWriteAt = state.lastSuccessfulWriteAt,
    progressAge = math.max(0, now - (state.lastSemanticProgressAt or now)),
    semanticProgressSequence = state.semanticProgressSequence,
    activityCount = state.activityCount,
    callbackNoiseCount = state.callbackNoiseCount,
    diagnosticOnlyCount = state.diagnosticOnlyCount,
    duplicateSemanticCount = state.duplicateSemanticCount,
    phaseStartedAt = state.phaseStartedAt,
    phaseDeadline = state.phaseDeadline,
    operationDeadline = state.operationDeadline,
    paused = state.paused,
    waitingForSimulation = state.waitingForSimulation,
    warned = state.warned,
    stalled = state.stalled,
    pauseDependentProgressDetected = state.pauseDependentProgressDetected,
    progressCount = state.progressCount,
    ownedVehicleCount = state.ownedVehicleCount,
    temporaryVehicleCount = state.temporaryVehicleCount,
    callbackCount = state.callbackCount,
    frameBudgetOverruns = state.frameBudgetOverruns,
    status = state.status,
  }
end

M.DEFAULTS = DEFAULTS
M.create = create
M.note = note
M.setDeadlines = setDeadlines
M.observePause = observePause
M.evaluate = evaluate
M.observeMetrics = observeMetrics
M.setStatus = setStatus
M.snapshot = snapshot

return M
