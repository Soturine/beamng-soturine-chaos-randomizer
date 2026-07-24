local adapter = require("ge/extensions/soturineChaosRandomizer/apiAdapter")
local configSelector = require("ge/extensions/soturineChaosRandomizer/configSelector")
local configVerification = require("ge/extensions/soturineChaosRandomizer/configVerification")
local contentIndex = require("ge/extensions/soturineChaosRandomizer/contentIndex")
local coverageLimits = require("ge/extensions/soturineChaosRandomizer/coverageLimits")
local candidateIsolation = require("ge/extensions/soturineChaosRandomizer/candidateIsolation")
local diagnosticsModule = require("ge/extensions/soturineChaosRandomizer/diagnostics")
local failureAttribution = require("ge/extensions/soturineChaosRandomizer/failureAttribution")
local historyModule = require("ge/extensions/soturineChaosRandomizer/history")
local historyTransaction = require("ge/extensions/soturineChaosRandomizer/historyTransaction")
local lifecycle = require("ge/extensions/soturineChaosRandomizer/lifecycle")
local mutationEngine = require("ge/extensions/soturineChaosRandomizer/mutationEngine")
local mutationPolicy = require("ge/extensions/soturineChaosRandomizer/mutationPolicy")
local operationState = require("ge/extensions/soturineChaosRandomizer/operationState")
local progressWatchdog = require("ge/extensions/soturineChaosRandomizer/progressWatchdog")
local paintRandomizer = require("ge/extensions/soturineChaosRandomizer/paintRandomizer")
local paintCoverageLedger = require("ge/extensions/soturineChaosRandomizer/paintCoverageLedger")
local paintVerification = require("ge/extensions/soturineChaosRandomizer/paintVerification")
local partBatchRecovery = require("ge/extensions/soturineChaosRandomizer/partBatchRecovery")
local rngModule = require("ge/extensions/soturineChaosRandomizer/rng")
local settingsModule = require("ge/extensions/soturineChaosRandomizer/settings")
local slotScanner = require("ge/extensions/soturineChaosRandomizer/slotScanner")
local slotCoverageLedger = require("ge/extensions/soturineChaosRandomizer/slotCoverageLedger")
local stressRunner = require("ge/extensions/soturineChaosRandomizer/stressRunner")
local treeConvergence = require("ge/extensions/soturineChaosRandomizer/treeConvergence")
local timeSource = require("ge/extensions/soturineChaosRandomizer/timeSource")
local tuningCoverageLedger = require("ge/extensions/soturineChaosRandomizer/tuningCoverageLedger")
local tuningPipeline = require("ge/extensions/soturineChaosRandomizer/tuningPipeline")
local util = require("ge/extensions/soturineChaosRandomizer/util")
local validator = require("ge/extensions/soturineChaosRandomizer/validator")
local vehicleSelector = require("ge/extensions/soturineChaosRandomizer/vehicleSelector")
local vehicleDNA = require("ge/extensions/soturineChaosRandomizer/vehicleDNA")
local vehicleDNACompatibility = require("ge/extensions/soturineChaosRandomizer/vehicleDNACompatibility")
local vehicleDNAImport = require("ge/extensions/soturineChaosRandomizer/vehicleDNAImport")
local vehicleDNAFingerprint = require("ge/extensions/soturineChaosRandomizer/vehicleDNAFingerprint")
local vehicleDNANormalizer = require("ge/extensions/soturineChaosRandomizer/vehicleDNANormalizer")
local vehicleDNAPassBudget = require("ge/extensions/soturineChaosRandomizer/vehicleDNAPassBudget")
local vehicleDNALocks = require("ge/extensions/soturineChaosRandomizer/vehicleDNALocks")
local vehicleDNAMutations = require("ge/extensions/soturineChaosRandomizer/vehicleDNAMutations")
local vehicleDNACompare = require("ge/extensions/soturineChaosRandomizer/vehicleDNACompare")
local vehicleDNAGallery = require("ge/extensions/soturineChaosRandomizer/vehicleDNAGallery")
local vehicleDNAPackage = require("ge/extensions/soturineChaosRandomizer/vehicleDNAPackage")
local vehicleDNARestore = require("ge/extensions/soturineChaosRandomizer/vehicleDNARestore")
local vehicleDNASchema = require("ge/extensions/soturineChaosRandomizer/vehicleDNASchema")
local vehicleDNAStorage = require("ge/extensions/soturineChaosRandomizer/vehicleDNAStorage")
local vehicleRecovery = require("ge/extensions/soturineChaosRandomizer/vehicleRecovery")
local vehicleTargetTracker = require("ge/extensions/soturineChaosRandomizer/vehicleTargetTracker")
local vehicleStabilizer = require("ge/extensions/soturineChaosRandomizer/vehicleStabilizer")
local productionModules = {
  lineupManager = require("ge/extensions/soturineChaosRandomizer/lineupManager"),
  lineupSchema = require("ge/extensions/soturineChaosRandomizer/lineupSchema"),
  lineupStorage = require("ge/extensions/soturineChaosRandomizer/lineupStorage"),
  managedRegistry = require("ge/extensions/soturineChaosRandomizer/managedVehicleRegistry"),
  spawnAdapter = require("ge/extensions/soturineChaosRandomizer/spawnApiAdapter"),
  spawnDirector = require("ge/extensions/soturineChaosRandomizer/spawnDirector"),
  aiAdapter = require("ge/extensions/soturineChaosRandomizer/aiAdapter"),
  aiDirector = require("ge/extensions/soturineChaosRandomizer/aiDirector"),
  destinationMarker = require("ge/extensions/soturineChaosRandomizer/destinationMarker"),
  routePlanner = require("ge/extensions/soturineChaosRandomizer/routePlanner"),
}

local M = {}
local production = {}

M.dependencies = {"core_modmanager", "core_vehicle_manager", "core_vehicle_partmgmt", "core_vehicles"}

local EXTENSION_VERSION = "0.6.0"
local TARGET_BEAMNG = "0.38.6.0.19963"
local WAIT_TIMEOUT = 25
local PAINT_CONFIRM_TIMEOUT = 2
local RECENT_LIMIT = 4
local DNA_RESTORE_TIMEOUT = 120

local runtime = {
  initialized = false,
  settings = settingsModule.defaults(),
  index = contentIndex.create(),
  state = operationState.create(adapter.clock, WAIT_TIMEOUT),
  time = timeSource.create(adapter.clock),
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
  recovery = vehicleRecovery.create(),
  lineup = {
    current = nil,
    library = productionModules.lineupStorage.create(20),
    loaded = false,
    pendingNext = false,
  },
  managedVehicles = productionModules.managedRegistry.create(32),
  spawnDirector = {preview = nil, run = nil, lastResult = nil},
  aiDirector = productionModules.aiDirector.create(32),
  destination = productionModules.destinationMarker.create(),
  aiRoute = productionModules.routePlanner.create(16),
  uiMode = "standard",
  performance = {
    indexBuilds = 0,
    indexCacheHits = 0,
    lastIndexDuration = 0,
    lastOperation = nil,
    garageLoadMs = 0,
    compatibilityMs = 0,
    thumbnailLoadMs = 0,
    compareMs = 0,
    exportMs = 0,
    importMs = 0,
  },
  dna = {
    library = vehicleDNAStorage.create(100),
    loaded = false,
    loadStatus = "not_loaded",
    pending = nil,
    preflight = nil,
    exportText = nil,
    selectedId = nil,
    page = 0,
    pageSize = 8,
    query = {search = "", filter = "all", sort = "updated", model = "", tag = "", collection = ""},
    details = nil,
    comparison = nil,
    sharePreview = nil,
    importPreview = nil,
    thumbnailPending = nil,
  },
}

local startPaint
local startTuning
local processMutationPass
local startStressIteration
local processDNAParts
local startDNATuning
local startDNAPaint
local validateDNAFinal
local verifyDNAFinal
local runDNATargetPreflight
local completeReplayGeneration
local cancelOperation
local attemptPartBatchRollback
local applyNextIsolationBatch
local preflightVehicleDNA
local startVehicleDNABaseOperation

local function addDNADeviation(active, deviation)
  if type(deviation) ~= "table" then return end
  active.dnaDeviationKeys = active.dnaDeviationKeys or {}
  local key = vehicleDNACompatibility.deviationKey(deviation)
  if active.dnaDeviationKeys[key] then return end
  active.dnaDeviationKeys[key] = true
  active.dnaDeviations[#active.dnaDeviations + 1] = util.deepCopy(deviation)
end

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
  local storageMetrics = vehicleDNAStorage.metrics(runtime.dna.library) or {}
  local garageStarted = adapter.clock()
  local query = util.deepCopy(runtime.dna.query)
  query.offset, query.limit = runtime.dna.page * runtime.dna.pageSize, runtime.dna.pageSize
  local garageEntries, garageTotal = vehicleDNAStorage.query(runtime.dna.library, query)
  runtime.performance.garageLoadMs = math.max(0, (adapter.clock() - garageStarted) * 1000)
  runtime.performance.storageBytes = storageMetrics.canonicalBytes or 0
  runtime.performance.storageElements = storageMetrics.elementCount or 0
  local publicSettings = util.deepCopy(runtime.settings)
  publicSettings.lockProfile = nil
  local lockProfile = vehicleDNALocks.normalize(runtime.settings.lockProfile)
  local trackerMetrics = runtime.active and runtime.active.targetTracker
    and vehicleTargetTracker.summary(runtime.active.targetTracker, adapter.clock()) or nil
  local recoveryMetrics = vehicleRecovery.metrics(runtime.recovery)
  local lifecycleMetrics = operationState.summary(runtime.state)
  local clockMetrics = timeSource.snapshot(runtime.time)
  local watchdogMetrics = runtime.active and runtime.active.progressWatchdog
    and progressWatchdog.snapshot(runtime.active.progressWatchdog, clockMetrics.realMonotonicTime) or nil
  local okActiveVehicle, activeVehicleId = adapter.getCurrentVehicleId()
  local publicLineup
  if runtime.lineup.current then
    publicLineup = {
      id = runtime.lineup.current.id, name = runtime.lineup.current.name,
      episodeSeed = runtime.lineup.current.episodeSeed, preset = runtime.lineup.current.preset,
      active = runtime.lineup.current.active == true,
      summary = productionModules.lineupManager.summary(runtime.lineup.current), competitors = {},
    }
    for _, competitor in ipairs(runtime.lineup.current.competitors or {}) do
      publicLineup.competitors[#publicLineup.competitors + 1] = {
        index = competitor.index, id = competitor.id, name = competitor.name,
        seed = competitor.seed, status = competitor.status, warning = competitor.warning,
        dnaId = competitor.dnaId, modelKey = competitor.modelKey,
        position = competitor.position, configuration = competitor.configuration,
        source = util.deepCopy(competitor.source), dependencies = util.deepCopy(competitor.dependencies),
        coverage = util.deepCopy(competitor.coverage), targetGeneration = competitor.targetGeneration,
        managedHandle = competitor.managedHandle,
        raceStatus = competitor.raceStatus, traits = util.deepCopy(competitor.traits),
      }
    end
  end
  return {
    extensionVersion = EXTENSION_VERSION,
    gameVersion = adapter.getGameVersion(),
    busy = operationState.deriveBusy(runtime.state),
    operationState = runtime.state.state,
    lifecyclePhase = runtime.state.phase,
    lifecycle = lifecycleMetrics,
    clocks = clockMetrics,
    paused = clockMetrics.paused,
    stalled = watchdogMetrics and watchdogMetrics.stalled == true or false,
    stalledWarning = watchdogMetrics and watchdogMetrics.warned == true or false,
    watchdog = watchdogMetrics,
    operationType = runtime.state.kind,
    waitReason = runtime.active and runtime.active.wait and runtime.active.wait.reason or nil,
    targetStatus = trackerMetrics and trackerMetrics.status or nil,
    targetMetrics = trackerMetrics,
    activeVehicleAvailable = okActiveVehicle and activeVehicleId ~= nil,
    uiMode = runtime.uiMode,
    recovery = recoveryMetrics,
    token = runtime.state.token,
    transaction = runtime.active and {
      recoveryOnly = runtime.active.recoveryOnly == true,
      originalSnapshot = runtime.active.operationOriginalSnapshot and {
        modelKey = runtime.active.operationOriginalSnapshot.modelKey,
        vehicleId = runtime.active.operationOriginalSnapshot.vehicleId,
      } or nil,
      candidateBase = runtime.active.operationCandidateBase and {
        modelKey = runtime.active.operationCandidateBase.modelKey,
        vehicleId = runtime.active.operationCandidateBase.vehicleId,
      } or nil,
      currentTarget = util.deepCopy(runtime.active.operationCurrentTarget),
      recoveryTarget = util.deepCopy(runtime.active.operationRecoveryTarget),
      mutationPlan = runtime.active.operationMutationPlan and {
        stage = runtime.active.operationMutationPlan.stage,
        operationId = runtime.active.operationMutationPlan.operationId,
        targetGeneration = runtime.active.operationMutationPlan.targetGeneration,
      } or nil,
      pending = {
        currentBatch = runtime.active.currentBatch and #runtime.active.currentBatch or 0,
        afterReload = runtime.active.afterReload and 1 or 0,
        tuning = runtime.active.pendingTuningChanges and #runtime.active.pendingTuningChanges or 0,
        paint = runtime.active.paintConfirmation and 1 or 0,
        treeTimer = runtime.active.treeRescanAt and 1 or 0,
      },
    } or nil,
    progress = util.deepCopy(runtime.progress),
    settings = publicSettings,
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
    coverage = runtime.active and {
      slots = runtime.active.slotLedger and slotCoverageLedger.summary(runtime.active.slotLedger) or nil,
      tuning = runtime.active.tuningLedger and tuningCoverageLedger.summary(runtime.active.tuningLedger) or nil,
      paint = runtime.active.paintLedger and paintCoverageLedger.summary(runtime.active.paintLedger) or nil,
      limits = util.deepCopy(runtime.active.coverageLimits),
      convergence = runtime.active.convergence and treeConvergence.metrics(runtime.active.convergence) or nil,
    } or runtime.lastResult and util.deepCopy(runtime.lastResult.details and runtime.lastResult.details.coverage) or nil,
    developerStress = publicStressState(),
    lineup = {
      current = publicLineup,
      stored = #(runtime.lineup.library.entries or {}),
      schemaVersion = productionModules.lineupSchema.SCHEMA_VERSION,
      storagePath = adapter.LINEUP_LIBRARY_PATH,
    },
    spawnDirector = {
      preview = runtime.spawnDirector.preview and {
        count = #(runtime.spawnDirector.preview.placements or {}),
        mode = runtime.spawnDirector.preview.options and runtime.spawnDirector.preview.options.mode,
      } or nil,
      run = runtime.spawnDirector.run and {
        active = runtime.spawnDirector.run.active, cursor = runtime.spawnDirector.run.cursor,
        total = #(runtime.spawnDirector.run.placements or {}), spawned = #(runtime.spawnDirector.run.spawned or {}),
        failures = #(runtime.spawnDirector.run.failures or {}),
      } or nil,
      lastResult = util.deepCopy(runtime.spawnDirector.lastResult),
      managed = productionModules.managedRegistry.list(runtime.managedVehicles),
    },
    aiDirector = {
      capabilities = productionModules.aiAdapter.capabilities(),
      vehicles = productionModules.aiDirector.list(runtime.aiDirector),
      destination = util.deepCopy(runtime.destination),
      route = util.deepCopy(runtime.aiRoute),
      diagnostics = util.deepCopy(runtime.aiDirector.diagnostics),
    },
    performance = util.deepCopy(runtime.performance),
    locks = {
      summary = vehicleDNALocks.summary(lockProfile),
      vehicle = lockProfile.vehicle,
      configuration = lockProfile.configuration,
      categories = util.deepCopy(lockProfile.categories),
      tuningAll = lockProfile.tuning.all,
      paintAll = lockProfile.paints.all,
    },
    garage = {
      loaded = runtime.dna.loaded,
      loadStatus = runtime.dna.loadStatus,
      entries = garageEntries,
      total = garageTotal,
      page = runtime.dna.page,
      pageSize = runtime.dna.pageSize,
      pageCount = math.max(1, math.ceil(garageTotal / runtime.dna.pageSize)),
      limit = runtime.dna.library.limit,
      storage = storageMetrics,
      query = util.deepCopy(runtime.dna.query),
      pendingSave = runtime.dna.pending ~= nil,
      pending = runtime.dna.pending and {
        id = runtime.dna.pending.id,
        name = runtime.dna.pending.name,
        modelKey = runtime.dna.pending.final.modelKey,
        seed = runtime.dna.pending.generation.seed,
      } or nil,
      selectedId = runtime.dna.selectedId,
      preflight = util.deepCopy(runtime.dna.preflight),
      exportReady = runtime.dna.exportText ~= nil,
      details = util.deepCopy(runtime.dna.details),
      comparison = runtime.dna.comparison and {
        leftId = runtime.dna.comparison.leftId, rightId = runtime.dna.comparison.rightId,
        equal = runtime.dna.comparison.equal, differenceCount = #(runtime.dna.comparison.differences or {}),
        truncated = runtime.dna.comparison.truncated == true,
      } or nil,
      sharePreview = util.deepCopy(runtime.dna.sharePreview),
      importPreview = runtime.dna.importPreview and util.deepCopy(runtime.dna.importPreview.public) or nil,
      thumbnailPending = runtime.dna.thumbnailPending,
      schemaVersion = vehicleDNASchema.SCHEMA_VERSION,
      generatorVersion = vehicleDNASchema.GENERATOR_VERSION,
      storagePath = adapter.DNA_LIBRARY_PATH,
    },
  }
end

local function publishState()
  adapter.emit("SoturineChaosRandomizerState", publicState())
end

local function setProgress(label, value)
  runtime.progress = {label = label, value = util.clamp(value or 0, 0, 1)}
  publishState()
end

local function noteProgress(active, kind, reason)
  if active and active.progressWatchdog then
    progressWatchdog.note(active.progressWatchdog, kind, reason, runtime.time.realMonotonicTime)
  end
end

local function setLifecyclePhase(active, phase, timeout, reason)
  local ok, phaseError = operationState.setPhase(runtime.state, phase, timeout, reason)
  if ok then
    if active then
      active.lifecyclePhase = phase
      active.phaseGeneration = runtime.state.phaseGeneration
    end
    noteProgress(active, "phase", reason or phase)
  end
  return ok, phaseError
end

local function targetDescriptor(state)
  if type(state) ~= "table" then return nil end
  return {
    vehicleId = state.vehicleId,
    modelKey = state.modelKey,
    configKey = configVerification.stableKey(
      state.configKey or state.selectedConfiguration
        or (state.configIdentity and state.configIdentity.path)
    ),
  }
end

local function bindMutationPlan(active, stage)
  local expected = util.deepCopy(active.operationCurrentTarget or {
    vehicleId = active.vehicleId,
    modelKey = active.modelKey or (active.selectedModel and active.selectedModel.key),
  })
  local context = operationState.captureContext(runtime.state, expected)
  active.operationMutationPlan = {
    stage = stage,
    operationId = context.operationId,
    operationToken = context.operationToken,
    operationGeneration = context.operationGeneration,
    phaseGeneration = context.phaseGeneration,
    targetGeneration = context.targetGeneration,
    expectedTarget = expected,
  }
  return active.operationMutationPlan
end

local function guardMutationWrite(active, stage)
  if not active or active.recoveryOnly then
    local code = "recovery_target_received_stale_mutation"
    if active then
      diagnosticsModule.write(runtime.diagnostics, "E", code, {
        stage = stage,
        recoveryOnly = true,
        operationId = runtime.state.operationId,
        targetGeneration = runtime.state.targetGeneration,
      }, true)
    end
    return false, adapter.errorValue(code, "A stale mutation was blocked from the recovery target")
  end
  local plan = active.operationMutationPlan
  if type(plan) ~= "table" or plan.stage ~= stage then
    return false, adapter.errorValue("mutation_plan_unbound", "Mutation write has no current transaction binding", {stage = stage})
  end
  local okObserved, observedOrError = adapter.getVerificationState()
  if not okObserved then return false, observedOrError end
  local observed = targetDescriptor(observedOrError)
  local valid, reason = operationState.validateContinuation(runtime.state, plan, observed)
  if not valid then
    diagnosticsModule.write(runtime.diagnostics, "E", reason, {
      stage = stage,
      expected = util.deepCopy(plan.expectedTarget),
      observed = observed,
      recoveryOnly = active.recoveryOnly == true,
    }, true)
    return false, adapter.errorValue(reason, "A stale or wrong-target mutation write was blocked", {
      stage = stage, expected = plan.expectedTarget, observed = observed,
    })
  end
  return true
end

local function noteSuccessfulWrite(active, stage)
  noteProgress(active, "write", stage .. "_write_confirmed")
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
  if active and (success == true or (details and details.rollback == "completed")) then
    local readable, finalSnapshot = adapter.captureCurrentState("operation_final", active.seed)
    if readable then
      vehicleRecovery.rememberReadable(runtime.recovery, finalSnapshot)
      if success == true and terminalState == "completed" then
        vehicleRecovery.rememberCompletedGood(runtime.recovery, finalSnapshot)
      end
    end
  end
  if active then vehicleRecovery.cleanup(active) end
  details = type(details) == "table" and details or {}
  if active then
    details.targetGeneration = active.targetGeneration
    details.lifecycleAcceptance = {
      finalValidationPassed = success == true,
      busy = operationState.deriveBusy(runtime.state),
      targetConfirmed = active.operationCurrentTarget ~= nil,
      pendingWrites = active.currentBatch and #active.currentBatch or 0,
      pendingTimers = (active.treeRescanAt and 1 or 0) + (active.paintConfirmation and 1 or 0),
      pendingCallbacks = active.targetTracker and 1 or 0,
      staleCallbackCount = runtime.state.staleCallbackCount,
    }
  end
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
      lifecycle = active.lastTargetMetrics and util.deepCopy(active.lastTargetMetrics) or nil,
      recovery = util.deepCopy(vehicleRecovery.metrics(runtime.recovery)),
      batchRecovery = active.batchRecovery and partBatchRecovery.metrics(active.batchRecovery) or nil,
      success = success == true,
    }
  end
  if active and active.lineupIndex and runtime.lineup.current then
    local dna = runtime.dna.pending and util.deepCopy(runtime.dna.pending) or nil
    local okSnapshot, spawnSnapshot = adapter.captureCurrentState("lineup", active.seed)
    productionModules.lineupManager.record(
      runtime.lineup.current, active.lineupIndex, runtime.lastResult, dna, active.lineupTargetGeneration
    )
    local competitor = runtime.lineup.current.competitors[active.lineupIndex]
    if competitor and okSnapshot then competitor.spawnConfig = util.deepCopy(spawnSnapshot.config) end
    if dna and runtime.capabilities.dnaWrite then
      local updated = vehicleDNAStorage.add(runtime.dna.library, dna)
      if updated then
        local saved = adapter.saveDNALibrary(updated, runtime.dna.library)
        if saved then runtime.dna.library = updated; runtime.dna.pending = nil end
      end
    end
    local lineup = runtime.lineup.current
    if success then
      lineup.consecutiveFailures = 0
    else
      lineup.consecutiveFailures = (lineup.consecutiveFailures or 0) + 1
      if competitor and (competitor.attemptCount or 0) < (lineup.maxAttemptsPerCompetitor or 3)
        and lineup.consecutiveFailures < (lineup.maxConsecutiveFailures or 4)
      then
        competitor.status = "Pending"
        competitor.generationStatus = "Pending"
        competitor.warning = "Retrying with an independent candidate substream after recovery"
        lineup.nextIndex = active.lineupIndex
      elseif lineup.consecutiveFailures >= (lineup.maxConsecutiveFailures or 4) then
        lineup.active = false
        lineup.warnings[#lineup.warnings + 1] = "Generation stopped at the consecutive failure limit"
      end
    end
    if type(production.persistCurrentLineup) == "function" then production.persistCurrentLineup() end
    runtime.lineup.pendingNext = lineup.active == true
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
  runtime.dna.library.limit = runtime.settings.dnaLibraryLimit
  if type(adapter.loadDNALibrary) == "function" and runtime.capabilities.dnaRead then
    local okLibrary, storedLibrary, source = adapter.loadDNALibrary()
    if okLibrary and storedLibrary == nil then
      runtime.dna.library = vehicleDNAStorage.create(runtime.settings.dnaLibraryLimit)
      runtime.dna.loaded = true
      runtime.dna.loadStatus = "empty"
    elseif okLibrary then
      local normalized, libraryError = vehicleDNAStorage.normalizeLibrary(storedLibrary, runtime.settings.dnaLibraryLimit)
      if normalized then
        runtime.dna.library = normalized
        runtime.dna.loaded = true
        runtime.dna.loadStatus = source or "primary"
      else
        local backupOk, backup = false, nil
        if type(adapter.loadDNALibraryBackup) == "function" then backupOk, backup = adapter.loadDNALibraryBackup() end
        local recovered = backupOk and vehicleDNAStorage.normalizeLibrary(backup, runtime.settings.dnaLibraryLimit) or nil
        if recovered then
          runtime.dna.library = recovered
          runtime.dna.loaded = true
          runtime.dna.loadStatus = "last_known_good_recovered"
          diagnosticsModule.write(runtime.diagnostics, "W", "dna_library_recovered", {primaryReason = libraryError}, true)
        else
          runtime.dna.loadStatus = libraryError or "invalid"
        end
      end
    else runtime.dna.loadStatus = "unavailable" end
  end
  if type(adapter.loadLineupLibrary) == "function" and runtime.capabilities.lineupRead then
    local okLineups, storedLineups = adapter.loadLineupLibrary()
    if okLineups then
      runtime.lineup.library = productionModules.lineupStorage.load(storedLineups, 20)
      runtime.lineup.loaded = true
    end
  end
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
  local canStartEmpty = kind == "randomConfig" or kind == "fullRandom"
  if (not okId or vehicleId == nil) and not canStartEmpty then
    return false, adapter.errorValue("no_active_vehicle", "Scramble requires an active vehicle. Use Random Car or Spawn Safe Vehicle.")
  end
  if not okId then vehicleId = nil end
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
    settings = util.deepCopy(runtime.settings),
    policy = mutationPolicy.fromSettings(runtime.settings),
    originalVehicleId = vehicleId,
    vehicleId = vehicleId,
    pass = 1,
    coveragePass = 0,
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
    operationId = runtime.state.operationId,
    operationGeneration = runtime.state.operationGeneration,
    phaseGeneration = runtime.state.phaseGeneration,
    targetGeneration = runtime.state.targetGeneration,
    recoveryOnly = false,
    progressWatchdog = progressWatchdog.create(adapter.clock()),
    phase = kind == "scramble" and "parts" or "selection",
    stressIteration = context.stressIteration,
    waitTimeout = timeout,
    lineupExcludedModels = util.deepCopy(context.lineupExcludedModels),
    lineupExcludedConfigurations = util.deepCopy(context.lineupExcludedConfigurations),
    lineupRules = util.deepCopy(context.lineupRules),
    lineupAcceptedCompetitors = util.deepCopy(context.lineupAcceptedCompetitors),
    reloadCount = 0,
    partPassesApplied = 0,
    safetyBaseline = nil,
    safetyResult = nil,
    phaseTimings = {},
    startedWithoutVehicle = vehicleId == nil,
    batchRecovery = partBatchRecovery.create(),
    treeStabilizer = vehicleStabilizer.create({persistentTreeScans = 2}),
    safeOfficial = context.safeOfficial == true,
    stageReasons = {},
    coverageLimits = coverageLimits.copyDefaults(),
    slotLedger = slotCoverageLedger.create({}),
    tuningLedger = tuningCoverageLedger.create(),
    paintLedger = nil,
    convergence = treeConvergence.create(coverageLimits.copyDefaults(), adapter.clock()),
  }
  diagnosticsModule.write(runtime.diagnostics, "D", "operation_started", {
    kind = kind,
    seed = seed,
    vehicleId = vehicleId,
    chaos = runtime.settings.chaos,
    stressIteration = context.stressIteration,
    operationId = runtime.state.operationId,
    operationGeneration = runtime.state.operationGeneration,
    phaseGeneration = runtime.state.phaseGeneration,
    targetGeneration = runtime.state.targetGeneration,
  })
  setProgress("Starting " .. kind, 0.02)
  return true, runtime.active
