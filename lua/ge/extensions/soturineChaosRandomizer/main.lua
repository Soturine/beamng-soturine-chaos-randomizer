local adapter = require("ge/extensions/soturineChaosRandomizer/apiAdapter")
local configSelector = require("ge/extensions/soturineChaosRandomizer/configSelector")
local contentIndex = require("ge/extensions/soturineChaosRandomizer/contentIndex")
local diagnosticsModule = require("ge/extensions/soturineChaosRandomizer/diagnostics")
local historyModule = require("ge/extensions/soturineChaosRandomizer/history")
local mutationEngine = require("ge/extensions/soturineChaosRandomizer/mutationEngine")
local mutationPolicy = require("ge/extensions/soturineChaosRandomizer/mutationPolicy")
local operationState = require("ge/extensions/soturineChaosRandomizer/operationState")
local paintRandomizer = require("ge/extensions/soturineChaosRandomizer/paintRandomizer")
local rngModule = require("ge/extensions/soturineChaosRandomizer/rng")
local settingsModule = require("ge/extensions/soturineChaosRandomizer/settings")
local slotScanner = require("ge/extensions/soturineChaosRandomizer/slotScanner")
local tuningRandomizer = require("ge/extensions/soturineChaosRandomizer/tuningRandomizer")
local util = require("ge/extensions/soturineChaosRandomizer/util")
local vehicleSelector = require("ge/extensions/soturineChaosRandomizer/vehicleSelector")

local M = {}

M.dependencies = {"core_vehicle_manager", "core_vehicle_partmgmt", "core_vehicles"}

local EXTENSION_VERSION = "0.1.0-alpha.1"
local WAIT_TIMEOUT = 25
local RECENT_LIMIT = 4

local runtime = {
  initialized = false,
  settings = settingsModule.defaults(),
  index = contentIndex.create(),
  state = operationState.create(adapter.clock, WAIT_TIMEOUT),
  history = historyModule.create(10),
  diagnostics = diagnosticsModule.create(adapter.logRecord),
  active = nil,
  lastResult = nil,
  progress = {label = "Ready", value = 0},
  recentModels = {},
  recentConfigs = {},
  capabilities = {},
}

