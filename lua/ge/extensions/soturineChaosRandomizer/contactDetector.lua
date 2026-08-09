local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local function create(options)
  options = type(options) == "table" and options or {}
  return {
    distanceThreshold = util.clamp(tonumber(options.distanceThreshold) or 3.5, 0.5, 20),
    relativeSpeedThreshold = util.clamp(tonumber(options.relativeSpeedThreshold) or 1.5, 0, 50),
    cooldown = util.clamp(tonumber(options.cooldown) or 1, 0.1, 30),
    lastContacts = {}, activeContacts = {}, sequence = 0,
  }
end

local function pairKey(leftId, rightId)
  local left, right = tonumber(leftId), tonumber(rightId)
  if not left or not right or left == right then return nil end
  if left > right then left, right = right, left end
  return tostring(left) .. ":" .. tostring(right), left, right
end

local function observe(state, evidence, now)
  evidence = type(evidence) == "table" and evidence or {}
  now = tonumber(now) or 0
  local key, left, right = pairKey(evidence.leftVehicleId, evidence.rightVehicleId)
  if not key then return nil, "contact_pair_invalid" end
  local distance = tonumber(evidence.distance)
  local relativeSpeed = tonumber(evidence.relativeSpeed)
  local collisionSignal = evidence.collisionSignal == true
  local closeEnough = util.isFinite(distance) and distance <= state.distanceThreshold
  local speedEnough = util.isFinite(relativeSpeed)
    and math.abs(relativeSpeed) >= state.relativeSpeedThreshold
  local confirmed = collisionSignal or closeEnough and speedEnough
  local active = state.activeContacts[key]
  if evidence.ended == true or evidence.contactActive == false or not confirmed then
    if active then
      state.activeContacts[key] = nil
      state.lastContacts[key] = now
      return {
        sequence = active.sequence, state = "ended",
        leftVehicleId = left, rightVehicleId = right,
        at = now, startedAt = active.startedAt,
        duration = math.max(0, now - active.startedAt),
        samples = active.samples,
        distance = distance, relativeSpeed = relativeSpeed,
        evidence = evidence.ended == true and "explicit_end" or "contact_evidence_cleared",
      }
    end
    return nil, "contact_unconfirmed"
  end
  if active then
    active.lastAt = now
    active.samples = active.samples + 1
    active.distance = distance
    active.relativeSpeed = relativeSpeed
    active.severity = tonumber(evidence.severity)
    active.impulse = tonumber(evidence.impulse)
    return {
      sequence = active.sequence, state = "persisted",
      leftVehicleId = left, rightVehicleId = right,
      at = now, startedAt = active.startedAt,
      duration = math.max(0, now - active.startedAt),
      samples = active.samples,
      distance = distance, relativeSpeed = relativeSpeed,
      severity = active.severity, impulse = active.impulse,
      evidence = collisionSignal and "collision_signal" or "proximity_and_relative_speed",
    }
  end
  local lastEndedAt = state.lastContacts[key]
  if lastEndedAt and now - lastEndedAt < state.cooldown then return nil, "contact_cooldown" end
  state.sequence = state.sequence + 1
  active = {
    sequence = state.sequence, startedAt = now, lastAt = now, samples = 1,
    distance = distance, relativeSpeed = relativeSpeed,
    severity = tonumber(evidence.severity), impulse = tonumber(evidence.impulse),
  }
  state.activeContacts[key] = active
  return {
    sequence = state.sequence, state = "started",
    leftVehicleId = left, rightVehicleId = right,
    at = now, startedAt = now, duration = 0, samples = 1,
    distance = distance, relativeSpeed = relativeSpeed,
    severity = active.severity, impulse = active.impulse,
    evidence = collisionSignal and "collision_signal" or "proximity_and_relative_speed",
  }
end

M.create = create
M.observe = observe
M.pairKey = pairKey

return M
