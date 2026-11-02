-- Records the path this vehicle drives with the game's own scriptai recorder
-- (ai.startRecording / ai.stopRecording) and hands a bounded copy to GE Lua,
-- where Race "Recorded" playback replays it through ai.driveUsingPath.
local M = {}

local MAX_POINTS = 600

local function finite(value)
  return type(value) == "number" and value == value and value ~= math.huge and value ~= -math.huge
end

local function round(value, scale)
  return math.floor(value * scale + 0.5) / scale
end

local function point(sample)
  if type(sample) ~= "table" or not finite(sample.x) or not finite(sample.y) or not finite(sample.z) then return nil end
  return {
    x = round(sample.x, 100), y = round(sample.y, 100), z = round(sample.z, 100),
    t = finite(sample.t) and round(sample.t, 1000) or nil,
    v = finite(sample.v) and round(sample.v, 100) or nil,
  }
end

-- Keeps first and last samples and an even stride between them.
local function compact(path)
  local count, points = #path, {}
  local stride = math.max(1, math.ceil(count / (MAX_POINTS - 1)))
  for index = 1, count, stride do points[#points + 1] = point(path[index]) end
  if count > 1 and (count - 1) % stride ~= 0 then points[#points + 1] = point(path[count]) end
  return points
end

local function start()
  -- true records the speed of every sample, so playback follows the path
  -- with ai.driveUsingPath instead of the timed scriptai follower.
  ai.startRecording(true)
end

local function stop(requestId)
  local recorded = ai.stopRecording()
  local path = type(recorded) == "table" and type(recorded.path) == "table" and recorded.path or {}
  local payload = {
    requestId = tostring(requestId), vehicleId = obj:getID(),
    sourceCount = #path, points = compact(path),
  }
  obj:queueGameEngineLua(
    "if extensions.soturineChaosRandomizer then extensions.soturineChaosRandomizer.onRecordedPath("
      .. serialize(payload) .. ") end"
  )
end

M.MAX_POINTS = MAX_POINTS
M.start = start
M.stop = stop

return M
