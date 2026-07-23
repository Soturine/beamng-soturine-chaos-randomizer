local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local LOG_TAG = "SoturineChaosRandomizer"
local SETTINGS_PATH = "/settings/soturineChaosRandomizer/settings.json"
local DEFAULTS_PATH = "/settings/soturineChaosRandomizer/defaults.json"

local jbeamIO
local okJbeam, loadedJbeam = pcall(require, "jbeam/io")
if okJbeam then jbeamIO = loadedJbeam end

local function errorValue(code, message, context)
  return {
    code = code,
    message = message,
    context = context or {},
  }
end

local function safeCall(name, callback)
  local ok, value, extra = pcall(callback)
  if not ok then
    return false, errorValue("api_failure", "BeamNG API call failed: " .. name, {detail = tostring(value)})
  end
  return true, value, extra
end

local function getCapabilities()
  local capabilities = {
    vehicleManager = type(core_vehicle_manager) == "table" and type(core_vehicle_manager.getPlayerVehicleData) == "function",
    partManagement = type(core_vehicle_partmgmt) == "table"
      and type(core_vehicle_partmgmt.getConfig) == "function"
      and type(core_vehicle_partmgmt.setPartsTreeConfig) == "function",
    vehicleRegistry = type(core_vehicles) == "table"
      and type(core_vehicles.getModelList) == "function"
      and type(core_vehicles.getConfigList) == "function"
      and type(core_vehicles.replaceVehicle) == "function",
    hierarchicalSlots = type(jbeamIO) == "table"
      and type(jbeamIO.getPart) == "function"
      and type(jbeamIO.getAvailableParts) == "function",
    uiEvents = type(guihooks) == "table" and type(guihooks.trigger) == "function",
    persistence = type(jsonReadFile) == "function" and type(jsonWriteFile) == "function",
  }
  capabilities.scramble = capabilities.vehicleManager and capabilities.partManagement and capabilities.hierarchicalSlots
  capabilities.randomConfig = capabilities.vehicleRegistry
  capabilities.fullRandom = capabilities.scramble and capabilities.randomConfig
  return capabilities
end

local function getCurrentVehicleId()
  if type(be) ~= "table" and type(be) ~= "userdata" then
    return false, errorValue("unsupported_api", "The BeamNG vehicle interface is unavailable")
  end
  return safeCall("be:getPlayerVehicleID", function()
    local vehicleId = be:getPlayerVehicleID(0)
    if type(vehicleId) ~= "number" or vehicleId < 0 then return nil end
    return vehicleId
  end)
end

local function getCurrentVehicleObject()
  if type(getPlayerVehicle) ~= "function" then
    return false, errorValue("unsupported_api", "The active vehicle function is unavailable")
  end
  return safeCall("getPlayerVehicle", function() return getPlayerVehicle(0) end)
end

local function getCurrentVehicleData()
  if type(core_vehicle_manager) ~= "table" or type(core_vehicle_manager.getPlayerVehicleData) ~= "function" then
    return false, errorValue("unsupported_api", "The current vehicle manager is unavailable")
  end
  local ok, data = safeCall("core_vehicle_manager.getPlayerVehicleData", function()
    return core_vehicle_manager.getPlayerVehicleData()
  end)
  if not ok then return false, data end
  if type(data) ~= "table" then return false, errorValue("no_active_vehicle", "No active player vehicle was found") end
  return true, data
end

local function getCurrentModelKey()
  local ok, vehicle = getCurrentVehicleObject()
  if not ok then return false, vehicle end
  if not vehicle then return false, errorValue("no_active_vehicle", "No active player vehicle was found") end
  local success, model = safeCall("vehicle model key", function()
    if type(vehicle.getJBeamFilename) == "function" then return vehicle:getJBeamFilename() end
    return vehicle.JBeam
  end)
  if not success then return false, model end
  if type(model) ~= "string" or model == "" then
    return false, errorValue("invalid_vehicle_data", "The active vehicle has no model key")
  end
  return true, model
end

local function getCurrentConfig()
  if type(core_vehicle_partmgmt) ~= "table" or type(core_vehicle_partmgmt.getConfig) ~= "function" then
    return false, errorValue("unsupported_api", "The current configuration API is unavailable")
  end
  local ok, config = safeCall("core_vehicle_partmgmt.getConfig", function()
    return core_vehicle_partmgmt.getConfig()
  end)
  if not ok then return false, config end
  if type(config) ~= "table" then return false, errorValue("no_active_vehicle", "No active vehicle configuration was found") end
  return true, util.deepCopy(config)
end

local function captureCurrentState(operationType, seed)
  local okId, vehicleId = getCurrentVehicleId()
  if not okId then return false, vehicleId end
  if vehicleId == nil then return false, errorValue("no_active_vehicle", "No active player vehicle was found") end
  local okModel, modelKey = getCurrentModelKey()
  if not okModel then return false, modelKey end
  local okConfig, config = getCurrentConfig()
  if not okConfig then return false, config end
  return true, {
    modelKey = modelKey,
    selectedConfiguration = config.partConfigFilename,
    config = util.deepCopy(config),
    partsTree = util.deepCopy(config.partsTree or {}),
    tuning = util.deepCopy(config.vars or {}),
    paints = util.deepCopy(config.paints or {}),
    seed = seed,
    vehicleId = vehicleId,
    timestamp = os.time(),
    operationType = operationType,
  }