end

local function applyCreativeContext(active, context)
  context = type(context) == "table" and context or {}
  if context.seed then
    active.seed = rngModule.normalizeSeed(context.seed)
    active.rng = rngModule.new(active.seed)
    runtime.lastSeed = active.seed
  end
  if context.creativeOperation then
    active.creativeOperation = context.creativeOperation
    active.captureOperation = context.captureOperation or active.kind
    active.lockProfileSnapshot = vehicleDNALocks.normalize(context.lockProfile or runtime.settings.lockProfile)
    active.pendingLineage = util.deepCopy(context.lineage or {})
    if context.settings then active.policy = mutationPolicy.fromSettings(context.settings) end
  end
  return active
end

local function captureOriginal(active)
  setLifecyclePhase(active, "capturing_original", false, "capture_original_snapshot")
  if active.startedWithoutVehicle then
    active.originalState = nil
    return true
  end
  local ok, snapshot = adapter.captureCurrentState(active.kind, active.seed)
  if not ok then return false, snapshot end
  vehicleRecovery.rememberReadable(runtime.recovery, snapshot)
  active.operationOriginalSnapshot = util.deepCopy(snapshot)
  active.operationCurrentTarget = targetDescriptor(snapshot)
  operationState.nextTarget(runtime.state, active.operationCurrentTarget)
  active.targetGeneration = runtime.state.targetGeneration
  return historyTransaction.capture(active, snapshot)
end

