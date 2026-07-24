local configVerification = require("ge/extensions/soturineChaosRandomizer/configVerification")
local util = require("ge/extensions/soturineChaosRandomizer/util")
local vehicleStabilizer = require("ge/extensions/soturineChaosRandomizer/vehicleStabilizer")

local M = {}

local LIMITS = {candidates = 16, events = 32}

local function boundedAppend(list, value, limit)
  list[#list + 1] = value
  while #list > limit do table.remove(list, 1) end
end

local function scalar(value)
  if value == nil then return "~" end
  if type(value) == "boolean" then return value and "1" or "0" end
  return tostring(value)
end

local function stableTable(value, depth)
  depth = depth or 0
  if type(value) ~= "table" then return scalar(value) end
  if depth > 12 then return "<depth>" end
  local out = {"{"}
  for _, key in ipairs(util.sortedKeys(value)) do
    out[#out + 1] = scalar(key)
    out[#out + 1] = "="
    out[#out + 1] = stableTable(value[key], depth + 1)
    out[#out + 1] = ";"
  end
  out[#out + 1] = "}"
  return table.concat(out)
end

local function stateFingerprint(state)
  return table.concat({
    scalar(state.modelKey),
    scalar(configVerification.stableKey(state.configKey or (state.configIdentity and state.configIdentity.path))),
    stableTable(state.parts or {}),
  }, "|")
end

local function create(options)
  options = type(options) == "table" and options or {}
  local now = tonumber(options.startedAt) or 0
  return {
    token = options.token,
    phase = options.phase,
    expectedModelKey = options.modelKey,
    expectedConfigKey = options.configKey,
    expectedConfigIdentity = util.deepCopy(options.configIdentity),
    expectedParts = util.deepCopy(options.parts or {}),
    originalVehicleId = options.originalVehicleId,
    returnedVehicleId = options.returnedVehicleId,
    currentCandidateId = options.returnedVehicleId,
    startedAt = now,
    deadline = now + (tonumber(options.timeout) or 25),
    candidates = {},
    events = {},
    candidateSeen = {},
    candidateDrops = 0,
    eventDrops = 0,
    destroyed = {},
    rejected = {},
    suspectSwitchId = nil,
    lastState = nil,
    status = "vehicle_target_stabilizing",
    stabilizer = vehicleStabilizer.create(options.stabilizer),
  }
end

local function addCandidate(tracker, vehicleId, source, details)
  if type(vehicleId) ~= "number" or vehicleId < 0 then return false end
  local key = tostring(vehicleId)
  if not tracker.candidateSeen[key] then
    if #tracker.candidates >= LIMITS.candidates then
      tracker.candidateDrops = tracker.candidateDrops + 1
      return false
    end
    tracker.candidateSeen[key] = true
    tracker.candidates[#tracker.candidates + 1] = {
      vehicleId = vehicleId,
      source = source,
      details = util.deepCopy(details),
    }
  end
  tracker.currentCandidateId = vehicleId
  return true
end

local function addEvent(tracker, kind, details)
  if #tracker.events >= LIMITS.events then tracker.eventDrops = tracker.eventDrops + 1 end
  boundedAppend(tracker.events, {kind = kind, details = util.deepCopy(details)}, LIMITS.events)
end

local function bindReturned(tracker, vehicleId, strategy)
  tracker.returnedVehicleId = vehicleId
  addCandidate(tracker, vehicleId, "replace_return", {strategy = strategy})
  addEvent(tracker, "replace_return", {vehicleId = vehicleId, strategy = strategy})
end

local function onSpawned(tracker, vehicleId)
  addCandidate(tracker, vehicleId, "spawn_callback")
  addEvent(tracker, "spawn", {vehicleId = vehicleId})
  return true, "candidate_recorded"
end

local function onSwitched(tracker, oldId, newId, player, replaceWriteInFlight)
  if player ~= nil and player ~= 0 then
    addEvent(tracker, "auxiliary_switch", {oldId = oldId, newId = newId, player = player})
    return true, "auxiliary_player_ignored"
  end
  local priorCandidateId = tracker.currentCandidateId
  addCandidate(tracker, newId, replaceWriteInFlight and "switch_during_replace" or "player_switch")
  addEvent(tracker, "switch", {oldId = oldId, newId = newId, player = player})
  if not replaceWriteInFlight and newId ~= priorCandidateId and newId ~= tracker.returnedVehicleId then
    tracker.suspectSwitchId = newId
  end
  vehicleStabilizer.reset(tracker.stabilizer, "vehicle_switch")
  return true, "switch_candidate_recorded"
end

local function onDestroyed(tracker, vehicleId)
  tracker.destroyed[tostring(vehicleId)] = true
  addEvent(tracker, "destroyed", {vehicleId = vehicleId})
  if tracker.currentCandidateId == vehicleId then
    tracker.currentCandidateId = nil
    vehicleStabilizer.reset(tracker.stabilizer, "candidate_destroyed")
  end
  return true
end

local function verifyExpected(tracker, state)
  if tracker.expectedModelKey and state.modelKey ~= tracker.expectedModelKey then
    return false, "model_mismatch"
  end
  if tracker.expectedConfigIdentity then
    local ok, reason, details = configVerification.verify(tracker.expectedConfigIdentity, state)
    if not ok then return false, reason or "config_mismatch", details end
  elseif tracker.expectedConfigKey then
    local expected = configVerification.expectation({
      modelKey = tracker.expectedModelKey,
      key = configVerification.stableKey(tracker.expectedConfigKey),
      path = tracker.expectedConfigKey,
    })
    local ok, reason, details = configVerification.verify(expected, state)
    if not ok then return false, reason or "config_mismatch", details end
  end
  for path, candidate in pairs(tracker.expectedParts or {}) do
    if type(state.parts) ~= "table" or state.parts[path] ~= candidate then
      return false, "parts_state_mismatch:" .. tostring(path)
    end
  end
  return true
end

local function observe(tracker, token, state, now)
  now = tonumber(now) or 0
  if token ~= tracker.token then return "failed", "stale_operation_token" end
  if now >= tracker.deadline then
    tracker.status = "vehicle_target_timeout"
    return "failed", "vehicle_target_timeout"
  end
  if type(state) ~= "table" or type(state.vehicleId) ~= "number" then
    tracker.status = "vehicle_target_stabilizing"
    return "waiting", "vehicle_target_unavailable"
  end
  addCandidate(tracker, state.vehicleId, "player_poll", {modelKey = state.modelKey, configKey = state.configKey})
  local expected, reason, verificationDetails = verifyExpected(tracker, state)
  if not expected then
    tracker.rejected[tostring(state.vehicleId)] = reason
    if tracker.suspectSwitchId == state.vehicleId and reason == "model_mismatch" then
      tracker.status = "external_vehicle_switch"
      return "cancelled", "external_vehicle_switch", {vehicleId = state.vehicleId, reason = reason}
    end
    vehicleStabilizer.reset(tracker.stabilizer, reason)
    tracker.status = "vehicle_target_stabilizing"
    return "waiting", reason, verificationDetails
  end
  tracker.suspectSwitchId = nil
  tracker.currentCandidateId = state.vehicleId
  tracker.lastState = util.deepCopy(state)
  local stable, stableReason = vehicleStabilizer.observe(
    tracker.stabilizer, state.vehicleId, stateFingerprint(state), type(state.parts) == "table"
  )
  tracker.status = stableReason
  if stable then
    return "stable", stableReason, {
      vehicleId = state.vehicleId,
      state = util.deepCopy(state),
      verification = verificationDetails,
    }
  end
  return "waiting", stableReason
end

local function summary(tracker, now)
  local metrics = vehicleStabilizer.metrics(tracker.stabilizer)
  metrics.status = tracker.status
  metrics.candidateCount = #tracker.candidates
  metrics.candidateDrops = tracker.candidateDrops
  metrics.switchEventCount = #tracker.events
  metrics.eventDrops = tracker.eventDrops
  metrics.stabilizationMs = math.max(0, ((tonumber(now) or tracker.startedAt) - tracker.startedAt) * 1000)
  metrics.currentCandidateId = tracker.currentCandidateId
  metrics.returnedVehicleId = tracker.returnedVehicleId
  return metrics
end

M.LIMITS = LIMITS
M.create = create
M.addCandidate = addCandidate
M.addEvent = addEvent
M.bindReturned = bindReturned
M.onSpawned = onSpawned
M.onSwitched = onSwitched
M.onDestroyed = onDestroyed
M.observe = observe
M.verifyExpected = verifyExpected
M.stateFingerprint = stateFingerprint
M.summary = summary

return M
