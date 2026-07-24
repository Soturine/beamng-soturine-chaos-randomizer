local M = {}

local DEFAULTS = {
  minimumFrames = 5,
  minimumScans = 2,
  pollInterval = 0.05,
  persistentTreeScans = 2,
}

local function create(options)
  options = type(options) == "table" and options or {}
  return {
    minimumFrames = math.max(1, tonumber(options.minimumFrames) or DEFAULTS.minimumFrames),
    minimumScans = math.max(1, tonumber(options.minimumScans) or DEFAULTS.minimumScans),
    pollInterval = math.max(0, tonumber(options.pollInterval) or DEFAULTS.pollInterval),
    persistentTreeScans = math.max(2, tonumber(options.persistentTreeScans) or DEFAULTS.persistentTreeScans),
    lastPollAt = nil,
    vehicleId = nil,
    fingerprint = nil,
    stableFrames = 0,
    stableScans = 0,
    resets = 0,
    treeIssueFingerprint = nil,
    treeIssueScans = 0,
  }
end

local function shouldPoll(state, now)
  now = tonumber(now) or 0
  if state.lastPollAt == nil or now - state.lastPollAt >= state.pollInterval then
    state.lastPollAt = now
    return true
  end
  return false
end

local function reset(state, reason)
  state.vehicleId = nil
  state.fingerprint = nil
  state.stableFrames = 0
  state.stableScans = 0
  state.treeIssueFingerprint = nil
  state.treeIssueScans = 0
  state.resets = state.resets + 1
  state.lastResetReason = reason
end

local function observe(state, vehicleId, fingerprint, scanned)
  if vehicleId == nil or type(fingerprint) ~= "string" or fingerprint == "" then
    reset(state, "incomplete_observation")
    return false, "vehicle_target_stabilizing"
  end
  if state.vehicleId ~= vehicleId or state.fingerprint ~= fingerprint then
    state.vehicleId = vehicleId
    state.fingerprint = fingerprint
    state.stableFrames = 1
    state.stableScans = scanned and 1 or 0
    state.treeIssueFingerprint = nil
    state.treeIssueScans = 0
    state.resets = state.resets + 1
  else
    state.stableFrames = state.stableFrames + 1
    if scanned then state.stableScans = state.stableScans + 1 end
  end
  if state.stableFrames >= state.minimumFrames and state.stableScans >= state.minimumScans then
    return true, "vehicle_target_stable"
  end
  return false, "vehicle_target_stabilizing"
end

local function observeTreeIssue(state, issueFingerprint)
  if type(issueFingerprint) ~= "string" or issueFingerprint == "" then
    state.treeIssueFingerprint = nil
    state.treeIssueScans = 0
    return false, "tree_coherent"
  end
  if state.treeIssueFingerprint == issueFingerprint then
    state.treeIssueScans = state.treeIssueScans + 1
  else
    state.treeIssueFingerprint = issueFingerprint
    state.treeIssueScans = 1
  end
  if state.treeIssueScans >= state.persistentTreeScans then
    return true, "tree_issue_persistent"
  end
  return false, "tree_issue_transient"
end

local function metrics(state)
  return {
    stabilizationFrames = state.stableFrames,
    stabilizationScans = state.stableScans,
    stabilizationResets = state.resets,
    persistentTreeScans = state.treeIssueScans,
  }
end

M.DEFAULTS = DEFAULTS
M.create = create
M.shouldPoll = shouldPoll
M.reset = reset
M.observe = observe
M.observeTreeIssue = observeTreeIssue
M.metrics = metrics

return M
