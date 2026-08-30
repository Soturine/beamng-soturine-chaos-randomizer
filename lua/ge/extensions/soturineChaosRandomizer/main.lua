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
  compatibility = require("ge/extensions/soturineChaosRandomizer/compatibility"),
  registryReadiness = require("ge/extensions/soturineChaosRandomizer/registryReadiness"),
  userDataMigration = require("ge/extensions/soturineChaosRandomizer/userDataMigration"),
  raceManager = require("ge/extensions/soturineChaosRandomizer/raceManager"),
  raceFocusGuard = require("ge/extensions/soturineChaosRandomizer/raceFocusGuard"),
  racePreview = require("ge/extensions/soturineChaosRandomizer/racePreview"),
  raceAttemptCoordinator = require("ge/extensions/soturineChaosRandomizer/raceAttemptCoordinator"),
  lineupSchema = require("ge/extensions/soturineChaosRandomizer/lineupSchema"),
  lineupStorage = require("ge/extensions/soturineChaosRandomizer/lineupStorage"),
  lineupPersistence = require("ge/extensions/soturineChaosRandomizer/lineupPersistence"),
  managedRegistry = require("ge/extensions/soturineChaosRandomizer/managedVehicleRegistry"),
  spawnAdapter = require("ge/extensions/soturineChaosRandomizer/spawnApiAdapter"),
  spawnDirector = require("ge/extensions/soturineChaosRandomizer/spawnDirector"),
  aiAdapter = require("ge/extensions/soturineChaosRandomizer/aiAdapter"),
  aiDirector = require("ge/extensions/soturineChaosRandomizer/aiDirector"),
  destinationMarker = require("ge/extensions/soturineChaosRandomizer/destinationMarker"),
  routePlanner = require("ge/extensions/soturineChaosRandomizer/routePlanner"),
  operationContext = require("ge/extensions/soturineChaosRandomizer/runtime/operationContext"),
  domainOperations = require("ge/extensions/soturineChaosRandomizer/runtime/domainOperations"),
  energyStorageGuard = require("ge/extensions/soturineChaosRandomizer/energyStorageGuard"),
  engineFluidGuard = require("ge/extensions/soturineChaosRandomizer/engineFluidGuard"),
  baselineSemantics = require("ge/extensions/soturineChaosRandomizer/baselineSemantics"),
  criticalRepair = require("ge/extensions/soturineChaosRandomizer/criticalRepair"),
  performanceMetrics = require("ge/extensions/soturineChaosRandomizer/performanceMetrics"),
  frameBudget = require("ge/extensions/soturineChaosRandomizer/frameBudget"),
  registryCache = require("ge/extensions/soturineChaosRandomizer/registryCache"),
  incrementalIndexer = require("ge/extensions/soturineChaosRandomizer/incrementalIndexer"),
  uiPublisher = require("ge/extensions/soturineChaosRandomizer/uiPublisher"),
  uiProtocol = require("ge/extensions/soturineChaosRandomizer/uiProtocol"),
  uiCommandRouter = require("ge/extensions/soturineChaosRandomizer/uiCommandRouter"),
  uiStateProjector = require("ge/extensions/soturineChaosRandomizer/uiStateProjector"),
  uiPreferences = require("ge/extensions/soturineChaosRandomizer/uiPreferences"),
  adaptivePolling = require("ge/extensions/soturineChaosRandomizer/adaptivePolling"),
  aiModeConfirmation = require("ge/extensions/soturineChaosRandomizer/aiModeConfirmation"),
  cooperativeScheduler = require("ge/extensions/soturineChaosRandomizer/runtime/cooperativeScheduler"),
  stabilityLimits = require("ge/extensions/soturineChaosRandomizer/runtime/stabilityLimits"),
  safetyGate = require("ge/extensions/soturineChaosRandomizer/safetyGate"),
  safetyModel = require("ge/extensions/soturineChaosRandomizer/runtime/safetyModel"),
  operationOutcome = require("ge/extensions/soturineChaosRandomizer/operationOutcome"),
  formationEnum = require("ge/extensions/soturineChaosRandomizer/formationEnum"),
  contactDetector = require("ge/extensions/soturineChaosRandomizer/contactDetector"),
  playgroundMode = require("ge/extensions/soturineChaosRandomizer/playgroundMode"),
  raceScheduler = require("ge/extensions/soturineChaosRandomizer/raceScheduler"),
}

local M = {}
local production = {}

M.dependencies = {"core_modmanager", "core_vehicle_manager", "core_vehicle_partmgmt", "core_vehicles"}

local EXTENSION_VERSION = "0.7.8"
local WAIT_TIMEOUT = 25
local PAINT_CONFIRM_TIMEOUT = 2
local RECENT_LIMIT = 4
local READ_RETRY_TIMEOUT = 5
local READ_RETRY_INTERVAL = 0.10
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
  progress = {phase = "idle", phaseProgress = 0, overallProgress = 0, value = 0},
  recentModels = {},
  recentConfigs = {},
  recentRandomCarResults = {},
  recentFullRandomBaseResults = {},
  recentCompletedDNA = {},
  capabilities = {},
  conflicts = {},
  compatibility = productionModules.compatibility.evaluate({}, "unknown"),
  contentAliases = {},
  registry = productionModules.registryReadiness.create(),
  indexer = productionModules.incrementalIndexer.create(),
  catalogFingerprint = nil,
  migrationReport = productionModules.userDataMigration.create(EXTENSION_VERSION),
  recovery = vehicleRecovery.create(),
  lineup = {
    current = nil,
    library = productionModules.lineupStorage.create(20),
    loaded = false,
    pendingNext = false,
  },
  managedVehicles = productionModules.managedRegistry.create(32),
  domainOperations = productionModules.domainOperations.create(),
  spawnDirector = {preview = nil, run = nil, lastResult = nil},
  racePreview = nil,
  raceAttempts = productionModules.raceAttemptCoordinator.create(),
  aiDirector = productionModules.aiDirector.create(32),
  destination = productionModules.destinationMarker.create(),
  aiRoute = productionModules.routePlanner.create(16),
  uiMode = "expanded",
  uiPublisher = productionModules.uiPublisher.create(),
  uiSequence = productionModules.uiProtocol.createSequence(),
  uiCommandRouter = nil,
  frameBudgets = productionModules.frameBudget.create(),
  cooperativeScheduler = productionModules.cooperativeScheduler.create(),
  stabilityLimits = productionModules.stabilityLimits.normalize(),
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
  performanceTelemetry = productionModules.performanceMetrics.create({enabled = false, sampleLimit = 256, eventLimit = 512}),
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
local failActive

production.ensureOperationContext = function(active)
  if not active.operationContext then
    active.operationContext = productionModules.operationContext.create(
      runtime.state, active.token, runtime.time.realMonotonicTime, {
        domain = active.domain,
        action = active.kind,
        generation = active.domainGeneration,
        expectedSlot = active.expectedSlot,
        expectedLogicalTarget = active.logicalTarget,
        sourceVehicleId = active.originalVehicleId,
      }
    )
  else
    productionModules.operationContext.sync(active.operationContext, runtime.state)
  end
  return active.operationContext
end

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

local function selectionIdentity(modelKey, configKey)
  if not modelKey or not configKey then return nil end
  return tostring(modelKey) .. "/" .. tostring(configVerification.stableKey(configKey) or configKey)
end

local function withoutRecentPairs(models, recentPairs)
  local recent = {}
  for _, value in ipairs(recentPairs or {}) do recent[value] = true end
  if next(recent) == nil then return models, false end
  local total = 0
  for _, model in ipairs(models or {}) do total = total + #(model.configs or {}) end
  if total <= 1 then return models, false end
  local filtered, remaining = {}, 0
  for _, model in ipairs(models or {}) do
    local copy = util.deepCopy(model)
    copy.configs = {}
    for _, config in ipairs(model.configs or {}) do
      if not recent[selectionIdentity(config.modelKey or model.key, config.path or config.key)] then
        copy.configs[#copy.configs + 1] = util.deepCopy(config)
        remaining = remaining + 1
      end
    end
    if #copy.configs > 0 then filtered[#filtered + 1] = copy end
  end
  return remaining > 0 and filtered or models, remaining > 0
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

function production.publicPerformance()
  local result = util.deepCopy(runtime.performance)
  result.telemetry = productionModules.performanceMetrics.snapshot(runtime.performanceTelemetry, adapter.clock())
  result.frameBudgets = productionModules.frameBudget.snapshot(runtime.frameBudgets)
  result.uiPublish = productionModules.uiPublisher.snapshot(runtime.uiPublisher, adapter.clock())
  result.registryIndexing = productionModules.incrementalIndexer.snapshot(runtime.indexer)
  result.vehicleRuntime = type(productionModules.spawnAdapter.performanceSnapshot) == "function"
    and productionModules.spawnAdapter.performanceSnapshot() or nil
  result.diagnostics = diagnosticsModule.summary(runtime.diagnostics)
  return result
end

production.operationDomain = function(kind, context)
  context = type(context) == "table" and context or {}
  if context.domain == "chaos" or context.domain == "race" or context.domain == "garage" then
    return context.domain
  end
  if context.lineupIndex ~= nil then return "race" end
  if type(kind) == "string" and kind:sub(1, 3) == "dna" then return "garage" end
  return "chaos"
end

production.domainCallbackToken = function(active, kind, values)
  if not active or not active.domainContext then return nil end
  return productionModules.domainOperations.callbackToken(active.domainContext, kind, values)
end

production.reapOwnedOrphans = function(active, reason)
  if not active or not active.domainContext then return {removed = {}, failed = {}, skipped = {}} end
  local started = adapter.clock()
  local result = productionModules.domainOperations.reap(
    runtime.domainOperations, productionModules.spawnAdapter.deleteVehicle,
    {
      domain = active.domain, operationId = active.domainContext.operationId,
      now = adapter.clock(), clock = adapter.clock, budgetMs = 1, maxItems = 8,
    }
  )
  local elapsedMs = math.max(0, (adapter.clock() - started) * 1000)
  productionModules.performanceMetrics.record(runtime.performanceTelemetry, "ownershipCleanup", elapsedMs)
  productionModules.performanceMetrics.record(runtime.performanceTelemetry, "orphanReaper", elapsedMs)
  if #result.removed > 0 or #result.failed > 0 then
    diagnosticsModule.write(runtime.diagnostics, #result.failed == 0 and "I" or "W", "orphan_cleanup", {
      domain = active.domain, operationId = active.domainContext.operationId,
      reason = reason, cleanupResult = result,
    }, true)
  end
  return result
end

function production.placementAvailability()
  return productionModules.raceManager.placementAvailability(
    runtime.lineup.current, runtime.managedVehicles, runtime.state.busy,
    runtime.spawnDirector.run and runtime.spawnDirector.run.active
  )
end

local function publicState()
  local blacklist = contentIndex.blacklistCounts(runtime.index)
  local storageMetrics = vehicleDNAStorage.metrics(runtime.dna.library) or {}
  local garageStarted = adapter.clock()
  local query = util.deepCopy(runtime.dna.query)
  query.offset, query.limit = runtime.dna.page * runtime.dna.pageSize, runtime.dna.pageSize
  local garageEntries, garageTotal = vehicleDNAStorage.query(runtime.dna.library, query)
  runtime.performance.garageLoadMs = math.max(0, (adapter.clock() - garageStarted) * 1000)
  productionModules.performanceMetrics.record(runtime.performanceTelemetry, "garageLoad", runtime.performance.garageLoadMs)
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
      seedIntent = runtime.lineup.current.seedIntent,
      repeatedFromLineupId = runtime.lineup.current.repeatedFromLineupId,
      active = runtime.lineup.current.active == true,
      generationState = runtime.lineup.current.generationState,
      processingState = runtime.lineup.current.processingState,
      participationMode = runtime.lineup.current.participationMode,
      playerParticipates = runtime.lineup.current.playerParticipates == true,
      playerVehicleId = runtime.lineup.current.playerVehicleId,
      totalVehicles = runtime.lineup.current.totalVehicles,
      aiOpponentCount = runtime.lineup.current.aiOpponentCount,
      settings = util.deepCopy(runtime.lineup.current.settings),
      varietyRules = util.deepCopy(runtime.lineup.current.varietyRules),
      stagingPreview = util.deepCopy(runtime.lineup.current.stagingPreview),
      placementPreview = util.deepCopy(runtime.lineup.current.placementPreview),
      worldPreview = util.deepCopy(runtime.racePreview),
      warnings = util.deepCopy(runtime.lineup.current.warnings),
      persistence = util.deepCopy(runtime.lineup.current.persistence),
      schedulerState = runtime.lineup.current.schedulerState,
      schedulerLastProgressAt = runtime.lineup.current.schedulerLastProgressAt,
      summary = productionModules.raceManager.summary(runtime.lineup.current), competitors = {},
    }
    for _, competitor in ipairs(runtime.lineup.current.competitors or {}) do
      publicLineup.competitors[#publicLineup.competitors + 1] = {
        index = competitor.index, id = competitor.id, name = competitor.name,
        seed = competitor.seed, selectionSeed = competitor.selectionSeed,
        mutationSeed = competitor.mutationSeed, placementSeed = competitor.placementSeed,
        status = competitor.status, warning = competitor.warning,
        phase = competitor.phase, phaseProgress = competitor.phaseProgress,
        terminalState = competitor.terminalState, failureCode = competitor.failureCode,
        dnaId = competitor.dnaId, modelKey = competitor.modelKey,
        position = competitor.position, configuration = competitor.configuration,
        source = util.deepCopy(competitor.source), dependencies = util.deepCopy(competitor.dependencies),
        coverage = util.deepCopy(competitor.coverage), targetGeneration = competitor.targetGeneration,
        progress = competitor.progress,
        managedHandle = competitor.managedHandle,
        competitorId = competitor.competitorId or competitor.id,
        operationId = competitor.operationId, generation = competitor.generation,
        slotId = competitor.slotId, derivedSeed = competitor.derivedSeed,
        candidateVehicleId = competitor.candidateVehicleId,
        acceptedVehicleId = competitor.acceptedVehicleId,
        ownedTemporaryIds = util.deepCopy(competitor.ownedTemporaryIds),
        retryCount = competitor.retryCount,
        requestedIndex = competitor.requestedIndex,
        logicalCandidate = util.deepCopy(competitor.logicalCandidate),
        currentVehicleId = competitor.currentVehicleId,
        concreteVehicleId = competitor.currentVehicleId,
        generationId = runtime.lineup.current.id,
        episodeSeed = runtime.lineup.current.episodeSeed,
        slotSeed = competitor.seed,
        spawnState = competitor.spawnState,
        randomizationState = competitor.randomizationState,
        validationState = competitor.validationState,
        placementState = competitor.placementState,
        generationReady = competitor.generationReady == true,
        placementReady = competitor.placementReady == true,
        drivabilityState = competitor.drivabilityState,
        drivable = competitor.drivable,
        aiState = competitor.aiState,
        aiReady = competitor.aiReady == true,
        aiCommandDispatched = competitor.aiCommandDispatched == true,
        aiDispatch = util.deepCopy(competitor.aiDispatch),
        policyDecision = util.deepCopy(competitor.policyDecision),
        bindingFailureReason = competitor.bindingFailureReason,
        replacementState = competitor.replacementState,
        terminalResult = util.deepCopy(competitor.terminalResult),
        spawnTransaction = util.deepCopy(competitor.spawnTransaction),
        raceStatus = competitor.raceStatus, traits = util.deepCopy(competitor.traits),
      }
    end
  end
  return {
    extensionVersion = EXTENSION_VERSION,
    gameVersion = adapter.getGameVersion(),
    detectedGameVersion = runtime.compatibility.detectedGameVersion,
    primaryTarget = runtime.compatibility.primaryTarget,
    minimumSupported = runtime.compatibility.minimumSupported,
    compatibilityState = runtime.compatibility.compatibilityState,
    compatibilityWarnings = util.deepCopy(runtime.compatibility.compatibilityWarnings),
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
    domainOperations = productionModules.domainOperations.summary(runtime.domainOperations),
    cooperativeScheduler = productionModules.cooperativeScheduler.snapshot(runtime.cooperativeScheduler),
    stabilityLimits = util.deepCopy(runtime.stabilityLimits),
    recovery = recoveryMetrics,
    token = runtime.state.token,
    transaction = runtime.active and {
      operationId = runtime.active.operationId,
      operationGeneration = runtime.active.operationGeneration,
      phaseGeneration = runtime.active.phaseGeneration,
      targetGeneration = runtime.active.targetGeneration,
      recoveryGeneration = runtime.active.recoveryGeneration,
      recoveryOnly = runtime.active.recoveryOnly == true,
      expectedPlayerIndex = runtime.active.backgroundTarget ~= true and 0 or nil,
      targetRole = runtime.active.backgroundTarget and "background_owned" or "player_zero",
      expectedVehicleId = runtime.active.operationContext
        and runtime.active.operationContext.concreteTarget
        and runtime.active.operationContext.concreteTarget.vehicleId or nil,
      currentVehicleId = okActiveVehicle and activeVehicleId or nil,
      modelKey = runtime.active.modelKey or (runtime.active.selectedModel and runtime.active.selectedModel.key),
      configKey = runtime.active.selectedConfig and runtime.active.selectedConfig.key,
      configPath = runtime.active.selectedConfig and runtime.active.selectedConfig.path,
      phase = runtime.state.phase,
      phaseStartedAt = runtime.active.phaseStartedAt,
      wallElapsed = math.max(0, clockMetrics.realMonotonicTime - runtime.active.startedAt),
      simulationElapsed = math.max(0, clockMetrics.simulationTime - (runtime.active.startedSimulationAt or 0)),
      phaseWallElapsed = runtime.active.phaseStartedAt
        and math.max(0, clockMetrics.realMonotonicTime - runtime.active.phaseStartedAt) or nil,
      phaseSimulationElapsed = runtime.active.phaseStartedSimulationAt
        and math.max(0, clockMetrics.simulationTime - runtime.active.phaseStartedSimulationAt) or nil,
      phaseTimings = util.deepCopy(runtime.active.phaseTimings),
      readBackStatus = runtime.active.readBackStatus or (trackerMetrics and trackerMetrics.lastReason),
      targetIdentityFingerprint = trackerMetrics and trackerMetrics.stateFingerprint,
      treeFingerprint = trackerMetrics and trackerMetrics.treeFingerprint,
      configFingerprint = trackerMetrics and trackerMetrics.expectedConfigKey,
      callbackOwner = trackerMetrics and {
        operationGeneration = trackerMetrics.operationGeneration,
        phaseGeneration = trackerMetrics.phaseGeneration,
        targetGeneration = trackerMetrics.targetGeneration,
      } or nil,
      candidateIdChain = trackerMetrics and util.deepCopy(trackerMetrics.candidateChain) or {},
      lastProgressTimestamp = watchdogMetrics and watchdogMetrics.lastProgressAt,
      lastProgressReason = watchdogMetrics and watchdogMetrics.lastProgressReason,
      lastAcceptedCheckpoint = runtime.active.lastAcceptedCheckpoint,
      recoveryTier = runtime.active.recoveryTier,
      recoveryAttemptCount = recoveryMetrics.recoveryAttempts,
      rngSubstreams = util.deepCopy(runtime.active.rngSubstreams),
      originalSnapshot = runtime.active.operationOriginalSnapshot and {
        modelKey = runtime.active.operationOriginalSnapshot.modelKey,
        vehicleId = runtime.active.operationOriginalSnapshot.vehicleId,
      } or nil,
      candidateBase = runtime.active.operationCandidateBase and {
        modelKey = runtime.active.operationCandidateBase.modelKey,
        vehicleId = runtime.active.operationCandidateBase.vehicleId,
      } or nil,
      currentTarget = util.deepCopy(runtime.active.operationCurrentTarget),
      baselines = productionModules.baselineSemantics.summary(runtime.active.baselines),
      candidateClassification = runtime.active.safetyResult and runtime.active.safetyResult.classification
        or runtime.active.safetyBaseline and runtime.active.safetyBaseline.classification,
      engineFluids = util.deepCopy(runtime.active.engineFluidReport),
      criticalRepairAttempts = util.deepCopy(runtime.active.criticalRepairAttempts),
      recoveryTarget = util.deepCopy(runtime.active.operationRecoveryTarget),
      operationContext = runtime.active.operationContext
        and productionModules.operationContext.summary(runtime.active.operationContext) or nil,
      mutationPlan = runtime.active.operationMutationPlan and {
        stage = runtime.active.operationMutationPlan.stage,
        operationId = runtime.active.operationMutationPlan.operationId,
        targetGeneration = runtime.active.operationMutationPlan.targetGeneration,
      } or nil,
      spawnTransaction = util.deepCopy(runtime.active.spawnTransaction),
      pending = {
        currentBatch = runtime.active.currentBatch and #runtime.active.currentBatch or 0,
        afterReload = runtime.active.afterReload and 1 or 0,
        tuning = runtime.active.pendingTuningChanges and #runtime.active.pendingTuningChanges or 0,
        paint = runtime.active.paintConfirmation and 1 or 0,
        treeTimer = runtime.active.treeRescanAt and 1 or 0,
        safetyTimer = runtime.active.safetyRevalidateAt and 1 or 0,
        callbacks = runtime.active.targetTracker and 1 or 0,
        timers = (runtime.active.treeRescanAt and 1 or 0)
          + (runtime.active.safetyRevalidateAt and 1 or 0)
          + (runtime.active.paintConfirmation and 1 or 0),
        tuningPlan = runtime.active.pendingTuningPlan and 1 or 0,
        paintPlan = runtime.active.pendingPaintPlan and 1 or 0,
      },
    } or nil,
    progress = util.deepCopy(runtime.progress),
    settings = publicSettings,
    seed = runtime.active and runtime.active.seed or runtime.lastSeed or runtime.settings.manualSeed,
    lastResult = util.deepCopy(runtime.lastResult),
    lastFailure = util.deepCopy(runtime.lastFailure),
    index = {
      valid = runtime.index.valid == true,
      stale = runtime.index.stale == true,
      registry = productionModules.registryReadiness.summary(runtime.registry),
      models = #runtime.index.models,
      configurations = #runtime.index.allConfigs,
      duration = runtime.index.duration,
      sources = sourceCounts(),
      blacklists = blacklist,
      blacklisted = blacklist.total,
      lastBlocked = util.deepCopy(runtime.index.lastBlocked),
      lastQuarantine = util.deepCopy(runtime.index.lastQuarantine),
      suspects = contentIndex.suspectCount(runtime.index),
      lastSuspect = util.deepCopy(runtime.index.lastSuspect),
      indexing = productionModules.incrementalIndexer.snapshot(runtime.indexer),
      catalogFingerprint = runtime.catalogFingerprint,
    },
    canUndo = #runtime.history.entries > 0 and not runtime.state.busy,
    history = historyModule.summaries(runtime.history),
    capabilities = util.deepCopy(runtime.capabilities),
    conflicts = util.deepCopy(runtime.conflicts),
    migration = util.deepCopy(runtime.migrationReport),
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
      placement = production.placementAvailability(),
      racePreview = util.deepCopy(runtime.racePreview),
      attempts = productionModules.raceAttemptCoordinator.snapshot(runtime.raceAttempts),
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
      diagnostics = runtime.uiMode == "collapsed" and {}
        or {count = #(runtime.aiDirector.diagnostics or {})},
    },
    performance = production.publicPerformance(),
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
      comparison = util.deepCopy(runtime.dna.comparison),
      exportText = runtime.dna.exportText,
      sharePreview = util.deepCopy(runtime.dna.sharePreview),
      importPreview = runtime.dna.importPreview and util.deepCopy(runtime.dna.importPreview.public) or nil,
      thumbnailPending = runtime.dna.thumbnailPending,
      schemaVersion = vehicleDNASchema.SCHEMA_VERSION,
      generatorVersion = vehicleDNASchema.GENERATOR_VERSION,
      storagePath = adapter.DNA_LIBRARY_PATH,
    },
  }
end

production.payloadBytes = function(payload)
  if type(adapter.encodeJSON) ~= "function" then return 0 end
  local ok, encoded = adapter.encodeJSON(payload, false)
  return ok and type(encoded) == "string" and #encoded or 0
end

production.recordBudget = function(stage, elapsedMs, budgetMs)
  productionModules.frameBudget.check(runtime.frameBudgets, stage, elapsedMs, budgetMs, adapter.clock(), function(value)
    diagnosticsModule.write(runtime.diagnostics, "W", "frame_budget_exceeded", value, true)
  end)
end

local function publishState(forceFull)
  local started = adapter.clock()
  local state = publicState()
  local builtMs = math.max(0, (adapter.clock() - started) * 1000)
  productionModules.performanceMetrics.record(runtime.performanceTelemetry, "uiState", builtMs)
  local envelope = productionModules.uiStateProjector.full(
    runtime.uiSequence, state, adapter.clock(), forceFull == "reset" and "reset" or "full"
  )
  adapter.emit("SoturineChaosRandomizerState", envelope, true)
  local elapsedMs = math.max(0, (adapter.clock() - started) * 1000)
  productionModules.performanceMetrics.record(runtime.performanceTelemetry, "uiPublish", elapsedMs)
  productionModules.performanceMetrics.record(runtime.performanceTelemetry, "uiPayload", math.max(0, elapsedMs - builtMs))
  productionModules.performanceMetrics.recordEvent(runtime.performanceTelemetry, "uiEvents", adapter.clock())
  productionModules.uiPublisher.note(runtime.uiPublisher, "full", production.payloadBytes(envelope), adapter.clock())
  productionModules.uiPublisher.consume(runtime.uiPublisher, "full")
  production.recordBudget("uiPublish", elapsedMs, runtime.frameBudgets.values.uiPublishBudgetMs)
  return state
end

production.publishProgress = function(force)
  local now = adapter.clock()
  if force ~= true and not productionModules.uiPublisher.due(runtime.uiPublisher, now, false) then
    runtime.pendingProgressPublish = true
    productionModules.uiPublisher.suppress(runtime.uiPublisher)
    return false
  end
  runtime.pendingProgressPublish = false
  local started = adapter.clock()
  local payload = {
    progress = util.deepCopy(runtime.progress),
    busy = operationState.deriveBusy(runtime.state), operationState = runtime.state.state,
    lifecyclePhase = runtime.state.phase,
  }
  local envelope = productionModules.uiStateProjector.diff(
    runtime.uiSequence, "core", payload,
    {"progress", "busy", "operationState", "lifecyclePhase"},
    {operationId = runtime.state.operationId, operationGeneration = runtime.state.operationGeneration},
    now
  )
  adapter.emit("SoturineChaosRandomizerStateDiff", envelope, true)
  local elapsedMs = math.max(0, (adapter.clock() - started) * 1000)
  productionModules.performanceMetrics.record(runtime.performanceTelemetry, "uiPublish", elapsedMs)
  productionModules.performanceMetrics.recordEvent(runtime.performanceTelemetry, "uiEvents", now)
  productionModules.uiPublisher.note(runtime.uiPublisher, "partial", production.payloadBytes(envelope), now)
  productionModules.uiPublisher.consume(runtime.uiPublisher, "partial")
  production.recordBudget("uiPublish", elapsedMs, runtime.frameBudgets.values.uiPublishBudgetMs)
  return true
end

