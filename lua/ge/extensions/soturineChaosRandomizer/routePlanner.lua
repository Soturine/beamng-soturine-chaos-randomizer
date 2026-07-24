local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}
local point

local function create(maximum)
  return {points = {}, maximum = math.max(2, math.min(64, math.floor(tonumber(maximum) or 16))), revision = 0}
end

local function addPoint(state, value)
  local valuePoint = point(value)
  if not valuePoint then return false, "route_point_invalid" end
  if #state.points >= state.maximum then return false, "route_point_limit" end
  state.points[#state.points + 1] = valuePoint
  state.revision = (state.revision or 0) + 1
  return true
end

local function removeLast(state)
  if #state.points == 0 then return false, "route_points_missing" end
  table.remove(state.points)
  state.revision = (state.revision or 0) + 1
  return true
end

local function clear(state)
  state.points = {}
  state.revision = (state.revision or 0) + 1
  return true
end

local function reverse(state)
  local reversed = {}
  for index = #state.points, 1, -1 do reversed[#reversed + 1] = util.deepCopy(state.points[index]) end
  state.points = reversed
  state.revision = (state.revision or 0) + 1
  return true
end

point = function(value)
  if type(value) ~= "table" then return nil end
  local x, y, z = tonumber(value.x or value[1]), tonumber(value.y or value[2]), tonumber(value.z or value[3])
  if not util.isFinite(x) or not util.isFinite(y) or not util.isFinite(z) then return nil end
  return {x = x, y = y, z = z}
end

local function nearestRoad(adapter, value)
  local position = point(value)
  if not position then return nil, "destination_invalid" end
  local ok, first, second = adapter.findClosestRoad(position)
  if not ok or (first == nil and second == nil) then return nil, "navgraph_node_not_found" end
  return {position = position, first = first, second = second}
end

local function destinationRoute(adapter, origin, destination, maximum)
  local start, startError = nearestRoad(adapter, origin)
  if not start then return nil, startError end
  local finish, finishError = nearestRoad(adapter, destination)
  if not finish then return nil, finishError end
  local startNode = start.first or start.second
  local finishNode = finish.first or finish.second
  local ok, nodes = adapter.getPath(startNode, finishNode)
  if not ok or type(nodes) ~= "table" or #nodes == 0 then return nil, "navgraph_route_unreachable" end
  if #nodes > (maximum or 512) then return nil, "navgraph_route_limit" end
  return {nodes = nodes, origin = start, destination = finish, snapped = true, kind = "NavGraph"}
end

local function routeThrough(adapter, origin, points, maximum, loop)
  if type(points) ~= "table" or #points == 0 then return nil, "route_points_missing" end
  maximum = maximum or 512
  local destinations = util.deepCopy(points)
  if loop == true and #destinations > 1 then destinations[#destinations + 1] = util.deepCopy(destinations[1]) end
  local combined, current = {}, origin
  for _, destination in ipairs(destinations) do
    local segment, reason = destinationRoute(adapter, current, destination, maximum - #combined)
    if not segment then return nil, reason end
    for _, node in ipairs(segment.nodes) do
      if combined[#combined] ~= node then combined[#combined + 1] = node end
      if #combined > maximum then return nil, "navgraph_route_limit" end
    end
    current = destination
  end
  return {nodes = combined, origin = point(origin), destination = point(destinations[#destinations]), points = destinations, snapped = true, kind = "NavGraph route"}
end

M.point = point
M.create = create
M.addPoint = addPoint
M.removeLast = removeLast
M.clear = clear
M.reverse = reverse
M.nearestRoad = nearestRoad
M.destinationRoute = destinationRoute
M.routeThrough = routeThrough

return M
