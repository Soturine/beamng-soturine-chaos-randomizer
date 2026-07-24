local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}
local MODES = {Destination = true, Route = true, Chase = true, Follow = true, Traffic = true}
local FINISH_ACTIONS = {stop = true, brake = true, keep = true, loop = true, disable = true}
local STUCK_ACTIONS = {none = true, replan = true, reset = true, respawn = true, dnf = true}

local function create(limit)
  return {entries = {}, order = {}, limit = tonumber(limit) or 32, diagnostics = {}, diagnosticLimit = 256}
end

local function log(state, code, details)
  state.diagnostics[#state.diagnostics + 1] = {time = os.time(), code = code, details = util.deepCopy(details)}
  while #state.diagnostics > state.diagnosticLimit do table.remove(state.diagnostics, 1) end
end

local function assign(state, handle, vehicleId, mode, options, now)
  if type(handle) ~= "string" or handle == "" or type(vehicleId) ~= "number" or vehicleId < 0 then
    return nil, "ai_managed_target_invalid"
  end
  if not MODES[mode] then return nil, "ai_mode_unsupported" end
  if not state.entries[handle] and #state.order >= state.limit then return nil, "ai_vehicle_limit" end
  if not state.entries[handle] then state.order[#state.order + 1] = handle end
  local entry = {
    handle = handle, vehicleId = vehicleId, mode = mode, options = util.deepCopy(options or {}),
    status = "scheduled", startAt = (now or 0) + math.max(0, tonumber(options and options.delay) or 0),
    targetGeneration = options and options.targetGeneration,
    arrivalRadius = util.clamp(tonumber(options and options.arrivalRadius) or 8, 1, 100),
    arrivalSpeed = util.clamp(tonumber(options and options.arrivalSpeed) or 1.5, 0, 20),
    timeout = util.clamp(tonumber(options and options.timeout) or 600, 10, 3600),
    assignedAt = now or 0, lastProgressAt = now or 0, lastDistance = nil,
    replanCount = 0, maxReplans = math.max(0, math.min(10, math.floor(tonumber(options and options.maxReplans) or 2))),
    stuckTimeout = util.clamp(tonumber(options and options.stuckTimeout) or 12, 3, 120),
    minimumProgress = util.clamp(tonumber(options and options.minimumProgress) or 1, 0.1, 50),
    minimumSpeed = util.clamp(tonumber(options and options.minimumSpeed) or 0.5, 0, 20),
    monitorStuck = options and options.recoveryWhenStuck == true,
    stuckAction = STUCK_ACTIONS[options and options.stuckAction] and options.stuckAction or "none",
    finishAction = FINISH_ACTIONS[options and options.finishAction] and options.finishAction
      or (options and options.loop == true and "loop" or "stop"),
    allowDamaged = not options or options.allowDamagedVehicles ~= false,
    stuckEvents = 0,
  }
  state.entries[handle] = entry
  log(state, "ai_assigned", {handle = handle, mode = mode})
  return entry
end

local function observe(state, handle, observation, now)
  local entry = state.entries[handle]
  if not entry or entry.status ~= "running" then return nil, "ai_entry_not_running" end
  observation = type(observation) == "table" and observation or {}
  now = tonumber(now) or entry.assignedAt
  if observation.vehicleMissing then return "stopped", "vehicle_missing" end
  if observation.targetMissing and (entry.mode == "Chase" or entry.mode == "Follow") then return "stopped", "ai_target_removed" end
  local distance = tonumber(observation.distance)
  local speed = tonumber(observation.speed)
  if util.isFinite(distance) then
    entry.distanceToDestination = math.max(0, distance)
    if not entry.lastDistance or entry.lastDistance - distance >= entry.minimumProgress then
      entry.lastProgressAt = now
    end
    entry.lastDistance = distance
  end
  if util.isFinite(speed) then
    entry.speed = math.max(0, speed)
    if speed >= entry.minimumSpeed then entry.lastProgressAt = now end
  end
  if util.isFinite(tonumber(observation.routeProgress)) then
    local progress = util.clamp(tonumber(observation.routeProgress), 0, 1)
    if not entry.routeProgress or progress > entry.routeProgress then entry.lastProgressAt = now end
    entry.routeProgress = progress
  end
  if now - (entry.startedAt or entry.assignedAt) >= entry.timeout then return "timeout", "ai_timeout" end
  local finalPoint = observation.finalPointReached ~= false
  if distance and distance <= entry.arrivalRadius and finalPoint
    and (speed == nil or speed <= entry.arrivalSpeed or observation.aiStopped == true)
  then
    entry.arrivedAt = now
    return "arrived", "arrival_confirmed"
  end
  if entry.monitorStuck and now - (entry.lastProgressAt or now) >= entry.stuckTimeout
    and (speed == nil or speed < entry.minimumSpeed)
  then
    entry.stuckEvents = (entry.stuckEvents or 0) + 1
    entry.lastProgressAt = now
    return "stuck", entry.stuckAction
  end
  return "running"
end

local function requestReplan(state, handle)
  local entry = state.entries[handle]
  if not entry then return false, "ai_entry_missing" end
  if entry.replanCount >= entry.maxReplans then return false, "ai_replan_limit" end
  entry.replanCount = entry.replanCount + 1
  return true, entry.replanCount
end

local function setStatus(state, handle, status, reason)
  local entry = state.entries[handle]
  if not entry then return false end
  entry.status, entry.reason = status, reason
  log(state, "ai_" .. status, {handle = handle, reason = reason})
  return true
end

local function controlAll(state, action, now, controller)
  if action ~= "pause" and action ~= "resume" and action ~= "stop" and action ~= "reset" then
    return 0, "ai_control_invalid"
  end
  local affected = 0
  for _, handle in ipairs(state.order) do
    local entry = state.entries[handle]
    if entry then
      if action == "pause" and entry.status == "running" then
        if type(controller) == "function" then controller(entry.vehicleId, false) end
        setStatus(state, handle, "paused", "user_pause")
        affected = affected + 1
      elseif action == "resume" and entry.status == "paused" then
        entry.startAt = tonumber(now) or 0
        setStatus(state, handle, "scheduled", "user_resume")
        affected = affected + 1
      elseif action == "stop" or action == "reset" then
        if type(controller) == "function" then controller(entry.vehicleId, action == "reset") end
        setStatus(state, handle, "stopped", "user_" .. action)
        affected = affected + 1
      end
    end
  end
  return affected
end

local function list(state)
  local result = {}
  for _, handle in ipairs(state.order) do if state.entries[handle] then result[#result + 1] = util.deepCopy(state.entries[handle]) end end
  return result
end

M.create = create
M.assign = assign
M.setStatus = setStatus
M.controlAll = controlAll
M.list = list
M.log = log
M.observe = observe
M.requestReplan = requestReplan
M.MODES = MODES

return M
