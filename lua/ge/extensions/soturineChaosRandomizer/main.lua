local adapter = require("ge/extensions/soturineChaosRandomizer/apiAdapter")
local configSelector = require("ge/extensions/soturineChaosRandomizer/configSelector")
local contentIndex = require("ge/extensions/soturineChaosRandomizer/contentIndex")
local diagnosticsModule = require("ge/extensions/soturineChaosRandomizer/diagnostics")
local failureAttribution = require("ge/extensions/soturineChaosRandomizer/failureAttribution")
local historyModule = require("ge/extensions/soturineChaosRandomizer/history")
local historyTransaction = require("ge/extensions/soturineChaosRandomizer/historyTransaction")
local lifecycle = require("ge/extensions/soturineChaosRandomizer/lifecycle")
local mutationEngine = require("ge/extensions/soturineChaosRandomizer/mutationEngine")
local mutationPolicy = require("ge/extensions/soturineChaosRandomizer/mutationPolicy")
local operationState = require("ge/extensions/soturineChaosRandomizer/operationState")
local paintRandomizer = require("ge/extensions/soturineChaosRandomizer/paintRandomizer")
local paintVerification = require("ge/extensions/soturineChaosRandomizer/paintVerification")
local rngModule = require("ge/extensions/soturineChaosRandomizer/rng")
local settingsModule = require("ge/extensions/soturineChaosRandomizer/settings")
local slotScanner = require("ge/extensions/soturineChaosRandomizer/slotScanner")
local stressRunner = require("ge/extensions/soturineChaosRandomizer/stressRunner")
local tuningRandomizer = require("ge/extensions/soturineChaosRandomizer/tuningRandomizer")
local util = require("ge/extensions/soturineChaosRandomizer/util")
local validator = require("ge/extensions/soturineChaosRandomizer/validator")
local vehicleSelector = require("ge/extensions/soturineChaosRandomizer/vehicleSelector")

local M = {}

M.dependencies = {"core_modmanager", "core_vehicle_manager", "core_vehicle_partmgmt", "core_vehicles"}

local EXTENSION_VERSION = "0.3.0-alpha.1"
local WAIT_TIMEOUT = 25
local PAINT_CONFIRM_TIMEOUT = 2
local RECENT_LIMIT = 4

local runtime = {
  initialized = false,
  settings = settingsModule.defaults(),
  index = contentIndex.create(),
  state = operationState.create(adapter.clock, WAIT_TIMEOUT),
  history = historyModule.create(10),
  diagnostics = diagnosticsModule.create(adapter.logRecord),
  active = nil,
  stress = nil,
  lastSeed = nil,
  lastResult = nil,
  lastFailure = nil,
  progress = {label = "Ready", value = 0},
  recentModels = {},
  recentConfigs = {},
  capabilities = {},
  performance = {
    indexBuilds = 0,
    indexCacheHits = 0,
    lastIndexDuration = 0,
    lastOperation = nil,
  },
}

local startPaint
local startTuning
local processMutationPass
local startStressIteration

