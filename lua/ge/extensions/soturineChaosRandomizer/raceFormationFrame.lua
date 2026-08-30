local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local ORIGINS = {automatic = true, player = true, camera = true, custom = true}

local function normalizeForward(value)
  if type(value) ~= "table" then return nil end
  local x, y = tonumber(value.x or value[1]), tonumber(value.y or value[2])
  if not util.isFinite(x) or not util.isFinite(y) then return nil end
  local length = math.sqrt(x * x + y * y)
  if length < 1e-8 then return nil end
  return {x = x / length, y = y / length, z = 0}
end

local function customPoint(options)
  local point = type(options.customPoint) == "table" and options.customPoint or {
    x = options.customPointX, y = options.customPointY, z = options.customPointZ,
  }
  local x, y, z = tonumber(point.x), tonumber(point.y), tonumber(point.z)
  if not util.isFinite(x) or not util.isFinite(y) or not util.isFinite(z) then return nil end
  return {x = x, y = y, z = z}
end

local function resolve(adapter, options, lineup)
  adapter = type(adapter) == "table" and adapter or {}
  options = type(options) == "table" and options or {}
  lineup = type(lineup) == "table" and lineup or {}
  local requested = options.formationOrigin or "automatic"
  if requested == "player_front" or requested == "player_behind" then requested = "player" end
  if not ORIGINS[requested] then requested = "automatic" end
  local resolved = requested
  if resolved == "automatic" then
    resolved = lineup.playerParticipates == true and "player" or "camera"
  end

  local cameraOk, camera = false, nil
  if type(adapter.cameraFrame) == "function" then cameraOk, camera = adapter.cameraFrame() end
  if cameraOk ~= true or type(camera) ~= "table" then camera = nil end

  local playerId = tonumber(lineup.playerVehicleId or lineup.playerParticipantVehicleId)
  local playerOk, player = false, nil
  if playerId and type(adapter.objectFrame) == "function" then
    playerOk, player = adapter.objectFrame(playerId)
  end
  if playerOk ~= true or type(player) ~= "table" then player = nil end

  local frame
  if resolved == "player" then
    if not player then return nil, "formation_player_origin_unavailable" end
    frame = util.deepCopy(player)
  elseif resolved == "custom" then
    local point = customPoint(options)
    if not point then return nil, "formation_custom_origin_invalid" end
    if not camera then return nil, "formation_camera_heading_unavailable" end
    frame = util.deepCopy(camera)
    frame.position = point
  else
    if not camera then return nil, "formation_camera_origin_unavailable" end
    frame = util.deepCopy(camera)
  end

  frame.forward = normalizeForward(frame.forward)
  if not frame.forward then return nil, "formation_origin_heading_invalid" end
  frame.right = {x = frame.forward.y, y = -frame.forward.x, z = 0}
  frame.playerForward = player and normalizeForward(player.forward) or nil
  frame.originMode = requested
  frame.originSource = resolved
  frame.playerVehicleId = playerId
  return frame
end

M.ORIGINS = ORIGINS
M.resolve = resolve

return M
