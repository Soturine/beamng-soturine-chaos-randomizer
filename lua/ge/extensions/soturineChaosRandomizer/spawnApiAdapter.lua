local util = require("ge/extensions/soturineChaosRandomizer/util")
local spawnOutcome = require("ge/extensions/soturineChaosRandomizer/spawnOutcome")
local dimensionCacheModule = require("ge/extensions/soturineChaosRandomizer/dimensionCache")
local vehicleBufferPool = require("ge/extensions/soturineChaosRandomizer/vehicleBufferPool")
local vehicleIterator = require("ge/extensions/soturineChaosRandomizer/vehicleIterator")

local M = {}
local dimensionCache = dimensionCacheModule.create({limit = 64})
local buffers = vehicleBufferPool.create()

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

local vehicleIds

local function objectId(vehicle)
  if type(vehicle) ~= "table" and type(vehicle) ~= "userdata" then return nil end
  for _, method in ipairs({"getID", "getId"}) do
    local readable, fn = pcall(function() return vehicle[method] end)
    if readable and type(fn) == "function" then
      local worked, value = pcall(fn, vehicle)
      if worked and tonumber(value) then return tonumber(value) end
    end
  end
  return nil
end

local function spawnVehicle(modelKey, config, placement)
  if type(core_vehicles) ~= "table" or type(core_vehicles.spawnNewVehicle) ~= "function" then return false, "vehicle_spawn_unavailable" end
  placement = type(placement) == "table" and placement or {}
  local before = vehicleIds()
  local transaction = spawnOutcome.begin({
    requestedModel = modelKey, requestedConfig = config, requestedPlacement = placement,
    worldVehicleIdsBefore = before,
  })
  local direction = placement.forward or {x = 0, y = 1, z = 0}
  local rotation
  if type(quatFromDir) == "function" then
    local ok, value = pcall(quatFromDir, vector(direction), vector(placement.normal or {x = 0, y = 0, z = 1}))
    if ok then rotation = value end
  end
  local options = {config = util.deepCopy(config), pos = vector(placement.position)}
  if rotation then options.rot = rotation end
  local ok, vehicle = pcall(core_vehicles.spawnNewVehicle, modelKey, options)
  spawnOutcome.finish(transaction, {
    thrown = not ok, apiResult = vehicle,
    returnedObjectEvidence = ok and vehicle ~= nil and vehicle ~= false,
    returnedVehicleId = ok and objectId(vehicle) or nil,
    worldVehicleIdsAfter = vehicleIds(),
  })
  if #transaction.candidateVehicleIds == 1 then return true, transaction.candidateVehicleIds[1], transaction end
  if transaction.outcome == "awaiting_identity" then return false, "vehicle_spawn_id_unavailable", transaction end
  return false, transaction.reason or "UNKNOWN_FAILURE", transaction
end

local function placeVehicle(vehicleId, placement)
  if type(getObjectByID) ~= "function" or type(spawn) ~= "table"
    or type(spawn.safeTeleport) ~= "function" or type(placement) ~= "table"
    or type(placement.position) ~= "table"
  then return false, "vehicle_placement_unavailable" end
  local okObject, vehicle = pcall(getObjectByID, vehicleId)
  if not okObject or not vehicle then return false, "vehicle_missing" end
  local direction = placement.forward or {x = 0, y = 1, z = 0}
  local rotation
  if type(quatFromDir) == "function" then
    local worked, value = pcall(
      quatFromDir, vector(direction), vector(placement.normal or {x = 0, y = 0, z = 1})
    )
    if worked then rotation = value end
  end
  local worked = pcall(
    spawn.safeTeleport, vehicle, vector(placement.position), rotation,
    nil, nil, nil, true, false
  )
  return worked, worked and "vehicle_placement_requested" or "vehicle_placement_failed"
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

local function objectExists(vehicleId)
  if type(getObjectByID) ~= "function" or type(vehicleId) ~= "number" then return false end
  local ok, object = pcall(getObjectByID, vehicleId)
  return ok and object ~= nil
end