local function pushRecent(list, value)
  if not value then return end
  for index = #list, 1, -1 do
    if list[index] == value then table.remove(list, index) end
  end
  list[#list + 1] = value
  while #list > RECENT_LIMIT do table.remove(list, 1) end
end

local function sourceCounts()
  local counts = {official = 0, mod = 0, user = 0, unknown = 0}
  for _, config in ipairs(runtime.index.allConfigs or {}) do
    local kind = counts[config.sourceKind] ~= nil and config.sourceKind or "unknown"
    counts[kind] = counts[kind] + 1
  end
  return counts
end

local function publicStressState()
  if not runtime.stress then
    return {active = false, enabledByDefault = false, maxIterations = stressRunner.MAX_ITERATIONS}
  end
  return {
    active = runtime.stress.active == true,
    enabledByDefault = false,
    maxIterations = stressRunner.MAX_ITERATIONS,
    currentIteration = runtime.stress.currentIteration,
    currentSeed = runtime.stress.currentSeed,
    options = util.deepCopy(runtime.stress.options),
    summary = util.deepCopy(runtime.stress.summary),
    cancelReason = runtime.stress.cancelReason,
  }
end

local function publicState()
  local blacklist = contentIndex.blacklistCounts(runtime.index)
  return {
    extensionVersion = EXTENSION_VERSION,
    gameVersion = adapter.getGameVersion(),
    busy = runtime.state.busy,
    operationState = runtime.state.state,
    operationType = runtime.state.kind,
    waitReason = runtime.active and runtime.active.wait and runtime.active.wait.reason or nil,
    token = runtime.state.token,
    progress = util.deepCopy(runtime.progress),
    settings = util.deepCopy(runtime.settings),
    seed = runtime.active and runtime.active.seed or runtime.lastSeed or runtime.settings.manualSeed,
    lastResult = util.deepCopy(runtime.lastResult),
    lastFailure = util.deepCopy(runtime.lastFailure),
    index = {
      models = #runtime.index.models,
      configurations = #runtime.index.allConfigs,
      duration = runtime.index.duration,
      sources = sourceCounts(),
      blacklists = blacklist,
      blacklisted = blacklist.total,
      lastBlocked = util.deepCopy(runtime.index.lastBlocked),
      suspects = contentIndex.suspectCount(runtime.index),
      lastSuspect = util.deepCopy(runtime.index.lastSuspect),
    },
    canUndo = #runtime.history.entries > 0 and not runtime.state.busy,
    history = historyModule.summaries(runtime.history),
    capabilities = util.deepCopy(runtime.capabilities),
    developerStress = publicStressState(),
    performance = util.deepCopy(runtime.performance),
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

local function restoreStressSettings()
  if runtime.stress and runtime.stress.originalSettings then
    runtime.settings = settingsModule.validate(runtime.stress.originalSettings)
    historyModule.setLimit(runtime.history, runtime.settings.historyLimit)
    diagnosticsModule.setEnabled(runtime.diagnostics, runtime.settings.diagnosticLogging)
    adapter.saveSettings(runtime.settings)
    runtime.stress.originalSettings = nil
  end
end

local function failureRecord(active, phase, errorData, context)
  errorData = type(errorData) == "table" and errorData or adapter.errorValue("operation_failed", tostring(errorData))
  context = util.shallowMerge(errorData.context or {}, context or {})
  local resolvedPhase = phase or (active and active.phase) or "lifecycle"
  if resolvedPhase == "parts" and active and active.currentBatch then
    context.batch = util.deepCopy(active.currentBatch)
    if #active.currentBatch == 1 then
      context.slotPath = context.slotPath or active.currentBatch[1].slotPath
      context.candidate = context.candidate or active.currentBatch[1].selectedPart
    end
  end
  local selectedModel = active and active.selectedModel
  local selectedConfig = active and active.selectedConfig
  return {
    phase = resolvedPhase,
    code = errorData.code or "operation_failed",
    message = errorData.message or tostring(errorData.code or "Operation failed"),
    modelKey = context.modelKey or (selectedModel and selectedModel.key) or (active and active.modelKey),
    configKey = context.configKey or (selectedConfig and selectedConfig.key),
    slotPath = context.slotPath,
    candidate = context.candidate,
    tuningVariable = context.tuningVariable,
    paintLayer = context.paintLayer,
    seed = active and active.seed,
    operationToken = active and active.token,
    attempt = context.attempt or (active and active.pass),
    timestamp = os.time(),
    context = context,
  }
end

local function finishOperation(success, code, message, details, terminalState)
  local active = runtime.active
  terminalState = terminalState or (success and "completed" or "failed")
  operationState.finish(runtime.state, terminalState, success and nil or code)
  setResult(success, code, message, details)
  runtime.progress = {label = success and "Complete" or message, value = success and 1 or 0}
  diagnosticsModule.write(runtime.diagnostics, success and "I" or "E", "operation_finished", {
    code = code,
    message = message,
    details = details,
  }, true)
  if active then
    runtime.performance.lastOperation = {
      kind = active.kind,
      duration = math.max(0, adapter.clock() - active.startedAt),
      reloadCount = active.reloadCount or 0,
      slotScanDuration = active.slotScanDuration or 0,
      mutationPlanningDuration = active.mutationPlanningDuration or 0,
      slotCount = active.lastScanMetrics and active.lastScanMetrics.slotCount or 0,
      candidateCount = active.lastScanMetrics and active.lastScanMetrics.candidateCount or 0,
      treeDepth = active.lastScanMetrics and active.lastScanMetrics.maxDepth or 0,
      success = success == true,
    }
  end
  runtime.active = nil

  if active and active.stressIteration and runtime.stress then
    runtime.stress.vehicleId = active.vehicleId
    local duration = math.max(0, adapter.clock() - active.startedAt)
    stressRunner.record(runtime.stress, {
      success = success,
      duration = duration,
      seed = active.seed,
      phase = details and details.originalFailure and details.originalFailure.phase or active.phase,
      timeout = type(code) == "string" and code:find("timeout", 1, true) ~= nil,
      rollback = details and details.rollback == "completed",
    })
    runtime.stress.summary.blacklists = contentIndex.blacklistCounts(runtime.index)
    if not runtime.stress.active then restoreStressSettings() end
  end

  publishState()
  if not active or not active.stressIteration or not runtime.stress or not runtime.stress.active then
    adapter.notify(message, success and "check" or "warning", success and 5 or 8)
  end
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
  if not ok then return false, adapter.errorValue("no_eligible_content", "No eligible vehicle configurations were discovered") end
  counts.sources = sourceCounts()
  runtime.performance.indexBuilds = runtime.performance.indexBuilds + 1
  runtime.performance.lastIndexDuration = counts.duration
  diagnosticsModule.write(runtime.diagnostics, "I", "content_index_built", counts, true)
  return true, counts
end

local function ensureIndex()
  if runtime.index.valid then
    runtime.performance.indexCacheHits = runtime.performance.indexCacheHits + 1
    return true
  end
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

local function beginOperation(kind, context)
  initialize()
  context = type(context) == "table" and context or {}
  if runtime.state.busy then return false, adapter.errorValue("busy", "Another Chaos Randomizer operation is already running") end
  if runtime.stress and runtime.stress.active and not context.stressIteration then
    return false, adapter.errorValue("stress_active", "Developer stress diagnostics are running")
  end
  if runtime.state.state ~= "idle" then operationState.reset(runtime.state) end
  local okId, vehicleId = adapter.getCurrentVehicleId()
  if not okId or vehicleId == nil then return false, adapter.errorValue("no_active_vehicle", "Spawn or enter a vehicle before using Chaos Randomizer") end
  local seed, generator = operationSeed()
  runtime.lastSeed = seed
  local timeout = context.operationTimeout or WAIT_TIMEOUT
  local ok, token = operationState.begin(runtime.state, kind, vehicleId, timeout)
  if not ok then return false, adapter.errorValue("busy", "Another operation is already running") end
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
    deferredPaths = {},
    mutatedPaths = {},
    changes = {},
    tuningChanges = {},
    paintChanges = 0,
    warnings = {},
    destructiveStarted = false,
    historyCommitted = false,
    baseConfirmed = kind == "scramble",
    startedAt = adapter.clock(),
    phase = kind == "scramble" and "parts" or "selection",
    stressIteration = context.stressIteration,
    waitTimeout = timeout,
    reloadCount = 0,
    partPassesApplied = 0,
    safetyBaseline = nil,
    safetyResult = nil,
    phaseTimings = {},
  }
  diagnosticsModule.write(runtime.diagnostics, "D", "operation_started", {
    kind = kind,
    seed = seed,
    vehicleId = vehicleId,
    chaos = runtime.settings.chaos,
    stressIteration = context.stressIteration,
  })
  setProgress("Starting " .. kind, 0.02)
  return true, runtime.active
end

local function captureOriginal(active)
  local ok, snapshot = adapter.captureCurrentState(active.kind, active.seed)
  if not ok then return false, snapshot end
  return historyTransaction.capture(active, snapshot)
end

local function commitHistory(active)
  local ok, committed = historyTransaction.commit(active, runtime.history, historyModule.push)
  if not ok then
    return false, adapter.errorValue("history_commit_failed", "The original state could not be committed to history")
  end
  if committed then
    diagnosticsModule.write(runtime.diagnostics, "D", "history_committed", {
      token = active.token,
      phase = active.phase,
    })
  end
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

local function enterWaiting(active, phase, afterReload, expected, label, value)
  active.phase = phase
  active.afterReload = afterReload
  local target = (phase == "spawn" or phase == "rollback" or phase == "undo") and "waitingForVehicle" or "waitingForReload"
  local ok, transitionError = operationState.transition(runtime.state, target, active.waitTimeout or WAIT_TIMEOUT)
  if not ok then return false, adapter.errorValue("state_error", transitionError) end
  expected = util.shallowMerge(expected or {}, {
    token = active.token,
    phase = phase,
    eventType = "onVehicleSpawned",
    startedAt = adapter.clock(),
  })
  active.wait = lifecycle.createExpectation(expected)
  diagnosticsModule.write(runtime.diagnostics, "D", "lifecycle_wait_started", {
    phase = phase,
    waitReason = active.wait.reason,
    expectedEvent = active.wait.eventType,
    vehicleId = active.wait.vehicleId,
    modelKey = active.wait.modelKey,
  })
  setProgress(label, value)
  return true
end

local function bindReplacementTarget(active, result, phase)
  if type(result) ~= "table" or type(result.vehicleId) ~= "number" then
    return false, adapter.errorValue("vehicle_replace_target_ambiguous", "The replacement target could not be correlated")
  end
  local expectedOriginalId
  if phase == "rollback" or phase == "undo" then
    expectedOriginalId = active.originalState and active.originalState.vehicleId
    if expectedOriginalId ~= nil and result.vehicleId ~= expectedOriginalId then
      return false, adapter.errorValue(phase .. "_target_mismatch", "The restore write targeted an unrelated vehicle", {
        expectedVehicleId = expectedOriginalId,
        returnedVehicleId = result.vehicleId,
      })
    end
  end
  active.expectedReplacementVehicleId = result.vehicleId
  active.replaceRequestModel = active.wait and active.wait.modelKey
  active.replaceRequestConfig = active.wait and (active.wait.configIdentity or active.wait.configKey)
  active.replaceIssuedAt = adapter.clock()
  active.replaceCorrelationStrategy = result.correlationStrategy
  active.vehicleId = result.vehicleId
  runtime.state.vehicleId = result.vehicleId
  if active.wait then active.wait.vehicleId = result.vehicleId end
  diagnosticsModule.write(runtime.diagnostics, "D", "replacement_target_bound", {
    phase = phase,
    requestedModel = active.replaceRequestModel,
    requestedConfig = active.replaceRequestConfig,
    requestedTargetId = active.replaceTargetVehicleId,
    returnedTargetId = result.vehicleId,
    correlationStrategy = result.correlationStrategy,
  }, true)
  return true
end

local function issueReplacement(active, modelKey, config, phase)
  active.replaceRequestModel = modelKey
  active.replaceRequestConfig = util.deepCopy(config)
  active.replaceIssuedAt = adapter.clock()
  active.replaceTargetVehicleId = active.vehicleId
  active.replaceWriteInFlight = true
  active.pendingReplacementSwitch = nil
  local ok, result = adapter.replaceVehicle(modelKey, config, active.replaceTargetVehicleId)
  active.replaceWriteInFlight = false
  if not ok then return false, result end
  local bound, bindError = bindReplacementTarget(active, result, phase)
  if not bound then return false, bindError end
  local pending = active.pendingReplacementSwitch
  active.pendingReplacementSwitch = nil
  if pending and pending.ambiguous then
    return false, adapter.errorValue("vehicle_replace_event_ambiguous", "Multiple vehicle switches occurred before the replacement target was known", {
      expectedVehicleId = active.expectedReplacementVehicleId,
      events = pending.events,
    })
  end
  if pending and pending.newId ~= active.expectedReplacementVehicleId then
    return false, adapter.errorValue("vehicle_switched", "An unrelated vehicle switch occurred during replacement", {
      expectedVehicleId = active.expectedReplacementVehicleId,
      eventVehicleId = pending.newId,
    })
  end
  if pending then
    diagnosticsModule.write(runtime.diagnostics, "D", "replacement_switch_correlated", {
      phase = phase,
      oldId = pending.oldId,
      eventId = pending.newId,
      expectedReplacementId = active.expectedReplacementVehicleId,
      correlationStrategy = active.replaceCorrelationStrategy,
      queuedDuringWrite = true,
    })
  end
  return true, result
end

local function isUnsafeCorrelationFailure(errorData)
  local code = type(errorData) == "table" and errorData.code
  return code == "vehicle_replace_target_ambiguous"
    or code == "vehicle_replace_target_unavailable"
    or code == "vehicle_replace_event_ambiguous"
    or code == "vehicle_switched"
end

local function attributeFailure(active, failure)
  if not active then return end
  local target = failureAttribution.targetForPhase(failure.phase, active.baseConfirmed)
  if target == "config" and active.selectedConfig then
    local count, blocked, id = contentIndex.recordFailure(runtime.index, "config", {
      modelKey = active.selectedConfig.modelKey,
      configKey = active.selectedConfig.key,
      seed = active.seed,
      timestamp = failure.timestamp,
    }, failure)
    diagnosticsModule.write(runtime.diagnostics, "W", "configuration_failure", {
      id = id, failureCount = count, blacklisted = blocked, reason = failure.code,
    }, true)
  elseif target == "part" and active.currentBatch then
    local suspectBatch = #active.currentBatch > 1
    local fingerprintValues = {}
    for _, item in ipairs(active.currentBatch) do
      fingerprintValues[#fingerprintValues + 1] = tostring(item.slotPath) .. "=" .. tostring(item.selectedPart)
    end
    table.sort(fingerprintValues)
    local batchFingerprint = table.concat(fingerprintValues, "|")
    for _, decision in ipairs(active.currentBatch) do
      if decision.selectedPart and decision.selectedPart ~= "" then
        local count, blocked, id, suspect = contentIndex.recordFailure(runtime.index, "part", {
          modelKey = active.modelKey or (active.selectedModel and active.selectedModel.key),
          slotPath = decision.slotPath,
          candidate = decision.selectedPart,
          suspectBatch = suspectBatch,
          batchSize = #active.currentBatch,
          batchFingerprint = batchFingerprint,
          seed = active.seed,
          timestamp = failure.timestamp,
        }, failure)
        diagnosticsModule.write(runtime.diagnostics, "W", "part_candidate_failure", {
          id = id, failureCount = count, blacklisted = blocked, suspectBatch = suspectBatch,
          reason = failure.code, suspect = suspect,
        }, true)
      end
    end
  end
end

local function beginRollback(failure)
  local active = runtime.active
  if not active or not active.originalState then
    finishOperation(false, failure.code, failure.message, {failure = failure, rollback = "not_available"})
    return
  end
  local okTransition = operationState.transition(runtime.state, "rollingBack", false)
  if not okTransition then runtime.state.state = "rollingBack" end
  active.rollbackFailure = failure
  active.phase = "rollback"
  local okWait, waitError = enterWaiting(active, "rollback", "rollback", {
    modelKey = active.originalState.modelKey,
    configKey = active.originalState.selectedConfiguration,
    parts = adapter.flattenChosenParts(active.originalState.partsTree),
    tuning = active.originalState.tuning,
    paints = active.originalState.paints,
  }, "Restoring the previous vehicle", 0.1)
  if not okWait then
    finishOperation(false, "rollback_failed", "Operation failed and rollback could not enter its wait state", {
      originalFailure = failure,
      rollbackError = waitError,
    })
    return
  end
  local ok, rollbackResult = issueReplacement(active, active.originalState.modelKey, active.originalState.config, "rollback")
  if not ok then
    finishOperation(false, "rollback_failed", "Operation failed and rollback was rejected", {
      originalFailure = failure,
      rollbackError = rollbackResult,
    })
    return
  end
end

local function failActive(errorData, attemptRollback, phase, context)
  local active = runtime.active
  local failure = failureRecord(active, phase, errorData, context)
  runtime.lastFailure = failure
  attributeFailure(active, failure)
  diagnosticsModule.write(runtime.diagnostics, "E", "operation_error", failure, true)
  if attemptRollback and active and active.destructiveStarted and failure.phase ~= "rollback" and failure.phase ~= "undo" then
    beginRollback(failure)
  else
    finishOperation(false, failure.code, failure.message, {failure = failure})
  end
end

local function safetyContext(active, snapshot)
  local model = active.selectedModel or snapshot and snapshot.modelMetadata or {}
  return {
    type = model.type or model.Type or model.Category or model.category,
    isAutomation = model.isAutomation,
    isTrailer = model.isTrailer,
    isProp = model.isProp,
  }
end

local function validateFinalVehicle(active)
  setProgress("Validating final vehicle", 0.96)
  local scanStarted = adapter.clock()
  local okSnapshot, snapshot = adapter.getCurrentSlotSnapshot()
  if not okSnapshot then return false, snapshot end
  local scan, scanError = slotScanner.scan(snapshot.tree, snapshot.metadataByPath)
  active.slotScanDuration = (active.slotScanDuration or 0) + math.max(0, adapter.clock() - scanStarted)
  if not scan then return false, adapter.errorValue(scanError, "Could not scan the final parts tree") end
  local graph = validator.buildGraph(scan, safetyContext(active, snapshot))
  if not active.safetyBaseline then active.safetyBaseline = util.deepCopy(graph) end
  local result = validator.validateGraph(graph, active.safetyBaseline, active.policy.protectCriticalParts)
  active.safetyResult = result
  diagnosticsModule.write(runtime.diagnostics, result.valid and "D" or "E", "safety_validation", {
    phase = "validation",
    profile = result.profile,
    status = result.status,
    failures = result.failures,
    heuristicPaths = graph.heuristicPaths,
  }, not result.valid)
  if not result.valid then
    return false, adapter.errorValue("safety_validation_failed", "Final vehicle safety evidence is invalid", {
      profile = result.profile,
      status = result.status,
      failures = result.failures,
    })
  end
  return true, result
end

local function completeChaos(active)
  operationState.transition(runtime.state, "validating", false)
  active.phase = "validation"
  local safe, safetyOrError = validateFinalVehicle(active)
  if not safe then failActive(safetyOrError, true, "validation"); return end
  local completionMessage
  if safetyOrError.status == "not_applicable" then
    active.warnings[#active.warnings + 1] = "Prop safety validation is not applicable; this result does not claim a controllable vehicle."
    completionMessage = "Chaos complete; prop control is not validated"
  end
  local removed = 0
  for _, change in ipairs(active.changes) do if change.wasRemoved then removed = removed + 1 end end
  local details = {
    seed = active.seed,
    model = active.selectedModel and active.selectedModel.key or active.modelKey,
    configuration = active.selectedConfig and active.selectedConfig.key,
    mutationPasses = active.pass,
    baseConfiguration = active.selectedConfig and {
      key = active.selectedConfig.key,
      name = active.selectedConfig.name,
      path = active.selectedConfig.path,
      sourceKind = active.selectedConfig.sourceKind,
      sourceLabel = active.selectedConfig.sourceLabel,
    } or nil,
    partsChanged = #active.changes,
    partsRemoved = removed,
    nestedPasses = active.partPassesApplied or 0,
    tuningValues = util.deepCopy(active.tuningChanges),
    paintLayers = active.paintChanges,
    safety = util.deepCopy(safetyOrError),
    warnings = util.deepCopy(active.warnings),
  }
  finishOperation(true, "completed", completionMessage or string.format(
    "Chaos complete: %d parts, %d tuning values, %d paints",
    #active.changes, #active.tuningChanges, active.paintChanges
  ), details)
end

startPaint = function(active)
  if not operationState.isCurrent(runtime.state, active.token) then return end
  if not runtime.capabilities.scramblePaint then
    active.warnings[#active.warnings + 1] = "Paint randomization was skipped because paint read/write capability is unavailable."
    completeChaos(active)
    return
  end
  if runtime.state.state ~= "painting" then
    local ok, transitionError = operationState.transition(runtime.state, "painting", false)
    if not ok then failActive(adapter.errorValue("state_error", transitionError), true, "paint"); return end
  end
  active.phase = "paint"
  setProgress("Applying paints", 0.90)
  local okPaints, paints = adapter.getPaints()
  if not okPaints then failActive(paints, true, "paint"); return end
  local result, changed = paintRandomizer.randomize(paints, active.policy, active.rng:fork("paint"))
  active.paintChanges = changed
  diagnosticsModule.write(runtime.diagnostics, "D", "paint_randomized", {changes = changed})
  if changed > 0 then
    local okHistory, historyError = commitHistory(active)
    if not okHistory then failActive(historyError, false, "paint"); return end
    local okApply, applyResult = adapter.applyPaints(result)
    if not okApply then failActive(applyResult, true, "paint"); return end
    if applyResult.confirmationRequired then
      local transitioned, transitionError = operationState.transition(runtime.state, "waitingForReload", PAINT_CONFIRM_TIMEOUT)
      if not transitioned then failActive(adapter.errorValue("state_error", transitionError), true, "paint"); return end
      active.paintConfirmation = paintVerification.createDeferred(
        applyResult.expected, adapter.clock(), PAINT_CONFIRM_TIMEOUT, 0.1, 12
      )
      active.phase = "paint"
      diagnosticsModule.write(runtime.diagnostics, "D", "paint_confirmation_deferred", {
        strategy = active.paintConfirmation.strategy,
        reason = applyResult.readbackReason,
        timeout = PAINT_CONFIRM_TIMEOUT,
      })
      setProgress("Confirming paint read-back", 0.93)
      return
    end
  end
  completeChaos(active)
end

startTuning = function(active)
  if not operationState.isCurrent(runtime.state, active.token) then return end
  if not runtime.capabilities.scrambleTuning then
    active.warnings[#active.warnings + 1] = "Tuning randomization was skipped because tuning read/write capability is unavailable."
    operationState.transition(runtime.state, "painting", false)
    startPaint(active)
    return
  end
  if runtime.state.state ~= "tuning" then
    local ok, transitionError = operationState.transition(runtime.state, "tuning", false)
    if not ok then failActive(adapter.errorValue("state_error", transitionError), true, "tuning"); return end
  end
  active.phase = "tuning"
  setProgress("Applying tuning", 0.80)
  local okSnapshot, snapshot = adapter.getTuningSnapshot()
  if not okSnapshot then failActive(snapshot, true, "tuning"); return end
  local values, changes, groups = tuningRandomizer.randomize(
    snapshot.variables, snapshot.values, active.policy, active.rng:fork("tuning")
  )
  active.tuningChanges = changes
  diagnosticsModule.write(runtime.diagnostics, "D", "tuning_randomized", {
    changes = #changes,
    groups = groups,
  })
  if #changes == 0 then
    operationState.transition(runtime.state, "painting", false)
    startPaint(active)
    return
  end
  local expected = {}
  for _, change in ipairs(changes) do expected[change.name] = change.selectedValue end
  local okWait, waitError = enterWaiting(active, "tuning", "paint", {
    vehicleId = active.vehicleId,
    modelKey = active.modelKey or (active.selectedModel and active.selectedModel.key),
    tuning = expected,
  }, "Applying tuning and reloading", 0.85)
  if not okWait then failActive(waitError, true, "tuning"); return end
  local okHistory, historyError = commitHistory(active)
  if not okHistory then failActive(historyError, false, "tuning"); return end
  local okApply, applyError = adapter.applyTuning(values)
  if not okApply then failActive(applyError, true, "tuning") end
end

processMutationPass = function(active)
  if not operationState.isCurrent(runtime.state, active.token) then return end
  if runtime.state.state ~= "scanning" then
    local ok, transitionError = operationState.transition(runtime.state, "scanning", false)
    if not ok then failActive(adapter.errorValue("state_error", transitionError), true, "parts"); return end
  end
  active.phase = "parts"
  setProgress(string.format("Scanning parts (pass %d)", active.pass), 0.30 + math.min(active.pass, 5) * 0.07)
  local scanStarted = adapter.clock()
  local okSnapshot, snapshot = adapter.getCurrentSlotSnapshot()
  if not okSnapshot then failActive(snapshot, active.destructiveStarted, "parts"); return end
  local scan, scanError = slotScanner.scan(snapshot.tree, snapshot.metadataByPath)
  active.slotScanDuration = (active.slotScanDuration or 0) + math.max(0, adapter.clock() - scanStarted)
  if not scan then failActive(adapter.errorValue(scanError, "Could not scan the current parts tree"), active.destructiveStarted, "parts"); return end
  active.lastScanMetrics = util.deepCopy(scan.metrics)
  local graph = validator.buildGraph(scan, safetyContext(active, snapshot))
  if not active.safetyBaseline then active.safetyBaseline = util.deepCopy(graph) end
  local safetyResult = validator.validateGraph(graph, active.safetyBaseline, active.policy.protectCriticalParts)
  active.safetyResult = safetyResult
  local validProtection, protectionFailures = safetyResult.valid, safetyResult.failures
  if not validProtection then
    failActive(adapter.errorValue("critical_state_invalid", "Critical or required parts are missing after reload", {
      failures = protectionFailures,
    }), true, "validation")
    return
  end
  if active.pass > active.policy.maxMutationPasses then
    operationState.transition(runtime.state, "tuning", false)
    startTuning(active)
    return
  end

  local eligible = slotScanner.eligiblePaths(active.previousScan, scan, active.deferredPaths, active.mutatedPaths)
  if active.previousScan and next(eligible) == nil then
    operationState.transition(runtime.state, "tuning", false)
    startTuning(active)
    return
  end

  active.previousScan = scan
  active.deferredPaths = {}
  operationState.transition(runtime.state, "mutating", false)
  local modelKey = active.modelKey or (active.selectedModel and active.selectedModel.key)
  local planningStarted = adapter.clock()
  local tree, decisions = mutationEngine.plan(scan, eligible, active.policy, active.rng:fork("parts:" .. active.pass), {
    passNumber = active.pass,
    isBlacklisted = function(slot, candidate)
      local allowed, reason = contentIndex.isCandidateEligible(runtime.index, {
        modelKey = modelKey,
        slotPath = slot.path,
        candidate = candidate,
      })
      return not allowed, reason
    end,
  })
  active.mutationPlanningDuration = (active.mutationPlanningDuration or 0) + math.max(0, adapter.clock() - planningStarted)
  local actual = {}
  local ancestors = {}
  local deferred = 0
  local rejected = 0
  local protected = 0
  for _, decision in ipairs(decisions) do
    if not decision.skipped and decision.selectedPart ~= decision.previousPart then
      actual[#actual + 1] = decision
      active.changes[#active.changes + 1] = decision
      ancestors[#ancestors + 1] = decision.slotPath
      active.mutatedPaths[decision.slotPath] = true
    elseif decision.deferred then
      deferred = deferred + 1
      active.deferredPaths[decision.slotPath] = true
    elseif decision.reason == "candidate_blacklisted" or decision.reason == "candidate_suspect_suppressed" then
      rejected = rejected + 1
    elseif decision.protected then
      protected = protected + 1
    end
  end
  diagnosticsModule.write(runtime.diagnostics, "D", "mutation_pass", {
    pass = active.pass,
    slotsScanned = #scan.slots,
    ancestorsChanged = ancestors,
    descendantsDeferred = deferred,
    candidatesRejected = rejected,
    protectedSubstitutions = protected,
    actualChanges = #actual,
    reloadReason = #actual > 0 and "coherent_parts_batch" or "none",
    scanMetrics = scan.metrics,
    safetyProfile = graph.profile,
    safetyStatus = safetyResult.status,
    changes = actual,
  })
  if #actual == 0 then
    operationState.transition(runtime.state, "tuning", false)
    startTuning(active)
    return
  end

  local expectedParts = {}
  for _, decision in ipairs(actual) do expectedParts[decision.slotPath] = decision.selectedPart end
  active.currentBatch = util.deepCopy(actual)
  local applyingLabel = active.pass > 1
    and string.format("Applying nested part pass %d", active.pass)
    or "Applying part pass 1"
  local okWait, waitError = enterWaiting(active, "parts", "mutation", {
    vehicleId = active.vehicleId,
    modelKey = modelKey,
    parts = expectedParts,
  }, applyingLabel, 0.48 + math.min(active.pass, 5) * 0.06)
  if not okWait then failActive(waitError, true, "parts"); return end
  local okHistory, historyError = commitHistory(active)
  if not okHistory then failActive(historyError, false, "parts"); return end
  local okApply, applyError = adapter.applyPartsTree(tree)
  if not okApply then failActive(applyError, true, "parts"); return end
  setProgress(string.format("Reloading after part pass %d", active.pass), 0.51 + math.min(active.pass, 5) * 0.06)
end

local function startSpawnOperation(kind, context)
  local okBegin, activeOrError = beginOperation(kind, context)
  if not okBegin then
    setResult(false, activeOrError.code, activeOrError.message)
    publishState()
    return false
  end
  local active = activeOrError
  local okIndex, indexError = ensureIndex()
  if not okIndex then failActive(indexError, false, "index"); return false end
  if runtime.state.state ~= "selecting" then
    local ok, transitionError = operationState.transition(runtime.state, "selecting", false)
    if not ok then failActive(adapter.errorValue("state_error", transitionError), false, "selection"); return false end
  end
  active.phase = "selection"
  setProgress("Selecting vehicle", 0.15)
  local model, config, selectionError = chooseConfiguration(active)
  if not model then failActive(selectionError, false, "selection"); return false end
  active.selectedModel = model
  active.selectedConfig = config
  active.modelKey = model.key
  active.configIdentity = adapter.prepareConfigExpectation(config)
  diagnosticsModule.write(runtime.diagnostics, "D", "configuration_selected", {
    model = model.key,
    configuration = config.key,
    source = config.sourceKind,
    sourceLabel = config.sourceLabel,
    sourceStrategy = config.sourceStrategy,
    seed = active.seed,
    fairness = runtime.settings.selectionFairness,
  })
  local okCapture, captureError = captureOriginal(active)
  if not okCapture then failActive(captureError, false, "selection"); return false end
  operationState.transition(runtime.state, "spawning", false)
  local okWait, waitError = enterWaiting(active, "spawn", kind, {
    modelKey = model.key,
    configIdentity = active.configIdentity,
  }, "Loading configuration: " .. tostring(config.name), 0.22)
  if not okWait then failActive(waitError, false, "spawn"); return false end
  local okHistory, historyError = commitHistory(active)
  if not okHistory then failActive(historyError, false, "spawn"); return false end
  local okReplace, replaceResult = issueReplacement(active, model.key, config.path or config.key, "spawn")
  if not okReplace then
    local unsafeCorrelation = isUnsafeCorrelationFailure(replaceResult)
    failActive(replaceResult, not unsafeCorrelation, unsafeCorrelation and "lifecycle" or "spawn")
    return false
  end
  return true
end

local function startScramble(context)
  local okBegin, activeOrError = beginOperation("scramble", context)
  if not okBegin then
    setResult(false, activeOrError.code, activeOrError.message)
    publishState()
    return false
  end
  local active = activeOrError
  if not runtime.capabilities.scramble then
    failActive(adapter.errorValue("missing_parts_write", "This BeamNG build cannot read and write hierarchical parts"), false, "parts")
    return false
  end
  local okModel, modelKey = adapter.getCurrentModelKey()
  if not okModel then failActive(modelKey, false, "parts"); return false end
  active.modelKey = modelKey
  local okCapture, captureError = captureOriginal(active)
  if not okCapture then failActive(captureError, false, "parts"); return false end
  operationState.transition(runtime.state, "scanning", false)
  processMutationPass(active)
  return true
end

local function startUndo()
  initialize()
  if runtime.state.busy or (runtime.stress and runtime.stress.active) then
    setResult(false, "busy", "Wait for the current operation before using Undo")
    publishState()
    return false
  end
  if not runtime.capabilities.undo then
    setResult(false, "undo_unsupported", "Vehicle replacement confirmation is unavailable")
    publishState()
    return false
  end
  local entry = historyModule.peek(runtime.history)
  if not entry then
    setResult(false, "undo_unavailable", "There is no previous Chaos Randomizer state to restore")
    publishState()
    return false
  end
  local okCurrent, currentId = adapter.getCurrentVehicleId()
  if not okCurrent or currentId ~= entry.vehicleId then
    setResult(false, "undo_context_mismatch", "Undo is only available for the vehicle context that created the history entry")
    publishState()
    return false
  end
  if runtime.state.state ~= "idle" then operationState.reset(runtime.state) end
  local ok, token = operationState.begin(runtime.state, "undo", entry.vehicleId, WAIT_TIMEOUT)
  if not ok then return false end
  runtime.active = {
    token = token,
    kind = "undo",
    phase = "undo",
    seed = entry.seed,
    originalState = entry,
    originalVehicleId = entry.vehicleId,
    vehicleId = entry.vehicleId,
    destructiveStarted = true,
    startedAt = adapter.clock(),
    reloadCount = 0,
  }
  runtime.lastSeed = entry.seed
  operationState.transition(runtime.state, "spawning", false)
  local okWait, waitError = enterWaiting(runtime.active, "undo", "undo", {
    modelKey = entry.modelKey,
    configKey = entry.selectedConfiguration,
    parts = adapter.flattenChosenParts(entry.partsTree),
    tuning = entry.tuning,
    paints = entry.paints,
  }, "Restoring the previous vehicle", 0.35)
  if not okWait then failActive(waitError, false, "undo"); return false end
  local okReplace, replaceResult = issueReplacement(runtime.active, entry.modelKey, entry.config, "undo")
  if not okReplace then failActive(replaceResult, false, "undo"); return false end
  return true
end

local function startReindex()
  initialize()
  if runtime.state.busy or (runtime.stress and runtime.stress.active) then
    setResult(false, "busy", "Wait for the current operation before reindexing content")
    publishState()
    return false
  end
  contentIndex.clearFailures(runtime.index)
  runtime.index.valid = false
  if runtime.state.state ~= "idle" then operationState.reset(runtime.state) end
  local okBegin, token = operationState.begin(runtime.state, "reindex", nil, WAIT_TIMEOUT)
  if not okBegin then return false end
  runtime.active = {token = token, kind = "reindex", phase = "index", startedAt = adapter.clock()}
  operationState.transition(runtime.state, "indexing", false)
  setProgress("Reindexing installed content", 0.25)
  local ok, result = rebuildIndex()
  if not ok then failActive(result, false, "index"); return false end
  finishOperation(true, "reindexed", string.format("Indexed %d vehicles and %d configurations", result.models, result.configurations), result)
  return true
end

local function applySettingsSnapshot(snapshot)
  if type(snapshot) ~= "table" then return true end
  runtime.settings = settingsModule.validate(snapshot)
  historyModule.setLimit(runtime.history, runtime.settings.historyLimit)
  diagnosticsModule.setEnabled(runtime.diagnostics, runtime.settings.diagnosticLogging)
  local ok, saveError = adapter.saveSettings(runtime.settings)
  if not ok then
    setResult(false, saveError.code, saveError.message, {settingsAppliedForSession = true})
    diagnosticsModule.write(runtime.diagnostics, "W", "settings_persistence_failed", saveError, true)
  end
  return true
end

local function runActionInternal(action, context)
  if (action == "randomConfig" or action == "fullRandom" or action == "scramble")
    and not runtime.capabilities[action]
  then
    setResult(false, "capability_unavailable", "The requested action is unavailable in this BeamNG build", {
      action = action,
      warnings = runtime.capabilities.warnings,
    })
    publishState()
    return false
  end
  if action == "randomConfig" then return startSpawnOperation("randomConfig", context) end
  if action == "scramble" then return startScramble(context) end
  if action == "fullRandom" then return startSpawnOperation("fullRandom", context) end
  if action == "undo" then return startUndo() end
  if action == "reindex" then return startReindex() end
  setResult(false, "unknown_action", "Unknown Chaos Randomizer action")
  publishState()
  return false
end

local function runAction(action, settingsSnapshot)
  initialize()
  if runtime.state.busy then
    setResult(false, "busy", "Another Chaos Randomizer operation is already running")
    publishState()
    return false
  end
  if runtime.stress and runtime.stress.active then
    setResult(false, "stress_active", "Developer stress diagnostics are running")
    publishState()
    return false
  end
  applySettingsSnapshot(settingsSnapshot)
  return runActionInternal(action, {})
end

local function updateSettings(patch)
  initialize()
  if runtime.state.busy or (runtime.stress and runtime.stress.active) then return false end
  runtime.settings = settingsModule.update(runtime.settings, patch)
  historyModule.setLimit(runtime.history, runtime.settings.historyLimit)
  diagnosticsModule.setEnabled(runtime.diagnostics, runtime.settings.diagnosticLogging)
  local ok, saveError = adapter.saveSettings(runtime.settings)
  if not ok then setResult(false, saveError.code, saveError.message, {settingsAppliedForSession = true}) end
  publishState()
  return ok
end

local function requestState()
  initialize()
  publishState()
  return publicState()
end

local function onVehicleSpawned(vehicleId)
  if not runtime.state.busy or not runtime.active or not runtime.active.wait then return end
  local active = runtime.active
  local okCurrent, currentId = adapter.getCurrentVehicleId()
  if not okCurrent or currentId ~= vehicleId then
    diagnosticsModule.write(runtime.diagnostics, "D", "lifecycle_event_ignored", {
      eventReceived = "onVehicleSpawned", reason = "wrong_vehicle_event", vehicleId = vehicleId,
    })
    return
  end
  local matched, matchReason = lifecycle.matches(active.wait, {
    eventType = "onVehicleSpawned",
    vehicleId = vehicleId,
    token = active.token,
  })
  if not matched then
    diagnosticsModule.write(runtime.diagnostics, "D", "lifecycle_event_ignored", {
      eventReceived = "onVehicleSpawned", expectedEvent = active.wait.eventType, reason = matchReason,
    })
    return
  end
  local okState, verificationState = adapter.getVerificationState()
  if not okState then failActive(verificationState, true, active.phase); return end
  local verified, verificationReason, verificationDetails = lifecycle.verify(active.wait, verificationState)
  local elapsed = adapter.clock() - (active.wait.startedAt or adapter.clock())
  diagnosticsModule.write(runtime.diagnostics, verified and "D" or "E", "lifecycle_event_received", {
    eventReceived = "onVehicleSpawned",
    expectedEvent = active.wait.eventType,
    phase = active.wait.phase,
    stateVerified = verified,
    verificationReason = verificationReason,
    verificationStrategy = verificationDetails and verificationDetails.strategy,
    identityConfirmed = verificationDetails and verificationDetails.identityConfirmed,
    elapsed = elapsed,
  }, not verified)
  if not verified then
    if active.wait.phase == "rollback" then
      finishOperation(false, "rollback_unconfirmed", "Rollback event arrived but restored state could not be confirmed", {
        rollback = "unconfirmed", reason = verificationReason,
      })
    else
      failActive(adapter.errorValue("post_event_state_unconfirmed", "Reload event arrived but requested state was not confirmed", {
        verificationReason = verificationReason,
      }), true, active.wait.phase)
    end
    return
  end

  local completedPhase = active.wait.phase
  local afterReload = active.afterReload
  active.wait = nil
  active.vehicleId = vehicleId
  runtime.state.vehicleId = vehicleId
  if completedPhase == "spawn" or completedPhase == "parts" or completedPhase == "tuning"
    or completedPhase == "undo" or completedPhase == "rollback"
  then
    active.reloadCount = (active.reloadCount or 0) + 1
  end

  if completedPhase == "spawn" then
    active.baseConfirmed = true
    pushRecent(runtime.recentModels, active.selectedModel.key)
    pushRecent(runtime.recentConfigs, configSelector.identifier(active.selectedConfig))
    if afterReload == "randomConfig" then
      local message = "Loaded " .. tostring(active.selectedConfig.name)
      local warnings = {}
      if active.selectedModel.isProp then
        message = message .. "; prop control is not validated"
        warnings[#warnings + 1] = "The selected prop may not provide an active controllable vehicle."
      end
      finishOperation(true, "random_config_loaded", message, {
        seed = active.seed,
        model = active.selectedModel.key,
        configuration = active.selectedConfig.key,
        configurationName = active.selectedConfig.name,
        sourceKind = active.selectedConfig.sourceKind,
        sourceLabel = active.selectedConfig.sourceLabel,
        verificationStrategy = verificationDetails and verificationDetails.strategy,
        warnings = warnings,
      })
    else
      operationState.transition(runtime.state, "scanning", false)
      active.pass = 1
      processMutationPass(active)
    end
  elseif completedPhase == "parts" then
    active.partPassesApplied = (active.partPassesApplied or 0) + 1
    for _, decision in ipairs(active.currentBatch or {}) do
      if decision.selectedPart and decision.selectedPart ~= "" then
        local recorded, successDetails = contentIndex.recordSuccess(runtime.index, "part", {
          modelKey = active.modelKey or (active.selectedModel and active.selectedModel.key),
          slotPath = decision.slotPath,
          candidate = decision.selectedPart,
        }, os.time())
        if recorded then
          diagnosticsModule.write(runtime.diagnostics, "D", "part_candidate_success", successDetails)
        end
      end
    end
    active.currentBatch = nil
    active.pass = active.pass + 1
    operationState.transition(runtime.state, "scanning", false)
    processMutationPass(active)
  elseif completedPhase == "tuning" then
    operationState.transition(runtime.state, "painting", false)
    startPaint(active)
  elseif completedPhase == "undo" then
    historyModule.pop(runtime.history)
    finishOperation(true, "undo_completed", "Previous vehicle state restored", {model = active.originalState.modelKey})
  elseif completedPhase == "rollback" then
    local originalFailure = active.rollbackFailure or failureRecord(active, "rollback", adapter.errorValue("operation_failed", "Operation failed"))
    historyTransaction.rollbackSucceeded(active, runtime.history, historyModule.pop)
    finishOperation(false, originalFailure.code, originalFailure.message .. "; previous state restored", {
      rollback = "completed",
      originalFailure = originalFailure,
    })
  end
end

local function cancelOperation(code, message)
  if not runtime.state.busy then return end
  local failure = failureRecord(runtime.active, "lifecycle", adapter.errorValue(code or "operation_cancelled", message or "Operation cancelled"))
  runtime.lastFailure = failure
  finishOperation(false, failure.code, failure.message, {failure = failure}, "cancelled")
end

local function cancelDeveloperStressInternal(reason)
  if not runtime.stress or not runtime.stress.active then return false end
  stressRunner.cancel(runtime.stress, reason)
  if runtime.active and runtime.active.stressIteration then
    cancelOperation("stress_cancelled", "Developer stress diagnostics were cancelled")
  else
    restoreStressSettings()
    publishState()
  end
  return true
end

local function onVehicleSwitched(oldId, newId, player)
  if player ~= nil and player ~= 0 then return end
  if runtime.stress and runtime.stress.active and not runtime.state.busy
    and newId ~= runtime.stress.vehicleId
  then
    cancelDeveloperStressInternal("vehicle_changed")
    return
  end
  if not runtime.state.busy or not runtime.active then return end
  local active = runtime.active
  local replacementWait = active.phase == "spawn" or active.phase == "rollback" or active.phase == "undo"
  if replacementWait then
    if active.replaceWriteInFlight then
      if active.pendingReplacementSwitch then
        active.pendingReplacementSwitch = {
          ambiguous = true,
          events = {
            util.deepCopy(active.pendingReplacementSwitch),
            {oldId = oldId, newId = newId},
          },
        }
      else
        active.pendingReplacementSwitch = {oldId = oldId, newId = newId}
      end
      diagnosticsModule.write(runtime.diagnostics, "D", "replacement_switch_queued", {
        phase = active.phase,
        oldId = oldId,
        eventId = newId,
        reason = "replace_write_in_flight",
      })
      return
    end
    if active.expectedReplacementVehicleId and newId == active.expectedReplacementVehicleId then
      diagnosticsModule.write(runtime.diagnostics, "D", "replacement_switch_correlated", {
        phase = active.phase,
        oldId = oldId,
        eventId = newId,
        expectedReplacementId = active.expectedReplacementVehicleId,
        correlationStrategy = active.replaceCorrelationStrategy,
      })
      return
    end
    diagnosticsModule.write(runtime.diagnostics, "W", "replacement_switch_rejected", {
      phase = active.phase,
      oldId = oldId,
      eventId = newId,
      expectedReplacementId = active.expectedReplacementVehicleId,
      rejectionReason = active.expectedReplacementVehicleId and "unrelated_switch" or "ambiguous_target",
    }, true)
    if runtime.stress and runtime.stress.active then
      cancelDeveloperStressInternal("vehicle_changed")
    else
      cancelOperation("vehicle_switched", "Operation cancelled because an unrelated vehicle switch occurred")
    end
    return
  end
  if newId ~= runtime.state.vehicleId then
    if runtime.stress and runtime.stress.active then
      cancelDeveloperStressInternal("vehicle_changed")
    else
      cancelOperation("vehicle_switched", "Operation cancelled because the active vehicle changed")
    end
  end
end

local function onVehicleDestroyed(vehicleId)
  if runtime.stress and runtime.stress.active and not runtime.state.busy
    and vehicleId == runtime.stress.vehicleId
  then
    cancelDeveloperStressInternal("vehicle_destroyed")
    return
  end
  if runtime.stress and runtime.stress.active and runtime.state.busy and vehicleId == runtime.state.vehicleId then
    cancelDeveloperStressInternal("vehicle_destroyed")
    return
  end
  if runtime.state.busy and runtime.active then
    local active = runtime.active
    local replacementWait = active.phase == "spawn" or active.phase == "rollback" or active.phase == "undo"
    if replacementWait and active.expectedReplacementVehicleId ~= active.originalVehicleId
      and vehicleId == active.originalVehicleId
    then
      return
    end
    if vehicleId == runtime.state.vehicleId or vehicleId == active.expectedReplacementVehicleId then
      cancelOperation("vehicle_destroyed", "Operation cancelled because the active vehicle disappeared")
    end
  end
end

local function onClientEndMission()
  if runtime.stress and runtime.stress.active then cancelDeveloperStressInternal("map_changed") end
  cancelOperation("map_changed", "Operation cancelled because the map changed")
end

local function onModStateChanged(modData)
  runtime.index.valid = false
  contentIndex.clearFailures(runtime.index)
  diagnosticsModule.write(runtime.diagnostics, "I", "content_index_invalidated", {
    mod = type(modData) == "table" and modData.modname or nil,
  }, true)
  if runtime.stress and runtime.stress.active then cancelDeveloperStressInternal("mod_state_changed") end
  if runtime.state.busy then
    cancelOperation("content_changed", "Operation cancelled because enabled mod content changed")
  else
    publishState()
  end
end

local function runDeveloperStress(options)
  initialize()
  if runtime.state.busy or (runtime.stress and runtime.stress.active) then
    setResult(false, "busy", "Another operation is already running")
    publishState()
    return false
  end
  if not runtime.capabilities.developerStress then
    setResult(false, "stress_unsupported", "No supported operation is available for developer stress diagnostics")
    publishState()
    return false
  end
  local state, createError = stressRunner.create(options, adapter.clock())
  if not state then
    setResult(false, createError, "Developer stress options exceed the safe limits")
    publishState()
    return false
  end
  local okVehicle, vehicleId = adapter.getCurrentVehicleId()
  if not okVehicle or vehicleId == nil then
    setResult(false, "no_active_vehicle", "Spawn or enter a vehicle before starting developer stress diagnostics")
    publishState()
    return false
  end
  state.generator = rngModule.new(state.options.seed)
  state.vehicleId = vehicleId
  state.originalSettings = util.deepCopy(runtime.settings)
  runtime.stress = state
  diagnosticsModule.setEnabled(runtime.diagnostics, true)
  diagnosticsModule.write(runtime.diagnostics, "I", "developer_stress_started", {
    iterations = state.options.iterations,
    mode = state.options.mode,
    maxDuration = state.options.maxDuration,
  }, true)
  publishState()
  return true
end

local function cancelDeveloperStress()
  return cancelDeveloperStressInternal("manual")
end

local function getDeveloperStressState()
  return publicStressState()
end

startStressIteration = function()
  local stress = runtime.stress
  if not stress or not stress.active or not stress.pendingNext or runtime.state.busy then return end
  if adapter.clock() - stress.startedAt >= stress.options.maxDuration then
    stressRunner.cancel(stress, "duration_limit")
    publishState()
    return
  end
  stress.pendingNext = false
  stress.currentIteration = stress.currentIteration + 1
  local iteration = stress.currentIteration
  local action = stressRunner.operationFor(stress, iteration)
  if not runtime.capabilities[action] then
    action = runtime.capabilities.scramble and "scramble" or "randomConfig"
  end
  local seed = stressRunner.iterationSeed(stress, stress.generator, iteration)
  stress.currentSeed = seed
  local snapshot = util.deepCopy(runtime.settings)
  snapshot.manualSeed = seed
  applySettingsSnapshot(snapshot)
  local before = stress.summary.attempts
  local started = runActionInternal(action, {
    stressIteration = iteration,
    operationTimeout = stress.options.operationTimeout,
  })
  if not started and stress.summary.attempts == before then
    stressRunner.record(stress, {
      success = false,
      duration = 0,
      seed = seed,
      phase = "selection",
    })
    if not stress.active then restoreStressSettings() end
  end
  publishState()
end

local function processPaintConfirmation()
  local active = runtime.active
  if not active or not active.paintConfirmation then return false end
  local confirmation = active.paintConfirmation
  local now = adapter.clock()
  if paintVerification.shouldCheck(confirmation, now) then
    paintVerification.recordAttempt(confirmation, now)
    local verified, reason = adapter.verifyPaints(confirmation.expected)
    diagnosticsModule.write(runtime.diagnostics, verified and "D" or "W", "paint_confirmation_attempt", {
      strategy = confirmation.strategy,
      attempt = confirmation.attempts,
      verified = verified,
      reason = reason,
      elapsed = now - confirmation.startedAt,
    })
    if verified then
      active.paintConfirmation = nil
      completeChaos(active)
      return true
    end
  end
  if paintVerification.expired(confirmation, now) then
    active.paintConfirmation = nil
    failActive(adapter.errorValue("paint_apply_unconfirmed", "Paint write was not confirmed within the bounded read-back window", {
      strategy = confirmation.strategy,
      attempts = confirmation.attempts,
      elapsed = now - confirmation.startedAt,
    }), true, "paint")
    return true
  end
  return true
end

local function onUpdate()
  if runtime.stress and runtime.stress.active
    and adapter.clock() - runtime.stress.startedAt >= runtime.stress.options.maxDuration
  then
    cancelDeveloperStressInternal("duration_limit")
    return
  end
  if processPaintConfirmation() then return end
  if runtime.state.busy and operationState.isExpired(runtime.state) then
    local active = runtime.active
    local phase = active and active.wait and active.wait.phase or active and active.phase or "lifecycle"
    if phase == "rollback" then
      finishOperation(false, "rollback_timeout", "Rollback vehicle reload timed out", {rollback = "timeout"})
    else
      failActive(adapter.errorValue(phase .. "_reload_timeout", "Operation timed out while " .. tostring(
        active and active.wait and active.wait.reason or phase
      )), true, phase)
    end
    return
  end
  startStressIteration()
end

local function onExtensionLoaded()
  initialize()
  rebuildIndex()
  publishState()
end

M.runAction = runAction
M.randomConfig = function(settingsSnapshot) return runAction("randomConfig", settingsSnapshot) end
M.scramble = function(settingsSnapshot) return runAction("scramble", settingsSnapshot) end
M.fullRandom = function(settingsSnapshot) return runAction("fullRandom", settingsSnapshot) end
M.undo = function() return runAction("undo") end
M.reindex = function() return runAction("reindex") end
M.updateSettings = updateSettings
M.requestState = requestState
M.runDeveloperStress = runDeveloperStress
M.cancelDeveloperStress = cancelDeveloperStress
M.getDeveloperStressState = getDeveloperStressState
M.onExtensionLoaded = onExtensionLoaded
M.onVehicleSpawned = onVehicleSpawned
M.onVehicleSwitched = onVehicleSwitched
M.onVehicleDestroyed = onVehicleDestroyed
M.onClientEndMission = onClientEndMission
M.onModActivated = onModStateChanged
M.onModDeactivated = onModStateChanged
M.onUpdate = onUpdate

return M
