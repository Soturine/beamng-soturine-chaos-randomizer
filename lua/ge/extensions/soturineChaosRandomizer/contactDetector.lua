local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local function create(options)
  options = type(options) == "table" and options or {}
  return {
    distanceThreshold = util.clamp(tonumber(options.distanceThreshold) or 3.5, 0.5, 20),
    relativeSpeedThreshold = util.clamp(tonumber(options.relativeSpeedThreshold) or 1.5, 0, 50),
    cooldown = util.clamp(tonumber(options.cooldown) or 1, 0.1, 30),
    lastContacts = {}, sequence = 0,
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
  if not collisionSignal and not (closeEnough and speedEnough) then
    return nil, "contact_unconfirmed"
  end
  local lastAt = state.lastContacts[key]
  if lastAt and now - lastAt < state.cooldown then return nil, "contact_cooldown" end
  state.lastContacts[key] = now
  state.sequence = state.sequence + 1
  return {
    sequence = state.sequence, leftVehicleId = left, rightVehicleId = right,
    at = now, distance = distance, relativeSpeed = relativeSpeed,
    evidence = collisionSignal and "collision_signal" or "proximity_and_relative_speed",
  }
end

M.create = create
M.observe = observe
M.pairKey = pairKey

return M
