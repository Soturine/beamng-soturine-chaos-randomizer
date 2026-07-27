local M = {}

local function finite(value)
  return type(value) == "number" and value == value and value ~= math.huge and value ~= -math.huge
end

local function collect(requestId, operationId, operationGeneration, targetGeneration)
  local result = {
    requestId = requestId,
    operationId = operationId,
    operationGeneration = operationGeneration,
    targetGeneration = targetGeneration,
    vehicleId = obj:getID(),
    available = false,
    source = "powertrain.getDevicesByType(combustionEngine).thermals.debugData.engineThermalData",
    confidence = "direct_vehicle_runtime_state",
    engines = {},
  }
  local ok, devices = pcall(function()
    return powertrain and powertrain.getDevicesByType
      and powertrain.getDevicesByType("combustionEngine") or {}
  end)
  if ok and type(devices) == "table" then
    result.available = true
    for _, engine in pairs(devices) do
      local thermal = engine.thermals and engine.thermals.debugData
        and engine.thermals.debugData.engineThermalData or {}
      local oilMass = tonumber(thermal.oilMass)
      local minimum = tonumber(thermal.miniumSafeOilMass or thermal.minimumSafeOilMass)
      local maximum = tonumber(thermal.maximumSafeOilMass)
      local coolantMass = tonumber(thermal.coolantMass)
      result.engines[#result.engines + 1] = {
        name = tostring(engine.name or engine.type or "combustionEngine"),
        oilMass = finite(oilMass) and oilMass or nil,
        minimumSafeOilMass = finite(minimum) and minimum or nil,
        maximumSafeOilMass = finite(maximum) and maximum or nil,
        coolantMass = finite(coolantMass) and coolantMass or nil,
        coolantExposed = thermal.coolantMass ~= nil,
        disabled = engine.isDisabled == true,
        stalled = engine.isStalled == true,
        oilLevelCritical = damageTracker and damageTracker.getDamage
          and damageTracker.getDamage("engine", "oilLevelCritical") == true or false,
      }
    end
    table.sort(result.engines, function(a, b) return a.name < b.name end)
  end
  obj:queueGameEngineLua(string.format(
    "if extensions.soturineChaosRandomizer then extensions.soturineChaosRandomizer.onFluidProbe(%s) end",
    serialize(result)
  ))
end

M.collect = collect

return M
