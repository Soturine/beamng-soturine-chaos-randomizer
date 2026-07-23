local util = require("ge/extensions/soturineChaosRandomizer/util")
local capabilityModel = require("ge/extensions/soturineChaosRandomizer/capabilities")
local configVerification = require("ge/extensions/soturineChaosRandomizer/configVerification")
local paintVerification = require("ge/extensions/soturineChaosRandomizer/paintVerification")
local validator = require("ge/extensions/soturineChaosRandomizer/validator")

local M = {}

local LOG_TAG = "SoturineChaosRandomizer"
local SETTINGS_PATH = "/settings/soturineChaosRandomizer/settings.json"
local DEFAULTS_PATH = "/settings/soturineChaosRandomizer/defaults.json"
local DNA_LIBRARY_PATH = "/settings/soturineChaosRandomizer/vehicleDNA/library.json"
local DNA_BACKUP_PATH = "/settings/soturineChaosRandomizer/vehicleDNA/library.last-known-good.json"
local DNA_EXPORT_PATH = "/settings/soturineChaosRandomizer/vehicleDNA/share/export.vdna.json"
local DNA_PACKAGE_EXPORT_PATH = "/settings/soturineChaosRandomizer/vehicleDNA/share/export.vdna.zip"
local DNA_PACKAGE_INBOX_PATH = "/settings/soturineChaosRandomizer/vehicleDNA/inbox/import.vdna.zip"
local DNA_THUMBNAIL_DIRECTORY = "/settings/soturineChaosRandomizer/vehicleDNA/thumbnails/"

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

local function callContract(name, failureCode, contract, callback)
  local ok, value, extra = pcall(callback)
  if not ok then
    return false, errorValue(failureCode, "BeamNG API call failed: " .. name, {
      detail = tostring(value),
      thrown = true,
      contract = contract,
    })
  end
  if value == false then
    return false, errorValue(failureCode, "BeamNG rejected the write: " .. name, {
      result = false,
      contract = contract,
    })
  end
  if contract == "object_required" and value == nil then
    return false, errorValue(failureCode, "BeamNG did not return the required vehicle object: " .. name, {
      result = "nil",
      contract = contract,
    })
  end
  return true, {
    value = value,
    extra = extra,
    confirmationRequired = contract == "nil_then_event",
    contract = contract,
  }
end

local function getCapabilities()
  local vehicleManager = type(core_vehicle_manager) == "table"
    and type(core_vehicle_manager.getPlayerVehicleData) == "function"
  local configRead = type(core_vehicle_partmgmt) == "table"
    and type(core_vehicle_partmgmt.getConfig) == "function"
  local hierarchicalRead = type(jbeamIO) == "table"
    and type(jbeamIO.getPart) == "function"
    and type(jbeamIO.getAvailableParts) == "function"
  local jsonRead = type(jsonReadFile) == "function"
  local jsonWrite = type(jsonWriteFile) == "function"
  local raw = {
    vehicleRegistry = type(core_vehicles) == "table"
      and type(core_vehicles.getModelList) == "function"
      and type(core_vehicles.getConfigList) == "function",
    vehicleReplace = type(core_vehicles) == "table" and type(core_vehicles.replaceVehicle) == "function"
      and type(getObjectByID) == "function",
    partsRead = vehicleManager and configRead and hierarchicalRead,
    partsWrite = type(core_vehicle_partmgmt) == "table"
      and type(core_vehicle_partmgmt.setPartsTreeConfig) == "function",
    tuningRead = vehicleManager and configRead,
    tuningWrite = type(core_vehicle_partmgmt) == "table"
      and type(core_vehicle_partmgmt.setConfigVars) == "function",
    paintRead = configRead,
    paintWrite = type(core_vehicle_partmgmt) == "table"
      and type(core_vehicle_partmgmt.setConfigPaints) == "function",
    settingsRead = jsonRead,
    settingsWrite = jsonWrite,
    settingsPersistence = jsonRead and jsonWrite,
    dnaRead = jsonRead,
    dnaWrite = jsonRead and jsonWrite,
    dnaExportFile = jsonWrite,
    dnaBackup = jsonRead and jsonWrite,
    dnaPackageWrite = type(hashStringSHA256) == "function" and type(io) == "table" and FS ~= nil,
    dnaPackageRead = type(hashStringSHA256) == "function" and type(io) == "table" and FS ~= nil,
    thumbnailCapture = type(extensions) == "table" and type(extensions.load) == "function"
      and type(getObjectByID) == "function" and FS ~= nil,
    thumbnailDelete = FS ~= nil,
    uiEvents = type(guihooks) == "table" and type(guihooks.trigger) == "function",
    lifecycleConfirmation = type(extensions) == "table" and type(extensions.hook) == "function",
  }
  return capabilityModel.derive(raw)
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
    selectedConfiguration = configVerification.normalizePath(config.partConfigFilename),
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
  result = util.deepCopy(result)
  local modManager = type(core_modmanager) == "table" and core_modmanager
    or type(extensions) == "table" and extensions.core_modmanager
  if type(modManager) == "table" and type(modManager.getModFromPath) == "function" then
    for _, config in pairs(result.configs) do
      local label = type(config) == "table" and util.normalizeText(config.Source or config.source) or ""
      local hasExplicitSource = type(config) == "table" and (
        config.userSaved == true or config.player == true or config.modID ~= nil or config.modId ~= nil
        or label == "custom" or label == "mod" or label == "beamng - official" or label == "official"
      )
      if type(config) == "table" and type(config.pcFilename) == "string" and not hasExplicitSource then
        local owned, mod = pcall(modManager.getModFromPath, config.pcFilename)
        if owned and type(mod) == "table" then
          config.pathOwnership = {
            kind = "mod",
            modID = mod.modID,
            modName = mod.modname,
            sourceLabel = mod.modData and mod.modData.title or mod.modname,
            strategy = "core_modmanager.getModFromPath",
          }
        end
      end
    end
  end
  return true, result
