local M = {}

local function create(limits, startedAt)
  return {
    limits = limits,
    startedAt = startedAt,
    coherentScans = 0,
    noProgressPasses = 0,
    previousSignature = nil,
    previousDiscovered = 0,
    converged = false,
    limitReason = nil,
  }
end

local function observe(state, observation)
  observation = observation or {}
  local sameTree = state.previousSignature ~= nil and state.previousSignature == observation.signature
  local noNew = (tonumber(observation.discovered) or 0) <= (state.previousDiscovered or 0)
  local quiet = noNew and (tonumber(observation.pending) or 0) == 0
    and (tonumber(observation.newDescendants) or 0) == 0
    and (tonumber(observation.pendingRetries) or 0) == 0
    and (tonumber(observation.changesApplied) or 0) == 0
  if quiet then
    state.coherentScans = sameTree and state.coherentScans + 1 or 1
  else
    state.coherentScans = 0
  end
  if quiet then state.noProgressPasses = state.noProgressPasses + 1 else state.noProgressPasses = 0 end
  state.previousSignature = observation.signature
  state.previousDiscovered = math.max(state.previousDiscovered or 0, tonumber(observation.discovered) or 0)
  state.converged = state.coherentScans >= state.limits.coherentScansRequired
  return state.converged, state.converged and "tree_converged" or "tree_not_converged"
end

local function metrics(state)
  return {
    coherentScans = state.coherentScans,
    noProgressPasses = state.noProgressPasses,
    discoveredSlots = state.previousDiscovered,
    converged = state.converged,
    limitReason = state.limitReason,
  }
end

M.create = create
M.observe = observe
M.metrics = metrics

return M