end

local function getRegistryData()
  if type(core_vehicles) ~= "table" or type(core_vehicles.getModelList) ~= "function" or type(core_vehicles.getConfigList) ~= "function" then
    return false, errorValue("unsupported_api", "The BeamNG vehicle registry is unavailable")
  end
  local ok, result = safeCall("vehicle registry", function()
    local modelResult = core_vehicles.getModelList(true)
    local configResult = core_vehicles.getConfigList(true)
    return {
      models = type(modelResult) == "table" and modelResult.models or nil,
      configs = type(configResult) == "table" and configResult.configs or nil,
    }
  end)
  if not ok then return false, result end
  if type(result.models) ~= "table" or type(result.configs) ~= "table" then
    return false, errorValue("invalid_registry", "The vehicle registry returned an unexpected structure")
  end
  return true, util.deepCopy(result)
end

local function replaceVehicle(modelKey, config)
  if type(core_vehicles) ~= "table" or type(core_vehicles.replaceVehicle) ~= "function" then
    return false, errorValue("unsupported_api", "Vehicle replacement is unavailable")
  end
  if type(modelKey) ~= "string" or modelKey == "" then
    return false, errorValue("invalid_model", "A valid vehicle model is required")
  end
  local ok, vehicle = safeCall("core_vehicles.replaceVehicle", function()
    return core_vehicles.replaceVehicle(modelKey, {config = util.deepCopy(config)})
  end)
  if not ok then return false, vehicle end
  return true, vehicle
end

local function applyPartsTree(tree)
  if type(core_vehicle_partmgmt) ~= "table" or type(core_vehicle_partmgmt.setPartsTreeConfig) ~= "function" then
    return false, errorValue("unsupported_api", "Hierarchical part configuration is unavailable")
  end
  if type(tree) ~= "table" then return false, errorValue("invalid_parts_tree", "A valid parts tree is required") end
  local ok, result = safeCall("core_vehicle_partmgmt.setPartsTreeConfig", function()
    return core_vehicle_partmgmt.setPartsTreeConfig(util.deepCopy(tree), true)
  end)
  if not ok then return false, result end
  return true
end

local function applyTuning(values)
  if type(core_vehicle_partmgmt) ~= "table" or type(core_vehicle_partmgmt.setConfigVars) ~= "function" then
    return false, errorValue("unsupported_api", "Tuning application is unavailable")
  end
  local ok, result = safeCall("core_vehicle_partmgmt.setConfigVars", function()
    return core_vehicle_partmgmt.setConfigVars(util.deepCopy(values or {}), true)
  end)
  if not ok then return false, result end
  return true
end

local function applyPaints(paints)
  if type(core_vehicle_partmgmt) ~= "table" or type(core_vehicle_partmgmt.setConfigPaints) ~= "function" then
    return false, errorValue("unsupported_api", "Paint application is unavailable")
  end
  local ok, result = safeCall("core_vehicle_partmgmt.setConfigPaints", function()
    return core_vehicle_partmgmt.setConfigPaints(util.deepCopy(paints or {}), false)
  end)
  if not ok then return false, result end
  return true
end

local function getSlotDefinition(parentPart, slotId)
  local slots = type(parentPart) == "table" and (parentPart.slots2 or parentPart.slots) or nil
  if type(slots) ~= "table" then return nil end
  for _, definition in ipairs(slots) do
    if type(definition) == "table" and (definition.name or definition.type) == slotId then return definition end
  end
  return nil
end

local function getCurrentSlotSnapshot()
  if type(jbeamIO) ~= "table" or type(jbeamIO.getPart) ~= "function" then
    return false, errorValue("unsupported_api", "The current JBeam slot API is unavailable")
  end
  local okData, vehicleData = getCurrentVehicleData()
  if not okData then return false, vehicleData end
  local tree = vehicleData.config and vehicleData.config.partsTree
  if type(tree) ~= "table" then return false, errorValue("missing_parts_tree", "The active vehicle has no hierarchical parts tree") end
  local ok, snapshot = safeCall("hierarchical slot metadata", function()
    local ioCtx = vehicleData.ioCtx
    local availableParts = jbeamIO.getAvailableParts(ioCtx) or {}
    local metadataByPath = {}

    local function visit(parentNode)
      if type(parentNode) ~= "table" then return end
      local parentPart = jbeamIO.getPart(ioCtx, parentNode.chosenPartName)
      for _, childKey in ipairs(util.sortedKeys(parentNode.children or {})) do
        local child = parentNode.children[childKey]
        if type(child) == "table" then
          local definition = getSlotDefinition(parentPart, child.id or childKey) or {}
          local allowTypes = {}
          if type(definition.allowTypes) == "table" then
            allowTypes = util.copyArray(definition.allowTypes)
          elseif type(definition.type) == "string" then
            allowTypes = {definition.type}
          end
          local partInfo = availableParts[child.chosenPartName or ""] or {}
          metadataByPath[child.path] = {
            coreSlot = definition.coreSlot == true,
            required = definition.required == true or definition.coreSlot == true,
            defaultPart = definition.default,
            description = definition.description,
            allowTypes = allowTypes,
            denyTypes = util.copyArray(definition.denyTypes or {}),
            parentPart = parentNode.chosenPartName,
            source = partInfo.modName or partInfo.modID,
          }
          visit(child)
        end
      end
    end
    visit(tree)
    return {
      tree = util.deepCopy(tree),
      metadataByPath = metadataByPath,
      variables = util.deepCopy(vehicleData.vdata and vehicleData.vdata.variables or {}),
      currentTuning = util.deepCopy(vehicleData.config.vars or {}),
      paints = util.deepCopy(vehicleData.config.paints or {}),
      ioContextAvailable = ioCtx ~= nil,
    }
  end)
  if not ok then return false, snapshot end
  return true, snapshot