end

local function vehicleObjectId(vehicle)
  if type(vehicle) ~= "table" and type(vehicle) ~= "userdata" then return nil end
  for _, methodName in ipairs({"getID", "getId"}) do
    local readable, method = pcall(function() return vehicle[methodName] end)
    if readable and type(method) == "function" then
      local ok, value = pcall(method, vehicle)
      if ok and type(value) == "number" and value >= 0 then return value, methodName .. "()" end
    end
  end
  local readable, value = pcall(function() return vehicle.id or vehicle.ID end)
  if not readable then return nil end
  if type(value) == "number" and value >= 0 then return value, "id_field" end
  return nil
end

local function replaceVehicle(modelKey, config, targetVehicleId)
  if type(core_vehicles) ~= "table" or type(core_vehicles.replaceVehicle) ~= "function" then
    return false, errorValue("unsupported_api", "Vehicle replacement is unavailable")
  end
  if type(modelKey) ~= "string" or modelKey == "" then
    return false, errorValue("invalid_model", "A valid vehicle model is required")
  end
  local targetVehicle
  if targetVehicleId ~= nil then
    if type(targetVehicleId) ~= "number" or type(getObjectByID) ~= "function" then
      return false, errorValue("vehicle_replace_target_unavailable", "The exact replacement target is unavailable", {
        targetVehicleId = targetVehicleId,
      })
    end
    local resolved, value = pcall(getObjectByID, targetVehicleId)
    if not resolved or value == nil then
      return false, errorValue("vehicle_replace_target_unavailable", "The exact replacement target no longer exists", {
        targetVehicleId = targetVehicleId,
      })
    end
    targetVehicle = value
  end
  local ok, result = callContract("core_vehicles.replaceVehicle", "vehicle_replace_rejected", "object_required", function()
    return core_vehicles.replaceVehicle(modelKey, {config = util.deepCopy(config)}, targetVehicle)
  end)
  if not ok then return false, result end
  local vehicleId, strategy = vehicleObjectId(result.value)
  if vehicleId == nil then
    return false, errorValue("vehicle_replace_target_ambiguous", "BeamNG returned a vehicle without a usable target ID", {
      contract = result.contract,
    })
  end
  result.vehicleId = vehicleId
  result.correlationStrategy = "returned_vehicle_object." .. strategy
  result.requestedTargetVehicleId = targetVehicleId
  return true, result
end

