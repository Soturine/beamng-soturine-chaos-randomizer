local util = require("ge/extensions/soturineChaosRandomizer/util")
local configVerification = require("ge/extensions/soturineChaosRandomizer/configVerification")

local M = {}

local ADAPTER_PATH = "ge/extensions/soturineChaosRandomizer/apiAdapter"
local MAIN_PATH = "ge/extensions/soturineChaosRandomizer/main"

local function vehicleObject(id)
  return {getID = function() return id end}
end

local function flatten(tree)
  local result = {}
  local function visit(node)
    for _, key in ipairs(util.sortedKeys(type(node) == "table" and node.children or {})) do
      local child = node.children[key]
      result[child.path or tostring(key)] = child.chosenPartName or ""
      visit(child)
    end
  end
  visit(tree)
  return result
end

local function baseTree()
  return {
    chosenPartName = "fixture_root",
    children = {
      body = {
        id = "body",
        path = "/body/",
        chosenPartName = "body_a",
        suitablePartNames = {"body_a", "body_b"},
        children = {},
      },
    },
  }
end

local function partMetadata()
  return {
    ["/body/"] = {
      candidateMetadata = {
        body_a = {sourceKind = "official", sourceLabel = "BeamNG - Official", roles = {}},
        body_b = {sourceKind = "mod", sourceLabel = "Fixture Parts", modID = "fixture_parts", roles = {}},
      },
    },
  }
end

