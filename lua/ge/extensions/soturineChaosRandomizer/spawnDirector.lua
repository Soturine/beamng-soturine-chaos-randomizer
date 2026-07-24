local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local MODES = {Front = true, Behind = true, Left = true, Right = true, ["Front Left"] = true, ["Front Right"] = true, ["Behind Left"] = true, ["Behind Right"] = true, Line = true, Grid = true, Circle = true, Custom = true}
local MODE_ALIASES = { ["Front-left"] = "Front Left", ["Front-right"] = "Front Right", ["Back-left"] = "Behind Left", ["Back-right"] = "Behind Right", ["Custom point"] = "Custom" }
local HEADING_MODES = {
  camera = true, player = true, road = true, destination = true, custom = true,
}
local HEADING_ALIASES = {
  ["Same as camera"] = "camera", ["Same as player vehicle"] = "player",
  ["Road direction"] = "road", ["Face destination"] = "destination",
  ["Custom yaw"] = "custom",
}

local function offset(mode, index, count, options)
  local spacing = options.spacing
  if mode == "Front" then return 0, spacing * index end
  if mode == "Behind" then return 0, -spacing * index end
  if mode == "Left" then return -spacing * index, 0 end
  if mode == "Right" then return spacing * index, 0 end
  if mode == "Front Left" then return -spacing * index, spacing * index end
  if mode == "Front Right" then return spacing * index, spacing * index end
  if mode == "Behind Left" then return -spacing * index, -spacing * index end
  if mode == "Behind Right" then return spacing * index, -spacing * index end
  if mode == "Line" then return (index - (count + 1) * 0.5) * spacing, spacing end
  if mode == "Grid" then
    local columns = math.max(1, options.columns)
    local row, column = math.floor((index - 1) / columns), (index - 1) % columns
    return (column - (columns - 1) * 0.5) * spacing, (row + 1) * spacing
  end
  if mode == "Circle" then
    local angle = (index - 1) * math.pi * 2 / count
    return math.cos(angle) * options.radius, math.sin(angle) * options.radius
  end
  if mode == "Custom" and type(options.custom) == "table" and type(options.custom[index]) == "table" then
    return tonumber(options.custom[index].x) or 0, tonumber(options.custom[index].y) or 0
  end
  return 0, spacing * index
end

local function normalize(options)
  options = type(options) == "table" and options or {}
  local mode = MODE_ALIASES[options.mode] or options.mode
  local headingMode = HEADING_ALIASES[options.headingMode or options.heading] or options.headingMode or options.heading
  local normalized = {
    mode = MODES[mode] and mode or "Grid",
    count = math.max(1, math.min(16, math.floor(tonumber(options.count) or 1))),
    spacing = util.clamp(tonumber(options.spacing) or 6, 3, 40),
    rows = math.max(1, math.min(8, math.floor(tonumber(options.rows) or 2))),
    columns = math.max(1, math.min(8, math.floor(tonumber(options.columns) or 2))),
    radius = util.clamp(tonumber(options.radius) or 12, 5, 100),
    headingOffset = util.clamp(tonumber(options.headingOffset) or 0, -180, 180),
    groundOffset = util.clamp(tonumber(options.groundOffset) or 0.2, 0, 3),
    maxSlopeDegrees = util.clamp(tonumber(options.maxSlopeDegrees) or 25, 1, 60),
    minimumObjectDistance = util.clamp(tonumber(options.minimumObjectDistance) or 3, 1, 20),
    interval = util.clamp(tonumber(options.interval) or 0.75, 0.25, 10),
    maxConcurrentLoads = 1,
    headingMode = HEADING_MODES[headingMode] and headingMode or "camera",
    destination = util.deepCopy(options.destination),
    spawnAll = options.spawnAll ~= false,
    useNextLineupCompetitor = options.useNextLineupCompetitor ~= false,
    selectedDNAId = type(options.selectedDNAId) == "string" and options.selectedDNAId:sub(1, 128) or nil,
    custom = util.deepCopy(options.custom),
    customPoint = util.deepCopy(options.customPoint),
  }
  if normalized.mode == "Custom" then normalized.count = 1 end
  return normalized
end