local function applyPartsTree(tree)
  if type(core_vehicle_partmgmt) ~= "table" or type(core_vehicle_partmgmt.setPartsTreeConfig) ~= "function" then
    return false, errorValue("unsupported_api", "Hierarchical part configuration is unavailable")
  end
  if type(tree) ~= "table" then return false, errorValue("invalid_parts_tree", "A valid parts tree is required") end
  local ok, result = callContract("core_vehicle_partmgmt.setPartsTreeConfig", "parts_apply_rejected", "nil_then_event", function()
    return core_vehicle_partmgmt.setPartsTreeConfig(util.deepCopy(tree), true)
  end)
  if not ok then return false, result end
  return true, result
end

local function applyTuning(values)
  if type(core_vehicle_partmgmt) ~= "table" or type(core_vehicle_partmgmt.setConfigVars) ~= "function" then
    return false, errorValue("unsupported_api", "Tuning application is unavailable")
  end
  local ok, result = callContract("core_vehicle_partmgmt.setConfigVars", "tuning_apply_rejected", "nil_then_event", function()
    return core_vehicle_partmgmt.setConfigVars(util.deepCopy(values or {}), true)
  end)
  if not ok then return false, result end
  return true, result
end

local function applyPaints(paints)
  if type(core_vehicle_partmgmt) ~= "table" or type(core_vehicle_partmgmt.setConfigPaints) ~= "function" then
    return false, errorValue("unsupported_api", "Paint application is unavailable")
  end
  local expected, normalizationError = paintVerification.normalizePaints(paints or {})
  if not expected then
    return false, errorValue("paint_data_invalid", "Paint data could not be normalized", {reason = normalizationError})
  end
  local payload = util.deepCopy(paints or {})
  local ok, result = callContract("core_vehicle_partmgmt.setConfigPaints", "paint_apply_rejected", "nil_then_readback", function()
    return core_vehicle_partmgmt.setConfigPaints(payload, false)
  end)
  if not ok then return false, result end
  local okConfig, config = getCurrentConfig()
  if not okConfig then
    result.confirmationRequired = true
    result.verified = false
    result.expected = expected
    result.readbackReason = "immediate_readback_unavailable"
    result.readbackError = config
    return true, result
  end
  local verified, reason = paintVerification.compare(expected, config.paints or {})
  if not verified then
    result.confirmationRequired = true
    result.verified = false
    result.expected = expected
    result.readbackReason = reason
    return true, result
  end
  result.confirmationRequired = false
  result.verified = true
  result.expected = expected
  result.readbackReason = reason
  return true, result
end

local function verifyPaints(expected)
  local okConfig, config = getCurrentConfig()
  if not okConfig then return false, "paint_readback_unavailable", config end
  local matches, reason = paintVerification.compare(expected or {}, config.paints or {})
  return matches, reason, util.deepCopy(config.paints or {})
end

local function flattenChosenParts(tree)
  local result = {}
  local function visit(node)
    for _, key in ipairs(util.sortedKeys(type(node) == "table" and node.children or {})) do
      local child = node.children[key]
      if type(child) == "table" then
        result[child.path or tostring(key)] = child.chosenPartName or ""
        visit(child)
      end
    end
  end
  visit(tree)
  return result
end

