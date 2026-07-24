local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local MODES = {Destination = true, Route = true, Chase = true, Follow = true, Traffic = true}
local SPEED_MODES = {set = true, limit = true}

local function quote(value) return string.format("%q", tostring(value or "")) end

local function object(vehicleId)
  if type(getObjectByID) ~= "function" then return nil, "vehicle_lookup_unavailable" end
  local ok, result = pcall(getObjectByID, vehicleId)
  if not ok or result == nil then return nil, "vehicle_missing" end
  return result
end

local function queue(vehicleId, command)
  local vehicle, reason = object(vehicleId)
  if not vehicle then return false, reason end
  local readable, method = pcall(function() return vehicle.queueLuaCommand end)
  if not readable or type(method) ~= "function" then return false, "vehicle_lua_queue_unavailable" end
  local ok = pcall(method, vehicle, command)
  return ok, ok and "queued" or "vehicle_lua_queue_failed"
end

local function encodeNodeList(nodes)
  if type(nodes) ~= "table" or #nodes < 1 or #nodes > 512 then return nil end
  local values = {}
  for _, node in ipairs(nodes) do
    if type(node) ~= "string" and type(node) ~= "number" then return nil end
    local value = tostring(node)
    if #value > 128 or value:find("[%z\1-\31]") then return nil end
    values[#values + 1] = quote(value)
  end
  return "{" .. table.concat(values, ",") .. "}"
end

local function configure(vehicleId, options)
  options = type(options) == "table" and options or {}
  local speed = util.clamp(tonumber(options.speed) or 15, 0, 120)
  local speedMode = SPEED_MODES[options.speedMode] and options.speedMode or "limit"
  local aggression = util.clamp(tonumber(options.aggression) or 0.5, 0.3, 1)
  local lane = options.driveInLane == false and "off" or "on"
  local avoid = options.avoidCars == false and "off" or "on"
  return queue(vehicleId, table.concat({
    "ai.setSpeed(" .. tostring(speed) .. ")",
    "ai.setSpeedMode(" .. quote(speedMode) .. ")",
    "ai.setAggression(" .. tostring(aggression) .. ")",
    "ai.driveInLane(" .. quote(lane) .. ")",
    "ai.setAvoidCars(" .. quote(avoid) .. ")",
  }, ";"))
end

local function start(vehicleId, mode, options)
  if not MODES[mode] then
    return false, (mode == "Scripted" or mode == "Recorded") and "ai_mode_scripted_unavailable" or "ai_mode_unsupported"
  end
  options = type(options) == "table" and options or {}
  local configured, reason = configure(vehicleId, options)
  if not configured then return false, reason end
  if mode == "Destination" or mode == "Route" then
    local list = encodeNodeList(options.nodes)
    if not list then return false, "ai_route_invalid" end
    local laps = options.loop == true and math.max(2, math.min(1000, math.floor(tonumber(options.loopLaps) or 1000))) or 1
    local pathArgument = options.nodesArePath == false and "wpTargetList=" or "path="
    return queue(vehicleId, "ai.driveUsingPath{" .. pathArgument .. list .. ",driveInLane=" .. quote(options.driveInLane == false and "off" or "on") .. ",avoidCars=" .. quote(options.avoidCars == false and "off" or "on") .. ",routeSpeed=" .. tostring(util.clamp(tonumber(options.speed) or 15, 0, 120)) .. ",routeSpeedMode=" .. quote(SPEED_MODES[options.speedMode] and options.speedMode or "limit") .. ",aggression=" .. tostring(util.clamp(tonumber(options.aggression) or 0.5, 0.3, 1)) .. ",noOfLaps=" .. tostring(laps) .. "}")
  end
  if mode == "Chase" or mode == "Follow" then
    local targetId = math.floor(tonumber(options.targetVehicleId) or -1)
    if targetId < 0 or targetId == vehicleId then return false, "ai_target_invalid" end
    return queue(vehicleId, "ai.setTargetObjectID(" .. tostring(targetId) .. ");ai.setMode(" .. quote(mode:lower()) .. ")")
  end
  if mode == "Traffic" then return queue(vehicleId, "ai.setMode('traffic')") end
  return false, "ai_mode_unsupported"
end

local function stop(vehicleId, disable)
  return queue(vehicleId, disable == true and "ai.setMode('disabled')" or "ai.setMode('stop')")
end

local function recording(vehicleId, enabled)
  return queue(vehicleId, enabled and "ai.startRecording()" or "ai.stopRecording()")
end

local function targetExists(vehicleId)
  local vehicle, reason = object(math.floor(tonumber(vehicleId) or -1))
  return vehicle ~= nil, vehicle and "vehicle_target_confirmed" or reason
end

local function findClosestRoad(position)
  if type(map) ~= "table" or type(map.findClosestRoad) ~= "function" then return false, "navgraph_unavailable" end
  local value = type(vec3) == "function" and vec3(position.x, position.y, position.z) or position
  local ok, first, second = pcall(map.findClosestRoad, value)
  return ok, first, second
end

local function getPath(first, second)
  if type(map) ~= "table" or type(map.getPath) ~= "function" then return false, "navgraph_unavailable" end
  local ok, result = pcall(map.getPath, first, second)
  return ok and type(result) == "table", result
end

local function capabilities()
  local nav = type(map) == "table" and type(map.findClosestRoad) == "function" and type(map.getPath) == "function"
  local vehicleQueue = type(getObjectByID) == "function"
  return {
    Destination = nav and vehicleQueue, Route = nav and vehicleQueue,
    Chase = vehicleQueue, Follow = vehicleQueue, Traffic = vehicleQueue,
    Recording = vehicleQueue, Recorded = false, Scripted = false,
    navgraphReason = nav and nil or "No reachable NavGraph API is available in this map/build.",
    scriptedReason = "Scripted path unavailable in this build: no bounded portable path-transfer contract is enabled by the mod.",
    recordedReason = "Recorded playback is unavailable until a validated path can be transferred back to GE Lua.",
  }
end

M.MODES = MODES
M.queue = queue
M.configure = configure
M.start = start
M.stop = stop
M.recording = recording
M.targetExists = targetExists
M.findClosestRoad = findClosestRoad
M.getPath = getPath
M.capabilities = capabilities

return M