local function commitHistory(active)
  if active.startedWithoutVehicle and not active.originalState then
    active.destructiveStarted = true
    return true
  end
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
  local availableModels = {}
  for _, model in ipairs(models) do
    local availableConfigs = {}
    for _, config in ipairs(model.configs or {}) do
      local allowedByCircuit = (not runtime.recovery.circuitOpen and not active.safeOfficial) or config.sourceKind == "official"
      if allowedByCircuit and not vehicleRecovery.isQuarantined(runtime.recovery, config.modelKey, config.key) then
        availableConfigs[#availableConfigs + 1] = config
      end
    end
    if #availableConfigs > 0 then
      local copy = util.deepCopy(model)
      copy.configs = availableConfigs
      availableModels[#availableModels + 1] = copy
    end
  end
  models = availableModels
  if active.lineupRules then
    local filtered, variety = productionModules.lineupManager.filterModels(
      models, active.lineupRules, active.lineupAcceptedCompetitors
    )
    models = filtered
    active.lineupVariety = variety
  end
  local vehicleLocked = false
  if active.lockProfileSnapshot and vehicleDNALocks.requiresModel(active.lockProfileSnapshot) then
    local currentModel = active.lockProfileSnapshot.boundModelKey
    if not currentModel then
      return nil, nil, adapter.errorValue("lock_model_unresolved", "Model-bound locks have no compatible vehicle binding")
    end
    local sameModel = {}
    for _, model in ipairs(models) do if model.key == currentModel then sameModel[#sameModel + 1] = model end end
    models = sameModel
    vehicleLocked = true
  end
  if active.excludeModelKey and not vehicleLocked and #models > 1 then
    local alternatives = {}
    for _, model in ipairs(models) do
      if model.key ~= active.excludeModelKey then alternatives[#alternatives + 1] = model end
    end
    if #alternatives > 0 then models = alternatives end
  end
  if #models == 0 then return nil, nil, adapter.errorValue("no_eligible_vehicles", "No vehicles match the current content filters") end
  local manualSeed = type(runtime.settings.manualSeed) == "string" and runtime.settings.manualSeed ~= ""
  local recentModels = active.lineupExcludedModels or (manualSeed and {} or runtime.recentModels)
  local recentConfigs = active.lineupExcludedConfigurations or (manualSeed and {} or runtime.recentConfigs)
  active.selectionContext = {
    fairness = runtime.settings.selectionFairness,
    contentFilter = runtime.settings.contentFilter,
    manualSeed = manualSeed,
    recentPolicy = manualSeed and "ignored_for_manual_seed" or "bounded_session_recent",
    eligibleModels = #models,
    vehicleLock = vehicleLocked,
  }
  if runtime.settings.selectionFairness == "configuration" then
    local configs = contentIndex.eligibleConfigs(runtime.index, runtime.settings)
    local filteredConfigs = {}
    local allowedModels, allowedConfigs = {}, {}
    for _, model in ipairs(models) do
      allowedModels[model.key] = true
      for _, allowedConfig in ipairs(model.configs or {}) do
        allowedConfigs[configSelector.identifier(allowedConfig)] = true
      end
    end
    for _, config in ipairs(configs) do
      if allowedModels[config.modelKey] and allowedConfigs[configSelector.identifier(config)]
        and not vehicleRecovery.isQuarantined(runtime.recovery, config.modelKey, config.key)
        and (not (active.lockProfileSnapshot and active.lockProfileSnapshot.configuration)
          or configVerification.normalizePath(config.path or config.key) == active.lockProfileSnapshot.boundConfigKey)
      then
        filteredConfigs[#filteredConfigs + 1] = config
      end
    end
    configs = filteredConfigs
    active.selectionContext.eligibleConfigurations = #configs
    local config, selectionError = configSelector.select(configs, active.rng:fork("configuration"), recentConfigs)
    if not config then return nil, nil, adapter.errorValue(selectionError, "No configurations match the current filters") end
    for _, model in ipairs(models) do
      if model.key == config.modelKey then return model, config end
    end
    return nil, nil, adapter.errorValue("model_config_mismatch", "The selected configuration has no eligible model")
  end
  local model, modelError = vehicleSelector.select(models, active.rng:fork("vehicle"), recentModels)
  if not model then return nil, nil, adapter.errorValue(modelError, "No vehicles match the current filters") end
  active.selectionContext.eligibleConfigurations = #model.configs
  local selectableConfigs = model.configs
  if active.lockProfileSnapshot and active.lockProfileSnapshot.configuration then
    selectableConfigs = {}
    for _, candidate in ipairs(model.configs or {}) do
      if configVerification.normalizePath(candidate.path or candidate.key) == active.lockProfileSnapshot.boundConfigKey then
        selectableConfigs[#selectableConfigs + 1] = candidate
      end
    end
  end
  local config, configError = configSelector.select(selectableConfigs, active.rng:fork("configuration:" .. model.key), recentConfigs)
  if not config then return nil, nil, adapter.errorValue(configError, "The selected vehicle has no eligible configurations") end
  return model, config
end

local function enterWaiting(active, phase, afterReload, expected, label, value)
  active.phase = phase
  active.afterReload = afterReload
  local target = (phase == "spawn" or phase == "rollback" or phase == "undo" or phase == "dna_base_spawn")
    and "waitingForVehicle" or "waitingForReload"
  local ok, transitionError = operationState.transition(runtime.state, target, active.waitTimeout or WAIT_TIMEOUT)
  if not ok then return false, adapter.errorValue("state_error", transitionError) end
  local lifecyclePhase = (
      phase == "parts" or phase == "part_isolation_test"
      or phase == "part_batch_rollback" or phase == "dna_parts"
    ) and "waiting_parts_reload"
    or (phase == "tuning" or phase == "dna_tuning") and "waiting_tuning_reload"
    or (phase == "rollback") and (
      active.recoveryStep == "previous" and "recovering_previous"
      or active.recoveryStep == "last_known_good" and "recovering_last_completed_good"
      or "recovering_fallback"
    )
    or "tracking_target_identity"
  setLifecyclePhase(active, lifecyclePhase, active.waitTimeout or WAIT_TIMEOUT, "wait:" .. tostring(phase))
  expected = util.shallowMerge(expected or {}, {
    token = active.token,
    phase = phase,
    eventType = "onVehicleSpawned",
    startedAt = adapter.clock(),
  })
  local createsTarget = phase == "spawn" or phase == "rollback" or phase == "undo" or phase == "dna_base_spawn"
  local expectedTarget = {
    vehicleId = expected.vehicleId,
    modelKey = expected.modelKey,
    configKey = configVerification.stableKey(
      expected.configKey or (expected.configIdentity and expected.configIdentity.path)
    ),
  }
  if createsTarget then
    operationState.nextTarget(runtime.state, expectedTarget)
    active.targetGeneration = runtime.state.targetGeneration
  end
  active.phaseGeneration = runtime.state.phaseGeneration
  active.waitContext = operationState.captureContext(runtime.state, expectedTarget)
  active.wait = lifecycle.createExpectation(expected)
  active.wait.context = util.deepCopy(active.waitContext)
  active.targetTracker = vehicleTargetTracker.create({
    token = active.token,
    operationId = runtime.state.operationId,
    operationGeneration = runtime.state.operationGeneration,
    phaseGeneration = runtime.state.phaseGeneration,
    targetGeneration = runtime.state.targetGeneration,
    phase = phase,
    modelKey = active.wait.modelKey,
    configKey = active.wait.configKey,
    configIdentity = active.wait.configIdentity,
    parts = active.wait.parts,
    originalVehicleId = active.vehicleId,
    startedAt = active.wait.startedAt,
    timeout = active.waitTimeout or WAIT_TIMEOUT,
    recoveryOnly = active.recoveryOnly == true,
    stabilizer = {minimumFrames = 5, minimumScans = 2, pollInterval = 0.05, persistentTreeScans = 2},
    treeStabilizer = {minimumFrames = 2, minimumScans = 2, pollInterval = 0},
  })
  diagnosticsModule.write(runtime.diagnostics, "D", "lifecycle_wait_started", {
    phase = phase,
    waitReason = active.wait.reason,
    expectedEvent = active.wait.eventType,
    vehicleId = active.wait.vehicleId,
    modelKey = active.wait.modelKey,
    operationId = runtime.state.operationId,
    operationGeneration = runtime.state.operationGeneration,
    phaseGeneration = runtime.state.phaseGeneration,
    targetGeneration = runtime.state.targetGeneration,
    lifecyclePhase = runtime.state.phase,
  })
  setProgress(label, value)
  return true
end

local function bindReplacementTarget(active, result, phase)
  if type(result) ~= "table" or type(result.vehicleId) ~= "number" then
    return false, adapter.errorValue("vehicle_replace_target_ambiguous", "The replacement target could not be correlated")
  end
  active.expectedReplacementVehicleId = result.vehicleId
  active.replaceRequestModel = active.wait and active.wait.modelKey
  active.replaceRequestConfig = active.wait and (active.wait.configIdentity or active.wait.configKey)
  active.replaceIssuedAt = adapter.clock()
  active.replaceCorrelationStrategy = result.correlationStrategy
  active.vehicleId = result.vehicleId
  runtime.state.vehicleId = result.vehicleId
  if active.wait then active.wait.vehicleId = result.vehicleId end
  local boundTarget = {
    vehicleId = result.vehicleId,
    modelKey = active.wait and active.wait.modelKey or active.modelKey,
    configKey = configVerification.stableKey(active.wait and (
      active.wait.configKey or (active.wait.configIdentity and active.wait.configIdentity.path)
    )),
  }
  runtime.state.expectedTarget = util.deepCopy(boundTarget)
  if active.waitContext then active.waitContext.expectedTarget = util.deepCopy(boundTarget) end
  if active.recoveryOnly then
    active.operationRecoveryTarget = util.deepCopy(boundTarget)
  else
    active.operationCurrentTarget = util.deepCopy(boundTarget)
  end
  if active.targetTracker then
    vehicleTargetTracker.bindReturned(active.targetTracker, result.vehicleId, result.correlationStrategy)
  end
  noteProgress(active, "target", "replacement_target_bound")
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
  local ok, result = adapter.replaceVehicle(modelKey, config, active.replaceTargetVehicleId)
  active.replaceWriteInFlight = false
  if not ok then return false, result end
  local bound, bindError = bindReplacementTarget(active, result, phase)
  if not bound then return false, bindError end
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

local function startNextRecovery(active)
  active.recoveryIndex = (active.recoveryIndex or 0) + 1
  local step = active.recoverySteps and active.recoverySteps[active.recoveryIndex]
  if not step then
    finishOperation(false, "vehicle_recovery_failed", "The operation and all bounded vehicle recovery attempts failed", {
      originalFailure = active.rollbackFailure,
      recovery = vehicleRecovery.metrics(runtime.recovery),
      attempts = (active.recoveryIndex or 1) - 1,
    })
    return false
  end
  local snapshot = step.snapshot or {}
  local configValue = snapshot.config or snapshot.selectedConfiguration
  if type(configValue) == "table" and configValue.path then configValue = configValue.path end
  local configIdentity
  if step.kind == "safe_official" and type(snapshot.config) == "table" then
    configIdentity = adapter.prepareConfigExpectation(snapshot.config)
  end
  local okTransition = operationState.transition(runtime.state, "rollingBack", false)
  if not okTransition then runtime.state.state = "rollingBack" end
  active.phase = "rollback"
  active.recoveryStep = step.kind
  active.recoverySnapshot = util.deepCopy(snapshot)
  local okWait, waitError = enterWaiting(active, "rollback", "recovery", {
    modelKey = snapshot.modelKey,
    configIdentity = configIdentity,
    configKey = configIdentity and nil or snapshot.selectedConfiguration,
    parts = snapshot.partsTree and adapter.flattenChosenParts(snapshot.partsTree) or {},
    tuning = snapshot.tuning or {},
    paints = snapshot.paints,
  }, "Recovering vehicle: " .. tostring(step.kind), 0.1)
  if not okWait then
    diagnosticsModule.write(runtime.diagnostics, "E", "vehicle_recovery_step_failed", {
      step = step.kind, reason = waitError,
    }, true)
    return startNextRecovery(active)
  end
  local ok, rollbackResult = issueReplacement(active, snapshot.modelKey, configValue, "rollback")
  if not ok then
    diagnosticsModule.write(runtime.diagnostics, "E", "vehicle_recovery_step_failed", {
      step = step.kind, reason = rollbackResult,
    }, true)
    return startNextRecovery(active)
  end
  diagnosticsModule.write(runtime.diagnostics, "W", "vehicle_recovery_started", {
    step = step.kind, attempt = active.recoveryIndex, modelKey = snapshot.modelKey,
  }, true)
  return true
end

local function beginRollback(failure)
  local active = runtime.active
  if not active then return end
  active.rollbackFailure = failure
  active.recoverySteps = vehicleRecovery.choosePlan(runtime.recovery, active.originalState, runtime.index.allConfigs)
  active.recoveryIndex = 0
  active.token = operationState.invalidate(runtime.state, "recovery_started", {
    operation = true,
    target = true,
  })
  active.operationGeneration = runtime.state.operationGeneration
  active.phaseGeneration = runtime.state.phaseGeneration
  active.targetGeneration = runtime.state.targetGeneration
  vehicleRecovery.invalidateForRecovery(active)
  setLifecyclePhase(active, "rolling_back_operation", false, "recovery_started")
  diagnosticsModule.write(runtime.diagnostics, "W", "recovery_pipeline_invalidated", {
    operationId = runtime.state.operationId,
    operationGeneration = runtime.state.operationGeneration,
    phaseGeneration = runtime.state.phaseGeneration,
    targetGeneration = runtime.state.targetGeneration,
    recoveryOnly = true,
  }, true)
  startNextRecovery(active)
end

attemptPartBatchRollback = function(active, reason)
  if not active or not active.currentBatch or #active.currentBatch == 0 or not active.batchRecovery then
    return false, "part_batch_snapshot_missing"
  end
  local failedBatch = util.deepCopy(active.currentBatch)
  local configKey = active.selectedConfig and active.selectedConfig.key
    or active.originalState and active.originalState.selectedConfiguration
  if not active.candidateIsolation then
    active.candidateIsolation = candidateIsolation.create(failedBatch, active.coverageLimits.maxCandidateAttempts)
    active.isolationBaseTree = util.deepCopy(active.batchRecovery.currentBatch and active.batchRecovery.currentBatch.treeBefore or {})
    candidateIsolation.nextBatch(active.candidateIsolation)
  end
  candidateIsolation.record(active.candidateIsolation, false, reason)
  local retryAllowed, retryReason
  if #failedBatch == 1 then
    local decision = failedBatch[1]
    active.deferredPaths[decision.slotPath] = true
    retryAllowed, retryReason = partBatchRecovery.recordFailure(active.batchRecovery, {
      modelKey = active.modelKey or (active.selectedModel and active.selectedModel.key),
      configKey = configKey,
      slotPath = decision.slotPath,
      candidate = decision.selectedPart,
      pass = active.pass,
      confidence = "confirmed",
      scope = "session",
      failureType = "candidate",
    }, reason)
    if active.slotLedger then
      for _, entry in pairs(active.slotLedger.entries) do
        if entry.slotPath == decision.slotPath then
          entry.quarantinedCandidates[#entry.quarantinedCandidates + 1] = decision.selectedPart
          entry.status, entry.reason = "failed_and_rolled_back", reason
          entry.rollbackCount = (entry.rollbackCount or 0) + 1
        end
      end
    end
  else
    retryAllowed, retryReason = partBatchRecovery.recordSuspectFailure(active.batchRecovery, {
      modelKey = active.modelKey or (active.selectedModel and active.selectedModel.key),
      configKey = configKey,
      pass = active.pass,
      batchSize = #failedBatch,
    }, reason)
  end
  if not retryAllowed then return false, retryReason end
  local rollbackAllowed, treeOrReason = partBatchRecovery.beginRollback(active.batchRecovery)
  if not rollbackAllowed then return false, treeOrReason end
  diagnosticsModule.write(runtime.diagnostics, "W", #failedBatch == 1 and "part_candidate_quarantined" or "part_batch_isolation_started", {
    modelKey = active.modelKey,
    configKey = configKey,
    slotPath = #failedBatch == 1 and failedBatch[1].slotPath or nil,
    candidate = #failedBatch == 1 and failedBatch[1].selectedPart or nil,
    batchSize = #failedBatch,
    confidence = #failedBatch == 1 and "confirmed" or "suspect",
    reason = reason,
    recovery = partBatchRecovery.metrics(active.batchRecovery),
  }, true)
  if runtime.state.state == "waitingForReload" then operationState.transition(runtime.state, "scanning", false) end
  if runtime.state.state == "scanning" then operationState.transition(runtime.state, "mutating", false) end
  active.batchRollbackDecisions = util.deepCopy(active.currentBatch)
  local expectedParts = adapter.flattenChosenParts(treeOrReason)
  local okWait, waitError = enterWaiting(active, "part_batch_rollback", "batchRetry", {
    vehicleId = active.vehicleId,
    modelKey = active.modelKey or (active.selectedModel and active.selectedModel.key),
    parts = expectedParts,
  }, "Rolling back unsafe part batch", 0.46)
  if not okWait then return false, waitError.code or "part_batch_rollback_wait_failed" end
  bindMutationPlan(active, "part_batch_rollback")
  local guardOk, guardError = guardMutationWrite(active, "part_batch_rollback")
  if not guardOk then return false, guardError.code or "stale_callback_ignored" end
  local okApply, applyError = adapter.applyPartsTree(treeOrReason)
  if not okApply then
    partBatchRecovery.finishRollback(active.batchRecovery, false)
    return false, applyError.code or "part_batch_rollback_failed"
  end
  noteSuccessfulWrite(active, "part_batch_rollback")
  return true, "part_batch_rollback_started"
end

local function treeWithDecisions(baseTree, decisions)
  local tree = util.deepCopy(baseTree or {})
  for _, decision in ipairs(decisions or {}) do
    local node = mutationEngine.getTreeNode(tree, decision.keys)
    if node then node.chosenPartName = decision.selectedPart end
  end
  return tree
end

applyNextIsolationBatch = function(active)
  local isolation = active.candidateIsolation
  if not isolation then return false end
  local batch, reason = candidateIsolation.nextBatch(isolation)
  if not batch then
    diagnosticsModule.write(runtime.diagnostics, "I", "part_candidate_isolation_complete", {
      reason = reason, metrics = candidateIsolation.metrics(isolation),
    }, true)
    active.candidateIsolation = nil
    active.isolationBaseTree = nil
    active.currentBatch = nil
    active.batchRecovery.currentBatch = nil
    active.pass = active.pass + 1
    operationState.transition(runtime.state, "scanning", false)
    processMutationPass(active)
    return true
  end
  local confirmed = isolation.confirmed or {}
  local treeBefore = treeWithDecisions(active.isolationBaseTree, confirmed)
  local combined = util.deepCopy(confirmed)
  for _, decision in ipairs(batch) do combined[#combined + 1] = util.deepCopy(decision) end
  local tree = treeWithDecisions(active.isolationBaseTree, combined)
  local expected = {}
  for _, decision in ipairs(combined) do expected[decision.slotPath] = decision.selectedPart end
  active.currentBatch = util.deepCopy(batch)
  partBatchRecovery.beginBatch(active.batchRecovery, {
    modelKey = active.modelKey or (active.selectedModel and active.selectedModel.key),
    configKey = active.selectedConfig and active.selectedConfig.key
      or active.originalState and active.originalState.selectedConfiguration,
    pass = active.pass, treeBefore = treeBefore, changes = batch,
  })
  if runtime.state.state == "scanning" then operationState.transition(runtime.state, "mutating", false) end
  local okWait, waitError = enterWaiting(active, "part_isolation_test", "candidateIsolation", {
    vehicleId = active.vehicleId,
    modelKey = active.modelKey or (active.selectedModel and active.selectedModel.key),
    parts = expected,
  }, "Isolating a failing part candidate", 0.52)
  if not okWait then failActive(waitError, true, "parts"); return true end
  bindMutationPlan(active, "part_isolation_test")
  local guardOk, guardError = guardMutationWrite(active, "part_isolation_test")
  if not guardOk then failActive(guardError, true, "parts"); return true end
  local okApply, applyError = adapter.applyPartsTree(tree)
  if not okApply then failActive(applyError, true, "parts") end
  if okApply then noteSuccessfulWrite(active, "part_isolation_test") end
  return true
end

local function failActive(errorData, attemptRollback, phase, context)
  local active = runtime.active
  local failure = failureRecord(active, phase, errorData, context)
  runtime.lastFailure = failure
  if failure.phase == "spawn" and active and active.selectedConfig then
    vehicleRecovery.recordLoadFailure(runtime.recovery, {
      modelKey = active.selectedConfig.modelKey,
      configKey = active.selectedConfig.key,
    }, failure.code)
  end
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

local function currentDependencies(scan)
  local values = {
    baseConfiguration = {},
    parts = {},
    wheelTire = {},
    mods = {},
    official = {},
    user = {},
    unknown = {},
  }
  local seen = {parts = {}, wheelTire = {}, mods = {}, official = {}, user = {}, unknown = {}}
  for _, slot in ipairs(type(scan) == "table" and scan.slots or {}) do
    if type(slot.currentPart) ~= "string" or slot.currentPart == "" then
      -- Empty optional slots are state, not content dependencies.
    else
    local metadata = slot.candidateMetadata and slot.candidateMetadata[slot.currentPart] or {}
    local kind = metadata.sourceKind == "mod" and "mods"
      or metadata.sourceKind == "official" and "official"
      or metadata.sourceKind == "user" and "user" or "unknown"
    local id = tostring(metadata.modID or slot.currentPart)
    local record = {
      kind = metadata.sourceKind or "unknown",
      id = id,
      label = metadata.sourceLabel or "Unknown",
      partName = slot.currentPart,
      slotPath = slot.path,
      modID = metadata.modID,
    }
    if not seen.parts[slot.path] then
      seen.parts[slot.path] = true
      values.parts[#values.parts + 1] = util.deepCopy(record)
    end
    local normalizedSlot = util.normalizeText(tostring(slot.id or "") .. " " .. tostring(slot.description or ""))
    local wheelOrTire = false
    for token in normalizedSlot:gmatch("[%w]+") do
      if token == "wheel" or token == "wheels" or token == "tire" or token == "tires" then
        wheelOrTire = true
        break
      end
    end
    if wheelOrTire then
      if not seen.wheelTire[slot.path] then
        seen.wheelTire[slot.path] = true
        values.wheelTire[#values.wheelTire + 1] = util.deepCopy(record)
      end
    end
    local aggregateId = kind == "mods" and metadata.modID and tostring(metadata.modID) or id
    if aggregateId ~= "" and not seen[kind][aggregateId] then
      seen[kind][aggregateId] = true
      values[kind][#values[kind] + 1] = util.deepCopy(record)
    end
    end
  end
  for _, key in ipairs({"parts", "wheelTire", "mods", "official", "user", "unknown"}) do
    table.sort(values[key], function(a, b)
      if a.id ~= b.id then return a.id < b.id end
      return tostring(a.slotPath) < tostring(b.slotPath)
    end)
  end
  return values
end

local function capturePendingDNA(active, details)
  local okCapture, capture = adapter.captureCurrentState(active.kind, active.seed)
  if not okCapture then return false, capture end
  local okSnapshot, snapshot = adapter.getCurrentSlotSnapshot()
  if not okSnapshot then return false, snapshot end
  local scan, scanError = slotScanner.scan(snapshot.tree, snapshot.metadataByPath)
  if not scan then return false, adapter.errorValue(scanError, "Vehicle DNA final slot normalization failed") end
  local selected = active.selectedConfig
  local dependencies = currentDependencies(scan)
  dependencies.baseConfiguration = {
    modelKey = selected and selected.modelKey or capture.modelKey,
    configKey = selected and selected.key or nil,
    configPath = selected and selected.path or capture.selectedConfiguration,
    sourceKind = selected and selected.sourceKind or "unknown",
    sourceLabel = selected and selected.sourceLabel or "Unknown",
    modID = selected and selected.raw and (selected.raw.modID or selected.raw.modId) or nil,
  }
  local entry, createError = vehicleDNA.create({
    capture = capture,
    snapshot = snapshot,
    scan = scan,
    result = details,
    settings = runtime.settings,
    seed = active.seed,
    operation = active.captureOperation or active.kind,
    gameVersion = adapter.getGameVersion(),
    extensionVersion = EXTENSION_VERSION,
    base = selected and {
      modelKey = selected.modelKey,
      configKey = selected.key,
      configName = selected.name,
      configPath = selected.path,
      registryIdentity = true,
      sourceKind = selected.sourceKind,
      sourceLabel = selected.sourceLabel,
      sourceStrategy = selected.sourceStrategy,
      modID = selected.raw and (selected.raw.modID or selected.raw.modId),
      identityStrategy = active.configIdentity and active.configIdentity.strategy,
      stateSignature = active.configIdentity and active.configIdentity.signature,
    } or {
      modelKey = capture.modelKey,
      configPath = capture.selectedConfiguration,
    },
    startingState = active.parentFinalState or active.originalState,
    selectionContext = active.selectionContext,
    recentPolicy = active.selectionContext and active.selectionContext.recentPolicy or "not_applicable",
    dependencies = dependencies,
    safety = active.safetyResult,
    warnings = active.warnings,
    lineage = active.pendingLineage,
    lockProfile = active.lockProfileSnapshot,
    tuningCoverage = active.tuningLedger and (function()
      local records = {}
      for _, key in ipairs(active.tuningLedger.order or {}) do
        records[#records + 1] = util.deepCopy(active.tuningLedger.entries[key])
      end
      return records
    end)() or {},
    metrics = {
      reloadCount = active.reloadCount or 0,
      partPasses = active.partPassesApplied or 0,
      slotCount = scan.metrics.slotCount,
      candidateCount = scan.metrics.candidateCount,
      maxDepth = scan.metrics.maxDepth,
    },
  })
  if not entry then return false, adapter.errorValue("dna_capture_invalid", "Vehicle DNA schema validation failed", {reason = createError}) end
  if active.creativeOperation and (not entry.lineage or not entry.lineage.rootId) then
    entry.lineage = util.shallowMerge(entry.lineage or {}, {
      rootId = entry.id,
      generation = tonumber(entry.lineage and entry.lineage.generation) or 0,
      createdFrom = active.creativeOperation,
    })
    local valid, reason = vehicleDNASchema.validateEntry(entry)
    if not valid then return false, adapter.errorValue("dna_capture_invalid", "Creative Vehicle DNA lineage is invalid", {reason = reason}) end
  end
  runtime.dna.pending = entry
  diagnosticsModule.write(runtime.diagnostics, "I", "dna_capture_ready", {
    id = entry.id, modelKey = entry.final.modelKey, schemaVersion = entry.schemaVersion,
    generatorVersion = entry.generation.generatorVersion,
  }, true)
  return true, entry
end

completeReplayGeneration = function(active, safetyResult)
  active.phase = "dna_replay_verification"
  setProgress("Verifying replayed generation", 0.97)
  local okCapture, capture = adapter.captureCurrentState(active.kind, active.seed)
  if not okCapture then failActive(capture, true, "dna_replay_verification"); return end
  local okSnapshot, snapshot = adapter.getCurrentSlotSnapshot()
  if not okSnapshot then failActive(snapshot, true, "dna_replay_verification"); return end
  local scan, scanError = slotScanner.scan(snapshot.tree, snapshot.metadataByPath)
  if not scan then failActive(adapter.errorValue(scanError, "Replay final slot scan failed"), true, "dna_replay_verification"); return end
  local observed = {
    modelKey = capture.modelKey,
    configIdentity = capture.selectedConfiguration,
    slots = vehicleDNANormalizer.normalizeSlots(scan),
    tuning = vehicleDNANormalizer.normalizeTuning(snapshot.variables, capture.tuning or snapshot.currentTuning),
    paints = vehicleDNANormalizer.normalizePaints(capture.paints or snapshot.paints),
  }
  local expected = util.deepCopy(active.dnaEntry.final or {})
  local stateExact = util.deepEqual(expected, observed, 1e-8)
  local environmentChanged = active.dnaEntry.environment
    and active.dnaEntry.environment.beamNGVersion ~= adapter.getGameVersion()
  local exact = stateExact and not environmentChanged
  local observedFingerprint = vehicleDNAFingerprint.fingerprint(observed)
  local fingerprintMatches = observedFingerprint ~= nil and observedFingerprint == (active.dnaEntry.fingerprints and active.dnaEntry.fingerprints.final)
  local status = exact and "exact" or (#(active.dnaDeviations or {}) > 0 and "partial" or "close")
  finishOperation(true, "dna_replay_" .. status, "Vehicle DNA generation replay: " .. status, {
    replayStatus = status,
    dnaId = active.dnaEntry.id,
    baseSelectionFrozen = true,
    exact = exact,
    fingerprintMatches = fingerprintMatches,
    observedFingerprint = observedFingerprint,
    savedFingerprint = active.dnaEntry.fingerprints and active.dnaEntry.fingerprints.final,
    deviations = util.deepCopy(active.dnaDeviations or {}),
    safety = util.deepCopy(safetyResult),
    stateExact = stateExact,
    environmentChanged = environmentChanged,
  })
end

local function completeChaos(active)
  operationState.transition(runtime.state, "validating", false)
  active.phase = "validation"
  setLifecyclePhase(active, "final_validation", false, "chaos_final_validation")
  local safe, safetyOrError = validateFinalVehicle(active)
  if not safe then failActive(safetyOrError, true, "validation"); return end
  if active.replayGeneration then completeReplayGeneration(active, safetyOrError); return end
  local completionMessage
  if safetyOrError.status == "not_applicable" then
    active.warnings[#active.warnings + 1] = "Prop safety validation is not applicable; this result does not claim a controllable vehicle."
    completionMessage = "Chaos complete; prop control is not validated"
  end
  local removed = 0
  for _, change in ipairs(active.changes) do if change.wasRemoved then removed = removed + 1 end end
  local okReadBack, finalState = adapter.getVerificationState()
  if okReadBack and active.slotLedger then
    slotCoverageLedger.markFinalParts(active.slotLedger, finalState.parts)
  end
  local slotSummary = active.slotLedger and slotCoverageLedger.summary(active.slotLedger) or nil
  local tuningSummary = active.tuningLedger and tuningCoverageLedger.summary(active.tuningLedger) or nil
  local paintSummary = active.paintLedger and paintCoverageLedger.summary(active.paintLedger) or nil
  local verifiedTraits = productionModules.lineupManager.verifiedTraits(active.selectedModel, active.selectedConfig)
  local details = {
    seed = active.seed,
    model = active.selectedModel and active.selectedModel.key or active.modelKey,
    configuration = active.selectedConfig and active.selectedConfig.key,
    verifiedTraits = verifiedTraits,
    metadataUncertain = productionModules.lineupManager.metadataUncertain(verifiedTraits)
      or safetyOrError.status == "uncertain",
    potentiallyUndrivable = safetyOrError.status == "uncertain"
      or safetyOrError.status == "not_applicable"
      or safetyOrError.profile == "prop" or safetyOrError.profile == "trailer"
      or safetyOrError.profile == "special" or safetyOrError.profile == "unknown",
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
    stageReasons = util.deepCopy(active.stageReasons or {}),
    lifecycle = util.deepCopy(active.lastTargetMetrics),
    batchRecovery = active.batchRecovery and partBatchRecovery.metrics(active.batchRecovery) or nil,
    safety = util.deepCopy(safetyOrError),
    warnings = util.deepCopy(active.warnings),
    coverage = {
      slots = slotSummary,
      tuning = tuningSummary,
      paint = paintSummary,
      limits = util.deepCopy(active.coverageLimits),
      convergence = active.convergence and treeConvergence.metrics(active.convergence) or nil,
    },
  }
  local totalChanges = #active.changes + #active.tuningChanges + active.paintChanges
  local partial = not okReadBack
    or not active.slotLedger or not slotCoverageLedger.isComplete(active.slotLedger)
    or not active.tuningLedger or not tuningCoverageLedger.isComplete(active.tuningLedger)
    or not active.paintLedger or not paintCoverageLedger.isComplete(active.paintLedger)
    or (tuningSummary and tuningSummary.tuningRejected > 0)
    or (paintSummary and paintSummary.paintRejected > 0)
    or details.stageReasons.tuning == "tuning_capability_unavailable"
    or details.stageReasons.paint == "paint_capability_unavailable"
  local dnaReady, dnaOrError = capturePendingDNA(active, details)
  details.dnaReady = dnaReady
  if dnaReady then
    details.dnaId = dnaOrError.id
  else
    partial = true
    details.warnings[#details.warnings + 1] = "Vehicle DNA capture was unavailable: " .. tostring(dnaOrError.message or dnaOrError.code)
    diagnosticsModule.write(runtime.diagnostics, "W", "dna_capture_failed", dnaOrError, true)
  end
  details.partial = partial
  details.status = partial and "Partial" or "Completed"
  if partial and not (active.settings and active.settings.allowPartialResult == true) then
    runtime.dna.pending = nil
    failActive(adapter.errorValue("partial_result_not_allowed", "Coverage was partial and Keep Partial Result is off", {
      coverage = util.deepCopy(details.coverage), warnings = util.deepCopy(details.warnings),
    }), true, "partial_result")
    return
  end
  local completionCode = active.creativeOperation == "reroll_unlocked" and "reroll_unlocked_completed"
    or active.creativeOperation == "mutation" and "dna_mutation_completed" or "completed"
  if active.kind == "fullRandom" then
    completionCode = partial and "full_random_partial" or "full_random_completed"
  elseif active.kind == "scramble" and totalChanges == 0 and not active.creativeOperation then
    completionCode = partial and "scramble_partial" or "scramble_no_mutable_content"
  end
  local creativeMessage = active.creativeOperation == "reroll_unlocked" and "Reroll Unlocked complete"
    or active.creativeOperation == "mutation" and "Vehicle DNA mutation complete" or nil
  finishOperation(true, completionCode, creativeMessage or completionMessage or string.format(
    "%s: %d parts, %d tuning values, %d paints",
    partial and "Chaos partial result" or "Chaos complete",
    #active.changes, #active.tuningChanges, active.paintChanges
  ), details, partial and "partial" or "completed")
end

startPaint = function(active)
  if not operationState.isCurrent(runtime.state, active.token) then return end
  if active.recoveryOnly then guardMutationWrite(active, "paint"); return end
  if not runtime.capabilities.scramblePaint then
    active.warnings[#active.warnings + 1] = "Paint randomization was skipped because paint read/write capability is unavailable."
    active.stageReasons = active.stageReasons or {}
    active.stageReasons.paint = "paint_capability_unavailable"
    active.paintLedger = paintCoverageLedger.create({}, nil, false, {
      operationId = active.operationId, targetGeneration = active.targetGeneration,
      modelKey = active.modelKey or (active.selectedModel and active.selectedModel.key),
      configIdentity = active.configIdentity,
    })
    completeChaos(active)
    return
  end
  if runtime.state.state ~= "painting" then
    local ok, transitionError = operationState.transition(runtime.state, "painting", false)
    if not ok then failActive(adapter.errorValue("state_error", transitionError), true, "paint"); return end
  end
  active.phase = "paint"
  setLifecyclePhase(active, "applying_paint", false, "paint_planning")
  setProgress("Applying paints", 0.90)
  local okPaints, paints = adapter.getPaints()
  if not okPaints then failActive(paints, true, "paint"); return end
  active.paintLedger = paintCoverageLedger.create(paints, active.lockProfileSnapshot and function(layer, field)
    return vehicleDNALocks.isPaintLocked(active.lockProfileSnapshot, layer, field)
  end or nil, true, {
    operationId = active.operationId, targetGeneration = active.targetGeneration,
    modelKey = active.modelKey or (active.selectedModel and active.selectedModel.key),
    configIdentity = active.configIdentity,
  })
  local result, changed, selectedLayers = paintRandomizer.randomize(paints, active.policy, active.rng:fork("paint"), {
    independentSubstreams = active.creativeOperation ~= nil,
    isFieldLocked = active.lockProfileSnapshot and function(layer, field)
      return vehicleDNALocks.isPaintLocked(active.lockProfileSnapshot, layer, field)
    end or nil,
  })
  paintCoverageLedger.requested(active.paintLedger, paints, result, selectedLayers)
  active.paintChanges = changed
  active.stageReasons = active.stageReasons or {}
  active.stageReasons.paint = changed > 0 and "paint_processed" or "paint_no_mutable_fields"
  diagnosticsModule.write(runtime.diagnostics, "D", "paint_randomized", {changes = changed})
  if changed > 0 then
    local okHistory, historyError = commitHistory(active)
    if not okHistory then failActive(historyError, false, "paint"); return end
    setLifecyclePhase(active, "applying_paint", false, "paint_write")
    bindMutationPlan(active, "paint")
    local guardOk, guardError = guardMutationWrite(active, "paint")
    if not guardOk then failActive(guardError, true, "paint"); return end
    local okApply, applyResult = adapter.applyPaints(result)
    if not okApply then failActive(applyResult, true, "paint"); return end
    noteSuccessfulWrite(active, "paint")
    if applyResult.confirmationRequired then
      local transitioned, transitionError = operationState.transition(runtime.state, "waitingForReload", PAINT_CONFIRM_TIMEOUT)
      if not transitioned then failActive(adapter.errorValue("state_error", transitionError), true, "paint"); return end
      active.paintConfirmation = paintVerification.createDeferred(
        applyResult.expected, adapter.clock(), PAINT_CONFIRM_TIMEOUT, 0.1, 12
      )
      setLifecyclePhase(active, "verifying_paint", PAINT_CONFIRM_TIMEOUT, "paint_readback")
      active.paintConfirmation.context = operationState.captureContext(
        runtime.state, active.operationCurrentTarget
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
    local okReadBack, readBack = adapter.getPaints()
    if okReadBack then paintCoverageLedger.readBack(active.paintLedger, readBack) end
  else
    paintCoverageLedger.readBack(active.paintLedger, paints)
  end
  completeChaos(active)
end

local function applyTuningPass(active, snapshot, pass, onlyNew)
  setLifecyclePhase(active, "applying_tuning", false, "tuning_pass_" .. tostring(pass))
  local values, changes, ledger, newly = tuningPipeline.plan(
    snapshot.variables, snapshot.values, active.policy, active.rng:fork("tuning:pass:" .. tostring(pass)), {
      onlyNew = onlyNew == true,
      extremeTuning = runtime.settings.extremeTuning == true,
      isLocked = active.lockProfileSnapshot and function(name, category, subCategory)
        return vehicleDNALocks.isTuningLocked(active.lockProfileSnapshot, name, category, subCategory)
      end or nil,
    }, active.tuningLedger, pass
  )
  active.tuningLedger = ledger
  active.tuningPass = pass
  active.pendingTuningChanges = changes
  for _, change in ipairs(changes) do active.tuningChanges[#active.tuningChanges + 1] = change end
  active.stageReasons = active.stageReasons or {}
  active.stageReasons.tuning = #changes > 0 and "tuning_processed" or "tuning_no_mutable_values"
  diagnosticsModule.write(runtime.diagnostics, "D", "tuning_pass_planned", {
    pass = pass, changes = #changes, newlyDiscovered = newly,
    coverage = tuningCoverageLedger.summary(active.tuningLedger),
  })
  if #changes == 0 then return false end
  local expected = {}
  for _, change in ipairs(changes) do expected[change.name] = change.selectedValue end
  local okWait, waitError = enterWaiting(active, "tuning", "paint", {
    vehicleId = active.vehicleId,
    modelKey = active.modelKey or (active.selectedModel and active.selectedModel.key),
    tuning = expected,
  }, pass == 1 and "Applying tuning and reloading" or "Applying newly discovered tuning", 0.85)
  if not okWait then failActive(waitError, true, "tuning"); return true end
  local okHistory, historyError = commitHistory(active)
  if not okHistory then failActive(historyError, false, "tuning"); return true end
  bindMutationPlan(active, "tuning")
  local guardOk, guardError = guardMutationWrite(active, "tuning")
  if not guardOk then failActive(guardError, true, "tuning"); return true end
  local okApply, applyError = adapter.applyTuning(values)
  if not okApply then failActive(applyError, true, "tuning") end
  if okApply then noteSuccessfulWrite(active, "tuning") end
  return true
end

local function processTuningReadback(active)
  setLifecyclePhase(active, "verifying_tuning", false, "tuning_readback")
  local okSnapshot, snapshot = adapter.getTuningSnapshot()
  if not okSnapshot then failActive(snapshot, true, "tuning_readback"); return end
  tuningCoverageLedger.readBack(active.tuningLedger, snapshot.values, active.tuningPass or 1)
  for _, change in ipairs(active.pendingTuningChanges or {}) do
    local entry = active.tuningLedger.entries[change.identity]
    if entry then
      change.requestedValue = entry.requested
      change.readBackValue = entry.readBack
      change.readBackStatus = entry.status
      change.clamped = entry.clamped == true
    end
  end
  if (active.tuningPass or 1) < 2 then
    if applyTuningPass(active, snapshot, 2, true) then return end
    tuningCoverageLedger.readBack(active.tuningLedger, snapshot.values, 2)
  end
  operationState.transition(runtime.state, "painting", false)
  startPaint(active)
end

startTuning = function(active)
  if not operationState.isCurrent(runtime.state, active.token) then return end
  if active.recoveryOnly then guardMutationWrite(active, "tuning"); return end
  if not runtime.capabilities.scrambleTuning then
    active.warnings[#active.warnings + 1] = "Tuning randomization was skipped because tuning read/write capability is unavailable."
    active.stageReasons = active.stageReasons or {}
    active.stageReasons.tuning = "tuning_capability_unavailable"
    active.tuningLedger.finalReadBack = true
    operationState.transition(runtime.state, "painting", false)
    startPaint(active)
    return
  end
  if runtime.state.state ~= "tuning" then
    local ok, transitionError = operationState.transition(runtime.state, "tuning", false)
    if not ok then failActive(adapter.errorValue("state_error", transitionError), true, "tuning"); return end
  end
  active.phase = "tuning"
  setLifecyclePhase(active, "planning_tuning", false, "tuning_planning")
  local tuningBound, tuningBindReason = tuningCoverageLedger.bindContext(active.tuningLedger, {
    operationId = active.operationId, targetGeneration = active.targetGeneration,
    modelKey = active.modelKey or (active.selectedModel and active.selectedModel.key),
    configIdentity = active.configIdentity or (active.selectedConfig and (active.selectedConfig.path or active.selectedConfig.key)),
  })
  if not tuningBound then failActive(adapter.errorValue(tuningBindReason, "Tuning ledger target changed"), true, "tuning"); return end
  setProgress("Applying tuning", 0.80)
  local okSnapshot, snapshot = adapter.getTuningSnapshot()
  if not okSnapshot then failActive(snapshot, true, "tuning"); return end
  if not applyTuningPass(active, snapshot, 1, false) then
    tuningCoverageLedger.readBack(active.tuningLedger, snapshot.values, 1)
    operationState.transition(runtime.state, "painting", false)
    startPaint(active)
  end
end

local function safetyFailureFingerprint(failures)
  local values = {}
  for _, failure in ipairs(failures or {}) do
    values[#values + 1] = table.concat({
      tostring(failure.code or failure.reason or "invalid"),
      tostring(failure.slotPath or failure.path or failure.role or ""),
      tostring(failure.partName or failure.candidate or ""),
    }, ":")
  end
  table.sort(values)
  return table.concat(values, "|")
end

processMutationPass = function(active)
  if not operationState.isCurrent(runtime.state, active.token) then return end
  if active.recoveryOnly then guardMutationWrite(active, "parts"); return end
  if runtime.state.state ~= "scanning" then
    local ok, transitionError = operationState.transition(runtime.state, "scanning", false)
    if not ok then failActive(adapter.errorValue("state_error", transitionError), true, "parts"); return end
  end
  active.phase = "parts"
  setLifecyclePhase(active, "planning_parts", false, "parts_scan_and_plan")
  active.coveragePass = (active.coveragePass or 0) + 1
  setProgress(string.format("Scanning complete slot tree (pass %d)", active.coveragePass), 0.30 + math.min(active.coveragePass, 8) * 0.045)
  local scanStarted = adapter.clock()
  local okSnapshot, snapshot = adapter.getCurrentSlotSnapshot()
  if not okSnapshot then failActive(snapshot, active.destructiveStarted, "parts"); return end
  local scan, scanError = slotScanner.scan(snapshot.tree, snapshot.metadataByPath)
  active.slotScanDuration = (active.slotScanDuration or 0) + math.max(0, adapter.clock() - scanStarted)
  if not scan then failActive(adapter.errorValue(scanError, "Could not scan the current parts tree"), active.destructiveStarted, "parts"); return end
  if active.lastTreeSignature ~= scan.signature then
    active.lastTreeSignature = scan.signature
    noteProgress(active, "tree", "parts_tree_changed")
  end
  active.lastScanMetrics = util.deepCopy(scan.metrics)
  if active.coveragePass == 1 then
    active.coverageLimits = coverageLimits.derive(scan.metrics)
    active.convergence.limits = active.coverageLimits
  end
  local ledgerContext = {
    operationId = active.operationId,
    targetGeneration = active.targetGeneration,
    modelKey = active.modelKey or (active.selectedModel and active.selectedModel.key),
    configIdentity = active.configIdentity or (active.selectedConfig and (active.selectedConfig.path or active.selectedConfig.key))
      or (active.originalState and active.originalState.selectedConfiguration),
  }
  local slotBound, slotBindReason = slotCoverageLedger.bindContext(active.slotLedger, ledgerContext)
  if not slotBound then failActive(adapter.errorValue(slotBindReason, "Slot ledger target changed"), true, "parts"); return end
  local discoveredBefore = #(active.slotLedger.order or {})
  slotCoverageLedger.observeScan(active.slotLedger, ledgerContext, scan, active.coveragePass)
  active.slotLedger.reloadsUsed = active.reloadCount or 0
  local graph = validator.buildGraph(scan, safetyContext(active, snapshot))
  if not active.safetyBaseline then active.safetyBaseline = util.deepCopy(graph) end
  local safetyResult = validator.validateGraph(graph, active.safetyBaseline, active.policy.protectCriticalParts)
  active.safetyResult = safetyResult
  local validProtection, protectionFailures = safetyResult.valid, safetyResult.failures
  if not validProtection then
    local persistent, persistenceReason = vehicleStabilizer.observeTreeIssue(
      active.treeStabilizer, safetyFailureFingerprint(protectionFailures)
    )
    if not persistent then
      active.treeRescanAt = adapter.clock() + 0.05
      active.treeRescanContext = operationState.captureContext(runtime.state, active.operationCurrentTarget)
      diagnosticsModule.write(runtime.diagnostics, "W", "tree_validation_deferred", {
        reason = persistenceReason,
        failures = protectionFailures,
        metrics = vehicleStabilizer.metrics(active.treeStabilizer),
      })
      setProgress("Waiting for a coherent parts tree", 0.44)
      return
    end
    if active.currentBatch then
      local recovering, recoveryReason = attemptPartBatchRollback(active, "critical_state_invalid")
      if recovering then return end
      diagnosticsModule.write(runtime.diagnostics, "E", "part_batch_recovery_exhausted", {
        reason = recoveryReason, recovery = partBatchRecovery.metrics(active.batchRecovery),
      }, true)
    end
    failActive(adapter.errorValue("critical_state_invalid", "Critical or required parts are missing after reload", {
      failures = protectionFailures,
    }), true, "validation")
    return
  end
  vehicleStabilizer.observeTreeIssue(active.treeStabilizer, nil)
  active.treeRescanAt = nil
  if active.currentBatch then
    active.partPassesApplied = (active.partPassesApplied or 0) + 1
    for _, decision in ipairs(active.currentBatch) do
      if decision.selectedPart and decision.selectedPart ~= "" then
        local recorded, successDetails = contentIndex.recordSuccess(runtime.index, "part", {
          modelKey = active.modelKey or (active.selectedModel and active.selectedModel.key),
          slotPath = decision.slotPath,
          candidate = decision.selectedPart,
        }, os.time())
        if recorded then diagnosticsModule.write(runtime.diagnostics, "D", "part_candidate_success", successDetails) end
      end
    end
    active.currentBatch = nil
    active.batchRecovery.currentBatch = nil
  end
  local eligible = slotScanner.eligiblePaths(active.previousScan, scan, active.deferredPaths, active.mutatedPaths)
  active.previousScan = scan
  active.deferredPaths = {}
  operationState.transition(runtime.state, "mutating", false)
  local modelKey = active.modelKey or (active.selectedModel and active.selectedModel.key)
  local planningStarted = adapter.clock()
  local partsGenerator = active.creativeOperation and active.rng:fork("parts") or active.rng:fork("parts:" .. active.pass)
  local tree, decisions = mutationEngine.plan(scan, eligible, active.policy, partsGenerator, {
    passNumber = active.pass,
    isBlacklisted = function(slot, candidate)
      local configKey = active.selectedConfig and active.selectedConfig.key
        or active.originalState and active.originalState.selectedConfiguration
      if partBatchRecovery.isQuarantined(active.batchRecovery, modelKey, configKey, slot.path, candidate) then
        return true, "part_candidate_quarantined"
      end
      local allowed, reason = contentIndex.isCandidateEligible(runtime.index, {
        modelKey = modelKey,
        slotPath = slot.path,
        candidate = candidate,
      })
      return not allowed, reason
    end,
    independentSubstreams = active.creativeOperation ~= nil,
    categoryForSlot = vehicleDNALocks.classifySlot,
    isLocked = active.lockProfileSnapshot and function(slot)
      return vehicleDNALocks.isSlotLocked(active.lockProfileSnapshot, slot)
    end or nil,
  })
  active.mutationPlanningDuration = (active.mutationPlanningDuration or 0) + math.max(0, adapter.clock() - planningStarted)
  local actual = {}
  local ancestors = {}
  local deferred = 0
  local rejected = 0
  local protected = 0
  for _, decision in ipairs(decisions) do
    local observedSlot = scan.byPath and scan.byPath[decision.slotPath]
    if observedSlot then
      slotCoverageLedger.classifyDecision(active.slotLedger, ledgerContext, observedSlot, decision, active.coveragePass)
    end
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
    if decision.locked and active.replayGeneration and active.replayLockPolicy == "current" then
      addDNADeviation(active, {
        phase = "generation",
        reason = "replay_current_lock_preserved",
        savedPath = decision.slotPath,
        expected = "generated_part_decision",
        actual = decision.previousPart,
      })
    end
  end
  diagnosticsModule.write(runtime.diagnostics, "D", "mutation_pass", {
    pass = active.coveragePass,
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
    coverage = slotCoverageLedger.summary(active.slotLedger),
  })
  local slotSummary = slotCoverageLedger.summary(active.slotLedger)
  local converged = treeConvergence.observe(active.convergence, {
    signature = scan.signature,
    discovered = slotSummary.slotsDiscovered,
    pending = slotSummary.slotsUnresolved,
    newDescendants = math.max(0, slotSummary.slotsDiscovered - discoveredBefore),
    pendingRetries = active.batchRecovery.currentBatch and 1 or 0,
    changesApplied = #actual,
  })
  local convergenceMetrics = treeConvergence.metrics(active.convergence)
  local limitReason = coverageLimits.exceeded(active.coverageLimits, {
    passesUsed = active.coveragePass,
    reloadsUsed = active.reloadCount or 0,
    noProgressPasses = convergenceMetrics.noProgressPasses,
    slotsDiscovered = slotSummary.slotsDiscovered,
    candidateAttempts = slotSummary.slotsAttempted,
    startedAt = active.startedAt,
  }, adapter.clock())
  if limitReason then
    active.slotLedger.limitReason = limitReason
    active.convergence.limitReason = limitReason
    active.warnings[#active.warnings + 1] = "Slot coverage stopped at safety limit: " .. limitReason
    active.stageReasons.parts = "coverage_limit_" .. limitReason
    operationState.transition(runtime.state, "tuning", false)
    startTuning(active)
    return
  end
  if #actual == 0 then
    if converged then
      active.slotLedger.converged = true
      active.stageReasons.parts = "tree_converged"
      operationState.transition(runtime.state, "tuning", false)
      startTuning(active)
      return
    end
    operationState.transition(runtime.state, "scanning", false)
    active.treeRescanAt = adapter.clock() + 0.05
    active.treeRescanContext = operationState.captureContext(runtime.state, active.operationCurrentTarget)
    setProgress("Confirming slot-tree convergence", 0.74)
    return
  end

  local expectedParts = {}
  for _, decision in ipairs(actual) do expectedParts[decision.slotPath] = decision.selectedPart end
  active.currentBatch = util.deepCopy(actual)
  partBatchRecovery.beginBatch(active.batchRecovery, {
    modelKey = modelKey,
    configKey = active.selectedConfig and active.selectedConfig.key
      or active.originalState and active.originalState.selectedConfiguration,
    pass = active.pass,
    treeBefore = snapshot.tree,
    changes = actual,
  })
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
  bindMutationPlan(active, "parts")
  local guardOk, guardError = guardMutationWrite(active, "parts")
  if not guardOk then failActive(guardError, true, "parts"); return end
  local okApply, applyError = adapter.applyPartsTree(tree)
  if not okApply then failActive(applyError, true, "parts"); return end
  noteSuccessfulWrite(active, "parts")
  setProgress(string.format("Reloading after part pass %d", active.pass), 0.51 + math.min(active.pass, 5) * 0.06)
end

local function startSpawnOperation(kind, context)
  local okBegin, activeOrError = beginOperation(kind, context)
  if not okBegin then
    setResult(false, activeOrError.code, activeOrError.message)
    publishState()
    return false
  end
  local active = applyCreativeContext(activeOrError, context)
  local okIndex, indexError = ensureIndex()
  if not okIndex then failActive(indexError, false, "index"); return false end
  if runtime.state.state ~= "selecting" then
    local ok, transitionError = operationState.transition(runtime.state, "selecting", false)
    if not ok then failActive(adapter.errorValue("state_error", transitionError), false, "selection"); return false end
  end
  active.phase = "selection"
  setLifecyclePhase(active, "selecting", false, "vehicle_selection")
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
  setLifecyclePhase(active, "issuing_spawn", false, "vehicle_spawn_request")
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
  local active = applyCreativeContext(activeOrError, context)
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
  local candidate = util.deepCopy(snapshot)
  if candidate.lockProfile == nil then candidate.lockProfile = runtime.settings.lockProfile end
  runtime.settings = settingsModule.validate(candidate)
  runtime.settings.dnaLibraryLimit = math.max(runtime.settings.dnaLibraryLimit, #(runtime.dna.library.entries or {}))
  runtime.dna.library.limit = runtime.settings.dnaLibraryLimit
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

local function rerollUnlocked(options)
  initialize()
  if runtime.state.busy or (runtime.stress and runtime.stress.active) then return false end
  options = type(options) == "table" and options or {}
  local profile = vehicleDNALocks.normalize(runtime.settings.lockProfile)
  local lineage, seed
  local parent = options.parentDNAId and vehicleDNAStorage.find(runtime.dna.library, options.parentDNAId) or nil
  if parent then
    local index = math.max(1, math.floor(tonumber(options.mutationIndex) or vehicleDNAMutations.nextIndex(runtime.dna.library, parent.id)))
    seed = rngModule.new(table.concat({parent.generation.seed, parent.id, "reroll_unlocked", index}, ":")).seed
    lineage = {
      parentId = parent.id,
      rootId = parent.lineage and parent.lineage.rootId or parent.id,
      generation = math.min(vehicleDNAMutations.MAX_LINEAGE_DEPTH, math.floor(tonumber(parent.lineage and parent.lineage.generation) or 0) + 1),
      mutationIndex = index,
      createdFrom = "reroll_unlocked",
      parentSeed = parent.generation.seed,
    }
  else
    seed = options.seed and rngModule.normalizeSeed(options.seed) or nil
    lineage = {generation = 0, createdFrom = "reroll_unlocked"}
  end
  local context = {
    creativeOperation = "reroll_unlocked",
    captureOperation = profile.configuration and "scramble" or "fullRandom",
    lockProfile = profile,
    lineage = lineage,
    seed = seed,
  }
  if parent then
    local preflightOk, report = preflightVehicleDNA(parent.id, "compatible")
    if not preflightOk or not report or report.registryStatus == "registry_incompatible" then return false end
    return startVehicleDNABaseOperation(parent, report, "mutation", true, {
      seed = seed,
      settings = runtime.settings,
      lockProfile = profile,
      lineage = lineage,
      creativeOperation = "reroll_unlocked",
      strength = "wild",
      allowModelChange = not vehicleDNALocks.requiresModel(profile),
    })
  end
  if profile.configuration then return startScramble(context) end
  return startSpawnOperation("fullRandom", context)
end

local function updateSettings(patch)
  initialize()
  if runtime.state.busy or (runtime.stress and runtime.stress.active) then return false end
  runtime.settings = settingsModule.update(runtime.settings, patch)
  runtime.settings.dnaLibraryLimit = math.max(runtime.settings.dnaLibraryLimit, #(runtime.dna.library.entries or {}))
  runtime.dna.library.limit = runtime.settings.dnaLibraryLimit
  historyModule.setLimit(runtime.history, runtime.settings.historyLimit)
  diagnosticsModule.setEnabled(runtime.diagnostics, runtime.settings.diagnosticLogging)
  local ok, saveError = adapter.saveSettings(runtime.settings)
  if not ok then setResult(false, saveError.code, saveError.message, {settingsAppliedForSession = true}) end
  publishState()
  return ok
end

local function persistLockProfile(profile, code, message)
  if runtime.state.busy then return false end
  profile = vehicleDNALocks.normalize(profile)
  if vehicleDNALocks.requiresModel(profile) then
    local okModel, modelKey = adapter.getCurrentModelKey()
    if not okModel then
      setResult(false, "lock_model_unresolved", "Model-bound locks require an active vehicle")
      publishState()
      return false
    end
    profile.boundModelKey = modelKey
    if profile.configuration then
      local okConfig, config = adapter.getCurrentConfig()
      if not okConfig then
        setResult(false, "lock_configuration_unresolved", "Configuration Lock requires a readable active configuration")
        publishState()
        return false
      end
      profile.boundConfigKey = configVerification.normalizePath(config.partConfigFilename)
    else
      profile.boundConfigKey = nil
    end
  else
    profile.boundModelKey = nil
    profile.boundConfigKey = nil
  end
  runtime.settings.lockProfile = vehicleDNALocks.normalize(profile)
  local ok, saveError = adapter.saveSettings(runtime.settings)
  if ok then setResult(true, code or "lock_profile_updated", message or "Lock profile updated", {
    summary = vehicleDNALocks.summary(runtime.settings.lockProfile),
  }) else setResult(false, saveError.code, saveError.message, {settingsAppliedForSession = true}) end
  publishState()
  return ok
end

local function updateLockProfile(patch)
  initialize()
  return persistLockProfile(vehicleDNALocks.applyPatch(runtime.settings.lockProfile, patch))
end

local function lockVehicle(locked)
  return updateLockProfile({vehicle = locked ~= false})
end

local function lockConfiguration(locked)
  return updateLockProfile({configuration = locked ~= false})
end

local function lockCategory(category, locked)
  initialize()
  local allowed = false
  for _, value in ipairs(vehicleDNALocks.CATEGORIES) do if value == category then allowed = true; break end end
  if not allowed then setResult(false, "lock_category_invalid", "Unknown lock category"); publishState(); return false end
  local profile = vehicleDNALocks.normalize(runtime.settings.lockProfile)
  profile.categories[category] = locked ~= false and true or nil
  return persistLockProfile(profile, "lock_category_updated", "Category lock updated")
end

local function currentLockScan()
  local okSnapshot, snapshot = adapter.getCurrentSlotSnapshot()
  if not okSnapshot then return nil, snapshot end
  local scan, reason = slotScanner.scan(snapshot.tree, snapshot.metadataByPath)
  if not scan then return nil, adapter.errorValue(reason, "Current slot tree is unavailable for locks") end
  return scan
end

local function lockCurrentParts()
  initialize()
  if runtime.state.busy then return false end
  local scan, scanError = currentLockScan()
  if not scan then setResult(false, scanError.code, scanError.message); publishState(); return false end
  local profile = vehicleDNALocks.normalize(runtime.settings.lockProfile)
  local count = 0
  for _, slot in ipairs(scan.slots or {}) do
    if count >= vehicleDNALocks.MAX_SLOT_LOCKS then break end
    if type(slot.currentPart) == "string" and slot.currentPart ~= "" then
      profile.parts[slot.path] = {
        path = slot.path, slotId = slot.id, parentPath = slot.parentPath,
        parentPart = slot.parentPart, partName = slot.currentPart,
      }
      count = count + 1
    end
  end
  return persistLockProfile(profile, "current_parts_locked", string.format("Locked %d current parts", count))
end

local function lockSlot(path, locked)
  initialize()
  if runtime.state.busy then return false end
  local profile = vehicleDNALocks.normalize(runtime.settings.lockProfile)
  if locked == false then profile.slots[path] = nil
  else
    local scan, scanError = currentLockScan()
    if not scan then setResult(false, scanError.code, scanError.message); publishState(); return false end
    local slot = scan.byPath[path]
    if not slot then setResult(false, "lock_slot_unresolved", "The slot path is not present in the current tree"); publishState(); return false end
    profile.slots[path] = {
      path = path, slotId = slot.id, parentPath = slot.parentPath,
      parentPart = slot.parentPart, partName = slot.currentPart ~= "" and slot.currentPart or nil,
    }
  end
  return persistLockProfile(profile, "lock_slot_updated", "Slot lock updated")
end

local function unlockSlot(path) return lockSlot(path, false) end

local function lockPart(path, locked)
  initialize()
  if runtime.state.busy then return false end
  local profile = vehicleDNALocks.normalize(runtime.settings.lockProfile)
  if locked == false then profile.parts[path] = nil
  else
    local scan, scanError = currentLockScan()
    if not scan then setResult(false, scanError.code, scanError.message); publishState(); return false end
    local slot = scan.byPath[path]
    if not slot or type(slot.currentPart) ~= "string" or slot.currentPart == "" then
      setResult(false, "lock_part_unresolved", "No current part can be locked at this slot"); publishState(); return false
    end
    profile.parts[path] = {
      path = path, slotId = slot.id, parentPath = slot.parentPath,
      parentPart = slot.parentPart, partName = slot.currentPart,
    }
  end
  return persistLockProfile(profile, "lock_part_updated", "Part lock updated")
end

local function lockTuning(name, locked, normalizedValue)
  initialize()
  local profile = vehicleDNALocks.normalize(runtime.settings.lockProfile)
  if name == "*" then profile.tuning.all = locked ~= false
  elseif type(name) == "string" and name ~= "" and #name <= 256 then
    profile.tuning.variables[name] = locked ~= false and true or nil
    local normalized = tonumber(normalizedValue)
    if locked ~= false and util.isFinite(normalized) then profile.tuning.normalized[name] = util.clamp(normalized, 0, 1)
    else profile.tuning.normalized[name] = nil end
  else setResult(false, "lock_tuning_invalid", "Tuning lock name is invalid"); publishState(); return false end
  return persistLockProfile(profile, "lock_tuning_updated", "Tuning lock updated")
end

local function lockPaint(layer, field, locked)
  initialize()
  local profile = vehicleDNALocks.normalize(runtime.settings.lockProfile)
  if layer == "*" then profile.paints.all = locked ~= false
  else
    layer = math.floor(tonumber(layer) or -1)
    if layer < 1 or layer > vehicleDNALocks.MAX_PAINT_LAYERS then
      setResult(false, "lock_paint_invalid", "Paint layer is invalid"); publishState(); return false
    end
    if field == "*" then profile.paints.layers[layer] = locked ~= false and true or nil
    elseif type(field) == "string" then
      local allowedFields = {
        baseColor = true, metallic = true, roughness = true,
        clearcoat = true, clearcoatRoughness = true,
      }
      if not allowedFields[field] then
        setResult(false, "lock_paint_invalid", "Paint field is invalid"); publishState(); return false
      end
      profile.paints.fields[layer] = profile.paints.fields[layer] or {}
      profile.paints.fields[layer][field] = locked ~= false and true or nil
    else setResult(false, "lock_paint_invalid", "Paint field is invalid"); publishState(); return false end
  end
  return persistLockProfile(profile, "lock_paint_updated", "Paint lock updated")
end

local function applyLockPreset(name)
  initialize()
  local profile, reason = vehicleDNALocks.applyPreset(runtime.settings.lockProfile, name)
  if not profile then setResult(false, reason, "Lock preset is invalid"); publishState(); return false end
  return persistLockProfile(profile, "lock_preset_applied", "Lock preset applied: " .. tostring(name))
end

local function getVehicleDNALocks(id)
  initialize()
  local profile = runtime.settings.lockProfile
  if id ~= nil and id ~= "" then
    local entry = vehicleDNAStorage.find(runtime.dna.library, id)
    if not entry then setResult(false, "dna_not_found", "Vehicle DNA entry was not found"); publishState(); return false end
    profile = entry.lockProfile or vehicleDNALocks.empty()
  end
  local result = {id = id, profile = vehicleDNALocks.normalize(profile), summary = vehicleDNALocks.summary(profile)}
  local scan = currentLockScan()
  if scan then
    result.resolution = vehicleDNALocks.resolve(profile, scan)
    result.slots = {}
    for _, slot in ipairs(scan.slots or {}) do
      result.slots[#result.slots + 1] = {
        path = slot.path, slotId = slot.id, partName = slot.currentPart,
        category = vehicleDNALocks.classifySlot(slot), locked = vehicleDNALocks.isSlotLocked(profile, slot),
      }
    end
  end
  adapter.emit("SoturineChaosRandomizerLocks", result)
  return result
end

local function requestState()
  initialize()
  publishState()
  return publicState()
end

local function setUICompactMode(mode)
  initialize()
  local allowed = {collapsed = true, compact = true, standard = true, expanded = true}
  if not allowed[mode] then return false end
  runtime.uiMode = mode
  publishState()
  return true
end

local function copyDiagnostics()
  initialize()
  local state = publicState()
  local active = runtime.active
  local tracker = active and active.targetTracker and vehicleTargetTracker.summary(active.targetTracker, adapter.clock()) or nil
  local pending = state.transaction and state.transaction.pending or {}
  local payload = {
    extensionVersion = EXTENSION_VERSION,
    gameVersion = adapter.getGameVersion(),
    state = runtime.state.state,
    lifecycle = {
      operationId = runtime.state.operationId,
      operationToken = runtime.state.token,
      operationGeneration = runtime.state.operationGeneration,
      phaseGeneration = runtime.state.phaseGeneration,
      targetGeneration = runtime.state.targetGeneration,
      phase = runtime.state.phase,
      busy = operationState.deriveBusy(runtime.state),
      pauseState = state.clocks.pauseKnown and state.clocks.paused or "unknown",
      realTime = state.clocks.realMonotonicTime,
      simulationTime = state.clocks.simulationTime,
      realDelta = state.clocks.realDelta,
      simulationDelta = state.clocks.simulationDelta,
      frame = state.clocks.frameCounter,
      expectedTarget = util.deepCopy(runtime.state.expectedTarget),
      currentPlayerVehicle = state.activeVehicleAvailable and runtime.state.vehicleId or nil,
      targetIdentityStatus = tracker and tracker.identityStatus,
      treeConvergenceStatus = tracker and tracker.treeStatus,
      stableIdentityFrames = tracker and tracker.stabilizationFrames,
      stableTreeScans = tracker and tracker.treeStabilizationScans,
      staleCallbackCount = runtime.state.staleCallbackCount,
      recoveryOnly = active and active.recoveryOnly == true or false,
      originalSnapshotIdentity = state.transaction and state.transaction.originalSnapshot,
      candidateBaseIdentity = state.transaction and state.transaction.candidateBase,
      lastCompletedGoodIdentity = state.recovery and state.recovery.lastCompletedGoodSnapshot,
      recoveryTargetIdentity = state.transaction and state.transaction.recoveryTarget,
      pendingPartsCount = pending.currentBatch or 0,
      pendingTuningCount = pending.tuning or 0,
      pendingPaintCount = pending.paint or 0,
      watchdog = util.deepCopy(state.watchdog),
    },
    lastResult = util.deepCopy(runtime.lastResult),
    lastFailure = util.deepCopy(runtime.lastFailure),
    performance = util.deepCopy(runtime.performance),
    recovery = vehicleRecovery.metrics(runtime.recovery),
    lineup = state.lineup and state.lineup.current and {
      episodeSeed = state.lineup.current.episodeSeed,
      summary = util.deepCopy(state.lineup.current.summary),
    } or nil,
    ai = state.aiDirector and {
      vehicles = util.deepCopy(state.aiDirector.vehicles),
      destinationStatus = state.aiDirector.destination and state.aiDirector.destination.status,
      routePoints = state.aiDirector.route and #(state.aiDirector.route.points or {}) or 0,
    } or nil,
    records = diagnosticsModule.snapshot(runtime.diagnostics),
  }
  local ok, encoded = adapter.encodeJSON(payload, true)
  if not ok then return false end
  while #encoded > 262144 and #payload.records > 0 do
    table.remove(payload.records, 1)
    ok, encoded = adapter.encodeJSON(payload, true)
    if not ok then return false end
  end
  adapter.emit("SoturineChaosRandomizerDiagnostics", {text = encoded, bytes = #encoded})
  return true
end

local function spawnSafeVehicle()
  initialize()
  if runtime.state.busy then return false end
  return startSpawnOperation("randomConfig", {safeOfficial = true})
end

local function retryQuarantinedConfigurations()
  if runtime.state.busy then return false end
  vehicleRecovery.retryQuarantined(runtime.recovery)
  setResult(true, "vehicle_quarantine_cleared", "Quarantined configurations are eligible for a manual retry")
  publishState()
  return true
end

local function persistDNALibrary(candidate, successCode, successMessage)
  local normalized, validationError = vehicleDNAStorage.normalizeLibrary(candidate, runtime.settings.dnaLibraryLimit)
  if not normalized then
    setResult(false, validationError, "Vehicle DNA library validation failed")
    publishState()
    return false
  end
  if type(adapter.saveDNALibrary) ~= "function" or not runtime.capabilities.dnaWrite then
    setResult(false, "dna_storage_unavailable", "Vehicle DNA persistence is unavailable")
    publishState()
    return false
  end
  local ok, writeResult = adapter.saveDNALibrary(normalized, runtime.dna.library)
  if not ok then
    setResult(false, writeResult.code, writeResult.message, writeResult.context)
    if writeResult.code == "dna_storage_recovered" then runtime.dna.loadStatus = "last_known_good_recovered" end
    publishState()
    return false
  end
  local okRead, readback = adapter.loadDNALibrary()
  local verified, readError = okRead and vehicleDNAStorage.normalizeLibrary(readback, runtime.settings.dnaLibraryLimit) or nil
  if not verified then
    setResult(false, "dna_storage_readback_failed", "Vehicle DNA library persisted but could not be verified", {reason = readError})
    publishState()
    return false
  end
  runtime.dna.library = verified
  runtime.dna.loaded = true
  runtime.dna.loadStatus = "primary_verified"
  setResult(true, successCode, successMessage, writeResult)
  publishState()
  return true
end

local function saveVehicleDNA(name)
  initialize()
  if runtime.state.busy then setResult(false, "busy", "Wait for the current operation before saving Vehicle DNA"); publishState(); return false end
  if not runtime.dna.pending then setResult(false, "dna_capture_unavailable", "Complete an operation before saving Vehicle DNA"); publishState(); return false end
  local entry = util.deepCopy(runtime.dna.pending)
  if type(name) == "string" and name ~= "" then entry.name = vehicleDNA.safeName(name, entry.name) end
  local updated, err, id = vehicleDNAStorage.add(runtime.dna.library, entry)
  if not updated then setResult(false, err, "Vehicle DNA could not be added to the library"); publishState(); return false end
  if persistDNALibrary(updated, "dna_saved", "Vehicle DNA saved") then
    runtime.dna.pending = nil
    runtime.dna.selectedId = id
    publishState()
    return true
  end
  return false
end

local function setVehicleDNAPage(page)
  initialize()
  local _, total = vehicleDNAStorage.summaries(runtime.dna.library, 0, 1)
  local maximum = math.max(0, math.ceil(total / runtime.dna.pageSize) - 1)
  runtime.dna.page = math.max(0, math.min(maximum, math.floor(tonumber(page) or 0)))
  publishState()
  return true
end

local function deleteVehicleDNA(id)
  initialize()
  if runtime.state.busy then return false end
  local entry = vehicleDNAStorage.find(runtime.dna.library, id)
  local updated, err = vehicleDNAStorage.remove(runtime.dna.library, id)
  if not updated then setResult(false, err, "Vehicle DNA entry was not found"); publishState(); return false end
  if runtime.dna.selectedId == id then runtime.dna.selectedId = nil end
  local persisted = persistDNALibrary(updated, "dna_deleted", "Vehicle DNA deleted")
  if persisted and entry and entry.thumbnail and entry.thumbnail.kind == "managed" then
    local removed, removeError = adapter.removeDNAThumbnail(id)
    if not removed then diagnosticsModule.write(runtime.diagnostics, "W", "thumbnail_cleanup_failed", removeError, true) end
  end
  return persisted
end

local function renameVehicleDNA(id, name)
  initialize()
  if runtime.state.busy then return false end
  local updated, err = vehicleDNAStorage.rename(runtime.dna.library, id, name)
  if not updated then setResult(false, err, "Vehicle DNA could not be renamed"); publishState(); return false end
  return persistDNALibrary(updated, "dna_renamed", "Vehicle DNA renamed")
end

local function setVehicleDNAFavorite(id, favorite)
  initialize()
  if runtime.state.busy then return false end
  local updated, err = vehicleDNAStorage.setFavorite(runtime.dna.library, id, favorite)
  if not updated then setResult(false, err, "Vehicle DNA favorite could not be updated"); publishState(); return false end
  return persistDNALibrary(updated, "dna_favorite_updated", "Vehicle DNA favorite updated")
end

local function persistMetadata(updated, err, code, message)
  if not updated then setResult(false, err, message .. " failed"); publishState(); return false end
  return persistDNALibrary(updated, code, message)
end

local function setVehicleDNAPinned(id, pinned)
  initialize(); if runtime.state.busy then return false end
  local updated, err = vehicleDNAStorage.setPinned(runtime.dna.library, id, pinned)
  return persistMetadata(updated, err, "dna_pinned_updated", "Vehicle DNA pin updated")
end

local function setVehicleDNARating(id, rating)
  initialize(); if runtime.state.busy then return false end
  local updated, err = vehicleDNAStorage.setRating(runtime.dna.library, id, rating)
  return persistMetadata(updated, err, "dna_rating_updated", "Vehicle DNA rating updated")
end

local function setVehicleDNATags(id, tags)
  initialize(); if runtime.state.busy then return false end
  local updated, err = vehicleDNAStorage.setTags(runtime.dna.library, id, tags)
  return persistMetadata(updated, err, "dna_tags_updated", "Vehicle DNA tags updated")
end

local function setVehicleDNACollection(id, collection)
  initialize(); if runtime.state.busy then return false end
  local updated, err = vehicleDNAStorage.setCollection(runtime.dna.library, id, collection)
  return persistMetadata(updated, err, "dna_collection_updated", "Vehicle DNA collection updated")
end

local function setVehicleDNANotes(id, notes)
  initialize(); if runtime.state.busy then return false end
  local updated, err = vehicleDNAStorage.setNotes(runtime.dna.library, id, notes)
  return persistMetadata(updated, err, "dna_notes_updated", "Vehicle DNA notes updated")
end

local function duplicateVehicleDNA(id)
  initialize(); if runtime.state.busy then return false end
  local updated, err, newId = vehicleDNAStorage.duplicate(runtime.dna.library, id)
  if not updated then setResult(false, err, "Vehicle DNA duplication failed"); publishState(); return false end
  runtime.dna.selectedId = newId
  return persistDNALibrary(updated, "dna_duplicated", "Vehicle DNA duplicated")
end

local function setVehicleDNAQuery(query)
  initialize()
  query = type(query) == "table" and query or {}
  local filter = {all = true, favorites = true, pinned = true, recent = true, exact = true, partial = true, missing = true}
  local sort = {updated = true, created = true, name = true, rating = true}
  runtime.dna.query = {
    search = type(query.search) == "string" and query.search:sub(1, 128) or "",
    filter = filter[query.filter] and query.filter or "all",
    sort = sort[query.sort] and query.sort or "updated",
    model = type(query.model) == "string" and query.model:sub(1, 256) or "",
    tag = type(query.tag) == "string" and query.tag:sub(1, 64) or "",
    collection = type(query.collection) == "string" and query.collection:sub(1, 80) or "",
  }
  runtime.dna.page = 0
  publishState()
  return true
end

local function getVehicleDNADetails(id)
  initialize()
  local entry = vehicleDNAStorage.find(runtime.dna.library, id)
  if not entry then setResult(false, "dna_not_found", "Vehicle DNA entry was not found"); publishState(); return false end
  local children = {}
  for _, child in ipairs(runtime.dna.library.entries or {}) do
    if child.lineage and child.lineage.parentId == id then children[#children + 1] = vehicleDNAStorage.summary(child) end
  end
  local parent = entry.lineage and entry.lineage.parentId and vehicleDNAStorage.find(runtime.dna.library, entry.lineage.parentId) or nil
  local details = {
    entry = entry,
    parent = parent and vehicleDNAStorage.summary(parent) or nil,
    children = children,
    summary = vehicleDNAStorage.summary(entry),
  }
  runtime.dna.selectedId = id
  runtime.dna.details = {
    id = id, summary = details.summary, parent = details.parent,
    childCount = #children, slotCount = #(entry.final and entry.final.slots or {}),
    tuningCount = #(entry.final and entry.final.tuning or {}), paintCount = #(entry.final and entry.final.paints or {}),
  }
  adapter.emit("SoturineChaosRandomizerDNADetails", details)
  publishState()
  return details
end

local function compareVehicleDNA(leftId, rightId)
  initialize()
  local left, right = vehicleDNAStorage.find(runtime.dna.library, leftId), vehicleDNAStorage.find(runtime.dna.library, rightId)
  if not left or not right then setResult(false, "dna_not_found", "Both Vehicle DNA entries are required for comparison"); publishState(); return false end
  local started = adapter.clock()
  local comparison, reason = vehicleDNACompare.compare(left, right)
  runtime.performance.compareMs = math.max(0, (adapter.clock() - started) * 1000)
  if not comparison then setResult(false, reason, "Vehicle DNA comparison failed"); publishState(); return false end
  runtime.dna.comparison = comparison
  adapter.emit("SoturineChaosRandomizerDNAComparison", comparison)
  setResult(true, "dna_comparison_ready", comparison.equal and "Vehicle DNA entries are equal" or "Vehicle DNA differences ready", {
    leftId = leftId, rightId = rightId, differenceCount = #comparison.differences,
  })
  publishState()
  return comparison
end

local function importVehicleDNA(value)
  initialize()
  if runtime.state.busy then return false end
  local imported = value
  if type(value) == "table" and value.format == "SoturineVehicleDNAShare" then
    if tonumber(value.shareVersion) ~= 1 or type(value.vehicleDNA) ~= "table" then
      setResult(false, "dna_share_envelope_invalid", "Vehicle DNA share envelope was rejected"); publishState(); return false
    end
    imported = value.vehicleDNA
  end
  local entry, importError = vehicleDNAImport.sanitize(imported)
  if not entry then setResult(false, importError, "Vehicle DNA import was rejected"); publishState(); return false end
  local originId = entry.id
  entry.lineage = util.shallowMerge(entry.lineage or {}, {
    originId = originId, importedAt = os.time(), importStrategy = "validated_json_object",
  })
  local updated, addError, id = vehicleDNAStorage.add(runtime.dna.library, entry)
  if not updated then setResult(false, addError, "Vehicle DNA import could not be stored"); publishState(); return false end
  runtime.dna.selectedId = id
  return persistDNALibrary(updated, "dna_imported", "Vehicle DNA imported")
end

local function exportVehicleDNA(id, writeFile)
  initialize()
  local entry = vehicleDNAStorage.find(runtime.dna.library, id)
  if not entry then setResult(false, "dna_not_found", "Vehicle DNA entry was not found"); publishState(); return false end
  local ok, encoded = adapter.encodeJSON(entry, true)
  if not ok then setResult(false, encoded.code, encoded.message); publishState(); return false end
  runtime.dna.exportText = encoded
  adapter.emit("SoturineChaosRandomizerDNAExport", {text = encoded, format = "legacy-json", bytes = #encoded})
  runtime.dna.selectedId = id
  local details = {copyReady = true, bytes = #encoded}
  if writeFile == true and runtime.capabilities.dnaExportFile then
    local fileOk, fileResult = adapter.exportDNAFile(entry)
    if not fileOk then setResult(false, fileResult.code, fileResult.message, details); publishState(); return false end
    details.file = fileResult
  end
  setResult(true, "dna_export_ready", writeFile and "Vehicle DNA export ready" or "Vehicle DNA JSON ready to copy", details)
  publishState()
  return true
end

local function exportVehicleDNAJson(id, writeFile)
  initialize()
  local started = adapter.clock()
  local entry = vehicleDNAStorage.find(runtime.dna.library, id)
  if not entry then setResult(false, "dna_not_found", "Vehicle DNA entry was not found"); publishState(); return false end
  local envelope = vehicleDNAPackage.envelope(entry)
  local ok, encoded = adapter.encodeJSON(envelope, true)
  if not ok then setResult(false, encoded.code, encoded.message); publishState(); return false end
  runtime.dna.exportText = encoded
  runtime.dna.selectedId = id
  local checksumOk, checksum = adapter.sha256(encoded)
  local details = {copyReady = true, bytes = #encoded, format = ".vdna.json", sha256 = checksumOk and checksum or nil}
  if writeFile == true then
    local fileOk, fileResult = adapter.exportDNAFile(envelope)
    if not fileOk then setResult(false, fileResult.code, fileResult.message, details); publishState(); return false end
    details.file = fileResult
  end
  runtime.performance.exportMs = math.max(0, (adapter.clock() - started) * 1000)
  runtime.dna.sharePreview = {
    id = id, format = ".vdna.json", bytes = #encoded, sha256 = details.sha256,
    dependencies = util.deepCopy(entry.dependencies or {}), privacy = "No mod bytes, scripts, absolute paths, or personal data are included.",
  }
  adapter.emit("SoturineChaosRandomizerDNAExport", {
    text = encoded, format = ".vdna.json", bytes = #encoded, sha256 = details.sha256,
  })
  setResult(true, "dna_json_export_ready", "Vehicle DNA JSON share is ready", details)
  publishState()
  return true
end

local function packageSHA(value)
  local ok, digest = adapter.sha256(value)
  return ok and digest or nil
end

local function localImportCompatibility(entry)
  if not runtime.index.valid then
    local ok, indexError = rebuildIndex()
    if not ok then return nil, indexError end
  end
  local availableModIDs = {}
  for _, model in ipairs(runtime.index.models or {}) do
    local raw = model.raw or {}
    local id = raw.modID or raw.modId
    if id ~= nil then availableModIDs[tostring(id)] = true end
  end
  for _, config in ipairs(runtime.index.allConfigs or {}) do
    local raw = config.raw or {}
    local id = raw.modID or raw.modId
    if id ~= nil then availableModIDs[tostring(id)] = true end
  end
  return vehicleDNACompatibility.evaluate(entry, {
    modelsByKey = runtime.index.modelsByKey,
    configs = runtime.index.allConfigs,
    availableModIDs = availableModIDs,
    gameVersion = adapter.getGameVersion(),
    extensionVersion = EXTENSION_VERSION,
    targetBeamNG = TARGET_BEAMNG,
    generatorVersion = vehicleDNASchema.GENERATOR_VERSION,
  }, "compatible")
end

local function exportVehicleDNAPackage(id)
  initialize()
  if not runtime.capabilities.dnaPackageWrite then
    setResult(false, "vdna_package_export_unavailable", "This BeamNG environment cannot write validated Vehicle DNA packages"); publishState(); return false
  end
  local started = adapter.clock()
  local entry = vehicleDNAStorage.find(runtime.dna.library, id)
  if not entry then setResult(false, "dna_not_found", "Vehicle DNA entry was not found"); publishState(); return false end
  local okVehicle, vehicleJSON = adapter.encodeJSON(vehicleDNAPackage.envelope(entry), true)
  if not okVehicle then setResult(false, vehicleJSON.code, vehicleJSON.message); publishState(); return false end
  local compatibility = runtime.dna.selectedId == id and runtime.dna.preflight or {
    status = "not_evaluated", note = "Run compatibility inspection on the receiving installation.",
  }
  local okCompatibility, compatibilityJSON = adapter.encodeJSON(compatibility, true)
  if not okCompatibility then setResult(false, compatibilityJSON.code, compatibilityJSON.message); publishState(); return false end
  local readme = table.concat({
    "Soturine Vehicle DNA package", "", "Contains metadata only; no mods, JBeam, textures, scripts, or other third-party assets.",
    "Import through Soturine's Chaos Randomizer and inspect dependencies before restoring.", "",
  }, "\n")
  local payloads = {
    ["vehicle.vdna.json"] = vehicleJSON,
    ["compatibility.json"] = compatibilityJSON,
    ["README.txt"] = readme,
  }
  if entry.thumbnail and entry.thumbnail.kind == "managed" and type(adapter.readDNAThumbnail) == "function" then
    local thumbnailOk, thumbnailData = adapter.readDNAThumbnail(id)
    if thumbnailOk and vehicleDNAGallery.pngDimensions(thumbnailData) then
      payloads["thumbnail.png"] = thumbnailData
    elseif not thumbnailOk then
      diagnosticsModule.write(runtime.diagnostics, "W", "package_thumbnail_omitted", thumbnailData, true)
    end
  end
  local manifestFiles = {}
  local packageNames = {"vehicle.vdna.json", "compatibility.json"}
  if payloads["thumbnail.png"] then packageNames[#packageNames + 1] = "thumbnail.png" end
  packageNames[#packageNames + 1] = "README.txt"
  for _, name in ipairs(packageNames) do
    local digest = packageSHA(payloads[name])
    if not digest then setResult(false, "checksum_unavailable", "SHA-256 is required for Vehicle DNA packages"); publishState(); return false end
    manifestFiles[#manifestFiles + 1] = {name = name, bytes = #payloads[name], sha256 = digest}
  end
  local manifest = {
    format = "SoturineVehicleDNAPackage", packageVersion = vehicleDNAPackage.PACKAGE_VERSION,
    schemaVersion = entry.schemaVersion, generatorVersion = entry.generatorVersion,
    originId = entry.id, files = manifestFiles,
  }
  local okManifest, manifestJSON = adapter.encodeJSON(manifest, true)
  if not okManifest then setResult(false, manifestJSON.code, manifestJSON.message); publishState(); return false end
  payloads["manifest.json"] = manifestJSON
  local packageData, packageError = vehicleDNAPackage.build(payloads)
  if not packageData then setResult(false, packageError, "Vehicle DNA package validation failed before write"); publishState(); return false end
  local writeOk, writeResult = adapter.exportDNAPackage(packageData)
  if not writeOk then setResult(false, writeResult.code, writeResult.message); publishState(); return false end
  local digest = packageSHA(packageData)
  runtime.performance.exportMs = math.max(0, (adapter.clock() - started) * 1000)
  runtime.dna.sharePreview = {
    id = id, format = ".vdna.zip", bytes = #packageData, sha256 = digest,
    entries = #packageNames + 1, dependencies = util.deepCopy(entry.dependencies or {}),
    thumbnailIncluded = payloads["thumbnail.png"] ~= nil,
    privacy = payloads["thumbnail.png"] and "Metadata plus the explicitly captured managed vehicle image; no mod assets or scripts."
      or "Metadata only; no mod assets, scripts, absolute paths, or personal data.",
  }
  setResult(true, "vdna_package_exported", "Vehicle DNA package exported to the controlled share folder", {
    file = writeResult, bytes = #packageData, sha256 = digest, entries = #packageNames + 1,
  })
  publishState()
  return true
end

local function importVehicleDNAPackage(reference)
  initialize()
  if runtime.state.busy then return false end
  if reference ~= nil and reference ~= "" and reference ~= "inbox" then
    setResult(false, "vdna_package_reference_invalid", "Only the fixed Vehicle DNA inbox is accepted"); publishState(); return false
  end
  local started = adapter.clock()
  local readOk, packageData = adapter.importDNAPackage()
  if not readOk then setResult(false, packageData.code, packageData.message); publishState(); return false end
  local inspected, inspectError = vehicleDNAPackage.inspect(packageData)
  if not inspected then setResult(false, inspectError, "Vehicle DNA package was rejected"); publishState(); return false end
  local manifestOk, manifest = adapter.decodeJSON(inspected.entries["manifest.json"])
  if not manifestOk then setResult(false, manifest.code, manifest.message); publishState(); return false end
  local validManifest, manifestError = vehicleDNAPackage.validateManifest(manifest, inspected, packageSHA)
  if not validManifest then setResult(false, manifestError, "Vehicle DNA package manifest was rejected"); publishState(); return false end
  local vehicleOk, envelope = adapter.decodeJSON(inspected.entries["vehicle.vdna.json"])
  if not vehicleOk or envelope.format ~= "SoturineVehicleDNAShare" or tonumber(envelope.shareVersion) ~= 1 then
    setResult(false, "vdna_package_vehicle_invalid", "Vehicle DNA package payload was rejected"); publishState(); return false
  end
  local compatibilityOk, compatibilityPreview = adapter.decodeJSON(inspected.entries["compatibility.json"] or "")
  if not compatibilityOk then
    setResult(false, "vdna_package_compatibility_invalid", "Vehicle DNA compatibility preview was rejected"); publishState(); return false
  end
  local entry, importError = vehicleDNAImport.sanitize(envelope.vehicleDNA)
  if not entry then setResult(false, importError, "Packaged Vehicle DNA failed schema validation"); publishState(); return false end
  if tonumber(manifest.schemaVersion) ~= tonumber(entry.schemaVersion)
    or tostring(manifest.generatorVersion or "") ~= tostring(entry.generatorVersion or "")
  then setResult(false, "vdna_package_schema_mismatch", "Package manifest schema does not match Vehicle DNA payload"); publishState(); return false end
  local originId = entry.id
  local exporterCompatibility = {
    status = type(compatibilityPreview.status) == "string" and compatibilityPreview.status:sub(1, 64) or "not_evaluated",
    registryStatus = type(compatibilityPreview.registryStatus) == "string" and compatibilityPreview.registryStatus:sub(1, 64) or nil,
    missing = math.max(0, math.floor(tonumber(compatibilityPreview.missing) or 0)),
    changed = math.max(0, math.floor(tonumber(compatibilityPreview.changed) or 0)),
  }
  local localCompatibility, localError = localImportCompatibility(entry)
  if not localCompatibility then
    setResult(false, localError.code or "local_compatibility_unavailable", localError.message or "Local compatibility could not be evaluated")
    publishState()
    return false
  end
  entry.extensions = util.shallowMerge(entry.extensions or {}, {
    exporterCompatibility = exporterCompatibility,
  })
  entry.lineage = util.shallowMerge(entry.lineage or {}, {
    originId = originId, importedAt = os.time(), importStrategy = "validated_vdna_package",
  })
  local validEntry, entryError = vehicleDNASchema.validateEntry(entry)
  if not validEntry then setResult(false, entryError, "Imported lineage metadata is invalid"); publishState(); return false end
  local thumbnailData, thumbnailDimensions = inspected.entries["thumbnail.png"], nil
  if thumbnailData then
    thumbnailDimensions = vehicleDNAGallery.pngDimensions(thumbnailData)
    if not thumbnailDimensions then setResult(false, "thumbnail_png_invalid", "Packaged thumbnail was rejected"); publishState(); return false end
  end
  runtime.dna.importPreview = {
    entry = entry,
    thumbnailData = thumbnailData,
    thumbnailDimensions = thumbnailDimensions,
    public = {
      originId = originId, summary = vehicleDNAStorage.summary(entry),
      dependencies = util.deepCopy(entry.dependencies or {}), packageBytes = #packageData,
      packageSha256 = packageSHA(packageData), thumbnailPresent = inspected.entries["thumbnail.png"] ~= nil,
      exporterCompatibility = exporterCompatibility,
      localCompatibility = util.deepCopy(localCompatibility),
      compatibility = util.deepCopy(localCompatibility),
    },
  }
  runtime.performance.importMs = math.max(0, (adapter.clock() - started) * 1000)
  setResult(true, "vdna_package_preview_ready", "Vehicle DNA package is valid; confirm import after reviewing dependencies", runtime.dna.importPreview.public)
  publishState()
  return true
end

local function confirmVehicleDNAPackageImport()
  initialize()
  if runtime.state.busy or not runtime.dna.importPreview then return false end
  local updated, addError, id = vehicleDNAStorage.add(runtime.dna.library, runtime.dna.importPreview.entry)
  if not updated then setResult(false, addError, "Vehicle DNA package could not be stored"); publishState(); return false end
  local wroteThumbnail = false
  if runtime.dna.importPreview.thumbnailData then
    local writeOk, writeError = adapter.writeDNAThumbnail(id, runtime.dna.importPreview.thumbnailData)
    if not writeOk then setResult(false, writeError.code, writeError.message); publishState(); return false end
    wroteThumbnail = true
    local metadata = vehicleDNAGallery.managedMetadata(id, runtime.dna.importPreview.thumbnailDimensions)
    updated, addError = vehicleDNAStorage.setThumbnail(updated, id, metadata)
    if not updated then adapter.removeDNAThumbnail(id); setResult(false, addError, "Imported thumbnail metadata failed validation"); publishState(); return false end
  end
  runtime.dna.selectedId = id
  runtime.dna.importPreview = nil
  local persisted = persistDNALibrary(updated, "vdna_package_imported", "Vehicle DNA package imported with a unique local ID")
  if not persisted and wroteThumbnail then adapter.removeDNAThumbnail(id) end
  return persisted
end

local function currentThumbnailState(entry)
  local okCapture, capture = adapter.captureCurrentState("thumbnail_preflight", entry.generation and entry.generation.seed)
  if not okCapture then return nil, capture end
  local okSnapshot, snapshot = adapter.getCurrentSlotSnapshot()
  if not okSnapshot then return nil, snapshot end
  local scan, scanError = slotScanner.scan(snapshot.tree, snapshot.metadataByPath)
  if not scan then return nil, adapter.errorValue(scanError, "Thumbnail state scan failed") end
  local observed = {
    modelKey = capture.modelKey,
    configIdentity = configVerification.normalizePath(capture.selectedConfiguration),
    slots = vehicleDNANormalizer.normalizeSlots(scan),
    tuning = vehicleDNANormalizer.normalizeTuning(snapshot.variables, capture.tuning or snapshot.currentTuning),
    paints = vehicleDNANormalizer.normalizePaints(capture.paints or snapshot.paints),
  }
  local expected = {
    modelKey = entry.final.modelKey,
    configIdentity = configVerification.normalizePath(entry.final.configIdentity or (entry.base and entry.base.configPath)),
    slots = util.deepCopy(entry.final.slots or {}),
    tuning = util.deepCopy(entry.final.tuning or {}),
    paints = util.deepCopy(entry.final.paints or {}),
  }
  return {
    exact = util.deepEqual(expected, observed, 1e-8),
    fingerprint = vehicleDNAFingerprint.fingerprint(observed),
    observed = observed,
  }
end

local function captureVehicleDNAThumbnail(id, options)
  initialize()
  if runtime.state.busy or runtime.dna.thumbnailPending then return false end
  local entry = vehicleDNAStorage.find(runtime.dna.library, id)
  if not entry then setResult(false, "dna_not_found", "Vehicle DNA entry was not found"); publishState(); return false end
  if not (entry.thumbnail and entry.thumbnail.kind == "managed") then
    local managedCount = 0
    for _, candidate in ipairs(runtime.dna.library.entries or {}) do
      if candidate.thumbnail and candidate.thumbnail.kind == "managed" then managedCount = managedCount + 1 end
    end
    if managedCount >= vehicleDNAGallery.MAX_MANAGED_THUMBNAILS then
      setResult(false, "thumbnail_count_limit", "Managed thumbnail limit reached"); publishState(); return false
    end
  end
  options = type(options) == "table" and options or {}
  local stateMatch, stateError = currentThumbnailState(entry)
  if not stateMatch then
    setResult(false, stateError.code or "thumbnail_state_unavailable", stateError.message or "Current vehicle state could not be verified"); publishState(); return false
  end
  if not stateMatch.exact and options.allowNonExact ~= true then
    setResult(false, "thumbnail_state_mismatch", "Restore the exact Vehicle DNA state or explicitly allow a non-exact thumbnail"); publishState(); return false
  end
  local started = adapter.clock()
  runtime.dna.thumbnailPending = id
  local captureOk, captureResult = adapter.captureDNAThumbnail(id, function(success, result)
    runtime.dna.thumbnailPending = nil
    runtime.performance.thumbnailLoadMs = math.max(0, (adapter.clock() - started) * 1000)
    if not success or runtime.state.busy then
      adapter.removeDNAThumbnail(id)
      setResult(false, success and "thumbnail_operation_conflict" or result.code, success and "Thumbnail capture overlapped another operation" or result.message)
      publishState(); return
    end
    local dimensions, reason = vehicleDNAGallery.pngDimensions(result.data)
    if not dimensions then adapter.removeDNAThumbnail(id); setResult(false, reason, "Captured thumbnail was rejected"); publishState(); return end
    local finalMatch, finalMatchError = currentThumbnailState(entry)
    if not finalMatch or (stateMatch.exact and not finalMatch.exact) then
      adapter.removeDNAThumbnail(id)
      setResult(false, "thumbnail_state_changed", finalMatchError and finalMatchError.message or "Vehicle state changed during thumbnail capture")
      publishState(); return
    end
    local metadata = vehicleDNAGallery.managedMetadata(id, dimensions, {
      exactState = stateMatch.exact,
      capturedFingerprint = finalMatch.fingerprint,
    })
    local updated, updateError = vehicleDNAStorage.setThumbnail(runtime.dna.library, id, metadata)
    if not updated then adapter.removeDNAThumbnail(id); setResult(false, updateError, "Thumbnail metadata could not be stored"); publishState(); return end
    persistDNALibrary(updated, "thumbnail_captured", "Vehicle DNA thumbnail captured")
  end)
  if not captureOk then runtime.dna.thumbnailPending = nil; setResult(false, captureResult.code, captureResult.message); publishState(); return false end
  setResult(true, "thumbnail_capture_started", "Capturing a bounded Vehicle DNA thumbnail", captureResult)
  publishState()
  return true
end

local function removeVehicleDNAThumbnail(id)
  initialize()
  if runtime.state.busy then return false end
  local entry = vehicleDNAStorage.find(runtime.dna.library, id)
  if not entry then setResult(false, "dna_not_found", "Vehicle DNA entry was not found"); publishState(); return false end
  if entry.thumbnail and entry.thumbnail.kind == "managed" then
    local removeOk, removeError = adapter.removeDNAThumbnail(id)
    if not removeOk then setResult(false, removeError.code, removeError.message); publishState(); return false end
  end
  local updated, updateError = vehicleDNAStorage.setThumbnail(runtime.dna.library, id, nil)
  if not updated then setResult(false, updateError, "Thumbnail metadata could not be removed"); publishState(); return false end
  return persistDNALibrary(updated, "thumbnail_removed", "Vehicle DNA thumbnail removed; safe fallback restored")
end

local function dnaEnvironment(entry)
  if not runtime.index.valid then
    local ok, err = rebuildIndex()
    if not ok then return nil, err end
  end
  local okModel, currentModel = adapter.getCurrentModelKey()
  if not okModel then return nil, currentModel end
  local snapshot = {variables = {}, paints = {}}
  local scan
  local currentConfigPath
  local okConfig, currentConfig = adapter.getCurrentConfig()
  if okConfig and type(currentConfig) == "table" then
    currentConfigPath = configVerification.normalizePath(
      currentConfig.partConfigFilename or currentConfig.configPath or currentConfig.configKey
    )
  end
  if currentModel == (entry.base and entry.base.modelKey) then
    local okSnapshot, snapshotOrError = adapter.getCurrentSlotSnapshot()
    if not okSnapshot then return nil, snapshotOrError end
    snapshot = snapshotOrError
    local scanError
    scan, scanError = slotScanner.scan(snapshot.tree, snapshot.metadataByPath)
    if not scan then return nil, adapter.errorValue(scanError, "Compatibility slot scan failed") end
  end
  local availableModIDs = {}
  for _, model in ipairs(runtime.index.models or {}) do
    local raw = model.raw or {}
    local id = raw.modID or raw.modId
    if id ~= nil then availableModIDs[tostring(id)] = true end
  end
  for _, config in ipairs(runtime.index.allConfigs or {}) do
    local raw = config.raw or {}
    local id = raw.modID or raw.modId
    if id ~= nil then availableModIDs[tostring(id)] = true end
  end
  for _, slot in ipairs(scan and scan.slots or {}) do
    for candidate, metadata in pairs(slot.candidateMetadata or {}) do
      if type(metadata) == "table" and metadata.sourceKind == "mod" then
        availableModIDs[tostring(metadata.modID or candidate)] = true
      end
    end
  end
  return {
    modelsByKey = runtime.index.modelsByKey,
    configs = runtime.index.allConfigs,
    scan = scan,
    variables = snapshot.variables or {},
    paints = snapshot.paints or {},
    gameVersion = adapter.getGameVersion(),
    extensionVersion = EXTENSION_VERSION,
    targetBeamNG = TARGET_BEAMNG,
    generatorVersion = vehicleDNASchema.GENERATOR_VERSION,
    currentModelKey = currentModel,
    currentConfigPath = currentConfigPath,
    availableModIDs = availableModIDs,
  }
end

preflightVehicleDNA = function(id, mode)
  initialize()
  if runtime.state.busy then return false end
  local started = adapter.clock()
  local entry = vehicleDNAStorage.find(runtime.dna.library, id)
  if not entry then setResult(false, "dna_not_found", "Vehicle DNA entry was not found"); publishState(); return false end
  local environment, environmentError = dnaEnvironment(entry)
  if not environment then setResult(false, environmentError.code, environmentError.message); publishState(); return false end
  local report = vehicleDNACompatibility.evaluate(entry, environment, mode)
  runtime.performance.compatibilityMs = math.max(0, (adapter.clock() - started) * 1000)
  runtime.dna.preflight = report
  runtime.dna.selectedId = id
  local reasonCode = report.status == "target_inspection_required" and "dna_target_inspection_required"
    or report.registryStatus == "registry_incompatible" and "dna_registry_preflight_incompatible"
    or report.registryStatus == "registry_compatible" and "dna_registry_preflight_compatible"
    or "dna_registry_preflight_exact"
  setResult(report.status ~= "incompatible", reasonCode, "Vehicle DNA registry preflight: " .. report.status, report)
  diagnosticsModule.write(runtime.diagnostics, "I", "dna_registry_preflight", report, true)
  publishState()
  return report.status ~= "incompatible", report
end

local function pureSeedReplayVehicleDNA(id)
  initialize()
  if runtime.state.busy then return false end
  local entry = vehicleDNAStorage.find(runtime.dna.library, id)
  if not entry then setResult(false, "dna_not_found", "Vehicle DNA entry was not found"); publishState(); return false end
  if tonumber(entry.generation and entry.generation.generatorVersion) ~= vehicleDNASchema.GENERATOR_VERSION then
    setResult(false, "dna_replay_generator_unsupported", "This Vehicle DNA generator version is not supported for Pure Seed Replay")
    publishState()
    return false
  end
  local operation = entry.generation and entry.generation.operation
  if operation ~= "randomConfig" and operation ~= "scramble" and operation ~= "fullRandom" then
    setResult(false, "dna_replay_operation_unsupported", "This Vehicle DNA operation cannot be replayed")
    publishState()
    return false
  end
  local replaySettings = settingsModule.validate(entry.generation.settings or {})
  replaySettings.manualSeed = entry.generation.seed
  runtime.dna.selectedId = id
  local started = runAction(operation, replaySettings)
  if started and runtime.active then
    runtime.active.replayDNAId = id
    if entry.environment and entry.environment.beamNGVersion ~= adapter.getGameVersion() then
      runtime.active.warnings[#runtime.active.warnings + 1] = "Replay Seed is running in a different BeamNG environment and does not promise snapshot equality."
    end
  end
  return started
end

startVehicleDNABaseOperation = function(entry, registryReport, purpose, confirmPartial, creativeContext)
  local kind = purpose == "replay" and "dnaReplayGeneration"
    or purpose == "mutation" and "dnaMutation"
    or (purpose == "restore_exact" and "dnaRestoreExact" or "dnaRestoreCompatible")
  local okBegin, activeOrError = beginOperation(kind, {operationTimeout = DNA_RESTORE_TIMEOUT})
  if not okBegin then setResult(false, activeOrError.code, activeOrError.message); publishState(); return false end
  local active = activeOrError
  active.seed = entry.generation.seed
  active.rng = rngModule.new(active.seed)
  active.phase = "dna_registry_preflight"
  active.dnaEntry = entry
  active.dnaMode = purpose == "restore_exact" and "exact"
    or purpose == "restore_compatible" and "compatible"
    or purpose == "mutation" and "exact" or "replay"
  active.replayGeneration = purpose == "replay"
  active.confirmPartial = confirmPartial == true
  active.policy = mutationPolicy.fromSettings(entry.generation and entry.generation.settings or runtime.settings)
  if purpose == "replay" then
    creativeContext = type(creativeContext) == "table" and creativeContext or {}
    active.replayLockPolicy = creativeContext.lockPolicy or "original"
    active.lockProfileSnapshot = vehicleDNALocks.normalize(creativeContext.lockProfile)
  elseif purpose == "mutation" then
    creativeContext = type(creativeContext) == "table" and creativeContext or {}
    active.creativeOperation = creativeContext.creativeOperation or "mutation"
    active.captureOperation = entry.generation.operation
    active.seed = creativeContext.seed
    active.rng = rngModule.new(active.seed)
    active.policy = mutationPolicy.fromSettings(creativeContext.settings)
    active.lockProfileSnapshot = vehicleDNALocks.normalize(creativeContext.lockProfile)
    active.pendingLineage = util.deepCopy(creativeContext.lineage)
    active.mutationStrength = creativeContext.strength
    active.allowModelChange = creativeContext.allowModelChange == true
  end
  active.dnaReport = registryReport
  active.dnaDeviations = {}
  active.dnaDeviationKeys = {}
  for _, deviation in ipairs(registryReport.deviations or {}) do addDNADeviation(active, deviation) end
  active.dnaAppliedParts = {}
  active.dnaExpectedTuning = {}
  active.dnaExpectedPaints = {}
  active.dnaPass = 1
  active.modelKey = entry.base.modelKey
  active.baseConfirmed = false
  local resolvedConfig = registryReport.configuration and registryReport.configuration.resolvedPath
    or entry.base.configPath or entry.base.configKey
  for _, model in ipairs(runtime.index.models or {}) do
    if model.key == entry.base.modelKey then active.selectedModel = model; break end
  end
  for _, config in ipairs(runtime.index.allConfigs or {}) do
    if config.modelKey == entry.base.modelKey and (
      config.path == resolvedConfig or config.key == (registryReport.configuration and registryReport.configuration.resolvedKey)
    ) then active.selectedConfig = config; break end
  end
  active.selectionContext = {strategy = "saved_base_frozen", modelKey = entry.base.modelKey, config = resolvedConfig}
  local okCapture, captureError = captureOriginal(active)
  if not okCapture then failActive(captureError, false, "dna_registry_preflight"); return false end
  operationState.transition(runtime.state, "spawning", false)
  local configIdentity = {
    modelKey = entry.base.modelKey,
    key = entry.base.configKey,
    path = entry.base.configPath,
    registryIdentity = entry.base.configKey ~= nil,
  }
  local okWait, waitError = enterWaiting(active, "dna_base_spawn", "dna_target_preflight", {
    modelKey = entry.base.modelKey,
    configIdentity = configIdentity,
  }, "Loading saved Vehicle DNA base", 0.18)
  if not okWait then failActive(waitError, false, "dna_base_spawn"); return false end
  local okHistory, historyError = commitHistory(active)
  if not okHistory then failActive(historyError, false, "dna_base_spawn"); return false end
  local okReplace, replaceError = issueReplacement(active, entry.base.modelKey, resolvedConfig, "dna_base_spawn")
  if not okReplace then failActive(replaceError, true, "dna_base_spawn"); return false end
  return true
end

local function replayVehicleDNAGeneration(id, lockPolicy)
  initialize()
  if runtime.state.busy then return false end
  local entry = vehicleDNAStorage.find(runtime.dna.library, id)
  if not entry then setResult(false, "dna_not_found", "Vehicle DNA entry was not found"); publishState(); return false end
  if tonumber(entry.generation and entry.generation.generatorVersion) ~= vehicleDNASchema.GENERATOR_VERSION then
    setResult(false, "dna_replay_generator_unsupported", "This Vehicle DNA generator version cannot replay generation stages")
    publishState()
    return false
  end
  local operation = entry.generation and entry.generation.operation
  if operation ~= "randomConfig" and operation ~= "scramble" and operation ~= "fullRandom" then
    setResult(false, "dna_replay_operation_unsupported", "This Vehicle DNA operation cannot be replayed")
    publishState()
    return false
  end
  local preflightOk, report = preflightVehicleDNA(id, "compatible")
  if not preflightOk or not report or report.registryStatus == "registry_incompatible" then return false end
  runtime.dna.selectedId = id
  lockPolicy = lockPolicy == "current" and "current" or "original"
  local lockProfile = lockPolicy == "current" and runtime.settings.lockProfile or entry.lockProfile
  return startVehicleDNABaseOperation(entry, report, "replay", true, {lockPolicy = lockPolicy, lockProfile = lockProfile})
end

local function replayVehicleDNA(id)
  return replayVehicleDNAGeneration(id, "original")
end

local function mutateVehicleDNA(id, strength, options)
  initialize()
  if runtime.state.busy then return false end
  local entry = vehicleDNAStorage.find(runtime.dna.library, id)
  if not entry then setResult(false, "dna_not_found", "Vehicle DNA entry was not found"); publishState(); return false end
  if not vehicleDNAMutations.validateStrength(strength) then
    setResult(false, "mutation_strength_invalid", "Mutation strength must be small, medium, or wild"); publishState(); return false
  end
  options = type(options) == "table" and options or {}
  local index = math.max(1, math.floor(tonumber(options.mutationIndex) or vehicleDNAMutations.nextIndex(runtime.dna.library, id)))
  local seed, seedError = vehicleDNAMutations.deriveSeed(entry.generation.seed, entry.id, index, strength)
  if not seed then setResult(false, seedError, "Mutation seed could not be derived"); publishState(); return false end
  local lineage, lineageError = vehicleDNAMutations.lineage(entry, index, strength, "mutation")
  if not lineage then setResult(false, lineageError, "Mutation lineage limit reached"); publishState(); return false end
  lineage.mutationSeed = seed
  local mutationSettings = vehicleDNAMutations.settingsForStrength(entry.generation.settings, strength)
  local preflightOk, report = preflightVehicleDNA(id, "compatible")
  if not preflightOk or not report or report.registryStatus == "registry_incompatible" then return false end
  runtime.dna.selectedId = id
  return startVehicleDNABaseOperation(entry, report, "mutation", true, {
    seed = seed,
    settings = mutationSettings,
    lockProfile = runtime.settings.lockProfile,
    lineage = lineage,
    strength = strength,
    allowModelChange = strength == "wild" and not vehicleDNALocks.requiresModel(runtime.settings.lockProfile),
  })
end

local function restoreVehicleDNA(id, mode, confirmPartial)
  initialize()
  if runtime.state.busy then return false end
  mode = mode == "compatible" and "compatible" or "exact"
  local entry = vehicleDNAStorage.find(runtime.dna.library, id)
  if not entry then setResult(false, "dna_not_found", "Vehicle DNA entry was not found"); publishState(); return false end
  local preflightOk, report = preflightVehicleDNA(id, mode)
  if not preflightOk or type(report) ~= "table" then return false end
  if report.registryStatus == "registry_incompatible" or report.status == "incompatible" then return false end
  if mode == "exact" and report.status ~= "exact" and report.status ~= "target_inspection_required" then
    setResult(false, "dna_registry_preflight_incompatible", "Restore Exact registry preflight is incompatible", report)
    publishState(); return false
  end
  if mode == "compatible" and report.status == "partial" and confirmPartial ~= true then
    setResult(false, "dna_partial_authorization_required", "Restore Compatible requires authorization for a partial result", report)
    publishState()
    return false
  end
  return startVehicleDNABaseOperation(entry, report, mode == "exact" and "restore_exact" or "restore_compatible", confirmPartial)
end

runDNATargetPreflight = function(active)
  active.phase = "dna_target_preflight"
  setProgress("Inspecting loaded Vehicle DNA target", 0.24)
  local environment, environmentError = dnaEnvironment(active.dnaEntry)
  if not environment then failActive(environmentError, true, "dna_target_preflight"); return end
  local inspectionMode = active.creativeOperation and "compatible"
    or active.dnaMode == "exact" and "exact" or "compatible"
  local report = vehicleDNACompatibility.evaluate(active.dnaEntry, environment, inspectionMode)
  active.dnaTargetReport = report
  runtime.dna.preflight = report
  for _, deviation in ipairs(report.deviations or {}) do addDNADeviation(active, deviation) end
  diagnosticsModule.write(runtime.diagnostics, "I", "dna_target_preflight", report, true)
  if (report.status == "target_inspection_required" and not active.creativeOperation) or report.status == "incompatible" then
    failActive(adapter.errorValue("dna_target_preflight_incompatible", "Loaded Vehicle DNA target is incompatible", {report = report}), true, "dna_target_preflight")
    return
  end
  if active.dnaMode == "exact" and not active.creativeOperation and report.status ~= "exact" then
    failActive(adapter.errorValue("dna_target_preflight_incompatible", "Restore Exact target inspection found differences", {report = report}), true, "dna_target_preflight")
    return
  end
  if report.status == "partial" and active.dnaMode ~= "replay" and not active.confirmPartial then
    failActive(adapter.errorValue("dna_partial_authorization_required", "Partial target restore was not authorized", {report = report}), true, "dna_target_preflight")
    return
  end
  active.dnaTargetStatus = report.status
  if active.replayGeneration then
    if active.dnaEntry.generation.operation == "randomConfig" then
      local transitioned, transitionError = operationState.transition(runtime.state, "validating", false)
      if not transitioned then failActive(adapter.errorValue("state_error", transitionError), true, "dna_replay_verification"); return end
      local safe, safetyOrError = validateFinalVehicle(active)
      if not safe then failActive(safetyOrError, true, "dna_replay_verification"); return end
      completeReplayGeneration(active, safetyOrError)
    else
      active.pass = 1
      active.previousScan = nil
      active.deferredPaths = {}
      active.mutatedPaths = {}
      operationState.transition(runtime.state, "scanning", false)
      processMutationPass(active)
    end
    return
  end
  operationState.transition(runtime.state, "scanning", false)
  processDNAParts(active)
end

processDNAParts = function(active)
  if not operationState.isCurrent(runtime.state, active.token) then return end
  if active.recoveryOnly then guardMutationWrite(active, "dna_parts"); return end
  active.phase = "dna_parts"
  local okSnapshot, snapshot = adapter.getCurrentSlotSnapshot()
  if not okSnapshot then failActive(snapshot, true, "dna_parts"); return end
  local scan, scanError = slotScanner.scan(snapshot.tree, snapshot.metadataByPath)
  if not scan then failActive(adapter.errorValue(scanError, "Vehicle DNA parts scan failed"), true, "dna_parts"); return end
  if not active.safetyBaseline then
    active.safetyBaseline = validator.buildGraph(scan, safetyContext(active, snapshot))
  end
  local tree, batch, issues = vehicleDNARestore.planPartsPass(active.dnaEntry, scan, active.dnaMode)
  for _, issue in ipairs(issues or {}) do addDNADeviation(active, issue) end
  if not tree then
    failActive(adapter.errorValue("dna_parts_incompatible", "Saved Vehicle DNA parts are unavailable", {issues = issues}), true, "dna_parts")
    return
  end
  local scanState = {}
  for _, slot in ipairs(scan.slots or {}) do scanState[#scanState + 1] = {path = slot.path, partName = slot.currentPart} end
  local scanFingerprint = vehicleDNAFingerprint.fingerprint(scanState)
  if not active.dnaPassBudget then
    active.dnaPassBudget = vehicleDNAPassBudget.create(
      active.dnaEntry.metrics and active.dnaEntry.metrics.maxDepth,
      scan.metrics and scan.metrics.maxDepth,
      active.startedAt,
      DNA_RESTORE_TIMEOUT
    )
  end
  local progressOk, progressReason = vehicleDNAPassBudget.observe(active.dnaPassBudget, scanFingerprint, #batch, adapter.clock())
  if not progressOk then
    failActive(adapter.errorValue(progressReason, "Vehicle DNA restore stopped because the parts tree did not make bounded progress", {
      pass = active.dnaPassBudget.pass, passLimit = active.dnaPassBudget.passLimit,
      pending = #batch, scanFingerprint = scanFingerprint,
    }), true, "dna_parts")
    return
  end
  if #batch == 0 then
    operationState.transition(runtime.state, "tuning", false)
    startDNATuning(active)
    return
  end
  operationState.transition(runtime.state, "mutating", false)
  local expected = {}
  for _, change in ipairs(batch) do
    expected[change.slotPath] = change.selectedPart
    active.dnaAppliedParts[change.slotPath] = change.selectedPart
  end
  active.currentBatch = util.deepCopy(batch)
  local okWait, waitError = enterWaiting(active, "dna_parts", "dna_parts", {
    vehicleId = active.vehicleId, modelKey = active.dnaEntry.final.modelKey, parts = expected,
  }, "Restoring Vehicle DNA parts", 0.25 + math.min(active.dnaPass / active.dnaPassBudget.passLimit, 1) * 0.42)
  if not okWait then failActive(waitError, true, "dna_parts"); return end
  bindMutationPlan(active, "dna_parts")
  local guardOk, guardError = guardMutationWrite(active, "dna_parts")
  if not guardOk then failActive(guardError, true, "dna_parts"); return end
  local okApply, applyError = adapter.applyPartsTree(tree)
  if not okApply then failActive(applyError, true, "dna_parts"); return end
  noteSuccessfulWrite(active, "dna_parts")
  active.dnaPass = active.dnaPass + 1
end

startDNATuning = function(active)
  if active.recoveryOnly then guardMutationWrite(active, "dna_tuning"); return end
  active.phase = "dna_tuning"
  if not runtime.capabilities.scrambleTuning then
    if active.dnaMode == "exact" and #(active.dnaEntry.final.tuning or {}) > 0 then
      failActive(adapter.errorValue("dna_tuning_capability_missing", "Restore Exact requires tuning read/write capability"), true, "dna_tuning")
      return
    end
    addDNADeviation(active, {phase = "execution", reason = "tuning_capability_missing"})
    operationState.transition(runtime.state, "painting", false)
    startDNAPaint(active)
    return
  end
  local okSnapshot, snapshot = adapter.getTuningSnapshot()
  if not okSnapshot then failActive(snapshot, true, "dna_tuning"); return end
  local values, issues = vehicleDNARestore.tuningValues(active.dnaEntry, snapshot.variables, active.dnaMode)
  active.dnaExpectedTuning = util.deepCopy(values)
  for _, issue in ipairs(issues) do
    issue.phase = issue.phase or "execution"
    addDNADeviation(active, issue)
  end
  if active.dnaMode == "exact" and #issues > 0 then
    failActive(adapter.errorValue("dna_tuning_incompatible", "Restore Exact tuning preconditions changed", {issues = issues}), true, "dna_tuning")
    return
  end
  if next(values) == nil then operationState.transition(runtime.state, "painting", false); startDNAPaint(active); return end
  local okWait, waitError = enterWaiting(active, "dna_tuning", "dna_paint", {
    vehicleId = active.vehicleId, modelKey = active.dnaEntry.final.modelKey, tuning = values,
  }, "Restoring Vehicle DNA tuning", 0.76)
  if not okWait then failActive(waitError, true, "dna_tuning"); return end
  bindMutationPlan(active, "dna_tuning")
  local guardOk, guardError = guardMutationWrite(active, "dna_tuning")
  if not guardOk then failActive(guardError, true, "dna_tuning"); return end
  local okApply, applyError = adapter.applyTuning(values)
  if not okApply then failActive(applyError, true, "dna_tuning"); return end
  noteSuccessfulWrite(active, "dna_tuning")
end

startDNAPaint = function(active)
  if active.recoveryOnly then guardMutationWrite(active, "dna_paint"); return end
  active.phase = "dna_paint"
  local saved = active.dnaEntry.final.paints or {}
  if #saved == 0 then validateDNAFinal(active); return end
  if not runtime.capabilities.scramblePaint then
    if active.dnaMode == "exact" then failActive(adapter.errorValue("dna_paint_capability_missing", "Restore Exact requires paint read/write capability"), true, "dna_paint"); return end
    addDNADeviation(active, {phase = "execution", reason = "paint_capability_missing"})
    validateDNAFinal(active)
    return
  end
  local okPaints, current = adapter.getPaints()
  if not okPaints then failActive(current, true, "dna_paint"); return end
  local payload = util.deepCopy(saved)
  if active.dnaMode == "exact" and #current ~= #saved then
    failActive(adapter.errorValue("dna_paint_layer_mismatch", "Restore Exact paint layer count changed", {expected = #saved, actual = #current}), true, "dna_paint")
    return
  elseif active.dnaMode == "compatible" and #payload > #current then
    while #payload > #current do table.remove(payload) end
    addDNADeviation(active, {phase = "execution", reason = "paint_layers_omitted", expected = #saved, actual = #current})
  end
  if #payload == 0 then validateDNAFinal(active); return end
  setLifecyclePhase(active, "applying_paint", false, "dna_paint_write")
  bindMutationPlan(active, "dna_paint")
  local guardOk, guardError = guardMutationWrite(active, "dna_paint")
  if not guardOk then failActive(guardError, true, "dna_paint"); return end
  local okApply, applyResult = adapter.applyPaints(payload)
  if not okApply then failActive(applyResult, true, "dna_paint"); return end
  noteSuccessfulWrite(active, "dna_paint")
  active.dnaExpectedPaints = payload
  if applyResult.confirmationRequired then
    operationState.transition(runtime.state, "waitingForReload", PAINT_CONFIRM_TIMEOUT)
    active.paintConfirmation = paintVerification.createDeferred(applyResult.expected, adapter.clock(), PAINT_CONFIRM_TIMEOUT, 0.1, 12)
    setLifecyclePhase(active, "verifying_paint", PAINT_CONFIRM_TIMEOUT, "dna_paint_readback")
    active.paintConfirmation.context = operationState.captureContext(
      runtime.state, active.operationCurrentTarget
    )
    setProgress("Confirming Vehicle DNA paint read-back", 0.91)
    return
  end
  validateDNAFinal(active)
end

validateDNAFinal = function(active)
  active.phase = "dna_validation"
  local transitioned, transitionError = operationState.transition(runtime.state, "validating", false)
  if not transitioned then
    failActive(adapter.errorValue("state_error", transitionError), true, "dna_validation")
    return
  end
  local safe, safetyOrError = validateFinalVehicle(active)
  if not safe then
    failActive(adapter.errorValue("dna_validation_failed", "Restored Vehicle DNA failed safety validation", {
      cause = safetyOrError,
    }), true, "dna_validation")
    return
  end
  active.dnaSafetyResult = util.deepCopy(safetyOrError)
  verifyDNAFinal(active)
end

local function continueCreativeFromParent(active, capture, scan)
  local lockReport = vehicleDNALocks.preflight(
    active.lockProfileSnapshot,
    active.dnaEntry.final.modelKey,
    capture.selectedConfiguration,
    scan
  )
  if not lockReport.valid then
    failActive(adapter.errorValue("creative_lock_unresolved", "Creative locks do not resolve on the parent final state", {
      lockReport = lockReport,
    }), true, "creative_lock_preflight")
    return
  end
  active.parentFinalState = util.deepCopy(capture)
  active.parentFinalRestored = true
  active.dnaMode = nil
  active.dnaAppliedParts = nil
  active.dnaExpectedTuning = nil
  active.dnaExpectedPaints = nil
  active.dnaPassBudget = nil
  active.pass = 1
  active.previousScan = nil
  active.deferredPaths = {}
  active.mutatedPaths = {}
  active.safetyBaseline = nil
  active.modelKey = active.dnaEntry.final.modelKey
  if active.allowModelChange then
    operationState.transition(runtime.state, "selecting", false)
    active.excludeModelKey = active.dnaEntry.final.modelKey
    local model, config, selectionError = chooseConfiguration(active)
    active.excludeModelKey = nil
    if not model then failActive(selectionError, true, "creative_selection"); return end
    active.selectedModel = model
    active.selectedConfig = config
    active.modelKey = model.key
    active.configIdentity = adapter.prepareConfigExpectation(config)
    operationState.transition(runtime.state, "spawning", false)
    local okWait, waitError = enterWaiting(active, "spawn", "creativeMutationSpawn", {
      modelKey = model.key,
      configIdentity = active.configIdentity,
    }, "Loading Wild mutation vehicle", 0.28)
    if not okWait then failActive(waitError, true, "creative_selection"); return end
    local okReplace, replaceError = issueReplacement(active, model.key, config.path or config.key, "spawn")
    if not okReplace then failActive(replaceError, true, "creative_selection"); return end
    return
  end
  operationState.transition(runtime.state, "scanning", false)
  processMutationPass(active)
end

verifyDNAFinal = function(active)
  active.phase = "dna_final_verification"
  setProgress("Verifying restored Vehicle DNA", 0.96)
  local okCapture, capture = adapter.captureCurrentState(active.kind, active.seed)
  if not okCapture then failActive(capture, true, "dna_final_verification"); return end
  local okSnapshot, snapshot = adapter.getCurrentSlotSnapshot()
  if not okSnapshot then failActive(snapshot, true, "dna_final_verification"); return end
  local scan, scanError = slotScanner.scan(snapshot.tree, snapshot.metadataByPath)
  if not scan then failActive(adapter.errorValue(scanError, "Vehicle DNA final verification scan failed"), true, "dna_final_verification"); return end
  local failures = {}
  for _, saved in ipairs(active.dnaEntry.final.slots or {}) do
    local current = vehicleDNACompatibility.resolveSlot(saved, scan, active.dnaEntry.final.modelKey)
    if active.dnaMode == "exact" then
      if not current or current.currentPart ~= saved.partName then failures[#failures + 1] = {path = saved.path, reason = "slot_readback_mismatch"} end
    elseif current then
      local available = saved.partName == "" or current.currentPart == saved.partName
      for _, candidate in ipairs(current.candidates or {}) do
        if candidate == saved.partName then available = true; break end
      end
      if available and current.currentPart ~= saved.partName then
        failures[#failures + 1] = {path = current.path, reason = "compatible_slot_readback_mismatch"}
      end
    end
  end
  local expectedTuning = active.dnaMode == "exact" and {} or active.dnaExpectedTuning
  if active.dnaMode == "exact" then
    for _, saved in ipairs(active.dnaEntry.final.tuning or {}) do expectedTuning[saved.name] = saved.value end
  end
  for name, expected in pairs(expectedTuning or {}) do
    local actual = tonumber(capture.tuning and capture.tuning[name])
    if not actual or math.abs(actual - expected) > 1e-8 then
      failures[#failures + 1] = {
        name = name,
        reason = "tuning_readback_mismatch",
        expected = expected,
        actual = actual,
      }
    end
  end
  if active.dnaMode == "compatible" and #(active.dnaExpectedPaints or {}) > 0 then
    local paintsMatch, paintReason = paintVerification.compare(active.dnaExpectedPaints, capture.paints or {})
    if not paintsMatch then failures[#failures + 1] = {reason = paintReason or "compatible_paint_readback_mismatch"} end
  end
  if active.dnaMode == "exact" then
    local paintsMatch, paintReason = paintVerification.compare(active.dnaEntry.final.paints or {}, capture.paints or {})
    if not paintsMatch or #(active.dnaEntry.final.paints or {}) ~= #(capture.paints or {}) then
      failures[#failures + 1] = {reason = paintReason or "paint_readback_mismatch"}
    end
    if #scan.slots ~= #(active.dnaEntry.final.slots or {}) then failures[#failures + 1] = {reason = "slot_topology_mismatch"} end
  end
  if #failures > 0 then
    failActive(adapter.errorValue("dna_final_verification_failed", "Restored Vehicle DNA diverged during final verification", {failures = failures}), true, "dna_final_verification")
    return
  end
  if active.creativeOperation == "mutation" or active.creativeOperation == "reroll_unlocked" then
    continueCreativeFromParent(active, capture, scan)
    return
  end
  local status = active.dnaMode == "exact" and "exact" or (#active.dnaDeviations > 0 and "partial" or "compatible")
  finishOperation(true, "dna_restore_" .. status, "Vehicle DNA restored: " .. status, {
    restoreStatus = status, dnaId = active.dnaEntry.id, deviations = util.deepCopy(active.dnaDeviations),
    exact = status == "exact", verified = true, safety = util.deepCopy(active.dnaSafetyResult),
  })
end

local function completeStableTarget(vehicleId, verificationState, verificationDetails)
  local active = runtime.active
  local elapsed = adapter.clock() - (active.wait.startedAt or adapter.clock())
  diagnosticsModule.write(runtime.diagnostics, "D", "vehicle_target_stable", {
    eventReceived = "stable_player_target",
    expectedEvent = active.wait.eventType,
    phase = active.wait.phase,
    stateVerified = true,
    verificationStrategy = verificationDetails and verificationDetails.strategy,
    identityConfirmed = verificationDetails and verificationDetails.identityConfirmed,
    elapsed = elapsed,
    lifecycle = active.lastTargetMetrics,
  }, true)

  local completedPhase = active.wait.phase
  local afterReload = active.afterReload
  local stableTarget = targetDescriptor(verificationState) or {
    vehicleId = vehicleId,
    modelKey = active.wait.modelKey,
    configKey = configVerification.stableKey(
      active.wait.configKey or (active.wait.configIdentity and active.wait.configIdentity.path)
    ),
  }
  stableTarget.vehicleId = vehicleId
  if active.recoveryOnly then active.operationRecoveryTarget = util.deepCopy(stableTarget)
  else active.operationCurrentTarget = util.deepCopy(stableTarget) end
  runtime.state.expectedTarget = util.deepCopy(stableTarget)
  noteProgress(active, "target", "target_identity_and_tree_confirmed")
  active.wait = nil
  active.waitContext = nil
  active.targetTracker = nil
  active.vehicleId = vehicleId
  runtime.state.vehicleId = vehicleId
  if completedPhase == "spawn" or completedPhase == "parts" or completedPhase == "tuning"
    or completedPhase == "undo" or completedPhase == "rollback" or completedPhase == "dna_base_spawn"
    or completedPhase == "dna_parts" or completedPhase == "dna_tuning" or completedPhase == "part_batch_rollback"
    or completedPhase == "part_isolation_test"
  then
    active.reloadCount = (active.reloadCount or 0) + 1
  end

  if completedPhase == "parts" or completedPhase == "part_isolation_test"
    or completedPhase == "part_batch_rollback" or completedPhase == "dna_parts"
  then
    setLifecyclePhase(active, "verifying_parts", false, "parts_reload_verified")
  elseif completedPhase == "tuning" or completedPhase == "dna_tuning" then
    setLifecyclePhase(active, "verifying_tuning", false, "tuning_reload_verified")
  end

  if completedPhase == "spawn" then
    active.baseConfirmed = true
    local baseOk, baseSnapshot = adapter.captureCurrentState(active.kind, active.seed)
    if baseOk then
      active.operationCandidateBase = util.deepCopy(baseSnapshot)
      vehicleRecovery.rememberReadable(runtime.recovery, baseSnapshot)
    end
    pushRecent(runtime.recentModels, active.selectedModel.key)
    pushRecent(runtime.recentConfigs, configSelector.identifier(active.selectedConfig))
    if afterReload == "randomConfig" then
      local message = "Loaded " .. tostring(active.selectedConfig.name)
      local warnings = {}
      if active.selectedModel.isProp then
        message = message .. "; prop control is not validated"
        warnings[#warnings + 1] = "The selected prop may not provide an active controllable vehicle."
      end
      local details = {
        seed = active.seed,
        model = active.selectedModel.key,
        configuration = active.selectedConfig.key,
        configurationName = active.selectedConfig.name,
        sourceKind = active.selectedConfig.sourceKind,
        sourceLabel = active.selectedConfig.sourceLabel,
        verifiedTraits = productionModules.lineupManager.verifiedTraits(active.selectedModel, active.selectedConfig),
        verificationStrategy = verificationDetails and verificationDetails.strategy,
        warnings = warnings,
      }
      operationState.transition(runtime.state, "validating", false)
      local dnaSafe, dnaSafety = validateFinalVehicle(active)
      details.safety = dnaSafe and util.deepCopy(dnaSafety) or nil
      local dnaReady, dnaOrError = false, dnaSafety
      if dnaSafe then dnaReady, dnaOrError = capturePendingDNA(active, details) end
      details.dnaReady = dnaReady
      if dnaReady then details.dnaId = dnaOrError.id else
        details.warnings[#details.warnings + 1] = "Vehicle DNA capture was unavailable because final validation or capture did not complete."
        diagnosticsModule.write(runtime.diagnostics, "W", "dna_capture_failed", dnaOrError, true)
      end
      finishOperation(true, "random_config_loaded", message, details)
    else
      operationState.transition(runtime.state, "scanning", false)
      active.pass = 1
      processMutationPass(active)
    end
  elseif completedPhase == "parts" then
    active.pass = active.pass + 1
    operationState.transition(runtime.state, "scanning", false)
    processMutationPass(active)
  elseif completedPhase == "part_isolation_test" then
    local successfulBatch = util.deepCopy(active.currentBatch or {})
    candidateIsolation.record(active.candidateIsolation, true)
    for _, decision in ipairs(successfulBatch) do
      active.changes[#active.changes + 1] = util.deepCopy(decision)
      active.mutatedPaths[decision.slotPath] = true
      local recorded, successDetails = contentIndex.recordSuccess(runtime.index, "part", {
        modelKey = active.modelKey or (active.selectedModel and active.selectedModel.key),
        slotPath = decision.slotPath, candidate = decision.selectedPart,
      }, os.time())
      if recorded then diagnosticsModule.write(runtime.diagnostics, "D", "part_candidate_isolated_success", successDetails) end
    end
    active.currentBatch = nil
    active.batchRecovery.currentBatch = nil
    operationState.transition(runtime.state, "scanning", false)
    applyNextIsolationBatch(active)
  elseif completedPhase == "part_batch_rollback" then
    partBatchRecovery.finishRollback(active.batchRecovery, true)
    for _, decision in ipairs(active.batchRollbackDecisions or {}) do
      active.mutatedPaths[decision.slotPath] = nil
      for index = #active.changes, 1, -1 do
        if active.changes[index].slotPath == decision.slotPath
          and active.changes[index].selectedPart == decision.selectedPart
        then
          table.remove(active.changes, index)
          break
        end
      end
    end
    active.batchRollbackDecisions = nil
    active.currentBatch = nil
    vehicleStabilizer.observeTreeIssue(active.treeStabilizer, nil)
    operationState.transition(runtime.state, "scanning", false)
    if active.candidateIsolation then
      applyNextIsolationBatch(active)
    else
      active.previousScan = nil
      active.pass = active.pass + 1
      processMutationPass(active)
    end
  elseif completedPhase == "tuning" then
    operationState.transition(runtime.state, "tuning", false)
    processTuningReadback(active)
  elseif completedPhase == "undo" then
    historyModule.pop(runtime.history)
    finishOperation(true, "undo_completed", "Previous vehicle state restored", {model = active.originalState.modelKey})
  elseif completedPhase == "rollback" then
    local originalFailure = active.rollbackFailure or failureRecord(active, "rollback", adapter.errorValue("operation_failed", "Operation failed"))
    historyTransaction.rollbackSucceeded(active, runtime.history, historyModule.pop)
    local readable, recoverySnapshot = adapter.captureCurrentState("recovery", active.seed)
    if readable then vehicleRecovery.rememberReadable(runtime.recovery, recoverySnapshot) end
    local recoveryStep = active.recoveryStep or "previous"
    finishOperation(false, originalFailure.code, originalFailure.message .. "; vehicle recovery completed", {
      rollback = "completed",
      recoveryStep = recoveryStep,
      locksRequireReview = recoveryStep ~= "previous",
      originalFailure = originalFailure,
    })
  elseif completedPhase == "dna_base_spawn" then
    active.baseConfirmed = true
    active.dnaPass = 1
    operationState.transition(runtime.state, "scanning", false)
    runDNATargetPreflight(active)
  elseif completedPhase == "dna_parts" then
    active.currentBatch = nil
    operationState.transition(runtime.state, "scanning", false)
    processDNAParts(active)
  elseif completedPhase == "dna_tuning" then
    operationState.transition(runtime.state, "painting", false)
    startDNAPaint(active)
  end
end

local function nominateSpawnDirectorCandidate(vehicleId, source, oldId)
  local run = runtime.spawnDirector.run
  local pending = run and run.active and run.pendingVerification
  if not pending or type(vehicleId) ~= "number" or vehicleId < 0 then return false end
  if source == "switch" and oldId ~= pending.vehicleId then return false end
  if vehicleId == pending.vehicleId then return true end
  pending.candidateIds = pending.candidateIds or {}
  pending.candidateSeen = pending.candidateSeen or {}
  local key = tostring(vehicleId)
  if pending.candidateSeen[key] then return true end
  if #pending.candidateIds >= 8 then return false end
  pending.candidateSeen[key] = true
  pending.candidateIds[#pending.candidateIds + 1] = vehicleId
  pending.lastCandidateSource = source
  return true
end

local function onVehicleSpawned(vehicleId)
  nominateSpawnDirectorCandidate(vehicleId, "spawn")
  if not runtime.state.busy or not runtime.active or not runtime.active.targetTracker then return end
  local active = runtime.active
  local accepted, reason = vehicleTargetTracker.onSpawned(active.targetTracker, vehicleId)
  if not accepted and reason == "stale_callback_ignored" then
    runtime.state.staleCallbackCount = runtime.state.staleCallbackCount + 1
    diagnosticsModule.write(runtime.diagnostics, "E",
      active.recoveryOnly and "recovery_target_received_stale_mutation" or "stale_callback_ignored", {
        source = "onVehicleSpawned",
        phase = active.phase,
        vehicleId = vehicleId,
        recoveryOnly = active.recoveryOnly == true,
        operationGeneration = runtime.state.operationGeneration,
        phaseGeneration = runtime.state.phaseGeneration,
        targetGeneration = runtime.state.targetGeneration,
      }, true)
    return
  end
  noteProgress(active, "target", "vehicle_spawn_callback")
  diagnosticsModule.write(runtime.diagnostics, "D", "vehicle_target_candidate", {
    source = "onVehicleSpawned",
    phase = active.phase,
    vehicleId = vehicleId,
    classification = reason,
  })
end

local function processTargetTracking()
  local active = runtime.active
  if not runtime.state.busy or not active or not active.wait or not active.targetTracker then return false end
  local now = runtime.time.realMonotonicTime
  if not vehicleStabilizer.shouldPoll(active.targetTracker.stabilizer, now) then return true end
  local waitingForSimulation = runtime.time.paused == true and runtime.time.simulationDelta <= 0
  if waitingForSimulation and not active.pauseWaitStartedAt then
    active.pauseWaitStartedAt = now
    active.resumeLifecyclePhase = runtime.state.phase
    setLifecyclePhase(active, "waiting_for_simulation_resume", false, "simulation_paused")
    active.targetTracker.phaseGeneration = runtime.state.phaseGeneration
    active.waitContext.phaseGeneration = runtime.state.phaseGeneration
    active.targetTracker.status = "waiting_for_simulation_resume"
    setProgress("Waiting for the simulation to resume so the vehicle can finish loading", runtime.progress.value)
  elseif not waitingForSimulation and active.pauseWaitStartedAt then
    local pausedDuration = math.max(0, now - active.pauseWaitStartedAt)
    active.targetTracker.deadline = active.targetTracker.deadline + pausedDuration
    local resumePhase = active.targetTracker.identityConfirmed
      and next(active.targetTracker.expectedParts or {}) and "stabilizing_tree"
      or "tracking_target_identity"
    setLifecyclePhase(active, resumePhase, active.waitTimeout or WAIT_TIMEOUT, "simulation_resumed")
    active.targetTracker.phaseGeneration = runtime.state.phaseGeneration
    active.waitContext.phaseGeneration = runtime.state.phaseGeneration
    active.pauseWaitStartedAt = nil
    active.resumeLifecyclePhase = nil
  end
  local okState, stateOrError = adapter.getVerificationState()
  local observed = okState and stateOrError or nil
  local context = util.deepCopy(active.waitContext or {})
  context.waitingForSimulation = waitingForSimulation
  local status, reason, details = vehicleTargetTracker.observe(active.targetTracker, active.token, observed, now, context)
  active.lastTargetMetrics = vehicleTargetTracker.summary(active.targetTracker, now)
  if active.lastTargetMetrics.identityConfirmed and active.lastTargetMetrics.treeStatus ~= "not_required"
    and not waitingForSimulation and runtime.state.phase ~= "stabilizing_tree"
  then
    setLifecyclePhase(active, "stabilizing_tree", active.waitTimeout or WAIT_TIMEOUT, "target_identity_confirmed")
    active.targetTracker.phaseGeneration = runtime.state.phaseGeneration
    active.waitContext.phaseGeneration = runtime.state.phaseGeneration
    noteProgress(active, "target", "target_identity_confirmed")
  end
  if status == "stable" then
    noteProgress(active, "tree", "target_tree_converged")
    completeStableTarget(details.vehicleId, details.state, details.verification)
    return true
  end
  if status == "cancelled" then
    cancelOperation("vehicle_switched", "Operation cancelled because the player selected an unrelated vehicle")
    return true
  end
  if status == "failed" then
    local phase = active.wait and active.wait.phase or active.phase or "lifecycle"
    if (phase == "parts" or phase == "part_isolation_test") and active.currentBatch then
      local recovering, recoveryReason = attemptPartBatchRollback(active, reason)
      if recovering then return true end
      diagnosticsModule.write(runtime.diagnostics, "E", "part_batch_recovery_exhausted", {
        reason = recoveryReason, lifecycle = active.lastTargetMetrics,
      }, true)
    end
    if phase == "rollback" then
      diagnosticsModule.write(runtime.diagnostics, "E", "vehicle_recovery_step_failed", {
        step = active.recoveryStep, reason = reason, lifecycle = active.lastTargetMetrics,
      }, true)
      startNextRecovery(active)
    else
      failActive(adapter.errorValue(reason, "The vehicle did not stabilize before timeout", {
        lifecycle = active.lastTargetMetrics,
        lastReadError = okState and nil or stateOrError,
      }), true, phase)
    end
    return true
  end
  if reason ~= active.lastTargetReason then
    active.lastTargetReason = reason
    diagnosticsModule.write(runtime.diagnostics, "D", "vehicle_target_stabilizing", {
      phase = active.phase,
      reason = reason,
      lifecycle = active.lastTargetMetrics,
      readError = okState and nil or stateOrError,
    })
  end
  return true
end

cancelOperation = function(code, message)
  if not runtime.state.busy then return end
  local active = runtime.active
  if active then
    setLifecyclePhase(active, "cancelling", false, code or "operation_cancelled")
    active.token = operationState.invalidate(runtime.state, code or "operation_cancelled", {
      operation = true, target = true,
    })
    active.operationGeneration = runtime.state.operationGeneration
    active.phaseGeneration = runtime.state.phaseGeneration
    active.targetGeneration = runtime.state.targetGeneration
    vehicleRecovery.cleanup(active)
  end
  local failure = failureRecord(runtime.active, "lifecycle", adapter.errorValue(code or "operation_cancelled", message or "Operation cancelled"))
  runtime.lastFailure = failure
  finishOperation(false, failure.code, failure.message, {failure = failure}, "cancelled")
end

local function cancelCurrentOperation()
  if not runtime.state.busy or not runtime.active then return false end
  local active = runtime.active
  local isDNA = type(active.kind) == "string" and active.kind:sub(1, 3) == "dna"
  local code = isDNA and "dna_partial_cancelled" or "operation_cancelled"
  local message = isDNA and "Vehicle DNA operation cancelled by the user" or "Operation cancelled by the user"
  if active.destructiveStarted then
    setLifecyclePhase(active, "cancelling", false, "user_cancel")
    active.token = operationState.invalidate(runtime.state, "user_cancel", {
      operation = true, target = true,
    })
    active.operationGeneration = runtime.state.operationGeneration
    active.phaseGeneration = runtime.state.phaseGeneration
    active.targetGeneration = runtime.state.targetGeneration
    failActive(adapter.errorValue(code, message), true, active.phase or "lifecycle", {requestedByUser = true})
  else
    cancelOperation(code, message)
  end
  return true
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
  if player == nil or player == 0 then nominateSpawnDirectorCandidate(newId, "switch", oldId) end
  if runtime.stress and runtime.stress.active and not runtime.state.busy
    and (player == nil or player == 0)
    and newId ~= runtime.stress.vehicleId
  then
    cancelDeveloperStressInternal("vehicle_changed")
    return
  end
  if not runtime.state.busy or not runtime.active then return end
  local active = runtime.active
  if active.targetTracker then
    local accepted, reason = vehicleTargetTracker.onSwitched(
      active.targetTracker, oldId, newId, player, active.replaceWriteInFlight == true
    )
    if not accepted and reason == "stale_callback_ignored" then
      runtime.state.staleCallbackCount = runtime.state.staleCallbackCount + 1
      diagnosticsModule.write(runtime.diagnostics, "E",
        active.recoveryOnly and "recovery_target_received_stale_mutation" or reason, {
          source = "onVehicleSwitched", oldId = oldId, newId = newId, player = player,
          recoveryOnly = active.recoveryOnly == true,
          operationGeneration = runtime.state.operationGeneration,
          phaseGeneration = runtime.state.phaseGeneration,
          targetGeneration = runtime.state.targetGeneration,
        }, true)
      return
    end
    noteProgress(active, "target", "vehicle_switch_callback")
    diagnosticsModule.write(runtime.diagnostics, "D", "vehicle_switch_observed", {
      phase = active.phase, oldId = oldId, newId = newId, player = player, classification = reason,
    })
    return
  end
  if (player == nil or player == 0) and newId ~= runtime.state.vehicleId then
    if runtime.stress and runtime.stress.active then
      cancelDeveloperStressInternal("vehicle_changed")
    else
      cancelOperation("vehicle_switched", "Operation cancelled because the active vehicle changed")
    end
  end
end

local function onVehicleDestroyed(vehicleId)
  local spawnPending = runtime.spawnDirector.run and runtime.spawnDirector.run.pendingVerification
  local expectedSpawnReplacement = spawnPending and spawnPending.vehicleId == vehicleId
  local managed, managedEntry = productionModules.managedRegistry.destroyed(runtime.managedVehicles, vehicleId)
  if managed and managedEntry and expectedSpawnReplacement then
    managedEntry.status = "loading"
    managedEntry.failureReason = "awaiting_replacement_candidate"
  elseif managed and managedEntry and runtime.lineup.current then
    for _, competitor in ipairs(runtime.lineup.current.competitors or {}) do
      if competitor.managedHandle == managedEntry.handle then competitor.raceStatus = "DNF"; break end
    end
  end
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
    if active.targetTracker then
      vehicleTargetTracker.onDestroyed(active.targetTracker, vehicleId)
      diagnosticsModule.write(runtime.diagnostics, "D", "vehicle_target_destroyed_observed", {
        phase = active.phase, vehicleId = vehicleId,
      })
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
  productionModules.destinationMarker.clear(runtime.destination)
  productionModules.routePlanner.clear(runtime.aiRoute)
  runtime.spawnDirector.preview = nil
  if runtime.spawnDirector.run then runtime.spawnDirector.run.active = false end
  production.controlManagedAI("reset")
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

function production.persistCurrentLineup()
  local current = runtime.lineup.current
  if not current then return false, "lineup_missing" end
  local valid, reason = productionModules.lineupSchema.validate(current, {allowOne = true})
  if not valid then return false, reason end
  local added, stored = productionModules.lineupStorage.add(runtime.lineup.library, current)
  if not added then return false, stored end
  if runtime.capabilities.lineupWrite and type(adapter.saveLineupLibrary) == "function" then
    local ok, writeError = adapter.saveLineupLibrary(runtime.lineup.library)
    if not ok then return false, writeError.code end
  end
  return true
end

function production.createChaosLineup(options)
  initialize()
  if runtime.state.busy or (runtime.lineup.current and runtime.lineup.current.active) then
    setResult(false, "lineup_busy", "A lineup or vehicle operation is already running"); publishState(); return false
  end
  local lineup, reason = productionModules.lineupManager.create(options)
  if not lineup then setResult(false, reason, "Chaos Lineup options are invalid"); publishState(); return false end
  runtime.lineup.current = lineup
  runtime.lineup.pendingNext = true
  local persisted, persistReason = production.persistCurrentLineup()
  if not persisted then
    lineup.active = false
    runtime.lineup.pendingNext = false
  end
  setResult(persisted, persisted and "lineup_started" or "lineup_storage_failed",
    persisted and "Chaos Lineup generation started" or "Chaos Lineup was created but its initial checkpoint could not be saved",
    {episodeSeed = lineup.episodeSeed, count = #lineup.competitors, storageReason = persistReason})
  publishState()
  return persisted
end

function production.startNextLineupCompetitor()
  if runtime.state.busy or not runtime.lineup.pendingNext or not runtime.lineup.current then return false end
  runtime.lineup.pendingNext = false
  local competitor = productionModules.lineupManager.nextCompetitor(runtime.lineup.current)
  if not competitor then
    local saved, reason = production.persistCurrentLineup()
    setResult(saved, saved and "lineup_ready" or "lineup_storage_failed", saved and "Chaos Lineup generation finished" or "Lineup finished but storage verification failed", {
      summary = productionModules.lineupManager.summary(runtime.lineup.current), reason = reason,
    })
    publishState()
    return false
  end
  local checkpointed, checkpointReason = production.persistCurrentLineup()
  if not checkpointed then
    competitor.status = "Failed"
    competitor.generationStatus = "Failed"
    competitor.warning = "Generation checkpoint failed; retry after storage is available"
    runtime.lineup.current.active = false
    runtime.lineup.pendingNext = false
    setResult(false, "lineup_storage_failed", "The competitor was not started because its generation checkpoint could not be saved", {
      index = competitor.index, reason = checkpointReason,
    })
    publishState()
    return false
  end
  local settings = util.deepCopy(runtime.settings)
  local attemptNumber = (competitor.attemptCount or 0) + 1
  settings.manualSeed = productionModules.lineupManager.domainSeed(
    runtime.lineup.current, competitor, "operation", attemptNumber
  ) or competitor.seed
  settings.allowPartialResult = runtime.lineup.current.acceptPartial == true
  if competitor.forceOfficialFallback then settings.contentFilter = "official" end
  if runtime.lineup.current.preset == "Maximum Chaos" then settings.chaos, settings.extremeTuning = 100, true
  elseif runtime.lineup.current.preset == "Mods Showcase" then settings.chaos, settings.contentFilter = 100, "mods"
  else settings.chaos = math.max(60, settings.chaos or 75) end
  applySettingsSnapshot(settings)
  local excludedModels, excludedConfigurations = {}, {}
  local acceptedCompetitors = {}
  local rules = runtime.lineup.current.varietyRules or {}
  for _, previous in ipairs(runtime.lineup.current.competitors or {}) do
    if previous.index < competitor.index and (previous.status == "Ready" or previous.status == "Ready with warnings" or previous.status == "Partial") then
      acceptedCompetitors[#acceptedCompetitors + 1] = util.deepCopy(previous)
      if rules.avoidDuplicateModels and previous.modelKey then excludedModels[#excludedModels + 1] = previous.modelKey end
      if rules.avoidDuplicateConfigurations and previous.modelKey and previous.configuration then
        excludedConfigurations[#excludedConfigurations + 1] = tostring(previous.modelKey) .. "/"
          .. tostring(configVerification.stableKey(previous.configuration) or previous.configuration)
      end
    end
  end
  local started = runActionInternal("fullRandom", {
    lineupExcludedModels = excludedModels,
    lineupExcludedConfigurations = excludedConfigurations,
    lineupRules = rules,
    lineupAcceptedCompetitors = acceptedCompetitors,
    safeOfficial = competitor.forceOfficialFallback == true,
  })
  if started and runtime.active then
    runtime.active.lineupIndex = competitor.index
    runtime.active.lineupSeed = runtime.lineup.current.episodeSeed
    runtime.active.lineupAttempt = attemptNumber
    runtime.active.lineupTargetGeneration = competitor.targetGeneration
    runtime.active.captureOperation = "fullRandom"
    competitor.forceOfficialFallback = nil
  else
    productionModules.lineupManager.record(
      runtime.lineup.current, competitor.index, runtime.lastResult, nil, competitor.targetGeneration
    )
    runtime.lineup.pendingNext = true
  end
  publishState()
  return started
end

function production.resolveLineupFailure(index, action)
  local lineup = runtime.lineup.current
  index = math.floor(tonumber(index) or -1)
  local ok, reason = productionModules.lineupManager.resolveFailure(lineup, index, action)
  if not ok then
    setResult(false, reason, "Lineup failure action was rejected")
    publishState()
    return false
  end
  runtime.lineup.pendingNext = lineup.active == true
  production.persistCurrentLineup()
  setResult(true, "lineup_failure_action_applied", "Lineup failure action applied", {index = index, action = action})
  publishState()
  return true
end

function production.renameLineupCompetitor(index, name)
  local lineup = runtime.lineup.current
  index = math.floor(tonumber(index) or -1)
  if not lineup or not lineup.competitors[index] or type(name) ~= "string" then return false end
  name = name:gsub("[%z\1-\31]", " "):gsub("^%s+", ""):gsub("%s+$", ""):sub(1, 80)
  if name == "" then return false end
  lineup.competitors[index].name = name
  lineup.updatedAt = os.time()
  local persisted, reason = production.persistCurrentLineup()
  if not persisted then
    setResult(false, "lineup_storage_failed", "The name changed in memory but could not be checkpointed", {reason = reason})
    publishState()
    return false
  end
  setResult(true, "lineup_competitor_renamed", "Competitor renamed without changing Vehicle DNA", {index = index})
  publishState()
  return true
end

function production.exportChaosLineup()
  if not runtime.lineup.current then return false end
  local copy = util.deepCopy(runtime.lineup.current)
  copy.active, copy.nextIndex, copy.acceptPartial, copy.acceptMetadataUncertain, copy.acceptPotentiallyUndrivable = nil, nil, nil, nil, nil
  for _, competitor in ipairs(copy.competitors or {}) do competitor.spawnConfig = nil end
  local valid, reason = productionModules.lineupSchema.validate(copy, {allowOne = true})
  if not valid then setResult(false, reason, "Lineup export validation failed"); publishState(); return false end
  local ok, result = adapter.exportLineup(copy)
  setResult(ok, ok and "lineup_exported" or result.code, ok and "Lineup exported as .lineup.json" or result.message, ok and result or nil)
  publishState()
  return ok
end

function production.importChaosLineup()
  local ok, value = adapter.importLineup()
  if not ok then setResult(false, value.code, value.message); publishState(); return false end
  local lineup, reason = productionModules.lineupSchema.sanitizedImport(value)
  if not lineup then setResult(false, reason, "Lineup import validation failed"); publishState(); return false end
  local compatibilityFailures = 0
  for _, competitor in ipairs(lineup.competitors or {}) do
    if competitor.dna then
      local report, reportError = localImportCompatibility(competitor.dna)
      if report then
        competitor.compatibility = {
          status = report.status,
          registryStatus = report.registryStatus,
          deviations = util.deepCopy(report.deviations or {}),
          recomputedLocally = true,
        }
      else
        compatibilityFailures = compatibilityFailures + 1
        competitor.compatibility = {
          status = "unavailable", reason = reportError and (reportError.code or reportError.message) or tostring(reportError),
          recomputedLocally = false,
        }
      end
    else
      competitor.compatibility = {status = "dna_missing", recomputedLocally = true}
    end
  end
  runtime.lineup.current = lineup
  runtime.lineup.current.active = false
  runtime.lineup.current.nextIndex = #lineup.competitors + 1
  production.persistCurrentLineup()
  setResult(true, "lineup_imported", "Lineup imported and local compatibility recomputed", {compatibilityFailures = compatibilityFailures})
  publishState()
  return true
end

function production.occupiedManagedPositions()
  local enumerated, all = productionModules.spawnAdapter.occupiedVehiclePositions()
  if enumerated then return all end
  local positions = {}
  for _, entry in ipairs(productionModules.managedRegistry.list(runtime.managedVehicles)) do
    if entry.status ~= "destroyed" then local ok, position = productionModules.spawnAdapter.objectPosition(entry.vehicleId); if ok then positions[#positions + 1] = position end end
  end
  return positions
end

function production.previewLineupSpawn(options)
  if runtime.state.busy then
    setResult(false, "operation_busy", "Spawn Director cannot start during a vehicle mutation operation"); publishState(); return false
  end
  if runtime.spawnDirector.run and runtime.spawnDirector.run.active then
    setResult(false, "spawn_director_busy", "Spawn Director is already running"); publishState(); return false
  end
  options = type(options) == "table" and util.deepCopy(options) or {}
  local lineup = runtime.lineup.current
  local competitors = {}
  if type(options.selectedDNAId) == "string" and options.selectedDNAId ~= "" then
    local dna = vehicleDNAStorage.find(runtime.dna.library, options.selectedDNAId)
    if dna then
      competitors[1] = {
        index = 1, id = "selected-dna:" .. dna.id, name = dna.name,
        status = "Ready", raceStatus = "Pending", dnaId = dna.id,
        dna = util.deepCopy(dna), modelKey = dna.final and dna.final.modelKey,
      }
    else
      setResult(false, "spawn_selected_dna_missing", "The selected Vehicle DNA is unavailable"); publishState(); return false
    end
  elseif lineup then
    for _, competitor in ipairs(lineup.competitors) do
      local accepted = competitor.status == "Ready" or competitor.status == "Ready with warnings"
        or (competitor.status == "Partial" and lineup.acceptPartial)
      local notAlreadyManaged = competitor.managedHandle == nil and competitor.raceStatus ~= "Loading"
      if accepted and (options.useNextLineupCompetitor == false or notAlreadyManaged) then
        competitors[#competitors + 1] = competitor
      end
    end
  else
    setResult(false, "lineup_missing", "Create or import a lineup, or choose a Vehicle DNA"); publishState(); return false
  end
  if #competitors == 0 then setResult(false, "lineup_no_spawnable_competitors", "No accepted competitors are ready to spawn"); publishState(); return false end
  options.count = math.min(#competitors, tonumber(options.count) or #competitors)
  if options.mode == "Custom point" or options.mode == "Custom" then
    options.customPoint = {
      x = tonumber(options.customPointX), y = tonumber(options.customPointY), z = tonumber(options.customPointZ),
    }
  end
  if options.headingMode == "destination" then
    options.destination = runtime.destination.active and runtime.destination.confirmed
      and util.deepCopy(runtime.destination.point) or nil
  else options.destination = nil end
  local okFrame, frame = productionModules.spawnAdapter.cameraFrame()
  if not okFrame then setResult(false, frame, "Camera-relative spawn frame is unavailable"); publishState(); return false end
  if options.headingMode == "player" then
    local okPlayer, playerForward = productionModules.spawnAdapter.playerForward()
    if okPlayer then frame.playerForward = playerForward end
  elseif options.headingMode == "road" then
    local okRoad, roadForward = productionModules.spawnAdapter.roadForward(frame.position)
    if okRoad then frame.roadForward = roadForward end
  end
  local plan, reason = productionModules.spawnDirector.plan(frame, options, productionModules.spawnAdapter.raycastGround, production.occupiedManagedPositions())
  if not plan then setResult(false, reason, "Spawn preview is unsafe: " .. tostring(reason)); publishState(); return false end
  plan.competitors = competitors
  runtime.spawnDirector.preview = plan
  setResult(true, "spawn_preview_ready", "Spawn preview is ready", {count = #plan.placements, mode = plan.options.mode})
  publishState()
  return true
end

function production.startLineupSpawn(options)
  if runtime.state.busy then
    setResult(false, "operation_busy", "Spawn Director cannot start during a vehicle mutation operation"); publishState(); return false
  end
  if runtime.spawnDirector.run and runtime.spawnDirector.run.active then
    setResult(false, "spawn_director_busy", "Spawn Director is already running"); publishState(); return false
  end
  if not runtime.spawnDirector.preview and not production.previewLineupSpawn(options) then return false end
  local plan = runtime.spawnDirector.preview
  if options and options.spawnAll == false then
    plan.placements = {plan.placements[1]}
    plan.competitors = {plan.competitors[1]}
  end
  plan.active, plan.cursor, plan.nextAt = true, 1, adapter.clock()
  runtime.spawnDirector.run = plan
  runtime.spawnDirector.preview = nil
  setResult(true, "spawn_director_started", "Spawn Director started sequential spawning")
  publishState()
  return true
end

function production.configForCompetitor(competitor)
  if type(competitor.spawnConfig) == "table" then return util.deepCopy(competitor.spawnConfig) end
  local dna = competitor.dna
  if type(dna) ~= "table" then return nil end
  local config = {partConfigFilename = dna.base and dna.base.configPath, parts = {}, vars = {}, paints = util.deepCopy(dna.final and dna.final.paints or {})}
  for _, slot in ipairs(dna.final and dna.final.slots or {}) do config.parts[slot.slotId] = slot.partName end
  for _, variable in ipairs(dna.final and dna.final.tuning or {}) do config.vars[variable.name] = variable.value end
  return config
end

local function verifyPendingSpawn(pending)
  local candidates, seen = {pending.vehicleId}, {[tostring(pending.vehicleId)] = true}
  for _, vehicleId in ipairs(pending.candidateIds or {}) do
    local key = tostring(vehicleId)
    if not seen[key] then candidates[#candidates + 1], seen[key] = vehicleId, true end
  end
  local waiting, lastReason = false, "spawn_readback_pending"
  for _, vehicleId in ipairs(candidates) do
    local verified, stateOrReason = productionModules.spawnAdapter.verifySpawnTarget(
      vehicleId, pending.modelKey, pending.config
    )
    if verified == true then
      if vehicleId ~= pending.vehicleId then
        local rebound, rebindReason = productionModules.managedRegistry.rebind(
          runtime.managedVehicles, pending.handle, pending.vehicleId, vehicleId, pending.targetGeneration
        )
        if not rebound then return false, rebindReason end
        pending.vehicleId = vehicleId
        pending.targetGeneration = runtime.managedVehicles.entries[pending.handle].targetGeneration
        pending.lastVerifiedState, pending.stableScans = nil, 0
      end
      return true, stateOrReason
    elseif verified == nil then
      waiting, lastReason = true, stateOrReason
    else lastReason = stateOrReason end
  end
  return waiting and nil or false, lastReason
end

function production.processSpawnDirector()
  local run = runtime.spawnDirector.run
  if not run or not run.active or adapter.clock() < run.nextAt then return false end
  if run.pendingVerification then
    local pending = run.pendingVerification
    local verified, stateOrReason = verifyPendingSpawn(pending)
    if verified == true then
      if pending.lastVerifiedState and util.deepEqual(pending.lastVerifiedState, stateOrReason, 1e-8) then
        pending.stableScans = (pending.stableScans or 1) + 1
      else
        pending.lastVerifiedState = util.deepCopy(stateOrReason)
        pending.stableScans = 1
      end
      if pending.stableScans < 2 then
        pending.lastReason = "spawn_readback_stabilizing"
        run.nextAt = adapter.clock() + 0.1
        return true
      end
      productionModules.managedRegistry.setPending(runtime.managedVehicles, pending.handle, {
        writes = 0, timers = 0, callbacks = 0,
      })
      productionModules.managedRegistry.updateState(
        runtime.managedVehicles, pending.handle, pending.targetGeneration, stateOrReason
      )
      local ready, readyReason = productionModules.managedRegistry.markReady(
        runtime.managedVehicles, pending.handle, pending.targetGeneration, {
          busy = false, targetConfirmed = true, validated = true,
        }
      )
      if ready then
        run.spawned[#run.spawned + 1] = pending.handle
        pending.competitor.raceStatus = "Ready"
        pending.competitor.managedHandle = pending.handle
      else
        run.failures[#run.failures + 1] = {index = pending.competitor.index, reason = readyReason}
      end
      run.pendingVerification = nil
      run.cursor = run.cursor + 1
      run.nextAt = adapter.clock() + run.options.interval
      production.persistCurrentLineup()
      publishState()
      return true
    end
    if verified == false or adapter.clock() >= pending.deadline then
      local entry = runtime.managedVehicles.entries[pending.handle]
      if entry then entry.status = "failed"; entry.failureReason = stateOrReason end
      run.failures[#run.failures + 1] = {
        index = pending.competitor.index,
        reason = verified == false and stateOrReason or "spawn_readback_timeout",
      }
      pending.competitor.raceStatus = "DNS"
      run.pendingVerification = nil
      run.cursor = run.cursor + 1
      run.nextAt = adapter.clock() + run.options.interval
      production.persistCurrentLineup()
      publishState()
      return true
    end
    pending.lastReason = stateOrReason
    run.nextAt = adapter.clock() + 0.1
    return true
  end
  local placement, competitor = run.placements[run.cursor], run.competitors[run.cursor]
  if not placement or not competitor then
    run.active = false
    runtime.spawnDirector.lastResult = {success = #run.failures == 0, spawned = #run.spawned, failed = #run.failures}
    production.persistCurrentLineup()
    publishState()
    return false
  end
  local config = production.configForCompetitor(competitor)
  local modelKey = competitor.modelKey or competitor.dna and competitor.dna.final and competitor.dna.final.modelKey
  local ok, vehicleId
  if config and modelKey then ok, vehicleId = productionModules.spawnAdapter.spawnVehicle(modelKey, config, placement)
  else ok, vehicleId = false, "spawn_config_unavailable" end
  if ok then
    local entry, reason = productionModules.managedRegistry.register(runtime.managedVehicles, vehicleId, {
      competitorId = competitor.id,
      lineupId = runtime.lineup.current and runtime.lineup.current.id,
      name = competitor.name,
      lineupCompetitorId = competitor.id,
      dnaId = competitor.dnaId,
      modelKey = modelKey,
      configIdentity = {modelKey = modelKey, configPath = config.partConfigFilename},
      spawnTransform = util.deepCopy(placement),
      lastKnownState = {vehicleId = vehicleId, modelKey = modelKey},
      config = util.deepCopy(config),
      targetConfirmed = false,
      validated = false,
    })
    if entry then
      productionModules.managedRegistry.setPending(runtime.managedVehicles, entry.handle, {
        writes = 0, timers = 1, callbacks = 1,
      })
      run.pendingVerification = {
        handle = entry.handle,
        targetGeneration = entry.targetGeneration,
        vehicleId = vehicleId,
        modelKey = modelKey,
        config = util.deepCopy(config),
        competitor = competitor,
        startedAt = adapter.clock(),
        deadline = adapter.clock() + WAIT_TIMEOUT,
        candidateIds = {}, candidateSeen = {}, stableScans = 0,
      }
      run.nextAt = adapter.clock() + 0.1
      competitor.raceStatus, competitor.managedHandle = "Pending", entry.handle
      publishState()
      return true
    else run.failures[#run.failures + 1] = {index = competitor.index, reason = reason} end
  else
    run.failures[#run.failures + 1] = {index = competitor.index, reason = vehicleId}
    competitor.raceStatus = "DNS"
  end
  run.cursor = run.cursor + 1
  run.nextAt = adapter.clock() + run.options.interval
  publishState()
  return true
end

function production.cancelLineupSpawn()
  runtime.spawnDirector.preview = nil
  local run = runtime.spawnDirector.run
  if run then
    run.active = false
    if run.pendingVerification then
      local entry = runtime.managedVehicles.entries[run.pendingVerification.handle]
      if entry and entry.status == "loading" then
        entry.status = "failed"
        entry.failureReason = "spawn_verification_cancelled"
        productionModules.managedRegistry.setPending(runtime.managedVehicles, entry.handle, {
          writes = 0, timers = 0, callbacks = 0,
        })
      end
      if run.pendingVerification.competitor then run.pendingVerification.competitor.raceStatus = "DNS" end
      run.pendingVerification = nil
    end
  end
  production.persistCurrentLineup()
  setResult(true, "spawn_director_cancelled", "Spawn Director stopped; existing vehicles were preserved")
  publishState()
  return true
end

function production.removeManagedVehicle(handle)
  if runtime.state.busy then
    setResult(false, "operation_busy", "Managed vehicles cannot be removed during a vehicle mutation operation"); publishState(); return false
  end
  local entry = runtime.managedVehicles.entries[handle]
  if not entry then return false end
  productionModules.aiAdapter.stop(entry.vehicleId, true)
  local deleted, reason = productionModules.spawnAdapter.deleteVehicle(entry.vehicleId)
  if not deleted and reason ~= "vehicle_missing" then
    setResult(false, reason, "Managed vehicle could not be removed"); publishState(); return false
  end
  productionModules.managedRegistry.remove(runtime.managedVehicles, handle)
  if runtime.lineup.current then
    for _, competitor in ipairs(runtime.lineup.current.competitors or {}) do
      if competitor.managedHandle == handle then
        competitor.managedHandle, competitor.raceStatus = nil, "Pending"
        break
      end
    end
  end
  setResult(true, "managed_vehicle_removed", "Managed vehicle removed", {handle = handle})
  publishState()
  return true
end

function production.respawnManagedVehicle(handle)
  if runtime.state.busy then
    setResult(false, "operation_busy", "Managed vehicles cannot respawn during a vehicle mutation operation"); publishState(); return false
  end
  local entry = runtime.managedVehicles.entries[handle]
  if not entry then return false end
  local modelKey = entry.modelKey or entry.metadata and entry.metadata.modelKey
  local config = entry.metadata and entry.metadata.config
  local placement = entry.spawnTransform or entry.metadata and entry.metadata.spawnTransform
  if not modelKey or type(config) ~= "table" or type(placement) ~= "table" then
    setResult(false, "managed_respawn_state_missing", "Managed vehicle has no verified spawn state"); publishState(); return false
  end
  local oldId = entry.vehicleId
  local generation = productionModules.managedRegistry.beginGeneration(runtime.managedVehicles, handle, "respawn")
  local spawned, newId = productionModules.spawnAdapter.spawnVehicle(modelKey, config, placement)
  if not spawned then
    entry.status, entry.failureReason = "destroyed", newId
    setResult(false, newId, "Managed vehicle respawn failed"); publishState(); return false
  end
  local rebound, reason = productionModules.managedRegistry.respawn(
    runtime.managedVehicles, handle, oldId, newId, generation
  )
  if not rebound then
    productionModules.spawnAdapter.deleteVehicle(newId)
    setResult(false, reason, "Managed vehicle respawn callback was stale"); publishState(); return false
  end
  productionModules.managedRegistry.setPending(runtime.managedVehicles, handle, {timers = 1, callbacks = 1})
  local competitor = {index = 0, id = entry.lineupCompetitorId, name = entry.metadata and entry.metadata.name or handle}
  if runtime.lineup.current then
    for _, candidate in ipairs(runtime.lineup.current.competitors or {}) do
      if candidate.id == entry.lineupCompetitorId then competitor = candidate; break end
    end
  end
  runtime.spawnDirector.run = {
    active = true, options = {interval = 0.75}, placements = {}, competitors = {}, cursor = 1,
    nextAt = adapter.clock() + 0.1, spawned = {}, failures = {},
    pendingVerification = {
      handle = handle, targetGeneration = entry.targetGeneration,
      vehicleId = newId, modelKey = modelKey, config = util.deepCopy(config),
      competitor = competitor, startedAt = adapter.clock(), deadline = adapter.clock() + WAIT_TIMEOUT,
      candidateIds = {}, candidateSeen = {}, stableScans = 0,
    },
  }
  setResult(true, "managed_vehicle_respawning", "Managed vehicle respawn is awaiting read-back", {handle = handle, vehicleId = newId})
  publishState()
  return true
end

function production.placeAIDestination()
  local ok, result = productionModules.destinationMarker.placeFromCamera(runtime.destination, 2000)
  if ok then productionModules.destinationMarker.snapToNavGraph(runtime.destination, productionModules.aiAdapter) end
  setResult(ok, ok and "ai_destination_preview" or result, ok and "AI destination preview placed; confirm exact or NavGraph-snapped point" or "AI destination could not be placed")
  publishState()
  return ok
end

function production.confirmAIDestination(mode)
  local ok, result = productionModules.destinationMarker.confirm(runtime.destination, mode)
  setResult(ok, ok and "ai_destination_confirmed" or result,
    ok and "AI destination confirmed" or "AI destination confirmation failed")
  publishState()
  return ok
end

function production.clearAIDestination()
  productionModules.destinationMarker.clear(runtime.destination); publishState(); return true
end

function production.addAIRoutePoint()
  local ok, result = productionModules.destinationMarker.placeFromCamera(runtime.destination, 2000)
  if not ok then setResult(false, result, "Route point could not be placed"); publishState(); return false end
  local added, reason = productionModules.routePlanner.addPoint(runtime.aiRoute, result)
  if not added then setResult(false, reason, "Route point was rejected"); publishState(); return false end
  setResult(true, "ai_route_point_added", "Route point added", {count = #runtime.aiRoute.points})
  publishState()
  return true
end

function production.editAIRoute(action)
  local methods = {
    remove = productionModules.routePlanner.removeLast,
    clear = productionModules.routePlanner.clear,
    reverse = productionModules.routePlanner.reverse,
  }
  local method = methods[action]
  if not method then return false end
  local ok, reason = method(runtime.aiRoute)
  setResult(ok, ok and "ai_route_updated" or reason, ok and "AI route updated" or "AI route could not be updated", {action = action})
  publishState()
  return ok
end

function production.startManagedAI(options)
  options = type(options) == "table" and util.deepCopy(options) or {}
  local mode = options.mode or "Destination"
  local capabilities = productionModules.aiAdapter.capabilities()
  if capabilities[mode] ~= true then
    local reason = (mode == "Destination" or mode == "Route") and capabilities.navgraphReason
      or (mode == "Recorded" and capabilities.recordedReason) or capabilities.scriptedReason
    setResult(false, "ai_mode_unavailable", reason or "AI mode unavailable in this build")
    publishState()
    return false
  end
  local selected = type(options.handles) == "table" and options.handles or runtime.managedVehicles.order
  local started, failures = 0, {}
  for order, handle in ipairs(selected) do
    local managed, managedReason = productionModules.managedRegistry.readyEntry(runtime.managedVehicles, handle)
    if managed then
      local currentOptions = util.deepCopy(options)
      currentOptions.targetGeneration = managed.targetGeneration
      currentOptions.delay = (tonumber(options.delay) or 0) + (order - 1) * (tonumber(options.stagger) or 0)
      if mode == "Destination" then
        local okPos, origin = productionModules.spawnAdapter.objectPosition(managed.vehicleId)
        if okPos and runtime.destination.active and runtime.destination.confirmed then
          local route, reason = productionModules.routePlanner.destinationRoute(productionModules.aiAdapter, origin, runtime.destination.point, coverageLimits.DEFAULTS.maxAIRouteNodes)
          if route then currentOptions.nodes, currentOptions.destination, currentOptions.nodesArePath = route.nodes, util.deepCopy(runtime.destination.point), true
          else failures[#failures + 1] = {handle = handle, reason = reason} end
        else failures[#failures + 1] = {handle = handle, reason = "ai_destination_missing"} end
      elseif mode == "Route" then
        local okPos, origin = productionModules.spawnAdapter.objectPosition(managed.vehicleId)
        local route, reason
        if okPos then
          route, reason = productionModules.routePlanner.routeThrough(
            productionModules.aiAdapter, origin, runtime.aiRoute.points,
            coverageLimits.DEFAULTS.maxAIRouteNodes, options.loop == true
          )
        else reason = "vehicle_position_unavailable" end
        if route then
          currentOptions.nodes, currentOptions.destination, currentOptions.nodesArePath = route.nodes, route.destination, true
        else failures[#failures + 1] = {handle = handle, reason = reason or "route_points_missing"} end
      elseif mode == "Chase" or mode == "Follow" then
        local targetId = math.floor(tonumber(options.targetVehicleId) or -1)
        local targetOk, targetReason = productionModules.aiAdapter.targetExists(targetId)
        if not targetOk or targetId == managed.vehicleId then
          failures[#failures + 1] = {handle = handle, reason = targetReason or "ai_target_invalid"}
          currentOptions.targetVehicleId = nil
        else currentOptions.targetVehicleId = targetId end
      end
      local routeReady = (mode ~= "Destination" and mode ~= "Route") or currentOptions.nodes
      local targetReady = (mode ~= "Chase" and mode ~= "Follow") or currentOptions.targetVehicleId
      if routeReady and targetReady then
        local entry, reason = productionModules.aiDirector.assign(runtime.aiDirector, handle, managed.vehicleId, mode, currentOptions, adapter.clock())
        if entry then
          productionModules.managedRegistry.setAIState(runtime.managedVehicles, handle, managed.targetGeneration, {status = "scheduled", mode = mode})
          started = started + 1
        else failures[#failures + 1] = {handle = handle, reason = reason} end
      end
    else failures[#failures + 1] = {handle = handle, reason = managedReason} end
  end
  setResult(started > 0, started > 0 and "ai_director_scheduled" or "ai_director_failed", started > 0 and "AI Director scheduled managed vehicles" or "No managed vehicle could be scheduled", {started = started, failures = failures})
  publishState()
  return started > 0
end

function production.controlManagedAI(action)
  local affected, controlReason = productionModules.aiDirector.controlAll(
    runtime.aiDirector, action, adapter.clock(),
    function(vehicleId, disable) return productionModules.aiAdapter.stop(vehicleId, disable) end
  )
  if controlReason then
    setResult(false, controlReason, "AI Director control was rejected"); publishState(); return false
  end
  for _, handle in ipairs(runtime.aiDirector.order) do
    local entry = runtime.aiDirector.entries[handle]
    if entry then
      local managed = runtime.managedVehicles.entries[handle]
      if managed then productionModules.managedRegistry.setAIState(runtime.managedVehicles, handle, managed.targetGeneration, {status = entry.status, reason = entry.reason, mode = entry.mode}) end
    end
  end
  if action == "stop" or action == "reset" then productionModules.destinationMarker.clear(runtime.destination) end
  if action == "reset" then productionModules.routePlanner.clear(runtime.aiRoute) end
  if affected == 0 then return true end
  setResult(true, "ai_" .. action, "AI Director " .. action .. " applied", {affected = affected})
  publishState()
  return true
end

function production.setAIRecording(handle, enabled)
  local managed = runtime.managedVehicles.entries[handle]
  if not managed then return false end
  local ok, reason = productionModules.aiAdapter.recording(managed.vehicleId, enabled == true)
  setResult(ok, ok and "ai_recording_updated" or reason, ok and (enabled and "AI recording started" or "AI recording stopped") or "AI recording command failed")
  publishState()
  return ok
end

function production.processAIDirector()
  local now = adapter.clock()
  if now < (runtime.aiDirector.nextPollAt or 0) then return false end
  runtime.aiDirector.nextPollAt = now + 0.2
  for _, handle in ipairs(runtime.aiDirector.order) do
    local entry = runtime.aiDirector.entries[handle]
    if entry and entry.status == "scheduled" and now >= entry.startAt then
      local managed, managedReason = productionModules.managedRegistry.readyEntry(
        runtime.managedVehicles, handle, entry.targetGeneration
      )
      local ok, reason = false, managedReason
      if managed then ok, reason = productionModules.aiAdapter.start(entry.vehicleId, entry.mode, entry.options) end
      productionModules.aiDirector.setStatus(runtime.aiDirector, handle, ok and "running" or "failed", reason)
      entry.startedAt, entry.lastProgressAt = now, now
    elseif entry and entry.status == "running" then
      local managed, managedReason = productionModules.managedRegistry.readyEntry(
        runtime.managedVehicles, handle, entry.targetGeneration
      )
      local okPos, position = productionModules.spawnAdapter.objectPosition(entry.vehicleId)
      local okSpeed, speed = productionModules.spawnAdapter.objectSpeed(entry.vehicleId)
      local targetMissing = false
      if (entry.mode == "Chase" or entry.mode == "Follow") and entry.options.targetVehicleId then
        targetMissing = not productionModules.aiAdapter.targetExists(entry.options.targetVehicleId)
      end
      local distance
      if okPos and entry.options.destination then
        local dx, dy, dz = position.x - entry.options.destination.x, position.y - entry.options.destination.y, position.z - entry.options.destination.z
        distance = math.sqrt(dx * dx + dy * dy + dz * dz)
      end
      local event, reason = productionModules.aiDirector.observe(runtime.aiDirector, handle, {
        vehicleMissing = managed == nil or not okPos,
        targetMissing = targetMissing,
        distance = distance,
        speed = okSpeed and speed or nil,
        finalPointReached = true,
      }, now)
      if event == "arrived" then
        if entry.finishAction == "disable" then productionModules.aiAdapter.stop(entry.vehicleId, true)
        elseif entry.finishAction ~= "keep" and entry.finishAction ~= "loop" then productionModules.aiAdapter.stop(entry.vehicleId, false) end
        productionModules.aiDirector.setStatus(runtime.aiDirector, handle, "arrived", reason)
      elseif event == "timeout" or event == "stopped" then
        productionModules.aiAdapter.stop(entry.vehicleId, false)
        productionModules.aiDirector.setStatus(runtime.aiDirector, handle, event, reason or managedReason)
      elseif event == "stuck" then
        local action = reason
        local recovered = false
        if action == "replan" and (entry.mode == "Destination" or entry.mode == "Route")
          and okPos and entry.options.destination
        then
          local allowed = productionModules.aiDirector.requestReplan(runtime.aiDirector, handle)
          if allowed then
            local route = productionModules.routePlanner.destinationRoute(
              productionModules.aiAdapter, position, entry.options.destination,
              coverageLimits.DEFAULTS.maxAIRouteNodes
            )
            if route then
              entry.options.nodes = route.nodes
              recovered = productionModules.aiAdapter.start(entry.vehicleId, entry.mode, entry.options) == true
            end
          end
        elseif action == "reset" then
          productionModules.aiAdapter.stop(entry.vehicleId, true)
          entry.startAt = now + 0.25
          productionModules.aiDirector.setStatus(runtime.aiDirector, handle, "scheduled", "stuck_reset")
          recovered = true
        elseif action == "respawn" then
          recovered = production.respawnManagedVehicle(handle) == true
        elseif action == "dnf" then
          productionModules.aiAdapter.stop(entry.vehicleId, false)
          productionModules.aiDirector.setStatus(runtime.aiDirector, handle, "dnf", "stuck_dnf")
          if runtime.lineup.current then
            for _, competitor in ipairs(runtime.lineup.current.competitors or {}) do
              if competitor.managedHandle == handle then competitor.raceStatus = "DNF"; break end
            end
          end
          recovered = true
        elseif action == "none" then
          productionModules.aiDirector.log(runtime.aiDirector, "ai_stuck_observed", {handle = handle, action = "none"})
          recovered = true
        end
        if recovered and entry.status == "running" then
          productionModules.aiDirector.log(runtime.aiDirector, "ai_stuck_recovery", {handle = handle, action = action, replans = entry.replanCount})
        elseif not recovered and entry.status == "running" then
          productionModules.aiDirector.setStatus(runtime.aiDirector, handle, "stuck", action or "stuck_timeout")
        end
      end
    end
    local managed = runtime.managedVehicles.entries[handle]
    if entry and managed then
      productionModules.managedRegistry.setAIState(runtime.managedVehicles, handle, managed.targetGeneration, {
        status = entry.status, reason = entry.reason, mode = entry.mode,
        distance = entry.distanceToDestination, replans = entry.replanCount,
      })
    end
  end
  return true
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
  local now = runtime.time.realMonotonicTime
  if active.recoveryOnly then
    active.paintConfirmation = nil
    guardMutationWrite(active, "paint_confirmation")
    return true
  end
  local okObserved, observed = adapter.getVerificationState()
  local validContext, contextReason = operationState.validateContinuation(
    runtime.state, confirmation.context or {}, okObserved and targetDescriptor(observed) or nil
  )
  if not validContext then
    active.paintConfirmation = nil
    diagnosticsModule.write(runtime.diagnostics, "E", contextReason, {
      source = "paint_confirmation",
      recoveryOnly = active.recoveryOnly == true,
    }, true)
    return true
  end
  if runtime.time.paused and runtime.time.simulationDelta <= 0 then
    if not confirmation.pauseStartedAt then
      confirmation.pauseStartedAt = now
      setLifecyclePhase(active, "waiting_for_simulation_resume", false, "paint_waiting_for_simulation")
      confirmation.context = operationState.captureContext(runtime.state, active.operationCurrentTarget)
      setProgress("Waiting for the simulation to resume so the vehicle can finish loading", runtime.progress.value)
    end
    return true
  elseif confirmation.pauseStartedAt then
    local pauseDuration = math.max(0, now - confirmation.pauseStartedAt)
    confirmation.deadline = confirmation.deadline + pauseDuration
    confirmation.nextCheckAt = now
    confirmation.pauseStartedAt = nil
    setLifecyclePhase(active, "verifying_paint", PAINT_CONFIRM_TIMEOUT, "paint_simulation_resumed")
    confirmation.context = operationState.captureContext(runtime.state, active.operationCurrentTarget)
  end
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
      local okPaints, paints = adapter.getPaints()
      if okPaints and active.paintLedger then paintCoverageLedger.readBack(active.paintLedger, paints) end
      if active.kind == "dnaRestoreExact" or active.kind == "dnaRestoreCompatible" then
        validateDNAFinal(active)
      else
        completeChaos(active)
      end
      return true
    end
  end
  if paintVerification.expired(confirmation, now) then
    active.paintConfirmation = nil
    local isDNA = active.kind == "dnaRestoreExact" or active.kind == "dnaRestoreCompatible"
    failActive(adapter.errorValue(isDNA and "dna_paint_apply_unconfirmed" or "paint_apply_unconfirmed", "Paint write was not confirmed within the bounded read-back window", {
      strategy = confirmation.strategy,
      attempts = confirmation.attempts,
      elapsed = now - confirmation.startedAt,
    }), true, isDNA and "dna_paint" or "paint")
    return true
  end
  return true
end

local function onUpdate(dtReal, dtSim, dtRaw)
  local pauseKnown, paused = false, nil
  if type(adapter.getPauseState) == "function" then
    local okPause, pauseValue = adapter.getPauseState()
    if okPause then pauseKnown, paused = true, pauseValue end
  end
  timeSource.sample(runtime.time, dtReal, dtSim, dtRaw, pauseKnown and paused or nil, adapter.clock())
  local activeAtFrameStart = runtime.active
  if activeAtFrameStart and activeAtFrameStart.progressWatchdog then
    progressWatchdog.observePause(
      activeAtFrameStart.progressWatchdog, runtime.time.paused, runtime.time.realMonotonicTime
    )
  end

  if runtime.spawnDirector.preview then productionModules.spawnAdapter.drawPreview(runtime.spawnDirector.preview.placements) end
  productionModules.destinationMarker.draw(runtime.destination)
  if runtime.stress and runtime.stress.active
    and adapter.clock() - runtime.stress.startedAt >= runtime.stress.options.maxDuration
  then
    cancelDeveloperStressInternal("duration_limit")
  end

  local phaseWorkHandled = processTargetTracking()
  if not phaseWorkHandled then phaseWorkHandled = processPaintConfirmation() end
  if not phaseWorkHandled and runtime.state.busy and runtime.active and runtime.active.treeRescanAt
    and adapter.clock() >= runtime.active.treeRescanAt
  then
    local treeActive = runtime.active
    local contextOk, contextReason = operationState.validateContinuation(
      runtime.state, treeActive.treeRescanContext or {},
      treeActive.operationCurrentTarget
    )
    treeActive.treeRescanAt = nil
    treeActive.treeRescanContext = nil
    if contextOk then
      setLifecyclePhase(treeActive, "rescanning_tree", false, "tree_rescan_timer")
      processMutationPass(treeActive)
    else
      diagnosticsModule.write(runtime.diagnostics, "W", contextReason, {
        source = "tree_rescan_timer",
      }, true)
    end
    phaseWorkHandled = true
  end

  -- Housekeeping must run even while a lifecycle phase is waiting.
  production.processSpawnDirector()
  production.processAIDirector()

  local waitingForSimulation = runtime.state.phase == "waiting_for_simulation_resume"
  local watchdogState
  if runtime.active and runtime.active.progressWatchdog then
    watchdogState = progressWatchdog.evaluate(
      runtime.active.progressWatchdog, runtime.time.realMonotonicTime, waitingForSimulation
    )
    if watchdogState ~= runtime.active.lastWatchdogState then
      runtime.active.lastWatchdogState = watchdogState
      diagnosticsModule.write(runtime.diagnostics,
        watchdogState == "stalled" and "W" or "D", "operation_watchdog", {
          state = watchdogState,
          lifecyclePhase = runtime.state.phase,
          clocks = timeSource.snapshot(runtime.time),
          watchdog = progressWatchdog.snapshot(
            runtime.active.progressWatchdog, runtime.time.realMonotonicTime
          ),
        }, watchdogState == "stalled")
    end
    if runtime.active.progressWatchdog.pauseDependentProgressDetected
      and not runtime.active.pauseDependencyReported
    then
      runtime.active.pauseDependencyReported = true
      diagnosticsModule.write(runtime.diagnostics, "E", "pause_dependent_progress_detected", {
        lifecyclePhase = runtime.state.phase,
        clocks = timeSource.snapshot(runtime.time),
      }, true)
    end
  end

  if runtime.state.busy and not waitingForSimulation and operationState.isExpired(
    runtime.state, runtime.time.realMonotonicTime
  ) then
    local active = runtime.active
    local phase = active and active.wait and active.wait.phase or active and active.phase or "lifecycle"
    if phase == "rollback" then
      finishOperation(false, "rollback_timeout", "Rollback vehicle reload timed out", {rollback = "timeout"})
    else
      failActive(adapter.errorValue(phase .. "_reload_timeout", "Operation timed out while " .. tostring(
        active and active.wait and active.wait.reason or phase
      )), true, phase)
    end
  end

  startStressIteration()
  production.startNextLineupCompetitor()
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
M.updateLockProfile = updateLockProfile
M.getVehicleDNALocks = getVehicleDNALocks
M.lockVehicle = lockVehicle
M.lockConfiguration = lockConfiguration
M.lockCategory = lockCategory
M.lockSlot = lockSlot
M.unlockSlot = unlockSlot
M.lockPart = lockPart
M.lockCurrentParts = lockCurrentParts
M.lockTuning = lockTuning
M.lockPaint = lockPaint
M.applyLockPreset = applyLockPreset
M.rerollUnlocked = rerollUnlocked
M.requestState = requestState
M.setUICompactMode = setUICompactMode
M.copyDiagnostics = copyDiagnostics
M.spawnSafeVehicle = spawnSafeVehicle
M.retryQuarantinedConfigurations = retryQuarantinedConfigurations
M.runDeveloperStress = runDeveloperStress
M.cancelDeveloperStress = cancelDeveloperStress
M.cancelCurrentOperation = cancelCurrentOperation
M.getDeveloperStressState = getDeveloperStressState
M.createChaosLineup = production.createChaosLineup
M.renameLineupCompetitor = production.renameLineupCompetitor
M.resolveLineupFailure = production.resolveLineupFailure
M.exportChaosLineup = production.exportChaosLineup
M.importChaosLineup = production.importChaosLineup
M.previewLineupSpawn = production.previewLineupSpawn
M.startLineupSpawn = production.startLineupSpawn
M.cancelLineupSpawn = production.cancelLineupSpawn
M.removeManagedVehicle = production.removeManagedVehicle
M.respawnManagedVehicle = production.respawnManagedVehicle
M.placeAIDestination = production.placeAIDestination
M.confirmAIDestination = production.confirmAIDestination
M.clearAIDestination = production.clearAIDestination
M.addAIRoutePoint = production.addAIRoutePoint
M.editAIRoute = production.editAIRoute
M.startManagedAI = production.startManagedAI
M.pauseManagedAI = function() return production.controlManagedAI("pause") end
M.resumeManagedAI = function() return production.controlManagedAI("resume") end
M.stopManagedAI = function() return production.controlManagedAI("stop") end
M.resetManagedAI = function() return production.controlManagedAI("reset") end
M.setAIRecording = production.setAIRecording
M.saveVehicleDNA = saveVehicleDNA
M.setVehicleDNAPage = setVehicleDNAPage
M.deleteVehicleDNA = deleteVehicleDNA
M.renameVehicleDNA = renameVehicleDNA
M.setVehicleDNAFavorite = setVehicleDNAFavorite
M.setVehicleDNAPinned = setVehicleDNAPinned
M.setVehicleDNARating = setVehicleDNARating
M.setVehicleDNATags = setVehicleDNATags
M.setVehicleDNACollection = setVehicleDNACollection
M.setVehicleDNANotes = setVehicleDNANotes
M.duplicateVehicleDNA = duplicateVehicleDNA
M.setVehicleDNAQuery = setVehicleDNAQuery
M.getVehicleDNADetails = getVehicleDNADetails
M.compareVehicleDNA = compareVehicleDNA
M.importVehicleDNA = importVehicleDNA
M.exportVehicleDNA = exportVehicleDNA
M.exportVehicleDNAJson = exportVehicleDNAJson
M.exportVehicleDNAPackage = exportVehicleDNAPackage
M.importVehicleDNAPackage = importVehicleDNAPackage
M.confirmVehicleDNAPackageImport = confirmVehicleDNAPackageImport
M.captureVehicleDNAThumbnail = captureVehicleDNAThumbnail
M.removeVehicleDNAThumbnail = removeVehicleDNAThumbnail
M.preflightVehicleDNA = preflightVehicleDNA
M.replayVehicleDNA = replayVehicleDNA
M.replayVehicleDNAGeneration = replayVehicleDNAGeneration
M.pureSeedReplayVehicleDNA = pureSeedReplayVehicleDNA
M.mutateVehicleDNA = mutateVehicleDNA
M.restoreVehicleDNA = restoreVehicleDNA
M.onExtensionLoaded = onExtensionLoaded
M.onVehicleSpawned = onVehicleSpawned
M.onVehicleSwitched = onVehicleSwitched
M.onVehicleDestroyed = onVehicleDestroyed
M.onClientEndMission = onClientEndMission
M.onModActivated = onModStateChanged
M.onModDeactivated = onModStateChanged
M.onUpdate = onUpdate

return M