local function getVerificationState()
  local okId, vehicleId = getCurrentVehicleId()
  if not okId then return false, vehicleId end
  local okModel, modelKey = getCurrentModelKey()
  if not okModel then return false, modelKey end
  local okConfig, config = getCurrentConfig()
  if not okConfig then return false, config end
  return true, {
    vehicleId = vehicleId,
    modelKey = modelKey,
    configKey = config.partConfigFilename,
    configIdentity = {
      path = configVerification.normalizePath(config.partConfigFilename),
      key = configVerification.stableKey(config.partConfigFilename),
      signature = configVerification.signature(config),
    },
    parts = flattenChosenParts(config.partsTree or {}),
    tuning = util.deepCopy(config.vars or {}),
    paints = util.deepCopy(config.paints or {}),
  }
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
    local candidateCache = {}

    local function candidateSource(partName, partInfo, partData)
      partInfo = type(partInfo) == "table" and partInfo or {}
      partData = type(partData) == "table" and partData or {}
      local modID = partInfo.modID or partData.modID
      local modName = partInfo.modName or partData.modName
      local sourceLabel = partInfo.Source or partInfo.source or partData.Source or partData.source
      local sourceKind = "unknown"
      if modID ~= nil or modName ~= nil then
        sourceKind = "mod"
        sourceLabel = sourceLabel or modName
      elseif util.normalizeText(sourceLabel) == "beamng - official" or util.normalizeText(sourceLabel) == "official" then
        sourceKind = "official"
      end
      local functional = validator.evidenceFromPart(partData)
      return {
        partName = partName,
        sourceKind = sourceKind,
        sourceLabel = sourceLabel or "Unknown",
        modID = modID,
        path = partInfo.filename or partInfo.sourceFile or partData.filename or partData.sourceFile,
        roles = functional.roles,
        evidence = functional.evidence,
        heuristic = functional.heuristic,
      }
    end

    local function metadataForCandidate(candidate)
      if candidateCache[candidate] then return candidateCache[candidate] end
      local candidatePart = jbeamIO.getPart(ioCtx, candidate) or {}
      candidateCache[candidate] = candidateSource(candidate, availableParts[candidate], candidatePart)
      return candidateCache[candidate]
    end

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
          local candidateMetadata = {}
          for _, candidate in ipairs(child.suitablePartNames or {}) do
            if type(candidate) == "string" and candidate ~= "" then
              candidateMetadata[candidate] = metadataForCandidate(candidate)
            end
          end
          if child.chosenPartName and child.chosenPartName ~= "" and not candidateMetadata[child.chosenPartName] then
            candidateMetadata[child.chosenPartName] = metadataForCandidate(child.chosenPartName)
          end
          metadataByPath[child.path] = {
            coreSlot = definition.coreSlot == true,
            required = definition.required == true or definition.coreSlot == true,
            defaultPart = definition.default,
            description = definition.description,
            allowTypes = allowTypes,
            denyTypes = util.copyArray(definition.denyTypes or {}),
            parentPart = parentNode.chosenPartName,
            candidateMetadata = candidateMetadata,
          }
          visit(child)
        end
      end
    end
    visit(tree)
    local modelMetadata = {}
    if type(core_vehicles) == "table" and type(core_vehicles.getModel) == "function" then
      local modelRecord = core_vehicles.getModel(vehicleData.model or (vehicleData.vehicleObj and vehicleData.vehicleObj.JBeam))
      local model = type(modelRecord) == "table" and (modelRecord.model or modelRecord) or {}
      modelMetadata = {
        type = model.type or model.Type or model.Category or model.category,
        isAutomation = model.isAutomation,
        isTrailer = model.isTrailer,
        isProp = model.isProp,
      }
    end
    return {
      tree = util.deepCopy(tree),
      metadataByPath = metadataByPath,
      variables = util.deepCopy(vehicleData.vdata and vehicleData.vdata.variables or {}),
      currentTuning = util.deepCopy(vehicleData.config.vars or {}),
      paints = util.deepCopy(vehicleData.config.paints or {}),
      modelMetadata = modelMetadata,
      ioContextAvailable = ioCtx ~= nil,
    }
  end)
  if not ok then return false, snapshot end
  return true, snapshot
end

local function prepareConfigExpectation(configRecord)
  configRecord = type(configRecord) == "table" and configRecord or {}
  local pathValue = configRecord.path or (configRecord.raw and configRecord.raw.pcFilename)
  local loadedConfig
  if type(pathValue) == "string" and type(jsonReadFile) == "function" then
    local ok, value = pcall(jsonReadFile, pathValue)
    if ok and type(value) == "table" then loadedConfig = value end
  end
  return configVerification.expectation(configRecord, loadedConfig)
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
    return jsonWriteFile(SETTINGS_PATH, util.deepCopy(settings), true, nil, true)
  end)
  if not ok then return false, result end
  if result == false then return false, errorValue("settings_write_failed", "BeamNG could not save Chaos Randomizer settings") end
  return true
end

local function loadDNALibrary()
  if type(jsonReadFile) ~= "function" then
    return false, errorValue("dna_storage_unavailable", "Vehicle DNA JSON storage is unavailable")
  end
  local ok, result = safeCall("jsonReadFile Vehicle DNA library", function()
    local primary = jsonReadFile(DNA_LIBRARY_PATH)
    if type(primary) == "table" then return {value = primary, source = "primary"} end
    local backup = jsonReadFile(DNA_BACKUP_PATH)
    if type(backup) == "table" then return {value = backup, source = "last_known_good"} end
    return {value = nil, source = "missing"}
  end)
  if not ok then return false, result end
  return true, util.deepCopy(result.value), result.source
end