local function pushRecent(list, value)
  if not value then return end
  for index = #list, 1, -1 do
    if list[index] == value then table.remove(list, index) end
  end
  list[#list + 1] = value
  while #list > RECENT_LIMIT do table.remove(list, 1) end
end

local function publicState()
  local indexCounts = {
    models = #runtime.index.models,
    configurations = #runtime.index.allConfigs,
    duration = runtime.index.duration,
  }
  return {
    extensionVersion = EXTENSION_VERSION,
    gameVersion = adapter.getGameVersion(),
    busy = runtime.state.busy,
    operationState = runtime.state.state,
    operationType = runtime.state.kind,
    token = runtime.state.token,
    progress = util.deepCopy(runtime.progress),
    settings = util.deepCopy(runtime.settings),
    seed = runtime.active and runtime.active.seed or runtime.settings.manualSeed,
    lastResult = util.deepCopy(runtime.lastResult),
    index = indexCounts,
    canUndo = #runtime.history.entries > 0 and not runtime.state.busy,
    history = historyModule.summaries(runtime.history),
    capabilities = util.deepCopy(runtime.capabilities),
  }
end

local function publishState()
  adapter.emit("SoturineChaosRandomizerState", publicState())
end

local function setProgress(label, value)
  runtime.progress = {label = label, value = util.clamp(value or 0, 0, 1)}
  publishState()
end

local function setResult(success, code, message, details)
  runtime.lastResult = {
    success = success == true,
    code = code,
    message = message,
    details = util.deepCopy(details or {}),
    timestamp = os.time(),
  }
end

local function finishOperation(success, code, message, details, terminalState)
  terminalState = terminalState or (success and "completed" or "failed")
  operationState.finish(runtime.state, terminalState, success and nil or code)
  setResult(success, code, message, details)
  runtime.progress = {label = success and "Complete" or message, value = success and 1 or 0}
  diagnosticsModule.write(runtime.diagnostics, success and "I" or "E", "operation_finished", {
    code = code,
    message = message,
    details = details,
  }, true)
  runtime.active = nil
  publishState()
  adapter.notify(message, success and "check" or "warning", success and 5 or 8)
end

local function cancelOperation(code, message)
  if not runtime.state.busy then return end
  finishOperation(false, code or "operation_cancelled", message or "Operation cancelled", {}, "cancelled")
end

local function initialize()
  if runtime.initialized then return end
  runtime.capabilities = adapter.getCapabilities()
  local okSettings, stored = adapter.loadSettings()
  if okSettings then runtime.settings = settingsModule.validate(stored) end
  runtime.history = historyModule.create(runtime.settings.historyLimit)
  diagnosticsModule.setEnabled(runtime.diagnostics, runtime.settings.diagnosticLogging)
  runtime.initialized = true
  diagnosticsModule.write(runtime.diagnostics, "I", "extension_loaded", {
    extensionVersion = EXTENSION_VERSION,
    gameVersion = adapter.getGameVersion(),
    capabilities = runtime.capabilities,
  }, true)
end

local function rebuildIndex()
  local started = adapter.clock()
  local okRegistry, registry = adapter.getRegistryData()
  if not okRegistry then return false, registry end
  local ok, counts = contentIndex.build(runtime.index, registry.models, registry.configs, os.time(), adapter.clock() - started)
  if not ok then
    return false, adapter.errorValue("no_eligible_content", "No eligible vehicle configurations were discovered")
  end
  diagnosticsModule.write(runtime.diagnostics, "I", "content_index_built", counts, true)
  return true, counts
end

local function ensureIndex()
  if runtime.index.valid then return true end
  local transitioned = operationState.transition(runtime.state, "indexing", false)
  if not transitioned then return false, adapter.errorValue("state_error", "Could not enter indexing state") end
  setProgress("Indexing installed content", 0.08)
  return rebuildIndex()
end

local function operationSeed()
  local source = runtime.settings.manualSeed
  if type(source) ~= "string" or source == "" then source = adapter.entropy() end
  local generator = rngModule.new(source)
  return generator.seed, generator
end

local function beginOperation(kind)
  initialize()
  if runtime.state.busy then
    setResult(false, "busy", "Another Chaos Randomizer operation is already running")
    publishState()
    return false
  end
  if runtime.state.state ~= "idle" then operationState.reset(runtime.state) end

  local okId, vehicleId = adapter.getCurrentVehicleId()
  if not okId or vehicleId == nil then
    setResult(false, "no_active_vehicle", "Spawn or enter a vehicle before using Chaos Randomizer")
    publishState()
    return false
  end
  local seed, generator = operationSeed()
  local ok, token = operationState.begin(runtime.state, kind, vehicleId, WAIT_TIMEOUT)
  if not ok then return false end
  runtime.active = {
    token = token,
    kind = kind,
    seed = seed,
    rng = generator,
    policy = mutationPolicy.fromSettings(runtime.settings),
    originalVehicleId = vehicleId,
    vehicleId = vehicleId,
    pass = 1,
    previousScan = nil,
    changes = {},
    tuningChanges = {},
    paintChanges = 0,
    destructiveStarted = false,
    ignoreNextSwitch = false,
    rollbackError = nil,
  }
  setProgress("Starting " .. kind, 0.02)
  return true, runtime.active
end

local function captureHistory(active)
  local ok, snapshot = adapter.captureCurrentState(active.kind, active.seed)
  if not ok then return false, snapshot end
  active.originalState = snapshot
  historyModule.push(runtime.history, snapshot)
  active.historyCaptured = true
  return true
end

local function chooseConfiguration(active)
  local models = contentIndex.eligibleModels(runtime.index, runtime.settings)
  if #models == 0 then return nil, nil, adapter.errorValue("no_eligible_vehicles", "No vehicles match the current content filters") end

  if runtime.settings.selectionFairness == "configuration" then
    local configs = contentIndex.eligibleConfigs(runtime.index, runtime.settings)
    local config, selectionError = configSelector.select(configs, active.rng:fork("configuration"), runtime.recentConfigs)
    if not config then return nil, nil, adapter.errorValue(selectionError, "No configurations match the current filters") end
    for _, model in ipairs(models) do
      if model.key == config.modelKey then return model, config end
    end
    return nil, nil, adapter.errorValue("model_config_mismatch", "The selected configuration has no eligible model")
  end

  local model, modelError = vehicleSelector.select(models, active.rng:fork("vehicle"), runtime.recentModels)
  if not model then return nil, nil, adapter.errorValue(modelError, "No vehicles match the current filters") end
  local config, configError = configSelector.select(model.configs, active.rng:fork("configuration:" .. model.key), runtime.recentConfigs)
  if not config then return nil, nil, adapter.errorValue(configError, "The selected vehicle has no eligible configurations") end
  return model, config
end

local function enterWaiting(active, nextStage, label, value)
  active.afterReload = nextStage
  active.ignoreNextSwitch = true
  local ok, transitionError = operationState.transition(runtime.state, runtime.state.state == "spawning" and "waitingForVehicle" or "waitingForReload", WAIT_TIMEOUT)
  if not ok then return false, adapter.errorValue("state_error", transitionError) end
  setProgress(label, value)
  return true
end

local function beginRollback(errorData)
  local active = runtime.active
  if not active or not active.originalState then
    finishOperation(false, errorData.code, errorData.message, {rollback = "not_available"})
    return
  end
  local okTransition = operationState.transition(runtime.state, "rollingBack", false)
  if not okTransition then runtime.state.state = "rollingBack" end
  active.rollbackError = errorData
  active.afterReload = "rollback"
  active.ignoreNextSwitch = true
  operationState.transition(runtime.state, "waitingForVehicle", WAIT_TIMEOUT)
  setProgress("Restoring the previous vehicle", 0.1)
  local ok, rollbackError = adapter.replaceVehicle(active.originalState.modelKey, active.originalState.config)
  if not ok then
    finishOperation(false, "rollback_failed", "Operation failed and rollback could not start", {
      originalError = errorData,
      rollbackError = rollbackError,
    })
  end
end

local function failActive(errorData, attemptRollback)
  errorData = type(errorData) == "table" and errorData or adapter.errorValue("operation_failed", tostring(errorData))
  if attemptRollback and runtime.active and runtime.active.destructiveStarted then
    beginRollback(errorData)
  else
    finishOperation(false, errorData.code, errorData.message, errorData.context)
  end
end

local startPaint
local startTuning
local processMutationPass

startPaint = function(active)
  if not operationState.isCurrent(runtime.state, active.token) then return end
  if runtime.state.state ~= "painting" then
    local ok, transitionError = operationState.transition(runtime.state, "painting", false)
    if not ok then failActive(adapter.errorValue("state_error", transitionError), true); return end
  end
  setProgress("Randomizing supported paints", 0.90)
  local okPaints, paints = adapter.getPaints()
  if not okPaints then failActive(paints, true); return end
  local result, changed = paintRandomizer.randomize(paints, active.policy, active.rng:fork("paint"))
  active.paintChanges = changed
  if changed > 0 then
    local okApply, applyError = adapter.applyPaints(result)
    if not okApply then failActive(applyError, true); return end
  end
  operationState.transition(runtime.state, "validating", false)
  local details = {
    seed = active.seed,
    model = active.selectedModel and active.selectedModel.key,
    configuration = active.selectedConfig and active.selectedConfig.key,
    mutationPasses = active.pass,
    partChanges = #active.changes,
    tuningChanges = #active.tuningChanges,
    paintChanges = active.paintChanges,
  }
  finishOperation(true, "completed", string.format("Chaos complete: %d parts, %d tuning values, %d paints", #active.changes, #active.tuningChanges, active.paintChanges), details)
end

startTuning = function(active)
  if not operationState.isCurrent(runtime.state, active.token) then return end
  if runtime.state.state ~= "tuning" then
    local ok, transitionError = operationState.transition(runtime.state, "tuning", false)
    if not ok then failActive(adapter.errorValue("state_error", transitionError), true); return end
  end
  setProgress("Randomizing final tuning", 0.80)
  local okSnapshot, snapshot = adapter.getTuningSnapshot()
  if not okSnapshot then failActive(snapshot, true); return end
  local values, changes = tuningRandomizer.randomize(snapshot.variables, snapshot.values, active.policy, active.rng:fork("tuning"))
  active.tuningChanges = changes
  if #changes == 0 then
    operationState.transition(runtime.state, "painting", false)
    startPaint(active)
    return
  end

  local okWait, waitError = enterWaiting(active, "paint", "Applying tuning and reloading", 0.85)
  if not okWait then failActive(waitError, true); return end
  local okApply, applyError = adapter.applyTuning(values)
  if not okApply then failActive(applyError, true) end
end

processMutationPass = function(active)
  if not operationState.isCurrent(runtime.state, active.token) then return end
  if runtime.state.state ~= "scanning" then
    local ok, transitionError = operationState.transition(runtime.state, "scanning", false)
    if not ok then failActive(adapter.errorValue("state_error", transitionError), true); return end
  end
  setProgress(string.format("Scanning compatible slots (pass %d)", active.pass), 0.30 + math.min(active.pass, 5) * 0.07)
  local okSnapshot, snapshot = adapter.getCurrentSlotSnapshot()
  if not okSnapshot then failActive(snapshot, true); return end
  local scan, scanError = slotScanner.scan(snapshot.tree, snapshot.metadataByPath)
  if not scan then failActive(adapter.errorValue(scanError, "Could not scan the current parts tree"), true); return end

  local eligible = slotScanner.changedPaths(active.previousScan, scan)
  if active.previousScan and next(eligible) == nil then
    operationState.transition(runtime.state, "tuning", false)
    startTuning(active)
    return
  end
  if active.pass > active.policy.maxMutationPasses then
    operationState.transition(runtime.state, "tuning", false)
    startTuning(active)
    return
  end

  active.previousScan = scan
  operationState.transition(runtime.state, "mutating", false)
  local tree, decisions = mutationEngine.plan(scan, eligible, active.policy, active.rng:fork("parts:" .. active.pass), {
    passNumber = active.pass,
  })
  local actual = 0
  for _, decision in ipairs(decisions) do
    if not decision.skipped and decision.selectedPart ~= decision.previousPart then
      active.changes[#active.changes + 1] = decision
      actual = actual + 1
    end
  end
  diagnosticsModule.write(runtime.diagnostics, "D", "mutation_pass", {
    pass = active.pass,
    slots = #scan.slots,
    changes = actual,
  })
  if actual == 0 then
    operationState.transition(runtime.state, "tuning", false)
    startTuning(active)
    return
  end

  active.destructiveStarted = true
  local okWait, waitError = enterWaiting(active, "mutation", "Applying compatible part changes", 0.48 + math.min(active.pass, 5) * 0.06)
  if not okWait then failActive(waitError, true); return end
  local okApply, applyError = adapter.applyPartsTree(tree)
  if not okApply then failActive(applyError, true) end
end

local function startSpawnOperation(kind)
  local okBegin, active = beginOperation(kind)
  if not okBegin then return false end
  local okIndex, indexError = ensureIndex()
  if not okIndex then failActive(indexError, false); return false end
  if runtime.state.state ~= "selecting" then
    local ok, transitionError = operationState.transition(runtime.state, "selecting", false)
    if not ok then failActive(adapter.errorValue("state_error", transitionError), false); return false end
  end
  setProgress("Selecting a compatible vehicle configuration", 0.15)
  local model, config, selectionError = chooseConfiguration(active)
  if not model then failActive(selectionError, false); return false end
  active.selectedModel = model
  active.selectedConfig = config
  local okCapture, captureError = captureHistory(active)
  if not okCapture then failActive(captureError, false); return false end

  operationState.transition(runtime.state, "spawning", false)
  active.destructiveStarted = true
  local okWait, waitError = enterWaiting(active, kind == "fullRandom" and "fullRandom" or "randomConfig", "Loading " .. tostring(config.name), 0.22)
  if not okWait then failActive(waitError, true); return false end
  local okReplace, replaceError = adapter.replaceVehicle(model.key, config.path or config.key)
  if not okReplace then
    contentIndex.recordFailure(runtime.index, "config", config.modelKey .. "/" .. config.key)
    failActive(replaceError, true)
    return false
  end
  return true
end

local function randomConfig()
  return startSpawnOperation("randomConfig")
end

local function fullRandom()
  return startSpawnOperation("fullRandom")
end

local function scramble()
  local okBegin, active = beginOperation("scramble")
  if not okBegin then return false end
  if not runtime.capabilities.scramble then
    failActive(adapter.errorValue("unsupported_api", "This BeamNG build does not expose hierarchical part mutation"), false)
    return false
  end
  local okCapture, captureError = captureHistory(active)
  if not okCapture then failActive(captureError, false); return false end
  operationState.transition(runtime.state, "scanning", false)
  processMutationPass(active)
  return true
end

local function undo()
  initialize()
  if runtime.state.busy then
    setResult(false, "busy", "Wait for the current operation before using Undo")
    publishState()
    return false
  end
  local entry = historyModule.peek(runtime.history)
  if not entry then
    setResult(false, "undo_unavailable", "There is no previous Chaos Randomizer state to restore")
    publishState()
    return false
  end
  if runtime.state.state ~= "idle" then operationState.reset(runtime.state) end
  local ok, token = operationState.begin(runtime.state, "undo", entry.vehicleId, WAIT_TIMEOUT)
  if not ok then return false end
  runtime.active = {
    token = token,
    kind = "undo",
    seed = entry.seed,
    originalState = entry,
    destructiveStarted = true,
    afterReload = "undo",
    ignoreNextSwitch = true,
  }
  operationState.transition(runtime.state, "spawning", false)
  enterWaiting(runtime.active, "undo", "Restoring the previous vehicle", 0.35)
  local okReplace, replaceError = adapter.replaceVehicle(entry.modelKey, entry.config)
  if not okReplace then failActive(replaceError, false); return false end
  return true
end

local function reindex()
  initialize()
  if runtime.state.busy then
    setResult(false, "busy", "Wait for the current operation before reindexing content")
    publishState()
    return false
  end
  contentIndex.clearFailures(runtime.index)
  runtime.index.valid = false
  if runtime.state.state ~= "idle" then operationState.reset(runtime.state) end
  local okBegin = operationState.begin(runtime.state, "reindex", nil, WAIT_TIMEOUT)
  if not okBegin then return false end
  operationState.transition(runtime.state, "indexing", false)
  setProgress("Reindexing installed content", 0.25)
  local ok, result = rebuildIndex()
  if not ok then failActive(result, false); return false end
  finishOperation(true, "reindexed", string.format("Indexed %d vehicles and %d configurations", result.models, result.configurations), result)
  return true
end

local function updateSettings(patch)
  initialize()
  if runtime.state.busy then return false end
  runtime.settings = settingsModule.update(runtime.settings, patch)
  historyModule.setLimit(runtime.history, runtime.settings.historyLimit)
  diagnosticsModule.setEnabled(runtime.diagnostics, runtime.settings.diagnosticLogging)
  local ok, saveError = adapter.saveSettings(runtime.settings)
  if not ok then
    setResult(false, saveError.code, saveError.message)
  end
  publishState()
  return ok
end

local function requestState()
  initialize()
  publishState()
  return publicState()
end

local function onVehicleSpawned(vehicleId)
  if not runtime.state.busy or not runtime.active then return end
  if runtime.state.state ~= "waitingForVehicle" and runtime.state.state ~= "waitingForReload" then return end
  local okCurrent, currentId = adapter.getCurrentVehicleId()
  if not okCurrent or currentId ~= vehicleId then return end
  local active = runtime.active
  active.vehicleId = vehicleId
  runtime.state.vehicleId = vehicleId
  active.ignoreNextSwitch = false

  if active.afterReload == "randomConfig" then
    pushRecent(runtime.recentModels, active.selectedModel.key)
    pushRecent(runtime.recentConfigs, configSelector.identifier(active.selectedConfig))
    finishOperation(true, "random_config_loaded", "Loaded " .. tostring(active.selectedConfig.name), {
      seed = active.seed,
      model = active.selectedModel.key,
      configuration = active.selectedConfig.key,
    })
  elseif active.afterReload == "fullRandom" then
    pushRecent(runtime.recentModels, active.selectedModel.key)
    pushRecent(runtime.recentConfigs, configSelector.identifier(active.selectedConfig))
    operationState.transition(runtime.state, "scanning", false)
    active.pass = 1
    processMutationPass(active)
  elseif active.afterReload == "mutation" then
    active.pass = active.pass + 1
    operationState.transition(runtime.state, "scanning", false)
    processMutationPass(active)
  elseif active.afterReload == "paint" then
    operationState.transition(runtime.state, "painting", false)
    startPaint(active)
  elseif active.afterReload == "undo" then
    historyModule.pop(runtime.history)
    finishOperation(true, "undo_completed", "Previous vehicle state restored", {model = active.originalState.modelKey})
  elseif active.afterReload == "rollback" then
    local originalError = active.rollbackError or adapter.errorValue("operation_failed", "Operation failed")
    if active.historyCaptured then historyModule.pop(runtime.history) end
    finishOperation(false, originalError.code, originalError.message .. "; previous state restored", {
      rollback = "completed",
      originalError = originalError.context,
    })
  end
end

local function onVehicleSwitched(oldId, newId, player)
  if not runtime.state.busy or not runtime.active or (player ~= nil and player ~= 0) then return end
  if runtime.active.ignoreNextSwitch then
    runtime.active.vehicleId = newId
    runtime.state.vehicleId = newId
    runtime.active.ignoreNextSwitch = false
    return
  end
  if newId ~= runtime.state.vehicleId then cancelOperation("vehicle_switched", "Operation cancelled because the active vehicle changed") end
end

local function onVehicleDestroyed(vehicleId)
  if not runtime.state.busy or not runtime.active then return end
  if runtime.active.ignoreNextSwitch then return end
  if vehicleId == runtime.state.vehicleId then cancelOperation("vehicle_destroyed", "Operation cancelled because the active vehicle disappeared") end
end

local function onClientEndMission()
  cancelOperation("map_changed", "Operation cancelled because the map changed")
end

local function onUpdate()
  if not runtime.state.busy or not operationState.isExpired(runtime.state) then return end
  local active = runtime.active
  if active and active.afterReload == "rollback" then
    finishOperation(false, "rollback_failed", "Vehicle reload timed out and rollback also timed out", {rollback = "timeout"})
    return
  end
  if active and active.selectedConfig then
    contentIndex.recordFailure(runtime.index, "config", active.selectedConfig.modelKey .. "/" .. active.selectedConfig.key)
  end
  failActive(adapter.errorValue("vehicle_reload_timeout", "Vehicle reload timed out"), true)
end

local function onExtensionLoaded()
  initialize()
  rebuildIndex()
  publishState()
end

M.randomConfig = randomConfig
M.scramble = scramble
M.fullRandom = fullRandom
M.undo = undo
M.reindex = reindex
M.updateSettings = updateSettings
M.requestState = requestState
M.onExtensionLoaded = onExtensionLoaded
M.onVehicleSpawned = onVehicleSpawned
M.onVehicleSwitched = onVehicleSwitched
M.onVehicleDestroyed = onVehicleDestroyed
M.onClientEndMission = onClientEndMission
M.onUpdate = onUpdate

return M