local function setProgress(_, value)
  local active = runtime.active
  local phase = active and (active.lifecyclePhase or active.phase) or runtime.state.phase or "idle"
  local phaseProgress = util.clamp(value or 0, 0, 1)
  local overall = phaseProgress
  if active and active.lineupIndex and runtime.lineup.current then
    local total = math.max(1, #(runtime.lineup.current.competitors or {}))
    overall = util.clamp(((active.lineupIndex - 1) + phaseProgress) / total, 0, 1)
  end
  local sameOperation = runtime.progress.operationId == runtime.state.operationId
  local sameRace = active and active.lineupIndex and runtime.progress.raceId == runtime.lineup.current.id
  if sameOperation or sameRace then overall = math.max(runtime.progress.overallProgress or 0, overall) end
  runtime.progress = {
    operationId = runtime.state.operationId,
    raceId = active and active.lineupIndex and runtime.lineup.current.id or nil,
    phase = phase,
    phaseProgress = phaseProgress,
    overallProgress = overall,
    value = overall,
    pass = active and active.pass or nil,
    attempt = active and (active.retryCount or active.configRetryCount) or nil,
    slotId = active and active.expectedSlot or nil,
    label = phase,
  }
  productionModules.uiPublisher.mark(runtime.uiPublisher, "progressDirty")
  production.publishProgress(false)
end

local function noteProgress(active, kind, reason)
  if active and active.progressWatchdog then
    local semantic = progressWatchdog.note(
      active.progressWatchdog, kind, reason, runtime.time.realMonotonicTime
    )
    if semantic and active.domainContext then
      active.domainContext.semanticProgressSequence =
        (active.domainContext.semanticProgressSequence or 0) + 1
    end
  end
end

local function setLifecyclePhase(active, phase, timeout, reason)
  local phaseChanged = active and active.lifecyclePhase ~= phase
  if phaseChanged then
    if active.lifecyclePhase and active.phaseStartedAt then
      active.phaseTimings = active.phaseTimings or {}
      active.phaseTimings[active.lifecyclePhase] = (active.phaseTimings[active.lifecyclePhase] or 0)
        + math.max(0, runtime.time.realMonotonicTime - active.phaseStartedAt)
    end
    active.phaseStartedAt = runtime.time.realMonotonicTime
    active.phaseStartedSimulationAt = runtime.time.simulationTime
  end
  local ok, phaseError = operationState.setPhase(runtime.state, phase, timeout, reason)
  if ok then
    if active then
      active.lifecyclePhase = phase
      active.phaseGeneration = runtime.state.phaseGeneration
      if active.domainContext then
        productionModules.domainOperations.setPhase(active.domainContext, phase, "active")
      end
      if active.progressWatchdog then
        progressWatchdog.setPhase(active.progressWatchdog, phase, runtime.time.realMonotonicTime)
        progressWatchdog.setDeadlines(
          active.progressWatchdog,
          runtime.state.deadline,
          runtime.state.operationDeadline
        )
      end
      if active.lineupIndex and runtime.lineup.current then
        local racePhase = phase == "selecting" and "selecting_vehicle"
          or phase == "issuing_spawn" and "spawning_vehicle"
          or (phase == "tracking_target_identity" or phase == "stabilizing_tree") and "binding_vehicle"
          or (phase == "final_validation") and "validating"
          or (phase == "planning_parts" or phase == "applying_parts" or phase == "waiting_parts_reload"
            or phase == "planning_tuning" or phase == "applying_tuning" or phase == "waiting_tuning_reload"
            or phase == "applying_paint" or phase == "verifying_paint") and "randomizing"
        if racePhase then
          productionModules.raceManager.setPhase(
            runtime.lineup.current, active.lineupIndex, racePhase, runtime.progress.phaseProgress
          )
        end
      end
    end
    if phaseChanged then noteProgress(active, "phase", reason or phase) end
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
  local expected = util.deepCopy(active.reloadWriteTarget or active.operationCurrentTarget or {
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
  local expectedVehicleId = active.reloadWriteTarget and active.reloadWriteTarget.vehicleId
    or active.operationCurrentTarget and active.operationCurrentTarget.vehicleId or active.vehicleId
  local okObserved, observedOrError = adapter.getVerificationState(
    expectedVehicleId, active.backgroundTarget == true
  )
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
  active.lastAcceptedCheckpoint = stage .. "_write_confirmed"
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
    adapter.saveSettings(settingsModule.forPersistence(runtime.settings))
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
  context.operationId = context.operationId or active and active.operationId
  context.operationGeneration = context.operationGeneration or active and active.operationGeneration
  context.preset = context.preset or active and active.domain == "race"
    and runtime.lineup.current and runtime.lineup.current.preset
  context.sourceVehicleId = context.sourceVehicleId or active and active.originalVehicleId
  context.candidateVehicleId = context.candidateVehicleId or active and active.vehicleId
  context.spawnAction = context.spawnAction or active and active.kind
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
    operationId = context.operationId,
    operationGeneration = context.operationGeneration,
    preset = context.preset,
    sourceVehicleId = context.sourceVehicleId,
    candidateVehicleId = context.candidateVehicleId,
    attempt = context.attempt or (active and active.pass),
    timestamp = os.time(),
    context = context,
  }
end

local function validateTerminalVehicleCardinality(active)
  if not active or type(adapter.worldVehicleIds) ~= "function" or not active.domainContext then return true, {} end
  local after = adapter.worldVehicleIds()
  productionModules.domainOperations.recordWorldAfter(active.domainContext, after)
  local valid, details = productionModules.domainOperations.classifyWorldDelta(active.domainContext, after)
  details.worldVehicleIdsBefore = util.deepCopy(active.worldVehicleIdsBefore or {})
  details.worldVehicleIdsObserved = util.deepCopy(after)
  details.ignoredBackgroundCallbacks = active.ignoredBackgroundCallbacks or 0
  details.playerUsedAsStaging = active.backgroundTarget and false or nil
  return valid, details
end

local function finishOperation(success, code, message, details, terminalState)
  local active = runtime.active
  terminalState = terminalState or (success and "completed" or "failed")
  details = type(details) == "table" and details or {}
  if active and success == true and active.kind == "scramble" then
    local currentOk, currentVehicleId = adapter.getCurrentVehicleId()
    if not currentOk or currentVehicleId ~= active.originalVehicleId then
      if productionModules.spawnAdapter.objectExists(active.originalVehicleId) then
        adapter.enterVehicle(active.originalVehicleId)
        active.vehicleId = active.originalVehicleId
      end
      success = false
      code = "scramble_cardinality_violation"
      message = "Scramble stopped because the controlled vehicle identity changed"
      terminalState = "failed"
      details.cardinalityViolation = true
    end
  end
  if active and success == true then
    active.operationMutationPlan = nil
    active.pendingTuningPlan = nil
    active.pendingPaintPlan = nil
    active.pendingTuningChanges = nil
    active.currentBatch = nil
    active.batchRollbackDecisions = nil
    active.afterReload = nil
    if active.slotLedger and slotCoverageLedger.isComplete(active.slotLedger) then
      active.slotLedger.closed, active.slotLedger.closeReason = true, "terminal_readback_complete"
    end
    if active.tuningLedger and tuningCoverageLedger.isComplete(active.tuningLedger) then
      active.tuningLedger.closed, active.tuningLedger.closeReason = true, "terminal_readback_complete"
    end
    if active.paintLedger and paintCoverageLedger.isComplete(active.paintLedger) then
      active.paintLedger.closed, active.paintLedger.closeReason = true, "terminal_readback_complete"
    end
  end
  operationState.finish(runtime.state, terminalState, success and nil or code)
  if active then vehicleRecovery.cleanup(active) end
  if active and active.domainContext then
    local currentOk, currentVehicleId = adapter.getCurrentVehicleId()
    local acceptedVehicleId = tonumber(active.vehicleId) or (currentOk and currentVehicleId or nil)
    if success == true and acceptedVehicleId ~= nil then
      local role = active.domain == "race" and "race_competitor" or "player_result"
      productionModules.domainOperations.acceptVehicle(
        runtime.domainOperations, active.domainContext, acceptedVehicleId, role,
        currentOk and currentVehicleId or acceptedVehicleId
      )
      productionModules.operationContext.markAccepted(
        production.ensureOperationContext(active), acceptedVehicleId,
        currentOk and currentVehicleId or acceptedVehicleId
      )
      if active.domain == "chaos" and active.kind ~= "scramble"
        and type(active.originalVehicleId) == "number"
        and active.originalVehicleId ~= acceptedVehicleId
      then
        productionModules.domainOperations.expectRemoval(active.domainContext, active.originalVehicleId)
        if productionModules.spawnAdapter.objectExists(active.originalVehicleId) then
          local deleted, deleteReason = productionModules.spawnAdapter.deleteVehicle(active.originalVehicleId)
          if deleted then
            productionModules.domainOperations.recordRemoval(
              runtime.domainOperations, active.originalVehicleId, "replaced_player_source_removed"
            )
            details.sourceVehicleRemoved = active.originalVehicleId
          else
            details.cardinalityCleanupWarning = deleteReason
          end
        end
      end
    elseif details.rollback == "completed" and acceptedVehicleId ~= nil then
      productionModules.domainOperations.acceptVehicle(
        runtime.domainOperations, active.domainContext, acceptedVehicleId, "player_result",
        currentOk and currentVehicleId or acceptedVehicleId
      )
      productionModules.domainOperations.rollback(
        active.domainContext, acceptedVehicleId, active.rollbackFailure and active.rollbackFailure.code
      )
    end
    local domainTerminal = details.rollback == "completed" and "rolled_back"
      or terminalState == "partial" and "partial_success"
      or terminalState == "completed" and "completed"
      or terminalState == "cancelled" and "cancelled" or "failed"
    productionModules.domainOperations.terminal(runtime.domainOperations, active.domainContext, domainTerminal, {
      restoredVehicleId = details.rollback == "completed" and acceptedVehicleId or nil,
      sourceStillExists = productionModules.spawnAdapter.objectExists(active.originalVehicleId),
      playerVehicleIdAfter = currentOk and currentVehicleId or acceptedVehicleId,
      rollbackReason = active.rollbackFailure and active.rollbackFailure.code,
      endedAt = runtime.time.realMonotonicTime,
    })
    if active.progressWatchdog then progressWatchdog.setStatus(active.progressWatchdog, "cleaning") end
    local cleanup = production.reapOwnedOrphans(active, domainTerminal)
    details.cleanupResult = util.deepCopy(cleanup)
    local worldVehicleIdsAfter = type(adapter.worldVehicleIds) == "function"
      and adapter.worldVehicleIds() or {}
    productionModules.domainOperations.recordWorldAfter(
      active.domainContext, worldVehicleIdsAfter
    )
    productionModules.operationContext.markTerminal(production.ensureOperationContext(active), domainTerminal, {
      restoredVehicleId = details.rollback == "completed" and acceptedVehicleId or nil,
      sourceStillExists = productionModules.spawnAdapter.objectExists(active.originalVehicleId),
      playerVehicleIdAfter = currentOk and currentVehicleId or acceptedVehicleId,
      removedVehicleIds = cleanup.removed,
      worldVehicleIdsAfter = worldVehicleIdsAfter,
    })
    details.operationTransaction = productionModules.operationContext.summary(
      production.ensureOperationContext(active)
    )
    if success == true and (active.kind == "scramble" or active.kind == "randomConfig" or active.kind == "fullRandom") then
      local cardinalityOk, cardinality = validateTerminalVehicleCardinality(active)
      details.vehicleCardinality = cardinality
      if not cardinalityOk then
        details.cardinalityWarning = "expected_vehicle_transaction_incomplete"
        details.partialApplied = true
        details.appliedIncomplete = true
      elseif cardinality.hasExternalWorldChanges then
        details.cardinalityWarning = "unrelated_world_change_observed"
        active.nonFatalPartial = true
      end
    end
  end
  if active and active.spawnTransaction then
    if (success == true or details.rollback == "completed") and tonumber(active.vehicleId) then
      productionModules.spawnAdapter.spawnOutcome.accept(active.spawnTransaction, active.vehicleId)
    end
    details.spawnCleanup = production.cleanupSpawnTransaction(active.spawnTransaction)
    details.spawnTransaction = util.deepCopy(active.spawnTransaction)
  end
  if active and active.criticalRepairSucceeded == true then
    details.criticalRepairSucceeded = true
  end
  if active then
    details.baselines = productionModules.baselineSemantics.summary(active.baselines)
    details.baselineType = active.criticalRepairSourceType
      or active.recoveryStep
      or (active.baselines and active.baselines.lastAcceptedGeneratedResult
        and "last_accepted_generated_result" or "current_generated_result")
    details.candidateClassification = details.safety and details.safety.classification
      or active.safetyResult and active.safetyResult.classification
      or active.safetyBaseline and active.safetyBaseline.classification
    details.missingCriticalItems = details.safety and util.deepCopy(details.safety.failures or {})
      or util.deepCopy(active.criticalRepairFailures or {})
    details.missingOptionalItems = details.safety and util.deepCopy(details.safety.missingParts or {}) or {}
    details.engineFluids = details.engineFluids or util.deepCopy(active.engineFluidReport)
    details.partsTreeStabilitySamples = active.lastTargetMetrics
      and active.lastTargetMetrics.coherentState and active.lastTargetMetrics.coherentState.stableSamples
    details.repairAttempts = util.deepCopy(active.criticalRepairAttempts or {})
    details.rollbackReason = active.rollbackFailure and active.rollbackFailure.code or nil
  end
  details.nonFatalPartial = active and active.nonFatalPartial == true or nil
  details.energyGuardUncertain = active and active.energyGuardUncertain == true or nil
  details.engineFluidUncertain = active and active.engineFluidUncertain == true or nil
  local outcomeAxes = productionModules.operationOutcome.axes(
    success, code, details, terminalState
  )
  details.terminalOutcome = outcomeAxes.terminalOutcome
  details.appliedState = outcomeAxes.appliedState
  details.verificationConfidence = outcomeAxes.verificationConfidence
  details.outcomeConfidence = outcomeAxes.verificationConfidence
  details.failureKind = outcomeAxes.failureKind
  details.legacyTerminalOutcome = productionModules.operationOutcome.legacy(details.terminalOutcome)
  if active then
    details.targetGeneration = active.targetGeneration
    details.lifecycleAcceptance = {
      finalValidationPassed = success == true,
      busy = operationState.deriveBusy(runtime.state),
      targetConfirmed = active.operationCurrentTarget ~= nil,
      pendingWrites = active.currentBatch and #active.currentBatch or 0,
      pendingTimers = (active.treeRescanAt and 1 or 0)
        + (active.safetyRevalidateAt and 1 or 0)
        + (active.paintConfirmation and 1 or 0),
      pendingCallbacks = active.targetTracker and 1 or 0,
      staleCallbackCount = runtime.state.staleCallbackCount,
      coverageLedgersClosed = (not active.slotLedger or active.slotLedger.closed == true)
        and (not active.tuningLedger or active.tuningLedger.closed == true)
        and (not active.paintLedger or active.paintLedger.closed == true),
      targetOwnershipConfirmed = active.targetOwnershipConfirmed == true
        or active.operationCurrentTarget ~= nil,
    }
    details.snapshotPromoted = false
    details.snapshotSource = active.recoveryOnly and "recovery_target" or "operation_final"
  end
  if active and (success == true or details.rollback == "completed") then
    local readable, finalSnapshot = adapter.captureCurrentState(
      "operation_final", active.seed, active.vehicleId, active.backgroundTarget == true
    )
    if readable then
      vehicleRecovery.rememberReadable(runtime.recovery, finalSnapshot)
      local accepted = success == true and (
          details.terminalOutcome == "COMPLETED"
          or details.terminalOutcome == "COMPLETED_WITH_SKIPS"
          or details.terminalOutcome == "COMPLETED_WITH_WARNING"
          or details.terminalOutcome == "PARTIAL_APPLIED"
        )
        and details.lifecycleAcceptance.busy == false
        and details.lifecycleAcceptance.pendingWrites == 0
        and details.lifecycleAcceptance.pendingTimers == 0
        and details.lifecycleAcceptance.pendingCallbacks == 0
        and details.lifecycleAcceptance.targetOwnershipConfirmed == true
        and active.recoveryOnly ~= true
      if accepted then
        vehicleRecovery.rememberCompletedGood(runtime.recovery, finalSnapshot, false, {
          operationId = active.operationId,
          operationGeneration = active.operationGeneration,
          targetGeneration = active.targetGeneration,
          completedAt = adapter.clock(),
        })
        details.snapshotPromoted = true
        details.snapshotSource = details.terminalOutcome == "PARTIAL_APPLIED"
          and "accepted_partial_operation" or "completed_operation"
      end
    end
  end
  if active then
    if active.lifecyclePhase and active.phaseStartedAt then
      active.phaseTimings = active.phaseTimings or {}
      active.phaseTimings[active.lifecyclePhase] = (active.phaseTimings[active.lifecyclePhase] or 0)
        + math.max(0, runtime.time.realMonotonicTime - active.phaseStartedAt)
      active.phaseStartedAt = runtime.time.realMonotonicTime
    end
    local phaseDuration = 0
    for _, duration in pairs(active.phaseTimings or {}) do phaseDuration = phaseDuration + (tonumber(duration) or 0) end
    active.phaseDuration = phaseDuration
    details.runtimeMetrics = {
      partsReloadCount = active.partsReloadCount or 0,
      tuningReloadCount = active.tuningReloadCount or 0,
      readbackCount = active.readbackCount or 0,
      repairReloadCount = active.repairReloadCount or 0,
      reloadDuration = active.reloadDuration or 0,
      phaseDuration = active.phaseDuration or 0,
      maxSingleStep = active.maxSingleStep or 0,
      reloadBudget = util.deepCopy(active.reloadBudget),
      semanticProgressSequence = active.progressWatchdog
        and active.progressWatchdog.semanticProgressSequence or 0,
      duplicateCallbackCount = active.progressWatchdog
        and active.progressWatchdog.duplicateSemanticCount or 0,
    }
  end
  setResult(success, code, message, details)
  runtime.progress = {
    operationId = active and active.operationId or runtime.state.operationId,
    raceId = active and active.lineupIndex and runtime.lineup.current and runtime.lineup.current.id or nil,
    phase = success and "complete" or terminalState == "cancelled" and "cancelled" or "failed",
    phaseProgress = 1,
    overallProgress = success and 1 or (runtime.progress.overallProgress or 0),
    value = success and 1 or (runtime.progress.overallProgress or 0),
    slotId = active and active.expectedSlot or nil,
  }
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
      partsReloadCount = active.partsReloadCount or 0,
      tuningReloadCount = active.tuningReloadCount or 0,
      readbackCount = active.readbackCount or 0,
      repairReloadCount = active.repairReloadCount or 0,
      reloadDuration = active.reloadDuration or 0,
      phaseDuration = active.phaseDuration or 0,
      maxSingleStep = active.maxSingleStep or 0,
      reloadBudget = util.deepCopy(active.reloadBudget),
      semanticProgressSequence = active.progressWatchdog
        and active.progressWatchdog.semanticProgressSequence or 0,
      duplicateCallbackCount = active.progressWatchdog
        and active.progressWatchdog.duplicateSemanticCount or 0,
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
    local okSnapshot, spawnSnapshot = adapter.captureCurrentState(
      "lineup", active.seed, active.vehicleId, active.backgroundTarget == true
    )
    local competitor = runtime.lineup.current.competitors[active.lineupIndex]
    if competitor and active.domainContext then
      local candidates = active.domainContext.candidateVehicleIds or {}
      competitor.slotId = tostring(active.lineupIndex)
      competitor.operationId = active.domainContext.operationId
      competitor.generation = active.domainContext.generation
      competitor.derivedSeed = active.seed
      competitor.candidateVehicleId = candidates[#candidates]
      competitor.acceptedVehicleId = active.domainContext.acceptedVehicleId
      competitor.ownedTemporaryIds = util.deepCopy(active.domainContext.ownedTemporaryIds or {})
      competitor.baseline = active.operationOriginalSnapshot and {
        vehicleId = active.operationOriginalSnapshot.vehicleId,
        modelKey = active.operationOriginalSnapshot.modelKey,
        configKey = active.operationOriginalSnapshot.selectedConfiguration,
      } or nil
      competitor.retryCount = math.max(0, (competitor.attemptCount or 0))
    end
    productionModules.raceManager.record(
      runtime.lineup.current, active.lineupIndex, runtime.lastResult, dna, active.lineupTargetGeneration
    )
    if competitor and okSnapshot then competitor.spawnConfig = util.deepCopy(spawnSnapshot.config) end
    if competitor and competitor.dna and runtime.capabilities.dnaWrite then
      local updated = vehicleDNAStorage.add(runtime.dna.library, competitor.dna)
      if updated then
        local saved = adapter.saveDNALibrary(updated, runtime.dna.library)
        if saved then runtime.dna.library = updated; runtime.dna.pending = nil end
      end
    end
    local lineup = runtime.lineup.current
    local accepted = competitor and (
      competitor.status == "ready" or competitor.status == "ready_with_warnings"
        or competitor.status == "partial" and lineup.acceptPartial == true
    )
    if accepted and (type(active.vehicleId) ~= "number"
      or active.vehicleId == active.lineupPlayerVehicleId)
    then
      competitor.status = "failed"
      competitor.phase = "failed"
      competitor.terminalState = "failed"
      competitor.failureCode = "independent_target_missing"
      competitor.validationState = "independent_target_missing"
      competitor.warning = "Generation did not retain an independent competitor vehicle"
      accepted = false
    end
    if accepted and type(active.vehicleId) == "number"
      and active.vehicleId ~= active.lineupPlayerVehicleId
    then
      local entry = productionModules.managedRegistry.findByVehicle(runtime.managedVehicles, active.vehicleId)
      if entry then
        local matches = productionModules.managedRegistry.matchesSlot(
          runtime.managedVehicles, entry.handle, {
            lineupId = lineup.id, competitorId = competitor.id,
            slotId = competitor.slotId or tostring(competitor.index),
            vehicleId = active.vehicleId,
          }
        )
        if not matches then entry = nil end
      end
      local registryReason
      if not entry then
        entry, registryReason = productionModules.managedRegistry.register(runtime.managedVehicles, active.vehicleId, {
          competitorId = competitor.id, lineupCompetitorId = competitor.id,
          lineupId = lineup.id, name = competitor.name, dnaId = competitor.dnaId,
          slotId = competitor.slotId or tostring(competitor.index), generationId = lineup.id,
          episodeSeed = lineup.episodeSeed, slotSeed = competitor.seed,
          modelKey = competitor.modelKey,
          configIdentity = {
            modelKey = competitor.modelKey, configPath = competitor.configuration,
          },
          spawnTransform = util.deepCopy(competitor.stagingPlacement),
          lastKnownState = okSnapshot and util.deepCopy(spawnSnapshot) or {
            vehicleId = active.vehicleId, modelKey = competitor.modelKey,
          },
          config = util.deepCopy(competitor.spawnConfig),
          targetConfirmed = true, validated = true,
        })
      end
      if entry then
        productionModules.managedRegistry.setPending(runtime.managedVehicles, entry.handle, {
          writes = 0, timers = 0, callbacks = 0,
        })
        productionModules.managedRegistry.markReady(
          runtime.managedVehicles, entry.handle, entry.targetGeneration,
          {busy = false, targetConfirmed = true, validated = true}
        )
        competitor.managedHandle = entry.handle
        competitor.currentVehicleId = entry.vehicleId
        competitor.concreteVehicleId = entry.vehicleId
        competitor.raceStatus = "Ready"
        competitor.spawnState = "spawned_and_retained"
        competitor.placementState = "staged"
        competitor.generationReady = true
        competitor.placementReady = true
      else
        competitor.status = "failed"
        competitor.phase = "failed"
        competitor.terminalState = "failed"
        competitor.failureCode = "managed_registry_failed"
        competitor.validationState = "registry_failed"
        competitor.warning = "Generated vehicle could not be registered as an isolated managed competitor"
        competitor.bindingFailureReason = registryReason or "managed_slot_binding_failed"
        accepted = false
      end
    end
    if active.lineupOwnedTarget and not accepted and type(active.vehicleId) == "number"
      and active.vehicleId ~= active.lineupPlayerVehicleId
    then
      local owner = productionModules.domainOperations.ownership(runtime.domainOperations, active.vehicleId)
      if owner and owner.domain == "race" and owner.operationId == active.domainContext.operationId
        and owner.generation == active.domainContext.generation and owner.accepted ~= true
      then productionModules.spawnAdapter.deleteVehicle(active.vehicleId) end
      if competitor then
        competitor.currentVehicleId = nil
        competitor.concreteVehicleId = nil
        competitor.generationReady = false
        competitor.placementReady = false
        competitor.aiReady = false
        competitor.spawnState = "failed_target_removed"
        competitor.placementState = "unavailable"
      end
    end
    if accepted and competitor and type(active.vehicleId) == "number" then
      local dimensions = productionModules.spawnAdapter.vehicleDimensions(
        active.vehicleId, active.targetGeneration or 0
      )
      if type(dimensions) == "table" then
        dimensions.source = "actual_vehicle_bounds"
        competitor.previewDimensions = util.deepCopy(dimensions)
      end
    end
    productionModules.racePreview.update(runtime.racePreview, lineup)
    if active.backgroundTarget and type(active.lineupPlayerVehicleId) == "number" then
      local focused, focusReason = adapter.enterVehicle(active.lineupPlayerVehicleId)
      if not focused then
        lineup.warnings[#lineup.warnings + 1] =
          "The original player vehicle was preserved but could not be re-entered automatically."
        diagnosticsModule.write(runtime.diagnostics, "W", "lineup_player_focus_restore_failed", {
          playerVehicleId = active.lineupPlayerVehicleId, reason = focusReason,
        }, true)
      end
    end
    if terminalState == "cancelled" then
      productionModules.raceManager.cancel(lineup, "Race generation cancelled by user")
      if lineup.settings and lineup.settings.retainAcceptedOnCancel == false then
        production.clearManagedRaceVehicles("race_cancel_policy_cleanup")
      end
    elseif success then
      lineup.consecutiveFailures = 0
    else
      lineup.consecutiveFailures = (lineup.consecutiveFailures or 0) + 1
      if lineup.consecutiveFailures >= (lineup.maxConsecutiveFailures or 4) then
        lineup.active = false
        lineup.generationState = productionModules.raceManager.summary(lineup).ready > 0
          and "lineup_partial" or "lineup_failed"
        lineup.processingState = "lineup_processing_finished"
        lineup.warnings[#lineup.warnings + 1] = "Generation stopped at the consecutive failure limit"
      end
    end
    if type(production.persistCurrentLineup) == "function" then production.persistCurrentLineup() end
    runtime.lineup.pendingNext = lineup.active == true
    lineup.schedulerState = lineup.active and "scheduled" or "finished"
    lineup.schedulerLastProgressAt = runtime.time.realMonotonicTime
    if active.lineupPreviousSettings then runtime.settings = settingsModule.validate(active.lineupPreviousSettings) end
  end
  if active and active.progressWatchdog then progressWatchdog.setStatus(active.progressWatchdog, "terminal") end
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
end

production.currentCatalogFingerprint = function()
  local fingerprint = productionModules.registryCache.fingerprint({
    beamNGVersion = adapter.getGameVersion(), modVersion = EXTENSION_VERSION,
    registryShapeVersion = 1,
    activeModsFingerprint = type(adapter.activeModsFingerprintSource) == "function"
      and adapter.activeModsFingerprintSource() or "active_mods_unavailable",
    contentAliasesVersion = runtime.contentAliases.schemaVersion or 1,
    settingsSchema = runtime.settings.schemaVersion,
  })
  return fingerprint
end

production.restoreRegistryCache = function()
  runtime.catalogFingerprint = production.currentCatalogFingerprint()
  if type(adapter.loadRegistryCache) ~= "function" then
    runtime.indexer.cacheMisses = runtime.indexer.cacheMisses + 1
    return false, "cache_read_unavailable"
  end
  local ok, stored, encodedBytes = adapter.loadRegistryCache()
  if not ok then
    runtime.indexer.cacheMisses = runtime.indexer.cacheMisses + 1
    return false, type(stored) == "table" and stored.code or stored
  end
  local payload, reason = productionModules.registryCache.validate(
    stored, runtime.catalogFingerprint, encodedBytes
  )
  if not payload then runtime.indexer.cacheMisses = runtime.indexer.cacheMisses + 1; return false, reason end
  local restored, counts = contentIndex.restoreCache(runtime.index, payload)
  if not restored then runtime.indexer.cacheMisses = runtime.indexer.cacheMisses + 1; return false, counts end
  runtime.indexer.cacheHits = runtime.indexer.cacheHits + 1
  runtime.performance.indexCacheHits = runtime.performance.indexCacheHits + 1
  runtime.registry.state, runtime.registry.nextAttemptAt = "ready", nil
  runtime.registry.lastCounts = {models = counts.models, configurations = counts.configurations}
  return true, counts
end

local function initialize()
  if runtime.initialized then return end
  runtime.capabilities = adapter.getCapabilities()
  runtime.conflicts = type(adapter.detectKnownConflicts) == "function"
    and adapter.detectKnownConflicts() or {}
  local okCompatibility, compatibilityMetadata = false, nil
  if type(adapter.loadCompatibilityMetadata) == "function" then
    okCompatibility, compatibilityMetadata = adapter.loadCompatibilityMetadata()
  end
  runtime.compatibility = productionModules.compatibility.evaluate(
    okCompatibility and compatibilityMetadata or {}, adapter.getGameVersion()
  )
  local okAliases, aliases = false, nil
  if type(adapter.loadContentAliases) == "function" then okAliases, aliases = adapter.loadContentAliases() end
  runtime.contentAliases = okAliases and aliases or {}
  productionModules.registryReadiness.begin(runtime.registry, adapter.clock(), "extension_load")
  runtime.migrationReport = productionModules.userDataMigration.create(EXTENSION_VERSION)
  local okSettings, stored, settingsSource = adapter.loadSettings()
  if okSettings then
    local sourceVersion = tonumber(stored.schemaVersion) or 0
    runtime.settings = settingsModule.validate(stored)
    if sourceVersion < runtime.settings.schemaVersion and settingsSource ~= "defaults" then
      local saved, saveResult = adapter.saveSettings(settingsModule.forPersistence(runtime.settings))
      productionModules.userDataMigration.record(
        runtime.migrationReport, "settings", sourceVersion, runtime.settings.schemaVersion,
        saved and "migrated" or "failed", {source = settingsSource, persistence = saveResult}
      )
    else
      productionModules.userDataMigration.record(
        runtime.migrationReport, "settings", sourceVersion, runtime.settings.schemaVersion,
        "preserved", {source = settingsSource}
      )
    end
  else
    productionModules.userDataMigration.warning(runtime.migrationReport, "settings_unavailable", stored)
  end
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
        productionModules.userDataMigration.record(
          runtime.migrationReport, "vehicleDNA", storedLibrary.schemaVersion,
          normalized.schemaVersion, "preserved", {source = source}
        )
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
    else
      runtime.dna.loadStatus = "unavailable"
      productionModules.userDataMigration.warning(runtime.migrationReport, "vehicle_dna_unavailable", storedLibrary)
    end
  end
  if type(adapter.loadLineupLibrary) == "function" and runtime.capabilities.lineupRead then
    local okLineups, storedLineups, lineupSource = adapter.loadLineupLibrary()
    if okLineups then
      runtime.lineup.library = productionModules.lineupStorage.load(storedLineups, 20)
      runtime.lineup.loaded = true
      productionModules.userDataMigration.record(
        runtime.migrationReport, "lineups", storedLineups and storedLineups.schemaVersion,
        runtime.lineup.library.schemaVersion, "preserved", {source = lineupSource}
      )
    else
      productionModules.userDataMigration.warning(runtime.migrationReport, "lineups_unavailable", storedLineups)
    end
  end
  if type(adapter.writeMigrationReport) == "function" then
    local reported, reportError = adapter.writeMigrationReport(runtime.migrationReport)
    if not reported then
      productionModules.userDataMigration.warning(runtime.migrationReport, "migration_report_write_failed", reportError)
    end
  end
  runtime.history = historyModule.create(runtime.settings.historyLimit)
  diagnosticsModule.setEnabled(runtime.diagnostics, runtime.settings.diagnosticLogging)
  productionModules.performanceMetrics.setEnabled(runtime.performanceTelemetry, runtime.settings.performanceProfiling)
  runtime.frameBudgets = productionModules.frameBudget.create(runtime.settings.performanceBudgets)
  local cacheHit, cacheResult = production.restoreRegistryCache()
  runtime.initialized = true
  diagnosticsModule.write(runtime.diagnostics, "I", "extension_loaded", {
    extensionVersion = EXTENSION_VERSION,
    gameVersion = adapter.getGameVersion(),
    compatibility = runtime.compatibility,
    capabilities = runtime.capabilities,
    registryCache = {hit = cacheHit, result = cacheResult, fingerprint = runtime.catalogFingerprint},
  }, true)
end

local function rebuildIndex()
  if runtime.indexer.active then return true, {scheduled = true, reason = "already_indexing"} end
  local started = adapter.clock()
  local okRegistry, registry
  if type(adapter.readRegistrySnapshot) == "function" then
    okRegistry, registry = adapter.readRegistrySnapshot()
  else
    okRegistry, registry = adapter.getRegistryData()
    if okRegistry then
      registry.modelsReady, registry.configsReady = true, true
      registry.modelCount, registry.configCount = 1, 1
      registry.issues = {}
    end
  end
  if not okRegistry then
    productionModules.performanceMetrics.record(runtime.performanceTelemetry, "registryIndexing", math.max(0, (adapter.clock() - started) * 1000))
    return false, registry
  end
  local readinessState = productionModules.registryReadiness.observe(runtime.registry, registry, adapter.clock())
  if readinessState ~= "ready" then
    productionModules.performanceMetrics.record(runtime.performanceTelemetry, "registryIndexing", math.max(0, (adapter.clock() - started) * 1000))
    return false, adapter.errorValue(
      readinessState == "failed_confirmed" and "registry_failed_confirmed" or "registry_warming_up",
      readinessState == "failed_confirmed" and "The BeamNG vehicle registry did not become ready within the retry budget"
        or "The BeamNG vehicle registry is still warming up",
      productionModules.registryReadiness.summary(runtime.registry)
    )
  end
  local contentJob = contentIndex.beginBuild(
    runtime.index, registry.models, registry.configs, os.time(), runtime.contentAliases
  )
  local total = #contentJob.models + #contentJob.configs
  local indexStartedAt = adapter.clock()
  productionModules.incrementalIndexer.start(runtime.indexer, total,
    function()
      local ok, progress = contentIndex.stepBuild(contentJob, 1)
      return ok, progress
    end,
    function()
      local ok, counts = contentIndex.finishBuild(contentJob, adapter.clock() - indexStartedAt)
      if not ok then return false, adapter.errorValue("no_eligible_content", "No eligible vehicle configurations were discovered") end
      counts.sources = sourceCounts()
      runtime.performance.indexBuilds = runtime.performance.indexBuilds + 1
      runtime.performance.lastIndexDuration = counts.duration
      runtime.index.stale = false
      diagnosticsModule.write(runtime.diagnostics, "I", "content_index_built", counts, true)
      local payload = contentIndex.cachePayload(runtime.index)
      if payload and type(adapter.saveRegistryCache) == "function" then
        runtime.catalogFingerprint = production.currentCatalogFingerprint()
        local envelope = productionModules.registryCache.envelope(runtime.catalogFingerprint, payload, {
          models = counts.models, configurations = counts.configurations, builtAt = runtime.index.builtAt,
        })
        local saved, saveReason = adapter.saveRegistryCache(envelope)
        diagnosticsModule.write(runtime.diagnostics, saved and "I" or "W", "registry_cache_persisted", {
          saved = saved, reason = saveReason,
        }, not saved)
      end
      if runtime.active and runtime.active.kind == "reindex" then
        finishOperation(true, "reindexed", string.format(
          "Indexed %d vehicles and %d configurations", counts.models, counts.configurations
        ), counts)
      end
      return true, counts
    end,
    {startedAt = indexStartedAt, reason = runtime.active and runtime.active.kind == "reindex" and "manual_reindex" or "registry_rebuild"}
  )
  productionModules.performanceMetrics.record(runtime.performanceTelemetry, "registryIndexing", math.max(0, (adapter.clock() - started) * 1000))
  return true, {scheduled = true, totalItems = total}
end

production.processIncrementalIndex = function()
  if not runtime.indexer.active then return false end
  local started = adapter.clock()
  local ok, result, completed = productionModules.incrementalIndexer.step(
    runtime.indexer, adapter.clock(), adapter.clock,
    runtime.frameBudgets.values.indexChunkBudgetMs, 128
  )
  local elapsedMs = math.max(0, (adapter.clock() - started) * 1000)
  productionModules.performanceMetrics.record(runtime.performanceTelemetry, "registryIndexing", elapsedMs)
  production.recordBudget("registryIndexing", elapsedMs, runtime.frameBudgets.values.indexChunkBudgetMs)
  if runtime.active and runtime.active.kind == "reindex" and runtime.indexer.active then
    local progress = productionModules.incrementalIndexer.snapshot(runtime.indexer).progress
    runtime.progress.label, runtime.progress.value = "Reindexing installed content", 0.1 + progress * 0.8
    production.publishProgress(false)
  end
  if not ok and runtime.active and runtime.active.kind == "reindex" then
    failActive(type(result) == "table" and result or adapter.errorValue(
      "registry_indexing_failed", "Incremental content indexing failed", {reason = result}
    ), false, "index")
  elseif completed and not (runtime.active and runtime.active.kind == "reindex") then
    publishState()
  end
  return true
end

local function ensureIndex()
  if runtime.index.valid and runtime.index.stale ~= true then
    runtime.performance.indexCacheHits = runtime.performance.indexCacheHits + 1
    return true
  end
  local transitioned = operationState.transition(runtime.state, "indexing", false)
  if not transitioned then return false, adapter.errorValue("state_error", "Could not enter indexing state") end
  setProgress("Indexing installed content", 0.08)
  if runtime.registry.state == "unavailable" or runtime.registry.state == "failed_confirmed" then
    productionModules.registryReadiness.begin(runtime.registry, adapter.clock(), "operation_requires_index")
  end
  local scheduled, result = rebuildIndex()
  if scheduled then return false, adapter.errorValue("registry_indexing", "The content catalog is indexing incrementally", result) end
  return false, result
end

local function operationSeed()
  local source = runtime.settings.manualSeed
  local fixed = runtime.settings.seedMode == "fixed"
    or (runtime.settings.seedMode == nil and type(source) == "string" and source ~= "")
  if not fixed or type(source) ~= "string" or source == "" then source = adapter.entropy() end
  local generator = rngModule.new(source)
  return generator.seed, generator, fixed and "fixed_manual_seed" or "automatic_entropy"
end

local function beginOperation(kind, context)
  initialize()
  context = type(context) == "table" and context or {}
  if runtime.state.busy then return false, adapter.errorValue("busy", "Another Chaos Randomizer operation is already running") end
  if runtime.stress and runtime.stress.active and not context.stressIteration then
    return false, adapter.errorValue("stress_active", "Developer stress diagnostics are running")
  end
  if runtime.state.state ~= "idle" then operationState.reset(runtime.state) end
  local okId, currentPlayerVehicleId = adapter.getCurrentVehicleId()
  local vehicleId = context.startWithoutVehicle == true and nil
    or tonumber(context.targetVehicleId) or currentPlayerVehicleId
  local canStartEmpty = kind == "randomConfig" or kind == "fullRandom"
  if ((not okId and context.startWithoutVehicle ~= true) or vehicleId == nil) and not canStartEmpty then
    return false, adapter.errorValue("no_active_vehicle", "Scramble requires an active vehicle. Use Random Car or Spawn Safe Vehicle.")
  end
  if not okId and context.startWithoutVehicle ~= true then vehicleId = nil end
  local domain = production.operationDomain(kind, context)
  if type(vehicleId) == "number" then
    local owner = productionModules.domainOperations.ownership(runtime.domainOperations, vehicleId)
    if owner and owner.domain ~= domain and owner.role == "race_competitor" then
      return false, adapter.errorValue("race_competitor_transfer_required",
        "This vehicle belongs to Race. Remove it from Race or explicitly transfer ownership before using Chaos.", {
          vehicleId = vehicleId, ownerDomain = owner.domain, requestedDomain = domain,
        })
    end
  end
  local seed, generator, seedSource = operationSeed()
  local worldVehicleIdsBefore = type(adapter.worldVehicleIds) == "function"
    and adapter.worldVehicleIds() or {}
  runtime.lastSeed = seed
  local operationTimeout = context.operationTimeout
    or productionModules.stabilityLimits.operationTimeoutMs(runtime.stabilityLimits, kind, domain) / 1000
  operationTimeout = math.min(
    operationTimeout, runtime.stabilityLimits.maxOperationWallClockMs / 1000
  )
  local phaseTimeout = context.phaseTimeout or WAIT_TIMEOUT
  local initialLoadTimeout = context.initialLoadTimeout
    or ((kind == "randomConfig" or kind == "fullRandom" or domain == "race") and 45)
    or phaseTimeout
  local ok, token = operationState.begin(runtime.state, kind, vehicleId, operationTimeout)
  if not ok then return false, adapter.errorValue("busy", "Another operation is already running") end
  local previousDetails = runtime.lastResult and runtime.lastResult.details or nil
  runtime.active = {
    token = token,
    kind = kind,
    seed = seed,
    rng = generator,
    retryRng = generator:fork("retry"),
    rngSubstreams = {
      modelConfig = "vehicle/configuration",
      parts = "parts:pass",
      tuning = "tuning:pass",
      paint = "paint",
      retry = "retry",
    },
    seedSource = seedSource,
    selectionSubstream = "vehicle_selection:operation:" .. tostring(runtime.state.operationGeneration),
    previousResultIdentity = previousDetails and selectionIdentity(
      previousDetails.model,
      previousDetails.configuration or (previousDetails.baseConfiguration and previousDetails.baseConfiguration.path)
    ) or nil,
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
    startedSimulationAt = runtime.time.simulationTime,
    phaseStartedAt = runtime.time.realMonotonicTime,
    phaseStartedSimulationAt = runtime.time.simulationTime,
    lastAcceptedCheckpoint = "operation_started",
    operationId = runtime.state.operationId,
    operationGeneration = runtime.state.operationGeneration,
    phaseGeneration = runtime.state.phaseGeneration,
    targetGeneration = runtime.state.targetGeneration,
    recoveryOnly = false,
    progressWatchdog = progressWatchdog.create(runtime.time.realMonotonicTime, {
      warningAfter = kind == "randomConfig" and 5 or 10,
      stalledAfter = kind == "randomConfig" and 15 or 30,
      operationDeadline = runtime.time.realMonotonicTime + operationTimeout,
    }),
    phase = kind == "scramble" and "parts" or "selection",
    stressIteration = context.stressIteration,
    waitTimeout = phaseTimeout,
    initialLoadTimeout = initialLoadTimeout,
    operationTimeout = operationTimeout,
    lineupExcludedModels = util.deepCopy(context.lineupExcludedModels),
    lineupExcludedConfigurations = util.deepCopy(context.lineupExcludedConfigurations),
    lineupRules = util.deepCopy(context.lineupRules),
    lineupAcceptedCompetitors = util.deepCopy(context.lineupAcceptedCompetitors),
    lineupIndex = context.lineupIndex,
    lineupSeed = context.lineupSeed,
    lineupAttempt = context.lineupAttempt,
    lineupTargetGeneration = context.lineupTargetGeneration,
    lineupPreviousSettings = util.deepCopy(context.lineupPreviousSettings),
    lineupPlayerVehicleId = context.lineupPlayerVehicleId or currentPlayerVehicleId,
    lineupOwnedTarget = context.lineupOwnedTarget == true,
    backgroundTarget = context.backgroundTarget == true,
    backgroundTargetVehicleId = nil,
    unboundSpawnCallbacks = {},
    ignoredBackgroundCallbacks = 0,
    lineupStagingPlacement = util.deepCopy(context.lineupStagingPlacement),
    racePermissiveDrivability = context.racePermissiveDrivability == true,
    reloadCount = 0,
    partsReloadCount = 0,
    tuningReloadCount = 0,
    readbackCount = 0,
    repairReloadCount = 0,
    reloadDuration = 0,
    phaseDuration = 0,
    maxSingleStep = 0,
    reloadBudget = {
      mutationTarget = 1, repairLimit = 1, hardLimit = 4, hardLimitReached = false,
      coherentBatchCount = 0, largestCoherentBatch = 0, plannedPartWrites = 0,
      perWriteReloadsPrevented = 0,
    },
    partPassesApplied = 0,
    safetyBaseline = nil,
    safetyResult = nil,
    finalSafetyGate = productionModules.safetyGate.create({maxAttempts = 3, retryWindow = 1.5, retryDelay = 0.1}),
    partsSafetyGate = productionModules.safetyGate.create({maxAttempts = 3, retryWindow = 1.0, retryDelay = 0.05}),
    phaseTimings = {},
    startedWithoutVehicle = context.startWithoutVehicle == true or vehicleId == nil,
    batchRecovery = partBatchRecovery.create(),
    treeStabilizer = vehicleStabilizer.create({persistentTreeScans = 2}),
    safeOfficial = context.safeOfficial == true,
    stageReasons = {},
    coverageLimits = coverageLimits.copyDefaults(),
    slotLedger = slotCoverageLedger.create({}),
    tuningLedger = tuningCoverageLedger.create(),
    paintLedger = nil,
    convergence = treeConvergence.create(coverageLimits.copyDefaults(), adapter.clock()),
    baselines = productionModules.baselineSemantics.create(nil),
    criticalRepairAttempts = {},
    engineFluidEvidence = nil,
    domain = domain,
    expectedSlot = context.expectedSlot or context.lineupIndex,
    worldVehicleIdsBefore = util.deepCopy(worldVehicleIdsBefore),
    stabilityLimits = util.deepCopy(runtime.stabilityLimits),
  }
  local domainContext, superseded = productionModules.domainOperations.begin(runtime.domainOperations, {
    domain = domain,
    operationId = runtime.state.operationId,
    action = kind,
    expectedSlot = context.expectedSlot or context.lineupIndex,
    expectedLogicalTarget = context.expectedLogicalTarget,
    sourceVehicleId = vehicleId,
    seed = seed,
    createdAt = runtime.time.realMonotonicTime,
    worldVehicleIdsBefore = util.deepCopy(worldVehicleIdsBefore),
  })
  if not domainContext then
    operationState.finish(runtime.state, "failed", superseded)
    runtime.active = nil
    return false, adapter.errorValue(superseded, "The operation domain context could not start")
  end
  runtime.active.domainContext = domainContext
  runtime.active.domainGeneration = domainContext.generation
  runtime.active.callbackToken = production.domainCallbackToken(runtime.active, "operation")
  if type(vehicleId) == "number" then
    productionModules.domainOperations.ownVehicle(runtime.domainOperations, vehicleId, {
      domain = domain, operationId = domainContext.operationId, generation = domainContext.generation,
      role = "player_source", managed = false, created = false, accepted = false,
    })
  end
  runtime.active.operationContext = productionModules.operationContext.create(
    runtime.state, token, runtime.time.realMonotonicTime, {
      domain = domain,
      action = kind,
      generation = domainContext.generation,
      expectedSlot = context.expectedSlot or context.lineupIndex,
      expectedLogicalTarget = context.expectedLogicalTarget,
      sourceVehicleId = vehicleId,
      worldVehicleIdsBefore = util.deepCopy(worldVehicleIdsBefore),
    }
  )
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
    domain = domain,
    domainGeneration = domainContext.generation,
    supersededOperation = superseded and superseded.operationId or nil,
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
  local ok, snapshot = adapter.captureCurrentState(
    active.kind, active.seed, active.vehicleId, active.backgroundTarget == true
  )
  if not ok then return false, snapshot end
  vehicleRecovery.rememberReadable(runtime.recovery, snapshot)
  active.operationOriginalSnapshot = util.deepCopy(snapshot)
  active.baselines.originalPlayerVehicle = util.deepCopy(snapshot)
  local logicalTarget = targetDescriptor(snapshot)
  logicalTarget.vehicleId = nil
  operationState.nextTarget(runtime.state, logicalTarget)
  active.targetGeneration = runtime.state.targetGeneration
  local context = production.ensureOperationContext(active)
  context.originalSnapshot = util.deepCopy(snapshot)
  productionModules.operationContext.beginLogicalTarget(context, runtime.state, logicalTarget, runtime.time.realMonotonicTime)
  active.operationCurrentTarget = util.deepCopy(productionModules.operationContext.bindInitial(
    context, runtime.state, util.shallowMerge(targetDescriptor(snapshot), {
      source = "captured_original", coherentTargetRead = snapshot.coherentTargetRead ~= false,
    }), runtime.time.realMonotonicTime
  ))
  active.logicalTarget = util.deepCopy(context.logicalTarget)
  active.targetOwnershipConfirmed = true
  runtime.state.expectedTarget = util.deepCopy(logicalTarget)
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
      if allowedByCircuit and not vehicleRecovery.isQuarantined(runtime.recovery, config.modelKey, config.key)
        and not productionModules.domainOperations.isQuarantined(
          runtime.domainOperations, active.domain, config.modelKey, config.key
        )
      then
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
    local filtered, variety = productionModules.raceManager.filterModels(
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
  local manualSeed = active.seedSource == "fixed_manual_seed"
  local recentPairs = active.kind == "randomConfig" and runtime.recentRandomCarResults
    or active.kind == "fullRandom" and runtime.recentFullRandomBaseResults or {}
  local recentPairFilterApplied = false
  if not manualSeed and not active.replayGeneration and not active.lineupRules then
    models, recentPairFilterApplied = withoutRecentPairs(models, recentPairs)
  end
  local recentModels = active.lineupExcludedModels or (manualSeed and {} or runtime.recentModels)
  local recentConfigs = active.lineupExcludedConfigurations or (manualSeed and {} or runtime.recentConfigs)
  active.selectionContext = {
    fairness = runtime.settings.selectionFairness,
    contentFilter = runtime.settings.contentFilter,
    manualSeed = manualSeed,
    recentPolicy = manualSeed and "ignored_for_manual_seed" or "bounded_session_recent",
    eligibleModels = #models,
    vehicleLock = vehicleLocked,
    recentPairFilterApplied = recentPairFilterApplied,
    selectionSubstream = active.selectionSubstream,
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
        and not productionModules.domainOperations.isQuarantined(
          runtime.domainOperations, active.domain, config.modelKey, config.key
        )
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
  active.reloadStartedAt = runtime.time.realMonotonicTime
  active.afterReload = afterReload
  local target = (phase == "spawn" or phase == "rollback" or phase == "undo" or phase == "dna_base_spawn")
    and "waitingForVehicle" or "waitingForReload"
  local waitTimeout = (phase == "spawn" or phase == "dna_base_spawn")
      and (active.initialLoadTimeout or active.waitTimeout)
    or active.waitTimeout or WAIT_TIMEOUT
  active.currentWaitTimeout = waitTimeout
  local ok, transitionError = operationState.transition(runtime.state, target, waitTimeout)
  if not ok then return false, adapter.errorValue("state_error", transitionError) end
  local lifecyclePhase = (
      phase == "parts" or phase == "part_isolation_test"
      or phase == "part_batch_rollback" or phase == "dna_parts" or phase == "critical_repair"
    ) and "waiting_parts_reload"
    or (phase == "tuning" or phase == "dna_tuning" or phase == "fuel_guard") and "waiting_tuning_reload"
    or (phase == "rollback") and (
      (active.recoveryTier or 6) <= 3 and "recovering_previous"
      or active.recoveryStep == "explicit_safe_baseline" and "recovering_last_completed_good"
      or "recovering_fallback"
    )
    or "tracking_target_identity"
  setLifecyclePhase(active, lifecyclePhase, waitTimeout, "wait:" .. tostring(phase))
  active.phaseCallbackTokens = {
    onVehicleSpawned = production.domainCallbackToken(active, "onVehicleSpawned", {
      expectedSlot = active.expectedSlot,
    }),
    onVehicleSwitched = production.domainCallbackToken(active, "onVehicleSwitched", {
      expectedSlot = active.expectedSlot,
    }),
  }
  if phase == "parts" or phase == "part_isolation_test" or phase == "part_batch_rollback"
    or phase == "dna_parts" or phase == "critical_repair"
  then
    active.readBackStatus = "parts_reload_pending"
  elseif phase == "tuning" or phase == "dna_tuning" or phase == "fuel_guard" then
    active.readBackStatus = "tuning_reload_pending"
  else
    active.readBackStatus = "target_identity_unstable"
  end
  expected = util.shallowMerge(expected or {}, {
    token = active.token,
    phase = phase,
    eventType = "onVehicleSpawned",
    startedAt = adapter.clock(),
  })
  local createsTarget = phase == "spawn" or phase == "rollback" or phase == "undo" or phase == "dna_base_spawn"
  local expectedTarget = {
    modelKey = expected.modelKey,
    configIdentity = util.deepCopy(expected.configIdentity),
    configKey = configVerification.stableKey(
      expected.configKey or (expected.configIdentity and expected.configIdentity.path)
    ),
  }
  if createsTarget then
    operationState.nextTarget(runtime.state, expectedTarget)
    active.targetGeneration = runtime.state.targetGeneration
  end
  active.phaseGeneration = runtime.state.phaseGeneration
  local context = production.ensureOperationContext(active)
  if context.concreteTarget == nil and active.operationCurrentTarget then
    productionModules.operationContext.bindInitial(context, runtime.state, active.operationCurrentTarget, runtime.time.realMonotonicTime)
  end
  local contextWait, logicalTarget = productionModules.operationContext.beginWait(
    context, runtime.state, expectedTarget, phase, runtime.time.realMonotonicTime
  )
  active.reloadWriteTarget = util.deepCopy(contextWait.writeTarget or active.operationCurrentTarget)
  active.logicalTarget = util.deepCopy(logicalTarget)
  active.operationCurrentTarget = nil
  active.operationRecoveryTarget = active.recoveryOnly and nil or active.operationRecoveryTarget
  active.targetOwnershipConfirmed = false
  active.vehicleId = nil
  runtime.state.vehicleId = nil
  runtime.state.expectedTarget = util.deepCopy(logicalTarget)
  active.waitContext = operationState.captureContext(runtime.state, expectedTarget)
  expected.vehicleId = nil
  active.wait = lifecycle.createExpectation(expected)
  active.wait.context = util.deepCopy(active.waitContext)
  local expectedTuningMetadata = {}
  for _, change in ipairs(active.pendingTuningChanges or {}) do
    expectedTuningMetadata[change.name] = {
      minimum = change.minimum, maximum = change.maximum,
      tolerance = change.step and math.max(change.step * 0.45, 1e-9) or 1e-7,
    }
  end
  active.targetTracker = vehicleTargetTracker.create({
    token = active.token,
    operationId = runtime.state.operationId,
    operationGeneration = runtime.state.operationGeneration,
    phaseGeneration = runtime.state.phaseGeneration,
    targetGeneration = runtime.state.targetGeneration,
    phase = phase,
    vehicleId = nil,
    modelKey = active.wait.modelKey,
    configKey = active.wait.configKey,
    configIdentity = active.wait.configIdentity,
    parts = active.wait.parts,
    tuning = active.wait.tuning,
    tuningMetadata = expectedTuningMetadata,
    originalVehicleId = active.reloadWriteTarget and active.reloadWriteTarget.vehicleId,
    startedAt = active.wait.startedAt,
    timeout = active.waitTimeout or WAIT_TIMEOUT,
    recoveryOnly = active.recoveryOnly == true,
    stabilizer = {minimumFrames = 5, minimumScans = 2, pollInterval = 0.05, persistentTreeScans = 2},
    treeStabilizer = {minimumFrames = 2, minimumScans = 2, pollInterval = 0},
    requirePartsReadable = next(active.wait.parts or {}) ~= nil
      or (createsTarget and afterReload ~= "randomConfig"),
    requirePowertrainAvailable = active.safetyBaseline ~= nil
      and (active.safetyBaseline.classification == "drivable_combustion"
        or active.safetyBaseline.classification == "drivable_electric"
        or active.safetyBaseline.classification == "drivable_hybrid"),
    requireEnergyStorageAvailable = active.safetyBaseline ~= nil
      and (active.safetyBaseline.classification == "drivable_combustion"
        or active.safetyBaseline.classification == "drivable_electric"
        or active.safetyBaseline.classification == "drivable_hybrid"),
    coherentSamples = 2,
  })
  if active.reloadWriteTarget and active.reloadWriteTarget.vehicleId then
    vehicleTargetTracker.addCandidate(active.targetTracker, active.reloadWriteTarget.vehicleId, "reload_origin", {
      observedAt = runtime.time.realMonotonicTime,
      modelKey = active.reloadWriteTarget.modelKey,
      configKey = active.reloadWriteTarget.configKey,
    })
  end
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

local function recordReplacementCandidate(active, result, phase)
  if type(result) ~= "table" then return false, adapter.errorValue("vehicle_replace_rejected", "The replacement request returned no result") end
  active.expectedReplacementVehicleId = result.vehicleId
  active.replaceRequestModel = active.wait and active.wait.modelKey
  active.replaceRequestConfig = active.wait and (active.wait.configIdentity or active.wait.configKey)
  active.replaceIssuedAt = adapter.clock()
  active.replaceCorrelationStrategy = result.correlationStrategy
  active.spawnTransaction = util.deepCopy(result.spawnTransaction)
  local operationContext = production.ensureOperationContext(active)
  operationContext.spawnTransaction = util.deepCopy(result.spawnTransaction)
  if result.spawnTransaction then
    operationContext.requestedModel = result.spawnTransaction.requestedModel
    operationContext.requestedConfig = util.deepCopy(result.spawnTransaction.requestedConfig)
    operationContext.requestedPlacement = util.deepCopy(result.spawnTransaction.requestedPlacement)
    operationContext.worldVehicleIdsBefore = util.deepCopy(result.spawnTransaction.worldVehicleIdsBefore)
    operationContext.worldVehicleIdsAfter = util.deepCopy(result.spawnTransaction.worldVehicleIdsAfter)
    operationContext.returnedObjectEvidence = result.spawnTransaction.returnedObjectEvidence
    operationContext.returnedVehicleId = result.spawnTransaction.returnedVehicleId
    operationContext.rejectedVehicleIds = util.deepCopy(result.spawnTransaction.rejectedVehicleIds)
    operationContext.spawnOutcome = result.spawnTransaction.outcome
    local afterIds = result.spawnTransaction.worldVehicleIdsAfter or {}
    local present = {}
    for _, worldId in ipairs(afterIds) do present[tostring(worldId)] = true end
    for _, ownedId in ipairs(active.domainContext and active.domainContext.ownedTemporaryIds or {}) do
      if not present[tostring(ownedId)] then
        productionModules.domainOperations.recordRemoval(
          runtime.domainOperations, ownedId, "replacement_world_snapshot_absent"
        )
      end
    end
  end
  if active.targetTracker and type(result.vehicleId) == "number" then
    vehicleTargetTracker.bindReturned(active.targetTracker, result.vehicleId, result.correlationStrategy)
  end
  if type(result.vehicleId) == "number" then
    productionModules.domainOperations.expectAddition(active.domainContext, result.vehicleId)
    if active.backgroundTarget and type(active.lineupPlayerVehicleId) == "number" then
      local isolated, isolation = productionModules.raceFocusGuard.restore({
        playerVehicleId = active.lineupPlayerVehicleId,
        candidateVehicleId = result.vehicleId,
        getCurrentVehicleId = adapter.getCurrentVehicleId,
        enterVehicle = adapter.enterVehicle,
      })
      active.playerFocusIsolation = util.deepCopy(type(isolation) == "table" and isolation or {
        reason = isolation,
      })
      if not isolated then
        return false, adapter.errorValue(isolation,
          "Race generation could not restore the preserved player focus", {
            playerVehicleId = active.lineupPlayerVehicleId,
            candidateVehicleId = result.vehicleId,
          })
      end
    end
    if active.backgroundTarget then
      for _, token in pairs(active.phaseCallbackTokens or {}) do token.expectedVehicleId = result.vehicleId end
    end
    local callbackToken = production.domainCallbackToken(active, phase, {
      expectedSlot = active.expectedSlot, expectedVehicleId = result.vehicleId,
    })
    if callbackToken then
      local registered, registerReason = productionModules.domainOperations.registerCandidate(
        runtime.domainOperations, callbackToken, result.vehicleId, {
          source = "replace_return", created = result.vehicleId ~= active.originalVehicleId,
          observedAt = runtime.time.realMonotonicTime,
        }
      )
      if not registered then
        if registerReason == "owned_temporary_cardinality_violation" then
          productionModules.spawnAdapter.deleteVehicle(result.vehicleId)
        end
        return false, adapter.errorValue(registerReason, "The replacement candidate belongs to a stale or foreign operation")
      end
    end
    productionModules.operationContext.recordCandidate(production.ensureOperationContext(active), runtime.state, {
      vehicleId = result.vehicleId,
      source = "replace_return",
      observedAt = runtime.time.realMonotonicTime,
      operationId = runtime.state.operationId,
      operationGeneration = runtime.state.operationGeneration,
      targetGeneration = runtime.state.targetGeneration,
      modelKey = active.wait and active.wait.modelKey or active.modelKey,
      configKey = active.wait and active.wait.configKey,
      configIdentity = active.wait and active.wait.configIdentity,
      readStatus = "candidate_only",
      correlationEvidence = {strategy = result.correlationStrategy},
    })
  end
  if active.backgroundTarget and phase == "spawn" and type(result.vehicleId) == "number" then
    active.backgroundTargetVehicleId = result.vehicleId
    for _, callbackVehicleId in ipairs(active.unboundSpawnCallbacks or {}) do
      if callbackVehicleId ~= result.vehicleId then
        active.ignoredBackgroundCallbacks = active.ignoredBackgroundCallbacks + 1
      end
    end
    active.unboundSpawnCallbacks = {}
  end
  noteProgress(active, "target", "replacement_candidate_recorded")
  diagnosticsModule.write(runtime.diagnostics, "D", "replacement_candidate_recorded", {
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
  active.replaceTargetVehicleId = active.reloadWriteTarget and active.reloadWriteTarget.vehicleId
    or active.vehicleId
  local capacity, capacityReason = productionModules.domainOperations.canCreateTemporary(
    runtime.domainOperations, active.domainContext, active.replaceTargetVehicleId
  )
  if not capacity then
    return false, adapter.errorValue(capacityReason,
      "The operation already owns a live temporary vehicle and cannot create another")
  end
  active.replaceWriteInFlight = true
  local ok, result = adapter.replaceVehicle(
    modelKey, config, active.replaceTargetVehicleId,
    phase == "spawn" and active.lineupStagingPlacement or nil
  )
  active.replaceWriteInFlight = false
  if not ok then return false, result end
  local recorded, recordError = recordReplacementCandidate(active, result, phase)
  if not recorded then return false, recordError end
  if active.backgroundTarget and phase == "spawn" and type(result.vehicleId) == "number"
    and type(active.lineupStagingPlacement) == "table"
  then
    local placed, placementReason = productionModules.spawnAdapter.placeVehicle(
      result.vehicleId, active.lineupStagingPlacement
    )
    if not placed then
      return false, adapter.errorValue("lineup_staging_apply_failed",
        "The Race candidate could not be moved to its owned staging slot", {
          vehicleId = result.vehicleId, expectedSlot = active.expectedSlot,
          reason = placementReason,
        })
    end
    active.stagingPlacementApplied = true
    active.stagingPlacementVehicleId = result.vehicleId
    noteProgress(active, "binding", "candidate_staging_placement_requested")
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
  if step.kind == "hard_failure" then
    local cycleReason = vehicleRecovery.metrics(runtime.recovery).recoveryCycleReason
    finishOperation(false, cycleReason and "recovery_loop_detected" or "vehicle_recovery_failed",
      cycleReason and "Recovery stopped after detecting a repeated target state"
        or "The operation and all bounded vehicle recovery attempts failed", {
        originalFailure = active.rollbackFailure,
        recovery = vehicleRecovery.metrics(runtime.recovery),
        attempts = (active.recoveryIndex or 1) - 1,
        recoveryTier = 6,
      })
    return false
  end
  local accepted, recoveryReason = vehicleRecovery.observeRecoveryStep(
    runtime.recovery, runtime.state.operationId, active.recoveryGeneration, step
  )
  if not accepted then
    diagnosticsModule.write(runtime.diagnostics, "E", recoveryReason, {
      step = step.kind, tier = step.tier, attempt = active.recoveryIndex,
      recoveryGeneration = active.recoveryGeneration,
    }, true)
    return startNextRecovery(active)
  end
  local snapshot = step.snapshot or {}
  if step.kind == "local_rollback" then
    local readable, currentSnapshot = adapter.captureCurrentState(
      "recovery_local_check", active.seed, active.vehicleId, active.backgroundTarget == true
    )
    if readable and vehicleRecovery.targetStateFingerprint(currentSnapshot) == step.fingerprint then
      active.recoveryStep = step.kind
      active.recoveryTier = step.tier
      active.recoverySnapshot = util.deepCopy(snapshot)
      vehicleRecovery.rememberReadable(runtime.recovery, currentSnapshot)
      historyTransaction.rollbackSucceeded(active, runtime.history, historyModule.pop)
      local originalFailure = active.rollbackFailure
        or failureRecord(active, "rollback", adapter.errorValue("operation_failed", "Operation failed"))
      finishOperation(false, originalFailure.code,
        originalFailure.message .. "; current target restored to its clean candidate baseline", {
          rollback = "completed",
          recoveryStep = step.kind,
          recoveryTier = step.tier,
          recoveryOutcome = "continued_current_target_at_verified_baseline",
          locksRequireReview = false,
          originalFailure = originalFailure,
        })
      return true
    end
  end
  if step.kind == "original_player_vehicle" and active.domain == "chaos" then
    local sourceId = tonumber(active.operationOriginalSnapshot and active.operationOriginalSnapshot.vehicleId)
      or tonumber(active.originalVehicleId)
    if sourceId and productionModules.spawnAdapter.objectExists(sourceId) then
      local focused, focusReason = adapter.enterVehicle(sourceId)
      if focused then
        active.vehicleId = sourceId
        runtime.state.vehicleId = sourceId
        active.operationCurrentTarget = {
          vehicleId = sourceId,
          modelKey = snapshot.modelKey,
          source = "existing_player_source_reused",
        }
        for _, candidateId in ipairs(active.domainContext and active.domainContext.candidateVehicleIds or {}) do
          if candidateId ~= sourceId then
            productionModules.domainOperations.markOrphan(
              runtime.domainOperations, candidateId, "rollback_reused_existing_source"
            )
          end
        end
        local cleanup = production.reapOwnedOrphans(active, "rollback_reused_existing_source")
        productionModules.domainOperations.rollback(
          active.domainContext, sourceId, active.rollbackFailure and active.rollbackFailure.code
        )
        historyTransaction.rollbackSucceeded(active, runtime.history, historyModule.pop)
        local originalFailure = active.rollbackFailure
          or failureRecord(active, "rollback", adapter.errorValue("operation_failed", "Operation failed"))
        finishOperation(false, originalFailure.code,
          originalFailure.message .. "; the existing player source was reused without spawning another vehicle", {
            rollback = "completed",
            recoveryStep = step.kind,
            recoveryTier = step.tier,
            recoveryOutcome = "existing_player_source_reused",
            cleanupResult = cleanup,
            originalFailure = originalFailure,
          })
        return true
      end
      diagnosticsModule.write(runtime.diagnostics, "W", "existing_source_focus_failed", {
        vehicleId = sourceId, reason = focusReason,
      }, true)
    end
  end
  local configValue = snapshot.config or snapshot.selectedConfiguration
  if type(configValue) == "table" and configValue.path then configValue = configValue.path end
  local configIdentity
  if step.kind == "safe_official_fallback" and type(snapshot.config) == "table" then
    configIdentity = adapter.prepareConfigExpectation(snapshot.config)
  end
  local okTransition = operationState.transition(runtime.state, "rollingBack", false)
  if not okTransition then runtime.state.state = "rollingBack" end
  active.phase = "rollback"
  active.recoveryStep = step.kind
  active.recoveryTier = step.tier
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
    step = step.kind, tier = step.tier, attempt = active.recoveryIndex, modelKey = snapshot.modelKey,
    recoveryGeneration = active.recoveryGeneration,
  }, true)
  return true
end

local function beginRollback(failure)
  local active = runtime.active
  if not active then return end
  active.rollbackFailure = failure
  if active.selectedConfig then
    vehicleRecovery.quarantine(
      runtime.recovery,
      active.selectedConfig.modelKey or (active.selectedModel and active.selectedModel.key),
      active.selectedConfig.key,
      failure.code
    )
  end
  local failedOperationGeneration = runtime.state.operationGeneration
  active.token = operationState.invalidate(runtime.state, "recovery_started", {
    operation = true,
    target = true,
  })
  active.operationGeneration = runtime.state.operationGeneration
  active.phaseGeneration = runtime.state.phaseGeneration
  active.targetGeneration = runtime.state.targetGeneration
  vehicleRecovery.invalidateForRecovery(active)
  active.failedOperationGeneration = failedOperationGeneration
  active.recoveryGeneration = vehicleRecovery.beginRecovery(
    runtime.recovery, runtime.state.operationId, runtime.state.operationGeneration
  )
  local recoveryContext = productionModules.baselineSemantics.recoveryContext(
    active.baselines or productionModules.baselineSemantics.create(active.operationOriginalSnapshot),
    active.operationCurrentSnapshot or active.operationCandidateBase
  )
  recoveryContext.explicitBaselineSnapshot = runtime.recovery.lastCompletedGoodSnapshot
  recoveryContext.transient = false
  active.recoverySteps = vehicleRecovery.choosePlan(runtime.recovery, recoveryContext, runtime.index.allConfigs)
  active.recoveryIndex = 0
  setLifecyclePhase(active, "rolling_back_operation", false, "recovery_started")
  diagnosticsModule.write(runtime.diagnostics, "W", "recovery_pipeline_invalidated", {
    operationId = runtime.state.operationId,
    operationGeneration = runtime.state.operationGeneration,
    phaseGeneration = runtime.state.phaseGeneration,
    targetGeneration = runtime.state.targetGeneration,
    recoveryOnly = true,
    failedOperationGeneration = failedOperationGeneration,
    recoveryGeneration = active.recoveryGeneration,
  }, true)
  startNextRecovery(active)
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
  local okApply, applyError = adapter.applyPartsTree(
    treeOrReason, active.reloadWriteTarget and active.reloadWriteTarget.vehicleId,
    active.backgroundTarget == true
  )
  if not okApply then
    partBatchRecovery.finishRollback(active.batchRecovery, false)
    return false, applyError.code or "part_batch_rollback_failed"
  end
  noteSuccessfulWrite(active, "part_batch_rollback")
  return true, "part_batch_rollback_started"
end

local function attemptCriticalRepair(active, currentSnapshot, currentScan, failures, continuation)
  if not active or type(currentScan) ~= "table" then return false, "critical_repair_scan_missing" end
  local fingerprint = safetyFailureFingerprint(failures)
  active.criticalRepairAttempts = active.criticalRepairAttempts or {}
  local attempts = (active.criticalRepairAttempts[fingerprint] or 0) + 1
  active.criticalRepairAttempts[fingerprint] = attempts
  if attempts > 1 then return false, "critical_repair_already_attempted" end

  local sourceSnapshot, sourceType
  if active.batchRecovery and active.batchRecovery.currentBatch
    and type(active.batchRecovery.currentBatch.treeBefore) == "table"
  then
    sourceSnapshot = {partsTree = active.batchRecovery.currentBatch.treeBefore}
    sourceType = "current_mutation_attempt_start"
  else
    sourceSnapshot, sourceType = productionModules.baselineSemantics.repairSource(active.baselines)
  end
  if type(sourceSnapshot) ~= "table" or type(sourceSnapshot.partsTree) ~= "table" then
    return false, "critical_repair_source_missing"
  end
  local sourceScan, sourceError = slotScanner.scan(
    sourceSnapshot.partsTree, currentSnapshot and currentSnapshot.metadataByPath
  )
  if not sourceScan then return false, sourceError or "critical_repair_source_scan_failed" end
  local repairPlan, planReason, planDetails = productionModules.criticalRepair.plan(
    currentScan, sourceScan, failures, sourceType
  )
  if not repairPlan then
    diagnosticsModule.write(runtime.diagnostics, "E", planReason, {
      failures = failures, sourceType = sourceType, details = planDetails,
    }, true)
    return false, planReason
  end
  if runtime.state.state == "waitingForReload" then operationState.transition(runtime.state, "scanning", false) end
  if runtime.state.state == "scanning" or runtime.state.state == "validating" then
    operationState.transition(runtime.state, "mutating", false)
  end
  active.criticalRepairPlan = util.deepCopy(repairPlan)
  active.criticalRepairSourceType = sourceType
  active.criticalRepairContinuation = continuation or "parts"
  active.criticalRepairOriginPhase = active.phase
  active.criticalRepairFailures = util.deepCopy(failures)
  local okWait, waitError = enterWaiting(active, "critical_repair", continuation or "parts", {
    vehicleId = active.vehicleId,
    modelKey = active.modelKey or (active.selectedModel and active.selectedModel.key),
    parts = adapter.flattenChosenParts(repairPlan.tree),
  }, "Repairing the proven functional dependency", 0.94)
  if not okWait then return false, waitError.code or "critical_repair_wait_failed" end
  bindMutationPlan(active, "critical_repair")
  local guardOk, guardError = guardMutationWrite(active, "critical_repair")
  if not guardOk then return false, guardError.code or "critical_repair_target_changed" end
  local applied, applyError = adapter.applyPartsTree(
    repairPlan.tree, active.reloadWriteTarget and active.reloadWriteTarget.vehicleId,
    active.backgroundTarget == true
  )
  if not applied then return false, applyError.code or "critical_repair_apply_failed" end
  noteSuccessfulWrite(active, "critical_repair")
  diagnosticsModule.write(runtime.diagnostics, "W", "critical_dependency_repair_started", {
    sourceType = sourceType, repairs = repairPlan.repairs,
    retainedMutationCount = repairPlan.retainedMutationCount,
    failures = failures,
  }, true)
  return true, "critical_repair_started"
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
  local okApply, applyError = adapter.applyPartsTree(
    tree, active.reloadWriteTarget and active.reloadWriteTarget.vehicleId,
    active.backgroundTarget == true
  )
  if not okApply then failActive(applyError, true, "parts") end
  if okApply then noteSuccessfulWrite(active, "part_isolation_test") end
  return true
end

failActive = function(errorData, attemptRollback, phase, context)
  local active = runtime.active
  local failure = failureRecord(active, phase, errorData, context)
  runtime.lastFailure = failure
  if failure.phase == "spawn" and active and active.selectedConfig then
    vehicleRecovery.recordLoadFailure(runtime.recovery, {
      modelKey = active.selectedConfig.modelKey,
      configKey = active.selectedConfig.key,
    }, failure.code)
    if active.domainContext then
      local quarantined, quarantineRecord = productionModules.domainOperations.quarantine(
        runtime.domainOperations, active.domainContext,
        active.selectedConfig.modelKey or (active.selectedModel and active.selectedModel.key),
        active.selectedConfig.key, failure.code, runtime.time.realMonotonicTime
      )
      if quarantined then
        diagnosticsModule.write(runtime.diagnostics, "W", "config_quarantined", quarantineRecord, true)
      end
    end
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
  local config = active.selectedConfig or {}
  return {
    type = model.type or model.Type or model.Category or model.category,
    isAutomation = model.isAutomation,
    isTrailer = model.isTrailer,
    isProp = model.isProp,
    configKey = config.key or config.path,
    configName = config.name,
    description = config.description or config.Description,
    usage = config.usage or config.Usage,
    intentionalNonDrivable = config.intentionalNonDrivable == true,
  }
end

production.safetyEvidence = function(active, snapshot)
  local stableSamples = active.lastTargetMetrics and active.lastTargetMetrics.coherentState
    and active.lastTargetMetrics.coherentState.stableSamples or 0
  if stableSamples < 2 and active.targetOwnershipConfirmed == true then stableSamples = 2 end
  local slotCurrent = active.domain ~= "race" or (
    active.domainContext and tostring(active.domainContext.expectedSlot)
      == tostring(active.expectedSlot)
  )
  -- A successful adapter snapshot is already bound to the requested target.
  -- Keep compatibility with older/test adapters that predate the explicit
  -- vehicle/read-coherence fields, while still honoring an explicit mismatch
  -- or incoherent read from the production adapter.
  local observedVehicleId = tonumber(snapshot and snapshot.vehicleId) or tonumber(active.vehicleId)
  return {
    operationId = active.operationId,
    operationGeneration = active.operationGeneration,
    targetGeneration = active.targetGeneration,
    phaseGeneration = active.phaseGeneration,
    expectedVehicleId = tonumber(active.vehicleId),
    vehicleId = observedVehicleId,
    slotId = active.expectedSlot,
    coherent = type(snapshot) == "table" and snapshot.coherentTargetRead ~= false
      and active.targetOwnershipConfirmed == true,
    operationCurrent = operationState.isCurrent(runtime.state, active.token),
    phaseCurrent = tonumber(active.phaseGeneration) == tonumber(runtime.state.phaseGeneration),
    slotCurrent = slotCurrent,
    stableSamples = stableSamples,
    readStatus = snapshot and (snapshot.readStatus or "ready"),
    objectExists = tonumber(active.vehicleId) ~= nil,
    ownershipCurrent = active.targetOwnershipConfirmed == true
      or active.operationCurrentTarget ~= nil,
    bindConverged = stableSamples >= 2,
    treeConverged = stableSamples >= 2 and type(snapshot) == "table"
      and snapshot.coherentTargetRead ~= false,
    bindDeadlineExpired = false,
    convergenceDeadlineExpired = false,
  }
end

production.layerSafety = function(active, result, snapshot)
  local policy = util.shallowMerge(active.policy or {}, {
    allowPartialResult = active.settings and active.settings.allowPartialResult == true
      or active.racePermissiveDrivability == true,
  })
  return productionModules.safetyModel.layer(
    result, policy, production.safetyEvidence(active, snapshot)
  )
end

production.unknownSafetyResult = function(reason, detail)
  return {
    status = "pending", valid = nil, decision = validator.DECISIONS.UNKNOWN_OR_PENDING,
    profile = "unknown", classification = "unknown", failures = {},
    warnings = {{reason = reason}}, reason = reason, detail = util.deepCopy(detail),
  }
end

production.preserveUnconfirmedSafetyResult = function(active, result, phase)
  if active.domain == "chaos" and tonumber(active.vehicleId) and active.domainContext then
    productionModules.domainOperations.acceptVehicle(
      runtime.domainOperations, active.domainContext, active.vehicleId, "player_result", active.vehicleId
    )
    productionModules.operationContext.markAccepted(
      production.ensureOperationContext(active), active.vehicleId, active.vehicleId
    )
    if active.spawnTransaction then
      productionModules.spawnAdapter.spawnOutcome.accept(active.spawnTransaction, active.vehicleId)
    end
  end
  finishOperation(false, "safety_confirmation_unavailable",
    "Safety could not confirm the current vehicle within the bounded readback window", {
      safety = util.deepCopy(result), preservedCurrentResult = active.domain == "chaos",
      safetyGate = productionModules.safetyGate.snapshot(active.finalSafetyGate or active.partsSafetyGate),
      failurePhase = phase,
    })
end

production.evaluateFinalSafety = function(active, result, continuation)
  local action, details = productionModules.safetyGate.observe(
    active.finalSafetyGate, result, runtime.time.realMonotonicTime,
    active.settings and active.settings.allowPartialResult == true
  )
  if action == "retry" then
    active.safetyRevalidateAt = details.retryAt
    active.safetyContinuation = continuation
    active.safetyResult = util.deepCopy(result)
    diagnosticsModule.write(runtime.diagnostics, "D", "safety_readback_retry_scheduled", {
      attempt = details.attempt, maxAttempts = details.maxAttempts,
      reason = details.reason, continuation = continuation,
    })
    return nil, {retryPending = true, safety = util.deepCopy(result)}
  end
  active.safetyRevalidateAt = nil
  active.safetyContinuation = nil
  if action == "accept_partial" then
    active.nonFatalPartial = true
    active.warnings[#active.warnings + 1] =
      "Safety evidence remained incomplete after bounded readback; the partial-result policy preserved the vehicle."
    return true, result
  end
  if action == "accept_warning" then
    active.nonFatalPartial = true
    active.warnings[#active.warnings + 1] =
      "The stable result was accepted with warnings by the selected chaos policy."
    return true, result
  end
  if action == "policy_rejected" then
    local ruleId = result.safetyReasons and result.safetyReasons.acceptance
      or result.chaosAcceptance or "policy_requirements_not_satisfied"
    return false, adapter.errorValue("rejected_by_chaos_policy",
      "The stable result does not satisfy the selected chaos policy", {
        policyProfile = active.domain == "race" and runtime.lineup.current
          and runtime.lineup.current.preset or "Chaos",
        ruleId = ruleId,
        severity = "error",
        decision = "REJECT",
        evidence = util.deepCopy(result),
        runtimeIntegrity = result.runtimeIntegrity,
        drivability = result.drivability,
        chaosAcceptance = result.chaosAcceptance,
      })
  end
  if action == "unconfirmed" then
    return false, adapter.errorValue("safety_confirmation_unavailable",
      "Safety evidence remained unknown after bounded readback", {
        decision = validator.DECISIONS.UNKNOWN_OR_PENDING,
        safety = util.deepCopy(result), safetyGate = productionModules.safetyGate.snapshot(active.finalSafetyGate),
      })
  end
  return action == "accept", result
end

local function validateFinalVehicle(active, continuation)
  setProgress("Validating final vehicle", 0.96)
  local scanStarted = adapter.clock()
  local okSnapshot, snapshot = adapter.getCurrentSlotSnapshot(
    active.vehicleId, active.backgroundTarget == true
  )
  if not okSnapshot then
    local code = type(snapshot) == "table" and snapshot.code or "parts_read_unavailable"
    local unreadable = code == "missing_parts_tree" or code == "parts_read_unavailable"
      or code == "temporarily_unreadable" or code == "config_read_unavailable"
    if unreadable then
      return production.evaluateFinalSafety(active, production.unknownSafetyResult(code, snapshot), continuation)
    end
    return false, snapshot
  end
  local scan, scanError = slotScanner.scan(snapshot.tree, snapshot.metadataByPath)
  active.slotScanDuration = (active.slotScanDuration or 0) + math.max(0, adapter.clock() - scanStarted)
  if not scan then
    return production.evaluateFinalSafety(active, production.unknownSafetyResult(scanError, snapshot), continuation)
  end
  local graph = validator.buildGraph(scan, safetyContext(active, snapshot), {
    allowMissingParts = active.policy and active.policy.allowMissingParts == true,
    evidence = production.safetyEvidence(active, snapshot),
  })
  if not active.safetyBaseline then active.safetyBaseline = util.deepCopy(graph) end
  local result = validator.validateGraph(graph, active.safetyBaseline, active.policy.protectCriticalParts)
  result = production.layerSafety(active, result, snapshot)
  active.safetyResult = result
  diagnosticsModule.write(runtime.diagnostics, result.valid and "D" or "E", "safety_validation", {
    phase = "validation",
    profile = result.profile,
    status = result.status,
    failures = result.failures,
    warnings = result.warnings,
    missingParts = result.missingParts,
    heuristicPaths = graph.heuristicPaths,
  }, not result.valid)
  if result.decision == validator.DECISIONS.UNKNOWN_OR_PENDING then
    return production.evaluateFinalSafety(active, result, continuation)
  end
  productionModules.safetyGate.reset(active.finalSafetyGate)
  if result.decision == validator.DECISIONS.INVALID_CONFIRMED then
    local repairing, repairReason = attemptCriticalRepair(
      active, snapshot, scan, result.failures, "validation"
    )
    if repairing then
      return nil, {repairStarted = true, reason = repairReason, safety = util.deepCopy(result)}
    end
    return false, adapter.errorValue("safety_validation_failed", "Final vehicle safety evidence is invalid", {
      decision = validator.DECISIONS.INVALID_CONFIRMED,
      profile = result.profile,
      classification = result.classification,
      status = result.status,
      failures = result.failures,
      repairReason = repairReason,
    })
  end
  for _, warning in ipairs(result.warnings or {}) do
    active.nonFatalPartial = true
    active.partPolicyWarnings = active.partPolicyWarnings or {}
    local key = tostring(warning.reason) .. ":" .. tostring(warning.slotPath)
    if not active.partPolicyWarnings[key] then
      active.partPolicyWarnings[key] = true
      active.warnings[#active.warnings + 1] = string.format(
        "Parts warning at %s: %s.", tostring(warning.slotPath), tostring(warning.reason)
      )
    end
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
  local okCapture, capture = adapter.captureCurrentState(
    active.kind, active.seed, active.vehicleId, active.backgroundTarget == true
  )
  if not okCapture then return false, capture end
  local okSnapshot, snapshot = adapter.getCurrentSlotSnapshot(
    active.vehicleId, active.backgroundTarget == true
  )
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
  local okCapture, capture = adapter.captureCurrentState(
    active.kind, active.seed, active.vehicleId, active.backgroundTarget == true
  )
  if not okCapture then failActive(capture, true, "dna_replay_verification"); return end
  local okSnapshot, snapshot = adapter.getCurrentSlotSnapshot(
    active.vehicleId, active.backgroundTarget == true
  )
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

production.ensureEnergyStorageFloor = function(active, continuation)
  if active.energyGuardComplete then return false end
  local okSnapshot, snapshot = adapter.getTuningSnapshot(
    active.vehicleId, active.backgroundTarget == true
  )
  if not okSnapshot then
    active.energyGuardComplete = true
    active.energyGuardUncertain = true
    active.energyGuardReport = {
      status = "unavailable_warning", unresolved = 1, belowFloor = 0,
      safeToContinue = true, readError = util.deepCopy(snapshot), storages = {},
    }
    active.warnings = active.warnings or {}
    active.warnings[#active.warnings + 1] =
      "Combustion-fuel metadata/read-back was unavailable; the randomized vehicle was preserved."
    diagnosticsModule.write(runtime.diagnostics, "W", "fuel_floor_readback_unavailable",
      active.energyGuardReport, true)
    return false
  end
  local plan = productionModules.energyStorageGuard.plan(snapshot)
  active.energyGuardReport = util.deepCopy(plan.report)
  if plan.report.notApplicable then
    active.energyGuardComplete = true
    active.energyGuardReport.status = "not_applicable"
    diagnosticsModule.write(runtime.diagnostics, "D", "fuel_floor_not_applicable", active.energyGuardReport)
    return false
  end
  if #plan.changes == 0 and plan.report.compliant then
    active.energyGuardComplete = true
    active.energyGuardReport.status = "readback_confirmed"
    active.energyGuardOverrides = active.energyGuardOverrides or {}
    for _, storage in ipairs(plan.report.storages or {}) do
      if storage.classification == "combustion_fuel" and storage.variable and util.isFinite(storage.current) then
        active.energyGuardOverrides[storage.variable] = storage.current
      end
    end
    active.lastAcceptedCheckpoint = "fuel_floor_readback_confirmed"
    diagnosticsModule.write(runtime.diagnostics, "I", "fuel_floor_readback_confirmed", active.energyGuardReport, true)
    return false
  end
  if plan.report.unresolved > 0 and #plan.changes == 0 then
    active.energyGuardComplete = true
    active.energyGuardUncertain = true
    active.energyGuardReport.status = "uncertain_warning"
    active.warnings = active.warnings or {}
    active.warnings[#active.warnings + 1] =
      "Combustion-fuel storage could not be correlated confidently; no destructive fallback was applied."
    diagnosticsModule.write(runtime.diagnostics, "W", "fuel_floor_unresolved_nonfatal",
      active.energyGuardReport, true)
    return false
  end
  active.energyGuardAttempts = (active.energyGuardAttempts or 0) + 1
  if active.energyGuardAttempts > 2 then
    active.energyGuardComplete = true
    active.energyGuardUncertain = true
    active.energyGuardReport.status = "correction_unconfirmed_warning"
    active.energyGuardReport.correctionAttempts = active.energyGuardAttempts - 1
    active.warnings = active.warnings or {}
    active.warnings[#active.warnings + 1] =
      "The combustion-fuel floor correction could not be confirmed; the current randomized result was preserved."
    diagnosticsModule.write(runtime.diagnostics, "W", "fuel_floor_correction_unconfirmed",
      active.energyGuardReport, true)
    return false
  end
  if runtime.state.state == "waitingForVehicle" or runtime.state.state == "validating" then
    operationState.transition(runtime.state, "scanning", false)
  end
  if runtime.state.state == "waitingForReload" then operationState.transition(runtime.state, "tuning", false) end
  if runtime.state.state == "scanning" then operationState.transition(runtime.state, "tuning", false) end
  local expected = {}
  for _, change in ipairs(plan.changes) do
    expected[change.name] = change.requested
    local record = util.deepCopy(change)
    record.energyFloor = true
    record.selectedValue = change.requested
    active.tuningChanges[#active.tuningChanges + 1] = record
    active.energyGuardOverrides = active.energyGuardOverrides or {}
    active.energyGuardOverrides[change.name] = change.requested
    if type(active.kind) == "string" and active.kind:sub(1, 3) == "dna" then
      addDNADeviation(active, {
        kind = "tuning", name = change.name, reason = "minimum_combustion_fuel",
        requested = change.before, applied = change.requested,
      })
    end
  end
  active.pendingTuningChanges = nil
  active.energyGuardContinuation = continuation
  active.energyGuardPendingPlan = util.deepCopy(plan)
  local okWait, waitError = enterWaiting(active, "fuel_guard", continuation, {
    vehicleId = active.vehicleId,
    modelKey = active.modelKey or (active.selectedModel and active.selectedModel.key),
    tuning = expected,
  }, "Enforcing minimum combustion fuel", 0.95)
  if not okWait then failActive(waitError, true, "fuel_guard"); return true end
  local okHistory, historyError = commitHistory(active)
  if not okHistory then failActive(historyError, false, "fuel_guard"); return true end
  bindMutationPlan(active, "fuel_guard")
  local guardOk, guardError = guardMutationWrite(active, "fuel_guard")
  if not guardOk then failActive(guardError, true, "fuel_guard"); return true end
  local okApply, applyError = adapter.applyTuning(
    plan.values, active.reloadWriteTarget and active.reloadWriteTarget.vehicleId,
    active.backgroundTarget == true
  )
  if not okApply then failActive(applyError, true, "fuel_guard"); return true end
  noteSuccessfulWrite(active, "fuel_guard")
  diagnosticsModule.write(runtime.diagnostics, "I", "fuel_floor_correction_applied", {
    attempt = active.energyGuardAttempts, changes = plan.changes, report = plan.report,
  }, true)
  return true
end

production.ensureEngineFluidSafety = function(active, continuation, safety)
  local classification = safety and safety.classification
    or active.safetyResult and active.safetyResult.classification
    or active.safetyBaseline and active.safetyBaseline.classification
  if classification ~= "drivable_combustion" and classification ~= "drivable_hybrid" then
    active.engineFluidReport = {
      valid = true, status = "not_applicable", classification = classification,
      source = "candidate_classification",
    }
    return false
  end
  local guard = active.engineFluidGuard
  if guard and guard.complete == true and guard.vehicleId == active.vehicleId
    and guard.classification == classification
  then return false end
  if not guard or guard.vehicleId ~= active.vehicleId or guard.classification ~= classification then
    active.engineFluidGuard = {
      requestId = table.concat({
        tostring(active.operationId), tostring(active.operationGeneration),
        tostring(active.targetGeneration), tostring(active.vehicleId), "engine-fluid",
      }, ":"),
      vehicleId = active.vehicleId,
      operationId = active.operationId,
      operationGeneration = active.operationGeneration,
      targetGeneration = active.targetGeneration,
      classification = classification,
      continuation = continuation,
      attempts = 0,
      stableSamples = 0,
      nextRequestAt = runtime.time.realMonotonicTime,
      complete = false,
    }
    active.readBackStatus = "engine_fluid_evidence_pending"
    setLifecyclePhase(active, "validating_engine_fluids", false, "direct_vehicle_runtime_probe")
    diagnosticsModule.write(runtime.diagnostics, "D", "engine_fluid_probe_started", {
      requestId = active.engineFluidGuard.requestId, vehicleId = active.vehicleId,
      classification = classification, requiredStableSamples = 2, maximumRequests = 8,
    }, true)
  else
    guard.continuation = continuation
  end
  return true
end

production.completeRandomConfig = function(active, verificationDetails)
  if production.ensureEnergyStorageFloor(active, "random_config") then return end
  local message = "Loaded " .. tostring(active.selectedConfig.name)
  local warnings = util.deepCopy(active.warnings or {})
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
    verifiedTraits = productionModules.raceManager.verifiedTraits(active.selectedModel, active.selectedConfig),
    verificationStrategy = verificationDetails and verificationDetails.strategy,
    warnings = warnings,
    energyStorages = util.deepCopy(active.energyGuardReport),
    selection = {
      kind = "new_selection", substream = active.selectionSubstream, seedSource = active.seedSource,
      reusedFromRetry = false, restoredFromRecovery = false,
      previousResultIdentity = active.previousResultIdentity,
    },
  }
  operationState.transition(runtime.state, "validating", false)
  local dnaSafe, dnaSafety = validateFinalVehicle(active, "random_config")
  if dnaSafe == nil then return end
  if not dnaSafe then
    local decision = dnaSafety and dnaSafety.context and dnaSafety.context.decision
    if decision == validator.DECISIONS.UNKNOWN_OR_PENDING then
      production.preserveUnconfirmedSafetyResult(active, dnaSafety.context.safety, "random_config")
    else
      failActive(dnaSafety, decision == validator.DECISIONS.INVALID_CONFIRMED, "validation")
    end
    return
  end
  if dnaSafe and production.ensureEngineFluidSafety(active, "random_config", dnaSafety) then return end
  details.safety = dnaSafe and util.deepCopy(dnaSafety) or nil
  local dnaReady, dnaOrError = false, dnaSafety
  if dnaSafe then dnaReady, dnaOrError = capturePendingDNA(active, details) end
  for _, warning in ipairs(active.warnings or {}) do
    if not util.arrayContains(details.warnings, warning) then details.warnings[#details.warnings + 1] = warning end
  end
  details.dnaReady = dnaReady
  if dnaReady then details.dnaId = dnaOrError.id else
    details.warnings[#details.warnings + 1] = "Vehicle DNA capture was unavailable because final validation or capture did not complete."
    diagnosticsModule.write(runtime.diagnostics, "W", "dna_capture_failed", dnaOrError, true)
  end
  pushRecent(runtime.recentModels, active.selectedModel.key)
  pushRecent(runtime.recentConfigs, configSelector.identifier(active.selectedConfig))
  pushRecent(runtime.recentRandomCarResults, selectionIdentity(
    active.selectedModel.key, active.selectedConfig.path or active.selectedConfig.key
  ))
  if dnaReady then pushRecent(runtime.recentCompletedDNA, dnaOrError.id) end
  details.engineFluids = util.deepCopy(active.engineFluidReport)
  details.uncertain = active.energyGuardUncertain == true or active.engineFluidUncertain == true
  if active.nonFatalPartial == true then
    details.warnings[#details.warnings + 1] = "Additional verification was unavailable for this vehicle."
  end
  finishOperation(true, (details.uncertain or active.nonFatalPartial == true)
      and "random_config_loaded_with_warning" or "random_config_loaded",
    message, details, "completed")
end

local function completeChaos(active)
  if production.ensureEnergyStorageFloor(active, "chaos") then return end
  operationState.transition(runtime.state, "validating", false)
  active.phase = "validation"
  setLifecyclePhase(active, "final_validation", false, "chaos_final_validation")
  local safe, safetyOrError = validateFinalVehicle(active, "chaos")
  if safe == nil then return end
  if not safe then
    local decision = safetyOrError and safetyOrError.context and safetyOrError.context.decision
    if decision == validator.DECISIONS.UNKNOWN_OR_PENDING then
      production.preserveUnconfirmedSafetyResult(active, safetyOrError.context.safety, "chaos")
    else
      failActive(safetyOrError, decision == validator.DECISIONS.INVALID_CONFIRMED, "validation")
    end
    return
  end
  if production.ensureEngineFluidSafety(active, "chaos", safetyOrError) then return end
  if active.replayGeneration then completeReplayGeneration(active, safetyOrError); return end
  local completionMessage
  if safetyOrError.status == "not_applicable" then
    active.warnings[#active.warnings + 1] = "Prop safety validation is not applicable; this result does not claim a controllable vehicle."
    completionMessage = "Chaos complete; prop control is not validated"
  end
  local removed = 0
  for _, change in ipairs(active.changes) do if change.wasRemoved then removed = removed + 1 end end
  local okReadBack, finalState = adapter.getVerificationState(
    active.vehicleId, active.backgroundTarget == true
  )
  if okReadBack and active.slotLedger then
    slotCoverageLedger.markFinalParts(active.slotLedger, finalState.parts)
  end
  local slotSummary = active.slotLedger and slotCoverageLedger.summary(active.slotLedger) or nil
  local tuningSummary = active.tuningLedger and tuningCoverageLedger.summary(active.tuningLedger) or nil
  local paintSummary = active.paintLedger and paintCoverageLedger.summary(active.paintLedger) or nil
  local verifiedTraits = productionModules.raceManager.verifiedTraits(active.selectedModel, active.selectedConfig)
  local details = {
    seed = active.seed,
    model = active.selectedModel and active.selectedModel.key or active.modelKey,
    configuration = active.selectedConfig and active.selectedConfig.key,
    verifiedTraits = verifiedTraits,
    metadataUncertain = productionModules.raceManager.metadataUncertain(verifiedTraits)
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
    selection = {
      kind = "new_selection",
      substream = active.selectionSubstream,
      seedSource = active.seedSource,
      reusedFromRetry = active.lineupAttempt and active.lineupAttempt > 1 or false,
      restoredFromRecovery = false,
      previousResultIdentity = active.previousResultIdentity,
    },
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
    energyStorages = util.deepCopy(active.energyGuardReport),
    engineFluids = util.deepCopy(active.engineFluidReport),
    coverage = {
      slots = slotSummary,
      tuning = tuningSummary,
      paint = paintSummary,
      limits = util.deepCopy(active.coverageLimits),
      convergence = active.convergence and treeConvergence.metrics(active.convergence) or nil,
    },
  }
  local totalChanges = #active.changes + #active.tuningChanges + active.paintChanges
  local coveragePartial = not okReadBack
    or not active.slotLedger or not slotCoverageLedger.isComplete(active.slotLedger)
    or not active.tuningLedger or not tuningCoverageLedger.isComplete(active.tuningLedger)
    or not active.paintLedger or not paintCoverageLedger.isComplete(active.paintLedger)
    or (tuningSummary and tuningSummary.tuningRejected > 0)
    or (paintSummary and paintSummary.paintRejected > 0)
    or details.stageReasons.tuning == "tuning_capability_unavailable"
    or details.stageReasons.paint == "paint_capability_unavailable"
  local nonFatalPartial = active.energyGuardUncertain == true or active.engineFluidUncertain == true
    or active.nonFatalPartial == true
  local warningOnly = coveragePartial or nonFatalPartial
  local dnaReady, dnaOrError = capturePendingDNA(active, details)
  details.dnaReady = dnaReady
  if dnaReady then
    details.dnaId = dnaOrError.id
  else
    warningOnly = true
    details.warnings[#details.warnings + 1] = "Vehicle DNA capture was unavailable: " .. tostring(dnaOrError.message or dnaOrError.code)
    diagnosticsModule.write(runtime.diagnostics, "W", "dna_capture_failed", dnaOrError, true)
  end
  details.uncertain = nonFatalPartial or not okReadBack
  local partsLimitReason = tostring(details.stageReasons.parts or "")
  details.partialApplied = active.kind == "fullRandom" and #active.changes > 0
    and partsLimitReason:find("coverage_limit_", 1, true) == 1
  details.appliedIncomplete = details.partialApplied or nil
  details.skippedCount = (tuningSummary and tuningSummary.tuningRejected or 0)
    + (paintSummary and paintSummary.paintRejected or 0)
    + (details.stageReasons.tuning == "tuning_capability_unavailable" and 1 or 0)
    + (details.stageReasons.paint == "paint_capability_unavailable" and 1 or 0)
  details.status = warningOnly and "CompletedWithWarning" or "Completed"
  local completionCode = active.creativeOperation == "reroll_unlocked" and "reroll_unlocked_completed"
    or active.creativeOperation == "mutation" and "dna_mutation_completed" or "completed"
  if active.kind == "fullRandom" then
    completionCode = details.partialApplied and "full_random_partial_applied"
      or details.skippedCount > 0 and "full_random_completed_with_skips"
      or warningOnly and "full_random_completed_with_warning" or "full_random_completed"
  elseif active.kind == "scramble" and not active.creativeOperation then
    completionCode = details.skippedCount > 0 and "scramble_completed_with_skips"
      or warningOnly and "scramble_completed_with_warning"
      or totalChanges == 0 and "scramble_no_mutable_content" or "completed"
  end
  local creativeMessage = active.creativeOperation == "reroll_unlocked" and "Reroll Unlocked complete"
    or active.creativeOperation == "mutation" and "Vehicle DNA mutation complete" or nil
  if active.kind == "fullRandom" and active.selectedConfig then
    pushRecent(runtime.recentFullRandomBaseResults, selectionIdentity(
      active.selectedModel and active.selectedModel.key or active.modelKey,
      active.selectedConfig.path or active.selectedConfig.key
    ))
  end
  if dnaReady then pushRecent(runtime.recentCompletedDNA, dnaOrError.id) end
  finishOperation(true, completionCode, creativeMessage or completionMessage or string.format(
    "%s: %d parts, %d tuning values, %d paints",
    warningOnly and "Chaos complete with warnings" or "Chaos complete",
    #active.changes, #active.tuningChanges, active.paintChanges
  ), details, details.partialApplied and "partial" or "completed")
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
  local okPaints, paints = adapter.getPaints(active.vehicleId, active.backgroundTarget == true)
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
    local okApply, applyResult = adapter.applyPaints(
      result, active.vehicleId, active.backgroundTarget == true
    )
    if not okApply then failActive(applyResult, true, "paint"); return end
    noteSuccessfulWrite(active, "paint")
    if applyResult.confirmationRequired then
      local transitioned, transitionError = operationState.transition(runtime.state, "waitingForReload", PAINT_CONFIRM_TIMEOUT)
      if not transitioned then failActive(adapter.errorValue("state_error", transitionError), true, "paint"); return end
      active.paintConfirmation = paintVerification.createDeferred(
        applyResult.expected, adapter.clock(), PAINT_CONFIRM_TIMEOUT, 0.1, 12
      )
      setLifecyclePhase(active, "verifying_paint", PAINT_CONFIRM_TIMEOUT, "paint_readback")
      active.readBackStatus = "paint_readback_pending"
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
    local okReadBack, readBack = adapter.getPaints(active.vehicleId, active.backgroundTarget == true)
    if okReadBack then paintCoverageLedger.readBack(active.paintLedger, readBack) end
  else
    paintCoverageLedger.readBack(active.paintLedger, paints)
  end
  completeChaos(active)
end

local function applyTuningPass(active, snapshot, pass, onlyNew)
  setLifecyclePhase(active, "applying_tuning", false, "tuning_pass_" .. tostring(pass))
  active.tuningDiscoverySignatures = active.tuningDiscoverySignatures or {}
  active.tuningDiscoveryOrder = active.tuningDiscoveryOrder or {}
  local signature = tuningPipeline.snapshotSignature(snapshot.variables)
  local previousPass = active.tuningDiscoverySignatures[signature]
  if previousPass then
    active.tuningDiscoveryStopReason = previousPass == pass - 1
      and "tuning_fixed_point_reached" or "tuning_discovery_cycle_detected"
    active.stageReasons = active.stageReasons or {}
    active.stageReasons.tuning = active.tuningDiscoveryStopReason
    diagnosticsModule.write(runtime.diagnostics,
      active.tuningDiscoveryStopReason == "tuning_discovery_cycle_detected" and "W" or "D",
      active.tuningDiscoveryStopReason, {pass = pass, firstSeenPass = previousPass})
    return false
  end
  if pass > active.coverageLimits.maxTuningDiscoveryPasses then
    active.tuningDiscoveryStopReason = "tuning_discovery_limit_reached"
    active.stageReasons = active.stageReasons or {}
    active.stageReasons.tuning = active.tuningDiscoveryStopReason
    active.warnings[#active.warnings + 1] = "Tuning discovery stopped at its bounded pass limit."
    diagnosticsModule.write(runtime.diagnostics, "W", active.tuningDiscoveryStopReason, {
      pass = pass, limit = active.coverageLimits.maxTuningDiscoveryPasses,
      variableCount = #util.sortedKeys(snapshot.variables or {}),
    }, true)
    return false
  end
  active.tuningDiscoverySignatures[signature] = pass
  active.tuningDiscoveryOrder[#active.tuningDiscoveryOrder + 1] = signature
  local tuningStarted = adapter.clock()
  local values, changes, ledger, newly, metadataChanged = tuningPipeline.plan(
    snapshot.variables, snapshot.values, active.policy, active.rng:fork("tuning:pass:" .. tostring(pass)), {
      onlyNew = onlyNew == true,
      extremeTuning = runtime.settings.extremeTuning == true,
      maxVariables = active.coverageLimits.maxTuningVariables,
      isLocked = active.lockProfileSnapshot and function(name, category, subCategory)
        return vehicleDNALocks.isTuningLocked(active.lockProfileSnapshot, name, category, subCategory)
      end or nil,
    }, active.tuningLedger, pass
  )
  local fluidValues, fluidProtection = productionModules.engineFluidGuard.protectTuning(
    values, snapshot.variables, snapshot.values,
    active.safetyBaseline and active.safetyBaseline.classification
  )
  values = fluidValues
  active.engineFluidTuningProtection = fluidProtection
  for _, protected in ipairs(fluidProtection.protected or {}) do
    local matched = false
    for _, change in ipairs(changes) do
      if change.name == protected.name then
        change.selectedValue = protected.restored
        change.distribution = "critical_engine_fluid_protection"
        change.engineFluidProtection = util.deepCopy(protected)
        tuningCoverageLedger.update(ledger, change.identity, "attempted", {
          eligible = true, requested = protected.restored,
          tolerance = ledger.entries[change.identity] and ledger.entries[change.identity].tolerance,
          reason = "critical_engine_fluid_protection",
        })
        matched = true
        break
      end
    end
    if not matched then
      local variable = tuningPipeline.normalize(
        protected.name, snapshot.variables[protected.name], snapshot.values
      )
      local entry = tuningCoverageLedger.observe(ledger, variable, pass, false)
      tuningCoverageLedger.update(ledger, entry.identity, "attempted", {
        eligible = true, requested = protected.restored, tolerance = variable.tolerance,
        reason = "critical_engine_fluid_protection",
      })
      changes[#changes + 1] = {
        identity = entry.identity, name = protected.name, previousValue = variable.current,
        selectedValue = protected.restored, minimum = variable.minimum, maximum = variable.maximum,
        step = variable.step, default = variable.default, category = variable.category,
        subCategory = variable.subCategory, sourcePart = variable.sourcePart,
        distribution = "critical_engine_fluid_protection",
        engineFluidProtection = util.deepCopy(protected),
      }
    end
  end
  productionModules.performanceMetrics.record(
    runtime.performanceTelemetry, "tuningDiscovery", math.max(0, (adapter.clock() - tuningStarted) * 1000)
  )
  active.tuningLedger = ledger
  active.tuningPass = pass
  active.pendingTuningChanges = changes
  for _, change in ipairs(changes) do active.tuningChanges[#active.tuningChanges + 1] = change end
  active.stageReasons = active.stageReasons or {}
  active.stageReasons.tuning = #changes > 0 and "tuning_processed" or "tuning_no_mutable_values"
  diagnosticsModule.write(runtime.diagnostics, "D", "tuning_pass_planned", {
    pass = pass, changes = #changes, newlyDiscovered = newly,
    metadataChanged = metadataChanged,
    variableDrops = active.tuningLedger.variableDrops,
    coverage = tuningCoverageLedger.summary(active.tuningLedger),
    engineFluidProtection = util.deepCopy(fluidProtection),
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
  local okApply, applyError = adapter.applyTuning(
    values, active.reloadWriteTarget and active.reloadWriteTarget.vehicleId,
    active.backgroundTarget == true
  )
  if not okApply then failActive(applyError, true, "tuning") end
  if okApply then noteSuccessfulWrite(active, "tuning") end
  return true
end

local function processTuningReadback(active)
  setLifecyclePhase(active, "verifying_tuning", false, "tuning_readback")
  active.readBackStatus = "tuning_reload_pending"
  local okSnapshot, snapshot = adapter.getTuningSnapshot(
    active.vehicleId, active.backgroundTarget == true
  )
  if not okSnapshot then failActive(snapshot, true, "tuning_readback"); return end
  tuningCoverageLedger.readBack(active.tuningLedger, snapshot.values, active.tuningPass or 1)
  active.readBackStatus = "ready"
  active.lastAcceptedCheckpoint = "tuning_readback_confirmed"
  for _, change in ipairs(active.pendingTuningChanges or {}) do
    local entry = active.tuningLedger.entries[change.identity]
    if entry then
      change.requestedValue = entry.requested
      change.readBackValue = entry.readBack
      change.readBackStatus = entry.status
      change.clamped = entry.clamped == true
    end
  end
  local nextPass = (active.tuningPass or 1) + 1
  if applyTuningPass(active, snapshot, nextPass, true) then return end
  tuningCoverageLedger.readBack(active.tuningLedger, snapshot.values, nextPass)
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
  local okSnapshot, snapshot = adapter.getTuningSnapshot(
    active.vehicleId, active.backgroundTarget == true
  )
  if not okSnapshot then failActive(snapshot, true, "tuning"); return end
  if not applyTuningPass(active, snapshot, 1, false) then
    tuningCoverageLedger.readBack(active.tuningLedger, snapshot.values, 1)
    operationState.transition(runtime.state, "painting", false)
    startPaint(active)
  end
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
  local okSnapshot, snapshot = adapter.getCurrentSlotSnapshot(
    active.vehicleId, active.backgroundTarget == true
  )
  if not okSnapshot then
    local readCode = type(snapshot) == "table" and snapshot.code or "parts_read_unavailable"
    local retryable = readCode == "missing_parts_tree" or readCode == "parts_read_unavailable"
      or readCode == "temporarily_unreadable"
      or readCode == "config_read_unavailable" or readCode == "no_active_vehicle"
    if retryable then
      local now = runtime.time.realMonotonicTime
      active.readRetry = active.readRetry or {
        firstAt = now,
        deadline = now + math.min(READ_RETRY_TIMEOUT, active.waitTimeout or WAIT_TIMEOUT),
        count = 0,
      }
      active.readRetry.count = active.readRetry.count + 1
      active.readRetry.lastCode = readCode
      active.readRetry.lastAt = now
      if now < active.readRetry.deadline then
        active.treeRescanAt = now + READ_RETRY_INTERVAL
        active.treeRescanContext = operationState.captureContext(runtime.state, active.operationCurrentTarget)
        setProgress("Waiting for the target parts tree to become readable", runtime.progress.value)
        diagnosticsModule.write(runtime.diagnostics, "W", "parts_read_retry", {
          code = readCode,
          attempt = active.readRetry.count,
          deadline = active.readRetry.deadline,
          target = util.deepCopy(active.operationCurrentTarget),
        })
        return
      end
      snapshot = adapter.errorValue("parts_read_unavailable", "The target parts tree remained unavailable after bounded retries", {
        sourceCode = readCode,
        attempts = active.readRetry.count,
        elapsed = math.max(0, now - active.readRetry.firstAt),
      })
      if type(active.kind) == "string" and active.kind:sub(1, 3) ~= "dna" then
        active.nonFatalPartial = true
        active.preserveCurrentResult = true
        active.stageReasons.parts = "parts_tree_unavailable_warning"
        active.warnings[#active.warnings + 1] =
          "The parts tree remained unreadable; the current stable vehicle was preserved without fallback."
        active.slotLedger.limitReason = "parts_tree_unavailable"
        slotCoverageLedger.markFinalParts(active.slotLedger, {})
        diagnosticsModule.write(runtime.diagnostics, "W", "parts_tree_unavailable_nonfatal", {
          error = snapshot, target = util.deepCopy(active.operationCurrentTarget),
        }, true)
        operationState.transition(runtime.state, "tuning", false)
        startTuning(active)
        return
      end
    end
    failActive(snapshot, active.destructiveStarted, "parts")
    return
  end
  active.readRetry = nil
  local scan, scanError = slotScanner.scan(snapshot.tree, snapshot.metadataByPath)
  local scanDuration = math.max(0, adapter.clock() - scanStarted)
  active.slotScanDuration = (active.slotScanDuration or 0) + scanDuration
  productionModules.performanceMetrics.record(runtime.performanceTelemetry, "treeScanning", scanDuration * 1000)
  if not scan then failActive(adapter.errorValue(scanError, "Could not scan the current parts tree"), active.destructiveStarted, "parts"); return end
  if active.lastTreeSignature ~= scan.signature then
    active.lastTreeSignature = scan.signature
    noteProgress(active, "batch", "parts_tree_changed")
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
  local graph = validator.buildGraph(scan, safetyContext(active, snapshot), {
    allowMissingParts = active.policy and active.policy.allowMissingParts == true,
    evidence = production.safetyEvidence(active, snapshot),
  })
  if not active.safetyBaseline then active.safetyBaseline = util.deepCopy(graph) end
  local safetyResult = validator.validateGraph(graph, active.safetyBaseline, active.policy.protectCriticalParts)
  safetyResult = production.layerSafety(active, safetyResult, snapshot)
  active.safetyResult = safetyResult
  local safetyAction, safetyActionDetails = productionModules.safetyGate.observe(
    active.partsSafetyGate, safetyResult, runtime.time.realMonotonicTime,
    active.settings and active.settings.allowPartialResult == true
  )
  if safetyAction == "retry" then
    active.treeRescanAt = safetyActionDetails.retryAt
    active.treeRescanContext = operationState.captureContext(runtime.state, active.operationCurrentTarget)
    diagnosticsModule.write(runtime.diagnostics, "D", "safety_tree_retry_scheduled", {
      attempt = safetyActionDetails.attempt, maxAttempts = safetyActionDetails.maxAttempts,
      reason = safetyActionDetails.reason,
    })
    setProgress("Waiting for current safety evidence", 0.44)
    return
  elseif safetyAction == "unconfirmed" then
    production.preserveUnconfirmedSafetyResult(active, safetyResult, "parts")
    return
  elseif safetyAction == "accept_partial" then
    active.nonFatalPartial = true
    active.warnings[#active.warnings + 1] =
      "Parts safety remained uncertain; partial-result policy preserved the bounded result."
  elseif safetyAction == "accept_warning" then
    active.nonFatalPartial = true
    active.warnings[#active.warnings + 1] =
      "The stable parts result was accepted with warnings by the selected chaos policy."
  elseif safetyAction == "policy_rejected" then
    local ruleId = safetyResult.safetyReasons and safetyResult.safetyReasons.acceptance
      or safetyResult.chaosAcceptance or "policy_requirements_not_satisfied"
    failActive(adapter.errorValue("rejected_by_chaos_policy",
      "The stable parts result does not satisfy the selected chaos policy", {
        policyProfile = active.domain == "race" and runtime.lineup.current
          and runtime.lineup.current.preset or "Chaos",
        ruleId = ruleId,
        severity = "error",
        decision = "REJECT",
        evidence = util.deepCopy(safetyResult),
        runtimeIntegrity = safetyResult.runtimeIntegrity,
        drivability = safetyResult.drivability,
        chaosAcceptance = safetyResult.chaosAcceptance,
      }), false, "validation")
    return
  end
  local protectionFailures = safetyResult.failures
  if safetyAction == "invalid_confirmed" then
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
    local repairing, criticalRepairReason = attemptCriticalRepair(
      active, snapshot, scan, protectionFailures, "parts"
    )
    if repairing then return end
    if active.currentBatch then
      local recovering, recoveryReason = attemptPartBatchRollback(active, "critical_state_invalid")
      if recovering then return end
      diagnosticsModule.write(runtime.diagnostics, "E", "part_batch_recovery_exhausted", {
        reason = recoveryReason, recovery = partBatchRecovery.metrics(active.batchRecovery),
      }, true)
    end
    failActive(adapter.errorValue("critical_state_invalid", "Critical or required parts are missing after reload", {
      failures = protectionFailures,
      criticalRepairReason = criticalRepairReason,
      destructiveRollbackAuthorized = safetyResult.destructiveRollbackAuthorized == true,
    }), safetyResult.destructiveRollbackAuthorized == true, "validation")
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
    local acceptedOk, acceptedSnapshot = adapter.captureCurrentState(
      "accepted_generated_checkpoint", active.seed, active.vehicleId,
      active.backgroundTarget == true
    )
    if acceptedOk then
      productionModules.baselineSemantics.acceptGenerated(active.baselines, acceptedSnapshot, {
        phase = "parts", pass = active.pass, targetGeneration = active.targetGeneration,
      })
      active.operationCurrentSnapshot = util.deepCopy(acceptedSnapshot)
    end
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
  local attemptOk, attemptSnapshot = adapter.captureCurrentState(
    "current_mutation_attempt", active.seed, active.vehicleId,
    active.backgroundTarget == true
  )
  if attemptOk then productionModules.baselineSemantics.beginAttempt(active.baselines, attemptSnapshot, {pass = active.pass}) end
  local planningDuration = math.max(0, adapter.clock() - planningStarted)
  active.mutationPlanningDuration = (active.mutationPlanningDuration or 0) + planningDuration
  productionModules.performanceMetrics.record(runtime.performanceTelemetry, "mutationPlanning", planningDuration * 1000)
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

  if (active.partsReloadCount or 0) >= (active.reloadBudget and active.reloadBudget.hardLimit or 4) then
    active.reloadBudget.hardLimitReached = true
    active.nonFatalPartial = true
    active.slotLedger.limitReason = "parts_reload_hard_limit"
    active.convergence.limitReason = "parts_reload_hard_limit"
    active.stageReasons.parts = "coverage_limit_parts_reload_hard_limit"
    active.warnings[#active.warnings + 1] =
      "Part mutation stopped at the bounded reload limit; the last coherent result was preserved."
    operationState.transition(runtime.state, "tuning", false)
    startTuning(active)
    return
  end

  local expectedParts = {}
  for _, decision in ipairs(actual) do expectedParts[decision.slotPath] = decision.selectedPart end
  active.reloadBudget.coherentBatchCount = (active.reloadBudget.coherentBatchCount or 0) + 1
  active.reloadBudget.largestCoherentBatch = math.max(
    active.reloadBudget.largestCoherentBatch or 0, #actual
  )
  active.reloadBudget.plannedPartWrites = (active.reloadBudget.plannedPartWrites or 0) + #actual
  active.reloadBudget.perWriteReloadsPrevented =
    (active.reloadBudget.perWriteReloadsPrevented or 0) + math.max(0, #actual - 1)
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
  local okApply, applyError = adapter.applyPartsTree(
    tree, active.reloadWriteTarget and active.reloadWriteTarget.vehicleId,
    active.backgroundTarget == true
  )
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
  local okModel, modelKey = adapter.getCurrentModelKey(active.vehicleId)
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
    operationId = runtime.state.operationId,
    operationGeneration = runtime.state.operationGeneration,
    phaseGeneration = runtime.state.phaseGeneration,
    targetGeneration = runtime.state.targetGeneration,
    recoveryOnly = false,
    lastAcceptedCheckpoint = "operation_started",
    domain = "chaos",
  }
  local undoDomainContext, undoDomainError = productionModules.domainOperations.begin(runtime.domainOperations, {
    domain = "chaos",
    operationId = runtime.state.operationId,
    action = "undo",
    sourceVehicleId = entry.vehicleId,
    seed = entry.seed,
    createdAt = runtime.time.realMonotonicTime,
  })
  if not undoDomainContext then
    operationState.finish(runtime.state, "failed", undoDomainError)
    runtime.active = nil
    setResult(false, undoDomainError, "Undo could not acquire its Chaos operation context")
    publishState()
    return false
  end
  runtime.active.domainContext = undoDomainContext
  runtime.active.domainGeneration = undoDomainContext.generation
  runtime.active.callbackToken = production.domainCallbackToken(runtime.active, "operation")
  productionModules.domainOperations.ownVehicle(runtime.domainOperations, entry.vehicleId, {
    domain = "chaos",
    operationId = undoDomainContext.operationId,
    generation = undoDomainContext.generation,
    role = "player_source",
    managed = false,
    created = false,
    accepted = false,
  })
  runtime.active.operationContext = productionModules.operationContext.create(
    runtime.state, token, runtime.time.realMonotonicTime, {
      domain = "chaos",
      action = "undo",
      generation = undoDomainContext.generation,
      sourceVehicleId = entry.vehicleId,
    }
  )
  local undoLogicalTarget = {
    modelKey = entry.modelKey,
    configKey = configVerification.stableKey(entry.selectedConfiguration),
  }
  productionModules.operationContext.beginLogicalTarget(
    runtime.active.operationContext, runtime.state, undoLogicalTarget, runtime.time.realMonotonicTime
  )
  runtime.active.operationCurrentTarget = util.deepCopy(productionModules.operationContext.bindInitial(
    runtime.active.operationContext, runtime.state, {
      vehicleId = entry.vehicleId,
      modelKey = entry.modelKey,
      configKey = entry.selectedConfiguration,
      source = "undo_source",
      coherentTargetRead = true,
    }, runtime.time.realMonotonicTime
  ))
  runtime.active.logicalTarget = util.deepCopy(runtime.active.operationContext.logicalTarget)
  runtime.active.targetOwnershipConfirmed = true
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
  runtime.index.stale = true
  if runtime.indexer.active then
    productionModules.incrementalIndexer.cancel(runtime.indexer, "manual_reindex_restart")
    runtime.indexer.last = runtime.indexer.active
    runtime.indexer.active = nil
  end
  if type(adapter.invalidateRegistryCache) == "function" then adapter.invalidateRegistryCache() end
  productionModules.registryReadiness.begin(runtime.registry, adapter.clock(), "manual_reindex")
  if runtime.state.state ~= "idle" then operationState.reset(runtime.state) end
  local okBegin, token = operationState.begin(runtime.state, "reindex", nil, WAIT_TIMEOUT)
  if not okBegin then return false end
  runtime.active = {token = token, kind = "reindex", phase = "index", startedAt = adapter.clock()}
  operationState.transition(runtime.state, "indexing", false)
  setProgress("Reindexing installed content", 0.25)
  local ok, result = rebuildIndex()
  if not ok then failActive(result, false, "index"); return false end
  if result and result.scheduled then return true end
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
  productionModules.performanceMetrics.setEnabled(runtime.performanceTelemetry, runtime.settings.performanceProfiling)
  runtime.frameBudgets = productionModules.frameBudget.create(runtime.settings.performanceBudgets)
  local ok, saveError = adapter.saveSettings(settingsModule.forPersistence(runtime.settings))
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
  if action == "randomConfig" or action == "scramble" or action == "fullRandom" then
    local lineup = runtime.lineup.current
    if lineup and (lineup.active or runtime.lineup.pendingNext) then
      runtime.lineup.pendingNext = false
      productionModules.raceManager.cancel(
        lineup, "Race generation stopped before starting an independent Chaos action"
      )
      diagnosticsModule.write(runtime.diagnostics, "I", "race_generation_isolated_from_chaos", {
        chaosAction = action, lineupId = lineup.id,
      }, true)
    end
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
  productionModules.performanceMetrics.setEnabled(runtime.performanceTelemetry, runtime.settings.performanceProfiling)
  runtime.frameBudgets = productionModules.frameBudget.create(runtime.settings.performanceBudgets)
  local ok, saveError = adapter.saveSettings(settingsModule.forPersistence(runtime.settings))
  if not ok then setResult(false, saveError.code, saveError.message, {settingsAppliedForSession = true}) end
  publishState()
  return ok
end

production.updateUIPreferences = function(patch)
  initialize()
  if runtime.state.busy or (runtime.stress and runtime.stress.active) then return false, "busy" end
  if type(patch) == "table" and type(patch.race) == "table" and runtime.racePreview then
    productionModules.racePreview.stale(runtime.racePreview, "race_options_changed")
  end
  local nextPreferences = productionModules.uiPreferences.patch(runtime.settings.uiPreferences, patch)
  runtime.settings = settingsModule.update(runtime.settings, {uiPreferences = nextPreferences})
  local ok, saveError = adapter.saveSettings(settingsModule.forPersistence(runtime.settings))
  if not ok then
    setResult(false, saveError.code, saveError.message, {settingsAppliedForSession = true})
  end
  publishState()
  return ok
end

production.migrateLegacyUIPreferences = function(legacyRacePolicy)
  initialize()
  local nextPreferences, changed = productionModules.uiPreferences.importLegacy(
    runtime.settings.uiPreferences, legacyRacePolicy
  )
  if not changed then return true end
  runtime.settings = settingsModule.update(runtime.settings, {uiPreferences = nextPreferences})
  local ok, saveError = adapter.saveSettings(settingsModule.forPersistence(runtime.settings))
  if not ok then
    setResult(false, saveError.code, saveError.message, {settingsAppliedForSession = true})
  end
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
  local ok, saveError = adapter.saveSettings(settingsModule.forPersistence(runtime.settings))
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
        displayName = slot.description or slot.id,
        category = vehicleDNALocks.classifySlot(slot), locked = vehicleDNALocks.isSlotLocked(profile, slot),
      }
    end
  end
  adapter.emit("SoturineChaosRandomizerLocks", result)
  return result
end

local function requestState()
  initialize()
  productionModules.uiPublisher.requestFull(runtime.uiPublisher)
  return publishState(true)
end

local function setUICompactMode(mode)
  initialize()
  local allowed = {collapsed = true, expanded = true}
  if not allowed[mode] then return false end
  runtime.uiMode = mode
  publishState()
  return true
end

local function copyDiagnostics()
  initialize()
  local serializationStarted = adapter.clock()
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
      expectedPlayerIndex = 0,
      currentPlayerVehicle = state.transaction and state.transaction.currentVehicleId or nil,
      candidateIdChain = tracker and util.deepCopy(tracker.candidateChain) or {},
      modelKey = state.transaction and state.transaction.modelKey,
      configKey = state.transaction and state.transaction.configKey,
      configPath = state.transaction and state.transaction.configPath,
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
      pendingCallbackCount = pending.callbacks or 0,
      pendingTimerCount = pending.timers or 0,
      currentBatchCount = pending.currentBatch or 0,
      currentTuningPlan = pending.tuningPlan or 0,
      currentPaintPlan = pending.paintPlan or 0,
      readBackStatus = state.transaction and state.transaction.readBackStatus,
      targetIdentityFingerprint = state.transaction and state.transaction.targetIdentityFingerprint,
      treeFingerprint = state.transaction and state.transaction.treeFingerprint,
      configFingerprint = state.transaction and state.transaction.configFingerprint,
      callbackOwner = state.transaction and util.deepCopy(state.transaction.callbackOwner),
      phaseStartedAt = state.transaction and state.transaction.phaseStartedAt,
      phaseWallElapsed = state.transaction and state.transaction.phaseWallElapsed,
      operationWallElapsed = state.transaction and state.transaction.wallElapsed,
      operationSimulationElapsed = state.transaction and state.transaction.simulationElapsed,
      lastProgressTimestamp = state.transaction and state.transaction.lastProgressTimestamp,
      lastProgressReason = state.transaction and state.transaction.lastProgressReason,
      lastAcceptedCheckpoint = state.transaction and state.transaction.lastAcceptedCheckpoint,
      recoveryGeneration = state.transaction and state.transaction.recoveryGeneration,
      recoveryTier = state.transaction and state.transaction.recoveryTier,
      recoveryAttemptCount = state.transaction and state.transaction.recoveryAttemptCount,
      recentClockSamples = util.deepCopy(state.clocks.recentSamples),
      watchdog = util.deepCopy(state.watchdog),
    },
    lastResult = util.deepCopy(runtime.lastResult),
    lastFailure = util.deepCopy(runtime.lastFailure),
    performance = production.publicPerformance(),
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
  productionModules.performanceMetrics.record(runtime.performanceTelemetry, "diagnosticsSerialization", math.max(0, (adapter.clock() - serializationStarted) * 1000))
  return true
end

production.resetPerformance = function()
  initialize()
  productionModules.performanceMetrics.reset(runtime.performanceTelemetry)
  publishState()
  return true
end

production.exportPerformance = function()
  initialize()
  local snapshot = production.publicPerformance()
  adapter.emit("SoturineChaosRandomizerPerformance", snapshot)
  return snapshot
end

local function spawnSafeVehicle()
  initialize()
  if runtime.state.busy then return false end
  return startSpawnOperation("randomConfig", {safeOfficial = true})
end

local function retryQuarantinedConfigurations()
  if runtime.state.busy then return false end
  vehicleRecovery.retryQuarantined(runtime.recovery)
  contentIndex.clearTransientQuarantine(runtime.index)
  productionModules.domainOperations.clearQuarantine(runtime.domainOperations, "chaos")
  productionModules.domainOperations.clearQuarantine(runtime.domainOperations, "race")
  productionModules.domainOperations.clearQuarantine(runtime.domainOperations, "garage")
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
  runtime.dna.details = details
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
    targetBeamNG = runtime.compatibility.primaryTarget or "unknown",
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
  local okSnapshot, snapshot = adapter.getCurrentSlotSnapshot(capture.vehicleId)
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
    targetBeamNG = runtime.compatibility.primaryTarget or "unknown",
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
      local safe, safetyOrError = validateFinalVehicle(active, "dna_replay")
      if safe == nil then return end
      if not safe then
        local decision = safetyOrError and safetyOrError.context and safetyOrError.context.decision
        if decision == validator.DECISIONS.UNKNOWN_OR_PENDING then
          production.preserveUnconfirmedSafetyResult(active, safetyOrError.context.safety, "dna_replay_verification")
        else
          failActive(safetyOrError, decision == validator.DECISIONS.INVALID_CONFIRMED, "dna_replay_verification")
        end
        return
      end
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
  local okSnapshot, snapshot = adapter.getCurrentSlotSnapshot(
    active.vehicleId, active.backgroundTarget == true
  )
  if not okSnapshot then failActive(snapshot, true, "dna_parts"); return end
  local scan, scanError = slotScanner.scan(snapshot.tree, snapshot.metadataByPath)
  if not scan then failActive(adapter.errorValue(scanError, "Vehicle DNA parts scan failed"), true, "dna_parts"); return end
  if not active.safetyBaseline then
    active.safetyBaseline = validator.buildGraph(scan, safetyContext(active, snapshot), {
      allowMissingParts = active.policy and active.policy.allowMissingParts == true,
    })
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
  local okApply, applyError = adapter.applyPartsTree(
    tree, active.reloadWriteTarget and active.reloadWriteTarget.vehicleId,
    active.backgroundTarget == true
  )
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
  local okSnapshot, snapshot = adapter.getTuningSnapshot(
    active.vehicleId, active.backgroundTarget == true
  )
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
  local okApply, applyError = adapter.applyTuning(
    values, active.reloadWriteTarget and active.reloadWriteTarget.vehicleId,
    active.backgroundTarget == true
  )
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
  local okPaints, current = adapter.getPaints(active.vehicleId, active.backgroundTarget == true)
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
  local okApply, applyResult = adapter.applyPaints(
    payload, active.vehicleId, active.backgroundTarget == true
  )
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
  if production.ensureEnergyStorageFloor(active, "dna_validation") then return end
  active.phase = "dna_validation"
  local transitioned, transitionError = operationState.transition(runtime.state, "validating", false)
  if not transitioned then
    failActive(adapter.errorValue("state_error", transitionError), true, "dna_validation")
    return
  end
  local safe, safetyOrError = validateFinalVehicle(active, "dna_validation")
  if safe == nil then return end
  if not safe then
    local decision = safetyOrError and safetyOrError.context and safetyOrError.context.decision
    if decision == validator.DECISIONS.UNKNOWN_OR_PENDING then
      production.preserveUnconfirmedSafetyResult(active, safetyOrError.context.safety, "dna_validation")
    else
      failActive(adapter.errorValue("dna_validation_failed", "Restored Vehicle DNA failed safety validation", {
        cause = safetyOrError, decision = decision,
      }), decision == validator.DECISIONS.INVALID_CONFIRMED, "dna_validation")
    end
    return
  end

  active.dnaSafetyResult = util.deepCopy(safetyOrError)
  verifyDNAFinal(active)
end

production.resumeSafetyContinuation = function(active, continuation)
  if not active or not operationState.isCurrent(runtime.state, active.token) then return false end
  if continuation == "random_config" then
    production.completeRandomConfig(active, active.lastVerificationDetails)
  elseif continuation == "chaos" then
    completeChaos(active)
  elseif continuation == "dna_validation" then
    validateDNAFinal(active)
  elseif continuation == "dna_replay" then
    local safe, safetyOrError = validateFinalVehicle(active, "dna_replay")
    if safe == nil then return true end
    if not safe then
      local decision = safetyOrError and safetyOrError.context and safetyOrError.context.decision
      if decision == validator.DECISIONS.UNKNOWN_OR_PENDING then
        production.preserveUnconfirmedSafetyResult(active, safetyOrError.context.safety, "dna_replay_verification")
      else
        failActive(safetyOrError, decision == validator.DECISIONS.INVALID_CONFIRMED, "dna_replay_verification")
      end
    else
      completeReplayGeneration(active, safetyOrError)
    end
  else
    production.preserveUnconfirmedSafetyResult(active, active.safetyResult or production.unknownSafetyResult(
      "safety_continuation_invalid", continuation
    ), "validation")
  end
  return true
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
  local okCapture, capture = adapter.captureCurrentState(
    active.kind, active.seed, active.vehicleId, active.backgroundTarget == true
  )
  if not okCapture then failActive(capture, true, "dna_final_verification"); return end
  local okSnapshot, snapshot = adapter.getCurrentSlotSnapshot(
    active.vehicleId, active.backgroundTarget == true
  )
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
    for _, saved in ipairs(active.dnaEntry.final.tuning or {}) do
      expectedTuning[saved.name] = active.energyGuardOverrides and active.energyGuardOverrides[saved.name]
        or saved.value
    end
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
    energyStorages = util.deepCopy(active.energyGuardReport),
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
  active.readBackStatus = "ready"
  active.lastAcceptedCheckpoint = completedPhase .. "_readback_confirmed"
  noteProgress(active, "readback", "target_identity_and_tree_confirmed")
  active.wait = nil
  active.waitContext = nil
  active.targetTracker = nil
  active.vehicleId = vehicleId
  runtime.state.vehicleId = vehicleId
  if completedPhase == "spawn" or completedPhase == "parts" or completedPhase == "tuning"
    or completedPhase == "undo" or completedPhase == "rollback" or completedPhase == "dna_base_spawn"
    or completedPhase == "dna_parts" or completedPhase == "dna_tuning" or completedPhase == "part_batch_rollback"
    or completedPhase == "part_isolation_test" or completedPhase == "fuel_guard"
    or completedPhase == "critical_repair"
  then
    active.reloadCount = (active.reloadCount or 0) + 1
  end
  active.readbackCount = (active.readbackCount or 0) + 1
  if active.reloadStartedAt then
    active.reloadDuration = (active.reloadDuration or 0)
      + math.max(0, runtime.time.realMonotonicTime - active.reloadStartedAt)
    active.reloadStartedAt = nil
  end
  if completedPhase == "parts" or completedPhase == "dna_parts"
    or completedPhase == "part_batch_rollback" or completedPhase == "part_isolation_test"
    or completedPhase == "critical_repair"
  then active.partsReloadCount = (active.partsReloadCount or 0) + 1 end
  if completedPhase == "tuning" or completedPhase == "dna_tuning"
    or completedPhase == "fuel_guard"
  then active.tuningReloadCount = (active.tuningReloadCount or 0) + 1 end
  if completedPhase == "critical_repair" or completedPhase == "part_batch_rollback"
    or completedPhase == "part_isolation_test"
  then active.repairReloadCount = (active.repairReloadCount or 0) + 1 end

  if completedPhase == "parts" or completedPhase == "part_isolation_test"
    or completedPhase == "part_batch_rollback" or completedPhase == "dna_parts"
    or completedPhase == "critical_repair"
  then
    setLifecyclePhase(active, "verifying_parts", false, "parts_reload_verified")
  elseif completedPhase == "tuning" or completedPhase == "dna_tuning" or completedPhase == "fuel_guard" then
    setLifecyclePhase(active, "verifying_tuning", false, "tuning_reload_verified")
  end

  if completedPhase == "spawn" then
    active.baseConfirmed = true
    local baseOk, baseSnapshot = adapter.captureCurrentState(
      active.kind, active.seed, active.vehicleId, active.backgroundTarget == true
    )
    if baseOk then
      active.operationCandidateBase = util.deepCopy(baseSnapshot)
      productionModules.baselineSemantics.setSelectedCandidate(active.baselines, baseSnapshot)
      productionModules.baselineSemantics.setCleanCandidate(active.baselines, baseSnapshot)
      vehicleRecovery.rememberReadable(runtime.recovery, baseSnapshot)
    end
    if afterReload == "randomConfig" then
      production.completeRandomConfig(active, verificationDetails)
    else
      operationState.transition(runtime.state, "scanning", false)
      active.pass = 1
      processMutationPass(active)
    end
  elseif completedPhase == "parts" then
    active.pass = active.pass + 1
    operationState.transition(runtime.state, "scanning", false)
    processMutationPass(active)
  elseif completedPhase == "critical_repair" then
    local repairPlan = active.criticalRepairPlan or {repairs = {}}
    local repaired = productionModules.criticalRepair.repairedPaths(repairPlan)
    for index = #active.changes, 1, -1 do
      if repaired[active.changes[index].slotPath] then table.remove(active.changes, index) end
    end
    for _, repair in ipairs(repairPlan.repairs or {}) do
      active.mutatedPaths[repair.slotPath] = true
      if active.slotLedger then
        for _, entry in pairs(active.slotLedger.entries or {}) do
          if entry.slotPath == repair.slotPath then
            entry.status = "repaired_critical_dependency"
            entry.reason = "critical_protection_precedence"
            entry.rollbackCount = (entry.rollbackCount or 0) + 1
          end
        end
      end
    end
    active.currentBatch = nil
    active.batchRollbackDecisions = nil
    if active.batchRecovery then active.batchRecovery.currentBatch = nil end
    active.criticalRepairSucceeded = true
    active.nonFatalPartial = true
    active.warnings[#active.warnings + 1] = string.format(
      "Repaired %d proven functional item(s) while retaining unrelated chaos changes.",
      #(repairPlan.repairs or {})
    )
    local acceptedOk, acceptedSnapshot = adapter.captureCurrentState(
      "critical_repair_accepted", active.seed, active.vehicleId,
      active.backgroundTarget == true
    )
    if acceptedOk then
      productionModules.baselineSemantics.acceptGenerated(active.baselines, acceptedSnapshot, {
        phase = "critical_repair", repairs = util.deepCopy(repairPlan.repairs or {}),
      })
      active.operationCurrentSnapshot = util.deepCopy(acceptedSnapshot)
    end
    diagnosticsModule.write(runtime.diagnostics, "I", "critical_dependency_repair_completed", {
      repairs = repairPlan.repairs, sourceType = repairPlan.sourceType,
      retainedMutationCount = repairPlan.retainedMutationCount,
    }, true)
    local continuation = active.criticalRepairContinuation
    local originPhase = active.criticalRepairOriginPhase
    active.criticalRepairPlan = nil
    active.criticalRepairContinuation = nil
    active.criticalRepairOriginPhase = nil
    if continuation == "parts" then
      operationState.transition(runtime.state, "scanning", false)
      processMutationPass(active)
    elseif originPhase and originPhase:find("dna", 1, true) then
      validateDNAFinal(active)
    elseif active.kind == "randomConfig" then
      production.completeRandomConfig(active, verificationDetails)
    else
      completeChaos(active)
    end
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
  elseif completedPhase == "fuel_guard" then
    operationState.transition(runtime.state, "tuning", false)
    active.energyGuardPendingPlan = nil
    local continuation = active.energyGuardContinuation
    active.energyGuardComplete = false
    if production.ensureEnergyStorageFloor(active, continuation) then return end
    if continuation == "random_config" then
      production.completeRandomConfig(active, verificationDetails)
    elseif continuation == "dna_validation" then
      validateDNAFinal(active)
    else
      completeChaos(active)
    end
  elseif completedPhase == "undo" then
    historyModule.pop(runtime.history)
    finishOperation(true, "undo_completed", "Previous vehicle state restored", {model = active.originalState.modelKey})
  elseif completedPhase == "rollback" then
    local originalFailure = active.rollbackFailure or failureRecord(active, "rollback", adapter.errorValue("operation_failed", "Operation failed"))
    historyTransaction.rollbackSucceeded(active, runtime.history, historyModule.pop)
    local readable, recoverySnapshot = adapter.captureCurrentState(
      "recovery", active.seed, active.vehicleId, active.backgroundTarget == true
    )
    if readable then vehicleRecovery.rememberReadable(runtime.recovery, recoverySnapshot) end
    local recoveryStep = active.recoveryStep or "previous"
    finishOperation(false, originalFailure.code, originalFailure.message .. "; vehicle recovery completed", {
      rollback = "completed",
      recoveryStep = recoveryStep,
      recoveryTier = active.recoveryTier,
      recoveryOutcome = "restored_explicit_snapshot",
      locksRequireReview = (active.recoveryTier or 6) >= 4,
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

production.restoreRacePlayerFocus = function(active, candidateVehicleId, source)
  if not active or active.backgroundTarget ~= true
    or type(active.lineupPlayerVehicleId) ~= "number"
  then return true end
  local restored, report = productionModules.raceFocusGuard.restore({
    playerVehicleId = active.lineupPlayerVehicleId,
    candidateVehicleId = candidateVehicleId,
    getCurrentVehicleId = adapter.getCurrentVehicleId,
    enterVehicle = adapter.enterVehicle,
  })
  active.playerFocusIsolation = util.deepCopy(type(report) == "table" and report or {
    reason = report, source = source,
  })
  diagnosticsModule.write(runtime.diagnostics, restored and "D" or "E",
    restored and "race_player_focus_verified" or "race_player_focus_restore_failed", {
      source = source, candidateVehicleId = candidateVehicleId,
      playerVehicleId = active.lineupPlayerVehicleId,
      report = util.deepCopy(report),
    }, not restored)
  return restored, report
end

local function onVehicleSpawned(vehicleId)
  nominateSpawnDirectorCandidate(vehicleId, "spawn")
  if not runtime.state.busy or not runtime.active or not runtime.active.targetTracker then return end
  local active = runtime.active
  if active.backgroundTarget then
    local expectedVehicleId = active.backgroundTargetVehicleId
      or active.expectedReplacementVehicleId or active.vehicleId
    if expectedVehicleId == nil and active.replaceWriteInFlight == true then
      if #active.unboundSpawnCallbacks < 16 then
        active.unboundSpawnCallbacks[#active.unboundSpawnCallbacks + 1] = vehicleId
      else
        active.ignoredBackgroundCallbacks = active.ignoredBackgroundCallbacks + 1
      end
      diagnosticsModule.write(runtime.diagnostics, "D", "background_spawn_callback_deferred", {
        vehicleId = vehicleId, expectedSlot = active.expectedSlot,
      })
      return
    end
    if type(expectedVehicleId) == "number" and vehicleId ~= expectedVehicleId then
      active.ignoredBackgroundCallbacks = active.ignoredBackgroundCallbacks + 1
      diagnosticsModule.write(runtime.diagnostics, "W", "background_spawn_callback_ignored", {
        vehicleId = vehicleId, expectedVehicleId = expectedVehicleId,
        expectedSlot = active.expectedSlot,
      }, true)
      return
    end
  end
  local owner = productionModules.domainOperations.ownership(runtime.domainOperations, vehicleId)
  if owner and (owner.domain ~= active.domain or owner.operationId ~= active.domainContext.operationId
    or owner.generation ~= active.domainContext.generation)
  then
    if owner.managed and not owner.accepted then
      productionModules.domainOperations.markOrphan(runtime.domainOperations, vehicleId, "ignored_stale_callback")
      productionModules.domainOperations.reap(
        runtime.domainOperations, productionModules.spawnAdapter.deleteVehicle,
        {domain = owner.domain, operationId = owner.operationId}
      )
    end
    runtime.state.staleCallbackCount = runtime.state.staleCallbackCount + 1
    diagnosticsModule.write(runtime.diagnostics, "W", "ignored_stale_callback", {
      source = "onVehicleSpawned", vehicleId = vehicleId,
      callbackDomain = owner.domain, activeDomain = active.domain,
      callbackOperationId = owner.operationId, activeOperationId = active.domainContext.operationId,
      cleanupResult = owner.managed and not owner.accepted and "orphan_removed" or "foreign_vehicle_preserved",
    }, true)
    return
  end
  local expectedCallbackVehicleId = active.expectedReplacementVehicleId
    or active.backgroundTargetVehicleId
  local callbackCorrelated = expectedCallbackVehicleId == nil
    or tonumber(expectedCallbackVehicleId) == tonumber(vehicleId)
  if callbackCorrelated then
    production.restoreRacePlayerFocus(active, vehicleId, "onVehicleSpawned")
    local domainToken = active.phaseCallbackTokens and active.phaseCallbackTokens.onVehicleSpawned
      or production.domainCallbackToken(active, "onVehicleSpawned", {
        expectedVehicleId = vehicleId, expectedSlot = active.expectedSlot,
      })
    local domainAccepted, domainReason = productionModules.domainOperations.registerCandidate(
      runtime.domainOperations, domainToken, vehicleId, {
        source = "onVehicleSpawned", created = vehicleId ~= active.originalVehicleId,
        observedAt = runtime.time.realMonotonicTime,
      }
    )
    if not domainAccepted then
      runtime.state.staleCallbackCount = runtime.state.staleCallbackCount + 1
      diagnosticsModule.write(runtime.diagnostics, "W", domainReason, {
        source = "onVehicleSpawned", vehicleId = vehicleId, activeDomain = active.domain,
      }, true)
      return
    end
    productionModules.operationContext.recordCandidate(production.ensureOperationContext(active), runtime.state, {
      vehicleId = vehicleId,
      source = "onVehicleSpawned",
      observedAt = runtime.time.realMonotonicTime,
      operationId = runtime.state.operationId,
      operationGeneration = runtime.state.operationGeneration,
      targetGeneration = runtime.state.targetGeneration,
      readStatus = "candidate_only",
    })
  else
    diagnosticsModule.write(runtime.diagnostics, "D", "callback_vehicle_mismatch_observed_only", {
      source = "onVehicleSpawned", vehicleId = vehicleId,
      expectedVehicleId = expectedCallbackVehicleId,
    })
  end
  local accepted, reason = vehicleTargetTracker.onSpawned(active.targetTracker, vehicleId)
  if not accepted and reason == "stale_callback_rejected" then
    runtime.state.staleCallbackCount = runtime.state.staleCallbackCount + 1
    diagnosticsModule.write(runtime.diagnostics, "E",
      active.recoveryOnly and "recovery_target_received_stale_mutation" or "stale_callback_rejected", {
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
  local verificationVehicleId = active.backgroundTarget
    and (active.backgroundTargetVehicleId or active.expectedReplacementVehicleId or active.vehicleId)
    or nil
  local okState, stateOrError = adapter.getVerificationState(
    verificationVehicleId, active.backgroundTarget == true
  )
  local observed = okState and stateOrError or nil
  if okState then
    if observed.readStatus and observed.readStatus ~= "ready" then
      active.readUnavailable = active.readUnavailable or {count = 0, firstAt = now}
      active.readUnavailable.count = active.readUnavailable.count + 1
      active.readUnavailable.lastCode = observed.readStatus
      active.readUnavailable.lastAt = now
    else
      active.readUnavailable = nil
    end
  else
    local readCode = type(stateOrError) == "table" and stateOrError.code or "config_read_unavailable"
    active.readUnavailable = active.readUnavailable or {count = 0, firstAt = now}
    active.readUnavailable.count = active.readUnavailable.count + 1
    active.readUnavailable.lastCode = readCode
    active.readUnavailable.lastAt = now
  end
  local context = util.deepCopy(active.waitContext or {})
  local status, reason, details = vehicleTargetTracker.observe(active.targetTracker, active.token, observed, now, context)
  active.lastTargetMetrics = vehicleTargetTracker.summary(active.targetTracker, now)
  if active.lastTargetMetrics.identityConfirmed and active.lastTargetMetrics.treeStatus ~= "not_required"
    and runtime.state.phase ~= "stabilizing_tree" then
    setLifecyclePhase(active, "stabilizing_tree",
      active.currentWaitTimeout or active.waitTimeout or WAIT_TIMEOUT, "target_identity_confirmed")
    active.targetTracker.phaseGeneration = runtime.state.phaseGeneration
    active.waitContext.phaseGeneration = runtime.state.phaseGeneration
    noteProgress(active, "binding", "target_identity_confirmed")
  end
  if status == "stable" then
    local rebound, concreteOrReason = productionModules.operationContext.rebindConcreteTarget(
      production.ensureOperationContext(active), runtime.state, {
        vehicleId = details.vehicleId,
        source = active.backgroundTarget and "stable_background_read" or "stable_player_read",
        observedAt = now,
        operationId = runtime.state.operationId,
        operationGeneration = runtime.state.operationGeneration,
        targetGeneration = runtime.state.targetGeneration,
        modelKey = details.state.modelKey,
        configKey = details.state.configKey,
        configIdentity = details.state.configIdentity,
        playerIndex = active.backgroundTarget ~= true and (details.state.playerIndex or 0) or nil,
        targetRole = details.state.targetRole,
        readStatus = details.state.readStatus,
        coherentTargetRead = details.state.coherentTargetRead == true,
        stable = true,
        correlationEvidence = {
          identityConfirmed = true,
          treeStatus = active.lastTargetMetrics.treeStatus,
          returnedVehicleId = active.targetTracker.returnedVehicleId,
        },
      }, now
    )
    if not rebound then
      failActive(adapter.errorValue(concreteOrReason, "The stable player target could not be rebound", {
        lifecycle = active.lastTargetMetrics,
      }), true, active.wait and active.wait.phase or "lifecycle")
      return true
    end
    local concrete = util.deepCopy(concreteOrReason)
    active.targetOwnershipConfirmed = true
    active.targetOwnershipConfirmedAt = now
    active.vehicleId = concrete.vehicleId
    active.reloadWriteTarget = nil
    if active.recoveryOnly then active.operationRecoveryTarget = concrete
    else active.operationCurrentTarget = concrete end
    runtime.state.vehicleId = concrete.vehicleId
    runtime.state.expectedTarget = util.deepCopy(active.logicalTarget)
    active.lastAcceptedCheckpoint = "concrete_target_rebound"
    noteProgress(active, "binding", "concrete_target_rebound")
    diagnosticsModule.write(runtime.diagnostics, "I", "concrete_target_rebound", {
      target = concrete,
      logicalTarget = util.deepCopy(active.logicalTarget),
      treeStatus = active.lastTargetMetrics.treeStatus,
      returnedVehicleId = active.targetTracker.returnedVehicleId,
      clocks = timeSource.snapshot(runtime.time),
      operationGeneration = runtime.state.operationGeneration,
      phaseGeneration = runtime.state.phaseGeneration,
      targetGeneration = runtime.state.targetGeneration,
    }, true)
    noteProgress(active, "readback", "target_tree_converged")
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
  local playerSwitch = player == nil or player == 0
  if runtime.state.busy and runtime.active and runtime.active.backgroundTarget and playerSwitch then
    local active = runtime.active
    if tonumber(newId) == tonumber(active.lineupPlayerVehicleId) then
      active.ignoredBackgroundCallbacks = active.ignoredBackgroundCallbacks + 1
      diagnosticsModule.write(runtime.diagnostics, "D", "background_operation_player_focus_already_restored", {
        oldId = oldId, newId = newId, player = player, expectedSlot = active.expectedSlot,
      })
      return
    end
    local restored, restoreReason = production.restoreRacePlayerFocus(
      active, newId, "onVehicleSwitched"
    )
    active.ignoredBackgroundCallbacks = active.ignoredBackgroundCallbacks + 1
    diagnosticsModule.write(runtime.diagnostics, restored and "D" or "E",
      "background_operation_player_switch_restored", {
        oldId = oldId, newId = newId, player = player,
        expectedSlot = active.expectedSlot, restored = restored,
        reason = restoreReason,
      }, not restored)
    return
  end
  if playerSwitch then nominateSpawnDirectorCandidate(newId, "switch", oldId) end
  if runtime.stress and runtime.stress.active and not runtime.state.busy
    and (player == nil or player == 0)
    and newId ~= runtime.stress.vehicleId
  then
    cancelDeveloperStressInternal("vehicle_changed")
    return
  end
  if not runtime.state.busy or not runtime.active then return end
  local active = runtime.active
  if player == nil or player == 0 then
    local owner = productionModules.domainOperations.ownership(runtime.domainOperations, newId)
    if owner and (owner.domain ~= active.domain or owner.operationId ~= active.domainContext.operationId
      or owner.generation ~= active.domainContext.generation)
    then
      runtime.state.staleCallbackCount = runtime.state.staleCallbackCount + 1
      diagnosticsModule.write(runtime.diagnostics, "W", "ignored_stale_callback", {
        source = "onVehicleSwitched", oldId = oldId, newId = newId,
        callbackDomain = owner.domain, activeDomain = active.domain,
        callbackOperationId = owner.operationId, activeOperationId = active.domainContext.operationId,
      }, true)
      cancelOperation("foreign_vehicle_switch", "Operation cancelled because the player switched to a vehicle owned by another domain")
      return
    end
  end
  if active.targetTracker then
    if player == nil or player == 0 then
      local expectedCallbackVehicleId = active.expectedReplacementVehicleId
        or active.backgroundTargetVehicleId
      local callbackCorrelated = active.replaceWriteInFlight ~= true
        and (expectedCallbackVehicleId == nil
          or tonumber(expectedCallbackVehicleId) == tonumber(newId))
      if callbackCorrelated then
        local domainToken = active.phaseCallbackTokens and active.phaseCallbackTokens.onVehicleSwitched
          or production.domainCallbackToken(active, "onVehicleSwitched", {
            expectedVehicleId = newId, expectedSlot = active.expectedSlot,
          })
        local registered, registerReason = productionModules.domainOperations.registerCandidate(
          runtime.domainOperations, domainToken, newId, {
            source = "onVehicleSwitched", created = newId ~= active.originalVehicleId,
            observedAt = runtime.time.realMonotonicTime,
          }
        )
        if not registered then
          runtime.state.staleCallbackCount = runtime.state.staleCallbackCount + 1
          diagnosticsModule.write(runtime.diagnostics, "W", registerReason, {
            source = "onVehicleSwitched", oldId = oldId, newId = newId,
          }, true)
          return
        end
        productionModules.operationContext.recordCandidate(production.ensureOperationContext(active), runtime.state, {
          vehicleId = newId,
          source = "onVehicleSwitched",
          observedAt = runtime.time.realMonotonicTime,
          operationId = runtime.state.operationId,
          operationGeneration = runtime.state.operationGeneration,
          targetGeneration = runtime.state.targetGeneration,
          playerIndex = 0,
          readStatus = "candidate_only",
          correlationEvidence = {oldId = oldId},
        })
      else
        diagnosticsModule.write(runtime.diagnostics, "D", "callback_vehicle_mismatch_observed_only", {
          source = "onVehicleSwitched", oldId = oldId, newId = newId,
          expectedVehicleId = expectedCallbackVehicleId,
          replaceWriteInFlight = active.replaceWriteInFlight == true,
        })
      end
    end
    local accepted, reason = vehicleTargetTracker.onSwitched(
      active.targetTracker, oldId, newId, player,
      active.replaceWriteInFlight == true
    )
    if not accepted and reason == "stale_callback_rejected" then
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

local function onVehicleDestroyed(vehicleId, destructionReason)
  if type(productionModules.spawnAdapter.invalidateDimensions) == "function" then
    productionModules.spawnAdapter.invalidateDimensions(vehicleId)
  end
  local normalizedReason = util.normalizeText(type(destructionReason) == "table"
    and (destructionReason.reason or destructionReason.cause) or destructionReason)
  local correlatedCause = normalizedReason:find("instabil", 1, true)
    and "INSTABILITY_CONFIRMED" or "UNKNOWN_FAILURE"
  productionModules.domainOperations.recordRemoval(runtime.domainOperations, vehicleId, correlatedCause)
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
      if active.operationContext then
        productionModules.operationContext.markDestroyed(active.operationContext, vehicleId)
      end
      diagnosticsModule.write(runtime.diagnostics, "D", "vehicle_target_destroyed_observed", {
        phase = active.phase, vehicleId = vehicleId, destructionReason = destructionReason,
        correlatedCause = correlatedCause,
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
  runtime.racePreview = nil
  if runtime.spawnDirector.run then runtime.spawnDirector.run.active = false end
  production.controlManagedAI("reset")
end

local function onModStateChanged(modData)
  runtime.index.stale = true
  if runtime.indexer.active then productionModules.incrementalIndexer.cancel(runtime.indexer, "mod_state_changed") end
  if type(adapter.invalidateRegistryCache) == "function" then adapter.invalidateRegistryCache() end
  productionModules.registryReadiness.begin(runtime.registry, adapter.clock(), "mod_state_changed")
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

function production.clearManagedRaceVehicles(reason, lineup)
  lineup = lineup or runtime.lineup.current
  local result = {removed = {}, failed = {}, blocked = {}, skipped = {}}
  if not lineup then return result end
  local expectedHandles = {}
  local playerVehicleId = tonumber(lineup.playerVehicleId or lineup.playerParticipantVehicleId)
  for _, competitor in ipairs(lineup.competitors or {}) do
    local handle = competitor.managedHandle
    if handle then expectedHandles[handle] = true end
    local classification, entryOrReason = productionModules.raceManager.cleanupClassification(
      lineup, competitor, runtime.managedVehicles,
      productionModules.spawnAdapter.objectExists
    )
    if classification == "KNOWN_REMOVED" then
      result.skipped[#result.skipped + 1] = {
        slotId = competitor.slotId or tostring(competitor.index),
        reason = "already_removed",
      }
    elseif classification == "UNRELATED" then
      result.skipped[#result.skipped + 1] = {
        slotId = competitor.slotId or tostring(competitor.index),
        reason = entryOrReason,
      }
    elseif classification == "UNKNOWN_BINDING" then
      result.blocked[#result.blocked + 1] = {
        slotId = competitor.slotId or tostring(competitor.index),
        vehicleId = competitor.currentVehicleId,
        reason = type(entryOrReason) == "string" and entryOrReason or "race_cleanup_binding_missing",
      }
    else
      local entry = entryOrReason
      local authorized, ownerOrReason = false, nil
      if entry and tonumber(entry.vehicleId) ~= playerVehicleId then
        authorized, ownerOrReason = productionModules.domainOperations.authorizeManagedCleanup(
          runtime.domainOperations, entry.vehicleId, {
            operationId = competitor.operationId, generation = competitor.generation,
            slot = competitor.index,
          }
        )
      elseif entry then ownerOrReason = "race_cleanup_player_protected" end
      if not authorized then
        result.blocked[#result.blocked + 1] = {
          handle = handle, slotId = competitor.slotId or tostring(competitor.index),
          vehicleId = competitor.currentVehicleId,
          reason = type(ownerOrReason) == "string" and ownerOrReason or "race_cleanup_ownership_unproven",
        }
      else
        productionModules.aiAdapter.stop(entry.vehicleId, true)
        local deleted, deleteReason = productionModules.spawnAdapter.deleteVehicle(entry.vehicleId)
        if deleted or deleteReason == "vehicle_missing" then
          result.removed[#result.removed + 1] = entry.vehicleId
          productionModules.domainOperations.recordRemoval(
            runtime.domainOperations, entry.vehicleId, reason or "race_generation_replaced"
          )
          productionModules.managedRegistry.remove(runtime.managedVehicles, entry.handle)
          productionModules.raceManager.markRemoved(competitor, {
            lineupId = lineup.id, managedHandle = entry.handle,
            vehicleId = entry.vehicleId, operationId = competitor.operationId,
            generation = competitor.generation,
            reason = reason or "race_generation_replaced",
          })
        else
          result.failed[#result.failed + 1] = {
            handle = handle, slotId = competitor.slotId or tostring(competitor.index),
            vehicleId = entry.vehicleId, reason = deleteReason,
          }
        end
      end
    end
  end
  for _, entry in ipairs(productionModules.managedRegistry.list(runtime.managedVehicles)) do
    if not expectedHandles[entry.handle] then
      result.skipped[#result.skipped + 1] = {
        handle = entry.handle, vehicleId = entry.vehicleId, reason = "not_owned_by_target_lineup",
      }
    end
  end
  return result
end

function production.cancelRaceGeneration(reason)
  local lineup = runtime.lineup.current
  if not lineup then return false end
  reason = reason or "Race generation cancelled by user"
  runtime.lineup.pendingNext = false
  runtime.racePreview = nil
  productionModules.raceManager.cancel(lineup, reason)
  lineup.removeAcceptedOnCancel = lineup.settings and lineup.settings.retainAcceptedOnCancel == false
  if runtime.active and runtime.active.domain == "race" then
    cancelCurrentOperation()
  else
    local domainContext = productionModules.domainOperations.active(runtime.domainOperations, "race")
    if domainContext and domainContext.terminalState == nil then
      productionModules.domainOperations.terminal(
        runtime.domainOperations, domainContext, "cancelled",
        {rollbackReason = reason, endedAt = runtime.time.realMonotonicTime}
      )
      productionModules.domainOperations.reap(
        runtime.domainOperations, productionModules.spawnAdapter.deleteVehicle,
        {domain = "race", operationId = domainContext.operationId}
      )
    end
    if lineup.removeAcceptedOnCancel then
      production.clearManagedRaceVehicles("race_cancel_policy_cleanup")
      lineup.removeAcceptedOnCancel = false
    end
  end
  production.persistCurrentLineup()
  setResult(true, "race_generation_cancelled", reason)
  publishState()
  return true
end

function production.persistCurrentLineup()
  local current = runtime.lineup.current
  if not current then return false, "lineup_missing" end
  local valid, reason = productionModules.lineupSchema.validate(current, {allowOne = true})
  if not valid then
    local failure = productionModules.lineupPersistence.recordFailure(
      current, reason, "schema", runtime.time.realMonotonicTime
    )
    return false, failure.code
  end
  local added, stored, candidateLibrary = productionModules.lineupPersistence.checkpoint(
    runtime.lineup.library, current, productionModules.lineupStorage
  )
  if not added then
    local failure = productionModules.lineupPersistence.recordFailure(
      current, stored, "serialization", runtime.time.realMonotonicTime
    )
    return false, failure.code
  end
  if runtime.capabilities.lineupWrite and type(adapter.saveLineupLibrary) == "function" then
    local ok, writeError = adapter.saveLineupLibrary(candidateLibrary)
    if not ok then
      local failure = productionModules.lineupPersistence.recordFailure(
        current, writeError, "write", runtime.time.realMonotonicTime
      )
      if not util.arrayContains(current.warnings, "Race progress is active but its latest checkpoint is not saved.") then
        current.warnings[#current.warnings + 1] =
          "Race progress is active but its latest checkpoint is not saved."
      end
      return false, failure.code
    end
  end
  runtime.lineup.library = candidateLibrary
  productionModules.lineupPersistence.recordSuccess(current, runtime.time.realMonotonicTime)
  return true
end

function production.retryLineupPersistence()
  initialize()
  if runtime.state.busy then
    setResult(false, "operation_busy", "Finish the active vehicle operation before retrying storage")
    publishState()
    return false
  end
  if not runtime.lineup.current then
    setResult(false, "lineup_missing", "There is no Race lineup to save")
    publishState()
    return false
  end
  local saved, reason = production.persistCurrentLineup()
  local persistence = util.deepCopy(runtime.lineup.current.persistence)
  setResult(saved, saved and "lineup_storage_recovered" or reason,
    saved and "The Race lineup checkpoint is saved" or "The Race lineup checkpoint is still not saved", {
      persistence = persistence, recoverable = not saved and persistence.recoverable == true,
      retryAction = not saved and persistence.retryAction or nil,
    })
  publishState()
  return saved
end

production.generationPreviewContext = function(options, lineup, playerOk, playerVehicleId)
  options = type(options) == "table" and options or {}
  local frameOk, frame = productionModules.spawnAdapter.cameraFrame()
  if not frameOk then return nil, "lineup_staging_frame_unavailable" end
  local origin = options.previewOrigin or "automatic"
  local playerPositionOk, playerPosition = false, nil
  local playerForwardOk, playerForward = false, nil
  if playerOk and type(playerVehicleId) == "number" then
    playerPositionOk, playerPosition = productionModules.spawnAdapter.objectPosition(playerVehicleId)
    playerForwardOk, playerForward = productionModules.spawnAdapter.playerForward()
  end
  if origin == "automatic" and playerPositionOk and playerForwardOk then
    frame.position = util.deepCopy(playerPosition)
    frame.forward = {
      x = tonumber(playerForward.x) or 0,
      y = tonumber(playerForward.y) or 1,
      z = 0,
    }
    frame.right = {x = frame.forward.y, y = -frame.forward.x, z = 0}
  elseif origin == "player_front" or origin == "player_behind" then
    if not playerPositionOk or not playerForwardOk then return nil, "preview_player_origin_unavailable" end
    local direction = origin == "player_behind" and -1 or 1
    frame.position = util.deepCopy(playerPosition)
    frame.forward = {
      x = (tonumber(playerForward.x) or 0) * direction,
      y = (tonumber(playerForward.y) or 1) * direction,
      z = 0,
    }
    frame.right = {x = frame.forward.y, y = -frame.forward.x, z = 0}
  elseif origin == "custom" then
    local custom = options.customPoint
    if type(custom) ~= "table" then
      custom = {x = options.customPointX, y = options.customPointY, z = options.customPointZ}
    end
    if not util.isFinite(tonumber(custom.x)) or not util.isFinite(tonumber(custom.y))
      or not util.isFinite(tonumber(custom.z))
    then return nil, "preview_custom_origin_invalid" end
    frame.position = {x = tonumber(custom.x), y = tonumber(custom.y), z = tonumber(custom.z)}
  end
  if playerForwardOk then frame.playerForward = util.deepCopy(playerForward) end
  if options.headingMode == "road" then
    local roadOk, roadForward = productionModules.spawnAdapter.roadForward(frame.position)
    if roadOk then frame.roadForward = roadForward end
  end
  local occupied = production.occupiedManagedPositions() or {}
  if playerPositionOk then
    local dimensions = productionModules.spawnAdapter.vehicleDimensions(playerVehicleId, 0)
    local playerRadius = type(dimensions) == "table"
      and math.max(tonumber(dimensions.width) or 2, tonumber(dimensions.length) or 4.8) * 0.5
      or 2.4
    occupied[#occupied + 1] = {
      x = playerPosition.x, y = playerPosition.y, z = playerPosition.z,
      radius = playerRadius + 1.5, vehicleId = playerVehicleId, protectedPlayer = true,
    }
  end
  local planningStarted = adapter.clock()
  local plan, planReason, planning = productionModules.spawnDirector.plan(frame, {
    -- Generation uses a dedicated, forward staging grid. The requested final
    -- formation remains a later positioning concern and never falls back to a
    -- generic spawn beside or behind the camera.
    mode = "Staggered Grid",
    count = #lineup.competitors,
    spacingMode = lineup.settings.spacingMode,
    longitudinalSpacing = lineup.settings.longitudinalSpacing,
    lateralSpacing = lineup.settings.lateralSpacing,
    safetyMargin = lineup.settings.safetyMargin,
    columns = math.max(1, math.ceil(math.sqrt(#lineup.competitors))),
    headingMode = options.headingMode or "camera",
    destination = runtime.destination.active and runtime.destination.confirmed
      and util.deepCopy(runtime.destination.point) or nil,
    minimumObjectDistance = 3,
    interval = 0.25,
  }, productionModules.spawnAdapter.raycastGround, occupied)
  planning = util.deepCopy(planning or plan and plan.planning or {})
  planning.durationMs = math.max(0, (adapter.clock() - planningStarted) * 1000)
  productionModules.performanceMetrics.record(
    runtime.performanceTelemetry, "racePlacementPlanning", planning.durationMs
  )
  if not plan then return nil, planReason, planning end
  plan.planning = planning
  local playerPlacement
  if lineup.playerParticipates and playerPositionOk then
    local playerDimensions = productionModules.spawnAdapter.vehicleDimensions(playerVehicleId, 0)
    if type(playerDimensions) == "table" then playerDimensions.source = "actual_vehicle_bounds" end
    playerPlacement = {
      position = playerPosition,
      forward = playerForwardOk and playerForward or frame.forward,
      normal = {x = 0, y = 0, z = 1},
      dimensions = playerDimensions,
    }
  end
  return {plan = plan, frame = frame, playerPlacement = playerPlacement,
    planning = util.deepCopy(planning)}
end

function production.previewRaceGeneration(options)
  initialize()
  options = type(options) == "table" and util.deepCopy(options) or {}
  if options.previewEnabled == false then
    if runtime.racePreview then
      productionModules.racePreview.clear(runtime.racePreview, "preference_disabled")
    else
      runtime.racePreview = {enabled = false, state = "PREVIEW_DISABLED", slots = {},
        clearedReason = "preference_disabled"}
    end
    setResult(true, "race_preview_disabled", "Race generation preview disabled")
    publishState()
    return true
  end
  if runtime.state.busy then
    setResult(false, "operation_busy", "Race generation preview cannot change during an active operation")
    publishState()
    return false
  end
  local attempt = productionModules.raceAttemptCoordinator.begin(runtime.raceAttempts,
    "preview_generation", {now = runtime.time.realMonotonicTime, deadlineSeconds = 10, desired = options})
  local function finishAttempt(status, errorCode, recoverable)
    productionModules.raceAttemptCoordinator.finish(runtime.raceAttempts, attempt, status, {
      now = runtime.time.realMonotonicTime, errorCode = errorCode, recoverable = recoverable,
      retryAction = "previewRaceGeneration",
    })
  end
  local lineup, reason = productionModules.raceManager.create(options)
  if not lineup then
    finishAttempt("failed", reason, false)
    setResult(false, reason, "Race preview options are invalid")
    publishState()
    return false
  end
  local playerOk, playerVehicleId = adapter.getCurrentVehicleId()
  if lineup.playerParticipates and (not playerOk or type(playerVehicleId) ~= "number") then
    finishAttempt("failed", "lineup_player_vehicle_required", true)
    setResult(false, "lineup_player_vehicle_required",
      "Player participates requires an active player vehicle")
    publishState()
    return false
  end
  productionModules.raceAttemptCoordinator.setPhase(runtime.raceAttempts, attempt, "planning_staging")
  local context, previewReason, previewPlanning = production.generationPreviewContext(
    options, lineup, playerOk, playerVehicleId
  )
  if not context then
    finishAttempt("failed", previewReason, true)
    setResult(false, previewReason, "Race generation preview is unavailable", {
      operationId = attempt.operationId, generation = attempt.generation,
      recoverable = true, retryAction = "previewRaceGeneration",
      planning = util.deepCopy(previewPlanning),
    })
    publishState()
    return false
  end
  runtime.racePreview = productionModules.racePreview.build(
    "generation_staging", context.plan, lineup, context.playerPlacement, true
  )
  runtime.racePreview.operationId = attempt.operationId
  runtime.racePreview.generation = attempt.generation
  finishAttempt("succeeded")
  setResult(true, "race_generation_preview_data_ready", "Race generation preview data is ready", {
    totalVehicles = lineup.totalVehicles,
    aiOpponents = lineup.aiOpponentCount,
    kind = runtime.racePreview.kind, previewState = runtime.racePreview.state,
    operationId = attempt.operationId, generation = attempt.generation,
    planning = util.deepCopy(context.planning),
  })
  publishState()
  return true
end

function production.createChaosLineup(options)
  initialize()
  if runtime.state.busy then
    setResult(false, "lineup_busy", "A lineup or vehicle operation is already running"); publishState(); return false
  end
  if runtime.capabilities.managedMultiVehicle ~= true
    or runtime.capabilities.backgroundVehicleWrite ~= true
  then
    setResult(false, "race_background_target_unsupported",
      "Race generation requires ID-bound non-player vehicle writes in this BeamNG build")
    publishState()
    return false
  end
  options = type(options) == "table" and util.deepCopy(options) or {}
  if not runtime.index.valid or runtime.index.stale == true then
    local scheduled, indexResult = rebuildIndex()
    setResult(false, scheduled and "race_pool_indexing" or "race_pool_index_unavailable",
      scheduled and "The installed vehicle catalog is being indexed; retry Race generation when it is ready"
        or "The Race candidate pool could not be inspected", {
        cause = scheduled and "CANDIDATE_POOL_PENDING" or "CANDIDATE_RESOLUTION_FAILED",
        index = util.deepCopy(indexResult), recoverable = scheduled == true,
        retryAction = scheduled and "createChaosLineup" or nil,
      })
    publishState()
    return false
  end
  local requestedPreset = productionModules.raceManager.PRESETS[options.preset]
    and options.preset or "Balanced"
  local resolvedPoolOptions = productionModules.raceManager.presetOptions(requestedPreset, options)
  local poolSettings = util.deepCopy(runtime.settings)
  poolSettings.contentFilter = resolvedPoolOptions.contentFilter or poolSettings.contentFilter
  poolSettings.includeAutomation = resolvedPoolOptions.allowAutomationVehicles == true
  poolSettings.includeTrailers = resolvedPoolOptions.allowTrailers == true
  poolSettings.includeProps = resolvedPoolOptions.allowProps == true
  local pool = productionModules.raceManager.poolSummary(
    contentIndex.eligibleModels(runtime.index, poolSettings), resolvedPoolOptions, {}
  )
  if not pool.available then
    local zeroCode = requestedPreset == "Mods Showcase"
      and "race_zero_pool_mods_showcase" or "race_zero_pool"
    setResult(false, zeroCode,
      requestedPreset == "Mods Showcase"
        and "No eligible mod vehicles are installed for Mods Showcase"
        or "No eligible vehicles match the selected Race preset and filters", {
        cause = "ZERO_POOL", preset = requestedPreset, pool = pool,
        alternatives = {"Balanced", "Custom", "Maximum Chaos"},
        recoverable = true, retryAction = "createChaosLineup",
      })
    publishState()
    return false
  end
  local attempt = productionModules.raceAttemptCoordinator.begin(runtime.raceAttempts,
    "lineup_generation", {now = runtime.time.realMonotonicTime, deadlineSeconds = 15, desired = options})
  local function finishAttempt(status, errorCode, recoverable)
    productionModules.raceAttemptCoordinator.finish(runtime.raceAttempts, attempt, status, {
      now = runtime.time.realMonotonicTime, errorCode = errorCode, recoverable = recoverable,
      retryAction = "createChaosLineup",
    })
  end
  local lineup, reason = productionModules.raceManager.create(options)
  if not lineup then
    finishAttempt("failed", reason, false)
    setResult(false, reason, "Race grid options are invalid", {
      operationId = attempt.operationId, generation = attempt.generation,
    }); publishState(); return false
  end
  local playerOk, playerVehicleId = adapter.getCurrentVehicleId()
  if lineup.playerParticipates and (not playerOk or type(playerVehicleId) ~= "number") then
    finishAttempt("failed", "lineup_player_vehicle_required", true)
    setResult(false, "lineup_player_vehicle_required",
      "Player participates requires an active player vehicle. Choose Spectator / camera only to generate without one.")
    publishState()
    return false
  end
  lineup.generationState = "lineup_processing"
  productionModules.raceAttemptCoordinator.setPhase(runtime.raceAttempts, attempt, "planning_staging")
  local previewContext, stagingReason, stagingPlanning = production.generationPreviewContext(
    options, lineup, playerOk, playerVehicleId
  )
  if not previewContext then
    lineup.generationState = "lineup_failed"
    lineup.processingState = "lineup_processing_finished"
    finishAttempt("failed", "lineup_staging_unsafe", true)
    setResult(false, "lineup_staging_unsafe", "Race cars were not generated because safe staging failed", {
      reason = stagingReason, operationId = attempt.operationId, generation = attempt.generation,
      recoverable = true, retryAction = "createChaosLineup",
      planning = util.deepCopy(stagingPlanning),
    })
    publishState()
    return false
  end
  productionModules.raceAttemptCoordinator.setPhase(runtime.raceAttempts, attempt, "replacing_previous_lineup")
  local previousLineup = runtime.lineup.current
  local cleanup = production.clearManagedRaceVehicles("new_race_generation", previousLineup)
  if #cleanup.failed > 0 or #cleanup.blocked > 0 then
    finishAttempt("failed", "race_cleanup_failed", true)
    setResult(false, "race_cleanup_failed", "Previous managed Race vehicles could not be cleaned safely", {
      removed = cleanup.removed, failed = cleanup.failed, blocked = cleanup.blocked,
      skipped = cleanup.skipped,
      operationId = attempt.operationId, generation = attempt.generation,
      recoverable = true, retryAction = "createChaosLineup",
    })
    publishState()
    return false
  end
  if previousLineup and previousLineup.active then
    productionModules.raceManager.cancel(previousLineup, "Superseded by a new Race generation")
    runtime.lineup.pendingNext = false
  end
  lineup.playerVehicleId = playerOk and playerVehicleId or nil
  lineup.playerParticipantVehicleId = lineup.playerParticipates and playerVehicleId or nil
  lineup.preservedExternalVehicleId = playerOk and playerVehicleId or nil
  local staging = previewContext.plan
  lineup.stagingPlan = util.deepCopy(staging.placements)
  lineup.stagingPreview = {
    status = "validated",
    requestedMode = staging.options.requestedMode,
    effectiveMode = staging.options.mode,
    formation = lineup.settings.formation,
    fallbackReason = staging.options.fallbackReason,
    count = #staging.placements,
    resolvedLateralSpacing = staging.options.resolvedLateralSpacing,
    resolvedLongitudinalSpacing = staging.options.resolvedLongitudinalSpacing,
    planning = util.deepCopy(staging.planning),
  }
  for index, competitor in ipairs(lineup.competitors) do
    competitor.stagingPlacement = util.deepCopy(staging.placements[index])
  end
  runtime.racePreview = productionModules.racePreview.build(
    "generation_staging", staging, lineup, previewContext.playerPlacement,
    lineup.settings.previewEnabled ~= false
  )
  runtime.lineup.current = lineup
  lineup.setupAttempt = {operationId = attempt.operationId, generation = attempt.generation}
  lineup.generationState = "lineup_processing"
  lineup.schedulerState = "scheduled"
  lineup.schedulerLastProgressAt = runtime.time.realMonotonicTime
  runtime.lineup.pendingNext = true
  local persisted, persistReason = production.persistCurrentLineup()
  finishAttempt("succeeded")
  setResult(true, persisted and "lineup_started" or "lineup_started_with_storage_warning",
    persisted and "Race grid generation started" or "The Race grid was created but its initial checkpoint could not be saved",
    {episodeSeed = lineup.episodeSeed, count = #lineup.competitors,
      seedIntent = lineup.seedIntent, repeatedFromLineupId = lineup.repeatedFromLineupId,
      totalVehicles = lineup.totalVehicles, aiOpponents = lineup.aiOpponentCount,
      playerParticipates = lineup.playerParticipates, cleanup = cleanup,
      stagingPreview = util.deepCopy(lineup.stagingPreview),
      planning = util.deepCopy(staging.planning), storageReason = persistReason})
  publishState()
  return true
end

function production.startNextLineupCompetitor()
  if runtime.state.busy or not runtime.lineup.pendingNext or not runtime.lineup.current then return false end
  runtime.lineup.pendingNext = false
  local competitor = productionModules.raceManager.nextCompetitor(runtime.lineup.current)
  if not competitor then
    local summary = productionModules.raceManager.summary(runtime.lineup.current)
    local saved, reason = production.persistCurrentLineup()
    local outcome = runtime.lineup.current.generationState
    local accepted = outcome == "lineup_ready" or outcome == "lineup_partial"
    setResult(accepted, saved and outcome or accepted and "lineup_ready_with_storage_warning"
        or "lineup_finished_with_storage_warning",
      saved and (outcome == "lineup_ready" and "Race grid ready"
        or outcome == "lineup_partial" and "Race grid generation completed partially"
        or "Race grid generation finished without a usable opponent")
        or accepted and "Race grid is ready, but its latest checkpoint is not saved"
        or "Race grid finished without a usable opponent and storage verification failed", {
      summary = summary, processingState = "lineup_processing_finished", reason = reason,
      persistenceWarning = saved and nil or reason,
    })
    publishState()
    return false
  end
  local checkpointed, checkpointReason = production.persistCurrentLineup()
  if not checkpointed then
    competitor.warning = "Generation continues; this checkpoint is not saved yet"
    diagnosticsModule.write(runtime.diagnostics, "W", "lineup_checkpoint_deferred", {
      index = competitor.index, reason = checkpointReason,
    }, true)
  end
  local previousSettings = util.deepCopy(runtime.settings)
  local settings = util.deepCopy(runtime.settings)
  local attemptNumber = (competitor.attemptCount or 0) + 1
  settings.manualSeed = productionModules.raceManager.domainSeed(
    runtime.lineup.current, competitor, "operation", attemptNumber
  ) or competitor.seed
  settings.seedMode = "fixed"
  settings.allowPartialResult = runtime.lineup.current.acceptPartial == true
  if competitor.forceOfficialFallback then settings.contentFilter = "official" end
  for key, value in pairs(runtime.lineup.current.settings.actionSettings or {}) do
    if value ~= nil then settings[key] = value end
  end
  runtime.settings = settingsModule.validate(settings)
  local excludedModels, excludedConfigurations = {}, {}
  local acceptedCompetitors = {}
  local rules = runtime.lineup.current.varietyRules or {}
  for _, previous in ipairs(runtime.lineup.current.competitors or {}) do
    if previous.index < competitor.index and (previous.status == "ready" or previous.status == "ready_with_warnings" or previous.status == "partial") then
      acceptedCompetitors[#acceptedCompetitors + 1] = util.deepCopy(previous)
      if rules.avoidDuplicateModels and previous.modelKey then excludedModels[#excludedModels + 1] = previous.modelKey end
      if rules.avoidDuplicateConfigurations and previous.modelKey and previous.configuration then
        excludedConfigurations[#excludedConfigurations + 1] = tostring(previous.modelKey) .. "/"
          .. tostring(configVerification.stableKey(previous.configuration) or previous.configuration)
      end
    end
  end
  local started = runActionInternal("fullRandom", {
    domain = "race",
    expectedSlot = competitor.index,
    expectedLogicalTarget = {competitorId = competitor.id, requestedIndex = competitor.index},
    lineupExcludedModels = excludedModels,
    lineupExcludedConfigurations = excludedConfigurations,
    lineupRules = rules,
    lineupAcceptedCompetitors = acceptedCompetitors,
    safeOfficial = competitor.forceOfficialFallback == true,
    startWithoutVehicle = true,
    lineupIndex = competitor.index,
    lineupSeed = runtime.lineup.current.episodeSeed,
    lineupAttempt = attemptNumber,
    lineupTargetGeneration = competitor.targetGeneration,
    lineupPreviousSettings = previousSettings,
    lineupPlayerVehicleId = runtime.lineup.current.playerVehicleId,
    lineupOwnedTarget = true,
    backgroundTarget = true,
    lineupStagingPlacement = util.deepCopy(competitor.stagingPlacement),
    racePermissiveDrivability = runtime.lineup.current.acceptPotentiallyUndrivable == true,
    operationTimeout = runtime.lineup.current.settings.maxWallClockSecondsPerCompetitor or 180,
  })
  if started and runtime.active then
    runtime.active.captureOperation = "fullRandom"
    competitor.operationId = runtime.active.operationId
    competitor.generation = runtime.active.operationGeneration
    competitor.logicalCandidate = {
      targetGeneration = runtime.active.targetGeneration,
      stagingPlacement = util.deepCopy(competitor.stagingPlacement),
    }
    competitor.startedAtMonotonic = runtime.time.realMonotonicTime
    competitor.deadlineAtMonotonic = runtime.time.realMonotonicTime
      + (runtime.lineup.current.settings.maxWallClockSecondsPerCompetitor or 180)
    competitor.spawnState = "spawning_independent_vehicle"
    runtime.lineup.current.schedulerState = "operation_active"
    runtime.lineup.current.schedulerLastProgressAt = runtime.time.realMonotonicTime
    competitor.randomizationState = "running"
    competitor.forceOfficialFallback = nil
    productionModules.raceManager.setPhase(
      runtime.lineup.current, competitor.index,
      runtime.state.phase == "selecting" and "selecting_vehicle" or "binding_vehicle",
      runtime.progress.phaseProgress
    )
  else
    runtime.settings = settingsModule.validate(previousSettings)
    productionModules.raceManager.record(
      runtime.lineup.current, competitor.index, runtime.lastResult, nil, competitor.targetGeneration
    )
    runtime.lineup.pendingNext = true
  end
  publishState()
  return started
end

production.auditRaceScheduler = function()
  local lineup = runtime.lineup.current
  if not lineup then return false end
  local persistence = lineup.persistence
  if persistence and persistence.status == "warning"
    and tonumber(persistence.nextRetryAt)
    and runtime.time.realMonotonicTime >= persistence.nextRetryAt
    and not runtime.state.busy
  then
    production.persistCurrentLineup()
  end
  local audit = productionModules.raceScheduler.audit(lineup, {
    busy = runtime.state.busy, activeOperation = runtime.active ~= nil,
    pendingNext = runtime.lineup.pendingNext,
  })
  lineup.schedulerState = audit.state
  if audit.terminal then
    runtime.lineup.pendingNext = false
    lineup.active = false
    lineup.generationState = "lineup_failed"
    lineup.processingState = "lineup_processing_finished"
    lineup.schedulerTerminalReason = audit.reason
    setResult(false, audit.reason, "Race generation stopped because scheduler progress could not be guaranteed", {
      scheduler = util.deepCopy(lineup.scheduler),
    })
    production.persistCurrentLineup()
    publishState()
    return false
  end
  if audit.schedule ~= true then return false end
  runtime.lineup.pendingNext = true
  lineup.schedulerLastProgressAt = runtime.time.realMonotonicTime
  if audit.healed then
    diagnosticsModule.write(runtime.diagnostics, "W", "lineup_scheduler_self_healed", {
      lineupId = lineup.id, slot = audit.slot,
      previousStatus = audit.previousStatus,
    }, true)
  end
  return true
end

function production.resolveLineupFailure(index, action)
  local lineup = runtime.lineup.current
  index = math.floor(tonumber(index) or -1)
  local ok, reason = productionModules.raceManager.resolveFailure(lineup, index, action)
  if not ok then
    setResult(false, reason, "Lineup failure action was rejected")
    publishState()
    return false
  end
  runtime.lineup.pendingNext = lineup.active == true
  if action == "stop" and lineup.settings and lineup.settings.retainAcceptedOnCancel == false then
    production.clearManagedRaceVehicles("race_stop_policy_cleanup")
  end
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
  local enumerationStarted = adapter.clock()
  local enumerated, all = productionModules.spawnAdapter.occupiedVehiclePositions()
  productionModules.performanceMetrics.record(runtime.performanceTelemetry, "vehicleEnumeration", math.max(0, (adapter.clock() - enumerationStarted) * 1000))
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
        status = "ready", phase = "ready", phaseProgress = 1,
        terminalState = "ready", raceStatus = "Pending", dnaId = dna.id,
        dna = util.deepCopy(dna), modelKey = dna.final and dna.final.modelKey,
      }
    else
      setResult(false, "spawn_selected_dna_missing", "The selected Vehicle DNA is unavailable"); publishState(); return false
    end
  elseif lineup then
    competitors = productionModules.raceManager.placementCompetitors(lineup, options)
  else
    setResult(false, "lineup_missing", "Create or import a lineup, or choose a Vehicle DNA"); publishState(); return false
  end
  if #competitors == 0 then
    setResult(false, "race_no_ready_cars", "No race cars are ready yet. Generate cars first.")
    publishState()
    return false
  end
  options.count = #competitors
  if options.spacingMode == "automatic" then
    options.vehicleDimensions = {}
    for index, competitor in ipairs(competitors) do
      local dimensionStarted = adapter.clock()
      local dimensions = type(competitor.currentVehicleId) == "number"
        and productionModules.spawnAdapter.vehicleDimensions(
          competitor.currentVehicleId, competitor.targetGeneration or 0
        ) or nil
      productionModules.performanceMetrics.record(runtime.performanceTelemetry, "vehicleDimensionRead", math.max(0, (adapter.clock() - dimensionStarted) * 1000))
      options.vehicleDimensions[index] = dimensions or {width = 2, length = 4.8, source = "safe_fallback"}
    end
  end
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
  local occupied = production.occupiedManagedPositions()
  local selectedIds = {}
  for _, competitor in ipairs(competitors) do
    if type(competitor.currentVehicleId) == "number" then
      selectedIds[tostring(competitor.currentVehicleId)] = true
    end
  end
  local externalOccupied = {}
  for _, item in ipairs(occupied or {}) do
    if not selectedIds[tostring(item.vehicleId)] then externalOccupied[#externalOccupied + 1] = item end
  end
  local planningStarted = adapter.clock()
  local plan, reason, planning = productionModules.spawnDirector.plan(
    frame, options, productionModules.spawnAdapter.raycastGround, externalOccupied
  )
  planning = util.deepCopy(planning or plan and plan.planning or {})
  planning.durationMs = math.max(0, (adapter.clock() - planningStarted) * 1000)
  productionModules.performanceMetrics.record(
    runtime.performanceTelemetry, "racePlacementPlanning", planning.durationMs
  )
  if not plan then
    setResult(false, reason, "Spawn preview is unsafe: " .. tostring(reason), {planning = planning})
    publishState()
    return false
  end
  plan.planning = planning
  plan.competitors = competitors
  runtime.spawnDirector.preview = plan
  local previewLineup = {competitors = competitors}
  local playerPlacement
  if lineup and type(lineup.playerVehicleId) == "number" then
    local positionOk, position = productionModules.spawnAdapter.objectPosition(lineup.playerVehicleId)
    local forwardOk, forward = productionModules.spawnAdapter.playerForward()
    local playerDimensions = productionModules.spawnAdapter.vehicleDimensions(lineup.playerVehicleId, 0)
    if type(playerDimensions) == "table" then playerDimensions.source = "actual_vehicle_bounds" end
    if positionOk then
      playerPlacement = {position = position, forward = forwardOk and forward or frame.forward,
        normal = {x = 0, y = 0, z = 1}, dimensions = playerDimensions}
    end
  end
  runtime.racePreview = productionModules.racePreview.build(
    "final_grid", plan, previewLineup, playerPlacement, true
  )
  if lineup then
    lineup.placementPreview = {
      status = "preview_ready", count = #plan.placements,
      requestedMode = plan.options.requestedMode, effectiveMode = plan.options.mode,
      fallbackReason = plan.options.fallbackReason,
      resolvedLateralSpacing = plan.options.resolvedLateralSpacing,
      resolvedLongitudinalSpacing = plan.options.resolvedLongitudinalSpacing,
      planning = util.deepCopy(plan.planning),
    }
  end
  setResult(true, "spawn_preview_ready", "Placement preview is ready; confirm to apply it", {
    count = #plan.placements, requestedMode = plan.options.requestedMode,
    mode = plan.options.mode, fallbackReason = plan.options.fallbackReason,
    resolvedLateralSpacing = plan.options.resolvedLateralSpacing,
    resolvedLongitudinalSpacing = plan.options.resolvedLongitudinalSpacing,
    planning = util.deepCopy(plan.planning),
  })
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
  -- Physical positioning always calculates a fresh plan. Renderer availability
  -- and a prior visual-preview click are deliberately outside this contract.
  if not production.previewLineupSpawn(options) then return false end
  local plan = runtime.spawnDirector.preview
  plan.active, plan.cursor, plan.nextAt = true, 1, adapter.clock()
  if runtime.lineup.current then runtime.lineup.current.placementState = "placing" end
  runtime.spawnDirector.run = plan
  runtime.spawnDirector.preview = nil
  runtime.racePreview = nil
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
  if pending.placementOnly then
    local readable, positionOrReason = productionModules.spawnAdapter.objectPosition(pending.vehicleId)
    if not readable then
      return positionOrReason == "vehicle_missing" and false or nil, positionOrReason
    end
    local expected = pending.placement and pending.placement.position or {}
    local dx = (tonumber(positionOrReason.x) or 0) - (tonumber(expected.x) or 0)
    local dy = (tonumber(positionOrReason.y) or 0) - (tonumber(expected.y) or 0)
    local dz = (tonumber(positionOrReason.z) or 0) - (tonumber(expected.z) or 0)
    if dx * dx + dy * dy + dz * dz > 2.25 then return nil, "placement_readback_pending" end
    return true, {vehicleId = pending.vehicleId, position = util.deepCopy(positionOrReason), placementOnly = true}
  end
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
        local rebound, rebindReason
        if pending.replacement then
          rebound, rebindReason = productionModules.managedRegistry.rebindReplacementCandidate(
            runtime.managedVehicles, pending.handle, pending.vehicleId, vehicleId,
            pending.targetGeneration
          )
        else
          rebound, rebindReason = productionModules.managedRegistry.rebind(
            runtime.managedVehicles, pending.handle, pending.vehicleId, vehicleId,
            pending.targetGeneration
          )
        end
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

function production.cleanupSpawnTransaction(transaction)
  if type(transaction) ~= "table" then return {removed = {}, failed = {}} end
  local result = {removed = {}, failed = {}}
  for _, vehicleId in ipairs(productionModules.spawnAdapter.spawnOutcome.cleanupIds(transaction)) do
    local deleted, reason = productionModules.spawnAdapter.deleteVehicle(vehicleId)
    if deleted or reason == "vehicle_missing" then
      result.removed[#result.removed + 1] = vehicleId
    else
      result.failed[#result.failed + 1] = {vehicleId = vehicleId, reason = reason}
    end
  end
  transaction.cleanup = util.deepCopy(result)
  return result
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
      if pending.replacement then
        local entry = runtime.managedVehicles.entries[pending.handle]
        local transaction = entry and entry.pendingReplacement
        local replacementValid = transaction
          and transaction.targetGeneration == pending.targetGeneration
          and transaction.sourceVehicleId == pending.replacement.sourceVehicleId
          and transaction.candidateVehicleId == pending.vehicleId
          and entry.vehicleId == transaction.sourceVehicleId
        if not replacementValid then
          production.cleanupSpawnTransaction(pending.spawnTransaction)
          productionModules.managedRegistry.abortReplacement(
            runtime.managedVehicles, pending.handle, pending.targetGeneration,
            "managed_replacement_transaction_mismatch"
          )
          run.failures[#run.failures + 1] = {
            index = pending.competitor.index, reason = "managed_replacement_transaction_mismatch",
          }
          pending.competitor.raceStatus = "Ready"
          pending.competitor.replacementState = "failed_source_retained"
          run.pendingVerification = nil
          run.cursor = run.cursor + 1
          run.nextAt = adapter.clock() + run.options.interval
          publishState()
          return true
        end
        local sourceOwner = productionModules.domainOperations.ownership(
          runtime.domainOperations, transaction.sourceVehicleId
        )
        local deleted, deleteReason = productionModules.spawnAdapter.deleteVehicle(
          transaction.sourceVehicleId
        )
        if not deleted and deleteReason ~= "vehicle_missing" then
          production.cleanupSpawnTransaction(pending.spawnTransaction)
          productionModules.managedRegistry.abortReplacement(
            runtime.managedVehicles, pending.handle, pending.targetGeneration, deleteReason
          )
          run.failures[#run.failures + 1] = {
            index = pending.competitor.index, reason = "managed_replacement_source_remove_failed",
            detail = deleteReason,
          }
          pending.competitor.raceStatus = "Ready"
          pending.competitor.replacementState = "failed_source_retained"
          run.pendingVerification = nil
          run.cursor = run.cursor + 1
          run.nextAt = adapter.clock() + run.options.interval
          publishState()
          return true
        end
        local committed, commitReason = productionModules.managedRegistry.commitReplacement(
          runtime.managedVehicles, pending.handle, pending.targetGeneration
        )
        if not committed then
          production.cleanupSpawnTransaction(pending.spawnTransaction)
          run.failures[#run.failures + 1] = {
            index = pending.competitor.index, reason = commitReason,
          }
          pending.competitor.raceStatus = "DNS"
          pending.competitor.replacementState = "failed_after_source_removed"
          run.pendingVerification = nil
          run.cursor = run.cursor + 1
          run.nextAt = adapter.clock() + run.options.interval
          publishState()
          return true
        end
        productionModules.domainOperations.recordRemoval(
          runtime.domainOperations, transaction.sourceVehicleId,
          "managed_replacement_source_removed"
        )
        if sourceOwner then
          productionModules.domainOperations.ownVehicle(runtime.domainOperations, pending.vehicleId, {
            domain = sourceOwner.domain, operationId = sourceOwner.operationId,
            generation = sourceOwner.generation, role = sourceOwner.role,
            slot = sourceOwner.slot, managed = true, created = true, accepted = true,
            terminal = true, identity = sourceOwner.identity,
          })
        end
        pending.competitor.replacementState = "candidate_committed"
        pending.competitor.replacedVehicleId = transaction.sourceVehicleId
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
        if pending.spawnTransaction then
          productionModules.spawnAdapter.spawnOutcome.accept(pending.spawnTransaction, pending.vehicleId)
          production.cleanupSpawnTransaction(pending.spawnTransaction)
          pending.competitor.spawnTransaction = util.deepCopy(pending.spawnTransaction)
        end
        run.spawned[#run.spawned + 1] = pending.handle
        pending.competitor.raceStatus = "Ready"
        pending.competitor.managedHandle = pending.handle
        pending.competitor.currentVehicleId = pending.vehicleId
        pending.competitor.concreteVehicleId = pending.vehicleId
        pending.competitor.placementState = pending.placementOnly and "placed" or "spawned"
        pending.competitor.placementReady = true
        if pending.replacement then pending.competitor.replacementState = "completed" end
        local entry = runtime.managedVehicles.entries[pending.handle]
        if entry and pending.placement then entry.spawnTransform = util.deepCopy(pending.placement) end
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
      if pending.spawnTransaction and not pending.placementOnly then
        production.cleanupSpawnTransaction(pending.spawnTransaction)
        pending.competitor.spawnTransaction = util.deepCopy(pending.spawnTransaction)
      end
      local entry = runtime.managedVehicles.entries[pending.handle]
      if pending.replacement then
        productionModules.managedRegistry.abortReplacement(
          runtime.managedVehicles, pending.handle, pending.targetGeneration,
          verified == false and stateOrReason or "spawn_readback_timeout"
        )
      elseif entry then
        entry.status = pending.placementOnly and "ready" or "failed"
        entry.targetConfirmed = pending.placementOnly == true
        entry.validated = pending.placementOnly == true
        entry.pendingWrites, entry.pendingTimers, entry.pendingCallbacks = 0, 0, 0
        entry.failureReason = stateOrReason
      end
      run.failures[#run.failures + 1] = {
        index = pending.competitor.index,
        reason = verified == false and stateOrReason or "spawn_readback_timeout",
      }
      pending.competitor.raceStatus = (pending.placementOnly or pending.replacement) and "Ready" or "DNS"
      pending.competitor.placementState = pending.placementOnly and "placement_failed"
        or pending.replacement and "staged" or "spawn_failed"
      pending.competitor.placementReady = pending.replacement == true
      if pending.replacement then pending.competitor.replacementState = "failed_source_retained" end
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
    if runtime.lineup.current then
      runtime.lineup.current.placementState = #run.failures == 0 and "ready" or "partial"
      runtime.lineup.current.placementPreview = nil
    end
    production.persistCurrentLineup()
    publishState()
    return false
  end
  local config = production.configForCompetitor(competitor)
  local modelKey = competitor.modelKey or competitor.dna and competitor.dna.final and competitor.dna.final.modelKey
  if competitor.managedHandle then
    local entry, readyReason = productionModules.managedRegistry.readyEntry(
      runtime.managedVehicles, competitor.managedHandle
    )
    if not entry then
      run.failures[#run.failures + 1] = {index = competitor.index, reason = readyReason}
      competitor.placementState = "managed_vehicle_unavailable"
      competitor.placementReady = false
    elseif tonumber(entry.vehicleId) == tonumber(runtime.lineup.current and runtime.lineup.current.playerVehicleId) then
      run.failures[#run.failures + 1] = {index = competitor.index, reason = "race_placement_player_protected"}
      competitor.placementState = "placement_authority_denied"
      competitor.placementReady = false
    else
      local bindingOk, bindingReason = productionModules.managedRegistry.matchesSlot(
        runtime.managedVehicles, entry.handle, {
          lineupId = runtime.lineup.current and runtime.lineup.current.id,
          competitorId = competitor.id,
          slotId = competitor.slotId or tostring(competitor.index),
          vehicleId = competitor.currentVehicleId,
        }
      )
      local authorized, authorityReason = false, bindingReason
      if bindingOk then
        authorized, authorityReason = productionModules.domainOperations.authorizeManagedCleanup(
          runtime.domainOperations, entry.vehicleId, {
            operationId = competitor.operationId, generation = competitor.generation,
            slot = competitor.index,
          }
        )
      end
      if not bindingOk or not authorized then
        run.failures[#run.failures + 1] = {
          index = competitor.index, reason = authorityReason or "race_placement_authority_denied",
        }
        competitor.placementState = "placement_authority_denied"
        competitor.placementReady = false
        run.cursor = run.cursor + 1
        run.nextAt = adapter.clock() + run.options.interval
        publishState()
        return true
      end
      local generation = productionModules.managedRegistry.beginGeneration(
        runtime.managedVehicles, entry.handle, "placement"
      )
      productionModules.managedRegistry.setPending(runtime.managedVehicles, entry.handle, {
        writes = 1, timers = 1, callbacks = 0,
      })
      local placed, placementReason = productionModules.spawnAdapter.placeVehicle(entry.vehicleId, placement)
      if placed then
        productionModules.managedRegistry.setPending(runtime.managedVehicles, entry.handle, {
          writes = 0, timers = 1, callbacks = 0,
        })
        run.pendingVerification = {
          handle = entry.handle, targetGeneration = generation,
          vehicleId = entry.vehicleId, modelKey = entry.modelKey,
          config = util.deepCopy(entry.metadata and entry.metadata.config or config),
          competitor = competitor, placement = util.deepCopy(placement), placementOnly = true,
          startedAt = adapter.clock(), deadline = adapter.clock() + WAIT_TIMEOUT,
          candidateIds = {}, candidateSeen = {}, stableScans = 0,
        }
        run.nextAt = adapter.clock() + 0.1
        competitor.raceStatus = "Loading"
        competitor.placementState = "placing"
        publishState()
        return true
      end
      entry.status = "ready"
      entry.targetConfirmed, entry.validated = true, true
      productionModules.managedRegistry.setPending(runtime.managedVehicles, entry.handle, {
        writes = 0, timers = 0, callbacks = 0,
      })
      run.failures[#run.failures + 1] = {index = competitor.index, reason = placementReason}
      competitor.placementState = "placement_failed"
      competitor.placementReady = false
    end
    run.cursor = run.cursor + 1
    run.nextAt = adapter.clock() + run.options.interval
    publishState()
    return true
  end
  local ok, vehicleId, spawnTransaction
  if config and modelKey then
    ok, vehicleId, spawnTransaction = productionModules.spawnAdapter.spawnVehicle(modelKey, config, placement)
  else ok, vehicleId = false, "spawn_config_unavailable" end
  if ok then
    local entry, reason = productionModules.managedRegistry.register(runtime.managedVehicles, vehicleId, {
      competitorId = competitor.id,
      lineupId = runtime.lineup.current and runtime.lineup.current.id,
      name = competitor.name,
      lineupCompetitorId = competitor.id,
      slotId = competitor.slotId or tostring(competitor.index),
      generationId = runtime.lineup.current and runtime.lineup.current.id,
      episodeSeed = runtime.lineup.current and runtime.lineup.current.episodeSeed,
      slotSeed = competitor.seed,
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
        spawnTransaction = spawnTransaction,
      }
      run.nextAt = adapter.clock() + 0.1
      competitor.raceStatus, competitor.managedHandle = "Pending", entry.handle
      publishState()
      return true
    else
      production.cleanupSpawnTransaction(spawnTransaction)
      run.failures[#run.failures + 1] = {index = competitor.index, reason = reason}
    end
  else
    production.cleanupSpawnTransaction(spawnTransaction)
    run.failures[#run.failures + 1] = {index = competitor.index, reason = vehicleId}
    competitor.raceStatus = "DNS"
    competitor.spawnTransaction = util.deepCopy(spawnTransaction)
  end
  run.cursor = run.cursor + 1
  run.nextAt = adapter.clock() + run.options.interval
  publishState()
  return true
end

function production.cancelLineupSpawn()
  runtime.spawnDirector.preview = nil
  runtime.racePreview = nil
  local run = runtime.spawnDirector.run
  if run then
    run.active = false
    if run.pendingVerification then
      if run.pendingVerification.spawnTransaction then
        production.cleanupSpawnTransaction(run.pendingVerification.spawnTransaction)
        if run.pendingVerification.competitor then
          run.pendingVerification.competitor.spawnTransaction = util.deepCopy(run.pendingVerification.spawnTransaction)
        end
      end
      local entry = runtime.managedVehicles.entries[run.pendingVerification.handle]
      if run.pendingVerification.replacement then
        productionModules.managedRegistry.abortReplacement(
          runtime.managedVehicles, run.pendingVerification.handle,
          run.pendingVerification.targetGeneration, "managed_replacement_cancelled"
        )
        if run.pendingVerification.competitor then
          run.pendingVerification.competitor.raceStatus = "Ready"
          run.pendingVerification.competitor.replacementState = "cancelled_source_retained"
        end
      elseif entry and entry.status == "loading" then
        entry.status = "failed"
        entry.failureReason = "spawn_verification_cancelled"
        productionModules.managedRegistry.setPending(runtime.managedVehicles, entry.handle, {
          writes = 0, timers = 0, callbacks = 0,
        })
      end
      if run.pendingVerification.competitor and not run.pendingVerification.replacement then
        run.pendingVerification.competitor.raceStatus = "DNS"
      end
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
  if not entry then
    local lineup = runtime.lineup.current
    for _, competitor in ipairs(lineup and lineup.competitors or {}) do
      local tombstone = competitor.removalTombstone
      if productionModules.raceManager.knownRemoved(competitor)
        and tombstone and tombstone.managedHandle == handle
      then
        setResult(true, "managed_vehicle_already_removed", "Managed vehicle was already removed", {
          handle = handle, slotId = competitor.slotId or tostring(competitor.index),
        })
        publishState()
        return true
      end
    end
    setResult(false, "managed_vehicle_unknown", "Managed vehicle is unavailable"); publishState(); return false
  end
  local lineup = runtime.lineup.current
  local competitor
  for _, candidate in ipairs(lineup and lineup.competitors or {}) do
    if candidate.managedHandle == handle then competitor = candidate; break end
  end
  local matches, bindingReason = false, "managed_slot_binding_unproven"
  if competitor then
    matches, bindingReason = productionModules.managedRegistry.matchesSlot(
      runtime.managedVehicles, handle, {
        lineupId = lineup.id, competitorId = competitor.id,
        slotId = competitor.slotId or tostring(competitor.index),
        vehicleId = competitor.currentVehicleId,
      }
    )
  end
  if not matches then
    setResult(false, bindingReason, "Managed removal requires a proven Race slot binding"); publishState(); return false
  end
  if tonumber(entry.vehicleId) == tonumber(lineup.playerVehicleId) then
    setResult(false, "race_cleanup_player_protected", "The player vehicle cannot be removed by Race cleanup"); publishState(); return false
  end
  local authorized, authorizationReason = productionModules.domainOperations.authorizeManagedCleanup(
    runtime.domainOperations, entry.vehicleId, {
      operationId = competitor.operationId, generation = competitor.generation,
      slot = competitor.index,
    }
  )
  if not authorized then
    setResult(false, authorizationReason, "Managed removal lacks local cleanup authority"); publishState(); return false
  end
  productionModules.aiAdapter.stop(entry.vehicleId, true)
  local deleted, reason = productionModules.spawnAdapter.deleteVehicle(entry.vehicleId)
  if not deleted and reason ~= "vehicle_missing" then
    setResult(false, reason, "Managed vehicle could not be removed"); publishState(); return false
  end
  productionModules.domainOperations.recordRemoval(
    runtime.domainOperations, entry.vehicleId, "managed_vehicle_removed_by_user"
  )
  productionModules.managedRegistry.remove(runtime.managedVehicles, handle)
  productionModules.raceManager.markRemoved(competitor, {
    lineupId = lineup.id, managedHandle = handle, vehicleId = entry.vehicleId,
    operationId = competitor.operationId, generation = competitor.generation,
    reason = "managed_vehicle_removed_by_user",
  })
  setResult(true, "managed_vehicle_removed", "Managed vehicle removed", {handle = handle})
  publishState()
  return true
end

function production.respawnManagedVehicle(handle)
  if runtime.state.busy then
    setResult(false, "operation_busy", "Managed vehicles cannot respawn during a vehicle mutation operation"); publishState(); return false
  end
  if runtime.spawnDirector.run and runtime.spawnDirector.run.active then
    setResult(false, "spawn_director_busy", "Finish or cancel the active placement/replacement first"); publishState(); return false
  end
  local entry, readyReason = productionModules.managedRegistry.readyEntry(
    runtime.managedVehicles, handle
  )
  if not entry then
    setResult(false, readyReason, "Managed vehicle is not ready for replacement"); publishState(); return false
  end
  local lineup = runtime.lineup.current
  local competitor
  for _, candidate in ipairs(lineup and lineup.competitors or {}) do
    if candidate.managedHandle == handle then competitor = candidate; break end
  end
  local bindingOk, bindingReason = false, "managed_slot_binding_unproven"
  if competitor then
    bindingOk, bindingReason = productionModules.managedRegistry.matchesSlot(
      runtime.managedVehicles, handle, {
        lineupId = lineup.id, competitorId = competitor.id,
        slotId = competitor.slotId or tostring(competitor.index),
        vehicleId = competitor.currentVehicleId,
      }
    )
  end
  if not bindingOk then
    setResult(false, bindingReason, "Managed replacement requires a proven Race slot binding"); publishState(); return false
  end
  local authorized, authorizationReason = productionModules.domainOperations.authorizeManagedCleanup(
    runtime.domainOperations, entry.vehicleId, {
      operationId = competitor.operationId, generation = competitor.generation,
      slot = competitor.index,
    }
  )
  if not authorized then
    setResult(false, authorizationReason, "Managed replacement lacks local cleanup authority"); publishState(); return false
  end
  local modelKey = entry.modelKey or entry.metadata and entry.metadata.modelKey
  local config = entry.metadata and entry.metadata.config
  local placement = entry.spawnTransform or entry.metadata and entry.metadata.spawnTransform
  if not modelKey or type(config) ~= "table" or type(placement) ~= "table" then
    setResult(false, "managed_respawn_state_missing", "Managed vehicle has no verified spawn state"); publishState(); return false
  end
  local oldId = entry.vehicleId
  local spawned, newId, spawnTransaction = productionModules.spawnAdapter.spawnVehicle(modelKey, config, placement)
  if not spawned then
    production.cleanupSpawnTransaction(spawnTransaction)
    setResult(false, newId, "Managed vehicle respawn failed"); publishState(); return false
  end
  if newId == oldId then
    setResult(false, "managed_replacement_reused_source_id",
      "Managed replacement returned the still-owned source identity; the source was preserved")
    publishState()
    return false
  end
  local generation = productionModules.managedRegistry.beginGeneration(
    runtime.managedVehicles, handle, "atomic_replacement"
  )
  local began, reason = productionModules.managedRegistry.beginReplacement(
    runtime.managedVehicles, handle, oldId, newId, generation
  )
  if not began then
    production.cleanupSpawnTransaction(spawnTransaction)
    productionModules.managedRegistry.abortReplacement(
      runtime.managedVehicles, handle, generation, reason
    )
    setResult(false, reason, "Managed vehicle replacement transaction was rejected"); publishState(); return false
  end
  productionModules.managedRegistry.setPending(runtime.managedVehicles, handle, {timers = 1, callbacks = 1})
  competitor.replacementState = "candidate_verifying"
  competitor.replacementCandidateVehicleId = newId
  runtime.spawnDirector.run = {
    active = true, options = {interval = 0.75}, placements = {}, competitors = {}, cursor = 1,
    nextAt = adapter.clock() + 0.1, spawned = {}, failures = {},
    pendingVerification = {
      handle = handle, targetGeneration = entry.targetGeneration,
      vehicleId = newId, modelKey = modelKey, config = util.deepCopy(config),
      competitor = competitor, startedAt = adapter.clock(), deadline = adapter.clock() + WAIT_TIMEOUT,
      candidateIds = {}, candidateSeen = {}, stableScans = 0,
      spawnTransaction = spawnTransaction,
      replacement = {sourceVehicleId = oldId, candidateVehicleId = newId},
    },
  }
  setResult(true, "managed_vehicle_replacement_started",
    "Managed replacement candidate is awaiting read-back; the source remains available", {
      handle = handle, sourceVehicleId = oldId, candidateVehicleId = newId,
      slotId = competitor.slotId, generation = generation,
    })
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
  options.speed = tonumber(options.speed) or (tonumber(options.speedKph)
    and tonumber(options.speedKph) / 3.6) or nil
  local lineup = runtime.lineup.current
  if lineup and (lineup.active == true or (lineup.generationState ~= "lineup_ready"
    and not (lineup.generationState == "lineup_partial" and lineup.acceptPartial == true)))
  then
    setResult(false, "race_formation_not_ready",
      "Race AI cannot start until generation and Placement are ready or an accepted partial formation is ready.")
    publishState()
    return false
  end
  if #(runtime.managedVehicles.order or {}) == 0 then
    setResult(false, "race_no_managed_vehicles", "No managed race cars are available. Place cars first.")
    publishState()
    return false
  end
  local mode = options.mode or "Destination"
  local capabilities = productionModules.aiAdapter.capabilities()
  if capabilities[mode] ~= true then
    local reason = (mode == "Destination" or mode == "Route") and capabilities.navgraphReason
      or (mode == "Recorded" and capabilities.recordedReason) or capabilities.scriptedReason
    setResult(false, "ai_mode_unavailable", reason or "AI mode unavailable in this build")
    publishState()
    return false
  end
  local selected
  if type(options.handles) == "table" and #options.handles > 0 then
    selected = options.handles
  elseif lineup then
    local ordered = {}
    for _, competitor in ipairs(lineup.competitors or {}) do
      if competitor.managedHandle then ordered[#ordered + 1] = competitor end
    end
    table.sort(ordered, function(left, right)
      local leftPosition = tonumber(left.position) or tonumber(left.index) or 0
      local rightPosition = tonumber(right.position) or tonumber(right.index) or 0
      return leftPosition == rightPosition and tostring(left.id) < tostring(right.id)
        or leftPosition < rightPosition
    end)
    selected = {}
    for _, competitor in ipairs(ordered) do selected[#selected + 1] = competitor.managedHandle end
  else selected = runtime.managedVehicles.order end
  local started, failures = 0, {}
  for order, handle in ipairs(selected) do
    local managed, managedReason = productionModules.managedRegistry.readyEntry(runtime.managedVehicles, handle)
    local lineupCompetitor
    for _, competitor in ipairs(lineup and lineup.competitors or {}) do
      if competitor.managedHandle == handle then lineupCompetitor = competitor; break end
    end
    if managed and lineupCompetitor and lineupCompetitor.drivable == false then
      managed, managedReason = nil, "vehicle_not_drivable"
    end
    if managed then
      local currentOptions = util.deepCopy(options)
      local currentMode = mode
      if options.preset == "Swarm" then
        local swarmModes = {"Follow", "Chase", "Flee", "Roam", "Traffic"}
        currentMode = swarmModes[(order - 1) % #swarmModes + 1]
      end
      currentOptions.targetGeneration = managed.targetGeneration
      currentOptions.delay = (tonumber(options.delay) or 0) + (order - 1) * (tonumber(options.stagger) or 0)
      if currentMode == "Destination" then
        local okPos, origin = productionModules.spawnAdapter.objectPosition(managed.vehicleId)
        if okPos and runtime.destination.active and runtime.destination.confirmed then
          local route, reason = productionModules.routePlanner.destinationRoute(productionModules.aiAdapter, origin, runtime.destination.point, coverageLimits.DEFAULTS.maxAIRouteNodes)
          if route then currentOptions.nodes, currentOptions.destination, currentOptions.nodesArePath = route.nodes, util.deepCopy(runtime.destination.point), true
          else failures[#failures + 1] = {handle = handle, reason = reason} end
        else failures[#failures + 1] = {handle = handle, reason = "ai_destination_missing"} end
      elseif currentMode == "Route" then
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
      elseif currentMode == "Chase" or currentMode == "Follow" or currentMode == "Flee" then
        local targetId = math.floor(tonumber(options.targetVehicleId) or -1)
        if options.preset == "Convoy" then
          local previousHandle = selected[order - 1]
          local previousManaged = previousHandle and runtime.managedVehicles.entries[previousHandle]
          targetId = previousManaged and previousManaged.vehicleId
            or math.floor(tonumber(options.targetVehicleId) or -1)
        end
        local targetOk, targetReason = productionModules.aiAdapter.targetExists(targetId)
        if not targetOk or targetId == managed.vehicleId then
          failures[#failures + 1] = {handle = handle, reason = targetReason or "ai_target_invalid"}
          currentOptions.targetVehicleId = nil
        else currentOptions.targetVehicleId = targetId end
      end
      local routeReady = (currentMode ~= "Destination" and currentMode ~= "Route") or currentOptions.nodes
      local targetReady = (currentMode ~= "Chase" and currentMode ~= "Follow" and currentMode ~= "Flee")
        or currentOptions.targetVehicleId
      if routeReady and targetReady then
        local entry, reason = productionModules.aiDirector.assign(runtime.aiDirector, handle,
          managed.vehicleId, currentMode, currentOptions, adapter.clock())
        if entry then
          productionModules.managedRegistry.setAIState(runtime.managedVehicles, handle,
            managed.targetGeneration, {status = "scheduled", mode = currentMode})
          if lineup then
            for _, competitor in ipairs(lineup.competitors or {}) do
              if competitor.managedHandle == handle then
                competitor.aiState = "SCHEDULED"
                competitor.aiReady = false
                competitor.aiCommandDispatched = false
                competitor.aiDispatch = {
                  vehicleId = managed.vehicleId,
                  slotId = competitor.slotId or tostring(competitor.index),
                  behaviorRequested = currentMode,
                  targetVehicleId = currentOptions.targetVehicleId,
                  aiCommand = currentMode,
                  dispatchResult = "SCHEDULED",
                  readbackState = "PENDING",
                }
                break
              end
            end
          end
          runtime.aiDirector.polling = runtime.aiDirector.polling or productionModules.adaptivePolling.create({
            fastInterval = 0.1, slowInterval = 1.0, stableThreshold = 3,
          }, adapter.clock())
          productionModules.adaptivePolling.wake(runtime.aiDirector.polling, adapter.clock())
          started = started + 1
        else failures[#failures + 1] = {handle = handle, reason = reason} end
      end
    else failures[#failures + 1] = {handle = handle, reason = managedReason} end
  end
  if lineup then
    for _, failure in ipairs(failures) do
      for _, competitor in ipairs(lineup.competitors or {}) do
        if competitor.managedHandle == failure.handle then
          competitor.aiState = "REJECTED"
          competitor.aiReady = false
          competitor.aiCommandDispatched = false
          competitor.aiDispatch = util.shallowMerge(competitor.aiDispatch or {}, {
            vehicleId = competitor.currentVehicleId,
            slotId = competitor.slotId or tostring(competitor.index),
            behaviorRequested = mode,
            dispatchResult = "REJECTED",
            readbackState = "NOT_STARTED",
            failureReason = failure.reason,
          })
          break
        end
      end
    end
  end
  setResult(started > 0, started > 0 and "ai_director_scheduled" or "ai_director_failed",
    started > 0 and "AI Director scheduled managed vehicles"
      or "Managed race cars could not start. Check Drive details and NavGraph availability.",
    {started = started, failures = failures})
  publishState()
  return started > 0
end

function production.startAIQuickPreset(name)
  local presets = {
    Follow = {mode = "Follow", speed = 14, aggression = 0.45, avoidCars = true},
    Convoy = {mode = "Follow", preset = "Convoy", speed = 13, aggression = 0.4,
      avoidCars = true, stagger = 0.25},
    Chase = {mode = "Chase", speed = 22, aggression = 0.75, avoidCars = true},
    Flee = {mode = "Flee", speed = 22, aggression = 0.65, avoidCars = true},
    Traffic = {mode = "Traffic", speed = 15, aggression = 0.45, avoidCars = true},
    Roam = {mode = "Roam", speed = 16, aggression = 0.5, avoidCars = true},
    Swarm = {mode = "Chase", preset = "Swarm", speed = 18, aggression = 0.55,
      avoidCars = true, stagger = 0.15},
  }
  local options = presets[name]
  if not options then
    setResult(false, "ai_quick_preset_invalid", "The selected AI preset is unavailable")
    publishState()
    return false
  end
  if options.mode == "Follow" or options.mode == "Chase" or options.mode == "Flee" then
    local playerOk, playerVehicleId = adapter.getCurrentVehicleId()
    if not playerOk or type(playerVehicleId) ~= "number" then
      setResult(false, "ai_quick_preset_target_missing",
        "This AI preset needs an active local player vehicle")
      publishState()
      return false
    end
    options.targetVehicleId = playerVehicleId
  end
  return production.startManagedAI(options)
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
  if runtime.aiDirector.polling then
    if action == "stop" or action == "reset" then productionModules.adaptivePolling.stop(runtime.aiDirector.polling)
    else productionModules.adaptivePolling.wake(runtime.aiDirector.polling, adapter.clock()) end
  end
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
  runtime.aiDirector.polling = runtime.aiDirector.polling or productionModules.adaptivePolling.create({
    fastInterval = 0.1, slowInterval = 1.0, stableThreshold = 3,
  }, now)
  if not productionModules.adaptivePolling.due(runtime.aiDirector.polling, now) then return false end
  local handles, seen, hasActive = {}, {}, false
  for _, handle in ipairs(runtime.aiDirector.order) do
    local entry = runtime.aiDirector.entries[handle]
    if entry and (entry.status == "scheduled" or entry.status == "confirming") then
      hasActive = true
      if entry.status == "confirming" or now >= entry.startAt then
        handles[#handles + 1], seen[handle] = handle, true
      end
    elseif entry and entry.status == "running" then hasActive = true end
  end
  local total = #(runtime.aiDirector.order or {})
  local batch = total > 0 and math.max(1, math.ceil(total / 4)) or 0
  runtime.aiDirector.pollCursor = tonumber(runtime.aiDirector.pollCursor) or 0
  for _ = 1, batch do
    runtime.aiDirector.pollCursor = runtime.aiDirector.pollCursor % math.max(1, total) + 1
    local handle = runtime.aiDirector.order[runtime.aiDirector.pollCursor]
    local entry = handle and runtime.aiDirector.entries[handle]
    if entry and entry.status == "running" and not seen[handle] then
      handles[#handles + 1], seen[handle] = handle, true
    end
  end
  local changed = false
  for _, handle in ipairs(handles) do
    local entry = runtime.aiDirector.entries[handle]
    local statusBefore = entry and entry.status
    if entry and entry.status == "scheduled" and now >= entry.startAt then
      local managed, managedReason = productionModules.managedRegistry.readyEntry(
        runtime.managedVehicles, handle, entry.targetGeneration
      )
      local ok, reason = false, managedReason
      if managed then ok, reason = productionModules.aiAdapter.start(entry.vehicleId, entry.mode, entry.options) end
      entry.lastAttemptAt = now
      entry.dispatchResult = ok and "QUEUED" or "REJECTED"
      entry.dispatchFailureReason = ok and nil or reason
      if ok then
        entry.startedAt, entry.lastProgressAt = now, now
        local readOk, observedMode, method = productionModules.aiAdapter.readMode(entry.vehicleId)
        if readOk then
          entry.modeConfirmation = productionModules.aiModeConfirmation.create(
            entry.vehicleId, entry.targetGeneration, entry.mode, now, 2
          )
          entry.modeConfirmation.method = method
          local confirmation = productionModules.aiModeConfirmation.observe(
            entry.modeConfirmation, observedMode, now, entry.targetGeneration
          )
          productionModules.aiDirector.setStatus(runtime.aiDirector, handle,
            confirmation == "confirmed" and "running" or "confirming",
            confirmation == "confirmed" and "mode_confirmed" or "mode_confirmation_pending")
        else
          productionModules.aiDirector.setStatus(runtime.aiDirector, handle, "running", "mode_confirmation_unavailable")
          productionModules.aiDirector.log(runtime.aiDirector, "mode_confirmation_unavailable", {
            handle = handle, vehicleId = entry.vehicleId, mode = entry.mode,
          })
        end
      else
        productionModules.aiDirector.setStatus(runtime.aiDirector, handle, "failed", reason)
      end
    elseif entry and entry.status == "confirming" then
      local managed = productionModules.managedRegistry.readyEntry(
        runtime.managedVehicles, handle, entry.targetGeneration
      )
      if not managed then
        if entry.modeConfirmation then productionModules.aiModeConfirmation.destroyed(entry.modeConfirmation) end
        productionModules.aiDirector.setStatus(runtime.aiDirector, handle, "failed", "vehicle_destroyed")
      else
        local readOk, observedMode = productionModules.aiAdapter.readMode(entry.vehicleId)
        local confirmation
        if readOk then
          confirmation = productionModules.aiModeConfirmation.observe(
            entry.modeConfirmation, observedMode, now, entry.targetGeneration
          )
        else
          confirmation = productionModules.aiModeConfirmation.unavailable(entry.modeConfirmation)
        end
        if confirmation == "confirmed" then
          productionModules.aiDirector.setStatus(runtime.aiDirector, handle, "running", "mode_confirmed")
        elseif confirmation == "unavailable" then
          productionModules.aiDirector.setStatus(runtime.aiDirector, handle, "running", "mode_confirmation_unavailable")
        elseif confirmation == "mismatch" or confirmation == "timeout" or confirmation == "stale" then
          productionModules.aiAdapter.stop(entry.vehicleId, false)
          productionModules.aiDirector.setStatus(runtime.aiDirector, handle, "failed", "ai_mode_" .. confirmation)
        end
      end
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
        modeConfirmation = entry.modeConfirmation and entry.modeConfirmation.status or nil,
      })
      if runtime.lineup.current then
        for _, competitor in ipairs(runtime.lineup.current.competitors or {}) do
          if competitor.managedHandle == handle then
            competitor.aiState = string.upper(tostring(entry.status or "UNKNOWN"))
            competitor.aiCommandDispatched = entry.dispatchResult == "QUEUED"
            local modeConfirmed = entry.reason == "mode_confirmed"
              or entry.modeConfirmation and entry.modeConfirmation.status == "confirmed"
            local motionObserved = tonumber(entry.speed) and tonumber(entry.speed) >= 0.5
            competitor.aiReady = modeConfirmed == true or motionObserved == true
            if motionObserved then
              competitor.drivable = true
              competitor.drivabilityState = "MOTION_OBSERVED"
            end
            competitor.aiDispatch = util.shallowMerge(competitor.aiDispatch or {}, {
              vehicleId = entry.vehicleId,
              slotId = competitor.slotId or tostring(competitor.index),
              behaviorRequested = entry.mode,
              targetVehicleId = entry.options and entry.options.targetVehicleId,
              aiCommand = entry.mode,
              dispatchResult = entry.dispatchResult or "PENDING",
              readbackState = modeConfirmed and "CONFIRMED"
                or motionObserved and "MOTION_CONFIRMED"
                or entry.reason == "mode_confirmation_unavailable" and "UNAVAILABLE"
                or string.upper(tostring(entry.status or "UNKNOWN")),
              failureReason = entry.dispatchFailureReason
                or entry.status == "failed" and entry.reason or nil,
            })
            break
          end
        end
      end
    end
    if entry and entry.status ~= statusBefore then changed = true end
  end
  if hasActive then productionModules.adaptivePolling.observed(runtime.aiDirector.polling, now, changed)
  else productionModules.adaptivePolling.stop(runtime.aiDirector.polling) end
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
  local okObserved, observed = adapter.getVerificationState(
    active.vehicleId, active.backgroundTarget == true
  )
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
  if paintVerification.shouldCheck(confirmation, now) then
    paintVerification.recordAttempt(confirmation, now)
    local verified, reason = adapter.verifyPaints(
      confirmation.expected, active.vehicleId, active.backgroundTarget == true
    )
    diagnosticsModule.write(runtime.diagnostics, verified and "D" or "W", "paint_confirmation_attempt", {
      strategy = confirmation.strategy,
      attempt = confirmation.attempts,
      verified = verified,
      reason = reason,
      elapsed = now - confirmation.startedAt,
    })
    if verified then
      active.paintConfirmation = nil
      active.readBackStatus = "ready"
      active.lastAcceptedCheckpoint = "paint_readback_confirmed"
      local okPaints, paints = adapter.getPaints(active.vehicleId, active.backgroundTarget == true)
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

function production.focusManagedVehicle(handle)
  local entry = runtime.managedVehicles.entries[handle]
  if not entry then
    setResult(false, "managed_vehicle_unknown", "The requested Race competitor is unavailable")
    publishState()
    return false
  end
  local focused, reason = adapter.enterVehicle(entry.vehicleId)
  setResult(focused, focused and "race_competitor_focused" or reason,
    focused and "Focused the selected Race competitor" or "The selected competitor could not be focused",
    {handle = handle, vehicleId = entry.vehicleId})
  publishState()
  return focused
end

function production.reorderLineupCompetitor(index, newPosition)
  local lineup = runtime.lineup.current
  index = math.floor(tonumber(index) or -1)
  local changed, reason = productionModules.raceManager.reorder(lineup, index, newPosition)
  if not changed then
    setResult(false, reason, "Competitor order was not changed")
    publishState()
    return false
  end
  local persisted, persistReason = production.persistCurrentLineup()
  setResult(persisted, persisted and "lineup_competitor_reordered" or "lineup_storage_failed",
    persisted and "Competitor placement order updated" or "The new order could not be checkpointed",
    {index = index, position = newPosition, reason = persistReason})
  publishState()
  return persisted
end

production.resumeEngineFluidContinuation = function(active, continuation)
  if not active or active ~= runtime.active or not operationState.isCurrent(runtime.state, active.token) then return end
  if continuation == "random_config" then
    production.completeRandomConfig(active)
  else
    completeChaos(active)
  end
end

production.onFluidProbe = function(evidence)
  local active = runtime.active
  local guard = active and active.engineFluidGuard
  if not guard or guard.complete == true or type(evidence) ~= "table"
    or evidence.requestId ~= guard.requestId
    or tonumber(evidence.vehicleId) ~= tonumber(guard.vehicleId)
    or tostring(evidence.operationId) ~= tostring(guard.operationId)
    or tostring(evidence.operationGeneration) ~= tostring(guard.operationGeneration)
    or tostring(evidence.targetGeneration) ~= tostring(guard.targetGeneration)
  then
    diagnosticsModule.write(runtime.diagnostics, "W", "stale_engine_fluid_probe_ignored", {
      received = type(evidence) == "table" and {
        requestId = evidence.requestId, vehicleId = evidence.vehicleId,
        operationId = evidence.operationId, operationGeneration = evidence.operationGeneration,
        targetGeneration = evidence.targetGeneration,
      } or nil,
      expected = guard and {
        requestId = guard.requestId, vehicleId = guard.vehicleId,
        operationId = guard.operationId, operationGeneration = guard.operationGeneration,
        targetGeneration = guard.targetGeneration,
      } or nil,
    }, true)
    return false
  end
  local signature = productionModules.engineFluidGuard.signature(evidence)
  guard.stableSamples = signature == guard.lastSignature and guard.stableSamples + 1 or 1
  guard.lastSignature = signature
  guard.lastEvidence = util.deepCopy(evidence)
  guard.awaitingResponse = false
  active.engineFluidEvidence = util.deepCopy(evidence)
  if guard.stableSamples < 2 then
    guard.nextRequestAt = runtime.time.realMonotonicTime
    return true
  end
  local assessment = productionModules.engineFluidGuard.assess(evidence, guard.classification)
  active.engineFluidReport = assessment
  local fluidPermissive = active.policy and (active.policy.allowMissingParts == true
    or tonumber(active.policy.slider) == 100)
    or active.settings and active.settings.allowPartialResult == true
  if assessment.valid == false and not fluidPermissive then
    guard.failurePending = adapter.errorValue(
      "engine_fluid_safety_failed",
      "Direct vehicle evidence found an unsafe engine-fluid state; no unverified runtime setter was used",
      {assessment = util.deepCopy(assessment), tuningProtection = util.deepCopy(active.engineFluidTuningProtection)}
    )
  else
    guard.complete = true
    guard.resumePending = true
    active.readBackStatus = assessment.fluidState == "FLUID_OK" and "engine_fluid_safe" or "engine_fluid_uncertain"
    if assessment.fluidState ~= "FLUID_OK" then
      active.engineFluidUncertain = true
      active.nonFatalPartial = true
      active.warnings[#active.warnings + 1] =
        (assessment.fluidState == "UNSAFE_CONFIRMED"
          and "The selected chaos policy accepted a confirmed unsafe fluid state with a warning."
          or "Engine-fluid runtime evidence was incomplete; this result is preserved without a fluid-safety claim.")
    end
  end
  diagnosticsModule.write(runtime.diagnostics,
    assessment.valid == false and "E" or assessment.status == "safe" and "I" or "W",
    "engine_fluid_probe_completed", {
      stableSamples = guard.stableSamples, attempts = guard.attempts,
      assessment = util.deepCopy(assessment),
      tuningProtection = util.deepCopy(active.engineFluidTuningProtection),
    }, assessment.status ~= "safe")
  return true
end

production.processEngineFluidGuard = function()
  local active = runtime.active
  local guard = active and active.engineFluidGuard
  if not guard or guard.complete == true and not guard.resumePending then return false end
  if guard.failurePending then
    local failure = guard.failurePending
    guard.failurePending = nil
    failActive(failure, true, "engine_fluid_validation")
    return true
  end
  if guard.resumePending then
    guard.resumePending = false
    production.resumeEngineFluidContinuation(active, guard.continuation)
    return true
  end
  local now = runtime.time.realMonotonicTime
  if now < (guard.nextRequestAt or 0) then return true end
  if guard.attempts >= 8 then
    guard.complete = true
    guard.resumePending = true
    active.engineFluidUncertain = true
    active.nonFatalPartial = true
    active.engineFluidReport = {
      valid = nil, status = "unavailable", classification = guard.classification,
      fluidState = "UNKNOWN",
      source = "bounded_vehicle_lua_probe", attempts = guard.attempts,
      lastEvidence = util.deepCopy(guard.lastEvidence), lastError = util.deepCopy(guard.lastError),
    }
    active.warnings[#active.warnings + 1] =
      "Engine-fluid runtime evidence was unavailable after eight bounded requests; no fluid-safety claim is made."
    diagnosticsModule.write(runtime.diagnostics, "W", "engine_fluid_probe_unavailable",
      util.deepCopy(active.engineFluidReport), true)
    return true
  end
  guard.attempts = guard.attempts + 1
  local queued, result = adapter.requestFluidEvidence(guard.vehicleId, guard.requestId, {
    operationId = guard.operationId, operationGeneration = guard.operationGeneration,
    targetGeneration = guard.targetGeneration,
  })
  guard.awaitingResponse = queued == true
  if not queued then guard.lastError = util.deepCopy(result) end
  guard.nextRequestAt = now + 0.25
  return true
end

local function onUpdate(dtReal, dtSim, dtRaw)
  local updateStarted = adapter.clock()
  local pauseKnown, paused = false, nil
  if type(adapter.getPauseState) == "function" then
    local okPause, pauseValue = adapter.getPauseState()
    if okPause then pauseKnown, paused = true, pauseValue end
  end
  timeSource.sample(runtime.time, dtReal, dtSim, dtRaw, pauseKnown and paused or nil, adapter.clock())
  production.processIncrementalIndex()
  if not runtime.indexer.active and (runtime.index.valid ~= true or runtime.index.stale == true)
    and productionModules.registryReadiness.due(runtime.registry, adapter.clock())
  then
    local previousRegistryState = runtime.registry.state
    local indexed = rebuildIndex()
    if indexed or runtime.registry.state ~= previousRegistryState then publishState() end
  end
  local fluidStarted = adapter.clock()
  local fluidWorkHandled = production.processEngineFluidGuard()
  productionModules.performanceMetrics.record(runtime.performanceTelemetry, "fluidGuard", math.max(0, (adapter.clock() - fluidStarted) * 1000))
  local activeAtFrameStart = runtime.active
  if activeAtFrameStart and activeAtFrameStart.progressWatchdog then
    progressWatchdog.observePause(
      activeAtFrameStart.progressWatchdog, runtime.time.paused, runtime.time.realMonotonicTime
    )
  end

  if runtime.state.busy and runtime.active then
    local active = runtime.active
    local waitPhase = active.wait and active.wait.phase
    local targetMayBeInTransit = waitPhase == "spawn" or waitPhase == "rollback"
      or waitPhase == "undo" or waitPhase == "dna_base_spawn"
      or (active.startedWithoutVehicle and active.operationCurrentTarget == nil)
    local okPlayer, playerVehicleId = adapter.getCurrentVehicleId()
    if not targetMayBeInTransit and (not okPlayer or playerVehicleId == nil) then
      active.playerVehicleMissingSince = active.playerVehicleMissingSince or runtime.time.realMonotonicTime
      active.readBackStatus = "target_identity_unstable"
      if runtime.time.realMonotonicTime - active.playerVehicleMissingSince >= 2 then
        failActive(adapter.errorValue("target_id_changed", "The player vehicle disappeared during the operation", {
          expectedVehicleId = active.operationCurrentTarget and active.operationCurrentTarget.vehicleId or active.vehicleId,
          currentVehicleId = playerVehicleId,
          wallElapsed = runtime.time.realMonotonicTime - active.playerVehicleMissingSince,
        }), true, runtime.state.phase or "lifecycle")
      end
    else
      active.playerVehicleMissingSince = nil
    end
  end

  local previewStarted = adapter.clock()
  if runtime.racePreview and runtime.racePreview.enabled then
    local drawWorked, renderResult, renderReport = pcall(function()
      if type(productionModules.spawnAdapter.drawPreview) ~= "function" then
        return false, {rendererAvailable = false, errorCode = "preview_renderer_unavailable"}
      end
      return productionModules.spawnAdapter.drawPreview(
        productionModules.racePreview.placements(runtime.racePreview)
      )
    end)
    if not drawWorked then
      local drawFailure = renderResult
      renderResult = false
      renderReport = {rendererAvailable = true, requestedMarkerCount = #(runtime.racePreview.slots or {}),
        renderedMarkerCount = 0, errorCode = "preview_renderer_threw", errorMessage = tostring(drawFailure)}
    end
    local previewStateChanged = productionModules.racePreview.recordRender(
      runtime.racePreview, renderReport, runtime.time.realMonotonicTime, renderResult
    )
    if previewStateChanged then
      diagnosticsModule.write(runtime.diagnostics,
        runtime.racePreview.state == "PREVIEW_RENDERED" and "I" or "W",
        "race_preview_state_changed", {
          state = runtime.racePreview.state,
          renderer = util.deepCopy(runtime.racePreview.renderer),
        }, runtime.racePreview.state ~= "PREVIEW_RENDERED")
      publishState()
    end
  end
  productionModules.destinationMarker.draw(runtime.destination)
  productionModules.performanceMetrics.record(runtime.performanceTelemetry, "preview", math.max(0, (adapter.clock() - previewStarted) * 1000))
  if runtime.stress and runtime.stress.active
    and adapter.clock() - runtime.stress.startedAt >= runtime.stress.options.maxDuration
  then
    cancelDeveloperStressInternal("duration_limit")
  end

  local targetTrackingStarted = adapter.clock()
  local phaseWorkHandled = fluidWorkHandled or processTargetTracking()
  productionModules.performanceMetrics.record(
    runtime.performanceTelemetry, "targetTracking", math.max(0, (adapter.clock() - targetTrackingStarted) * 1000)
  )
  if not phaseWorkHandled then
    local paintStarted = adapter.clock()
    phaseWorkHandled = processPaintConfirmation()
    productionModules.performanceMetrics.record(runtime.performanceTelemetry, "paintConfirmation", math.max(0, (adapter.clock() - paintStarted) * 1000))
  end
  if not phaseWorkHandled and runtime.state.busy and runtime.active
    and runtime.active.safetyRevalidateAt
    and runtime.time.realMonotonicTime >= runtime.active.safetyRevalidateAt
  then
    local safetyActive = runtime.active
    local continuation = safetyActive.safetyContinuation
    safetyActive.safetyRevalidateAt = nil
    safetyActive.safetyContinuation = nil
    phaseWorkHandled = production.resumeSafetyContinuation(safetyActive, continuation)
  end
  if not phaseWorkHandled and runtime.state.busy and runtime.active and runtime.active.treeRescanAt
    and adapter.clock() >= runtime.active.treeRescanAt
  then
    local treeActive = runtime.active
    local contextOk, contextReason = operationState.validateTimer(
      runtime.state, treeActive.treeRescanContext or {},
      treeActive.operationCurrentTarget
    )
    treeActive.treeRescanAt = nil
    treeActive.treeRescanContext = nil
    if contextOk then
      local treeStarted = adapter.clock()
      setLifecyclePhase(treeActive, "rescanning_tree", false, "tree_rescan_timer")
      processMutationPass(treeActive)
      productionModules.performanceMetrics.record(runtime.performanceTelemetry, "treeRescan", math.max(0, (adapter.clock() - treeStarted) * 1000))
    else
      diagnosticsModule.write(runtime.diagnostics, "W", contextReason, {
        source = "tree_rescan_timer",
      }, true)
    end
    phaseWorkHandled = true
  end

  -- Housekeeping must run even while a lifecycle phase is waiting.
  local spawnDirectorStarted = adapter.clock()
  production.processSpawnDirector()
  productionModules.performanceMetrics.record(
    runtime.performanceTelemetry, "spawnDirector", math.max(0, (adapter.clock() - spawnDirectorStarted) * 1000)
  )
  local aiDirectorStarted = adapter.clock()
  production.processAIDirector()
  productionModules.performanceMetrics.record(
    runtime.performanceTelemetry, "aiDirector", math.max(0, (adapter.clock() - aiDirectorStarted) * 1000)
  )
  local orphanStarted = adapter.clock()
  local orphanResult = productionModules.domainOperations.reap(
    runtime.domainOperations, productionModules.spawnAdapter.deleteVehicle,
    {now = adapter.clock(), clock = adapter.clock, budgetMs = 0.25, maxItems = 2}
  )
  local orphanElapsed = math.max(0, (adapter.clock() - orphanStarted) * 1000)
  productionModules.performanceMetrics.record(runtime.performanceTelemetry, "orphanReaper", orphanElapsed)
  if #orphanResult.removed > 0 or #orphanResult.failed > 0 then
    diagnosticsModule.write(runtime.diagnostics, #orphanResult.failed == 0 and "I" or "W", "orphan_reaper_batch", {
      removed = #orphanResult.removed, failed = #orphanResult.failed, pending = orphanResult.pending,
    }, #orphanResult.failed > 0)
  end

  local waitingForSimulation = runtime.state.phase == "waiting_for_simulation_resume"
  local watchdogState
  if runtime.active and runtime.active.progressWatchdog then
    local watchdogDomain = runtime.active.domainContext
    local temporaryCount = 0
    if watchdogDomain then
      for _, vehicleId in ipairs(watchdogDomain.ownedVehicleIds or {}) do
        local owner = productionModules.domainOperations.ownership(runtime.domainOperations, vehicleId)
        if owner and owner.managed and owner.accepted ~= true and owner.removed ~= true then
          temporaryCount = temporaryCount + 1
        end
      end
    end
    progressWatchdog.observeMetrics(runtime.active.progressWatchdog, {
      ownedVehicleCount = watchdogDomain and #(watchdogDomain.ownedVehicleIds or {}) or 0,
      temporaryVehicleCount = temporaryCount,
      callbackCount = (runtime.state.staleCallbackCount or 0)
        + (runtime.active.targetTracker and #(runtime.active.targetTracker.events or {}) or 0),
      frameBudgetOverruns = runtime.frameBudgets.totalExceeded or 0,
    })
    local phaseCode = runtime.state.phase
    local waitingForEngineEvent = phaseCode == "issuing_spawn"
      or phaseCode == "tracking_target_identity"
      or phaseCode == "waiting_parts_reload"
      or phaseCode == "waiting_tuning_reload"
      or phaseCode == "rolling_back_operation"
    local engineActive = phaseCode == "stabilizing_tree" or phaseCode == "applying_parts"
      or phaseCode == "verifying_parts" or phaseCode == "applying_tuning"
      or phaseCode == "verifying_tuning" or phaseCode == "applying_paint"
      or phaseCode == "verifying_paint" or phaseCode == "final_validation"
    watchdogState = progressWatchdog.evaluate(runtime.active.progressWatchdog,
      runtime.time.realMonotonicTime, {
        waitingForSimulation = waitingForSimulation,
        waitingForEngineEvent = waitingForEngineEvent,
        engineActive = engineActive,
      })
    if watchdogState ~= runtime.active.lastWatchdogState then
      runtime.active.lastWatchdogState = watchdogState
      diagnosticsModule.write(runtime.diagnostics,
        watchdogState == "NO_PROGRESS" and "W" or "D", "operation_watchdog", {
          state = watchdogState,
          lifecyclePhase = runtime.state.phase,
          clocks = timeSource.snapshot(runtime.time),
          watchdog = progressWatchdog.snapshot(
            runtime.active.progressWatchdog, runtime.time.realMonotonicTime
          ),
        }, watchdogState == "NO_PROGRESS")
    end
    if runtime.active.progressWatchdog.pauseDependentProgressDetected
      and not runtime.active.pauseDependencyReported
    then
      runtime.active.pauseDependencyReported = true
      diagnosticsModule.write(runtime.diagnostics, "E", "pause_toggle_unblocked_operation", {
        lifecyclePhase = runtime.state.phase,
        clocks = timeSource.snapshot(runtime.time),
      }, true)
    end
    if watchdogState == "NO_PROGRESS" and runtime.state.busy and runtime.active
      and runtime.active.watchdogAbortStarted ~= true
    then
      runtime.active.watchdogAbortStarted = true
      progressWatchdog.setStatus(runtime.active.progressWatchdog, "aborting")
      failActive(adapter.errorValue("operation_watchdog_stalled",
        "The operation watchdog stopped a transaction that made no bounded progress", {
          watchdog = progressWatchdog.snapshot(
            runtime.active.progressWatchdog, runtime.time.realMonotonicTime
          ),
        }), true, runtime.state.phase or "lifecycle")
    end
  end

  if runtime.state.busy and operationState.isOperationExpired(
    runtime.state, runtime.time.realMonotonicTime
  ) then
    failActive(adapter.errorValue("operation_deadline_exceeded", "The operation exceeded its bounded wall-clock deadline", {
      lifecyclePhase = runtime.state.phase,
      clocks = timeSource.snapshot(runtime.time),
    }), true, runtime.state.phase or "lifecycle")
  elseif runtime.state.busy and not waitingForSimulation and operationState.isExpired(
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
  local raceStarted = adapter.clock()
  production.auditRaceScheduler()
  if runtime.lineup.pendingNext and runtime.lineup.current then
    local enqueued, enqueueReason = productionModules.cooperativeScheduler.enqueue(
      runtime.cooperativeScheduler, "race_slot",
      "race_slot:" .. tostring(runtime.lineup.current.id) .. ":"
        .. tostring(runtime.lineup.current.nextIndex or 1),
      {lineupId = runtime.lineup.current.id}
    )
    local enqueueState = productionModules.raceScheduler.noteEnqueue(
      runtime.lineup.current, enqueued, enqueueReason
    )
    if enqueueState.terminal then
      runtime.lineup.pendingNext = false
      runtime.lineup.current.active = false
      runtime.lineup.current.generationState = "lineup_failed"
      runtime.lineup.current.processingState = "lineup_processing_finished"
      runtime.lineup.current.schedulerState = "terminal"
      runtime.lineup.current.schedulerTerminalReason = enqueueState.reason
      setResult(false, enqueueState.reason,
        "Race generation stopped because its scheduler queue remained unavailable")
      production.persistCurrentLineup()
      publishState()
    end
  end
  productionModules.cooperativeScheduler.tick(
    runtime.cooperativeScheduler,
    function(kind, payload)
      if kind == "race_slot" and runtime.lineup.current
        and payload.lineupId == runtime.lineup.current.id
      then
        productionModules.raceScheduler.noteDispatch(runtime.lineup.current)
        production.startNextLineupCompetitor()
      end
    end,
    {maxSteps = runtime.stabilityLimits.maxSpawnAttemptsPerFrame,
      budgetMs = 0.5, clock = adapter.clock}
  )
  productionModules.performanceMetrics.record(runtime.performanceTelemetry, "raceGeneration", math.max(0, (adapter.clock() - raceStarted) * 1000))
  if runtime.pendingProgressPublish and productionModules.uiPublisher.due(runtime.uiPublisher, adapter.clock(), false) then
    production.publishProgress(true)
  end
  local updateElapsedMs = math.max(0, (adapter.clock() - updateStarted) * 1000)
  if runtime.active then
    runtime.active.maxSingleStep = math.max(runtime.active.maxSingleStep or 0, updateElapsedMs)
  elseif activeAtFrameStart then
    activeAtFrameStart.maxSingleStep = math.max(activeAtFrameStart.maxSingleStep or 0, updateElapsedMs)
  end
  productionModules.performanceMetrics.record(runtime.performanceTelemetry, "onUpdate", updateElapsedMs)
  local mode = runtime.lineup.current and runtime.lineup.current.active and "race"
    or runtime.state.busy and "busy" or "idle"
  local budget = productionModules.frameBudget.budgetFor(runtime.frameBudgets, mode)
  production.recordBudget("onUpdate:" .. mode, updateElapsedMs, budget)
end

production.onExtensionLoaded = function()
  initialize()
  if runtime.index.valid ~= true then rebuildIndex() end
  publishState()
end

M.runAction = runAction
M.randomConfig = function(settingsSnapshot) return runAction("randomConfig", settingsSnapshot) end
M.scramble = function(settingsSnapshot) return runAction("scramble", settingsSnapshot) end
M.fullRandom = function(settingsSnapshot) return runAction("fullRandom", settingsSnapshot) end
M.undo = function() return runAction("undo") end
M.reindex = function() return runAction("reindex") end
M.updateSettings = updateSettings
M.updateUIPreferences = production.updateUIPreferences
M.migrateLegacyUIPreferences = production.migrateLegacyUIPreferences
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
M.cancelRaceGeneration = production.cancelRaceGeneration
M.getDeveloperStressState = getDeveloperStressState
M.previewRaceGeneration = production.previewRaceGeneration
M.createChaosLineup = production.createChaosLineup
M.retryLineupPersistence = production.retryLineupPersistence
M.renameLineupCompetitor = production.renameLineupCompetitor
M.reorderLineupCompetitor = production.reorderLineupCompetitor
M.resolveLineupFailure = production.resolveLineupFailure
M.exportChaosLineup = production.exportChaosLineup
M.importChaosLineup = production.importChaosLineup
M.previewLineupSpawn = production.previewLineupSpawn
M.startLineupSpawn = production.startLineupSpawn
M.cancelLineupSpawn = production.cancelLineupSpawn
M.removeManagedVehicle = production.removeManagedVehicle
M.respawnManagedVehicle = production.respawnManagedVehicle
M.focusManagedVehicle = production.focusManagedVehicle
M.placeAIDestination = production.placeAIDestination
M.confirmAIDestination = production.confirmAIDestination
M.clearAIDestination = production.clearAIDestination
M.addAIRoutePoint = production.addAIRoutePoint
M.editAIRoute = production.editAIRoute
M.startManagedAI = production.startManagedAI
M.startAIQuickPreset = production.startAIQuickPreset
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

production.uiCommandHandlers = {
  requestState = function() requestState(); return true end,
  runAction = runAction,
  updateSettings = updateSettings,
  updateUIPreferences = production.updateUIPreferences,
  migrateLegacyUIPreferences = production.migrateLegacyUIPreferences,
  setUICompactMode = setUICompactMode,
  cancelCurrentOperation = cancelCurrentOperation,
  cancelRaceGeneration = production.cancelRaceGeneration,
  getVehicleDNALocks = getVehicleDNALocks,
  copyDiagnostics = copyDiagnostics,
  spawnSafeVehicle = spawnSafeVehicle,
  retryQuarantinedConfigurations = retryQuarantinedConfigurations,
  rerollUnlocked = rerollUnlocked,
  previewRaceGeneration = production.previewRaceGeneration,
  saveVehicleDNA = saveVehicleDNA,
  deleteVehicleDNA = deleteVehicleDNA,
  renameVehicleDNA = renameVehicleDNA,
  setVehicleDNAFavorite = setVehicleDNAFavorite,
  setVehicleDNAPinned = setVehicleDNAPinned,
  setVehicleDNARating = setVehicleDNARating,
  setVehicleDNATags = setVehicleDNATags,
  setVehicleDNACollection = setVehicleDNACollection,
  setVehicleDNANotes = setVehicleDNANotes,
  duplicateVehicleDNA = duplicateVehicleDNA,
  setVehicleDNAQuery = setVehicleDNAQuery,
  getVehicleDNADetails = getVehicleDNADetails,
  compareVehicleDNA = compareVehicleDNA,
  importVehicleDNA = importVehicleDNA,
  exportVehicleDNAJson = exportVehicleDNAJson,
  exportVehicleDNAPackage = exportVehicleDNAPackage,
  importVehicleDNAPackage = importVehicleDNAPackage,
  confirmVehicleDNAPackageImport = confirmVehicleDNAPackageImport,
  captureVehicleDNAThumbnail = captureVehicleDNAThumbnail,
  removeVehicleDNAThumbnail = removeVehicleDNAThumbnail,
  preflightVehicleDNA = preflightVehicleDNA,
  replayVehicleDNAGeneration = replayVehicleDNAGeneration,
  pureSeedReplayVehicleDNA = pureSeedReplayVehicleDNA,
  mutateVehicleDNA = mutateVehicleDNA,
  restoreVehicleDNA = restoreVehicleDNA,
  setVehicleDNAPage = setVehicleDNAPage,
  lockVehicle = lockVehicle,
  lockConfiguration = lockConfiguration,
  lockCategory = lockCategory,
  lockSlot = lockSlot,
  unlockSlot = unlockSlot,
  lockPart = lockPart,
  lockCurrentParts = lockCurrentParts,
  lockTuning = lockTuning,
  lockPaint = lockPaint,
  applyLockPreset = applyLockPreset,
  updateLockProfile = updateLockProfile,
  createChaosLineup = production.createChaosLineup,
  retryLineupPersistence = production.retryLineupPersistence,
  renameLineupCompetitor = production.renameLineupCompetitor,
  reorderLineupCompetitor = production.reorderLineupCompetitor,
  resolveLineupFailure = production.resolveLineupFailure,
  exportChaosLineup = production.exportChaosLineup,
  importChaosLineup = production.importChaosLineup,
  previewLineupSpawn = production.previewLineupSpawn,
  startLineupSpawn = production.startLineupSpawn,
  cancelLineupSpawn = production.cancelLineupSpawn,
  removeManagedVehicle = production.removeManagedVehicle,
  respawnManagedVehicle = production.respawnManagedVehicle,
  focusManagedVehicle = production.focusManagedVehicle,
  placeAIDestination = production.placeAIDestination,
  confirmAIDestination = production.confirmAIDestination,
  clearAIDestination = production.clearAIDestination,
  addAIRoutePoint = production.addAIRoutePoint,
  editAIRoute = production.editAIRoute,
  startManagedAI = production.startManagedAI,
  startAIQuickPreset = production.startAIQuickPreset,
  pauseManagedAI = function() return production.controlManagedAI("pause") end,
  resumeManagedAI = function() return production.controlManagedAI("resume") end,
  stopManagedAI = function() return production.controlManagedAI("stop") end,
  resetManagedAI = function() return production.controlManagedAI("reset") end,
  setAIRecording = production.setAIRecording,
}

M.dispatchUICommand = function(envelope)
  if not runtime.uiCommandRouter then
    runtime.uiCommandRouter = productionModules.uiCommandRouter.create(production.uiCommandHandlers, {
      encodeJSON = adapter.encodeJSON,
      completedLimit = 128,
    })
  end
  return productionModules.uiCommandRouter.dispatch(runtime.uiCommandRouter, envelope)
end
M.onExtensionLoaded = production.onExtensionLoaded
M.onVehicleSpawned = onVehicleSpawned
M.onVehicleSwitched = onVehicleSwitched
M.onVehicleDestroyed = onVehicleDestroyed
M.onFluidProbe = production.onFluidProbe
M.onClientEndMission = onClientEndMission
M.onModActivated = onModStateChanged
M.onModDeactivated = onModStateChanged
M.onUpdate = onUpdate
M.onExtensionUnloaded = function()
  if runtime.state.busy then
    cancelOperation("extension_unloaded", "Operation cancelled because the Randomizer extension unloaded")
  end
  if runtime.active then vehicleRecovery.cleanup(runtime.active) end
  runtime.active = nil
  runtime.spawnDirector.preview = nil
  runtime.racePreview = nil
  if runtime.spawnDirector.run then runtime.spawnDirector.run.active = false end
  productionModules.destinationMarker.clear(runtime.destination)
  productionModules.routePlanner.clear(runtime.aiRoute)
  production.controlManagedAI("reset")
  runtime.uiCommandRouter = nil
  productionModules.cooperativeScheduler.clear(runtime.cooperativeScheduler)
  runtime.uiSequence = productionModules.uiProtocol.createSequence()
  runtime.initialized = false
end

return M