local function loadDNALibraryBackup()
  if type(jsonReadFile) ~= "function" then
    return false, errorValue("dna_storage_unavailable", "Vehicle DNA JSON storage is unavailable")
  end
  local ok, result = safeCall("jsonReadFile Vehicle DNA last-known-good", function()
    return jsonReadFile(DNA_BACKUP_PATH)
  end)
  if not ok then return false, result end
  return true, type(result) == "table" and util.deepCopy(result) or nil
end

local function saveDNALibrary(library, lastKnownGood)
  if type(jsonReadFile) ~= "function" or type(jsonWriteFile) ~= "function" then
    return false, errorValue("dna_storage_unavailable", "Vehicle DNA JSON storage is unavailable")
  end
  if type(library) ~= "table" then return false, errorValue("dna_library_invalid", "Vehicle DNA library data is invalid") end
  local function write(path, value)
    local ok, result = pcall(jsonWriteFile, path, util.deepCopy(value), true, nil, true)
    return ok and result ~= false
  end
  local function read(path)
    local ok, result = pcall(jsonReadFile, path)
    return ok and result or nil
  end
  local function recover(cause)
    if type(lastKnownGood) ~= "table" or not write(DNA_LIBRARY_PATH, lastKnownGood) then
      return false, errorValue("dna_storage_recovery_failed", "Vehicle DNA storage failed and last-known-good could not be restored", {cause = cause})
    end
    local recovered = read(DNA_LIBRARY_PATH)
    if type(recovered) ~= "table" or not util.deepEqual(recovered, lastKnownGood, 1e-10) then
      return false, errorValue("dna_storage_recovery_failed", "Vehicle DNA last-known-good read-back failed", {cause = cause})
    end
    return false, errorValue("dna_storage_recovered", "Vehicle DNA write failed; last-known-good was restored", {
      cause = cause, recovered = true, revision = recovered.revision,
    })
  end
  if type(lastKnownGood) == "table" and not write(DNA_BACKUP_PATH, lastKnownGood) then
    local primary = read(DNA_LIBRARY_PATH)
    if type(primary) == "table" and util.deepEqual(primary, lastKnownGood, 1e-10) then
      return false, errorValue("dna_storage_recovered", "Vehicle DNA backup write failed; primary remained at last-known-good", {
        cause = "dna_storage_backup_write_failed", recovered = true, revision = primary.revision,
      })
    end
    return recover("dna_storage_backup_write_failed")
  end
  if not write(DNA_LIBRARY_PATH, library) then return recover("dna_storage_primary_write_failed") end
  local readback = read(DNA_LIBRARY_PATH)
  if type(readback) ~= "table" or not util.deepEqual(readback, library, 1e-10) then
    return recover("dna_storage_primary_readback_failed")
  end
  return true, {path = DNA_LIBRARY_PATH, backupPath = DNA_BACKUP_PATH, verified = true}
end

local function encodeJSON(value, pretty)
  local encoder = pretty and jsonEncodePretty or jsonEncode
  if type(encoder) ~= "function" then return false, errorValue("dna_export_unavailable", "JSON encoding is unavailable") end
  local ok, encoded = safeCall("Vehicle DNA JSON encode", function() return encoder(util.deepCopy(value)) end)
  if not ok then return false, encoded end
  if type(encoded) ~= "string" then return false, errorValue("dna_export_failed", "Vehicle DNA JSON encoding failed") end
  return true, encoded
end

local function decodeJSON(value)
  if type(jsonDecode) ~= "function" or type(value) ~= "string" then
    return false, errorValue("dna_import_unavailable", "JSON decoding is unavailable")
  end
  local ok, decoded = safeCall("Vehicle DNA JSON decode", function() return jsonDecode(value) end)
  if not ok then return false, decoded end
  if type(decoded) ~= "table" then return false, errorValue("dna_import_invalid", "Decoded JSON is not an object") end
  return true, decoded
end

local function sha256(value)
  if type(hashStringSHA256) ~= "function" or type(value) ~= "string" then
    return false, errorValue("checksum_unavailable", "SHA-256 is unavailable")
  end
  local ok, digest = safeCall("hashStringSHA256", function() return hashStringSHA256(value) end)
  if not ok then return false, digest end
  digest = tostring(digest or ""):lower()
  if not digest:match("^[0-9a-f]+$") or #digest ~= 64 then
    return false, errorValue("checksum_invalid", "BeamNG returned an invalid SHA-256 digest")
  end
  return true, digest