end

local function getTuningSnapshot()
  local ok, data = getCurrentVehicleData()
  if not ok then return false, data end
  return true, {
    variables = util.deepCopy(data.vdata and data.vdata.variables or {}),
    values = util.deepCopy(data.config and data.config.vars or {}),
  }
end

local function getPaints()
  local ok, config = getCurrentConfig()
  if not ok then return false, config end
  return true, util.deepCopy(config.paints or {})
end

local function emit(eventName, payload)
  if type(guihooks) ~= "table" or type(guihooks.trigger) ~= "function" then return false end
  local ok = pcall(guihooks.trigger, eventName, util.deepCopy(payload or {}))
  return ok
end

local function notify(message, icon, ttl)
  return emit("Message", {
    msg = tostring(message or ""),
    icon = icon or "info",
    ttl = tonumber(ttl) or 5,
    category = "soturineChaosRandomizer",
  })
end

local function loadSettings()
  if type(jsonReadFile) ~= "function" then return false, errorValue("unsupported_api", "JSON settings are unavailable") end
  local ok, value = safeCall("jsonReadFile settings", function()
    local user = jsonReadFile(SETTINGS_PATH)
    if type(user) == "table" then return user, "user" end
    local defaults = jsonReadFile(DEFAULTS_PATH)
    return defaults, "defaults"
  end)
  if not ok then return false, value end
  if type(value) ~= "table" then return false, errorValue("invalid_settings", "Settings are missing or malformed") end
  return true, util.deepCopy(value)
end

local function saveSettings(settings)
  if type(jsonWriteFile) ~= "function" then return false, errorValue("unsupported_api", "JSON settings persistence is unavailable") end
  local ok, result = safeCall("jsonWriteFile settings", function()
    return jsonWriteFile(SETTINGS_PATH, util.deepCopy(settings), true)
  end)
  if not ok then return false, result end
  if result == false then return false, errorValue("settings_write_failed", "BeamNG could not save Chaos Randomizer settings") end
  return true
end

local function logRecord(level, event, details)
  if type(log) ~= "function" then return end
  local detailText = ""
  if type(details) == "table" and next(details) ~= nil then
    if type(jsonEncode) == "function" then
      local ok, encoded = pcall(jsonEncode, details)
      detailText = ok and (" " .. tostring(encoded)) or ""
    else
      detailText = " " .. tostring(details)
    end
  end
  log(level or "D", LOG_TAG, tostring(event or "event") .. detailText)
end

local function clock()
  if type(os.clockhp) == "function" then return os.clockhp() end
  return os.clock()
end

local function entropy()
  local vehicleId = -1
  local ok, id = getCurrentVehicleId()
  if ok and id then vehicleId = id end
  return table.concat({tostring(os.time()), tostring(clock()), tostring(vehicleId)}, ":")
end

local function getGameVersion()
  return tostring(beamng_versiond or beamng_version or "unknown")
end

M.errorValue = errorValue
M.getCapabilities = getCapabilities
M.getCurrentVehicleId = getCurrentVehicleId
M.getCurrentVehicleObject = getCurrentVehicleObject
M.getCurrentVehicleData = getCurrentVehicleData
M.getCurrentModelKey = getCurrentModelKey
M.getCurrentConfig = getCurrentConfig
M.captureCurrentState = captureCurrentState
M.getRegistryData = getRegistryData
M.replaceVehicle = replaceVehicle
M.applyPartsTree = applyPartsTree
M.applyTuning = applyTuning
M.applyPaints = applyPaints
M.getCurrentSlotSnapshot = getCurrentSlotSnapshot
M.getTuningSnapshot = getTuningSnapshot
M.getPaints = getPaints
M.emit = emit
M.notify = notify
M.loadSettings = loadSettings
M.saveSettings = saveSettings
M.logRecord = logRecord
M.clock = clock
M.entropy = entropy
M.getGameVersion = getGameVersion

return M
