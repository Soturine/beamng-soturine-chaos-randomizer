local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local function xyz(value)
  if value == nil then return nil end
  local ok, x, y, z = pcall(function() return tonumber(value.x or value[1]), tonumber(value.y or value[2]), tonumber(value.z or value[3]) end)
  if not ok or not util.isFinite(x) or not util.isFinite(y) or not util.isFinite(z) then return nil end
  return {x = x, y = y, z = z}
end

local function vector(value)
  if type(vec3) == "function" then return vec3(value.x, value.y, value.z) end
  return {value.x, value.y, value.z}
end

local function cameraFrame()
  if type(core_camera) ~= "table" or type(core_camera.getPosition) ~= "function" or type(core_camera.getForward) ~= "function" then
    return false, "camera_unavailable"
  end
  local ok, position, forward = pcall(function() return core_camera.getPosition(), core_camera.getForward() end)
  position, forward = ok and xyz(position) or nil, ok and xyz(forward) or nil
  if not position or not forward then return false, "camera_frame_invalid" end
  local length = math.sqrt(forward.x * forward.x + forward.y * forward.y)
  if length < 1e-6 then return false, "camera_heading_invalid" end
  forward.x, forward.y, forward.z = forward.x / length, forward.y / length, 0
  return true, {position = position, forward = forward, right = {x = -forward.y, y = forward.x, z = 0}}
end

local function playerForward()
  if type(getPlayerVehicle) ~= "function" then return false, "player_vehicle_unavailable" end
  local ok, vehicle = pcall(getPlayerVehicle, 0)
  if not ok or vehicle == nil then return false, "player_vehicle_unavailable" end
  local worked, direction = pcall(function() return vehicle:getDirectionVector() end)
  direction = worked and xyz(direction) or nil
  if not direction then return false, "player_heading_unavailable" end
  local length = math.sqrt(direction.x * direction.x + direction.y * direction.y)
  if length < 1e-6 then return false, "player_heading_unavailable" end
  return true, {x = direction.x / length, y = direction.y / length, z = 0}
end

local function roadForward(position)
  if type(map) ~= "table" or type(map.findClosestRoad) ~= "function" or type(map.getMap) ~= "function" then
    return false, "road_heading_unavailable"
  end
  local ok, first, second = pcall(map.findClosestRoad, vector(position))
  if not ok or first == nil or second == nil then return false, "road_heading_unavailable" end
  local mapOk, mapData = pcall(map.getMap)
  local nodes = mapOk and mapData and mapData.nodes
  local firstPosition = nodes and nodes[first] and xyz(nodes[first].pos)
  local secondPosition = nodes and nodes[second] and xyz(nodes[second].pos)
  if not firstPosition or not secondPosition then return false, "road_heading_unavailable" end
  local x, y = secondPosition.x - firstPosition.x, secondPosition.y - firstPosition.y
  local length = math.sqrt(x * x + y * y)
  if length < 1e-6 then return false, "road_heading_unavailable" end
  return true, {x = x / length, y = y / length, z = 0}
end

local function raycastGround(position, up, down)
  if type(Engine) ~= "table" or type(Engine.castRay) ~= "function" then return false, "ground_not_found" end
  local start = {x = position.x, y = position.y, z = position.z + (tonumber(up) or 20)}
  local finish = {x = position.x, y = position.y, z = position.z - (tonumber(down) or 80)}
  local ok, hit = pcall(Engine.castRay, vector(start), vector(finish), true, false)
  if not ok or type(hit) ~= "table" or hit.pt == nil then return false, "ground_not_found" end
  local point, normal = xyz(hit.pt), xyz(hit.norm or hit.normal)
  if not point then return false, "ground_not_found" end
  return true, {point = point, normal = normal or {x = 0, y = 0, z = 1}}
end

local function spawnVehicle(modelKey, config, placement)
  if type(core_vehicles) ~= "table" or type(core_vehicles.spawnNewVehicle) ~= "function" then return false, "vehicle_spawn_unavailable" end
  local direction = placement.forward or {x = 0, y = 1, z = 0}
  local rotation
  if type(quatFromDir) == "function" then
    local ok, value = pcall(quatFromDir, vector(direction), vector(placement.normal or {x = 0, y = 0, z = 1}))
    if ok then rotation = value end
  end
  local options = {config = util.deepCopy(config), pos = vector(placement.position)}
  if rotation then options.rot = rotation end
  local ok, vehicle = pcall(core_vehicles.spawnNewVehicle, modelKey, options)
  if not ok or vehicle == nil then return false, "vehicle_spawn_failed" end
  local id
  for _, method in ipairs({"getID", "getId"}) do
    local readable, fn = pcall(function() return vehicle[method] end)
    if readable and type(fn) == "function" then local worked, value = pcall(fn, vehicle); if worked then id = tonumber(value); break end end
  end
  if not id then return false, "vehicle_spawn_id_unavailable" end
  return true, id
end