end

local function userRealPath(virtualPath, directory)
  if FS == nil or type(virtualPath) ~= "string" or virtualPath:find("..", 1, true)
    or not virtualPath:match("^/settings/soturineChaosRandomizer/vehicleDNA/")
  then return nil, errorValue("controlled_path_invalid", "The controlled Vehicle DNA path is invalid") end
  local ok, result = safeCall("FS:getUserPath", function()
    local root = FS:getUserPath()
    if type(root) ~= "string" or root == "" then return nil end
    if directory and type(FS.directoryCreate) == "function" then FS:directoryCreate(directory, true) end
    local separator = package.config and package.config:sub(1, 1) or "/"
    local relative = virtualPath:gsub("^/", ""):gsub("/", separator)
    if root:sub(-1) ~= "/" and root:sub(-1) ~= "\\" then root = root .. separator end
    return root .. relative
  end)
  if not ok or type(result) ~= "string" then return nil, result end
  return result
end

local function writeControlledBinary(virtualPath, directory, data)
  if type(io) ~= "table" or type(io.open) ~= "function" or type(data) ~= "string" then
    return false, errorValue("binary_write_unavailable", "Controlled binary writing is unavailable")
  end
  local realPath, pathError = userRealPath(virtualPath, directory)
  if not realPath then return false, pathError end
  local ok, result = safeCall("controlled binary write", function()
    local file = io.open(realPath, "wb")
    if not file then return false end
    local written = file:write(data)
    file:close()
    if not written then return false end
    local readback = io.open(realPath, "rb")
    if not readback then return false end
    local observed = readback:read("*all")
    readback:close()
    return observed == data
  end)
  if not ok or result ~= true then return false, errorValue("binary_write_failed", "Controlled binary write/read-back failed") end
  return true, {path = virtualPath, bytes = #data}
end

local function readControlledBinary(virtualPath, maximum)
  if type(io) ~= "table" or type(io.open) ~= "function" then
    return false, errorValue("binary_read_unavailable", "Controlled binary reading is unavailable")
  end
  local realPath, pathError = userRealPath(virtualPath)
  if not realPath then return false, pathError end
  local ok, result = safeCall("controlled binary read", function()
    local file = io.open(realPath, "rb")
    if not file then return nil end
    local value = file:read((maximum or 524288) + 1)
    file:close()
    return value
  end)
  if not ok then return false, result end
  if type(result) ~= "string" then return false, errorValue("controlled_file_missing", "The controlled file does not exist") end
  if #result > (maximum or 524288) then return false, errorValue("controlled_file_size_limit", "The controlled file exceeds its size limit") end
  return true, result
end

local function exportDNAPackage(data)
  return writeControlledBinary(DNA_PACKAGE_EXPORT_PATH, "/settings/soturineChaosRandomizer/vehicleDNA/share/", data)
end

local function importDNAPackage()
  return readControlledBinary(DNA_PACKAGE_INBOX_PATH, 524288)
end

local function thumbnailPath(id)
  local safe = tostring(id or ""):gsub("[^A-Za-z0-9_-]", "-"):sub(1, 96)
  if safe == "" then return nil end
  return DNA_THUMBNAIL_DIRECTORY .. safe .. ".png"
end

local function captureDNAThumbnail(id, callback)
  local virtualPath = thumbnailPath(id)
  if not virtualPath or type(callback) ~= "function" or type(extensions) ~= "table" or type(extensions.load) ~= "function" then
    return false, errorValue("thumbnail_capture_unavailable", "Thumbnail capture is unavailable")
  end
  pcall(extensions.load, "render_renderViews")
  pcall(extensions.load, "util_screenshotCreator")
  if type(render_renderViews) ~= "table" or type(render_renderViews.takeScreenshot) ~= "function"
    or type(util_screenshotCreator) ~= "table" or type(util_screenshotCreator.frameVehicle) ~= "function"
    or type(vec3) ~= "function" or type(quatFromDir) ~= "function"
  then return false, errorValue("thumbnail_capture_unavailable", "The inspected screenshot chain is unavailable") end
  local okVehicle, vehicleId = getCurrentVehicleId()
  local vehicle = okVehicle and getObjectByID(vehicleId) or nil
  if not vehicle or type(vehicle.getSpawnWorldOOBB) ~= "function" then
    return false, errorValue("thumbnail_vehicle_unavailable", "No active vehicle is available for thumbnail capture")
  end
  local realPath, pathError = userRealPath(virtualPath, DNA_THUMBNAIL_DIRECTORY)
  if not realPath then return false, pathError end
  local ok, result = safeCall("bounded Vehicle DNA thumbnail capture", function()
    local box = vehicle:getSpawnWorldOOBB()
    local center = box:getCenter()
    local resolution, fov, nearPlane = vec3(500, 281, 0), 50, 0.1
    local position = util_screenshotCreator.frameVehicle(vehicle, fov, nearPlane, resolution.x / resolution.y)
    render_renderViews.takeScreenshot({
      pos = position,
      rot = quatFromDir(center - position),
      filename = realPath,
      renderViewName = "soturineVehicleDNAThumbnail",
      resolution = resolution,
      fov = fov,
      nearPlane = nearPlane,
      screenshotDelay = 0.5,
    }, function()
      local readOk, data = readControlledBinary(virtualPath, 262144)
      callback(readOk, readOk and {path = virtualPath, data = data, bytes = #data} or data)
    end)
    return true
  end)
  if not ok or result ~= true then return false, result end
  return true, {pending = true, path = virtualPath}
end

local function removeDNAThumbnail(id)
  local virtualPath = thumbnailPath(id)
  if not virtualPath or FS == nil or type(FS.removeFile) ~= "function" then
    return false, errorValue("thumbnail_delete_unavailable", "Thumbnail deletion is unavailable")
  end
  local ok, result = safeCall("FS:removeFile Vehicle DNA thumbnail", function()
    if type(FS.fileExists) == "function" and not FS:fileExists(virtualPath) then return true end
    local removed = FS:removeFile(virtualPath)
    return removed == 0 or removed == true
  end)
  if not ok or result ~= true then return false, errorValue("thumbnail_delete_failed", "Managed thumbnail could not be removed") end
  return true, {path = virtualPath}
end

local function exportDNAFile(entry)
  if type(jsonWriteFile) ~= "function" then return false, errorValue("dna_export_unavailable", "Vehicle DNA file export is unavailable") end
  local ok, result = safeCall("jsonWriteFile Vehicle DNA export", function()
    return jsonWriteFile(DNA_EXPORT_PATH, util.deepCopy(entry), true, nil, true)
  end)
  if not ok then return false, result end
  if result == false then return false, errorValue("dna_export_failed", "Vehicle DNA file export failed") end
  return true, {path = DNA_EXPORT_PATH}
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
M.verifyPaints = verifyPaints
M.prepareConfigExpectation = prepareConfigExpectation
M.getCurrentSlotSnapshot = getCurrentSlotSnapshot
M.getTuningSnapshot = getTuningSnapshot
M.getPaints = getPaints
M.emit = emit
M.notify = notify
M.loadSettings = loadSettings
M.saveSettings = saveSettings
M.loadDNALibrary = loadDNALibrary
M.loadDNALibraryBackup = loadDNALibraryBackup
M.saveDNALibrary = saveDNALibrary
M.encodeJSON = encodeJSON
M.decodeJSON = decodeJSON
M.sha256 = sha256
M.exportDNAFile = exportDNAFile
M.exportDNAPackage = exportDNAPackage
M.importDNAPackage = importDNAPackage
M.captureDNAThumbnail = captureDNAThumbnail
M.removeDNAThumbnail = removeDNAThumbnail
M.logRecord = logRecord
M.clock = clock
M.entropy = entropy
M.getGameVersion = getGameVersion
M.getVerificationState = getVerificationState
M.flattenChosenParts = flattenChosenParts
M._callContract = callContract
M._vehicleObjectId = vehicleObjectId
M.DNA_LIBRARY_PATH = DNA_LIBRARY_PATH
M.DNA_BACKUP_PATH = DNA_BACKUP_PATH
M.DNA_EXPORT_PATH = DNA_EXPORT_PATH
M.DNA_PACKAGE_EXPORT_PATH = DNA_PACKAGE_EXPORT_PATH
M.DNA_PACKAGE_INBOX_PATH = DNA_PACKAGE_INBOX_PATH
M.DNA_THUMBNAIL_DIRECTORY = DNA_THUMBNAIL_DIRECTORY

return M
