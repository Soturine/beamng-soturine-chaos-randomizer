local M = {}

local OUTCOMES = {
  COMPLETED = true,
  COMPLETED_WITH_SKIPS = true,
  COMPLETED_WITH_WARNING = true,
  PARTIAL_APPLIED = true,
  FAILED_TIMEOUT = true,
  FAILED_STALLED = true,
  FAILED_RUNTIME_INTEGRITY = true,
  FAILED_NO_CHANGE = true,
  FAILED_ROLLED_BACK = true,
  CANCELLED = true,
}

local CONFIDENCE = {
  CONFIRMED = true,
  UNCERTAIN = true,
  NOT_APPLICABLE = true,
  UNSUPPORTED_TELEMETRY = true,
}

local function contains(value, fragment)
  return tostring(value or ""):lower():find(fragment, 1, true) ~= nil
end

local function hasWarnings(details)
  return type(details.warnings) == "table" and #details.warnings > 0
    or details.warning ~= nil
    or details.cardinalityWarning ~= nil
    or details.cardinalityCleanupWarning ~= nil
    or details.persistenceWarning ~= nil
    or details.criticalRepairSucceeded == true
end

local function confidence(details)
  if CONFIDENCE[details.confidence] then return details.confidence end
  if details.telemetrySupported == false or details.unsupportedTelemetry == true then
    return "UNSUPPORTED_TELEMETRY"
  end
  if details.notApplicable == true
    or details.safety and details.safety.status == "not_applicable"
  then return "NOT_APPLICABLE" end
  if details.uncertain == true or details.metadataUncertain == true
    or details.energyGuardUncertain == true or details.engineFluidUncertain == true
    or details.safety and (details.safety.status == "uncertain"
      or details.safety.classification == "UNKNOWN_OR_PENDING")
  then return "UNCERTAIN" end
  return "CONFIRMED"
end

local function classify(success, code, details, terminalState)
  details = type(details) == "table" and details or {}
  if OUTCOMES[details.outcome] then return details.outcome, confidence(details) end
  local codeText = tostring(code or "")
  local outcome
  if terminalState == "cancelled" or contains(codeText, "cancel") then
    outcome = "CANCELLED"
  elseif details.rollback == "completed" then
    outcome = "FAILED_ROLLED_BACK"
  elseif contains(codeText, "watchdog") or contains(codeText, "stalled")
    or contains(codeText, "no_progress")
  then
    outcome = "FAILED_STALLED"
  elseif contains(codeText, "timeout") or contains(codeText, "deadline") then
    outcome = "FAILED_TIMEOUT"
  elseif details.runtimeIntegrityFailure == true or details.cardinalityViolation == true
    or contains(codeText, "runtime_integrity") or contains(codeText, "cardinality_violation")
  then
    outcome = "FAILED_RUNTIME_INTEGRITY"
  elseif success == true then
    if details.partialApplied == true or terminalState == "partial" and details.appliedIncomplete == true then
      outcome = "PARTIAL_APPLIED"
    elseif (tonumber(details.skippedCount) or 0) > 0
      or type(details.skips) == "table" and #details.skips > 0
    then
      outcome = "COMPLETED_WITH_SKIPS"
    elseif hasWarnings(details) or confidence(details) ~= "CONFIRMED"
      or terminalState == "partial" or details.nonFatalPartial == true
    then
      outcome = "COMPLETED_WITH_WARNING"
    else
      outcome = "COMPLETED"
    end
  else
    outcome = "FAILED_NO_CHANGE"
  end
  return outcome, confidence(details)
end

local function failureKind(outcome)
  if outcome == "FAILED_TIMEOUT" then return "TIMEOUT" end
  if outcome == "FAILED_STALLED" then return "STALLED" end
  if outcome == "FAILED_RUNTIME_INTEGRITY" then return "RUNTIME_INTEGRITY" end
  if outcome == "FAILED_ROLLED_BACK" then return "ROLLED_BACK" end
  if outcome == "FAILED_NO_CHANGE" then return "NO_CHANGE" end
  if outcome == "CANCELLED" then return "CANCELLED" end
  return nil
end

local function axes(success, code, details, terminalState)
  details = type(details) == "table" and details or {}
  local outcome, confidenceValue = classify(success, code, details, terminalState)
  local appliedState = "NOT_APPLIED"
  if details.rollback == "completed" or outcome == "FAILED_ROLLED_BACK" then
    appliedState = "ROLLED_BACK"
  elseif outcome == "PARTIAL_APPLIED" then
    appliedState = "PARTIALLY_APPLIED"
  elseif success == true then
    appliedState = "APPLIED"
  end
  return {
    terminalOutcome = outcome,
    appliedState = appliedState,
    verificationConfidence = confidenceValue,
    failureKind = failureKind(outcome),
    skippedCount = math.max(0, tonumber(details.skippedCount) or 0),
  }
end

local function freeze(state, outcome, confidenceValue)
  if type(state) ~= "table" then return false, "outcome_state_missing" end
  if state.terminal == true then
    return state.outcome == outcome and state.confidence == confidenceValue,
      "terminal_outcome_immutable"
  end
  if not OUTCOMES[outcome] then return false, "outcome_invalid" end
  if not CONFIDENCE[confidenceValue] then return false, "outcome_confidence_invalid" end
  state.outcome = outcome
  state.confidence = confidenceValue
  state.terminal = true
  return true
end

local function legacy(outcome)
  if outcome == "COMPLETED" then return "success" end
  if outcome == "COMPLETED_WITH_SKIPS" or outcome == "COMPLETED_WITH_WARNING" then
    return "success_with_warning"
  end
  if outcome == "PARTIAL_APPLIED" then return "partial_success" end
  if outcome == "FAILED_ROLLED_BACK" then return "full_rollback" end
  if outcome == "CANCELLED" then return "cancelled" end
  return "failed"
end

M.OUTCOMES = OUTCOMES
M.CONFIDENCE = CONFIDENCE
M.classify = classify
M.axes = axes
M.freeze = freeze
M.legacy = legacy

return M
