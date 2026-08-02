local M = {}

local function objectId(vehicle)
  if type(vehicle) ~= "table" and type(vehicle) ~= "userdata" then return nil end
  for _, name in ipairs({"getID", "getId"}) do
    local readable, method = pcall(function() return vehicle[name] end)
    if readable and type(method) == "function" then
      local ok, value = pcall(method, vehicle)
      value = ok and tonumber(value) or nil
      if value and value >= 0 and value == math.floor(value) then return value end
    end
  end
  local readable, value = pcall(function() return vehicle.id or vehicle.ID end)
  value = readable and tonumber(value) or nil
  return value and value >= 0 and value == math.floor(value) and value or nil
end

local function environment(source)
  source = type(source) == "table" and source or _G or {}
  return {
    vehiclesIterator = source.vehiclesIterator,
    activeVehiclesIterator = source.activeVehiclesIterator,
    getAllVehicles = source.getAllVehicles,
  }
end

local function visitIterator(factory, visitor)
  local ok, iterator, state, initial = pcall(factory)
  if not ok or type(iterator) ~= "function" then return false end
  local iterated = pcall(function()
    for vehicle in iterator, state, initial do visitor(vehicle) end
  end)
  return iterated
end

local function each(visitor, options)
  if type(visitor) ~= "function" then return false, "vehicle_visitor_invalid" end
  options = type(options) == "table" and options or {}
  local env = environment(options.environment)
  local factory = options.activeOnly and env.activeVehiclesIterator or env.vehiclesIterator
  local strategy = options.activeOnly and "activeVehiclesIterator" or "vehiclesIterator"
  if type(factory) == "function" and visitIterator(factory, visitor) then return true, strategy end
  if options.activeOnly and type(env.vehiclesIterator) == "function"
    and visitIterator(env.vehiclesIterator, visitor)
  then return true, "vehiclesIterator" end
  if type(env.getAllVehicles) ~= "function" then return false, "vehicle_enumeration_unavailable" end
  local ok, vehicles = pcall(env.getAllVehicles)
  if not ok or type(vehicles) ~= "table" then return false, "vehicle_enumeration_unavailable" end
  for _, vehicle in pairs(vehicles) do visitor(vehicle) end
  return true, "getAllVehicles"
end

local function collectIds(buffer, options)
  if type(buffer) ~= "table" then return false, "vehicle_buffer_invalid" end
  for index = #buffer, 1, -1 do buffer[index] = nil end
  local seen = {}
  local ok, strategy = each(function(vehicle)
    local id = objectId(vehicle)
    if id and not seen[id] then seen[id] = true; buffer[#buffer + 1] = id end
  end, options)
  if not ok then return false, strategy end
  if not options or options.deterministic ~= false then table.sort(buffer) end
  return true, strategy, #buffer
end

local function capabilities(source)
  local env = environment(source)
  return {
    vehiclesIterator = type(env.vehiclesIterator) == "function",
    activeVehiclesIterator = type(env.activeVehiclesIterator) == "function",
    getAllVehiclesFallback = type(env.getAllVehicles) == "function",
  }
end

M.objectId = objectId
M.each = each
M.collectIds = collectIds
M.capabilities = capabilities

return M