local function vehicleDimensions(vehicleId, targetGeneration)
  if type(getObjectByID) ~= "function" then return nil, "vehicle_lookup_unavailable" end
  local ok, object = pcall(getObjectByID, vehicleId)
  if not ok or not object then return nil, "vehicle_missing" end
  return dimensionCacheModule.read(dimensionCache, vehicleId, tonumber(targetGeneration) or 0, object, os.clock())
end

vehicleIds = function()
  local buffer, generation = vehicleBufferPool.acquire(buffers, "vehicleIdsBuffer")
  if not buffer then return nil, generation end
  local ok, strategy = vehicleIterator.collectIds(buffer, {deterministic = true})
  if not ok then vehicleBufferPool.release(buffers, "vehicleIdsBuffer", generation); return nil, strategy end
  local result = vehicleBufferPool.copyOut(buffer)
  vehicleBufferPool.release(buffers, "vehicleIdsBuffer", generation)
  return result, strategy
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
  local result, generation = vehicleBufferPool.acquire(buffers, "occupiedPositionsBuffer")
  if not result then return false, generation end
  local ok, strategy = vehicleIterator.each(function(vehicle)
    local worked, position = pcall(function() return vehicle:getPosition() end)
    position = worked and xyz(position) or nil
    if position then
      local id = vehicleIterator.objectId(vehicle)
      local dimensions = id and vehicleDimensions(id) or nil
      local radius = dimensions and math.sqrt(dimensions.width * dimensions.width
        + dimensions.length * dimensions.length) * 0.5 or 3
      result[#result + 1] = {
        x = position.x, y = position.y, z = position.z,
        radius = radius, dimensions = util.deepCopy(dimensions), vehicleId = id,
      }
    end
  end)
  if not ok then vehicleBufferPool.release(buffers, "occupiedPositionsBuffer", generation); return false, strategy end
  local public = vehicleBufferPool.copyOut(result)
  vehicleBufferPool.release(buffers, "occupiedPositionsBuffer", generation)
  return true, public, strategy
end

local function deleteVehicle(vehicleId)
  if type(getObjectByID) ~= "function" then return false, "vehicle_lookup_unavailable" end
  local ok, object = pcall(getObjectByID, vehicleId)
  if not ok or not object then return false, "vehicle_missing" end
  local readable, method = pcall(function() return object.delete end)
  if not readable or type(method) ~= "function" then return false, "vehicle_delete_unavailable" end
  local deleted = pcall(method, object)
  if deleted then dimensionCacheModule.invalidate(dimensionCache, vehicleId) end
  return deleted, deleted and "vehicle_deleted" or "vehicle_delete_failed"
end

local function invalidateDimensions(vehicleId, targetGeneration)
  return dimensionCacheModule.invalidate(dimensionCache, vehicleId, targetGeneration)
end

