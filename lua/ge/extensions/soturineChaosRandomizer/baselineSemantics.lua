local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local function create(originalPlayer)
  return {
    originalPlayerVehicle = util.deepCopy(originalPlayer),
    selectedRandomCandidate = nil,
    cleanCandidateBaseline = nil,
    lastAcceptedGeneratedResult = nil,
    currentMutationAttempt = nil,
    acceptedSequence = 0,
  }
end

local function setSelectedCandidate(state, snapshot)
  state.selectedRandomCandidate = util.deepCopy(snapshot)
  return state.selectedRandomCandidate
end

local function setCleanCandidate(state, snapshot)
  state.cleanCandidateBaseline = util.deepCopy(snapshot)
  if state.selectedRandomCandidate == nil then setSelectedCandidate(state, snapshot) end
  return state.cleanCandidateBaseline
end

local function beginAttempt(state, snapshot, details)
  state.currentMutationAttempt = {
    snapshot = util.deepCopy(snapshot), details = util.deepCopy(details or {}),
  }
  return state.currentMutationAttempt
end

local function acceptGenerated(state, snapshot, details)
  if type(snapshot) ~= "table" then return false, "accepted_snapshot_missing" end
  state.acceptedSequence = state.acceptedSequence + 1
  state.lastAcceptedGeneratedResult = util.deepCopy(snapshot)
  state.lastAcceptedGeneratedResult.baselineMetadata = util.shallowMerge(
    state.lastAcceptedGeneratedResult.baselineMetadata or {}, {
      type = "last_accepted_generated_result",
      acceptedSequence = state.acceptedSequence,
      details = util.deepCopy(details or {}),
    }
  )
  state.currentMutationAttempt = nil
  return true, state.lastAcceptedGeneratedResult
end

local function repairSource(state)
  if type(state.lastAcceptedGeneratedResult) == "table" then
    return util.deepCopy(state.lastAcceptedGeneratedResult), "last_accepted_generated_result"
  end
  if type(state.cleanCandidateBaseline) == "table" then
    return util.deepCopy(state.cleanCandidateBaseline), "clean_candidate_baseline"
  end
  if type(state.selectedRandomCandidate) == "table" then
    return util.deepCopy(state.selectedRandomCandidate), "selected_random_candidate"
  end
  if type(state.originalPlayerVehicle) == "table" then
    return util.deepCopy(state.originalPlayerVehicle), "original_player_vehicle"
  end
  return nil, "baseline_unavailable"
end

local function recoveryContext(state, currentTarget)
  return {
    currentTargetSnapshot = util.deepCopy(currentTarget),
    lastAcceptedGeneratedSnapshot = util.deepCopy(state.lastAcceptedGeneratedResult),
    candidateBaseSnapshot = util.deepCopy(state.cleanCandidateBaseline),
    selectedCandidateSnapshot = util.deepCopy(state.selectedRandomCandidate),
    originalSnapshot = util.deepCopy(state.originalPlayerVehicle),
  }
end

local function summary(state)
  state = type(state) == "table" and state or {}
  local function identity(snapshot)
    return type(snapshot) == "table" and {
      modelKey = snapshot.modelKey, vehicleId = snapshot.vehicleId,
      selectedConfiguration = snapshot.selectedConfiguration,
    } or nil
  end
  return {
    originalPlayerVehicle = identity(state.originalPlayerVehicle),
    selectedRandomCandidate = identity(state.selectedRandomCandidate),
    cleanCandidateBaseline = identity(state.cleanCandidateBaseline),
    lastAcceptedGeneratedResult = identity(state.lastAcceptedGeneratedResult),
    currentMutationAttempt = state.currentMutationAttempt and identity(state.currentMutationAttempt.snapshot) or nil,
    acceptedSequence = state.acceptedSequence,
  }
end

M.create = create
M.setSelectedCandidate = setSelectedCandidate
M.setCleanCandidate = setCleanCandidate
M.beginAttempt = beginAttempt
M.acceptGenerated = acceptGenerated
M.repairSource = repairSource
M.recoveryContext = recoveryContext
M.summary = summary

return M