local function flatUnit(value)
  if type(value) ~= "table" then return nil end
  local x, y = tonumber(value.x or value[1]), tonumber(value.y or value[2])
  if not util.isFinite(x) or not util.isFinite(y) then return nil end
  local length = math.sqrt(x * x + y * y)
  if length < 1e-8 then return nil end
  return {x = x / length, y = y / length, z = 0}
end

local function headingVector(frame, options, position)
  local base
  if options.headingMode == "player" then
    base = flatUnit(frame.playerForward)
    if not base then return nil, "player_heading_unavailable" end
  elseif options.headingMode == "road" then
    base = flatUnit(frame.roadForward)
    if not base then return nil, "road_heading_unavailable" end
  elseif options.headingMode == "destination" and type(options.destination) == "table" then
    base = flatUnit({x = (tonumber(options.destination.x) or 0) - position.x, y = (tonumber(options.destination.y) or 0) - position.y})
    if not base then return nil, "destination_heading_unavailable" end
  elseif options.headingMode == "destination" then return nil, "destination_heading_unavailable"
  elseif options.headingMode == "custom" then base = {x = 0, y = 1, z = 0}
  else base = flatUnit(frame.forward)
  end
  if not base then return nil, "camera_heading_invalid" end
  local angle = math.rad(options.headingOffset)
  return {
    x = base.x * math.cos(angle) - base.y * math.sin(angle),
    y = base.x * math.sin(angle) + base.y * math.cos(angle), z = 0,
  }
end

local function plan(frame, options, raycastGround, occupied)
  options = normalize(options)
  if type(frame) ~= "table" or type(frame.position) ~= "table" then return nil, "camera_frame_invalid" end
  local placements = {}
  for index = 1, options.count do
    local lateral, longitudinal = offset(options.mode, index, options.count, options)
    local customPoint = options.mode == "Custom" and type(options.customPoint) == "table"
      and {x = tonumber(options.customPoint.x), y = tonumber(options.customPoint.y), z = tonumber(options.customPoint.z)} or nil
    if options.mode == "Custom" and (not customPoint or not util.isFinite(customPoint.x)
      or not util.isFinite(customPoint.y) or not util.isFinite(customPoint.z))
    then return nil, "custom_point_invalid" end
    local raw = customPoint or {
        x = frame.position.x + frame.right.x * lateral + frame.forward.x * longitudinal,
        y = frame.position.y + frame.right.y * lateral + frame.forward.y * longitudinal,
        z = frame.position.z,
      }
    if math.sqrt(lateral * lateral + longitudinal * longitudinal) > 1000 then return nil, "outside_supported_area" end
    if type(raycastGround) ~= "function" then return nil, "ground_raycast_unavailable" end
    local ok, ground = raycastGround(raw)
    if not ok then return nil, ground or "ground_not_found" end
    if math.abs(ground.point.z - frame.position.z) > 250 then return nil, "outside_supported_area" end
    if ground.normal.z < math.cos(math.rad(options.maxSlopeDegrees)) then return nil, "slope_too_high" end
    local position = {x = ground.point.x, y = ground.point.y, z = ground.point.z + options.groundOffset}
    for _, existing in ipairs(occupied or {}) do
      local dx, dy = position.x - existing.x, position.y - existing.y
      local clearance = math.max(options.minimumObjectDistance, tonumber(existing.radius) or 0, options.spacing * 0.6)
      if dx * dx + dy * dy < clearance * clearance then return nil, "position_blocked" end
    end
    for _, existing in ipairs(placements) do
      local dx, dy = position.x - existing.position.x, position.y - existing.position.y
      if dx * dx + dy * dy < options.spacing * options.spacing * 0.36 then return nil, "position_blocked" end
    end
    local forward, headingReason = headingVector(frame, options, position)
    if not forward then return nil, headingReason end
    placements[#placements + 1] = {
      index = index, position = position, normal = ground.normal,
      forward = forward,
    }
  end
  return {options = options, placements = placements, cursor = 1, active = false, nextAt = 0, spawned = {}, failures = {}}
end

M.MODES = MODES
M.HEADING_MODES = HEADING_MODES
M.normalize = normalize
M.plan = plan
M.headingVector = headingVector

return M