local function performanceSnapshot()
  return {
    dimensions = dimensionCacheModule.snapshot(dimensionCache),
    buffers = vehicleBufferPool.snapshot(buffers),
    iterators = vehicleIterator.capabilities(),
  }
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
  placements = type(placements) == "table" and placements or {}
  local report = {
    rendererAvailable = debugDrawer ~= nil and type(ColorF) == "function"
      and type(vector) == "function",
    requestedMarkerCount = #placements,
    renderedMarkerCount = 0,
    errorCode = nil,
    errorMessage = nil,
  }
  if not report.rendererAvailable then
    report.errorCode = "preview_renderer_unavailable"
    report.errorMessage = "The world debug renderer is unavailable"
    return false, report
  end
  for _, placement in ipairs(placements or {}) do
    local worked, failure = pcall(function()
      local palette = {
        player = {0.2, 0.7, 1}, planned = {0.7, 0.7, 0.7}, generating = {1, 0.72, 0.12},
        ready = {0.2, 0.9, 0.35}, ready_with_warnings = {0.95, 0.65, 0.15}, failed = {1, 0.2, 0.2},
      }
      local rgb = palette[placement.visual] or palette.planned
      local color = ColorF(rgb[1], rgb[2], rgb[3], 0.8)
      local marginColor = ColorF(rgb[1], rgb[2], rgb[3], 0.35)
      local position = vector(placement.position)
      local forward = placement.forward or {x = 0, y = 1, z = 0}
      local width = tonumber(placement.dimensions and placement.dimensions.width) or 2
      local length = tonumber(placement.dimensions and placement.dimensions.length) or 4.8
      local fx, fy = tonumber(forward.x) or 0, tonumber(forward.y) or 1
      local magnitude = math.max(0.0001, math.sqrt(fx * fx + fy * fy))
      fx, fy = fx / magnitude, fy / magnitude
      local rx, ry = fy, -fx
      local function point(longitudinal, lateral, z)
        return vector({x = placement.position.x + fx * longitudinal + rx * lateral,
          y = placement.position.y + fy * longitudinal + ry * lateral,
          z = placement.position.z + (z or 0.1)})
      end
      local a, b = point(length * 0.5, width * 0.5), point(length * 0.5, -width * 0.5)
      local c, d = point(-length * 0.5, -width * 0.5), point(-length * 0.5, width * 0.5)
      local clearance = math.max(0, tonumber(placement.clearance) or 0)
      local marginLength, marginWidth = length * 0.5 + clearance, width * 0.5 + clearance
      local ma, mb = point(marginLength, marginWidth), point(marginLength, -marginWidth)
      local mc, md = point(-marginLength, -marginWidth), point(-marginLength, marginWidth)
      debugDrawer:drawSphere(position, 0.35, color)
      debugDrawer:drawLine(a, b, color); debugDrawer:drawLine(b, c, color)
      debugDrawer:drawLine(c, d, color); debugDrawer:drawLine(d, a, color)
      debugDrawer:drawLine(ma, mb, marginColor); debugDrawer:drawLine(mb, mc, marginColor)
      debugDrawer:drawLine(mc, md, marginColor); debugDrawer:drawLine(md, ma, marginColor)
      debugDrawer:drawLine(position, point(length * 0.65, 0, 0.25), color)
      if type(placement.label) == "string" and type(ColorI) == "function" then
        local positionSymbols = {valid = "[OK]", tight = "[!]", blocked = "[X]", unknown = "[?]"}
        local generationSymbols = {player = "[P]", planned = "[.]", generating = "[~]",
          ready = "[OK]", ready_with_warnings = "[!]", failed = "[X]"}
        local symbol = positionSymbols[placement.positionStatus]
          or generationSymbols[placement.visual] or "[.]"
        debugDrawer:drawTextAdvanced(point(0, 0, 1.2), symbol .. " " .. placement.label, color,
          true, false, ColorI(0, 0, 0, 210), false, true)
      end
    end)
    if worked then
      report.renderedMarkerCount = report.renderedMarkerCount + 1
    else
      report.errorCode = "preview_marker_render_failed"
      report.errorMessage = tostring(failure)
    end
  end
  if report.renderedMarkerCount == 0 and report.requestedMarkerCount > 0 then
    report.errorCode = report.errorCode or "preview_render_empty"
    report.errorMessage = report.errorMessage or "No preview marker was drawn"
    return false, report
  end
  return report.renderedMarkerCount > 0, report
end

M.xyz = xyz
M.cameraFrame = cameraFrame
M.playerForward = playerForward
M.roadForward = roadForward
M.raycastGround = raycastGround
M.spawnVehicle = spawnVehicle
M.placeVehicle = placeVehicle
M.objectPosition = objectPosition
M.objectExists = objectExists
M.vehicleDimensions = vehicleDimensions
M.invalidateDimensions = invalidateDimensions
M.vehicleIds = vehicleIds
M.objectSpeed = objectSpeed
M.occupiedVehiclePositions = occupiedVehiclePositions
M.deleteVehicle = deleteVehicle
M.readVehicleState = readVehicleState
M.verifySpawnTarget = verifySpawnTarget
M.drawPreview = drawPreview
M.performanceSnapshot = performanceSnapshot
M.spawnOutcome = spawnOutcome

return M
