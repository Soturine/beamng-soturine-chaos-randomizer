local spawnAdapter = require("ge/extensions/soturineChaosRandomizer/spawnApiAdapter")
local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local function create()
  return {
    active = false, confirmed = false, status = "empty", point = nil,
    exactPoint = nil, snappedPoint = nil, snapDistance = nil, createdAt = nil,
  }
end

local function placeFromCamera(state, maximumDistance)
  local ok, frame = spawnAdapter.cameraFrame()
  if not ok then return false, frame end
  local distance = tonumber(maximumDistance) or 2000
  local target = {x = frame.position.x + frame.forward.x * distance, y = frame.position.y + frame.forward.y * distance, z = frame.position.z + frame.forward.z * distance}
  if type(Engine) ~= "table" or type(Engine.castRay) ~= "function" or type(vec3) ~= "function" then return false, "destination_raycast_unavailable" end
  local worked, hit = pcall(Engine.castRay, vec3(frame.position.x, frame.position.y, frame.position.z), vec3(target.x, target.y, target.z), true, false)
  local point = worked and hit and spawnAdapter.xyz(hit.pt) or nil
  if not point then return false, "destination_not_found" end
  state.active, state.confirmed, state.status = false, false, "preview"
  state.point, state.exactPoint, state.snappedPoint = point, point, nil
  state.snapDistance, state.createdAt = nil, os.time()
  return true, point
end

local function snapToNavGraph(state, adapter)
  if not state.exactPoint then return false, "destination_not_found" end
  if type(adapter) ~= "table" or type(adapter.findClosestRoad) ~= "function" then return false, "navgraph_unavailable" end
  local ok, first, second, distance = adapter.findClosestRoad(state.exactPoint)
  if not ok or (first == nil and second == nil) then return false, "navgraph_node_not_found" end
  local snapped = state.exactPoint
  if type(map) == "table" and type(map.getMap) == "function" then
    local mapOk, mapData = pcall(map.getMap)
    local node = mapOk and mapData and mapData.nodes and mapData.nodes[first or second]
    local candidate = node and spawnAdapter.xyz(node.pos)
    if candidate then snapped = candidate end
  end
  state.snappedPoint = snapped
  if util and util.isFinite and util.isFinite(tonumber(distance)) then state.snapDistance = tonumber(distance)
  else
    local dx, dy, dz = snapped.x - state.exactPoint.x, snapped.y - state.exactPoint.y, snapped.z - state.exactPoint.z
    state.snapDistance = math.sqrt(dx * dx + dy * dy + dz * dz)
  end
  state.status = "preview_snapped"
  return true, snapped
end

local function confirm(state, mode)
  if not state.exactPoint then return false, "destination_not_found" end
  if mode == "snap" then
    if not state.snappedPoint then return false, "destination_snap_missing" end
    state.point = state.snappedPoint
  elseif mode == "exact" then state.point = state.exactPoint
  else return false, "destination_confirm_mode_invalid" end
  state.active, state.confirmed, state.status = true, true, "confirmed_" .. mode
  return true, state.point
end

local function clear(state)
  state.active, state.confirmed, state.status = false, false, "empty"
  state.point, state.exactPoint, state.snappedPoint = nil, nil, nil
  state.snapDistance, state.createdAt = nil, nil
  return true
end

local function draw(state)
  if not state.point or debugDrawer == nil or type(vec3) ~= "function" or type(ColorF) ~= "function" then return false end
  pcall(function() debugDrawer:drawSphere(vec3(state.point.x, state.point.y, state.point.z), 1.1, ColorF(1, 0.35, 0.05, 0.8)) end)
  return true
end

M.create = create
M.placeFromCamera = placeFromCamera
M.snapToNavGraph = snapToNavGraph
M.confirm = confirm
M.clear = clear
M.draw = draw

return M
