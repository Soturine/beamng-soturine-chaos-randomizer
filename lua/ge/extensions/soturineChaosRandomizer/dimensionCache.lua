local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local function finitePositive(value)
  return util.isFinite(value) and value > 0
end

local function xyz(value, y, z)
  if util.isFinite(value) and util.isFinite(y) and util.isFinite(z) then return value, y, z end
  if type(value) ~= "table" and type(value) ~= "userdata" then return nil end
  local ok, xValue, yValue, zValue = pcall(function() return value.x, value.y, value.z end)
  if ok and util.isFinite(xValue) and util.isFinite(yValue) and util.isFinite(zValue) then
    return xValue, yValue, zValue
  end
  return nil
end

local function method(object, name, ...)
  local readable, callback = pcall(function() return object[name] end)
  if not readable or type(callback) ~= "function" then return false end
  local ok, a, b, c = pcall(callback, object, ...)
  if not ok then return false end
  return true, a, b, c
end

local function extentsFromBox(box)
  if not box then return nil end
  local ok, value = method(box, "getHalfExtents")
  local x, y, z
  if ok then x, y, z = xyz(value) end
  if x and finitePositive(math.abs(x) * 2) and finitePositive(math.abs(y) * 2)
    and finitePositive(math.abs(z) * 2)
  then return math.abs(x) * 2, math.abs(y) * 2, math.abs(z) * 2 end
  return nil
end

local function pointXYZCapability(box)
  local readable, callback = pcall(function() return box and box.getPointXYZ end)
  return readable and type(callback) == "function"
end

local function readObject(object)
  if not object then return nil, "vehicle_missing" end
  local rearOk, rx, ry, rz = method(object, "getSpawnWorldOOBBRearPointXYZ")
  local frontOk, fx, fy, fz = method(object, "getSpawnWorldOOBBFrontPointXYZ")
  local centerOk = method(object, "getSpawnWorldOOBBCenterXYZ")
  if rearOk then rx, ry, rz = xyz(rx, ry, rz) else rx = nil end
  if frontOk then fx, fy, fz = xyz(fx, fy, fz) else fx = nil end
  local boxOk, box = method(object, "getSpawnWorldOOBB")
  local width, length, height
  if boxOk then width, length, height = extentsFromBox(box) end
  local source = "spawn_oobb"
  if rx and fx then
    local dx, dy, dz = fx - rx, fy - ry, fz - rz
    local xyzLength = math.sqrt(dx * dx + dy * dy + dz * dz)
    if finitePositive(xyzLength) then length = xyzLength; source = "spawn_oobb_xyz" end
  elseif boxOk and pointXYZCapability(box) then
    -- getPointXYZ capability is recorded even when half extents remain the
    -- more orientation-stable dimension source.
    source = "oobb_point_xyz"
  elseif centerOk then
    source = "spawn_oobb_center_xyz"
  end
  if not finitePositive(width) or not finitePositive(length) or not finitePositive(height) then
    local worldOk, worldBox = method(object, "getWorldBox")
    local extentsOk, value = false, nil
    if worldOk then extentsOk, value = method(worldBox, "getExtents") end
    local x, y, z
    if extentsOk then x, y, z = xyz(value) end
    if x and finitePositive(math.abs(x)) and finitePositive(math.abs(y)) and finitePositive(math.abs(z)) then
      width, length, height, source = math.abs(x), math.abs(y), math.abs(z), "world_box_fallback"
    end
  end
  if not finitePositive(width) or not finitePositive(length) or not finitePositive(height) then
    return nil, "vehicle_dimensions_unavailable"
  end
  return {width = width, length = length, height = height, source = source}
end

local function create(options)
  options = type(options) == "table" and options or {}
  return {
    entries = {}, order = {},
    limit = math.max(8, math.min(256, math.floor(tonumber(options.limit) or 64))),
    hits = 0, misses = 0, invalidations = 0,
  }
end

local function key(vehicleId, generation)
  vehicleId, generation = tonumber(vehicleId), tonumber(generation)
  if not vehicleId or vehicleId < 0 or not generation or generation < 0 then return nil end
  return tostring(math.floor(vehicleId)) .. ":" .. tostring(math.floor(generation))
end

local function removeKey(state, cacheKey)
  if not state.entries[cacheKey] then return false end
  state.entries[cacheKey] = nil
  for index, value in ipairs(state.order) do if value == cacheKey then table.remove(state.order, index); break end end
  state.invalidations = state.invalidations + 1
  return true
end

local function get(state, vehicleId, generation)
  local cacheKey = key(vehicleId, generation)
  local entry = cacheKey and state.entries[cacheKey] or nil
  if not entry then state.misses = state.misses + 1; return nil end
  state.hits = state.hits + 1
  return {
    vehicleId = entry.vehicleId, targetGeneration = entry.targetGeneration,
    width = entry.width, length = entry.length, height = entry.height,
    source = entry.source, measuredAt = entry.measuredAt,
  }
end

local function put(state, vehicleId, generation, dimensions, now)
  local cacheKey = key(vehicleId, generation)
  if not cacheKey or type(dimensions) ~= "table" or not finitePositive(dimensions.width)
    or not finitePositive(dimensions.length) or not finitePositive(dimensions.height)
  then return nil, "vehicle_dimensions_invalid" end
  if not state.entries[cacheKey] then state.order[#state.order + 1] = cacheKey end
  state.entries[cacheKey] = {
    vehicleId = math.floor(vehicleId), targetGeneration = math.floor(generation),
    width = dimensions.width, length = dimensions.length, height = dimensions.height,
    source = dimensions.source or "unknown", measuredAt = tonumber(now) or 0,
  }
  while #state.order > state.limit do removeKey(state, state.order[1]) end
  local entry = state.entries[cacheKey]
  return {
    vehicleId = entry.vehicleId, targetGeneration = entry.targetGeneration,
    width = entry.width, length = entry.length, height = entry.height,
    source = entry.source, measuredAt = entry.measuredAt,
  }
end

local function read(state, vehicleId, generation, object, now)
  local cached = get(state, vehicleId, generation)
  if cached then return cached, "cache_hit" end
  local dimensions, reason = readObject(object)
  if not dimensions then return nil, reason end
  return put(state, vehicleId, generation, dimensions, now), "measured"
end

local function invalidate(state, vehicleId, generation)
  local exact = generation ~= nil and key(vehicleId, generation) or nil
  if exact then return removeKey(state, exact) end
  local prefix = tostring(math.floor(tonumber(vehicleId) or -1)) .. ":"
  local removed = false
  for index = #state.order, 1, -1 do
    local cacheKey = state.order[index]
    if cacheKey:sub(1, #prefix) == prefix then
      state.entries[cacheKey] = nil; table.remove(state.order, index); removed = true
      state.invalidations = state.invalidations + 1
    end
  end
  return removed
end

local function clear(state)
  state.entries, state.order = {}, {}
  state.invalidations = state.invalidations + 1
  return true
end

local function snapshot(state)
  return {size = #state.order, limit = state.limit, hits = state.hits, misses = state.misses, invalidations = state.invalidations}
end

M.create = create
M.get = get
M.put = put
M.read = read
M.readObject = readObject
M.invalidate = invalidate
M.clear = clear
M.snapshot = snapshot

return M