local function objectPosition(vehicleId)
  if type(getObjectByID) ~= "function" then return false, "vehicle_lookup_unavailable" end
  local ok, object = pcall(getObjectByID, vehicleId)
  if not ok or not object then return false, "vehicle_missing" end
  local worked, position = pcall(function() return object:getPosition() end)
  position = worked and xyz(position) or nil
  if not position then return false, "vehicle_position_unavailable" end
  return true, position
end

local function objectSpeed(vehicleId)
  if type(getObjectByID) ~= "function" then return false, "vehicle_lookup_unavailable" end
  local ok, object = pcall(getObjectByID, vehicleId)
  if not ok or not object then return false, "vehicle_missing" end
  local worked, velocity = pcall(function() return object:getVelocity() end)
  velocity = worked and xyz(velocity) or nil
  if not velocity then return false, "vehicle_velocity_unavailable" end
  return true, math.sqrt(velocity.x * velocity.x + velocity.y * velocity.y + velocity.z * velocity.z)
end

local function occupiedVehiclePositions()
  if type(getAllVehicles) ~= "function" then return false, "vehicle_enumeration_unavailable" end
  local ok, vehicles = pcall(getAllVehicles)
  if not ok or type(vehicles) ~= "table" then return false, "vehicle_enumeration_unavailable" end
  local result = {}
  for _, vehicle in ipairs(vehicles) do
    local worked, position = pcall(function() return vehicle:getPosition() end)
    position = worked and xyz(position) or nil
    if position then
      local id
      pcall(function() id = tonumber(vehicle:getID()) end)
      result[#result + 1] = {x = position.x, y = position.y, z = position.z, radius = 3, vehicleId = id}
    end
  end
  return true, result
end

local function deleteVehicle(vehicleId)
  if type(getObjectByID) ~= "function" then return false, "vehicle_lookup_unavailable" end
  local ok, object = pcall(getObjectByID, vehicleId)
  if not ok or not object then return false, "vehicle_missing" end
  local readable, method = pcall(function() return object.delete end)
  if not readable or type(method) ~= "function" then return false, "vehicle_delete_unavailable" end
  local deleted = pcall(method, object)
  return deleted, deleted and "vehicle_deleted" or "vehicle_delete_failed"
end

local function readVehicleState(vehicleId)
  if type(core_vehicle_manager) ~= "table" or type(core_vehicle_manager.getVehicleData) ~= "function" then
    return false, "vehicle_state_read_unavailable"
  end
  local ok, data = pcall(core_vehicle_manager.getVehicleData, vehicleId)
  if not ok or type(data) ~= "table" then return nil, "vehicle_spawn_pending" end
  local modelKey = data.model
  if type(modelKey) ~= "string" and data.vehicleObj then
    local readable, value = pcall(function()
      if type(data.vehicleObj.getJBeamFilename) == "function" then return data.vehicleObj:getJBeamFilename() end
      return data.vehicleObj.JBeam
    end)
    if readable then modelKey = value end
  end
  if type(modelKey) ~= "string" or modelKey == "" or type(data.config) ~= "table" then
    return nil, "vehicle_spawn_pending"
  end
  return true, {
    vehicleId = vehicleId,
    modelKey = modelKey,
    config = util.deepCopy(data.config),
  }
end

local function verifySpawnTarget(vehicleId, expectedModelKey, expectedConfig)
  local readable, stateOrReason = readVehicleState(vehicleId)
  if readable ~= true then return readable, stateOrReason end
  local state = stateOrReason
  if expectedModelKey and state.modelKey ~= expectedModelKey then return false, "spawn_model_mismatch" end
  local expected = type(expectedConfig) == "table" and expectedConfig or {}
  local actual = state.config
  for key, value in pairs(expected.parts or {}) do
    if type(actual.parts) ~= "table" or actual.parts[key] ~= value then
      return nil, "spawn_parts_pending"
    end
  end
  for name, value in pairs(expected.vars or {}) do
    local requested = tonumber(value)
    local observed = actual.vars and tonumber(actual.vars[name])
    if requested ~= nil and (observed == nil or math.abs(observed - requested) > 1e-8) then
      return nil, "spawn_tuning_pending"
    end
  end
  if type(expected.paints) == "table" and #expected.paints > 0 then
    if type(actual.paints) ~= "table" or not util.deepEqual(expected.paints, actual.paints, 1e-5) then
      return nil, "spawn_paint_pending"
    end
  end
  return true, state
end

local function drawPreview(placements)
  if debugDrawer == nil or type(ColorF) ~= "function" then return false end
  for _, placement in ipairs(placements or {}) do
    pcall(function() debugDrawer:drawSphere(vector(placement.position), 0.6, ColorF(0.1, 0.8, 1, 0.65)) end)
  end
  return true
end

M.xyz = xyz
M.cameraFrame = cameraFrame
M.playerForward = playerForward
M.roadForward = roadForward
M.raycastGround = raycastGround
M.spawnVehicle = spawnVehicle
M.objectPosition = objectPosition
M.objectSpeed = objectSpeed
M.occupiedVehiclePositions = occupiedVehiclePositions
M.deleteVehicle = deleteVehicle
M.readVehicleState = readVehicleState
M.verifySpawnTarget = verifySpawnTarget
M.drawPreview = drawPreview

return M