local function new(options)
  options = type(options) == "table" and options or {}
  local harness = {
    now = 0,
    vehicleId = options.vehicleId or 1,
    returnedVehicleId = options.returnedVehicleId or options.vehicleId or 1,
    modelKey = "fixture_old",
    configPath = "/vehicles/fixture_old/original.pc",
    tree = baseTree(),
    metadata = partMetadata(),
    tuning = {boost = 0.5},
    tuningMinimum = 0,
    tuningMaximum = 1,
    paints = {{baseColor = {0.2, 0.3, 0.4, 1}, metallic = 0.2, roughness = 0.5, clearcoat = 0.8, clearcoatRoughness = 0}},
    calls = {},
    emitted = {},
    options = options,
    pendingReplacement = nil,
    pendingParts = nil,
    pendingTuning = nil,
    original = nil,
  }
  if options.emptyOptional then
    harness.tree.children.optional = {
      id = "optional", path = "/optional/", chosenPartName = "", suitablePartNames = {}, children = {},
    }
  end

  local capabilities = {
    randomConfig = true,
    scramble = true,
    fullRandom = true,
    undo = true,
    developerStress = true,
    scrambleParts = true,
    scrambleTuning = options.tuningUnavailable ~= true,
    scramblePaint = options.paintUnavailable ~= true,
    warnings = {},
    dnaRead = true,
    dnaWrite = true,
    dnaList = true,
    dnaDelete = true,
    dnaImportText = true,
    dnaExportFile = true,
    dnaBackup = true,
  }
  if options.tuningUnavailable then capabilities.warnings[#capabilities.warnings + 1] = "Tuning unavailable." end
  if options.paintUnavailable then capabilities.warnings[#capabilities.warnings + 1] = "Paint unavailable." end

  local adapter = {}
  function adapter.clock() return harness.now end
  function adapter.logRecord() end
  function adapter.errorValue(code, message, context) return {code = code, message = message, context = context or {}} end
  function adapter.getCapabilities() return util.deepCopy(capabilities) end
  function adapter.loadSettings() return true, {} end
  function adapter.saveSettings() return true end
  function adapter.loadDNALibrary() return true, util.deepCopy(harness.library), harness.library and "primary" or "missing" end
  function adapter.loadDNALibraryBackup() return true, util.deepCopy(harness.backupLibrary) end
  function adapter.saveDNALibrary(value, previous) harness.backupLibrary = util.deepCopy(previous); harness.library = util.deepCopy(value); return true, {verified = true} end
  function adapter.encodeJSON() return true, "{\"kind\":\"soturineVehicleDNA\"}" end
  function adapter.exportDNAFile() return true, {path = "/settings/fixture/export.json"} end
  adapter.DNA_LIBRARY_PATH = "/settings/fixture/library.json"
  function adapter.getGameVersion() return "fixture" end
  function adapter.entropy() return "fixture-entropy" end
  function adapter.emit(name, payload)
    harness.emitted[#harness.emitted + 1] = {name = name, payload = util.deepCopy(payload)}
    harness.lastState = util.deepCopy(payload)
    return true
  end
  function adapter.notify() return true end
  function adapter.getRegistryData()
    harness.calls[#harness.calls + 1] = "registry"
    return true, {
      models = {
        fixture_new = {key = "fixture_new", Name = "Fixture New", Source = "BeamNG - Official", Type = options.modelType or "Car"},
      },
      configs = {
        fixture_new_base = {
          model_key = "fixture_new",
          key = "base_version",
          Configuration = "Base Version",
          Source = "BeamNG - Official",
          pcFilename = "/vehicles/fixture_new/base_version.pc",
        },
      },
    }
  end
  function adapter.getCurrentVehicleId() return true, harness.vehicleId end
  function adapter.getCurrentModelKey() return true, harness.modelKey end
  function adapter.getCurrentConfig() return true, {partConfigFilename = harness.configPath} end
  function adapter.captureCurrentState(kind, seed)
    harness.calls[#harness.calls + 1] = "capture"
    local snapshot = {
      modelKey = harness.modelKey,
      selectedConfiguration = harness.configPath,
      config = {
        partConfigFilename = harness.configPath,
        partsTree = util.deepCopy(harness.tree),
        vars = util.deepCopy(harness.tuning),
        paints = util.deepCopy(harness.paints),
      },
      partsTree = util.deepCopy(harness.tree),
      tuning = util.deepCopy(harness.tuning),
      paints = util.deepCopy(harness.paints),
      vehicleId = harness.vehicleId,
      seed = seed,
      operationType = kind,
      timestamp = 1,
    }
    if harness.original == nil then harness.original = util.deepCopy(snapshot) end
    return true, snapshot
  end
  function adapter.prepareConfigExpectation(record)
    return configVerification.expectation(record)
  end
  function adapter.replaceVehicle(modelKey, config)
    harness.calls[#harness.calls + 1] = "replace"
    local restoring = type(config) == "table"
    if options.replaceFailure and not restoring then
      return false, adapter.errorValue("vehicle_replace_rejected", "fixture replace rejected")
    end
    if options.ambiguousReplace and not restoring then
      return true, {correlationStrategy = "fixture_missing_id"}
    end
    local targetId = restoring and harness.original.vehicleId or harness.returnedVehicleId
    harness.pendingReplacement = {
      restoring = restoring,
      vehicleId = targetId,
      modelKey = modelKey,
      config = util.deepCopy(config),
      path = restoring and config.partConfigFilename or config,
    }
    if options.synchronousSwitchId and not restoring then
      harness.main.onVehicleSwitched(harness.vehicleId, options.synchronousSwitchId, 0)
    end
    return true, {value = vehicleObject(targetId), vehicleId = targetId, correlationStrategy = "fixture_returned_id"}
  end
  function adapter.getVerificationState()
    return true, {
      vehicleId = harness.vehicleId,
      modelKey = harness.modelKey,
      configKey = harness.configPath,
      configIdentity = {path = harness.configPath, key = configVerification.stableKey(harness.configPath)},
      parts = flatten(harness.tree),
      tuning = util.deepCopy(harness.tuning),
      paints = util.deepCopy(harness.paints),
    }
  end
  function adapter.getCurrentSlotSnapshot()
    harness.calls[#harness.calls + 1] = "scan"
    return true, {
      tree = util.deepCopy(harness.tree),
      metadataByPath = util.deepCopy(harness.metadata),
      modelMetadata = {Type = options.modelType or "Car"},
      variables = {boost = {min = harness.tuningMinimum, max = harness.tuningMaximum, default = 0.5, step = 0.1}},
      currentTuning = util.deepCopy(harness.tuning),
      paints = util.deepCopy(harness.paints),
    }
  end
  function adapter.applyPartsTree(tree)
    harness.calls[#harness.calls + 1] = "parts"
    if options.partsFailure then return false, adapter.errorValue("parts_apply_rejected", "fixture parts rejected") end
    harness.pendingParts = util.deepCopy(tree)
    return true, {confirmationRequired = true}
  end
  function adapter.getTuningSnapshot()
    return true, {
      variables = {boost = {min = harness.tuningMinimum, max = harness.tuningMaximum, default = 0.5, step = 0.1}},
      values = util.deepCopy(harness.tuning),
    }
  end
  function adapter.applyTuning(values)
    harness.calls[#harness.calls + 1] = "tuning"
    if options.tuningFailure then return false, adapter.errorValue("tuning_apply_rejected", "fixture tuning rejected") end
    harness.pendingTuning = util.deepCopy(values)
    return true, {confirmationRequired = true}
  end
  function adapter.getPaints() return true, util.deepCopy(harness.paints) end
  function adapter.applyPaints(paints)
    harness.calls[#harness.calls + 1] = "paint"
    if options.paintFailure then return false, adapter.errorValue("paint_apply_rejected", "fixture paint rejected") end
    harness.paints = util.deepCopy(paints)
    if options.deferredPaint then
      return true, {confirmationRequired = true, expected = util.deepCopy(paints), readbackReason = "fixture_deferred"}
    end
    return true, {confirmationRequired = false, verified = true, expected = util.deepCopy(paints)}
  end
  function adapter.verifyPaints(expected)
    if options.paintNeverConfirms then return false, "fixture_mismatch" end
    harness.paints = util.deepCopy(expected)
    return true, "requested_fields_match"
  end
  adapter.flattenChosenParts = flatten

  local originalAdapter = package.loaded[ADAPTER_PATH]
  package.loaded[ADAPTER_PATH] = adapter
  package.loaded[MAIN_PATH] = nil
  harness.main = require(MAIN_PATH)
  package.loaded[ADAPTER_PATH] = originalAdapter
  return harness
end

local function confirmReplacement(harness)
  local pending = assert(harness.pendingReplacement, "no pending replacement")
  harness.pendingReplacement = nil
  harness.vehicleId = pending.vehicleId
  harness.modelKey = pending.modelKey
  harness.configPath = pending.path
  if pending.restoring then
    harness.tree = util.deepCopy(pending.config.partsTree or {})
    harness.tuning = util.deepCopy(pending.config.vars or {})
    harness.paints = util.deepCopy(pending.config.paints or {})
  else
    harness.tree = baseTree()
    if harness.options.emptyOptional then
      harness.tree.children.optional = {
        id = "optional", path = "/optional/", chosenPartName = "", suitablePartNames = {}, children = {},
      }
    end
    if harness.options.targetMissingBodyB then
      harness.tree.children.body.suitablePartNames = {"body_a"}
    end
    harness.tuning = {boost = 0.5}
  end
  harness.main.onVehicleSpawned(harness.vehicleId)
end

local function confirmParts(harness)
  harness.tree = assert(harness.pendingParts, "no pending parts")
  harness.pendingParts = nil
  harness.main.onVehicleSpawned(harness.vehicleId)
end

local function confirmTuning(harness)
  harness.tuning = assert(harness.pendingTuning, "no pending tuning")
  harness.pendingTuning = nil
  harness.main.onVehicleSpawned(harness.vehicleId)
end

local function driveSuccess(harness, action)
  local started = harness.main.runAction(action, {
    chaos = 100,
    allowMissingParts = false,
    protectCriticalParts = true,
    contentFilter = "everything",
    includeAutomation = true,
    includeTrailers = true,
    includeProps = true,
    selectionFairness = "vehicle",
    manualSeed = "pipeline-seed",
  })
  if not started then return false end
  if action == "randomConfig" or action == "fullRandom" then confirmReplacement(harness) end
  if action == "scramble" or action == "fullRandom" then
    if harness.pendingParts then confirmParts(harness) end
    if harness.pendingTuning then confirmTuning(harness) end
    if harness.options.deferredPaint then
      harness.now = harness.now + 0.2
      harness.main.onUpdate()
    end
  end
  return true
end

M.new = new
M.confirmReplacement = confirmReplacement
M.confirmParts = confirmParts
M.confirmTuning = confirmTuning
M.driveSuccess = driveSuccess

return M
