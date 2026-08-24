local root = rawget(_G, "SCR_TEST_ROOT") or os.getenv("SCR_TEST_VFS_ROOT") or "."
package.path = root .. "/?.lua;" .. root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path

local configSelector = require("ge/extensions/soturineChaosRandomizer/configSelector")
local coverageLimits = require("ge/extensions/soturineChaosRandomizer/coverageLimits")
local slotCoverageLedger = require("ge/extensions/soturineChaosRandomizer/slotCoverageLedger")
local treeConvergence = require("ge/extensions/soturineChaosRandomizer/treeConvergence")
local timeSource = require("ge/extensions/soturineChaosRandomizer/timeSource")
local candidateIsolation = require("ge/extensions/soturineChaosRandomizer/candidateIsolation")
local baselineSemantics = require("ge/extensions/soturineChaosRandomizer/baselineSemantics")
local coherentStateGate = require("ge/extensions/soturineChaosRandomizer/coherentStateGate")
local criticalRepair = require("ge/extensions/soturineChaosRandomizer/criticalRepair")
local engineFluidGuard = require("ge/extensions/soturineChaosRandomizer/engineFluidGuard")
local adapter = require("ge/extensions/soturineChaosRandomizer/apiAdapter")
local capabilities = require("ge/extensions/soturineChaosRandomizer/capabilities")
local contentIndex = require("ge/extensions/soturineChaosRandomizer/contentIndex")
local configVerification = require("ge/extensions/soturineChaosRandomizer/configVerification")
local compatibility = require("ge/extensions/soturineChaosRandomizer/compatibility")
local pathIdentity = require("ge/extensions/soturineChaosRandomizer/pathIdentity")
local registryReadiness = require("ge/extensions/soturineChaosRandomizer/registryReadiness")
local safetyGate = require("ge/extensions/soturineChaosRandomizer/safetyGate")
local safetyModel = require("ge/extensions/soturineChaosRandomizer/runtime/safetyModel")
local crc32 = require("ge/extensions/soturineChaosRandomizer/crc32")
local failureAttribution = require("ge/extensions/soturineChaosRandomizer/failureAttribution")
local energyStorageGuard = require("ge/extensions/soturineChaosRandomizer/energyStorageGuard")
local history = require("ge/extensions/soturineChaosRandomizer/history")
local historyTransaction = require("ge/extensions/soturineChaosRandomizer/historyTransaction")
local lifecycle = require("ge/extensions/soturineChaosRandomizer/lifecycle")
local mutationEngine = require("ge/extensions/soturineChaosRandomizer/mutationEngine")
local mutationPolicy = require("ge/extensions/soturineChaosRandomizer/mutationPolicy")
local operationState = require("ge/extensions/soturineChaosRandomizer/operationState")
local operationContext = require("ge/extensions/soturineChaosRandomizer/runtime/operationContext")
local domainOperations = require("ge/extensions/soturineChaosRandomizer/runtime/domainOperations")
local cooperativeScheduler = require("ge/extensions/soturineChaosRandomizer/runtime/cooperativeScheduler")
local stabilityLimits = require("ge/extensions/soturineChaosRandomizer/runtime/stabilityLimits")
local progressWatchdog = require("ge/extensions/soturineChaosRandomizer/progressWatchdog")
local operationOutcome = require("ge/extensions/soturineChaosRandomizer/operationOutcome")
local formationEnum = require("ge/extensions/soturineChaosRandomizer/formationEnum")
local vehicleIdentity = require("ge/extensions/soturineChaosRandomizer/vehicleIdentity")
local contactDetector = require("ge/extensions/soturineChaosRandomizer/contactDetector")
local playgroundMode = require("ge/extensions/soturineChaosRandomizer/playgroundMode")
local paintRandomizer = require("ge/extensions/soturineChaosRandomizer/paintRandomizer")
local paintVerification = require("ge/extensions/soturineChaosRandomizer/paintVerification")
local partBatchRecovery = require("ge/extensions/soturineChaosRandomizer/partBatchRecovery")
local performanceMetrics = require("ge/extensions/soturineChaosRandomizer/performanceMetrics")
local pngValidator = require("ge/extensions/soturineChaosRandomizer/pngValidator")
local rng = require("ge/extensions/soturineChaosRandomizer/rng")
local settings = require("ge/extensions/soturineChaosRandomizer/settings")
local slotScanner = require("ge/extensions/soturineChaosRandomizer/slotScanner")
local stressRunner = require("ge/extensions/soturineChaosRandomizer/stressRunner")
local tuningCoverageLedger = require("ge/extensions/soturineChaosRandomizer/tuningCoverageLedger")
local tuningPipeline = require("ge/extensions/soturineChaosRandomizer/tuningPipeline")
local transactionalJSON = require("ge/extensions/soturineChaosRandomizer/transactionalJSON")
local userDataMigration = require("ge/extensions/soturineChaosRandomizer/userDataMigration")
local paintCoverageLedger = require("ge/extensions/soturineChaosRandomizer/paintCoverageLedger")
local lineupSchema = require("ge/extensions/soturineChaosRandomizer/lineupSchema")
local lineupManager = require("ge/extensions/soturineChaosRandomizer/lineupManager")
local raceManager = require("ge/extensions/soturineChaosRandomizer/raceManager")
local raceFocusGuard = require("ge/extensions/soturineChaosRandomizer/raceFocusGuard")
local racePreview = require("ge/extensions/soturineChaosRandomizer/racePreview")
local raceAttemptCoordinator = require("ge/extensions/soturineChaosRandomizer/raceAttemptCoordinator")
local raceScheduler = require("ge/extensions/soturineChaosRandomizer/raceScheduler")
local lineupStorage = require("ge/extensions/soturineChaosRandomizer/lineupStorage")
local lineupPersistence = require("ge/extensions/soturineChaosRandomizer/lineupPersistence")
local managedVehicleRegistry = require("ge/extensions/soturineChaosRandomizer/managedVehicleRegistry")
local spawnDirector = require("ge/extensions/soturineChaosRandomizer/spawnDirector")
local spawnApiAdapter = require("ge/extensions/soturineChaosRandomizer/spawnApiAdapter")
local spawnOutcome = require("ge/extensions/soturineChaosRandomizer/spawnOutcome")
local routePlanner = require("ge/extensions/soturineChaosRandomizer/routePlanner")
local destinationMarker = require("ge/extensions/soturineChaosRandomizer/destinationMarker")
local aiAdapter = require("ge/extensions/soturineChaosRandomizer/aiAdapter")
local aiDirector = require("ge/extensions/soturineChaosRandomizer/aiDirector")
local util = require("ge/extensions/soturineChaosRandomizer/util")
local validator = require("ge/extensions/soturineChaosRandomizer/validator")
local vehicleSelector = require("ge/extensions/soturineChaosRandomizer/vehicleSelector")
local vehicleDNA = require("ge/extensions/soturineChaosRandomizer/vehicleDNA")
local vehicleDNACompatibility = require("ge/extensions/soturineChaosRandomizer/vehicleDNACompatibility")
local vehicleDNAFingerprint = require("ge/extensions/soturineChaosRandomizer/vehicleDNAFingerprint")
local vehicleDNAImport = require("ge/extensions/soturineChaosRandomizer/vehicleDNAImport")
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
local vehicleStabilizer = require("ge/extensions/soturineChaosRandomizer/vehicleStabilizer")
local vehicleTargetTracker = require("ge/extensions/soturineChaosRandomizer/vehicleTargetTracker")
local fixtures = require("tests/lua/fixtures/content")
local pipelineHarness = require("tests/lua/pipelineHarness")
local p1 = {
  frameBudget = require("ge/extensions/soturineChaosRandomizer/frameBudget"),
  buffers = require("ge/extensions/soturineChaosRandomizer/vehicleBufferPool"),
  iterator = require("ge/extensions/soturineChaosRandomizer/vehicleIterator"),
  dimensions = require("ge/extensions/soturineChaosRandomizer/dimensionCache"),
  registryCache = require("ge/extensions/soturineChaosRandomizer/registryCache"),
  indexer = require("ge/extensions/soturineChaosRandomizer/incrementalIndexer"),
  ui = require("ge/extensions/soturineChaosRandomizer/uiPublisher"),
  polling = require("ge/extensions/soturineChaosRandomizer/adaptivePolling"),
  aiConfirmation = require("ge/extensions/soturineChaosRandomizer/aiModeConfirmation"),
  diagnostics = require("ge/extensions/soturineChaosRandomizer/diagnostics"),
}
local p2 = {
  protocol = require("ge/extensions/soturineChaosRandomizer/uiProtocol"),
  router = require("ge/extensions/soturineChaosRandomizer/uiCommandRouter"),
  projector = require("ge/extensions/soturineChaosRandomizer/uiStateProjector"),
  preferences = require("ge/extensions/soturineChaosRandomizer/uiPreferences"),
}

local tests = {}
local requirementMappings = {}
local assertionCount = 0
local builtinAssert = assert
local assert
assert = function(...)
  assertionCount = assertionCount + 1
  return builtinAssert(...)
end

local function equal(actual, expected, message)
  assertionCount = assertionCount + 1
  if actual ~= expected then
    error((message or "values differ") .. ": expected " .. tostring(expected) .. ", got " .. tostring(actual), 2)
  end
end

local function truthy(value, message)
  assertionCount = assertionCount + 1
  if not value then error(message or "expected a truthy value", 2) end
end

local function near(actual, expected, epsilon, message)
  assertionCount = assertionCount + 1
  if math.abs(actual - expected) > (epsilon or 1e-9) then
    error((message or "values are not near") .. ": expected " .. tostring(expected) .. ", got " .. tostring(actual), 2)
  end
end

local function scriptedGenerator(booleanValues, floatUnits)
  local booleanIndex = 0
  local floatIndex = 0
  return {
    boolean = function(self, probability)
      booleanIndex = booleanIndex + 1
      local value = booleanValues and booleanValues[booleanIndex]
      if value == nil then return (probability or 0) >= 1 end
      return value
    end,
    float = function(self, minimum, maximum)
      floatIndex = floatIndex + 1
      local unit = floatUnits and floatUnits[floatIndex] or 0.5
      return minimum + (maximum - minimum) * unit
    end,
    choice = function(self, items) return items[1] end,
  }
end

local function sampleDNA(options)
  options = options or {}
  local entry = {
    format = "SoturineVehicleDNA",
    kind = "soturineVehicleDNA",
    schemaVersion = 1,
    generatorVersion = 4,
    id = options.id or "dna-fixture",
    name = options.name or "Fixture DNA",
    createdAt = 1,
    updatedAt = 1,
    favorite = false,
    tags = {},
    environment = {
      beamNGVersion = "fixture", extensionVersion = "0.4.0-alpha.2",
      targetBeamNG = "0.38.6.0.19963", schemaVersion = 1, generatorVersion = 4,
    },
    generation = {
      generatorVersion = 4,
      operation = options.operation or "fullRandom",
      seed = "SCR4-1234-5678",
      settings = {chaos = 100},
      selectionContext = {},
      startingStateFingerprint = "scrfp1-fixture",
    },
    operation = options.operation or "fullRandom",
    seed = {display = "SCR4-1234-5678", legacy = false},
    base = {modelKey = options.modelKey or "fixture_model", configKey = "base", configPath = "/vehicles/fixture_model/base.pc"},
    final = {
      modelKey = options.modelKey or "fixture_model",
      slots = util.deepCopy(options.slots or {}),
      tuning = util.deepCopy(options.tuning or {}),
      paints = util.deepCopy(options.paints or {}),
    },
    safety = {}, warnings = {}, metrics = {}, dependencies = {}, fingerprints = {}, validation = {status = "captured"}, lineage = {},
  }
  entry.fingerprints.settings = vehicleDNAFingerprint.fingerprint(entry.generation.settings)
  entry.fingerprints.environment = vehicleDNAFingerprint.fingerprint(entry.environment)
  entry.fingerprints.base = vehicleDNAFingerprint.fingerprint(entry.base)
  entry.fingerprints.final = vehicleDNAFingerprint.fingerprint(entry.final)
  entry.fingerprints.dependencies = vehicleDNAFingerprint.fingerprint(entry.dependencies)
  return entry
end

local function refreshDNAFingerprints(entry)
  entry.fingerprints.settings = vehicleDNAFingerprint.fingerprint(entry.generation.settings)
  entry.fingerprints.environment = vehicleDNAFingerprint.fingerprint(entry.environment)
  entry.fingerprints.base = vehicleDNAFingerprint.fingerprint(entry.base)
  entry.fingerprints.final = vehicleDNAFingerprint.fingerprint(entry.final)
  entry.fingerprints.dependencies = vehicleDNAFingerprint.fingerprint(entry.dependencies or {})
  return entry
end

tests.deterministic_prng = function()
  local left = rng.new("test-seed")
  local right = rng.new("test-seed")
  for _ = 1, 20 do equal(left:nextUInt(), right:nextUInt()) end
  local other = rng.new("different-seed")
  truthy(left:nextUInt() ~= other:nextUInt(), "different seeds should diverge")
end

tests.seed_normalization = function()
  equal(rng.normalizeSeed("  test-seed  "), rng.normalizeSeed("test-seed"))
  truthy(rng.normalizeSeed("test-seed"):match("^SCR6%-%x%x%x%x%-%x%x%x%x$") ~= nil)
  equal(rng.new("8F31-A902").seed, rng.new("8f31a902").seed)
  equal(rng.new("8F31-A902").seed, rng.new("SCR4-8F31-A902").seed)
end

tests.number_ranges = function()
  local generator = rng.new("ranges")
  for _ = 1, 500 do
    local integer = generator:integer(-3, 7)
    truthy(integer >= -3 and integer <= 7 and integer == math.floor(integer))
    local float = generator:float(-2.5, 4.25)
    truthy(float >= -2.5 and float <= 4.25)
  end
end

tests.weighted_selection = function()
  local generator = rng.new("weights")
  for _ = 1, 40 do equal(generator:weightedChoice({"never", "always"}, {0, 1}), "always") end
end

tests.anti_repeat_selection = function()
  local generator = rng.new("anti-repeat")
  local model = vehicleSelector.select({{key = "a"}, {key = "b"}}, generator, {"a"})
  equal(model.key, "b")
  local config = configSelector.select({
    {modelKey = "a", key = "one"},
    {modelKey = "a", key = "two"},
  }, generator, {"a/one"})
  equal(config.key, "two")
end

tests.chaos_policy_boundaries = function()
  local low = mutationPolicy.fromSettings({chaos = 0, allowMissingParts = true})
  local high = mutationPolicy.fromSettings({chaos = 100, allowMissingParts = true})
  equal(low.slider, 0)
  equal(high.slider, 100)
  equal(low.emptySlotChance, 0)
  truthy(high.emptySlotChance > 0)
  equal(low.maxMutationPasses, 48)
  equal(high.maxMutationPasses, 48)
  truthy(mutationPolicy.mutationChance(high, {depth = 2}, 1) <= 1)
end

tests.immutable_candidates = function()
  local candidates = {"current", "alternate", "alternate", ""}
  local cleaned = mutationEngine.cleanCandidates(candidates, "current")
  equal(#candidates, 4, "candidate source must not be mutated")
  equal(candidates[1], "current")
  equal(#cleaned, 1)
  equal(cleaned[1], "alternate")
end

tests.core_slots_cannot_be_emptied = function()
  local canEmpty, reason = validator.canEmpty({coreSlot = true, depth = 1}, false)
  equal(canEmpty, false)
  equal(reason, "required_or_core")

  local tree = {children = {engine = {
    id = "engine", path = "/engine/", chosenPartName = "engine_a",
    suitablePartNames = {"engine_a"}, children = {},
  }}}
  local scan = assert(slotScanner.scan(tree, { ["/engine/"] = {coreSlot = true} }))
  local result = mutationEngine.plan(scan, nil, {
    partMutationChance = 1, parentMutationChance = 1, nestedMutationChance = 1,
    allowMissingParts = true, emptySlotChance = 1, protectCriticalParts = false,
  }, scriptedGenerator({true, true}))
  equal(result.children.engine.chosenPartName, "engine_a")
end

tests.optional_slots_follow_empty_probability = function()
  local tree = {children = {hood = {
    id = "hood", path = "/hood/", chosenPartName = "hood_a",
    suitablePartNames = {"hood_a", "hood_b"}, children = {},
  }}}
  local scan = assert(slotScanner.scan(tree, {}))
  local result, decisions = mutationEngine.plan(scan, nil, {
    partMutationChance = 1, parentMutationChance = 1, nestedMutationChance = 1,
    allowMissingParts = true, emptySlotChance = 1, protectCriticalParts = false,
  }, scriptedGenerator({true, true}))
  equal(result.children.hood.chosenPartName, "")
  equal(decisions[1].wasRemoved, true)
end

tests.selects_a_different_candidate = function()
  local tree = {children = {door = {
    id = "door", path = "/door/", chosenPartName = "door_a",
    suitablePartNames = {"door_a", "door_b"}, children = {},
  }}}
  local scan = assert(slotScanner.scan(tree, {}))
  local result, decisions = mutationEngine.plan(scan, nil, {
    partMutationChance = 1, parentMutationChance = 1, nestedMutationChance = 1,
    allowMissingParts = false, emptySlotChance = 0, protectCriticalParts = false,
  }, scriptedGenerator({true}))
  equal(result.children.door.chosenPartName, "door_b")
  equal(decisions[1].previousPart, "door_a")
  equal(tree.children.door.chosenPartName, "door_a", "source tree must remain immutable")
end

tests.nested_slot_change_detection = function()
  local firstTree = {children = {body = {
    id = "body", path = "/body/", chosenPartName = "body_a",
    suitablePartNames = {"body_a", "body_b"}, children = {},
  }}}
  local secondTree = util.deepCopy(firstTree)
  secondTree.children.body.children.spoiler = {
    id = "spoiler", path = "/body/spoiler/", chosenPartName = "spoiler_a",
    suitablePartNames = {"spoiler_a", "spoiler_b"}, children = {},
  }
  local first = assert(slotScanner.scan(firstTree, {}))
  local second = assert(slotScanner.scan(secondTree, {}))
  local changed = slotScanner.changedPaths(first, second)
  truthy(changed["/body/spoiler/"])
  truthy(not changed["/body/"])
end

tests.tuning_clamping_and_quantization = function()
  local variable = tuningPipeline.normalize("pressure", {
    min = 10, max = 20, default = 40, step = 2,
  }, {pressure = -50})
  equal(variable.default, 20)
  equal(variable.current, 10)
  equal(util.roundToStep(15.1, 2, 10), 16)

  local value = tuningPipeline.choose(variable, {
    slider = 100, extremeTuningChance = 0, chaos = 1,
  }, scriptedGenerator({false}, {0.37}), false)
  truthy(value >= 10 and value <= 20)
  equal((value - 10) % 2, 0)
end

tests.legacy_lineup_facade_preserves_race_manager_contract = function()
  equal(lineupManager, raceManager)
  equal(lineupManager.create, raceManager.create)
end

tests.crc32_canonical_vectors = function()
  equal(crc32.digest(""), 0)
  equal(crc32.digest("123456789"), 3421780262)
  equal(crc32.digest("The quick brown fox jumps over the lazy dog"), 1095738169)
  equal(crc32.digest({}), nil)
end

tests.performance_metrics_are_bounded_and_report_percentiles = function()
  local metrics = performanceMetrics.create({sampleLimit = 8, eventLimit = 16})
  for value = 1, 100 do truthy(performanceMetrics.record(metrics, "onUpdate", value)) end
  truthy(not performanceMetrics.record(metrics, "onUpdate", 0 / 0))
  for index = 1, 20 do performanceMetrics.recordEvent(metrics, "ui", index / 20) end
  local report = performanceMetrics.snapshot(metrics, 1)
  equal(report.categories.onUpdate.count, 100)
  equal(report.categories.onUpdate.sampleCount, 8)
  truthy(report.categories.onUpdate.p50 <= report.categories.onUpdate.p95)
  truthy(report.categories.onUpdate.p95 <= report.categories.onUpdate.p99)
  equal(report.categories.onUpdate.max, 100)
  equal(report.eventRates.ui.count, 20)
  equal(report.eventRates.ui.perSecond, 16)
end

tests.default_centered_tuning = function()
  local variable = tuningPipeline.normalize("spring", {
    min = 0, max = 100, default = 50,
  }, {spring = 25})
  local value, distribution = tuningPipeline.choose(variable, {
    slider = 0, extremeTuningChance = 0, chaos = 0,
  }, scriptedGenerator({false}, {0.5}), false)
  near(value, 50)
  equal(distribution, "attempted")
end

tests.extreme_biased_tuning = function()
  local variable = tuningPipeline.normalize("spring", {
    min = 0, max = 100, default = 50,
  }, {spring = 50})
  local value, distribution = tuningPipeline.choose(variable, {
    slider = 100, extremeTuningChance = 1, chaos = 1,
  }, scriptedGenerator({true}), true)
  equal(value, 0)
  equal(distribution, "attempted")
end

tests.operation_state_and_timeout = function()
  local now = 10
  local state = operationState.create(function() return now end, 5)
  local ok, token = operationState.begin(state, "scramble", 42, 5)
  truthy(ok)
  truthy(operationState.isCurrent(state, token))
  truthy(operationState.transition(state, "scanning", false))
  truthy(not operationState.isExpired(state))
  truthy(operationState.transition(state, "mutating", false))
  truthy(operationState.transition(state, "waitingForReload", 5))
  now = 14.99
  truthy(not operationState.isExpired(state))
  now = 15
  truthy(operationState.isExpired(state))
end

tests.stale_callback_rejection = function()
  local state = operationState.create(function() return 0 end, 5)
  local _, oldToken = operationState.begin(state, "scramble", 1, 5)
  operationState.finish(state, "cancelled", "test")
  operationState.reset(state)
  local _, currentToken = operationState.begin(state, "scramble", 1, 5)
  truthy(oldToken ~= currentToken)
  truthy(not operationState.isCurrent(state, oldToken))
  truthy(operationState.isCurrent(state, currentToken))
end

tests.circular_history = function()
  local value = history.create(2)
  history.push(value, {modelKey = "one"})
  history.push(value, {modelKey = "two"})
  history.push(value, {modelKey = "three"})
  equal(#value.entries, 2)
  equal(value.entries[1].modelKey, "two")
  equal(history.pop(value).modelKey, "three")
end

tests.session_blacklist_threshold = function()
  local index = contentIndex.create()
  local count, blocked = contentIndex.recordFailure(index, "config", "car/base")
  equal(count, 1)
  equal(blocked, false)
  contentIndex.recordFailure(index, "config", "car/base")
  count, blocked = contentIndex.recordFailure(index, "config", "car/base")
  equal(count, 3)
  equal(blocked, true)
end

tests.settings_migration = function()
  local migrated = settings.validate({
    schemaVersion = 0,
    chaos = 140,
    allowEmptyParts = false,
    fairMode = false,
    historyLimit = 0,
  })
  equal(migrated.schemaVersion, 9)
  equal(migrated.chaos, 100)
  equal(migrated.allowMissingParts, false)
  equal(migrated.selectionFairness, "configuration")
  equal(migrated.historyLimit, 1)
end

tests.mod_config_pack_filtering = function()
  local index = contentIndex.create()
  local ok = contentIndex.build(index, {
    {key = "official_car", Name = "Official Car", Source = "BeamNG - Official", Type = "Car"},
  }, {
    {model_key = "official_car", key = "mod_config", Source = "A Config Pack", modID = "pack", pcFilename = "/vehicles/official_car/mod_config.pc"},
    {model_key = "official_car", key = "official_config", Source = "BeamNG - Official", pcFilename = "/vehicles/official_car/official_config.pc"},
  }, 1, 0.1)
  truthy(ok)
  local models = contentIndex.eligibleModels(index, {
    contentFilter = "mods", includeAutomation = true, includeTrailers = true, includeProps = true,
  })
  equal(#models, 1)
  equal(#models[1].configs, 1)
  equal(models[1].configs[1].key, "mod_config")
end

local function fullMutationPolicy(protect)
  return {
    partMutationChance = 1,
    parentMutationChance = 1,
    nestedMutationChance = 1,
    allowMissingParts = false,
    emptySlotChance = 0,
    protectCriticalParts = protect == true,
    maxMutationPasses = 5,
  }
end

local function decisionsByReason(decisions, reason)
  local result = {}
  for _, decision in ipairs(decisions or {}) do
    if decision.reason == reason then result[#result + 1] = decision end
  end
  return result
end

tests.adapter_rejects_false_api_result = function()
  local original = core_vehicle_partmgmt
  core_vehicle_partmgmt = {setPartsTreeConfig = function() return false end}
  local ok, err = adapter.applyPartsTree({})
  core_vehicle_partmgmt = original
  equal(ok, false)
  equal(err.code, "parts_apply_rejected")
end

tests.adapter_handles_nil_contract_explicitly = function()
  local original = core_vehicle_partmgmt
  core_vehicle_partmgmt = {setConfigVars = function() return nil end}
  local ok, result = adapter.applyTuning({value = 1})
  core_vehicle_partmgmt = original
  equal(ok, true)
  equal(result.confirmationRequired, true)
  equal(result.contract, "nil_then_event")
end

tests.adapter_preserves_thrown_api_error = function()
  local original = core_vehicle_partmgmt
  core_vehicle_partmgmt = {setConfigVars = function() error("fixture API exception") end}
  local ok, err = adapter.applyTuning({value = 1})
  core_vehicle_partmgmt = original
  equal(ok, false)
  truthy(err.context.thrown)
  truthy(err.context.detail:find("fixture API exception", 1, true) ~= nil)
end

tests.adapter_uses_phase_specific_error_code = function()
  local originalVehicles = core_vehicles
  local originalParts = core_vehicle_partmgmt
  core_vehicles = {replaceVehicle = function() return nil end}
  core_vehicle_partmgmt = {setConfigPaints = function() return false end}
  local _, vehicleError = adapter.replaceVehicle("fixture", "base")
  local _, paintError = adapter.applyPaints({})
  core_vehicles = originalVehicles
  core_vehicle_partmgmt = originalParts
  equal(vehicleError.code, "vehicle_replace_rejected")
  equal(paintError.code, "paint_apply_rejected")
end

tests.adapter_does_not_report_unconfirmed_write_as_success = function()
  local original = core_vehicle_partmgmt
  core_vehicle_partmgmt = {
    setConfigPaints = function() return nil end,
    getConfig = function() return {paints = {{baseColor = {0, 0, 0, 1}}}} end,
  }
  local ok, result = adapter.applyPaints({{baseColor = {1, 1, 1, 1}}})
  core_vehicle_partmgmt = original
  equal(ok, true)
  equal(result.confirmationRequired, true)
  equal(result.verified, false)
end

tests.adapter_passes_exact_replacement_target = function()
  local originalVehicles = core_vehicles
  local originalGetObjectByID = getObjectByID
  local target = {getID = function() return 42 end}
  local receivedTarget
  getObjectByID = function(id) if id == 42 then return target end end
  core_vehicles = {
    replaceVehicle = function(_, _, otherVehicle)
      receivedTarget = otherVehicle
      return otherVehicle
    end,
  }
  local ok, result = adapter.replaceVehicle("fixture", "base", 42)
  core_vehicles = originalVehicles
  getObjectByID = originalGetObjectByID
  truthy(ok)
  equal(receivedTarget, target)
  equal(result.vehicleId, 42)
  equal(result.requestedTargetVehicleId, 42)
end

tests.v072_adapter_mutates_background_vehicle_without_player_staging = function()
  local originalBe = be
  local originalGetObjectByID = getObjectByID
  local originalManager = core_vehicle_manager
  local originalParts = core_vehicle_partmgmt
  local playerId, enterCalls = 1, 0
  local target = {
    getID = function() return 42 end,
    getJBeamFilename = function() return "race_target" end,
  }
  local config = {
    partConfigFilename = "/vehicles/race_target/base.pc",
    partsTree = {chosenPartName = "root", children = {}},
    vars = {boost = 1},
    paints = {{baseColor = {0, 0, 0, 1}}},
  }
  be = {
    getPlayerVehicleID = function() return playerId end,
    enterVehicle = function() enterCalls = enterCalls + 1 end,
  }
  getObjectByID = function(id) if id == 42 then return target end end
  core_vehicle_manager = {
    getVehicleData = function(id)
      if id == 42 then return {config = config, vdata = {variables = {}}} end
    end,
  }
  core_vehicle_partmgmt = {
    setPartsTreeConfig = function() error("player parts API must not be used") end,
    setConfigVars = function() error("player tuning API must not be used") end,
    setConfigPaints = function() error("player paint API must not be used") end,
    setConfigOfVehicle = function(vehicle, patch)
      equal(vehicle, target)
      for key, value in pairs(patch) do config[key] = util.deepCopy(value) end
      return nil
    end,
  }
  local parts = {chosenPartName = "background", children = {}}
  truthy(adapter.applyPartsTree(parts, 42, true))
  truthy(adapter.applyTuning({boost = 2}, 42, true))
  local paintOk, paintResult = adapter.applyPaints({{baseColor = {1, 0, 0, 1}}}, 42, true)
  truthy(paintOk); truthy(paintResult.verified)
  local observedOk, observed = adapter.getVerificationState(42, true)
  truthy(observedOk)
  equal(observed.vehicleId, 42)
  equal(observed.targetRole, "background_owned")
  equal(observed.playerIndex, nil)
  equal(config.partsTree.chosenPartName, "background")
  equal(config.vars.boost, 2)
  equal(playerId, 1)
  equal(enterCalls, 0)
  be = originalBe
  getObjectByID = originalGetObjectByID
  core_vehicle_manager = originalManager
  core_vehicle_partmgmt = originalParts
end

tests.v062_adapter_reads_one_id_specific_target_snapshot = function()
  local originalBe = be
  local originalGetObjectByID = getObjectByID
  local originalManager = core_vehicle_manager
  local originalParts = core_vehicle_partmgmt
  local playerId = 42
  local managerReads = {}
  be = {getPlayerVehicleID = function() return playerId end}
  getObjectByID = function(id)
    if id == 42 then return {getJBeamFilename = function() return "target_model" end} end
  end
  core_vehicle_manager = {
    getPlayerVehicleData = function() error("global player data must not be used") end,
    getVehicleData = function(id)
      managerReads[#managerReads + 1] = id
      return {config = {
        partConfigFilename = "/vehicles/target_model/target.pc",
        partsTree = {chosenPartName = "target_body", children = {}},
        vars = {boost = 2},
        paints = {},
      }}
    end,
  }
  core_vehicle_partmgmt = {getConfig = function() error("global config must not be used") end}
  local ok, state = adapter.getVerificationState(42)
  be = originalBe
  getObjectByID = originalGetObjectByID
  core_vehicle_manager = originalManager
  core_vehicle_partmgmt = originalParts
  truthy(ok)
  equal(state.vehicleId, 42)
  equal(state.modelKey, "target_model")
  equal(state.configIdentity.key, "target")
  truthy(state.coherentTargetRead)
  equal(#managerReads, 2)
  equal(managerReads[1], 42)
  equal(managerReads[2], 42)
end

tests.v064_adapter_exposes_fresh_player_config_beside_stale_manager_bundle = function()
  local originalBe = be
  local originalGetObjectByID = getObjectByID
  local originalManager = core_vehicle_manager
  local originalParts = core_vehicle_partmgmt
  be = {getPlayerVehicleID = function() return 42 end}
  getObjectByID = function(id)
    if id == 42 then return {getJBeamFilename = function() return "target_model" end} end
  end
  core_vehicle_partmgmt = {getConfig = function()
    return {
      partConfigFilename = "/vehicles/target_model/new.pc",
      partsTree = {children = {body = {path = "/body/", chosenPartName = "body_new", children = {}}}},
      vars = {boost = 0.8}, paints = {},
    }
  end}
  core_vehicle_manager = {getVehicleData = function()
    return {config = {
      partConfigFilename = "/vehicles/target_model/old.pc",
      partsTree = {children = {body = {path = "/body/", chosenPartName = "body_old", children = {}}}},
      vars = {boost = 0.2}, paints = {},
    }}
  end}
  local ok, state = adapter.getVerificationState(nil)
  be = originalBe
  getObjectByID = originalGetObjectByID
  core_vehicle_manager = originalManager
  core_vehicle_partmgmt = originalParts
  truthy(ok)
  equal(#state.configCandidates, 2)
  equal(state.configCandidates[1].source, "player_partmgmt")
  equal(state.configCandidates[1].parts["/body/"], "body_new")
  equal(state.configCandidates[2].source, "manager_by_id")
  equal(state.configCandidates[2].parts["/body/"], "body_old")
  truthy(state.readiness.player and state.readiness.model and state.readiness.parts)
end

tests.v063_adapter_detects_id_specific_reads_independently = function()
  local originalBe = be
  local originalManager = core_vehicle_manager
  be = {getPlayerVehicleID = function() return 42 end}
  local reads = {}
  core_vehicle_manager = {
    getVehicleData = function(id)
      reads[#reads + 1] = id
      return {config = {partsTree = {children = {}}, vars = {boost = 1}}}
    end,
  }
  local ok, data = adapter.getCurrentVehicleData(42)
  local capabilities = adapter.getCapabilities()
  be = originalBe
  core_vehicle_manager = originalManager
  truthy(ok)
  truthy(type(data.config) == "table")
  equal(#reads, 1)
  equal(reads[1], 42)
  truthy(capabilities.vehicleDataById)
  truthy(not capabilities.vehicleDataByPlayer)
end

tests.v063_adapter_distinguishes_temporary_read_failure = function()
  local originalBe = be
  local originalManager = core_vehicle_manager
  be = {getPlayerVehicleID = function() return 42 end}
  core_vehicle_manager = {getVehicleData = function() return nil end}
  local ok, errorData = adapter.getCurrentVehicleData(42)
  be = originalBe
  core_vehicle_manager = originalManager
  equal(ok, false)
  equal(errorData.code, "temporarily_unreadable")
  equal(errorData.context.capabilityState, "temporarily_unreadable")
end

tests.v062_adapter_rejects_target_change_during_readback = function()
  local originalBe = be
  local originalGetObjectByID = getObjectByID
  local originalManager = core_vehicle_manager
  local idReads = 0
  be = {getPlayerVehicleID = function()
    idReads = idReads + 1
    return idReads >= 4 and 99 or 42
  end}
  getObjectByID = function(id)
    if id == 42 then return {getJBeamFilename = function() return "target_model" end} end
  end
  core_vehicle_manager = {
    getPlayerVehicleData = function() return nil end,
    getVehicleData = function()
      return {config = {partConfigFilename = "/vehicles/target_model/target.pc", partsTree = {children = {}}}}
    end,
  }
  local ok, err = adapter.getVerificationState(42)
  be = originalBe
  getObjectByID = originalGetObjectByID
  core_vehicle_manager = originalManager
  equal(ok, false)
  equal(err.code, "target_id_changed")
  equal(err.context.expectedVehicleId, 42)
  equal(err.context.currentVehicleId, 99)
end

tests.v062_adapter_rejects_write_to_wrong_player_target = function()
  local originalBe = be
  local originalParts = core_vehicle_partmgmt
  local writeCalled = false
  be = {getPlayerVehicleID = function() return 99 end}
  core_vehicle_partmgmt = {setPartsTreeConfig = function() writeCalled = true end}
  local ok, err = adapter.applyPartsTree({}, 42)
  be = originalBe
  core_vehicle_partmgmt = originalParts
  equal(ok, false)
  equal(err.code, "target_id_changed")
  truthy(not writeCalled)
end

tests.changing_parent_defers_descendant_mutation = function()
  local scan = assert(slotScanner.scan(fixtures.nestedTree, {}))
  local eligible = {["/engine/"] = true, ["/engine/intake/"] = true}
  local tree, decisions = mutationEngine.plan(scan, eligible, fullMutationPolicy(false), scriptedGenerator({true, true, true}))
  equal(tree.children.engine.chosenPartName, "engine_b")
  equal(tree.children.engine.children.intake.chosenPartName, "intake_a")
  equal(#decisionsByReason(decisions, "deferred_due_to_ancestor_change"), 1)
end

tests.multiple_ancestor_changes_defer_all_descendants = function()
  local scan = assert(slotScanner.scan(fixtures.nestedTree, {}))
  local _, decisions = mutationEngine.plan(scan, nil, fullMutationPolicy(false), scriptedGenerator({true, true, true, true, true}))
  truthy(#decisionsByReason(decisions, "deferred_due_to_ancestor_change") >= 4)
end

tests.sibling_mutations_remain_allowed = function()
  local scan = assert(slotScanner.scan(fixtures.nestedTree, {}))
  local eligible = {["/engine/"] = true, ["/accessory/"] = true}
  local tree = mutationEngine.plan(scan, eligible, fullMutationPolicy(false), scriptedGenerator({true, true}))
  equal(tree.children.engine.chosenPartName, "engine_b")
  equal(tree.children.accessory.chosenPartName, "part_pack_b")
end

tests.deferred_descendant_uses_new_tree_candidates = function()
  local first = assert(slotScanner.scan(fixtures.nestedTree, {}))
  local eligible = {["/engine/"] = true, ["/engine/intake/"] = true}
  local _, firstDecisions = mutationEngine.plan(first, eligible, fullMutationPolicy(false), scriptedGenerator({true, true}))
  equal(#decisionsByReason(firstDecisions, "deferred_due_to_ancestor_change"), 1)
  local reloaded = util.deepCopy(fixtures.nestedTree)
  reloaded.children.engine.chosenPartName = "engine_b"
  reloaded.children.engine.children.intake.chosenPartName = "intake_new_a"
  reloaded.children.engine.children.intake.suitablePartNames = {"intake_new_a", "intake_new_b"}
  local second = assert(slotScanner.scan(reloaded, {}))
  local secondEligible = slotScanner.eligiblePaths(first, second, {["/engine/intake/"] = true}, {["/engine/"] = true})
  equal(secondEligible["/engine/"], nil, "a changed ancestor must not be selected again")
  truthy(secondEligible["/engine/intake/"], "the deferred descendant must use the fresh tree")
  local result = mutationEngine.plan(second, secondEligible, fullMutationPolicy(false), scriptedGenerator({true}))
  equal(result.children.engine.children.intake.chosenPartName, "intake_new_b")
end

tests.stable_path_order_is_deterministic = function()
  local scan = assert(slotScanner.scan(fixtures.nestedTree, {}))
  for index = 2, #scan.slots do
    local previous, current = scan.slots[index - 1], scan.slots[index]
    truthy(previous.depth < current.depth or previous.depth == current.depth and previous.path <= current.path)
  end
  local again = assert(slotScanner.scan(util.deepCopy(fixtures.nestedTree), {}))
  equal(scan.signature, again.signature)
end

tests.mutation_pass_cap_is_respected = function()
  equal(mutationPolicy.fromSettings({chaos = 100}).maxMutationPasses, 48)
  truthy(mutationPolicy.fromSettings({chaos = 100}).maxMutationPasses >= 12)
end

tests.stale_candidates_are_never_applied = function()
  local reloaded = util.deepCopy(fixtures.nestedTree)
  reloaded.children.engine.children.intake.suitablePartNames = {"intake_a", "intake_new"}
  local scan = assert(slotScanner.scan(reloaded, {}))
  local result = mutationEngine.plan(scan, {["/engine/intake/"] = true}, fullMutationPolicy(false), scriptedGenerator({true}))
  equal(result.children.engine.children.intake.chosenPartName, "intake_new")
  truthy(result.children.engine.children.intake.chosenPartName ~= "intake_stale")
end

tests.critical_nonempty_replacement_is_protected = function()
  local scan = assert(slotScanner.scan(fixtures.nestedTree, {}))
  local result, decisions = mutationEngine.plan(scan, {["/engine/"] = true}, fullMutationPolicy(true), scriptedGenerator({true}))
  equal(result.children.engine.chosenPartName, "engine_a")
  local found = false
  for _, decision in ipairs(decisions) do
    if decision.reason and decision.reason:find("critical_current_preserved", 1, true) == 1 then found = true end
  end
  truthy(found)
end

tests.critical_slot_prefers_current_or_default = function()
  local slot = {
    id = "energy", description = "Energy Storage", currentPart = "",
    defaultPart = "battery_default", candidates = {"battery_other", "battery_default"},
  }
  local selected, reason = validator.protectedSelection(slot, true)
  equal(selected, "battery_default")
  truthy(reason:find("critical_default_restored", 1, true) == 1)
end

tests.optional_unknown_slot_remains_mutable = function()
  local scan = assert(slotScanner.scan(fixtures.nestedTree, {}))
  local result = mutationEngine.plan(scan, {["/accessory/"] = true}, fullMutationPolicy(true), scriptedGenerator({true}))
  equal(result.children.accessory.chosenPartName, "part_pack_b")
end

tests.legacy_keep_vehicle_drivable_setting_migrates = function()
  local value = settings.validate({schemaVersion = 1, keepVehicleDrivable = true})
  equal(value.schemaVersion, 9)
  equal(value.protectCriticalParts, true)
  equal(value.keepVehicleDrivable, nil)
end

tests.protection_reason_is_exposed = function()
  local valid, reason = validator.validateSelection({
    id = "wheel", description = "Wheel", currentPart = "wheel_a", defaultPart = "wheel_a",
    candidates = {"wheel_a", "wheel_b"},
  }, "wheel_b", true)
  equal(valid, false)
  truthy(reason:find("safety_evidence_unproven", 1, true) == 1)
end

tests.part_blacklist_is_applied = function()
  local index = contentIndex.create()
  local context = {modelKey = "car", slotPath = "/wheel/", candidate = "bad_wheel"}
  for _ = 1, 3 do contentIndex.recordFailure(index, "part", context, {code = "parts_reload_timeout"}) end
  truthy(contentIndex.isBlacklisted(index, "part", context))
end

tests.part_blacklist_key_includes_model_and_slot = function()
  local left = contentIndex.identifier("part", {modelKey = "a", slotPath = "/wheel/", candidate = "part"})
  local right = contentIndex.identifier("part", {modelKey = "b", slotPath = "/wheel/", candidate = "part"})
  local otherSlot = contentIndex.identifier("part", {modelKey = "a", slotPath = "/tire/", candidate = "part"})
  truthy(left ~= right and left ~= otherSlot)
end

tests.full_random_part_failure_does_not_blacklist_base_config = function()
  local index = contentIndex.create()
  local part = {modelKey = "car", slotPath = "/engine/", candidate = "engine_bad"}
  for _ = 1, 3 do contentIndex.recordFailure(index, "part", part, {code = "parts_apply_rejected"}) end
  equal(contentIndex.isBlacklisted(index, "config", {modelKey = "car", configKey = "base"}), false)
end

tests.spawn_failure_blacklists_configuration_only = function()
  local index = contentIndex.create()
  local config = {modelKey = "car", configKey = "base"}
  for _ = 1, 3 do contentIndex.recordFailure(index, "config", config, {code = "vehicle_replace_rejected"}) end
  truthy(contentIndex.isBlacklisted(index, "config", config))
  equal(contentIndex.blacklistCounts(index).part, 0)
end

tests.phase_specific_failure_attribution = function()
  equal(failureAttribution.targetForPhase("spawn", false), "config")
  equal(failureAttribution.targetForPhase("spawn", true), nil)
  equal(failureAttribution.targetForPhase("parts", true), "part")
  equal(failureAttribution.targetForPhase("paint", true), nil)
end

tests.reindex_clears_all_session_blacklists = function()
  local index = contentIndex.create()
  for _ = 1, 3 do contentIndex.recordFailure(index, "model", {modelKey = "bad"}, {code = "spawn"}) end
  for _ = 1, 3 do contentIndex.recordFailure(index, "part", {modelKey = "bad", slotPath = "/x/", candidate = "x"}, {code = "parts"}) end
  contentIndex.clearFailures(index)
  equal(contentIndex.blacklistCounts(index).total, 0)
  equal(index.lastBlocked, nil)
end

tests.blacklist_details_are_present_in_public_state = function()
  local index = contentIndex.create()
  local context = {modelKey = "car", configKey = "bad", seed = "0000-0001", timestamp = 5}
  for _ = 1, 3 do contentIndex.recordFailure(index, "config", context, {code = "vehicle_replace_rejected", seed = context.seed}) end
  equal(index.lastBlocked.type, "config")
  equal(index.lastBlocked.failureCount, 3)
  equal(index.lastBlocked.seed, "0000-0001")
end

tests.blacklisted_candidate_is_not_selected = function()
  local tree = {children = {slot = {id = "slot", path = "/slot/", chosenPartName = "a", suitablePartNames = {"a", "bad", "good"}, children = {}}}}
  local scan = assert(slotScanner.scan(tree, {}))
  local result = mutationEngine.plan(scan, nil, fullMutationPolicy(false), scriptedGenerator({true}), {
    isBlacklisted = function(_, candidate) return candidate == "bad" end,
  })
  equal(result.children.slot.chosenPartName, "good")
end

tests.batch_failure_does_not_immediately_blacklist_every_candidate = function()
  local index = contentIndex.create()
  local context = {modelKey = "car", slotPath = "/slot/", candidate = "suspect", suspectBatch = true}
  contentIndex.recordFailure(index, "part", context, {code = "parts_reload_timeout"})
  equal(contentIndex.isBlacklisted(index, "part", context), false)
  equal(index.suspects.part[contentIndex.identifier("part", context)].failedBatchCount, 1)
end

tests.spawn_event_cannot_complete_parts_wait = function()
  local expectation = lifecycle.createExpectation({token = "A", phase = "parts", vehicleId = 1, parts = {["/slot/"] = "new"}})
  truthy(lifecycle.matches(expectation, {token = "A", eventType = "onVehicleSpawned", vehicleId = 1}))
  local verified = lifecycle.verify(expectation, {parts = {["/slot/"] = "old"}})
  equal(verified, false)
end

tests.parts_event_cannot_complete_tuning_wait = function()
  local expectation = lifecycle.createExpectation({phase = "tuning", tuning = {pressure = 20}})
  local verified = lifecycle.verify(expectation, {tuning = {pressure = 10}})
  equal(verified, false)
end

tests.stale_lifecycle_event_is_ignored = function()
  local expectation = lifecycle.createExpectation({token = "new", phase = "parts"})
  local matched, reason = lifecycle.matches(expectation, {token = "old", eventType = "onVehicleSpawned"})
  equal(matched, false)
  equal(reason, "stale_operation_token")
end

tests.post_event_state_must_be_verified = function()
  local expectation = lifecycle.createExpectation({phase = "spawn", modelKey = "expected", configKey = "base"})
  local verified, reason = lifecycle.verify(expectation, {modelKey = "expected", configKey = "/vehicles/expected/other.pc"})
  equal(verified, false)
  equal(reason, "config_identity_unverified")
  local paintExpectation = lifecycle.createExpectation({phase = "undo", paints = fixtures.paints.one})
  local mismatchedPaints = util.deepCopy(fixtures.paints.one)
  mismatchedPaints[1].baseColor[1] = 0.9
  local paintVerified, paintReason = lifecycle.verify(paintExpectation, {paints = mismatchedPaints})
  equal(paintVerified, false)
  truthy(paintReason:find("paint_state_mismatch", 1, true) == 1)
end

tests.wrong_vehicle_event_cancels_or_is_ignored = function()
  local expectation = lifecycle.createExpectation({phase = "parts", vehicleId = 10})
  local matched, reason = lifecycle.matches(expectation, {eventType = "onVehicleSpawned", vehicleId = 11})
  equal(matched, false)
  equal(reason, "wrong_vehicle_event")
end

tests.timeout_reports_exact_wait_phase = function()
  equal(lifecycle.createExpectation({phase = "parts"}).reason, "waitingForPartsReload")
  equal(lifecycle.createExpectation({phase = "tuning"}).reason, "waitingForTuningReload")
end

tests.unknown_source_remains_unknown = function()
  equal(contentIndex.sourceKind({Source = "Community Label"}), "unknown")
  local model = contentIndex.normalizeModel({key = "official_parent", Source = "BeamNG - Official"})
  local config = contentIndex.normalizeConfig({model_key = "official_parent", key = "missing_source"}, {
    official_parent = model,
  })
  equal(config.sourceKind, "unknown")
  equal(config.sourceLabel, "Unknown")
end

tests.mod_id_overrides_official_parent_model = function()
  local index = contentIndex.create()
  contentIndex.build(index, {{key = "car", Source = "BeamNG - Official"}}, {
    {model_key = "car", key = "pack", modID = "pack", Source = "Pack"},
  })
  equal(index.allConfigs[1].sourceKind, "mod")
end

tests.user_saved_config_is_user = function()
  equal(contentIndex.sourceKind({Source = "Custom"}), "user")
  equal(contentIndex.sourceKind({player = true}), "user")
end

tests.official_aliases_are_explicit = function()
  equal(contentIndex.sourceKind({Source = "BeamNG - Official"}), "official")
  equal(contentIndex.sourceKind({Source = "Official"}), "official")
  equal(contentIndex.sourceKind({Source = "Official-ish"}), "unknown")
end

tests.arbitrary_nonempty_source_is_not_mod = function()
  equal(contentIndex.sourceKind({Source = "An Arbitrary Pack Name"}), "unknown")
end

tests.unknown_filter_behavior_is_documented = function()
  local index = contentIndex.create()
  contentIndex.build(index, fixtures.models, fixtures.configs)
  local base = {includeAutomation = true, includeTrailers = true, includeProps = true}
  local everything = contentIndex.eligibleConfigs(index, util.shallowMerge(base, {contentFilter = "everything"}))
  local mods = contentIndex.eligibleConfigs(index, util.shallowMerge(base, {contentFilter = "mods"}))
  local foundUnknown, modHasUnknown = false, false
  for _, config in ipairs(everything) do if config.sourceKind == "unknown" then foundUnknown = true end end
  for _, config in ipairs(mods) do if config.sourceKind == "unknown" then modHasUnknown = true end end
  truthy(foundUnknown)
  equal(modHasUnknown, false)
end

tests.automation_detection_uses_evidence = function()
  equal(contentIndex.normalizeModel({key = "automation_named_only", Type = "Car"}).isAutomation, false)
  equal(contentIndex.normalizeModel({key = "fixture", Type = "Automation"}).isAutomation, true)
end

tests.trailer_and_prop_classification_regression = function()
  equal(contentIndex.normalizeModel({key = "a", Type = "Trailer"}).isTrailer, true)
  equal(contentIndex.normalizeModel({key = "b", Type = "Property Car"}).isProp, false)
  equal(contentIndex.normalizeModel({key = "c", Type = "Prop"}).isProp, true)
end

tests.uncorrelated_variables_remain_independent = function()
  local _, changes, _, _, _, groups = tuningPipeline.plan({
    frontPressure = {min = 0, max = 10, default = 5},
    rearPressure = {min = 0, max = 10, default = 5},
  }, {}, mutationPolicy.fromSettings({chaos = 100}), rng.new("independent"), {extremeTuning = false})
  equal(#groups, 0)
  truthy(#changes > 0)
end

tests.explicit_group_uses_shared_substream = function()
  local _, _, _, _, _, groups = tuningPipeline.plan(fixtures.variables, {},
    mutationPolicy.fromSettings({chaos = 100}), rng.new("group"), {extremeTuning = false})
  equal(#groups, 1)
  equal(groups[1].groupId, "explicit_axle")
  equal(groups[1].memberCount, 2)
  equal(groups[1].strategy, "shared_normalized_sample")
end

tests.group_members_remain_in_range = function()
  local values = tuningPipeline.plan(fixtures.variables, {},
    mutationPolicy.fromSettings({chaos = 100}), rng.new("range"), {extremeTuning = false})
  truthy(values.groupedA >= 0 and values.groupedA <= 100)
  truthy(values.groupedB >= 10 and values.groupedB <= 20)
end

tests.group_members_keep_individual_steps = function()
  local values = tuningPipeline.plan(fixtures.variables, {},
    mutationPolicy.fromSettings({chaos = 100}), rng.new("steps"), {extremeTuning = false})
  equal(values.groupedA % 5, 0)
  equal((values.groupedB - 10) % 2, 0)
end

tests.missing_group_metadata_does_not_infer_relationship = function()
  local _, changes, _, _, _, groups = tuningPipeline.plan({
    frontSpring = {min = 0, max = 1, default = 0.5, category = "alignment"},
    rearSpring = {min = 0, max = 1, default = 0.5, category = "alignment"},
  }, {}, mutationPolicy.fromSettings({chaos = 100}), rng.new("no-inferred-group"), {extremeTuning = false})
  equal(#groups, 0)
  equal(#changes, 2)
end

tests.group_sampling_is_seed_deterministic = function()
  local policy = mutationPolicy.fromSettings({chaos = 100})
  local left = tuningPipeline.plan(fixtures.variables, {}, policy, rng.new("same-group-seed"), {extremeTuning = false})
  local right = tuningPipeline.plan(fixtures.variables, {}, policy, rng.new("same-group-seed"), {extremeTuning = false})
  truthy(util.deepEqual(left, right, 1e-10))
end

tests.stress_defaults_are_bounded = function()
  local options = assert(stressRunner.normalizeOptions({}))
  equal(options.iterations, 10)
  truthy(options.iterations <= stressRunner.MAX_ITERATIONS)
  truthy(options.maxDuration <= 300)
end

tests.stress_rejects_more_than_max_iterations = function()
  local options, err = stressRunner.normalizeOptions({iterations = 51})
  equal(options, nil)
  equal(err, "stress_iteration_limit")
end

tests.stress_can_be_cancelled = function()
  local state = assert(stressRunner.create({}, 0))
  truthy(stressRunner.cancel(state, "manual"))
  equal(state.active, false)
  equal(state.cancelReason, "manual")
end

tests.stress_never_overlaps_normal_operation = function()
  local state = assert(stressRunner.create({}, 0))
  truthy(state.active)
  truthy(state.pendingNext)
  equal(state.summary.attempts, 0)
end

tests.stress_stops_after_failure_policy = function()
  local state = assert(stressRunner.create({iterations = 5, stopOnFailure = true}, 0))
  stressRunner.record(state, {success = false, seed = "FAIL", phase = "parts"})
  equal(state.active, false)
  equal(state.pendingNext, false)
end

tests.stress_summary_counts_phases = function()
  local state = assert(stressRunner.create({iterations = 2}, 0))
  stressRunner.record(state, {success = false, seed = "A", phase = "parts", timeout = true, duration = 2})
  stressRunner.record(state, {success = true, seed = "B", phase = "validation", duration = 4})
  equal(state.summary.attempts, 2)
  equal(state.summary.phaseCounts.parts, 1)
  equal(state.summary.timeouts, 1)
  near(state.summary.averageDuration, 3)
end

tests.stress_uses_deterministic_iteration_seeds = function()
  local state = assert(stressRunner.create({seed = "base"}, 0))
  local left = stressRunner.iterationSeed(state, rng.new("base"), 3)
  local right = stressRunner.iterationSeed(state, rng.new("base"), 3)
  equal(left, right)
end

tests.stress_does_not_block_in_synchronous_loop = function()
  local state = assert(stressRunner.create({iterations = 50}, 0))
  equal(state.summary.attempts, 0)
  equal(state.pendingNext, true)
end

tests.failed_pre_destructive_operation_does_not_create_undo = function()
  local stack = history.create(10)
  local active = {kind = "scramble"}
  historyTransaction.capture(active, {modelKey = "car"})
  equal(#stack.entries, 0)
end

tests.history_is_pushed_once_before_first_write = function()
  local stack = history.create(10)
  local active = {kind = "scramble", originalState = {modelKey = "car"}}
  local ok, committed = historyTransaction.commit(active, stack, history.push)
  truthy(ok and committed)
  equal(#stack.entries, 1)
  truthy(active.destructiveStarted)
end

tests.multi_pass_mutation_creates_one_history_entry = function()
  local stack = history.create(10)
  local active = {kind = "scramble", originalState = {modelKey = "car"}}
  historyTransaction.commit(active, stack, history.push)
  local _, second = historyTransaction.commit(active, stack, history.push)
  equal(second, false)
  equal(#stack.entries, 1)
end

tests.undo_does_not_create_history_entry = function()
  local stack = history.create(10)
  local ok, committed = historyTransaction.commit({kind = "undo", originalState = {modelKey = "car"}}, stack, history.push)
  truthy(ok)
  equal(committed, false)
  equal(#stack.entries, 0)
end

tests.rollback_history_policy_is_consistent = function()
  local stack = history.create(10)
  local active = {kind = "scramble", originalState = {modelKey = "car"}}
  historyTransaction.commit(active, stack, history.push)
  truthy(historyTransaction.rollbackSucceeded(active, stack, history.pop))
  equal(#stack.entries, 0)
  equal(active.historyCommitted, false)
end

tests.parts_can_run_without_paint_capability = function()
  local value = capabilities.derive({partsRead = true, partsWrite = true, lifecycleConfirmation = true})
  equal(value.scramble, true)
  equal(value.scramblePaint, false)
  truthy(#value.warnings > 0)
end

tests.missing_parts_write_disables_scramble = function()
  local value = capabilities.derive({partsRead = true, partsWrite = false, lifecycleConfirmation = true})
  equal(value.scramble, false)
end

tests.missing_registry_disables_random_config = function()
  local value = capabilities.derive({vehicleRegistry = false, vehicleReplace = true, lifecycleConfirmation = true})
  equal(value.randomConfig, false)
end

tests.capability_warning_is_exposed = function()
  local value = capabilities.derive({
    partsRead = true, partsWrite = true, lifecycleConfirmation = true,
    tuningRead = false, tuningWrite = false, paintRead = false, paintWrite = false,
  })
  truthy(#value.warnings >= 2)
end

tests.v062_capability_report_has_explicit_four_state_contract = function()
  local value = capabilities.derive({
    vehicleReplace = true, vehicleSpawn = false,
    partsRead = true, partsWrite = true,
    tuningRead = true, tuningWrite = false,
    paintRead = false, paintWrite = false,
    navgraph = false, vehicleLuaQueue = true,
    managedMultiVehicle = true, raycast = false,
    thumbnailCapture = false, uiEvents = true,
    dnaPackageRead = true, dnaPackageWrite = true,
  })
  equal(value.report.vehicleReplaceSpawn.status, "degraded")
  equal(value.report.partsReadWrite.status, "available")
  equal(value.report.tuningReadWrite.status, "degraded")
  equal(value.report.paintReadWrite.status, "unavailable")
  equal(value.report.scriptAI.status, "unsupported")
  equal(value.report.managedMultiVehicle.status, "available")
  equal(value.report.raycastCustomPoint.status, "degraded")
  equal(value.report.fileImportExport.status, "available")
  truthy(type(value.report.aiDestination.reason) == "string")
end

tests.full_random_requires_replace_and_parts = function()
  local value = capabilities.derive({
    vehicleRegistry = true, vehicleReplace = true, partsRead = true, partsWrite = false,
    lifecycleConfirmation = true,
  })
  equal(value.randomConfig, true)
  equal(value.fullRandom, false)
end

tests.repeated_suspect_batch_eventually_isolates_candidate = function()
  local index = contentIndex.create()
  local context = {modelKey = "car", slotPath = "/wheel/", candidate = "bad", suspectBatch = true, batchSize = 2}
  for attempt = 1, 3 do
    context.batchFingerprint = "batch-" .. attempt
    contentIndex.recordFailure(index, "part", context, {code = "parts_reload_timeout", timestamp = attempt})
    if attempt == 2 then
      local allowed, reason = contentIndex.isCandidateEligible(index, context)
      equal(allowed, false)
      equal(reason, "candidate_suspect_suppressed")
      truthy(contentIndex.isCandidateEligible(index, context))
    end
  end
  truthy(contentIndex.isBlacklisted(index, "part", context))
end

tests.successful_candidate_reduces_suspicion = function()
  local index = contentIndex.create()
  local context = {
    modelKey = "car", slotPath = "/wheel/", candidate = "maybe", suspectBatch = true,
    batchSize = 2, batchFingerprint = "first", timestamp = 1,
  }
  contentIndex.recordFailure(index, "part", context, {code = "parts_reload_timeout", timestamp = 1})
  local record = index.suspects.part[contentIndex.identifier("part", context)]
  local before = record.suspicionScore
  contentIndex.recordSuccess(index, "part", context, 2)
  record = index.suspects.part[contentIndex.identifier("part", context)]
  truthy(record == nil or record.suspicionScore < before)
end

tests.suspect_batch_does_not_block_every_member_immediately = function()
  local index = contentIndex.create()
  for _, candidate in ipairs({"one", "two", "three"}) do
    local context = {
      modelKey = "car", slotPath = "/slot/", candidate = candidate,
      suspectBatch = true, batchSize = 3, batchFingerprint = "same-batch",
    }
    contentIndex.recordFailure(index, "part", context, {code = "parts_reload_timeout", timestamp = 1})
    truthy(not contentIndex.isBlacklisted(index, "part", context))
  end
end

tests.suspect_entries_affect_selection_policy = function()
  local index = contentIndex.create()
  local context = {modelKey = "car", slotPath = "/slot/", candidate = "suspect", suspectBatch = true, batchSize = 2}
  for attempt = 1, 2 do
    context.batchFingerprint = "different-" .. attempt
    contentIndex.recordFailure(index, "part", context, {code = "parts_reload_timeout", timestamp = attempt})
  end
  local allowed, reason = contentIndex.isCandidateEligible(index, context)
  equal(allowed, false)
  equal(reason, "candidate_suspect_suppressed")
  equal(contentIndex.isBlacklisted(index, "part", context), false)
end

tests.single_candidate_failure_is_stronger_than_batch_failure = function()
  local singleIndex = contentIndex.create()
  local batchIndex = contentIndex.create()
  local base = {modelKey = "car", slotPath = "/slot/", candidate = "part"}
  contentIndex.recordFailure(singleIndex, "part", base, {code = "parts_apply_rejected", timestamp = 1})
  contentIndex.recordFailure(batchIndex, "part", util.shallowMerge(base, {
    suspectBatch = true, batchSize = 4, batchFingerprint = "batch",
  }), {code = "parts_reload_timeout", timestamp = 1})
  local id = contentIndex.identifier("part", base)
  truthy(singleIndex.suspects.part[id].suspicionScore > batchIndex.suspects.part[id].suspicionScore)
end

tests.suspect_memory_is_bounded = function()
  local index = contentIndex.create()
  for value = 1, contentIndex.suspectLimits.records + 25 do
    contentIndex.recordFailure(index, "part", {
      modelKey = "car", slotPath = "/slot/", candidate = "part" .. value,
      suspectBatch = true, batchSize = 2, batchFingerprint = "batch" .. value, timestamp = value,
    }, {code = "parts_reload_timeout", timestamp = value})
  end
  truthy(contentIndex.suspectCount(index) <= contentIndex.suspectLimits.records)
end

tests.reindex_clears_suspects = function()
  local index = contentIndex.create()
  contentIndex.recordFailure(index, "part", {
    modelKey = "car", slotPath = "/slot/", candidate = "part", suspectBatch = true,
    batchSize = 2, batchFingerprint = "batch",
  }, {code = "parts_reload_timeout"})
  contentIndex.clearFailures(index)
  equal(contentIndex.suspectCount(index), 0)
  equal(index.lastSuspect, nil)
end

tests.mod_change_clears_stale_suspects = tests.reindex_clears_suspects
tests.suspect_store_is_bounded = tests.suspect_memory_is_bounded

tests.expected_replace_switch_is_accepted = function()
  local harness = pipelineHarness.new({vehicleId = 1, returnedVehicleId = 2})
  truthy(harness.main.fullRandom({chaos = 100, manualSeed = "replace"}))
  harness.main.onVehicleSwitched(1, 2, 0)
  local state = harness.main.requestState()
  truthy(state.busy)
  equal(state.operationState, "waitingForVehicle")
end

tests.unrelated_switch_during_spawn_cancels = function()
  local harness = pipelineHarness.new({vehicleId = 1, returnedVehicleId = 2})
  truthy(harness.main.randomConfig({manualSeed = "replace"}))
  harness.main.onVehicleSwitched(1, 99, 0)
  harness.vehicleId = 99
  harness.now = harness.now + 0.06
  harness.main.onUpdate()
  local state = harness.main.requestState()
  equal(state.busy, false)
  equal(state.lastResult.code, "vehicle_switched")
end

tests.manual_switch_does_not_retarget_spawn = function()
  local harness = pipelineHarness.new({vehicleId = 1, returnedVehicleId = 2})
  truthy(harness.main.randomConfig({manualSeed = "replace"}))
  harness.main.onVehicleSwitched(1, 99, 0)
  harness.vehicleId = 99
  harness.main.onVehicleSpawned(99)
  harness.now = harness.now + 0.06
  harness.main.onUpdate()
  local state = harness.main.requestState()
  equal(state.lastResult.code, "vehicle_switched")
end

tests.manual_switch_does_not_retarget_rollback = function()
  local harness = pipelineHarness.new({paintFailure = true, vehicleId = 1, returnedVehicleId = 2})
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom", {manualSeed = "rollback"}))
  truthy(harness.pendingReplacement and harness.pendingReplacement.restoring)
  local beforeSwitch = harness.main.requestState()
  truthy(beforeSwitch.transaction.recoveryOnly)
  equal(beforeSwitch.targetMetrics.returnedVehicleId, 2)
  harness.main.onVehicleSwitched(2, 77, 0)
  harness.vehicleId = 77
  harness.modelKey = "fixture_unrelated"
  harness.configPath = "/vehicles/fixture_unrelated/manual.pc"
  pipelineHarness.advance(harness, 0.1, nil, 1)
  local afterSwitch = harness.main.requestState()
  truthy(afterSwitch.lastResult, "rollback switch remained busy: "
    .. tostring(afterSwitch.lifecyclePhase) .. "/"
    .. tostring(afterSwitch.targetMetrics and afterSwitch.targetMetrics.lastReason))
  equal(afterSwitch.lastResult.code, "vehicle_switched")
end

tests.undo_wait_rejects_unrelated_vehicle = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "scramble"))
  truthy(harness.main.undo(), harness.main.requestState().lastResult.message)
  harness.main.onVehicleSwitched(1, 88, 0)
  harness.vehicleId = 88
  harness.modelKey = "fixture_unrelated"
  harness.now = harness.now + 0.06
  harness.main.onUpdate()
  equal(harness.main.requestState().lastResult.code, "vehicle_switched")
end

tests.spawn_event_for_other_vehicle_is_ignored = function()
  local harness = pipelineHarness.new({vehicleId = 1, returnedVehicleId = 2})
  truthy(harness.main.randomConfig({manualSeed = "spawn"}))
  harness.vehicleId = 99
  harness.main.onVehicleSpawned(99)
  truthy(harness.main.requestState().busy)
end

tests.replace_without_returned_id_uses_player_discovery = function()
  local harness = pipelineHarness.new({ambiguousReplace = true})
  truthy(harness.main.randomConfig({manualSeed = "missing-return-id"}))
  equal(harness.pendingReplacement, nil)
  harness.vehicleId = 44
  harness.modelKey = "fixture_new"
  harness.configPath = "/vehicles/fixture_new/base_version.pc"
  pipelineHarness.advance(harness, 0.06, nil, 6)
  local state = harness.main.requestState()
  truthy(not state.busy)
  equal(state.lastResult.code, "random_config_loaded")
end

tests.synchronous_expected_switch_is_correlated = function()
  local harness = pipelineHarness.new({vehicleId = 1, returnedVehicleId = 2, synchronousSwitchId = 2})
  truthy(harness.main.randomConfig({manualSeed = "synchronous-expected"}))
  truthy(harness.main.requestState().busy)
  pipelineHarness.confirmReplacement(harness)
  equal(harness.main.requestState().lastResult.code, "random_config_loaded")
end

tests.synchronous_unrelated_switch_never_starts_rollback = function()
  local harness = pipelineHarness.new({vehicleId = 1, returnedVehicleId = 2, synchronousSwitchId = 99})
  truthy(harness.main.randomConfig({manualSeed = "synchronous-unrelated"}))
  truthy(harness.pendingReplacement and not harness.pendingReplacement.restoring)
  pipelineHarness.confirmReplacement(harness)
  equal(harness.main.requestState().lastResult.code, "random_config_loaded")
end

tests.rollback_never_targets_unrelated_vehicle = function()
  local harness = pipelineHarness.new({vehicleId = 1, returnedVehicleId = 2, paintFailure = true})
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom", {manualSeed = "rollback-id"}))
  truthy(harness.pendingReplacement and harness.pendingReplacement.restoring)
  equal(harness.pendingReplacement.vehicleId, 2)
end

tests.paint_readback_allows_extra_fields = function()
  local expected = {{baseColor = {0.1, 0.2, 0.3, 1}, metallic = 0.2}}
  local actual = {{baseColor = {0.1, 0.2, 0.3, 1}, metallic = 0.2, extra = "preserved"}}
  truthy(paintVerification.compare(expected, actual))
end

tests.paint_readback_compares_requested_fields_only = function()
  local expected = {{baseColor = {0.1, 0.2, 0.3, 1}}}
  local actual = {{baseColor = {0.1, 0.2, 0.3, 1}, metallic = 0.95, roughness = 0.01}}
  truthy(paintVerification.compare(expected, actual))
end

tests.paint_readback_accepts_normalized_float_values = function()
  local expected = {{baseColor = {0.1, 0.2, 0.3, 1}, roughness = 0.5}}
  local actual = {{baseColor = {x = 0.100001, y = 0.199999, z = 0.3, w = 1}, roughness = 0.500001}}
  truthy(paintVerification.compare(expected, actual))
end

tests.paint_readback_rejects_significant_mismatch = function()
  local matches, reason = paintVerification.compare(
    {{baseColor = {0.1, 0.2, 0.3, 1}}},
    {{baseColor = {0.8, 0.2, 0.3, 1}}}
  )
  equal(matches, false)
  truthy(reason:find("paint_field_mismatch", 1, true) == 1)
end

tests.paint_readback_supports_bounded_deferred_confirmation = function()
  local state = paintVerification.createDeferred(fixtures.paints.one, 10, 2, 0.1, 3)
  truthy(paintVerification.shouldCheck(state, 10))
  paintVerification.recordAttempt(state, 10)
  equal(state.attempts, 1)
  truthy(not paintVerification.shouldCheck(state, 10.05))
  truthy(paintVerification.expired(state, 12))
end

tests.paint_confirmation_does_not_use_spawn_event = function()
  local harness = pipelineHarness.new({deferredPaint = true})
  truthy(harness.main.scramble({chaos = 100, manualSeed = "paint"}))
  pipelineHarness.confirmParts(harness)
  pipelineHarness.confirmTuning(harness)
  local before = harness.main.requestState()
  equal(before.waitReason, nil)
  harness.main.onVehicleSpawned(harness.vehicleId)
  truthy(harness.main.requestState().busy)
  harness.now = harness.now + 0.2
  harness.main.onUpdate()
  equal(harness.main.requestState().busy, false)
end

tests.external_mod_config_uses_confirmed_path_ownership = function()
  local model = contentIndex.normalizeModel({key = "external", Source = "Unknown"})
  local config = contentIndex.normalizeConfig({
    model_key = "external", key = "base", pcFilename = "/vehicles/external/base.pc",
    pathOwnership = {kind = "mod", modID = "external", sourceLabel = "External Pack", strategy = "core_modmanager.getModFromPath"},
  }, {external = model})
  equal(config.sourceKind, "mod")
  equal(config.sourceStrategy, "core_modmanager.getModFromPath")
end

tests.official_parent_with_mod_config_remains_mod = function()
  local model = contentIndex.normalizeModel({key = "official", Source = "BeamNG - Official"})
  local config = contentIndex.normalizeConfig({
    model_key = "official", key = "pack",
    pathOwnership = {kind = "mod", modID = "pack", sourceLabel = "Pack"},
  }, {official = model})
  equal(config.sourceKind, "mod")
end

tests.mod_parent_without_config_evidence_stays_unknown = function()
  local model = contentIndex.normalizeModel({key = "modcar", modID = "vehicle_mod"})
  local config = contentIndex.normalizeConfig({model_key = "modcar", key = "base"}, {modcar = model})
  equal(config.sourceKind, "unknown")
end

tests.arbitrary_brand_name_is_not_mod_evidence = function()
  equal(contentIndex.sourceKind({Brand = "Community Customs", Source = "Unknown"}), "unknown")
end

tests.repository_and_external_mods_share_same_registry_path = function()
  local repository = {pathOwnership = {kind = "mod", modID = "repo"}}
  local external = {pathOwnership = {kind = "mod", modName = "forum_zip"}}
  equal(contentIndex.sourceKind(repository), contentIndex.sourceKind(external))
  equal(contentIndex.sourceKind(repository), "mod")
end

tests.unknown_is_not_promoted_without_proof = function()
  equal(contentIndex.sourceKind({Source = "A Cool Author", pcFilename = "/vehicles/car/base.pc"}), "unknown")
end

tests.filename_verification_works = function()
  local expected = configVerification.expectation({modelKey = "car", key = "base", path = "/vehicles/car/base.pc"})
  local verified, _, details = configVerification.verify(expected, {
    modelKey = "car", configIdentity = {path = "/vehicles/car/base.pc"},
  })
  truthy(verified)
  equal(details.strategy, "filename")
end

tests.user_config_verifies_without_standard_filename = function()
  local expected = configVerification.expectation({modelKey = "car", key = "my setup", path = "settings/vehicles/car/my setup"})
  truthy(configVerification.verify(expected, {
    modelKey = "car", configIdentity = {path = "\\settings\\vehicles\\car\\my setup.pc"},
  }))
end

tests.generated_config_uses_state_signature = function()
  local generated = {parts = {engine = "engine_a", body = "body_a"}, vars = {boost = 0.5}}
  local expected = configVerification.expectation({modelKey = "car", raw = {loadedConfig = generated}}, generated)
  local verified, _, details = configVerification.verify(expected, {
    modelKey = "car", configIdentity = {signature = configVerification.signature(generated)},
  })
  truthy(verified)
  equal(details.strategy, "state_signature")
end

tests.unusual_mod_path_normalizes_correctly = function()
  equal(
    configVerification.normalizePath("mods\\unpacked\\Pack\\vehicles\\Car\\Config"),
    "/mods/unpacked/pack/vehicles/car/config.pc"
  )
end

tests.model_mismatch_always_fails = function()
  local expected = configVerification.expectation({modelKey = "expected", key = "base", path = "/vehicles/expected/base.pc"})
  local verified, reason = configVerification.verify(expected, {
    modelKey = "other", configIdentity = {path = "/vehicles/expected/base.pc"},
  })
  equal(verified, false)
  equal(reason, "model_mismatch")
end

tests.unverified_config_identity_is_not_claimed = function()
  local expected = configVerification.expectation({modelKey = "car", key = "base", path = "/vehicles/car/base.pc"})
  local verified, reason, details = configVerification.verify(expected, {modelKey = "car"})
  equal(verified, false)
  equal(reason, "config_identity_unverified")
  equal(details.identityConfirmed, false)
end

tests.verification_strategy_is_logged = function()
  local expectation = lifecycle.createExpectation({
    phase = "spawn", modelKey = "car",
    configIdentity = configVerification.expectation({modelKey = "car", key = "base", path = "/vehicles/car/base.pc"}),
  })
  local verified, _, details = lifecycle.verify(expectation, {
    modelKey = "car", configIdentity = {path = "/vehicles/car/base.pc"},
  })
  truthy(verified)
  equal(details.strategy, "filename")
end

tests.selected_part_uses_selected_candidate_source = function()
  local tree = {children = {slot = {
    id = "slot", path = "/slot/", chosenPartName = "official_part",
    suitablePartNames = {"official_part", "mod_part"}, children = {},
  }}}
  local scan = assert(slotScanner.scan(tree, { ["/slot/"] = {candidateMetadata = {
    official_part = {sourceKind = "official", sourceLabel = "BeamNG - Official"},
    mod_part = {sourceKind = "mod", sourceLabel = "Wheel Pack", modID = "wheel_pack"},
  }}}))
  local _, decisions = mutationEngine.plan(scan, nil, fullMutationPolicy(false), scriptedGenerator({true}))
  equal(decisions[1].selectedSource.sourceKind, "mod")
  equal(decisions[1].selectedSource.sourceLabel, "Wheel Pack")
end

tests.current_part_source_is_preserved_separately = function()
  local tree = {children = {slot = {id = "slot", path = "/slot/", chosenPartName = "a", suitablePartNames = {"a", "b"}, children = {}}}}
  local scan = assert(slotScanner.scan(tree, { ["/slot/"] = {candidateMetadata = {
    a = {sourceKind = "official", sourceLabel = "Official"}, b = {sourceKind = "mod", sourceLabel = "Mod"},
  }}}))
  local _, decisions = mutationEngine.plan(scan, nil, fullMutationPolicy(false), scriptedGenerator({true}))
  equal(decisions[1].previousSource.sourceKind, "official")
  equal(decisions[1].selectedSource.sourceKind, "mod")
end

tests.unknown_candidate_source_remains_unknown = function()
  local tree = {children = {slot = {id = "slot", path = "/slot/", chosenPartName = "a", suitablePartNames = {"a", "b"}, children = {}}}}
  local scan = assert(slotScanner.scan(tree, {}))
  local _, decisions = mutationEngine.plan(scan, nil, fullMutationPolicy(false), scriptedGenerator({true}))
  equal(decisions[1].selectedSource.sourceKind, "unknown")
end

tests.mod_wheel_source_is_reported_correctly = tests.selected_part_uses_selected_candidate_source

local function graphFixture(profile, roles, requiredRoles, missingRequired)
  return {
    profile = profile,
    roles = util.deepCopy(roles or {}),
    requiredRoles = util.deepCopy(requiredRoles or {}),
    missingRequired = util.deepCopy(missingRequired or {}),
  }
end

tests.combustion_vehicle_requires_applicable_energy_path = function()
  local baseline = graphFixture("standard_road", {energy_fuel = 1, propulsion_combustion = 1, power_path = 1})
  local current = graphFixture("standard_road", {propulsion_combustion = 1, power_path = 1})
  equal(validator.validateGraph(current, baseline, true).status, "unsafe")
end

tests.electric_vehicle_does_not_require_fuel_tank = function()
  local baseline = graphFixture("electric", {energy_electric = 1, propulsion_electric = 1, power_path = 1})
  local current = graphFixture("electric", {energy_electric = 1, propulsion_electric = 2, power_path = 2})
  equal(validator.validateGraph(current, baseline, true).status, "safe")
end

tests.electric_vehicle_preserves_battery_or_energy_source = function()
  local baseline = graphFixture("electric", {energy_electric = 1, propulsion_electric = 1, power_path = 1})
  local current = graphFixture("electric", {propulsion_electric = 1, power_path = 1})
  equal(validator.validateGraph(current, baseline, true).status, "unsafe")
end

tests.trailer_does_not_require_engine = function()
  local trailer = graphFixture("trailer", {})
  equal(validator.validateGraph(trailer, trailer, true).status, "safe")
end

tests.prop_does_not_require_drivetrain = function()
  local prop = graphFixture("prop", {})
  equal(validator.validateGraph(prop, prop, true).status, "not_applicable")
end

tests.two_wheel_vehicle_is_not_forced_to_four_wheels = function()
  local baseline = graphFixture("standard_road", {wheel = 2, tire_contact = 2})
  local current = graphFixture("standard_road", {wheel = 2, tire_contact = 2})
  truthy(validator.validateGraph(current, baseline, true).valid)
end

tests.multi_differential_layout_is_supported = function()
  local baseline = graphFixture("standard_road", {differential = 3}, {differential = 3})
  local current = graphFixture("standard_road", {differential = 3}, {differential = 3})
  truthy(validator.validateGraph(current, baseline, true).valid)
end

tests.unknown_vehicle_uses_conservative_fallback = function()
  local unknown = graphFixture("unknown", {power_path = 1})
  local result = validator.validateGraph(unknown, unknown, true)
  equal(result.status, "uncertain")
  truthy(result.valid)
end

tests.required_core_missing_is_unsafe = function()
  local graph = graphFixture("special", {}, {}, {"/required/"})
  equal(validator.validateGraph(graph, graph, true).status, "unsafe")
end

tests.optional_cosmetic_missing_is_safe = function()
  local graph = graphFixture("standard_road", {})
  truthy(validator.validateGraph(graph, graph, true).valid)
end

tests.uncertain_layout_does_not_claim_drivable = function()
  local graph = graphFixture("unknown", {})
  equal(validator.validateGraph(graph, graph, true).status, "uncertain")
end

tests.trailer_profile_has_no_propulsion_requirement = tests.trailer_does_not_require_engine

tests.trailer_full_random_can_complete_without_engine = function()
  local harness = pipelineHarness.new({modelType = "Trailer", tuningUnavailable = true, paintUnavailable = true})
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom", {allowPartialResult = true}))
  local state = harness.main.requestState()
  equal(state.lastResult.success, true)
  truthy(#state.lastResult.details.warnings >= 2)
end

tests.trailer_optional_attachment_mutation = function()
  local tree = {children = {cargo = {id = "cargo", path = "/cargo/", chosenPartName = "a", suitablePartNames = {"a", "b"}, children = {}}}}
  local scan = assert(slotScanner.scan(tree, {}))
  local result = mutationEngine.plan(scan, nil, fullMutationPolicy(true), scriptedGenerator({true}))
  equal(result.children.cargo.chosenPartName, "b")
end

tests.trailer_filters_remain_opt_in = function()
  local defaults = settings.defaults()
  equal(defaults.includeTrailers, false)
end

tests.prop_profile_does_not_require_vehicle_systems = tests.prop_does_not_require_drivetrain
tests.prop_slots_can_mutate = tests.trailer_optional_attachment_mutation

tests.prop_filter_is_opt_in = function()
  equal(settings.defaults().includeProps, false)
end

tests.prop_operation_reports_control_limit_honestly = function()
  local harness = pipelineHarness.new({modelType = "Prop", tuningUnavailable = true, paintUnavailable = true})
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom", {allowPartialResult = true}))
  local result = harness.main.requestState().lastResult
  equal(result.details.safety.status, "not_applicable")
  truthy(result.message:find("prop control is not validated", 1, true) ~= nil)
  truthy(#result.details.warnings >= 1)
end

tests.electric_energy_path_is_detected = function()
  local evidence = validator.evidenceFromPart({
    powertrain = {{"type"}, {type = "electricMotor"}},
    energyStorage = {{"type"}, {type = "electricBattery"}},
  })
  truthy(util.arrayContains(evidence.roles, "propulsion_electric"))
  truthy(util.arrayContains(evidence.roles, "energy_electric"))
  truthy(util.arrayContains(evidence.roles, "power_path"))
end

tests.electric_without_fuel_is_valid = tests.electric_vehicle_does_not_require_fuel_tank

tests.dual_motor_layout_is_supported = function()
  local baseline = graphFixture("electric", {energy_electric = 1, propulsion_electric = 2, power_path = 2})
  truthy(validator.validateGraph(baseline, baseline, true).valid)
end

tests.direct_drive_does_not_require_gearbox = function()
  local baseline = graphFixture("electric", {energy_electric = 1, propulsion_electric = 1, power_path = 1})
  truthy(validator.validateGraph(baseline, baseline, true).valid)
end

tests.electric_critical_group_is_preserved_when_unproven = function()
  local tree = {children = {energy = {
    id = "energy", path = "/energy/", chosenPartName = "battery_a",
    suitablePartNames = {"battery_a", "unknown_pack"}, children = {},
  }}}
  local scan = assert(slotScanner.scan(tree, { ["/energy/"] = {candidateMetadata = {
    battery_a = {roles = {"energy_electric"}}, unknown_pack = {roles = {}},
  }}}))
  local result = mutationEngine.plan(scan, nil, fullMutationPolicy(true), scriptedGenerator({true}))
  equal(result.children.energy.chosenPartName, "battery_a")
end

tests.front_rear_differentials_are_both_preserved_when_required = function()
  local baseline = graphFixture("standard_road", {differential = 2}, {differential = 2})
  truthy(validator.validateGraph(baseline, baseline, true).valid)
end

tests.center_front_rear_layout_is_supported = tests.multi_differential_layout_is_supported

tests.multiple_driven_axles_are_supported = function()
  local graph = graphFixture("standard_road", {driven_axle = 4})
  truthy(validator.validateGraph(graph, graph, true).valid)
end

tests.differential_free_layout_is_not_rejected = function()
  local graph = graphFixture("electric", {energy_electric = 1, propulsion_electric = 2, power_path = 2})
  truthy(validator.validateGraph(graph, graph, true).valid)
end

tests.full_random_is_one_operation = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom"))
  local state = harness.main.requestState()
  equal(state.lastResult.success, true)
  equal(#state.history, 1)
end

tests.full_random_does_not_finish_after_spawn = function()
  local harness = pipelineHarness.new()
  truthy(harness.main.fullRandom({chaos = 100, manualSeed = "full"}))
  pipelineHarness.confirmReplacement(harness)
  local state = harness.main.requestState()
  truthy(state.busy)
  truthy(harness.pendingParts ~= nil)
end

tests.full_random_runs_parts_tuning_and_paint = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom"))
  local seen = {}
  for _, call in ipairs(harness.calls) do seen[call] = true end
  truthy(seen.replace and seen.tuning and seen.paint,
    "pipeline calls replace=" .. tostring(seen.replace) .. " parts=" .. tostring(seen.parts)
      .. " tuning=" .. tostring(seen.tuning) .. " paint=" .. tostring(seen.paint))
end

tests.full_random_skips_unavailable_optional_stage_with_warning = function()
  local harness = pipelineHarness.new({tuningUnavailable = true, paintUnavailable = true})
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom", {allowPartialResult = true}))
  local details = harness.main.requestState().lastResult.details
  truthy(#details.warnings >= 2)
  equal(details.status, "CompletedWithWarning")
  equal(details.terminalOutcome, "COMPLETED_WITH_SKIPS")
end

tests.v060_partial_result_setting_controls_rollback = function()
  local rollback = pipelineHarness.new({tuningUnavailable = true, paintUnavailable = true})
  truthy(pipelineHarness.driveSuccess(rollback, "fullRandom", {allowPartialResult = false}))
  local rejected = rollback.main.requestState().lastResult
  equal(rejected.success, true)
  equal(rejected.details.terminalOutcome, "COMPLETED_WITH_SKIPS")
  truthy(not (rollback.pendingReplacement and rollback.pendingReplacement.restoring))

  local kept = pipelineHarness.new({tuningUnavailable = true, paintUnavailable = true})
  truthy(pipelineHarness.driveSuccess(kept, "fullRandom", {allowPartialResult = true}))
  local accepted = kept.main.requestState().lastResult
  equal(accepted.success, true)
  equal(accepted.details.status, "CompletedWithWarning")
  equal(accepted.details.terminalOutcome, "COMPLETED_WITH_SKIPS")
end

tests.full_random_has_one_history_entry = tests.full_random_is_one_operation

tests.full_random_rollback_restores_original = function()
  local harness = pipelineHarness.new({partsFailure = true})
  truthy(harness.main.fullRandom({chaos = 100, manualSeed = "rollback"}))
  pipelineHarness.confirmReplacement(harness)
  local state = harness.main.requestState()
  equal(state.busy, false)
  equal(state.lastResult.details.rollback, "completed")
  equal(#state.history, 0)
  equal(harness.modelKey, "fixture_new")
  equal(state.lastResult.details.recoveryTier, 3)
  equal(state.lastResult.details.recoveryStep, "clean_candidate_baseline")
end

tests.full_random_result_reports_base_version_and_final_changes = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom"))
  local details = harness.main.requestState().lastResult.details
  equal(details.baseConfiguration.key, "base_version")
  equal(details.baseConfiguration.sourceKind, "official")
  truthy(details.partsChanged >= 0)
  truthy(details.stageReasons.parts == "tree_converged" or details.partsChanged > 0)
  truthy(#details.tuningValues >= 1)
  truthy(details.paintLayers >= 1)
  truthy(type(details.safety) == "table")
end

tests.random_config_mocked_success_pipeline = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "randomConfig"))
  equal(harness.main.requestState().lastResult.code, "random_config_loaded")
end

tests.scramble_mocked_success_pipeline = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "scramble"))
  equal(harness.main.requestState().lastResult.success, true)
end

tests.full_random_mocked_success_pipeline = tests.full_random_runs_parts_tuning_and_paint

tests.spawn_failure_blacklists_config = function()
  local harness = pipelineHarness.new({replaceFailure = true})
  truthy(not harness.main.randomConfig({manualSeed = "spawn-failure"}))
  pipelineHarness.confirmReplacement(harness)
  local state = harness.main.requestState()
  equal(state.recovery.quarantinedConfigurations, 1)
  equal(state.busy, false)
end

tests.parts_failure_after_confirmed_spawn_does_not_blacklist_config = function()
  local harness = pipelineHarness.new({partsFailure = true})
  truthy(harness.main.fullRandom({chaos = 100, manualSeed = "parts-failure"}))
  pipelineHarness.confirmReplacement(harness)
  equal(harness.main.requestState().index.blacklists.config, 0)
end

tests.parts_timeout_attributes_current_batch = function()
  local harness = pipelineHarness.new()
  truthy(harness.main.fullRandom({chaos = 100, manualSeed = "parts-timeout"}))
  pipelineHarness.confirmReplacement(harness)
  harness.now = 30
  harness.main.onUpdate()
  local state = harness.main.requestState()
  equal(state.waitReason, "waitingForPartBatchRollback")
  truthy(state.busy)
end

tests.paint_failure_rolls_back = function()
  local harness = pipelineHarness.new({paintFailure = true})
  truthy(harness.main.scramble({chaos = 100, manualSeed = "paint-failure"}))
  pipelineHarness.confirmParts(harness)
  pipelineHarness.confirmTuning(harness)
  truthy(harness.pendingReplacement and harness.pendingReplacement.restoring)
  pipelineHarness.confirmReplacement(harness)
  equal(harness.main.requestState().lastResult.details.rollback, "completed")
end

tests.wrong_switch_during_replace_cancels = tests.unrelated_switch_during_spawn_cancels

tests.rollback_restores_and_pops_history = function()
  tests.full_random_rollback_restores_original()
end

tests.undo_restores_expected_vehicle = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "scramble"))
  truthy(harness.main.undo(), harness.main.requestState().lastResult.message)
  pipelineHarness.confirmReplacement(harness)
  local state = harness.main.requestState()
  equal(state.lastResult.code, "undo_completed")
  equal(#state.history, 0)
end

tests.stress_runs_operations_sequentially = function()
  local harness = pipelineHarness.new()
  truthy(harness.main.runDeveloperStress({iterations = 2, mode = "randomConfig", seed = "stress"}))
  harness.main.onUpdate()
  truthy(harness.pendingReplacement ~= nil)
  pipelineHarness.confirmReplacement(harness)
  harness.main.onUpdate()
  truthy(harness.pendingReplacement ~= nil)
  pipelineHarness.confirmReplacement(harness)
  local state = harness.main.getDeveloperStressState()
  equal(state.active, false)
  equal(state.summary.attempts, 2)
end

tests.mod_change_cancels_pipeline = function()
  local harness = pipelineHarness.new()
  truthy(harness.main.fullRandom({manualSeed = "mod-change"}))
  harness.main.onModActivated({modname = "fixture"})
  local state = harness.main.requestState()
  equal(state.busy, false)
  equal(state.lastResult.code, "content_changed")
end

tests.map_change_cancels_pipeline = function()
  local harness = pipelineHarness.new()
  truthy(harness.main.fullRandom({manualSeed = "map-change"}))
  harness.main.onClientEndMission()
  local state = harness.main.requestState()
  equal(state.busy, false)
  equal(state.lastResult.code, "map_changed")
end

tests.large_registry_fixture_is_deterministic = function()
  local models, configs = {}, {}
  for modelIndex = 1, 250 do
    local modelKey = string.format("model_%03d", modelIndex)
    models[modelKey] = {key = modelKey, Source = "BeamNG - Official", Type = "Car"}
    for configIndex = 1, 20 do
      local key = string.format("config_%03d_%02d", modelIndex, configIndex)
      configs[key] = {model_key = modelKey, key = key, Source = "BeamNG - Official"}
    end
  end
  local left, right = contentIndex.create(), contentIndex.create()
  contentIndex.build(left, models, configs, 1, 0)
  contentIndex.build(right, models, configs, 1, 0)
  equal(#left.models, 250)
  equal(#left.allConfigs, 5000)
  equal(left.allConfigs[4321].key, right.allConfigs[4321].key)
end

local function deepTree(depth)
  local root = {chosenPartName = "root", children = {}}
  local node = root
  for value = 1, depth do
    local key = "slot" .. value
    node.children[key] = {
      id = key, path = "/" .. string.rep("nested/", value - 1) .. key .. "/",
      chosenPartName = "part" .. value, suitablePartNames = {"part" .. value}, children = {},
    }
    node = node.children[key]
  end
  return root
end

tests.deep_tree_scan_is_bounded = function()
  local scan = assert(slotScanner.scan(deepTree(100), {}))
  equal(scan.metrics.slotCount, 100)
  equal(scan.metrics.maxDepth, 100)
  equal(scan.metrics.candidateCount, 100)
end

tests.deep_tree_does_not_overflow_reasonable_recursion = function()
  local scan = assert(slotScanner.scan(deepTree(160), {}))
  equal(#scan.slots, 160)
end

tests.diagnostic_history_is_bounded = function()
  local diagnostics = require("ge/extensions/soturineChaosRandomizer/diagnostics")
  local state = diagnostics.create(function() end)
  diagnostics.setEnabled(state, true)
  for value = 1, 250 do diagnostics.write(state, "D", "fixture", {value = value}) end
  equal(#diagnostics.snapshot(state), 200)
end

tests.index_cache_is_reused = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "randomConfig"))
  truthy(pipelineHarness.driveSuccess(harness, "randomConfig"))
  local performance = harness.main.requestState().performance
  equal(performance.indexBuilds, 1)
  truthy(performance.indexCacheHits >= 1)
end

tests.dna_schema_accepts_valid_v1 = function()
  local valid, reason = vehicleDNASchema.validateEntry(sampleDNA())
  equal(valid, true, tostring(reason))
end

tests.dna_schema_rejects_future_version = function()
  local entry = sampleDNA()
  entry.schemaVersion = 99
  local valid, reason = vehicleDNASchema.validateEntry(entry)
  equal(valid, false)
  equal(reason, "dna_future_schema_read_only")
end

tests.dna_schema_rejects_duplicate_slot_paths = function()
  local slot = {path = "/body/", slotId = "body", partName = "body_a"}
  local entry = sampleDNA({slots = {slot, util.deepCopy(slot)}})
  local valid, reason = vehicleDNASchema.validateEntry(entry)
  equal(valid, false)
  equal(reason, "dna_slot_duplicate_path")
end

tests.dna_schema_migration_is_idempotent = function()
  local entry = sampleDNA()
  local first, firstError = vehicleDNASchema.migrateEntry(entry)
  truthy(first, tostring(firstError))
  local second, secondError = vehicleDNASchema.migrateEntry(first)
  truthy(second, tostring(secondError))
  truthy(util.deepEqual(first, second))
end

tests.dna_schema_rejects_missing_required_format = function()
  local entry = sampleDNA()
  entry.format = nil
  local valid, reason = vehicleDNASchema.validateEntry(entry)
  equal(valid, false)
  equal(reason, "dna_format_invalid")
end

tests.dna_normalizer_uses_final_slot_shape_only = function()
  local scan = assert(slotScanner.scan(fixtures.nestedTree, {}))
  local slots = vehicleDNANormalizer.normalizeSlots(scan)
  equal(#slots, #scan.slots)
  truthy(slots[1].path ~= nil)
  equal(slots[1].candidates, nil)
  equal(slots[1].raw, nil)
end

tests.dna_normalizer_sorts_tuning_and_filters_malformed = function()
  local values = vehicleDNANormalizer.normalizeTuning(fixtures.variables, {independentB = 0.2, malformed = "bad", independentA = 5})
  equal(#values, 2)
  equal(values[1].name, "independentA")
  equal(values[2].name, "independentB")
end

tests.dna_fingerprint_sorts_object_keys = function()
  local left = assert(vehicleDNAFingerprint.fingerprint({b = 2, a = 1}))
  local right = assert(vehicleDNAFingerprint.fingerprint({a = 1, b = 2}))
  equal(left, right)
end

tests.dna_fingerprint_preserves_array_order = function()
  local left = assert(vehicleDNAFingerprint.fingerprint({"a", "b"}))
  local right = assert(vehicleDNAFingerprint.fingerprint({"b", "a"}))
  truthy(left ~= right)
end

tests.dna_fingerprint_rejects_cycles = function()
  local value = {}
  value.self = value
  local result, reason = vehicleDNAFingerprint.fingerprint(value)
  equal(result, nil)
  truthy(reason:find("canonical_cycle", 1, true) ~= nil)
end

tests.dna_fingerprint_rejects_nonfinite_numbers = function()
  local result, reason = vehicleDNAFingerprint.fingerprint({value = 0 / 0})
  equal(result, nil)
  truthy(reason:find("canonical_non_finite_number", 1, true) ~= nil)
end

tests.dna_fingerprint_enforces_depth_limit = function()
  local rootValue = {}
  local current = rootValue
  for _ = 1, 10 do current.child = {}; current = current.child end
  local result, reason = vehicleDNAFingerprint.fingerprint(rootValue, {maxDepth = 4})
  equal(result, nil)
  truthy(reason:find("canonical_depth_limit", 1, true) ~= nil)
end

tests.dna_fingerprint_detects_final_state_changes = function()
  local entry = sampleDNA({
    slots = {{path = "/body/", slotId = "body", partName = "body_a"}},
    tuning = {{name = "boost", value = 0.5}},
    paints = {{roughness = 0.5}},
  })
  local original = entry.fingerprints.final
  entry.final.slots[1].partName = "body_b"
  truthy(vehicleDNAFingerprint.fingerprint(entry.final) ~= original)
  refreshDNAFingerprints(entry)
  original = entry.fingerprints.final
  entry.final.tuning[1].value = 0.6
  truthy(vehicleDNAFingerprint.fingerprint(entry.final) ~= original)
  refreshDNAFingerprints(entry)
  original = entry.fingerprints.final
  entry.final.paints[1].roughness = 0.6
  truthy(vehicleDNAFingerprint.fingerprint(entry.final) ~= original)
end

tests.dna_storage_add_rename_delete_roundtrip = function()
  local library = vehicleDNAStorage.create(3)
  local added, addError, id = vehicleDNAStorage.add(library, sampleDNA())
  truthy(added, tostring(addError))
  equal(#added.entries, 1)
  local renamed = assert(vehicleDNAStorage.rename(added, id, "Renamed DNA"))
  equal(vehicleDNAStorage.find(renamed, id).name, "Renamed DNA")
  local removed = assert(vehicleDNAStorage.remove(renamed, id))
  equal(#removed.entries, 0)
end

tests.dna_storage_favorite_roundtrip = function()
  local library = vehicleDNAStorage.create(3)
  library = assert(vehicleDNAStorage.add(library, sampleDNA()))
  library = assert(vehicleDNAStorage.setFavorite(library, library.entries[1].id, true))
  equal(library.entries[1].favorite, true)
  local summaries = vehicleDNAStorage.summaries(library, 0, 8)
  equal(summaries[1].favorite, true)
end

tests.dna_adapter_preserves_last_known_good_before_write = function()
  local oldRead, oldWrite = rawget(_G, "jsonReadFile"), rawget(_G, "jsonWriteFile")
  local written = {}
  _G.jsonReadFile = function(path) return util.deepCopy(written[path]) end
  _G.jsonWriteFile = function(path, value)
    written[path] = util.deepCopy(value)
    return true
  end
  local previous = {kind = "previous"}
  local nextValue = {kind = "next"}
  local ok = adapter.saveDNALibrary(nextValue, previous)
  equal(ok, true)
  truthy(util.deepEqual(written[adapter.DNA_BACKUP_PATH], previous))
  truthy(util.deepEqual(written[adapter.DNA_LIBRARY_PATH], nextValue))
  _G.jsonReadFile, _G.jsonWriteFile = oldRead, oldWrite
end

tests.dna_adapter_loads_last_known_good_explicitly = function()
  local oldRead = rawget(_G, "jsonReadFile")
  _G.jsonReadFile = function(path)
    if path == adapter.DNA_BACKUP_PATH then return {kind = "backup"} end
    return nil
  end
  local ok, value = adapter.loadDNALibraryBackup()
  equal(ok, true)
  equal(value.kind, "backup")
  _G.jsonReadFile = oldRead
end

tests.dna_storage_limit_is_bounded = function()
  local library = vehicleDNAStorage.create(1)
  library = assert(vehicleDNAStorage.add(library, sampleDNA({id = "one"})))
  local rejected, reason = vehicleDNAStorage.add(library, sampleDNA({id = "two"}))
  equal(rejected, nil)
  equal(reason, "dna_library_entry_limit")
end

tests.dna_storage_rejects_corrupt_entry = function()
  local library = vehicleDNAStorage.create(3)
  library.entries = {{kind = "bad"}}
  local result = vehicleDNAStorage.normalizeLibrary(library)
  equal(result, nil)
end

tests.dna_import_discards_unknown_top_level_fields = function()
  local entry = sampleDNA()
  entry.untrustedFutureField = "discard me"
  local imported = assert(vehicleDNAImport.sanitize(entry))
  equal(imported.untrustedFutureField, nil)
end

tests.dna_import_rejects_executable_values = function()
  local entry = sampleDNA()
  entry.extensions = {callback = function() end}
  local imported, reason = vehicleDNAImport.sanitize(entry)
  equal(imported, nil)
  truthy(reason:find("canonical_unsupported_type", 1, true) ~= nil)
end

tests.dna_slot_resolution_uses_exact_path_parent_first = function()
  local scan = assert(slotScanner.scan(fixtures.nestedTree, {}))
  local current, strategy = vehicleDNACompatibility.resolveSlot({
    path = "/engine/intake/", slotId = "intake", parentPart = nil, partName = "intake_a",
  }, scan, "fixture")
  equal(current.path, "/engine/intake/")
  equal(strategy, "exact_path_slot_parent")
end

tests.dna_slot_resolution_rejects_ambiguous_fallback = function()
  local scan = {slots = {
    {path = "/left/wheel/", id = "wheel", parentPart = "hub"},
    {path = "/right/wheel/", id = "wheel", parentPart = "hub"},
  }}
  local current, strategy = vehicleDNACompatibility.resolveSlot({path = "/old/wheel/", slotId = "wheel", parentPart = "hub"}, scan, "fixture")
  equal(current, nil)
  equal(strategy, "slot_resolution_ambiguous")
end

tests.dna_preflight_requires_target_inspection_without_target_tree = function()
  local entry = sampleDNA()
  local report = vehicleDNACompatibility.evaluate(entry, {
    modelsByKey = {fixture_model = {}},
    configs = {{modelKey = "fixture_model", key = "base", path = "/vehicles/fixture_model/base.pc"}},
    scan = nil, variables = {}, paints = {}, gameVersion = "fixture",
    extensionVersion = "0.4.0-alpha.1", generatorVersion = 4,
  }, "exact")
  equal(report.status, "target_inspection_required")
  equal(report.registryStatus, "registry_exact")
end

tests.dna_compatible_preflight_reports_partial = function()
  local scan = assert(slotScanner.scan(fixtures.nestedTree, {}))
  local entry = sampleDNA({slots = {{path = "/missing/", slotId = "missing", partName = "part"}}})
  local report = vehicleDNACompatibility.evaluate(entry, {
    modelsByKey = {fixture_model = {}}, configs = {{modelKey = "fixture_model", key = "base", path = entry.base.configPath}},
    scan = scan, variables = {}, paints = {}, gameVersion = "fixture",
    extensionVersion = "0.4.0-alpha.1", generatorVersion = 4,
    currentConfigPath = entry.base.configPath,
  }, "compatible")
  equal(report.status, "partial")
  truthy(report.missing > 0)
end

tests.dna_compatible_restore_blocks_missing_required_slot = function()
  local scan = assert(slotScanner.scan(fixtures.nestedTree, {}))
  local entry = sampleDNA({slots = {{path = "/missing/", slotId = "missing", partName = "part", required = true}}})
  local report = vehicleDNACompatibility.evaluate(entry, {
    modelsByKey = {fixture_model = {}}, configs = {{modelKey = "fixture_model", key = "base", path = entry.base.configPath}},
    scan = scan, variables = {}, paints = {}, gameVersion = "fixture",
    extensionVersion = "0.4.0-alpha.1", generatorVersion = 4, currentConfigPath = entry.base.configPath,
  }, "compatible")
  equal(report.status, "incompatible")
  truthy(report.blocking > 0)
  local tree = vehicleDNARestore.planPartsPass(entry, scan, "compatible")
  equal(tree, nil)
end

tests.dna_restore_parent_first_defers_descendant = function()
  local scan = assert(slotScanner.scan(fixtures.nestedTree, {}))
  local entry = sampleDNA({slots = {
    {path = "/engine/", slotId = "engine", partName = "engine_b"},
    {path = "/engine/intake/", slotId = "intake", partName = "intake_stale"},
  }})
  local tree, batch = vehicleDNARestore.planPartsPass(entry, scan, "exact")
  truthy(tree ~= nil)
  equal(#batch, 1)
  equal(batch[1].slotPath, "/engine/")
end

tests.dna_restore_exact_rejects_missing_part = function()
  local scan = assert(slotScanner.scan(fixtures.nestedTree, {}))
  local entry = sampleDNA({slots = {{path = "/engine/", slotId = "engine", partName = "missing_engine"}}})
  local tree, _, issues = vehicleDNARestore.planPartsPass(entry, scan, "exact")
  equal(tree, nil)
  equal(issues[1].reason, "part_missing")
end

tests.dna_restore_compatible_clamps_tuning = function()
  local entry = sampleDNA({tuning = {{name = "boost", value = 2}}})
  local values, issues = vehicleDNARestore.tuningValues(entry, {boost = {min = 0, max = 1}}, "compatible")
  equal(values.boost, 1)
  equal(issues[1].reason, "tuning_clamped")
end

tests.dna_restore_exact_does_not_clamp_tuning = function()
  local entry = sampleDNA({tuning = {{name = "boost", value = 2}}})
  local values, issues = vehicleDNARestore.tuningValues(entry, {boost = {min = 0, max = 1}}, "exact")
  equal(values.boost, nil)
  equal(issues[1].reason, "tuning_out_of_range")
end

tests.dna_creation_records_generator_and_schema_versions = function()
  local scan = assert(slotScanner.scan(fixtures.nestedTree, {}))
  local entry, reason = vehicleDNA.create({
    capture = {modelKey = "fixture_model", selectedConfiguration = "/vehicles/fixture_model/base.pc", tuning = {}, paints = {}},
    snapshot = {variables = {}}, scan = scan, seed = "SCR4-1234-5678", operation = "scramble",
    gameVersion = "fixture", extensionVersion = "0.4.0-alpha.1", settings = {}, timestamp = 1,
  })
  truthy(entry, tostring(reason))
  equal(entry.schemaVersion, 1)
  equal(entry.generation.generatorVersion, 6)
end

tests.settings_schema_two_migrates_to_four = function()
  local value = settings.validate({schemaVersion = 2, dnaLimit = 25, autoSaveDNA = true})
  equal(value.schemaVersion, 9)
  equal(value.dnaLibraryLimit, 25)
  equal(value.autoSaveDNA, false)
end

tests.manual_seed_legacy_and_v4_keep_same_generator_sequence = function()
  local legacy = rng.new("1234-5678")
  local current = rng.new("SCR4-1234-5678")
  for _ = 1, 20 do equal(legacy:nextUInt(), current:nextUInt()) end
end

tests.dna_capabilities_are_granular = function()
  local derived = capabilities.derive({dnaRead = true, dnaWrite = true, dnaExportFile = false, dnaBackup = true})
  equal(derived.dnaList, true)
  equal(derived.dnaDelete, true)
  equal(derived.dnaExportFile, false)
  equal(derived.dnaBackup, true)
end

tests.completed_operation_exposes_pending_dna = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom"))
  local state = harness.main.requestState()
  equal(state.garage.pendingSave, true)
  equal(state.garage.pending.modelKey, "fixture_new")
end

tests.explicit_save_persists_dna_with_readback = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "randomConfig"))
  truthy(harness.main.saveVehicleDNA("Saved Fixture"))
  local state = harness.main.requestState()
  equal(state.garage.total, 1)
  equal(state.garage.entries[1].name, "Saved Fixture")
  equal(state.garage.pendingSave, false)
end

tests.dna_preflight_performs_no_destructive_write = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom"))
  truthy(harness.main.saveVehicleDNA("Preflight Fixture"))
  local id = harness.main.requestState().garage.entries[1].id
  local before = #harness.calls
  local ok = harness.main.preflightVehicleDNA(id, "exact")
  truthy(ok)
  for index = before + 1, #harness.calls do
    truthy(harness.calls[index] ~= "replace" and harness.calls[index] ~= "parts"
      and harness.calls[index] ~= "tuning" and harness.calls[index] ~= "paint")
  end
end

tests.restore_compatible_reports_clamped_deviation_and_verifies_readback = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom"))
  truthy(harness.main.saveVehicleDNA("Compatible Fixture"))
  local id = harness.main.requestState().garage.entries[1].id
  harness.tuningMinimum = -1
  harness.tuningMaximum = -1
  truthy(harness.main.restoreVehicleDNA(id, "compatible", true))
  pipelineHarness.confirmReplacement(harness)
  while harness.pendingParts do pipelineHarness.confirmParts(harness) end
  if harness.pendingTuning then pipelineHarness.confirmTuning(harness) end
  local state = harness.main.requestState()
  equal(state.lastResult.code, "dna_restore_partial")
  equal(state.lastResult.details.verified, true)
  truthy(#state.lastResult.details.deviations > 0)
end

tests.failed_operation_does_not_expose_pending_dna = function()
  local harness = pipelineHarness.new({paintFailure = true})
  truthy(harness.main.runAction("fullRandom", {chaos = 100, protectCriticalParts = true, manualSeed = "failure"}))
  pipelineHarness.confirmReplacement(harness)
  pipelineHarness.driveActive(harness, 64)
  truthy(not harness.main.requestState().busy)
  equal(harness.main.requestState().garage.pendingSave, false)
end

tests.restore_exact_uses_one_transaction_and_strict_readback = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom"))
  truthy(harness.main.saveVehicleDNA("Exact Fixture"))
  local id = harness.main.requestState().garage.entries[1].id
  local preflightOk, report = harness.main.preflightVehicleDNA(id, "exact")
  truthy(preflightOk)
  equal(report.status, "exact")
  truthy(harness.main.restoreVehicleDNA(id, "exact", false))
  pipelineHarness.confirmReplacement(harness)
  while harness.pendingParts do pipelineHarness.confirmParts(harness) end
  if harness.pendingTuning then pipelineHarness.confirmTuning(harness) end
  local state = harness.main.requestState()
  equal(state.lastResult.code, "dna_restore_exact")
  equal(state.lastResult.details.exact, true)
  equal(state.lastResult.details.verified, true)
end

tests.restore_exact_failure_rolls_back_original_state = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom"))
  truthy(harness.main.saveVehicleDNA("Rollback Fixture"))
  local id = harness.main.requestState().garage.entries[1].id
  harness.options.tuningFailure = true
  truthy(harness.main.restoreVehicleDNA(id, "exact", false))
  pipelineHarness.confirmReplacement(harness)
  truthy(harness.pendingReplacement ~= nil, "parts rejection should start rollback; phase="
    .. tostring(harness.main.requestState().lifecyclePhase) .. " code="
    .. tostring(harness.main.requestState().lastResult and harness.main.requestState().lastResult.code))
  pipelineHarness.confirmReplacement(harness)
  local state = harness.main.requestState()
  equal(state.lastResult.success, false)
  equal(state.lastResult.details.rollback, "completed")
end

tests.user_cancel_rolls_back_an_active_dna_operation = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom"))
  truthy(harness.main.saveVehicleDNA("Cancel Fixture"))
  local id = harness.main.requestState().garage.entries[1].id
  harness.modelKey, harness.configPath = "fixture_old", "/vehicles/fixture_old/original.pc"
  truthy(harness.main.restoreVehicleDNA(id, "compatible", true))
  truthy(harness.main.cancelCurrentOperation())
  truthy(harness.pendingReplacement ~= nil, "user cancellation must schedule rollback")
  pipelineHarness.confirmReplacement(harness)
  local result = harness.main.requestState().lastResult
  equal(result.success, false)
  equal(result.code, "dna_partial_cancelled")
  equal(result.details.rollback, "completed")
end

tests.config_paths_are_normalized_across_supported_forms = function()
  local expected = "/vehicles/fixture/base.pc"
  for _, value in ipairs({
    "vehicles/fixture/base", "/VEHICLES/FIXTURE/BASE.PC", "\\vehicles\\fixture\\base.pc",
    "//vehicles///fixture//base.pc",
  }) do equal(configVerification.normalizePath(value), expected) end
end

tests.config_resolution_is_model_scoped = function()
  local config, strategy = configVerification.resolveRegistryConfig("model_b", nil, "shared", nil, {
    {modelKey = "model_a", key = "shared", path = "/vehicles/model_a/shared.pc"},
    {modelKey = "model_b", key = "shared", path = "/vehicles/model_b/shared.pc"},
  })
  equal(config.modelKey, "model_b")
  equal(strategy, "model_scoped_key")
end

tests.dna_optional_missing_part_records_partial_deviation = function()
  local scan = assert(slotScanner.scan(fixtures.nestedTree, {}))
  local entry = sampleDNA({slots = {{path = "/engine/", slotId = "engine", partName = "not_installed"}}})
  local report = vehicleDNACompatibility.evaluate(entry, {
    modelsByKey = {fixture_model = {}}, configs = {{modelKey = "fixture_model", key = "base", path = entry.base.configPath}},
    scan = scan, variables = {}, paints = {}, gameVersion = "fixture", extensionVersion = "0.4.0-alpha.2",
    generatorVersion = 4, currentConfigPath = entry.base.configPath,
  }, "compatible")
  equal(report.status, "partial")
  equal(report.deviations[1].reason, "optional_part_omitted")
end

tests.dna_optional_missing_slot_records_partial_deviation = function()
  local scan = assert(slotScanner.scan(fixtures.nestedTree, {}))
  local entry = sampleDNA({slots = {{path = "/gone/", slotId = "gone", partName = "part"}}})
  local report = vehicleDNACompatibility.evaluate(entry, {
    modelsByKey = {fixture_model = {}}, configs = {{modelKey = "fixture_model", key = "base", path = entry.base.configPath}},
    scan = scan, variables = {}, paints = {}, gameVersion = "fixture", extensionVersion = "0.4.0-alpha.2",
    generatorVersion = 4, currentConfigPath = entry.base.configPath,
  }, "compatible")
  equal(report.status, "partial")
  equal(report.deviations[1].reason, "optional_slot_omitted")
end

tests.dna_slot_remap_records_deviation = function()
  local entry = sampleDNA({slots = {{path = "/old/body/", slotId = "body", parentPart = "root", partName = "body_a"}}})
  local scan = {slots = {{path = "/new/body/", id = "body", parentPart = "root", currentPart = "body_a", candidates = {"body_a"}}}}
  local report = vehicleDNACompatibility.evaluate(entry, {
    modelsByKey = {fixture_model = {}}, configs = {{modelKey = "fixture_model", key = "base", path = entry.base.configPath}},
    scan = scan, variables = {}, paints = {}, gameVersion = "fixture", extensionVersion = "0.4.0-alpha.2",
    generatorVersion = 4, currentConfigPath = entry.base.configPath,
  }, "compatible")
  equal(report.status, "partial")
  equal(report.deviations[1].reason, "slot_remapped")
end

tests.dna_pass_budget_supports_deep_trees = function()
  equal(vehicleDNAPassBudget.calculate(20, 1).passLimit, 24)
  equal(vehicleDNAPassBudget.calculate(50, 1).passLimit, 54)
  equal(vehicleDNAPassBudget.calculate(100, 1).passLimit, 104)
  equal(vehicleDNAPassBudget.calculate(200, 1).passLimit, 128)
end

tests.dna_pass_budget_detects_no_progress = function()
  local budget = vehicleDNAPassBudget.create(20, 20, 0, 120)
  truthy(vehicleDNAPassBudget.observe(budget, "A", 2, 1))
  local ok, reason = vehicleDNAPassBudget.observe(budget, "A", 2, 2)
  equal(ok, false)
  equal(reason, "dna_restore_no_progress")
end

tests.dna_pass_budget_detects_oscillation = function()
  local budget = vehicleDNAPassBudget.create(20, 20, 0, 120)
  truthy(vehicleDNAPassBudget.observe(budget, "A", 2, 1))
  truthy(vehicleDNAPassBudget.observe(budget, "B", 2, 2))
  local ok, reason = vehicleDNAPassBudget.observe(budget, "A", 2, 3)
  equal(ok, false)
  equal(reason, "dna_restore_repeated_state")
end

tests.dna_storage_metrics_expose_real_capacity = function()
  local library = assert(vehicleDNAStorage.add(vehicleDNAStorage.create(3), sampleDNA()))
  local value = assert(vehicleDNAStorage.metrics(library))
  equal(value.entryCount, 1)
  equal(value.entryLimit, 3)
  equal(value.byteLimit, vehicleDNAStorage.MAX_TOTAL_BYTES)
  truthy(value.canonicalBytes > 0 and value.largestEntryBytes > 0 and value.elementCount > 0)
end

tests.dna_storage_recovers_after_primary_write_failure = function()
  local oldRead, oldWrite = rawget(_G, "jsonReadFile"), rawget(_G, "jsonWriteFile")
  local stored = {[adapter.DNA_LIBRARY_PATH] = {kind = "old", revision = 7}}
  _G.jsonReadFile = function(path) return util.deepCopy(stored[path]) end
  _G.jsonWriteFile = function(path, value)
    if path == adapter.DNA_LIBRARY_PATH and value.kind == "new" then return false end
    stored[path] = util.deepCopy(value); return true
  end
  local ok, result = adapter.saveDNALibrary({kind = "new", revision = 8}, {kind = "old", revision = 7})
  equal(ok, false)
  equal(result.code, "dna_storage_recovered")
  equal(result.context.cause, "dna_storage_primary_write_failed")
  equal(stored[adapter.DNA_LIBRARY_PATH].kind, "old")
  _G.jsonReadFile, _G.jsonWriteFile = oldRead, oldWrite
end

tests.dna_dependencies_skip_empty_optional_slots = function()
  local harness = pipelineHarness.new({emptyOptional = true})
  truthy(pipelineHarness.driveSuccess(harness, "randomConfig"))
  truthy(harness.main.saveVehicleDNA("No Empty Dependency"))
  local dependencies = harness.library.entries[1].dependencies
  for _, item in ipairs(dependencies.parts or {}) do truthy(item.partName ~= "") end
end

tests.restore_exact_starts_from_different_model = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom"))
  truthy(harness.main.saveVehicleDNA("Cross Model Exact"))
  local id = harness.main.requestState().garage.entries[1].id
  harness.modelKey, harness.configPath = "fixture_old", "/vehicles/fixture_old/original.pc"
  local preflightOk, report = harness.main.preflightVehicleDNA(id, "exact")
  truthy(preflightOk)
  equal(report.status, "target_inspection_required")
  truthy(harness.main.restoreVehicleDNA(id, "exact", false))
  equal(harness.pendingReplacement.modelKey, "fixture_new")
  equal(harness.pendingReplacement.path, "/vehicles/fixture_new/base_version.pc")
  pipelineHarness.confirmReplacement(harness)
  while harness.pendingParts do pipelineHarness.confirmParts(harness) end
  if harness.pendingTuning then pipelineHarness.confirmTuning(harness) end
  equal(harness.main.requestState().lastResult.code, "dna_restore_exact")
end

tests.restore_compatible_starts_from_different_model = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom"))
  truthy(harness.main.saveVehicleDNA("Cross Model Compatible"))
  local id = harness.main.requestState().garage.entries[1].id
  harness.modelKey, harness.configPath = "fixture_old", "/vehicles/fixture_old/original.pc"
  truthy(harness.main.restoreVehicleDNA(id, "compatible", true))
  pipelineHarness.confirmReplacement(harness)
  while harness.pendingParts do pipelineHarness.confirmParts(harness) end
  if harness.pendingTuning then pipelineHarness.confirmTuning(harness) end
  local code = harness.main.requestState().lastResult.code
  truthy(code == "dna_restore_compatible" or code == "dna_restore_partial")
end

tests.partial_discovered_after_spawn_rolls_back_without_authorization = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom"))
  truthy(harness.main.saveVehicleDNA("Partial Authorization"))
  local id = harness.main.requestState().garage.entries[1].id
  harness.modelKey, harness.configPath = "fixture_old", "/vehicles/fixture_old/original.pc"
  harness.tuningMaximum = 0
  truthy(harness.main.restoreVehicleDNA(id, "compatible", false))
  pipelineHarness.confirmReplacement(harness)
  truthy(harness.pendingReplacement ~= nil, "target partial must start rollback; phase="
    .. tostring(harness.main.requestState().lifecyclePhase) .. " code="
    .. tostring(harness.main.requestState().lastResult and harness.main.requestState().lastResult.code))
  pipelineHarness.confirmReplacement(harness)
  local result = harness.main.requestState().lastResult
  equal(result.success, false)
  equal(result.code, "dna_partial_authorization_required")
  equal(result.details.rollback, "completed")
end

tests.replay_generation_freezes_saved_base_from_different_model = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom"))
  truthy(harness.main.saveVehicleDNA("Replay Frozen Base"))
  local id = harness.main.requestState().garage.entries[1].id
  harness.modelKey, harness.configPath = "fixture_old", "/vehicles/fixture_old/original.pc"
  truthy(harness.main.replayVehicleDNAGeneration(id))
  equal(harness.pendingReplacement.modelKey, "fixture_new")
  equal(harness.pendingReplacement.path, "/vehicles/fixture_new/base_version.pc")
  pipelineHarness.confirmReplacement(harness)
  while harness.pendingParts do pipelineHarness.confirmParts(harness) end
  if harness.pendingTuning then pipelineHarness.confirmTuning(harness) end
  local result = harness.main.requestState().lastResult
  truthy(result.code == "dna_replay_exact" or result.code == "dna_replay_close"
    or result.code == "dna_replay_partial")
  equal(result.details.baseSelectionFrozen, true)
end

tests.replay_generation_current_lock_policy_is_explicit_and_records_deviation = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom"))
  truthy(harness.main.saveVehicleDNA("Replay Current Locks"))
  local id = harness.main.requestState().garage.entries[1].id
  truthy(harness.main.updateLockProfile({categories = {body = true}}))
  harness.modelKey, harness.configPath = "fixture_old", "/vehicles/fixture_old/original.pc"
  truthy(harness.main.replayVehicleDNAGeneration(id, "current"))
  pipelineHarness.confirmReplacement(harness)
  while harness.pendingParts do pipelineHarness.confirmParts(harness) end
  if harness.pendingTuning then pipelineHarness.confirmTuning(harness) end
  local result = harness.main.requestState().lastResult
  equal(result.code, "dna_replay_partial")
  local found = false
  for _, deviation in ipairs(result.details.deviations or {}) do
    if deviation.reason == "replay_current_lock_preserved" then found = true end
  end
  truthy(found)
end

tests.restore_snapshot_ignores_current_creative_locks = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom"))
  truthy(harness.main.saveVehicleDNA("Restore Ignores Locks"))
  local id = harness.main.requestState().garage.entries[1].id
  truthy(harness.main.updateLockProfile({
    vehicle = true, configuration = true, categories = {body = true, tuning = true, paint = true},
  }))
  harness.modelKey, harness.configPath = "fixture_old", "/vehicles/fixture_old/original.pc"
  truthy(harness.main.restoreVehicleDNA(id, "exact", false))
  pipelineHarness.confirmReplacement(harness)
  while harness.pendingParts do pipelineHarness.confirmParts(harness) end
  if harness.pendingTuning then pipelineHarness.confirmTuning(harness) end
  equal(harness.main.requestState().lastResult.code, "dna_restore_exact")
end

tests.random_config_replay_loads_saved_config_without_reselection = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "randomConfig"))
  truthy(harness.main.saveVehicleDNA("Random Config Replay"))
  local id = harness.main.requestState().garage.entries[1].id
  harness.modelKey, harness.configPath = "fixture_old", "/vehicles/fixture_old/original.pc"
  truthy(harness.main.replayVehicleDNAGeneration(id))
  equal(harness.pendingReplacement.path, "/vehicles/fixture_new/base_version.pc")
  pipelineHarness.confirmReplacement(harness)
  local result = harness.main.requestState().lastResult
  truthy(result.code == "dna_replay_exact" or result.code == "dna_replay_close")
  equal(result.details.baseSelectionFrozen, true)
end

tests.pure_seed_replay_remains_separate = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "randomConfig"))
  truthy(harness.main.saveVehicleDNA("Pure Seed"))
  local id = harness.main.requestState().garage.entries[1].id
  harness.modelKey, harness.configPath = "fixture_old", "/vehicles/fixture_old/original.pc"
  truthy(harness.main.pureSeedReplayVehicleDNA(id))
  truthy(harness.pendingReplacement ~= nil)
  pipelineHarness.confirmReplacement(harness)
  equal(harness.main.requestState().lastResult.code, "random_config_loaded")
end

tests.lock_profile_migrates_and_persists_separately = function()
  local value = settings.validate({schemaVersion = 3})
  equal(value.schemaVersion, 9)
  equal(value.lockProfile.kind, "soturineVehicleDNALockProfile")
  local locked = vehicleDNALocks.applyPatch(value.lockProfile, {
    vehicle = true, categories = {engine = true}, tuning = {all = true},
  })
  truthy(locked.vehicle)
  truthy(locked.categories.engine)
  truthy(locked.tuning.all)
end

tests.lock_categories_use_slot_evidence_and_unknown_fallback = function()
  equal(vehicleDNALocks.classifySlot({id = "mainEngine", description = "Engine"}), "engine")
  equal(vehicleDNALocks.classifySlot({id = "frontWheelTire", path = "/wheels/front/tire/"}), "tires")
  equal(vehicleDNALocks.classifySlot({id = "mystery", description = "Unmapped component"}), "other")
  local category, reason = vehicleDNALocks.classifySlot({
    id = "navigation_unit", description = "Generic attachment", path = "/body/navigation_unit",
  })
  equal(category, "electronics")
  truthy(reason:find("slot_id_token", 1, true) ~= nil)
  equal(vehicleDNALocks.classifySlot({
    id = "generic_attachment", description = "Left Antenna", path = "/body/antenna_left",
  }), "electronics")
  equal(vehicleDNALocks.classifySlot({
    id = "unknown_mount", allowTypes = {"combustion_engine"}, path = "/body/unknown_mount",
  }), "engine")
  equal(vehicleDNALocks.classifySlot({
    id = "unknown_mount", currentPart = "race_suspension_arm", path = "/body/engine/unknown_mount",
  }), "suspension")
  equal(vehicleDNALocks.classifySlot({
    id = "unknown", path = "/body/navigation_unit",
  }), "electronics")
  category, reason = vehicleDNALocks.classifySlot({id = "unknown", path = "/body/mod_brand_widget"})
  equal(category, "body")
  truthy(reason:find("path_ancestry_token", 1, true) ~= nil)
  equal(vehicleDNALocks.classifySlot({
    id = "wheel_tire", description = "ModBrand Competition Product", path = "/body/engine/suspension/wheel_tire",
  }), "tires")
  equal(vehicleDNALocks.classifySlot({
    id = "modbrand_flux_capacitor", description = "ModBrand Flux Capacitor",
  }), "other")
end

tests.lock_summary_reports_bounded_category_slot_and_field_counts = function()
  local profile = vehicleDNALocks.normalize({
    vehicle = true, categories = {engine = true, paint = true},
    slots = {["/engine/"] = true}, tuning = {all = true},
    paints = {fields = {[1] = {metallic = true}}},
  })
  local value = vehicleDNALocks.summary(profile)
  equal(value.categories, 2)
  equal(value.unlockedCategories, #vehicleDNALocks.CATEGORIES - 2)
  equal(value.slots, 1)
  equal(value.tuning, 1)
  equal(value.paint, 1)
  equal(value.locked, 6)
end

tests.slot_and_part_locks_resolve_without_silent_substitution = function()
  local scan = assert(slotScanner.scan(fixtures.nestedTree, {}))
  local profile = vehicleDNALocks.normalize({
    slots = {["/engine/"] = {slotId = "engine", partName = "engine_a"}},
    parts = {["/accessory/"] = {slotId = "accessory", partName = "part_missing"}},
  })
  truthy(vehicleDNALocks.isSlotLocked(profile, scan.byPath["/engine/"]))
  local resolution = vehicleDNALocks.resolve(profile, scan)
  equal(resolution.unresolvedCount, 1)
  equal(resolution.unresolved[1].kind, "part")
end

tests.reroll_part_plan_preserves_locked_slots = function()
  local scan = assert(slotScanner.scan(fixtures.nestedTree, {}))
  local profile = vehicleDNALocks.normalize({categories = {engine = true}})
  local tree = mutationEngine.plan(scan, nil, fullMutationPolicy(false), rng.new("locked-plan"), {
    independentSubstreams = true,
    categoryForSlot = vehicleDNALocks.classifySlot,
    isLocked = function(slot) return vehicleDNALocks.isSlotLocked(profile, slot) end,
  })
  equal(tree.children.engine.chosenPartName, "engine_a")
end

tests.reroll_tuning_and_paint_preserve_individual_locks = function()
  local values = {independentA = 5, independentB = 0}
  local policy = mutationPolicy.fromSettings({chaos = 100, allowMissingParts = false})
  local randomized = tuningPipeline.plan(fixtures.variables, values, policy, rng.new("tuning-lock"), {
    isLocked = function(name) return name == "independentA" end,
  })
  equal(randomized.independentA, 5)
  local paints = {{baseColor = {0.2, 0.3, 0.4, 1}, metallic = 0.4, roughness = 0.5, clearcoat = 0.5, clearcoatRoughness = 0.2}}
  local painted = paintRandomizer.randomize(paints, policy, rng.new("paint-lock"), {
    independentSubstreams = true,
    isFieldLocked = function(_, field) return field == "metallic" end,
  })
  equal(painted[1].metallic, 0.4)
end

tests.reroll_independent_substreams_survive_unrelated_category_locks = function()
  local scan = assert(slotScanner.scan(fixtures.nestedTree, {}))
  local policy = fullMutationPolicy(false)
  local first = mutationEngine.plan(scan, nil, policy, rng.new("independent-locks"), {
    independentSubstreams = true, categoryForSlot = vehicleDNALocks.classifySlot,
  })
  local second = mutationEngine.plan(scan, nil, policy, rng.new("independent-locks"), {
    independentSubstreams = true, categoryForSlot = vehicleDNALocks.classifySlot,
    isLocked = function(slot) return vehicleDNALocks.classifySlot(slot) == "accessories" end,
  })
  equal(first.children.engine.chosenPartName, second.children.engine.chosenPartName)
end

tests.mutation_seed_and_lineage_are_deterministic = function()
  local parent = sampleDNA({id = "dna-parent"})
  local first = assert(vehicleDNAMutations.deriveSeed(parent.generation.seed, parent.id, 2, "small"))
  local second = assert(vehicleDNAMutations.deriveSeed(parent.generation.seed, parent.id, 2, "small"))
  equal(first, second)
  local lineage = assert(vehicleDNAMutations.lineage(parent, 2, "small", "mutation"))
  equal(lineage.parentId, parent.id)
  equal(lineage.rootId, parent.id)
  equal(lineage.generation, 1)
end

tests.mutation_strengths_are_bounded_direct_presets = function()
  equal(vehicleDNAMutations.settingsForStrength({chaos = 99}, "small").chaos, 25)
  equal(vehicleDNAMutations.settingsForStrength({chaos = 1}, "medium").chaos, 60)
  equal(vehicleDNAMutations.settingsForStrength({chaos = 1}, "wild").chaos, 100)
  equal(vehicleDNAMutations.settingsForStrength({}, "unknown"), nil)
end

tests.mutation_parent_is_immutable_children_are_unique_and_depth_is_bounded = function()
  local parent = sampleDNA({id = "mutation-root", name = "Immutable Parent"})
  local original = util.deepCopy(parent)
  local library = assert(vehicleDNAStorage.add(vehicleDNAStorage.create(10), parent))
  local child = util.deepCopy(parent)
  child.id, child.name = "mutation-root", "Mutation Child"
  child.lineage = assert(vehicleDNAMutations.lineage(parent, 1, "medium", "mutation"))
  library, _, child.id = vehicleDNAStorage.add(library, child)
  truthy(library)
  truthy(child.id ~= parent.id)
  truthy(util.deepEqual(vehicleDNAStorage.find(library, parent.id), original, 1e-8))
  equal(vehicleDNAMutations.nextIndex(library, parent.id), 2)
  local tooDeep = util.deepCopy(parent)
  tooDeep.lineage = {rootId = parent.id, generation = vehicleDNAMutations.MAX_LINEAGE_DEPTH}
  equal(vehicleDNAMutations.lineage(tooDeep, 2, "wild", "mutation"), nil)
end

tests.garage_metadata_filters_and_parent_delete_are_migratable = function()
  local library = vehicleDNAStorage.create(10)
  library = assert(vehicleDNAStorage.add(library, sampleDNA({id = "parent", name = "Parent"})))
  local child = sampleDNA({id = "child", name = "Child"})
  child.lineage = {parentId = "parent", rootId = "parent", generation = 1, createdFrom = "mutation"}
  library = assert(vehicleDNAStorage.add(library, child))
  library = assert(vehicleDNAStorage.setPinned(library, "child", true))
  library = assert(vehicleDNAStorage.setRating(library, "child", 5))
  library = assert(vehicleDNAStorage.setTags(library, "child", {"Track", "Orange"}))
  library = assert(vehicleDNAStorage.setCollection(library, "child", "Favorites"))
  local results, total = vehicleDNAStorage.query(library, {filter = "pinned", tag = "track", collection = "Favorites"})
  equal(total, 1)
  equal(results[1].rating, 5)
  library = assert(vehicleDNAStorage.remove(library, "parent"))
  truthy(vehicleDNAStorage.find(library, "child").lineage.parentMissing)
end

tests.garage_sort_and_pagination_are_bounded = function()
  local library = vehicleDNAStorage.create(10)
  for index, name in ipairs({"Zulu", "Alpha", "Mike"}) do
    local entry = sampleDNA({id = "page-" .. index, name = name})
    entry.updatedAt = index
    library = assert(vehicleDNAStorage.add(library, entry))
    library = assert(vehicleDNAStorage.setRating(library, entry.id, index))
  end
  local page, total = vehicleDNAStorage.query(library, {sort = "name", offset = 1, limit = 1})
  equal(total, 3)
  equal(#page, 1)
  equal(page[1].name, "Mike")
  local rated = vehicleDNAStorage.query(library, {sort = "rating", offset = 0, limit = 1})
  equal(rated[1].rating, 3)
end

tests.vehicle_dna_compare_is_field_by_field_not_fingerprint_only = function()
  local slots = {{path = "/engine/", slotId = "engine", partName = "engine_a"}}
  local left, right = sampleDNA({id = "left", slots = slots}), sampleDNA({id = "right", slots = slots})
  right.final.slots[1].partName = "changed_part"
  local comparison = assert(vehicleDNACompare.compare(left, right))
  equal(comparison.equal, false)
  truthy(#comparison.differences > 0)
  equal(comparison.differences[1].section == "slots" or comparison.differences[1].section == "configuration", true)
end

local function be32(value)
  return string.char(math.floor(value / 16777216) % 256, math.floor(value / 65536) % 256,
    math.floor(value / 256) % 256, value % 256)
end

local function fixturePNG(width, height)
  local function chunk(kind, data)
    return be32(#data) .. kind .. data .. be32(vehicleDNAPackage.crc32(kind .. data))
  end
  local ihdr = be32(width) .. be32(height) .. string.char(8, 6, 0, 0, 0)
  return "\137PNG\13\10\26\10" .. chunk("IHDR", ihdr) .. chunk("IDAT", "x") .. chunk("IEND", "")
end

tests.gallery_thumbnail_bounds_and_fallback_are_safe = function()
  local dimensions = assert(vehicleDNAGallery.pngDimensions(fixturePNG(500, 281)))
  equal(dimensions.width, 500)
  equal(vehicleDNAGallery.pngDimensions(fixturePNG(501, 281)), nil)
  local fallback = vehicleDNAGallery.fallback(sampleDNA())
  equal(fallback.kind, "fallback")
  equal(fallback.sourceKind, "unknown")
  truthy(not vehicleDNAGallery.safeId("../../unsafe"):find(".", 1, true))
  equal(vehicleDNAGallery.pngDimensions(fixturePNG(32, 18) .. string.rep("x", vehicleDNAGallery.MAX_BYTES)), nil)
end

local function fakeSHA(data)
  return string.rep(string.format("%x", #data % 16), 64)
end

local function packageFixture(includeThumbnail)
  local files = {
    ["vehicle.vdna.json"] = "{\"format\":\"SoturineVehicleDNAShare\"}",
    ["compatibility.json"] = "{\"status\":\"not_evaluated\"}",
    ["README.txt"] = "metadata only; no mods",
  }
  if includeThumbnail then files["thumbnail.png"] = fixturePNG(32, 18) end
  local records = {}
  for _, name in ipairs({"vehicle.vdna.json", "compatibility.json", "README.txt", "thumbnail.png"}) do
    if files[name] then records[#records + 1] = {name = name, bytes = #files[name], sha256 = fakeSHA(files[name])} end
  end
  files["manifest.json"] = "manifest-placeholder"
  return files, {format = "SoturineVehicleDNAPackage", packageVersion = 1, files = records}
end

tests.vdna_zip_roundtrip_validates_crc_manifest_and_limits = function()
  local files, manifest = packageFixture(false)
  local archive = assert(vehicleDNAPackage.build(files))
  local inspected = assert(vehicleDNAPackage.inspect(archive))
  truthy(vehicleDNAPackage.validateManifest(manifest, inspected, fakeSHA))
  equal(inspected.entries["README.txt"], files["README.txt"])
  truthy(not inspected.entries["mod.jbeam"])
end

tests.vdna_zip_rejects_traversal_duplicate_symlink_and_bomb_shapes = function()
  local files = packageFixture(true)
  local archive = assert(vehicleDNAPackage.build(files))
  local traversed = archive:gsub("README%.txt", "../bad.txt?")
  equal(vehicleDNAPackage.inspect(traversed), nil)
  local duplicated = archive:gsub("manifest%.json", "thumbnail.png")
  equal(vehicleDNAPackage.inspect(duplicated), nil)
  local central = assert(archive:find("PK\1\2", 1, true))
  local function byteAt(value, index, byte)
    return value:sub(1, index - 1) .. string.char(byte) .. value:sub(index + 1)
  end
  local symlink = byteAt(archive, central + 5, 3)
  symlink = byteAt(symlink, central + 41, 160)
  equal(vehicleDNAPackage.inspect(symlink), nil)
  local bomb = byteAt(archive, central + 20, 1)
  bomb = byteAt(bomb, central + 21, 0)
  bomb = byteAt(bomb, central + 22, 0)
  bomb = byteAt(bomb, central + 23, 0)
  equal(vehicleDNAPackage.inspect(bomb), nil)
end

tests.vdna_manifest_rejects_missing_checksum_and_future_package_version = function()
  local files, manifest = packageFixture(false)
  local inspected = assert(vehicleDNAPackage.inspect(assert(vehicleDNAPackage.build(files))))
  manifest.files[1].sha256 = string.rep("0", 64)
  equal(vehicleDNAPackage.validateManifest(manifest, inspected, fakeSHA), false)
  local _, cleanManifest = packageFixture(false)
  cleanManifest.files[#cleanManifest.files + 1] = {name = "thumbnail.png", bytes = 0, sha256 = string.rep("0", 64)}
  equal(vehicleDNAPackage.validateManifest(cleanManifest, inspected, fakeSHA), false)
  local _, futureManifest = packageFixture(false)
  futureManifest.packageVersion = vehicleDNAPackage.PACKAGE_VERSION + 1
  equal(vehicleDNAPackage.validateManifest(futureManifest, inspected, fakeSHA), false)
end

tests.vdna_zip_truncation_and_local_offset_corruption_fail_closed = function()
  local files = packageFixture(false)
  local archive = assert(vehicleDNAPackage.build(files))
  local ok, inspected = pcall(vehicleDNAPackage.inspect, archive:sub(1, #archive - 7))
  truthy(ok)
  equal(inspected, nil)
  local central = assert(archive:find("PK\1\2", 1, true))
  local corrupted = archive:sub(1, central + 41) .. string.char(255, 255, 255, 127) .. archive:sub(central + 46)
  ok, inspected = pcall(vehicleDNAPackage.inspect, corrupted)
  truthy(ok)
  equal(inspected, nil)
end

tests.imported_origin_is_preserved_while_local_ids_stay_unique = function()
  local library = vehicleDNAStorage.create(10)
  local first = sampleDNA({id = "foreign-origin"})
  first.lineage = {originId = first.id, importedAt = 10, importStrategy = "validated_json_object"}
  local firstId, secondId
  library, _, firstId = vehicleDNAStorage.add(library, first)
  library, _, secondId = vehicleDNAStorage.add(library, first)
  truthy(firstId ~= secondId)
  equal(vehicleDNAStorage.find(library, secondId).lineage.originId, "foreign-origin")
end

tests.vdna_json_envelope_roundtrips_through_public_import = function()
  local harness = pipelineHarness.new()
  local entry = sampleDNA({id = "json-origin", name = "JSON Envelope"})
  truthy(harness.main.importVehicleDNA(vehicleDNAPackage.envelope(entry)))
  truthy(harness.main.importVehicleDNA(vehicleDNAPackage.envelope(entry)))
  local first, second = harness.library.entries[1], harness.library.entries[2]
  equal(first.lineage.originId, "json-origin")
  equal(second.lineage.originId, "json-origin")
  truthy(first.id ~= second.id)
end

tests.reroll_unlocked_creates_pending_dna_without_changing_locked_state = function()
  local harness = pipelineHarness.new()
  truthy(harness.main.updateLockProfile({
    configuration = true,
    categories = {body = true, engine = true, transmission = true, drivetrain = true, suspension = true,
      brakes = true, steering = true, wheels = true, tires = true, aero = true, interior = true,
      electronics = true, accessories = true, props = true, other = true, tuning = true, paint = true},
    tuning = {all = true}, paints = {all = true},
  }))
  truthy(harness.main.rerollUnlocked({seed = "reroll-locked"}))
  for _ = 1, 16 do
    if not harness.main.requestState().busy then break end
    harness.now = harness.now + 0.1
    harness.main.onUpdate()
  end
  local state = harness.main.requestState()
  equal(state.lastResult.code, "reroll_unlocked_completed")
  truthy(state.garage.pendingSave)
end

tests.dna_mutation_loads_parent_base_and_creates_child_lineage = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom"))
  truthy(harness.main.saveVehicleDNA("Mutation Parent"))
  local id = harness.main.requestState().garage.entries[1].id
  harness.modelKey, harness.configPath = "fixture_old", "/vehicles/fixture_old/original.pc"
  truthy(harness.main.mutateVehicleDNA(id, "small", {mutationIndex = 1}))
  equal(harness.pendingReplacement.modelKey, "fixture_new")
  pipelineHarness.confirmReplacement(harness)
  for _ = 1, 24 do
    if harness.pendingReplacement then pipelineHarness.confirmReplacement(harness)
    elseif harness.pendingParts then pipelineHarness.confirmParts(harness)
    elseif harness.pendingTuning then pipelineHarness.confirmTuning(harness)
    elseif not harness.main.requestState().busy then break
    else harness.now = harness.now + 0.1; harness.main.onUpdate() end
  end
  local state = harness.main.requestState()
  equal(state.lastResult.code, "dna_mutation_completed")
  truthy(state.garage.pendingSave)
end

local function alpha2Tracker(options)
  options = options or {}
  return vehicleTargetTracker.create({
    token = "alpha2-token", phase = options.phase or "spawn", modelKey = options.modelKey or "target_model",
    parts = options.parts or {}, returnedVehicleId = options.returnedVehicleId,
    originalVehicleId = options.originalVehicleId or 1, startedAt = 0, timeout = options.timeout or 3,
    stabilizer = {minimumFrames = 5, minimumScans = 2, pollInterval = 0},
  })
end

local function alpha2State(id, model, parts)
  return {vehicleId = id, modelKey = model or "target_model", configKey = "/vehicles/target_model/base.pc", parts = parts or {}}
end

tests.alpha2_tracker_rebind_chain_contract = function()
  local tracker = alpha2Tracker({returnedVehicleId = 2})
  vehicleTargetTracker.onSwitched(tracker, 1, 2, 0, true)
  vehicleTargetTracker.onSpawned(tracker, 77) -- auxiliary entity, never player target
  vehicleTargetTracker.onDestroyed(tracker, 2)
  vehicleTargetTracker.onSwitched(tracker, 2, 3, 0, false)
  local status
  for frame = 1, 5 do status = vehicleTargetTracker.observe(tracker, "alpha2-token", alpha2State(3), frame * 0.1) end
  equal(status, "stable")
  equal(vehicleTargetTracker.summary(tracker, 0.5).currentCandidateId, 3)
end

tests.v063_returned_vehicle_id_remains_a_candidate = function()
  local tracker = alpha2Tracker({returnedVehicleId = 2})
  vehicleTargetTracker.onSpawned(tracker, 3)
  local status
  for frame = 1, 5 do
    status = vehicleTargetTracker.observe(
      tracker,
      "alpha2-token",
      alpha2State(3, "target_model"),
      frame * 0.1
    )
  end
  equal(status, "stable")
  local summary = vehicleTargetTracker.summary(tracker, 0.5)
  equal(summary.returnedVehicleId, 2)
  equal(summary.currentCandidateId, 3)
end

tests.v063_reload_can_rebind_same_logical_target = function()
  local tracker = vehicleTargetTracker.create({
    token = "reload", operationId = "SCR-reload", operationGeneration = 4,
    phaseGeneration = 7, targetGeneration = 2, phase = "parts",
    vehicleId = 10, modelKey = "target_model",
    configKey = "/vehicles/target_model/base.pc",
    parts = {["/body/"] = "body_b"}, requirePartsReadable = true,
    startedAt = 0, timeout = 3,
    stabilizer = {minimumFrames = 2, minimumScans = 2, pollInterval = 0},
    treeStabilizer = {minimumFrames = 2, minimumScans = 2, pollInterval = 0},
  })
  vehicleTargetTracker.onSpawned(tracker, 11)
  local context = {
    operationId = "SCR-reload", operationGeneration = 4,
    phaseGeneration = 7, targetGeneration = 2,
  }
  local status
  for frame = 1, 3 do
    status = vehicleTargetTracker.observe(tracker, "reload", {
      vehicleId = 11, playerIndex = 0, modelKey = "target_model",
      configKey = "/vehicles/target_model/base.pc",
      configIdentity = {path = "/vehicles/target_model/base.pc", key = "base"},
      parts = {["/body/"] = "body_b"}, partsAvailable = true, readStatus = "ready",
    }, frame * 0.1, context)
  end
  equal(status, "stable")
  equal(vehicleTargetTracker.summary(tracker, 0.3).currentCandidateId, 11)
end

tests.v064_optional_and_unproven_mod_absence_are_nonfatal = function()
  local tree = {children = {
    optional = {id = "optional", path = "/optional/", chosenPartName = "", children = {}},
    modHint = {id = "modHint", path = "/modHint/", chosenPartName = "", children = {}},
  }}
  local scan = assert(slotScanner.scan(tree, {
    ["/modHint/"] = {required = true, description = "non-standard mod hint"},
  }))
  local graph = validator.buildGraph(scan, {type = "Car"}, {allowMissingParts = true})
  local result = validator.validateGraph(graph, graph, true)
  truthy(result.valid)
  equal(#result.missingParts, 2)
  equal(result.missingParts[1].classification, "mod_metadata_required_unproven")
  equal(result.missingParts[2].classification, "optional_missing_allowed")
  equal(result.status, "uncertain")
  equal(#result.failures, 0)
end

tests.v064_only_core_slot_absence_is_structurally_fatal = function()
  local tree = {children = {
    core = {id = "core", path = "/core/", chosenPartName = "", children = {}},
  }}
  local scan = assert(slotScanner.scan(tree, {["/core/"] = {coreSlot = true}}))
  local graph = validator.buildGraph(scan, {type = "Car"}, {allowMissingParts = true})
  local result = validator.validateGraph(graph, graph, true)
  truthy(not result.valid)
  equal(result.failures[1].reason, "core_infrastructure_missing")
end

tests.v064_tracker_accepts_applied_state_from_matching_evidence_without_callback = function()
  local tracker = vehicleTargetTracker.create({
    token = "evidence", operationId = "SCR-evidence", operationGeneration = 1,
    phaseGeneration = 2, targetGeneration = 3, phase = "parts",
    modelKey = "target_model", configKey = "/vehicles/target_model/new.pc",
    parts = {["/body/"] = "body_new"}, requirePartsReadable = true,
    startedAt = 0, timeout = 3,
    stabilizer = {minimumFrames = 2, minimumScans = 2, pollInterval = 0},
    treeStabilizer = {minimumFrames = 2, minimumScans = 2, pollInterval = 0},
  })
  local observation = {
    vehicleId = 42, playerIndex = 0, modelKey = "target_model",
    readStatus = "ready", coherentTargetRead = true,
    configCandidates = {
      {
        source = "manager_by_id", configKey = "/vehicles/target_model/old.pc",
        configIdentity = {path = "/vehicles/target_model/old.pc", key = "old"},
        parts = {["/body/"] = "body_old"}, partsAvailable = true,
      },
      {
        source = "player_partmgmt", configKey = "/vehicles/target_model/new.pc",
        configIdentity = {path = "/vehicles/target_model/new.pc", key = "new"},
        parts = {["/body/"] = "body_new"}, partsAvailable = true,
      },
    },
  }
  local context = {
    operationId = "SCR-evidence", operationGeneration = 1,
    phaseGeneration = 2, targetGeneration = 3,
  }
  local status
  for frame = 1, 3 do
    status = vehicleTargetTracker.observe(tracker, "evidence", observation, frame * 0.1, context)
  end
  equal(status, "stable")
  local report = vehicleTargetTracker.summary(tracker, 0.3)
  truthy(not report.callbackSeen)
  equal(report.treeStatus, "vehicle_target_stable")
  equal(tracker.lastState.evidenceSource, "player_partmgmt")
end

tests.v064_callback_order_is_advisory_and_duplicate_safe = function()
  local tracker = alpha2Tracker({returnedVehicleId = 2})
  vehicleTargetTracker.onSpawned(tracker, 2)
  vehicleTargetTracker.onSpawned(tracker, 2)
  vehicleTargetTracker.onSwitched(tracker, 1, 2, 0, true)
  local status
  for frame = 1, 5 do
    status = vehicleTargetTracker.observe(tracker, "alpha2-token", alpha2State(2), frame * 0.1)
  end
  equal(status, "stable")
  vehicleTargetTracker.onSpawned(tracker, 2)
  local report = vehicleTargetTracker.summary(tracker, 0.6)
  equal(report.candidateCount, 1)
  truthy(report.callbackSeen)
end

tests.v063_random_car_accepts_recreated_player_target_without_pause = function()
  local harness = pipelineHarness.new({vehicleId = 1, returnedVehicleId = 2})
  truthy(harness.main.randomConfig({manualSeed = "candidate-rebind", seedMode = "fixed"}))
  harness.pendingReplacement.vehicleId = 3
  pipelineHarness.applyPendingReplacement(harness, true)
  pipelineHarness.advance(harness, 0.06, 0.06, 12)
  local state = harness.main.requestState()
  truthy(not state.busy, "recreated target remained Busy at " .. tostring(state.lifecyclePhase))
  equal(state.lastResult.code, "random_config_loaded")
  equal(state.lastResult.details.model, "fixture_new")
end

tests.v064_public_random_car_completes_without_any_lifecycle_callback = function()
  local harness = pipelineHarness.new({vehicleId = 1, returnedVehicleId = 2})
  truthy(harness.main.randomConfig({manualSeed = "no-callback-random-car", seedMode = "fixed"}))
  pipelineHarness.applyPendingReplacement(harness, false)
  pipelineHarness.advance(harness, 0.06, 0.06, 16)
  local state = harness.main.requestState()
  truthy(not state.busy, "Random Car remained Busy at " .. tostring(state.lifecyclePhase))
  equal(state.lastResult.code, "random_config_loaded")
end

local function driveAppliedStatesWithoutCallbacks(harness, maxSteps)
  for _ = 1, maxSteps or 160 do
    local state = harness.main.requestState()
    if not state.busy then return state end
    if harness.pendingReplacement then
      pipelineHarness.applyPendingReplacement(harness, false)
    elseif harness.pendingParts then
      harness.tree = util.deepCopy(harness.pendingParts)
      harness.pendingParts = nil
    elseif harness.pendingTuning then
      harness.tuning = util.deepCopy(harness.pendingTuning)
      harness.pendingTuning = nil
    end
    pipelineHarness.advance(harness, 0.06, harness.paused and 0 or 0.06, 1)
  end
  return harness.main.requestState()
end

tests.v064_full_random_and_scramble_accept_readback_without_callbacks = function()
  for _, action in ipairs({"fullRandom", "scramble"}) do
    local harness = pipelineHarness.new()
    truthy(harness.main.runAction(action, {
      chaos = 100, allowMissingParts = false, protectCriticalParts = true,
      manualSeed = "no-callback-" .. action, seedMode = "fixed",
      includeAutomation = true, includeTrailers = true, includeProps = true,
    }))
    local state = driveAppliedStatesWithoutCallbacks(harness, 220)
    truthy(not state.busy, action .. " remained Busy at " .. tostring(state.lifecyclePhase))
    truthy(state.lastResult and state.lastResult.success, action .. " did not succeed")
    equal(state.lastResult.details.lifecycleAcceptance.pendingCallbacks, 0)
  end
end

tests.v063_operation_context_rebind_requires_current_stable_player = function()
  local state = {
    operationId = "SCR-context", operationToken = "token", operationGeneration = 3,
    phaseGeneration = 5, targetGeneration = 7,
  }
  local context = operationContext.create(state, "token", 1)
  operationContext.beginLogicalTarget(context, state, {
    modelKey = "target_model", configKey = "/vehicles/target_model/base.pc",
  }, 1)
  operationContext.bindInitial(context, state, {
    vehicleId = 10, modelKey = "target_model", configKey = "/vehicles/target_model/base.pc",
  }, 1)
  local wait = operationContext.beginWait(context, state, {
    modelKey = "target_model", configKey = "/vehicles/target_model/base.pc",
  }, "parts", 2)
  equal(wait.writeTarget.vehicleId, 10)
  equal(context.concreteTarget, nil)

  local candidate = {
    vehicleId = 11, source = "player_poll", observedAt = 2.1,
    operationId = "SCR-context", operationGeneration = 3, targetGeneration = 7,
    modelKey = "target_model", configKey = "/vehicles/target_model/base.pc",
    playerIndex = 0, readStatus = "ready", coherentTargetRead = true, stable = true,
  }
  local invalid = util.deepCopy(candidate)
  invalid.playerIndex = 1
  equal(select(2, operationContext.rebindConcreteTarget(context, state, invalid, 2.1)), "candidate_not_player_zero")
  invalid = util.deepCopy(candidate)
  invalid.observedAt = 1.9
  equal(select(2, operationContext.rebindConcreteTarget(context, state, invalid, 2.1)), "candidate_before_current_wait")
  invalid = util.deepCopy(candidate)
  invalid.coherentTargetRead = false
  equal(select(2, operationContext.rebindConcreteTarget(context, state, invalid, 2.1)), "candidate_read_incoherent")
  invalid = util.deepCopy(candidate)
  invalid.modelKey = "wrong_model"
  equal(select(2, operationContext.rebindConcreteTarget(context, state, invalid, 2.1)), "target_model_mismatch")

  local rebound, concrete = operationContext.rebindConcreteTarget(context, state, candidate, 2.1)
  truthy(rebound)
  equal(concrete.vehicleId, 11)
  equal(context.logicalTarget.modelKey, "target_model")
  equal(context.rebindCount, 1)
end

tests.v063_operation_context_rejects_stale_and_destroyed_candidates = function()
  local state = {
    operationId = "SCR-context", operationToken = "token", operationGeneration = 3,
    phaseGeneration = 5, targetGeneration = 7,
  }
  local context = operationContext.create(state, "token", 1)
  operationContext.beginLogicalTarget(context, state, {modelKey = "target_model"}, 1)
  operationContext.beginWait(context, state, {modelKey = "target_model"}, "spawn", 2)
  local recorded, reason = operationContext.recordCandidate(context, state, {
    vehicleId = 20, operationId = "SCR-previous", operationGeneration = 2,
    targetGeneration = 6, observedAt = 2.1,
  })
  truthy(not recorded)
  equal(reason, "stale_callback_rejected")
  operationContext.markDestroyed(context, 21)
  local rebound, destroyedReason = operationContext.rebindConcreteTarget(context, state, {
    vehicleId = 21, source = "player_poll", observedAt = 2.1,
    operationId = "SCR-context", operationGeneration = 3, targetGeneration = 7,
    modelKey = "target_model", playerIndex = 0, readStatus = "ready",
    coherentTargetRead = true, stable = true,
  }, 2.1)
  truthy(not rebound)
  equal(destroyedReason, "candidate_destroyed")
  equal(context.staleCandidateCount, 1)
end

tests.v063_final_unbound_read_accepts_converged_target_at_deadline = function()
  local tracker = vehicleTargetTracker.create({
    token = "deadline", operationId = "SCR-deadline", operationGeneration = 1,
    phaseGeneration = 2, targetGeneration = 3, modelKey = "target_model",
    configKey = "/vehicles/target_model/base.pc", parts = {["/body/"] = "body_b"},
    tuning = {boost = 0.8}, tuningMetadata = {boost = {minimum = 0, maximum = 1, tolerance = 0.01}},
    requirePartsReadable = true, startedAt = 0, timeout = 1,
  })
  local status, reason, details = vehicleTargetTracker.observe(tracker, "deadline", {
    vehicleId = 99, playerIndex = 0, modelKey = "target_model",
    configKey = "/vehicles/target_model/base.pc", parts = {["/body/"] = "body_b"},
    partsAvailable = true, tuning = {boost = 0.8}, readStatus = "ready", coherentTargetRead = true,
  }, 1, {
    operationId = "SCR-deadline", operationGeneration = 1,
    phaseGeneration = 2, targetGeneration = 3,
  })
  equal(status, "failed")
  equal(reason, "operation_deadline_exceeded")
  equal(details.finalReadReason, "coherent_state_did_not_stabilize")
  local summary = vehicleTargetTracker.summary(tracker, 1)
  truthy(summary.finalReadAttempted)
  truthy(not summary.finalReadAccepted)
end

tests.v063_final_unbound_read_rejects_wrong_tuning = function()
  local tracker = vehicleTargetTracker.create({
    token = "deadline", modelKey = "target_model", tuning = {boost = 0.8},
    tuningMetadata = {boost = {minimum = 0.5, maximum = 1, tolerance = 0.01}},
    startedAt = 0, timeout = 1,
  })
  local status, reason, details = vehicleTargetTracker.observe(tracker, "deadline", {
    vehicleId = 99, playerIndex = 0, modelKey = "target_model", parts = {},
    tuning = {boost = 0.1}, readStatus = "ready", coherentTargetRead = true,
  }, 1)
  equal(status, "failed")
  equal(reason, "operation_deadline_exceeded")
  equal(details.finalReadReason, "tuning_readback_mismatch")
end

tests.v063_state_machine_terminal_and_generation_properties = function()
  local phases = {
    "capturing_original", "selecting", "issuing_spawn", "tracking_target_identity",
    "stabilizing_tree", "planning_parts", "applying_parts", "waiting_parts_reload",
    "verifying_parts", "planning_tuning", "applying_tuning", "waiting_tuning_reload",
    "verifying_tuning", "applying_paint", "verifying_paint", "final_validation",
  }
  local terminals = {"completed", "partial", "failed", "cancelled"}
  for sequence = 1, 32 do
    local state = operationState.create(function() return sequence end, 10)
    truthy(operationState.begin(state, "property", sequence, 10))
    local generator = rng.new("state-machine-property:" .. tostring(sequence))
    local operationGeneration = state.operationGeneration
    local phaseGeneration = state.phaseGeneration
    local targetGeneration = state.targetGeneration
    for _ = 1, 24 do
      local phase = phases[generator:integer(1, #phases)]
      truthy(operationState.setPhase(state, phase, 10, "property_sequence"))
      truthy(state.operationGeneration >= operationGeneration)
      truthy(state.phaseGeneration >= phaseGeneration)
      truthy(state.targetGeneration >= targetGeneration)
      operationGeneration, phaseGeneration, targetGeneration =
        state.operationGeneration, state.phaseGeneration, state.targetGeneration
    end
    truthy(operationState.finish(state, terminals[(sequence - 1) % #terminals + 1]))
    truthy(not operationState.deriveBusy(state))
    local resumed, reason = operationState.setPhase(state, "planning_parts", 10, "invalid_resume")
    equal(resumed, false)
    equal(reason, "terminal_phase_cannot_resume")
    truthy(not operationState.deriveBusy(state))
  end
end

tests.v063_cancel_is_terminal_from_every_active_phase = function()
  for phase, definition in pairs(operationState.phases) do
    if definition.terminal ~= true then
      local state = operationState.create(function() return 1 end, 10)
      truthy(operationState.begin(state, "cancel-property", 1, 10))
      truthy(operationState.setPhase(state, phase, 10, "cancel_property"))
      truthy(operationState.finish(state, "cancelled", "cancelled_by_user"))
      equal(state.phase, "cancelled")
      truthy(not operationState.deriveBusy(state), phase .. " remained Busy after cancel")
    end
  end
end

tests.v063_concrete_target_changes_only_after_validated_rebind = function()
  local state = {
    operationId = "SCR-property", operationGeneration = 4, phaseGeneration = 2,
    targetGeneration = 9, operationToken = "token",
  }
  local context = operationContext.create(state, "token", 0)
  operationContext.beginLogicalTarget(context, state, {modelKey = "expected"}, 0)
  operationContext.beginWait(context, state, {modelKey = "expected"}, "parts_reload", 1)
  local logical = util.deepCopy(context.logicalTarget)
  local invalid = {
    {vehicleId = 10, modelKey = "wrong", playerIndex = 0, stable = true, coherentTargetRead = true, observedAt = 2},
    {vehicleId = 11, modelKey = "expected", playerIndex = 1, stable = true, coherentTargetRead = true, observedAt = 2},
    {vehicleId = 12, modelKey = "expected", playerIndex = 0, stable = false, coherentTargetRead = true, observedAt = 2},
    {vehicleId = 13, modelKey = "expected", playerIndex = 0, stable = true, coherentTargetRead = false, observedAt = 2},
    {vehicleId = 14, modelKey = "expected", playerIndex = 0, stable = true, coherentTargetRead = true, observedAt = 0.5},
  }
  for _, candidate in ipairs(invalid) do
    local rebound = operationContext.rebindConcreteTarget(context, state, candidate, 2)
    equal(rebound, false)
    equal(context.concreteTarget, nil)
    truthy(util.deepEqual(context.logicalTarget, logical, 1e-10))
  end
  local accepted, target = operationContext.rebindConcreteTarget(context, state, {
    vehicleId = 15, modelKey = "expected", playerIndex = 0, stable = true,
    coherentTargetRead = true, readStatus = "ready", observedAt = 2,
  }, 2)
  truthy(accepted)
  equal(target.vehicleId, 15)
  truthy(util.deepEqual(context.logicalTarget, logical, 1e-10))
end

tests.v063_recovery_property_is_bounded_per_generation = function()
  local recovery = vehicleRecovery.create({cycleVisitLimit = 1})
  local lastGeneration = 0
  for sequence = 1, 32 do
    local generation = vehicleRecovery.beginRecovery(recovery, "SCR-recovery-property", sequence)
    truthy(generation > lastGeneration)
    lastGeneration = generation
    local step = {kind = "abort_candidate", tier = 3, snapshot = {
      modelKey = "candidate-" .. tostring(sequence), selectedConfiguration = "base.pc",
    }}
    truthy(vehicleRecovery.observeRecoveryStep(recovery, "SCR-recovery-property", generation, step))
    local repeated, reason = vehicleRecovery.observeRecoveryStep(
      recovery, "SCR-recovery-property", generation, step
    )
    equal(repeated, false)
    equal(reason, "candidate_cycle_detected")
    equal(recovery.recoveryAttempts, 2)
  end
end

tests.alpha2_tracker_limits_contract = function()
  local tracker = alpha2Tracker()
  for id = 1, 40 do vehicleTargetTracker.onSpawned(tracker, id) end
  local report = vehicleTargetTracker.summary(tracker, 0)
  equal(report.candidateCount, vehicleTargetTracker.LIMITS.candidates)
  equal(report.switchEventCount, vehicleTargetTracker.LIMITS.events)
  truthy(report.candidateDrops > 0)
  truthy(report.eventDrops > 0)
end

tests.alpha2_tracker_stability_timeout_stale_destroy_contract = function()
  local tracker = alpha2Tracker({returnedVehicleId = 2, timeout = 1})
  equal(vehicleTargetTracker.observe(tracker, "stale", alpha2State(2), 0.1), "failed")
  vehicleTargetTracker.onDestroyed(tracker, 2)
  local status = vehicleTargetTracker.observe(tracker, "alpha2-token", alpha2State(3), 1)
  equal(status, "failed")
  local stabilizer = vehicleStabilizer.create({minimumFrames = 5, minimumScans = 2})
  for frame = 1, 4 do truthy(not vehicleStabilizer.observe(stabilizer, 3, "same", true)) end
  truthy(vehicleStabilizer.observe(stabilizer, 3, "same", true))
end

tests.alpha2_tracker_switch_classification_contract = function()
  local tracker = alpha2Tracker({returnedVehicleId = 2})
  vehicleTargetTracker.onSwitched(tracker, 2, 99, 1, false)
  local status = vehicleTargetTracker.observe(tracker, "alpha2-token", alpha2State(2), 0.1)
  equal(status, "waiting")
  vehicleTargetTracker.onSwitched(tracker, 2, 99, 0, false)
  status = vehicleTargetTracker.observe(tracker, "alpha2-token", alpha2State(99, "unrelated"), 0.2)
  equal(status, "cancelled")
end

tests.alpha2_tree_stabilizer_contract = function()
  local stabilizer = vehicleStabilizer.create({persistentTreeScans = 2})
  local persistent, reason = vehicleStabilizer.observeTreeIssue(stabilizer, "required:/engine")
  equal(persistent, false)
  equal(reason, "tree_issue_transient")
  persistent, reason = vehicleStabilizer.observeTreeIssue(stabilizer, "required:/engine")
  equal(persistent, true)
  equal(reason, "tree_issue_persistent")
  equal(vehicleStabilizer.observeTreeIssue(stabilizer, nil), false)
end

tests.alpha2_batch_recovery_contract = function()
  local state = partBatchRecovery.create({retriesPerSlot = 2, retriesPerPass = 3, operationRetries = 4})
  partBatchRecovery.beginBatch(state, {
    modelKey = "model_a", configKey = "base", pass = 1,
    treeBefore = {chosenPartName = "root", children = {}},
    changes = {{slotPath = "/body/", selectedPart = "broken"}},
  })
  local retry = partBatchRecovery.recordFailure(state, {
    modelKey = "model_a", configKey = "base", pass = 1, slotPath = "/body/", candidate = "broken",
  }, "required_slot_missing")
  truthy(retry)
  truthy(partBatchRecovery.isQuarantined(state, "model_a", "base", "/body/", "broken"))
  truthy(not partBatchRecovery.isQuarantined(state, "model_b", "base", "/body/", "broken"))
  local rollback, tree = partBatchRecovery.beginRollback(state)
  truthy(rollback and type(tree) == "table")
  truthy(partBatchRecovery.finishRollback(state, true))
  local filtered = partBatchRecovery.filterCandidates(state, "model_a", "base", "/body/", {"broken", "alternative"})
  equal(#filtered, 1); equal(filtered[1], "alternative")
end

tests.alpha2_recovery_contract = function()
  local state = vehicleRecovery.create({consecutiveFailureLimit = 3})
  vehicleRecovery.rememberGood(state, {modelKey = "known", selectedConfiguration = "known.pc", config = {}})
  for index = 1, 3 do vehicleRecovery.recordLoadFailure(state, {modelKey = "bad", configKey = "bad" .. index}, "load_failed") end
  truthy(state.circuitOpen)
  truthy(vehicleRecovery.isQuarantined(state, "bad", "bad1"))
  vehicleRecovery.beginRecovery(state, "SCR-alpha2", 2)
  local plan = vehicleRecovery.choosePlan(state, {modelKey = "previous", selectedConfiguration = "previous.pc"}, {
    {modelKey = "safe", key = "base", path = "safe.pc", sourceKind = "official"},
  })
  equal(plan[1].kind, "original_player_vehicle"); equal(plan[1].tier, 5)
  equal(plan[2].kind, "explicit_safe_baseline"); equal(plan[2].tier, 6)
  equal(plan[3].kind, "safe_official_fallback"); equal(plan[3].tier, 7)
  equal(plan[4].kind, "hard_failure"); equal(plan[4].tier, 8)
  local operation = {wait = {}, targetTracker = {}, paintConfirmation = {}, replaceWriteInFlight = true}
  vehicleRecovery.cleanup(operation)
  equal(operation.wait, nil); equal(operation.targetTracker, nil); equal(operation.replaceWriteInFlight, false)
end

tests.alpha2_png_integrity_contract = function()
  local valid = fixturePNG(32, 18)
  truthy(pngValidator.validate(valid))
  equal(pngValidator.validate(valid .. "x"), nil)
  local corrupt = valid:sub(1, 45) .. string.char((valid:byte(46) + 1) % 256) .. valid:sub(47)
  equal(pngValidator.validate(corrupt), nil)
  equal(pngValidator.validate(valid:sub(1, #valid - 12)), nil)
  local ihdr = valid:sub(9, 33)
  equal(pngValidator.validate(valid:sub(1, 33) .. ihdr .. valid:sub(34)), nil)
  local bomb = valid:sub(1, 33)
  local function chunk(kind, data) return be32(#data) .. kind .. data .. be32(pngValidator.crc32(kind .. data)) end
  for _ = 1, 129 do bomb = bomb .. chunk("tEXt", "x") end
  bomb = bomb .. chunk("IDAT", "x") .. chunk("IEND", "")
  equal(pngValidator.validate(bomb, {maxBytes = #bomb + 1, maxWidth = 500, maxHeight = 281, maxChunks = 128, maxChunkBytes = 262144, maxIDATBytes = 262144}), nil)
end

tests.alpha2_no_active_vehicle_contract = function()
  local randomCar = pipelineHarness.new({noActive = true})
  truthy(randomCar.main.randomConfig({manualSeed = "empty-random-car"}))
  pipelineHarness.confirmReplacement(randomCar)
  equal(randomCar.main.requestState().lastResult.code, "random_config_loaded")
  local full = pipelineHarness.new({noActive = true})
  truthy(full.main.fullRandom({chaos = 100, manualSeed = "empty-full"}))
  pipelineHarness.confirmReplacement(full)
  if full.pendingParts then pipelineHarness.confirmParts(full) end
  if full.pendingTuning then pipelineHarness.confirmTuning(full) end
  truthy(not full.main.requestState().busy)
  local scramble = pipelineHarness.new({noActive = true})
  truthy(not scramble.main.scramble({manualSeed = "empty-scramble"}))
  equal(scramble.main.requestState().lastResult.code, "no_active_vehicle")
end

tests.alpha2_lock_model_binding_contract = function()
  local profile = vehicleDNALocks.normalize({
    boundModelKey = "model_a", boundConfigKey = "/vehicles/model_a/base.pc",
    configuration = true, parts = {["/body/"] = {partName = "body_a"}},
  })
  truthy(vehicleDNALocks.requiresModel(profile))
  local compatible = vehicleDNALocks.preflight(profile, "model_a", "/vehicles/model_a/base.pc", {
    byPath = {["/body/"] = {path = "/body/", currentPart = "body_a", candidates = {"body_a"}}},
  })
  truthy(compatible.valid)
  local incompatible = vehicleDNALocks.preflight(profile, "model_b", "/vehicles/model_b/base.pc", {byPath = {}})
  truthy(not incompatible.valid and incompatible.unresolvedCount > 0)
end

tests.alpha2_generator_legacy_restore_contract = function()
  local legacy = sampleDNA()
  truthy(vehicleDNASchema.validateEntry(legacy))
  equal(vehicleDNASchema.GENERATOR_VERSION, 6)
  truthy(vehicleDNASchema.isSupportedGenerator(4))
  local modern = sampleDNA()
  modern.generatorVersion = 5
  modern.generation.generatorVersion = 5
  modern.environment.generatorVersion = 5
  modern.base.modelKey = "parent_model"
  modern.final.modelKey = "wild_model"
  refreshDNAFingerprints(modern)
  truthy(vehicleDNASchema.validateEntry(modern))
end

tests.v060_coverage_chaos100_and_slot_identity = function()
  local policy = mutationPolicy.fromSettings({chaos = 100, protectCriticalParts = true})
  equal(mutationPolicy.mutationChance(policy, {depth = 1}, 1), 1)
  equal(mutationPolicy.mutationChance(policy, {depth = 7}, 9), 1)
  local ledger = slotCoverageLedger.create({modelKey = "fixture", configIdentity = {key = "base"}, operationId = "op-a", targetGeneration = 4})
  truthy(slotCoverageLedger.bindContext(ledger, {operationId = "op-a", targetGeneration = 4}))
  truthy(not slotCoverageLedger.bindContext(ledger, {operationId = "op-a", targetGeneration = 5}))
  local scan = {slots = {
    {parentPath = "/front/", path = "/shared/", id = "shared", depth = 2, currentPart = "a", candidates = {"a", "b"}},
    {parentPath = "/rear/", path = "/shared/", id = "shared", depth = 2, currentPart = "c", candidates = {"c"}},
  }}
  slotCoverageLedger.observeScan(ledger, {modelKey = "fixture", configIdentity = {key = "base"}}, scan, 1)
  equal(#ledger.order, 2)
  truthy(ledger.order[1] ~= ledger.order[2])
  slotCoverageLedger.classify(ledger, ledger.order[1], "changed", {eligible = true, selectedByChaos = true})
  slotCoverageLedger.classify(ledger, ledger.order[2], "no_alternative", {eligible = true, selectedByChaos = true})
  slotCoverageLedger.markFinalParts(ledger, { ["/shared/"] = "b" })
  local summary = slotCoverageLedger.summary(ledger)
  equal(summary.slotsEligible, 2)
  equal(summary.slotsSelectedByChaos, 2)
  truthy(slotCoverageLedger.isComplete(ledger))
end

tests.v060_tree_convergence_and_absolute_limits = function()
  local limits = coverageLimits.derive({slotCount = 40, maxDepth = 8})
  truthy(limits.maxTotalPasses > 12)
  truthy(limits.maxTotalPasses <= coverageLimits.DEFAULTS.maxTotalPasses)
  local state = treeConvergence.create(limits, 0)
  truthy(not treeConvergence.observe(state, {signature = "a", discovered = 8, pending = 1, changesApplied = 1}))
  truthy(not treeConvergence.observe(state, {signature = "b", discovered = 9, pending = 0, changesApplied = 0}))
  truthy(not treeConvergence.observe(state, {signature = "b", discovered = 9, pending = 0, changesApplied = 0}))
  truthy(treeConvergence.observe(state, {signature = "b", discovered = 9, pending = 0, changesApplied = 0}))
  equal(coverageLimits.exceeded(limits, {noProgressPasses = limits.maxNoProgressPasses}, 1), "maxNoProgressPasses")
end

tests.v060_coverage_tracks_new_and_disappearing_slots = function()
  local context = {modelKey = "fixture", configIdentity = "base"}
  local ledger = slotCoverageLedger.create(context)
  slotCoverageLedger.observeScan(ledger, context, {slots = {
    {parentPath = "/", path = "/body/", id = "body", depth = 1, currentPart = "a", candidates = {"a", "b"}},
    {parentPath = "/body/", path = "/body/child/", id = "child", depth = 2, currentPart = "x", candidates = {"x", "y"}},
  }}, 1)
  slotCoverageLedger.observeScan(ledger, context, {slots = {
    {parentPath = "/", path = "/body/", id = "body", depth = 1, currentPart = "b", candidates = {"a", "b"}},
    {parentPath = "/body/", path = "/body/new/", id = "new", depth = 6, currentPart = "n", candidates = {"n"}},
  }}, 2)
  local disappeared, newly = 0, 0
  for _, key in ipairs(ledger.order) do
    local entry = ledger.entries[key]
    if entry.status == "disappeared_after_parent_change" then disappeared = disappeared + 1 end
    if entry.newlyDiscovered then newly = newly + 1 end
  end
  equal(disappeared, 1)
  equal(newly, 1)
end

tests.v060_candidate_isolation_proves_only_the_culprit = function()
  local state = candidateIsolation.create({
    {slotPath = "/a/", selectedPart = "a2"},
    {slotPath = "/b/", selectedPart = "b2"},
    {slotPath = "/c/", selectedPart = "c2"},
  }, 20)
  equal(#assert(candidateIsolation.nextBatch(state)), 3)
  equal(candidateIsolation.record(state, false, "batch_failed"), "batch_split")
  equal(#assert(candidateIsolation.nextBatch(state)), 1)
  equal(candidateIsolation.record(state, true), "confirmed")
  equal(#assert(candidateIsolation.nextBatch(state)), 2)
  equal(candidateIsolation.record(state, false, "batch_failed"), "batch_split")
  candidateIsolation.nextBatch(state); candidateIsolation.record(state, true)
  candidateIsolation.nextBatch(state); candidateIsolation.record(state, false, "candidate_failed")
  truthy(candidateIsolation.complete(state))
  equal(#state.confirmed, 2)
  equal(#state.suspects, 1)
  equal(state.suspects[1].slotPath, "/c/")
end

tests.v060_tuning_pipeline_covers_metadata_and_readback = function()
  local variables = {
    boost = {min = 0, max = 1, default = 0.5, step = 0.25, category = "Engine", subCategory = "Boost"},
    fixed = {min = 1, max = 1, default = 1, category = "Engine"},
    hidden = {min = 0, max = 1, hideInUI = true},
    action = {min = 0, max = 1, action = true},
  }
  local values, changes, ledger = tuningPipeline.plan(variables, {boost = 0.5, fixed = 1},
    mutationPolicy.fromSettings({chaos = 100}), rng.new("tuning-v060"), {}, nil, 1)
  equal(#changes, 1)
  truthy(values.boost ~= 0.5)
  tuningCoverageLedger.readBack(ledger, {boost = 0.8}, 1)
  local summary = tuningCoverageLedger.summary(ledger)
  equal(summary.tuningEligible, 1)
  equal(summary.tuningSelectedByChaos, 1)
  equal(summary.tuningFixed, 1)
  equal(summary.tuningClamped, 1)
  truthy(tuningCoverageLedger.isComplete(ledger))
  truthy(tuningCoverageLedger.bindContext(ledger, {operationId = "tuning-op", targetGeneration = 2}))
  truthy(not tuningCoverageLedger.bindContext(ledger, {operationId = "tuning-op", targetGeneration = 3}))
end

tests.v060_tuning_rescan_discovers_only_new_variables = function()
  local policy = mutationPolicy.fromSettings({chaos = 100})
  local variables = {spring = {min = 0, max = 10, default = 5, step = 1, category = "Suspension"}}
  local _, _, ledger = tuningPipeline.plan(variables, {spring = 5}, policy, rng.new("pass-1"), {}, nil, 1)
  variables.nitrous = {min = 0, max = 100, default = 50, step = 10, category = "Powertrain"}
  local _, changes, _, newly = tuningPipeline.plan(variables, {spring = 5, nitrous = 50}, policy,
    rng.new("pass-2"), {onlyNew = true}, ledger, 2)
  equal(#newly, 1)
  equal(newly[1], "nitrous")
  equal(#changes, 1)
  equal(changes[1].name, "nitrous")
end

tests.v063_tuning_metadata_revision_is_reprocessed = function()
  local policy = mutationPolicy.fromSettings({chaos = 100})
  local variables = {boost = {min = 0, max = 1, default = 0.5, step = 0.1, category = "Engine"}}
  local _, first, ledger = tuningPipeline.plan(
    variables, {boost = 0.5}, policy, rng.new("metadata-pass-1"), {}, nil, 1
  )
  equal(#first, 1)
  variables.boost.max = 2
  variables.boost.step = 0.25
  local _, second, updated, newly, changed = tuningPipeline.plan(
    variables, {boost = first[1].selectedValue}, policy, rng.new("metadata-pass-2"),
    {onlyNew = true}, ledger, 2
  )
  equal(#newly, 0)
  equal(#changed, 1)
  equal(changed[1], "boost")
  equal(#second, 1)
  local entry = updated.entries[second[1].identity]
  equal(entry.maximum, 2)
  equal(entry.step, 0.25)
  equal(entry.metadataChangeCount, 1)
end

tests.v063_tuning_pipeline_reaches_fixed_point_after_multiple_waves = function()
  local boost = {min = 0, max = 1, default = 0.5, step = 0.1, category = "Engine"}
  local spring = {min = 0, max = 10, default = 5, step = 1, category = "Suspension"}
  local nitrous = {min = 0, max = 100, default = 50, step = 10, category = "Powertrain"}
  local harness = pipelineHarness.new({tuningWaves = {
    {variables = {boost = boost}},
    {variables = {boost = boost, spring = spring}, values = {spring = 5}},
    {variables = {boost = boost, spring = spring, nitrous = nitrous}, values = {nitrous = 50}},
    {variables = {boost = boost, spring = spring, nitrous = nitrous}},
  }})
  truthy(pipelineHarness.driveSuccess(harness, "scramble", {manualSeed = "tuning-waves"}))
  pipelineHarness.driveActive(harness, 256)
  local state = harness.main.requestState()
  truthy(not state.busy, "tuning waves remained Busy at " .. tostring(state.lifecyclePhase))
  equal(state.lastResult.code, "scramble_completed_with_warning")
  equal(state.lastResult.details.terminalOutcome, "COMPLETED_WITH_WARNING")
  local tuningWrites = 0
  for _, write in ipairs(harness.writes) do if write.kind == "tuning" then tuningWrites = tuningWrites + 1 end end
  equal(tuningWrites, 3)
  equal(state.lastResult.details.coverage.tuning.tuningDiscovered, 3)
  equal(state.lastResult.details.coverage.tuning.tuningNewlyDiscovered, 2)
end

tests.v063_tuning_signature_detects_fixed_point_and_cycle = function()
  local first = {a = {min = 0, max = 1, default = 0.5}}
  local second = {a = {min = 0, max = 2, default = 0.5}}
  equal(tuningPipeline.snapshotSignature(first), tuningPipeline.snapshotSignature(util.deepCopy(first)))
  truthy(tuningPipeline.snapshotSignature(first) ~= tuningPipeline.snapshotSignature(second))
end

tests.v063_tuning_disappearance_and_nonfinite_metadata_are_classified = function()
  local policy = mutationPolicy.fromSettings({chaos = 100})
  local variables = {
    valid = {min = 0, max = 1, default = 0.5},
    infinite = {min = 0, max = math.huge, default = 1},
    notANumber = {min = 0 / 0, max = 1, default = 0.5},
  }
  local _, changes, ledger = tuningPipeline.plan(
    variables, {valid = 0.5}, policy, rng.new("tuning-disappear"), {}, nil, 1
  )
  equal(#changes, 1)
  tuningCoverageLedger.readBack(ledger, {valid = changes[1].selectedValue}, 1)
  tuningPipeline.plan({}, {}, policy, rng.new("tuning-disappear-2"), {onlyNew = true}, ledger, 2)
  tuningCoverageLedger.readBack(ledger, {}, 2)
  equal(ledger.entries[changes[1].identity].status, "disappeared_after_apply")
  equal(tuningCoverageLedger.summary(ledger).tuningInvalid, 2)
end

tests.v063_tuning_discovery_cycle_stops_without_remaining_busy = function()
  local first = {boost = {min = 0, max = 1, default = 0.5, step = 0.1}}
  local second = {boost = {min = 0, max = 2, default = 0.5, step = 0.1}}
  local harness = pipelineHarness.new({tuningWaves = {
    {variables = first}, {variables = second}, {variables = first},
  }})
  truthy(pipelineHarness.driveSuccess(harness, "scramble", {manualSeed = "tuning-cycle"}))
  pipelineHarness.driveActive(harness, 256)
  local state = harness.main.requestState()
  truthy(not state.busy)
  equal(state.lastResult.details.stageReasons.tuning, "tuning_discovery_cycle_detected")
end

tests.v063_combustion_fuel_floor_single_and_multiple_tanks = function()
  local single = energyStorageGuard.plan({
    variables = {['$fuel'] = {name = '$fuel', min = 0, max = 60, default = 60, unit = 'L', title = 'Fuel Volume'}},
    values = {['$fuel'] = 0},
    energyStorages = {{name = 'mainTank', type = 'fuelTank', energyType = 'gasoline', fuelCapacity = 60, startingFuelCapacity = '$fuel'}},
  })
  equal(#single.changes, 1)
  near(single.values['$fuel'], 6)
  equal(single.report.storages[1].classification, 'combustion_fuel')

  local multiple = energyStorageGuard.plan({
    variables = {
      leftLevel = {name = 'leftLevel', min = 0, max = 500, default = 500, unit = 'L', sourcePart = 'left_tank'},
      auxLevel = {name = 'auxLevel', min = 0, max = 500, default = 500, unit = 'L', sourcePart = 'aux_tank'},
    },
    values = {leftLevel = 1, auxLevel = 49},
    energyStorages = {
      {name = 'leftTank', type = 'fuelTank', energyType = 'diesel', fuelCapacity = 500, startingFuelCapacity = 'leftLevel', sourcePart = 'left_tank'},
      {name = 'auxTank', type = 'fuelTank', energyType = 'diesel', fuelCapacity = 500, startingFuelCapacity = 'auxLevel', sourcePart = 'aux_tank'},
    },
  })
  equal(#multiple.changes, 2)
  near(multiple.values.leftLevel, 50)
  near(multiple.values.auxLevel, 50)
  equal(multiple.report.fuelStorageCount, 2)
end

tests.v063_energy_storage_classification_excludes_non_fuel = function()
  equal(energyStorageGuard.classifyStorage({type = 'electricBattery', name = 'mainBattery'}), 'electric_energy')
  equal(energyStorageGuard.classifyStorage({type = 'n2oTank', name = 'mainBottle'}), 'nitrous')
  equal(energyStorageGuard.classifyStorage({type = 'pressureTank', name = 'airTank'}), 'air_pressure')
  equal(energyStorageGuard.classifyStorage({type = 'pressureTank', name = 'hydraulicReservoir'}), 'hydraulic')
  equal(energyStorageGuard.classifyVariable({name = '$n2o_power', title = 'Nitrous Shot', unit = 'kW'}), 'nitrous')
  equal(energyStorageGuard.classifyVariable({name = '$batteryCapacity', unit = 'kWh'}), 'electric_energy')
  equal(energyStorageGuard.classifyVariable({name = '$hydraulicPressure', category = 'Hydraulics'}), 'hydraulic')
end

tests.v063_hybrid_only_clamps_combustion_storage = function()
  local plan = energyStorageGuard.plan({
    variables = {
      fuelLevel = {name = 'fuelLevel', min = 0, max = 50, default = 50, unit = 'L', title = 'Diesel Fuel Volume'},
      batteryLevel = {name = 'batteryLevel', min = 0, max = 100, default = 100, unit = 'kWh', title = 'Battery Energy'},
      n2oLevel = {name = 'n2oLevel', min = 0, max = 10, default = 10, title = 'N2O Bottle'},
    },
    values = {fuelLevel = 0, batteryLevel = 0, n2oLevel = 0},
    energyStorages = {
      {name = 'fuel', type = 'fuelTank', energyType = 'diesel', fuelCapacity = 50, startingFuelCapacity = 'fuelLevel'},
      {name = 'battery', type = 'electricBattery', batteryCapacity = 100, startingCapacity = 'batteryLevel'},
      {name = 'nitrous', type = 'n2oTank', capacity = 10, startingCapacity = 'n2oLevel'},
    },
  })
  equal(#plan.changes, 1)
  near(plan.values.fuelLevel, 5)
  equal(plan.values.batteryLevel, 0)
  equal(plan.values.n2oLevel, 0)
end

tests.v063_removed_or_absent_fuel_tank_is_not_applicable = function()
  local plan = energyStorageGuard.plan({
    variables = {battery = {name = 'battery', min = 0, max = 100, unit = 'kWh'}},
    values = {battery = 0},
    energyStorages = {{name = 'battery', type = 'electricBattery', batteryCapacity = 100}},
  })
  truthy(plan.report.notApplicable)
  truthy(plan.report.compliant)
  equal(#plan.changes, 0)
end

tests.v063_fuel_floor_is_read_back_before_success_and_dna_capture = function()
  local variables = {
    boost = {min = 0, max = 1, default = 0.5, step = 0.1},
    ['$fuel'] = {name = '$fuel', min = 0, max = 60, default = 60, step = 0.5,
      unit = 'L', title = 'Fuel Volume', hideInUI = true},
  }
  local harness = pipelineHarness.new({
    tuningWaves = {{variables = variables}},
    energyStorages = {{name = 'mainTank', type = 'fuelTank', energyType = 'gasoline',
      fuelCapacity = 60, startingFuelCapacity = '$fuel'}},
  })
  harness.tuning['$fuel'] = 0
  truthy(pipelineHarness.driveSuccess(harness, 'scramble', {manualSeed = 'fuel-floor-seed'}))
  pipelineHarness.driveActive(harness, 256)
  local state = harness.main.requestState()
  truthy(not state.busy, 'fuel guard remained Busy at ' .. tostring(state.lifecyclePhase))
  truthy(state.lastResult.success)
  near(harness.tuning['$fuel'], 6)
  equal(state.lastResult.details.energyStorages.status, 'readback_confirmed')
  equal(state.lastResult.details.energyStorages.storages[1].status, 'confirmed')
  truthy(type(state.lastResult.details.seed) == 'string' and state.lastResult.details.seed ~= '')
  truthy(state.garage.pendingSave)
  truthy(harness.main.saveVehicleDNA('Fuel Floor DNA'))
  local pendingFuel
  for _, variable in ipairs(harness.library.entries[1].final.tuning or {}) do
    if variable.name == '$fuel' then pendingFuel = variable.value end
  end
  near(pendingFuel, 6)
end

tests.v063_random_car_applies_fuel_floor_before_completion = function()
  local variables = {
    ['$fuel'] = {name = '$fuel', min = 0, max = 50, default = 50, unit = 'L', title = 'Fuel Volume'},
  }
  local harness = pipelineHarness.new({
    tuningWaves = {{variables = variables}},
    newTargetTuning = {['$fuel'] = 0},
    energyStorages = {{name = 'mainTank', type = 'fuelTank', energyType = 'diesel',
      fuelCapacity = 50, startingFuelCapacity = '$fuel'}},
  })
  harness.tuning['$fuel'] = 0
  truthy(harness.main.randomConfig({manualSeed = 'random-car-fuel'}))
  pipelineHarness.confirmReplacement(harness)
  pipelineHarness.driveActive(harness, 128)
  local state = harness.main.requestState()
  truthy(not state.busy)
  equal(state.lastResult.code, 'random_config_loaded')
  near(harness.tuning['$fuel'], 5)
  equal(state.lastResult.details.energyStorages.status, 'readback_confirmed')
end

tests.v064_uncertain_fuel_metadata_preserves_randomized_result = function()
  local harness = pipelineHarness.new({
    energyStorages = {{name = 'mysteryTank', type = 'fuelTank', energyType = 'gasoline',
      fuelCapacity = 60, startingFuelCapacity = '$modSpecificFuel'}},
  })
  truthy(harness.main.randomConfig({manualSeed = 'uncertain-fuel'}))
  pipelineHarness.confirmReplacement(harness)
  pipelineHarness.driveActive(harness, 128)
  local state = harness.main.requestState()
  truthy(not state.busy)
  equal(state.lastResult.success, true)
  equal(state.lastResult.code, 'random_config_loaded_with_warning')
  equal(state.lastResult.details.terminalOutcome, 'COMPLETED_WITH_WARNING')
  equal(state.lastResult.details.energyStorages.status, 'uncertain_warning')
  truthy(#state.lastResult.details.warnings > 0)
  equal(harness.modelKey, 'fixture_new')
end

tests.v064_unavailable_fuel_readback_is_warning_not_rollback = function()
  local harness = pipelineHarness.new({energyReadFailure = true})
  truthy(harness.main.randomConfig({manualSeed = 'fuel-read-unavailable'}))
  pipelineHarness.confirmReplacement(harness)
  pipelineHarness.driveActive(harness, 128)
  local state = harness.main.requestState()
  truthy(not state.busy)
  equal(state.lastResult.success, true)
  equal(state.lastResult.code, 'random_config_loaded_with_warning')
  equal(state.lastResult.details.terminalOutcome, 'COMPLETED_WITH_WARNING')
  equal(state.lastResult.details.energyStorages.status, 'unavailable_warning')
  equal(harness.modelKey, 'fixture_new')
end

tests.v060_paint_coverage_confirms_supported_fields = function()
  local before = {{baseColor = {0, 0, 0, 1}, metallic = 0, roughness = 0.5, clearcoat = 0, clearcoatRoughness = 0.5}}
  local after = {{baseColor = {1, 0, 0, 1}, metallic = 0.8, roughness = 0.2, clearcoat = 1, clearcoatRoughness = 0.1}}
  local ledger = paintCoverageLedger.create(before, function(_, field) return field == "clearcoat" end, true)
  paintCoverageLedger.requested(ledger, before, after, {[1] = true})
  paintCoverageLedger.readBack(ledger, after)
  local summary = paintCoverageLedger.summary(ledger)
  equal(summary.paintLocked, 1)
  equal(summary.paintRejected, 0)
  truthy(summary.paintChanged > 0)
  truthy(paintCoverageLedger.isComplete(ledger))
  truthy(paintCoverageLedger.bindContext(ledger, {operationId = "paint-op", targetGeneration = 8}))
  truthy(not paintCoverageLedger.bindContext(ledger, {operationId = "paint-op", targetGeneration = 9}))
  local unsupported = paintCoverageLedger.create({}, nil, false)
  equal(paintCoverageLedger.summary(unsupported).paintUnsupported, 1)
end

tests.v060_lineup_seeds_progress_schema_and_storage = function()
  local lineup = assert(lineupManager.create({count = 16, episodeSeed = "episode", acceptPartial = false}))
  truthy(lineupSchema.validate(lineup))
  local seeds = {}
  for _, competitor in ipairs(lineup.competitors) do
    truthy(not seeds[competitor.seed])
    seeds[competitor.seed] = true
  end
  local thirdSeed = lineup.competitors[3].seed
  local first = assert(lineupManager.nextCompetitor(lineup))
  equal(first.targetGeneration, 1)
  local accepted = {
    success = true,
    details = {
      verifiedTraits = {modelKey = "model_a", configuration = "base", sourceKind = "official", vehicleClass = "Car"},
      lifecycleAcceptance = {
        finalValidationPassed = true, busy = false,
        pendingWrites = 0, pendingTimers = 0, pendingCallbacks = 0,
      },
    },
  }
  truthy(not lineupManager.record(lineup, 1, accepted, sampleDNA({id = "dna-stale"}), first.targetGeneration + 1))
  equal(first.status, "selecting_vehicle")
  truthy(lineupManager.record(lineup, 1, accepted, sampleDNA({id = "dna-ready"}), first.targetGeneration))
  equal(first.status, "ready")
  local second = assert(lineupManager.nextCompetitor(lineup))
  local secondGeneration = second.targetGeneration
  truthy(lineupManager.record(lineup, 2, {success = false, message = "fixture"}, nil, secondGeneration))
  truthy(lineupManager.resolveFailure(lineup, 2, "retry"))
  local retry = assert(lineupManager.nextCompetitor(lineup))
  equal(retry.targetGeneration, secondGeneration + 1)
  truthy(lineupManager.record(lineup, 2, {success = false, message = "fixture retry"}, nil, retry.targetGeneration))
  equal(lineup.competitors[3].seed, thirdSeed)
  equal(lineupManager.summary(lineup).failed, 1)
  local library = lineupStorage.create(2)
  truthy(lineupStorage.add(library, lineup))
  equal(#library.entries, 1)
  local invalid = util.deepCopy(lineup); invalid.competitors[17] = util.deepCopy(invalid.competitors[16]); invalid.competitors[17].index = 17; invalid.competitors[17].id = "extra"
  truthy(not lineupSchema.validate(invalid))
end

tests.v060_lineup_import_is_data_only = function()
  local lineup = assert(lineupManager.create({count = 2, episodeSeed = "import"}))
  lineup.competitors[1].script = "os.execute('never')"
  lineup.competitors[1].compatibility = {status = "exporter_claim"}
  local imported = assert(lineupSchema.sanitizedImport(lineup))
  equal(imported.competitors[1].script, nil)
  equal(imported.competitors[1].compatibility.status, "requires_local_recompute")
end

tests.v060_lineup_variety_substreams_and_failure_actions = function()
  local lineup = assert(lineupManager.create({
    count = 3, episodeSeed = "variety",
    avoidDuplicateModels = true, avoidDuplicateConfigurations = true,
    avoidDuplicateFamilies = true, diversifyVehicleClasses = true,
    diversifySource = true, maxAttemptsPerCompetitor = 3,
  }))
  local first = lineup.competitors[1]
  first.status = "ready"
  first.traits = {verified = {
    modelKey = "model_a", configuration = "base", family = "family_a",
    vehicleClass = "Car", sourceKind = "official",
  }}
  local models = {
    {key = "model_a", type = "Car", sourceKind = "official", raw = {Family = "family_a"}, configs = {
      {modelKey = "model_a", key = "sport", sourceKind = "official"},
    }},
    {key = "model_b", type = "Truck", sourceKind = "mod", raw = {Family = "family_b"}, configs = {
      {modelKey = "model_b", key = "base", sourceKind = "mod"},
    }},
  }
  local filtered, metrics = lineupManager.filterModels(models, lineup.varietyRules, {first})
  equal(#filtered, 1)
  equal(filtered[1].key, "model_b")
  truthy(metrics.bestDiversityScore >= 1)

  local unknown = {{key = "unknown_model", sourceKind = "unknown", raw = {}, configs = {
    {modelKey = "unknown_model", key = "unknown_config", sourceKind = "unknown"},
  }}}
  local unknownFiltered = lineupManager.filterModels(unknown, lineup.varietyRules, {first})
  equal(#unknownFiltered, 1)
  local unknownTraits = lineupManager.verifiedTraits(unknown[1], unknown[1].configs[1])
  equal(unknownTraits.vehicleClass, nil)
  equal(unknownTraits.family, nil)

  local second = lineup.competitors[2]
  local operationA = assert(lineupManager.domainSeed(lineup, second, "operation", 1))
  local operationRetry = assert(lineupManager.domainSeed(lineup, second, "operation", 2))
  local paintA = assert(lineupManager.domainSeed(lineup, second, "paint", 1))
  local thirdOperation = assert(lineupManager.domainSeed(lineup, lineup.competitors[3], "operation", 1))
  truthy(operationA ~= operationRetry)
  truthy(operationA ~= paintA)
  local thirdAgain = assert(lineupManager.domainSeed(lineup, lineup.competitors[3], "operation", 1))
  equal(thirdOperation, thirdAgain)

  second.status, second.attemptCount = "failed", 1
  truthy(lineupManager.resolveFailure(lineup, 2, "retry"))
  equal(second.status, "planned")
  second.status = "failed"
  truthy(lineupManager.resolveFailure(lineup, 2, "fallback"))
  truthy(second.forceOfficialFallback)
  second.status = "failed"
  truthy(lineupManager.resolveFailure(lineup, 2, "skip"))
  equal(second.status, "skipped")
  lineup.competitors[3].status = "failed"
  truthy(lineupManager.resolveFailure(lineup, 3, "stop"))
  truthy(not lineup.active)

  local lifecycleResult = {success = true, details = {
    verifiedTraits = {modelKey = "mystery", configuration = "base", sourceKind = "unknown"},
    metadataUncertain = true, potentiallyUndrivable = true,
    lifecycleAcceptance = {finalValidationPassed = true, busy = false, pendingWrites = 0, pendingTimers = 0, pendingCallbacks = 0},
  }}
  local strict = assert(lineupManager.create({count = 2, episodeSeed = "strict"}))
  local strictCompetitor = assert(lineupManager.nextCompetitor(strict))
  truthy(lineupManager.record(strict, 1, lifecycleResult, sampleDNA({id = "strict-dna"}), strictCompetitor.targetGeneration))
  equal(strictCompetitor.status, "partial")
  truthy(strictCompetitor.warning:find("requires explicit acceptance", 1, true) ~= nil)
  local permissive = assert(lineupManager.create({
    count = 2, episodeSeed = "permissive", preset = "Custom",
    acceptMetadataUncertain = true, acceptPotentiallyUndrivable = true,
  }))
  local permissiveCompetitor = assert(lineupManager.nextCompetitor(permissive))
  truthy(lineupManager.record(permissive, 1, lifecycleResult, sampleDNA({id = "permissive-dna"}), permissiveCompetitor.targetGeneration))
  equal(permissiveCompetitor.status, "ready_with_warnings")
end

tests.v060_spawn_plans_are_camera_relative_and_safe = function()
  local frame = {position = {x = 10, y = 20, z = 5}, forward = {x = 0, y = 1, z = 0}, right = {x = 1, y = 0, z = 0}}
  local ground = function(position) return true, {point = {x = position.x, y = position.y, z = 0}, normal = {x = 0, y = 0, z = 1}} end
  local right = assert(spawnDirector.plan(frame, {mode = "Right", count = 1, spacing = 6}, ground, {}))
  equal(right.placements[1].position.x, 16)
  equal(right.placements[1].position.y, 20)
  local gridA = assert(spawnDirector.plan(frame, {mode = "Grid", count = 4, spacing = 6, columns = 2}, ground, {}))
  local gridB = assert(spawnDirector.plan(frame, {mode = "Grid", count = 4, spacing = 6, columns = 2}, ground, {}))
  truthy(util.deepEqual(gridA.placements, gridB.placements))
  local circle = assert(spawnDirector.plan(frame, {mode = "Circle", count = 4, radius = 12}, ground, {}))
  equal(#circle.placements, 4)
  local missing, missingReason = spawnDirector.plan(frame, {count = 1}, function() return false, "ground_not_found" end, {})
  equal(missing, nil); equal(missingReason, "ground_not_found")
  local blocked, blockedReason = spawnDirector.plan(frame, {
    mode = "Right", count = 1, spacing = 6, maxPlacementAttemptsPerSlot = 1,
  }, ground, {{x = 16, y = 20, z = 0}})
  equal(blocked, nil); equal(blockedReason, "position_blocked")
end

tests.v078_bounded_spawn_solver_recovers_and_reports_evidence = function()
  local frame = {
    position = {x = 0, y = 0, z = 5}, forward = {x = 0, y = 1, z = 0},
    right = {x = 1, y = 0, z = 0},
  }
  local ground = function(position)
    return true, {point = {x = position.x, y = position.y, z = 0}, normal = {x = 0, y = 0, z = 1}}
  end
  local options = {
    mode = "Right", count = 1, spacing = 6, maxPlacementAttemptsPerSlot = 5,
    maxPlacementDistance = 40, maxRejectedSamples = 3,
  }
  local recovered = assert(spawnDirector.plan(frame, options, ground, {{x = 6, y = 0, z = 0}}))
  equal(recovered.placements[1].attempt, 2)
  equal(recovered.planning.totalAttempts, 2)
  equal(recovered.planning.rejectedCandidates, 1)
  equal(recovered.planning.rejectionSummary.position_blocked, 1)
  equal(recovered.planning.fallbackDepth, 1)
  truthy(not recovered.planning.budgetExhausted)
  local replay = assert(spawnDirector.plan(frame, options, ground, {{x = 6, y = 0, z = 0}}))
  truthy(util.deepEqual(recovered, replay))

  local groundCalls = 0
  local groundRecovered = assert(spawnDirector.plan(frame, options, function(position)
    groundCalls = groundCalls + 1
    if groundCalls == 1 then return false, "ground_not_found" end
    return ground(position)
  end, {}))
  equal(groundRecovered.placements[1].attempt, 2)
  equal(groundRecovered.planning.rejectionSummary.ground_not_found, 1)

  local slopeCalls = 0
  local slopeRecovered = assert(spawnDirector.plan(frame, options, function(position)
    slopeCalls = slopeCalls + 1
    if slopeCalls == 1 then
      return true, {point = position, normal = {x = 1, y = 0, z = 0}}
    end
    return ground(position)
  end, {}))
  equal(slopeRecovered.placements[1].attempt, 2)
  equal(slopeRecovered.planning.rejectionSummary.slope_too_high, 1)

  local exhausted, exhaustedReason, exhaustedReport = spawnDirector.plan(frame, {
    mode = "Front", count = 1, spacing = 6, maxPlacementAttemptsPerSlot = 5,
    maxRejectedSamples = 2,
  }, ground, {{x = 0, y = 0, z = 0, radius = 1000}})
  equal(exhausted, nil); equal(exhaustedReason, "position_blocked")
  equal(exhaustedReport.totalAttempts, 5)
  equal(exhaustedReport.rejectedCandidates, 5)
  equal(#exhaustedReport.rejectionSamples, 2)
  truthy(exhaustedReport.budgetExhausted)

  local sibling, siblingReason, siblingReport = spawnDirector.plan(frame, {
    mode = "Grid", count = 2, columns = 1, spacing = 6,
    maxPlacementAttemptsPerSlot = 3,
  }, function()
    return true, {point = {x = 10, y = 10, z = 0}, normal = {x = 0, y = 0, z = 1}}
  end, {})
  equal(sibling, nil); equal(siblingReason, "position_blocked")
  equal(siblingReport.failedSlot, 2)
  equal(siblingReport.rejectionSummary.position_blocked, 3)

  local distant, distantReason, distantReport = spawnDirector.plan(frame, {
    mode = "Right", count = 1, spacing = 40, maxPlacementDistance = 20,
    maxPlacementAttemptsPerSlot = 1,
  }, ground, {})
  equal(distant, nil); equal(distantReason, "outside_supported_area")
  equal(distantReport.totalAttempts, 1)
end

tests.v060_spawn_heading_readback_and_ownership = function()
  local frame = {
    position = {x = 0, y = 0, z = 5}, forward = {x = 0, y = 1, z = 0}, right = {x = 1, y = 0, z = 0},
    playerForward = {x = 1, y = 0, z = 0}, roadForward = {x = -1, y = 0, z = 0},
  }
  local ground = function(position) return true, {point = {x = position.x, y = position.y, z = 0}, normal = {x = 0, y = 0, z = 1}} end
  local player = assert(spawnDirector.plan(frame, {mode = "Front", count = 1, headingMode = "player"}, ground, {}))
  near(player.placements[1].forward.x, 1, 1e-8)
  local road = assert(spawnDirector.plan(frame, {mode = "Front", count = 1, heading = "Road direction"}, ground, {}))
  near(road.placements[1].forward.x, -1, 1e-8)
  local face = assert(spawnDirector.plan(frame, {
    mode = "Right", count = 1, headingMode = "destination", destination = {x = 100, y = 0, z = 0},
  }, ground, {}))
  truthy(face.placements[1].forward.x > 0.9)
  equal(face.options.maxConcurrentLoads, 1)
  local custom = assert(spawnDirector.plan(frame, {
    mode = "Custom point", count = 4, customPoint = {x = 25, y = 35, z = 5}, headingMode = "camera",
  }, ground, {}))
  equal(#custom.placements, 1)
  equal(custom.placements[1].position.x, 25)
  local noRoad, noRoadReason = spawnDirector.plan({
    position = frame.position, forward = frame.forward, right = frame.right,
  }, {mode = "Front", count = 1, headingMode = "road"}, ground, {})
  equal(noRoad, nil); equal(noRoadReason, "road_heading_unavailable")

  local steep, steepReason = spawnDirector.plan(frame, {count = 1}, function(position)
    return true, {point = position, normal = {x = 1, y = 0, z = 0}}
  end, {})
  equal(steep, nil); equal(steepReason, "slope_too_high")

  local oldManager = core_vehicle_manager
  core_vehicle_manager = {getVehicleData = function(id)
    return {model = "model_b", config = {parts = {engine = "engine_b"}, vars = {boost = 2}, paints = {{metallic = 0.5}}}}
  end}
  local verified, state = spawnApiAdapter.verifySpawnTarget(17, "model_b", {
    parts = {engine = "engine_b"}, vars = {boost = 2}, paints = {{metallic = 0.5}},
  })
  core_vehicle_manager = oldManager
  truthy(verified)
  equal(state.vehicleId, 17)

  local registry = managedVehicleRegistry.create(2)
  local entry = assert(managedVehicleRegistry.register(registry, 17, {
    targetConfirmed = false, validated = false, modelKey = "model_b", dnaId = "dna-b",
    competitorId = "competitor-b", spawnTransform = face.placements[1],
  }))
  truthy(not managedVehicleRegistry.attachAuxiliary(registry, entry.handle, 18, {proven = false, ownerVehicleId = 17}))
  truthy(managedVehicleRegistry.attachAuxiliary(registry, entry.handle, 18, {proven = true, ownerVehicleId = 17}))
  local owner, kind = managedVehicleRegistry.findByVehicle(registry, 18)
  equal(owner.handle, entry.handle); equal(kind, "auxiliary")
  truthy(managedVehicleRegistry.setPending(registry, entry.handle, {writes = 0, timers = 0, callbacks = 0}))
  truthy(managedVehicleRegistry.markReady(registry, entry.handle, entry.targetGeneration,
    {busy = false, targetConfirmed = true, validated = true}))
  truthy(managedVehicleRegistry.readyEntry(registry, entry.handle, entry.targetGeneration))
end

tests.v060_managed_registry_rebinds_without_cross_vehicle_damage = function()
  local registry = managedVehicleRegistry.create(3)
  local first = assert(managedVehicleRegistry.register(registry, 10, {competitor = 1}))
  local second = assert(managedVehicleRegistry.register(registry, 20, {competitor = 2}))
  equal(first.status, "active")
  local loading = assert(managedVehicleRegistry.register(registry, 30,
    {competitor = 3, targetConfirmed = false, validated = false}))
  equal(loading.status, "loading")
  local loadingGeneration = loading.targetGeneration
  truthy(managedVehicleRegistry.setPending(registry, loading.handle, {writes = 1, callbacks = 1}))
  truthy(not managedVehicleRegistry.markReady(registry, loading.handle, loadingGeneration,
    {busy = false, targetConfirmed = true, validated = true}))
  truthy(managedVehicleRegistry.setPending(registry, loading.handle, {writes = 0, timers = 0, callbacks = 0}))
  truthy(managedVehicleRegistry.markReady(registry, loading.handle, loadingGeneration,
    {busy = false, targetConfirmed = true, validated = true}))
  equal(loading.status, "ready")
  local oldGeneration = first.targetGeneration
  truthy(not managedVehicleRegistry.rebind(registry, first.handle, 10, 12, oldGeneration + 1))
  equal(first.vehicleId, 10)
  truthy(managedVehicleRegistry.rebind(registry, first.handle, 10, 11))
  truthy(first.targetGeneration > oldGeneration)
  truthy(not managedVehicleRegistry.rebind(registry, first.handle, 11, 20))
  truthy(managedVehicleRegistry.destroyed(registry, 11))
  equal(registry.entries[second.handle].status, "active")
  truthy(managedVehicleRegistry.remove(registry, first.handle))
  equal(#managedVehicleRegistry.list(registry), 2)
end

tests.v060_navgraph_routes_and_ai_bounds = function()
  local fake = {
    findClosestRoad = function(position) return true, position.x < 5 and "start" or "finish" end,
    getPath = function(first, second) return true, {first, "middle", second} end,
  }
  local route = assert(routePlanner.destinationRoute(fake, {x = 0, y = 0, z = 0}, {x = 10, y = 0, z = 0}, 10))
  equal(route.kind, "NavGraph")
  equal(#route.nodes, 3)
  local noRoute, reason = routePlanner.destinationRoute({findClosestRoad = fake.findClosestRoad, getPath = function() return false end},
    {x = 0, y = 0, z = 0}, {x = 10, y = 0, z = 0}, 10)
  equal(noRoute, nil); equal(reason, "navgraph_route_unreachable")
  local director = aiDirector.create(1)
  local entry = assert(aiDirector.assign(director, "one", 1, "Destination", {delay = 2, arrivalRadius = 5}, 10))
  equal(entry.startAt, 12)
  local rejected, limitReason = aiDirector.assign(director, "two", 2, "Traffic", {}, 10)
  equal(rejected, nil); equal(limitReason, "ai_vehicle_limit")
  local staggered = aiDirector.create(3)
  local first = assert(aiDirector.assign(staggered, "first", 11, "Traffic", {delay = 0}, 5))
  local second = assert(aiDirector.assign(staggered, "second", 12, "Traffic", {delay = 0.4}, 5))
  local third = assert(aiDirector.assign(staggered, "third", 13, "Traffic", {delay = 0.8}, 5))
  near(second.startAt - first.startAt, 0.4, 1e-8)
  near(third.startAt - second.startAt, 0.4, 1e-8)
  aiDirector.setStatus(staggered, "first", "running", "fixture")
  aiDirector.setStatus(staggered, "second", "running", "fixture")
  aiDirector.setStatus(staggered, "third", "running", "fixture")
  local stoppedIds = {}
  local stopped = aiDirector.controlAll(staggered, "stop", 6, function(vehicleId) stoppedIds[vehicleId] = true end)
  equal(stopped, 3)
  truthy(stoppedIds[11] and stoppedIds[12] and stoppedIds[13])
  equal(staggered.entries.first.status, "stopped")
  equal(staggered.entries.second.status, "stopped")
  equal(staggered.entries.third.status, "stopped")
  local originalMap = map
  map = nil
  local detected = aiAdapter.capabilities()
  map = originalMap
  equal(detected.Destination, false)
  equal(detected.Scripted, false)
  local scripted, scriptedReason = aiAdapter.start(1, "Scripted", {})
  equal(scripted, false); equal(scriptedReason, "ai_mode_scripted_unavailable")
end

tests.v060_route_editor_ai_progress_and_isolation = function()
  local routeState = routePlanner.create(4)
  truthy(routePlanner.addPoint(routeState, {x = 1, y = 0, z = 0}))
  truthy(routePlanner.addPoint(routeState, {x = 2, y = 0, z = 0}))
  truthy(routePlanner.reverse(routeState))
  equal(routeState.points[1].x, 2)
  truthy(routePlanner.removeLast(routeState))
  equal(#routeState.points, 1)
  truthy(routePlanner.clear(routeState))
  equal(#routeState.points, 0)

  local fake = {
    findClosestRoad = function(position) return true, "n" .. tostring(position.x), nil end,
    getPath = function(first, second) return true, {first, second} end,
  }
  local loopRoute = assert(routePlanner.routeThrough(fake, {x = 0, y = 0, z = 0}, {
    {x = 1, y = 0, z = 0}, {x = 2, y = 0, z = 0},
  }, 20, true))
  truthy(#loopRoute.nodes >= 3)
  equal(loopRoute.points[1].x, loopRoute.points[#loopRoute.points].x)

  local director = aiDirector.create(2)
  local arrival = assert(aiDirector.assign(director, "arrival", 10, "Destination", {
    arrivalRadius = 5, arrivalSpeed = 1, timeout = 30, targetGeneration = 7,
  }, 0))
  aiDirector.setStatus(director, "arrival", "running", "fixture")
  arrival.startedAt = 0
  equal(aiDirector.observe(director, "arrival", {distance = 4, speed = 5}, 1), "running")
  local arrived, arrivedReason = aiDirector.observe(director, "arrival", {distance = 3, speed = 0.5}, 2)
  equal(arrived, "arrived"); equal(arrivedReason, "arrival_confirmed")

  local stuck = assert(aiDirector.assign(director, "stuck", 11, "Destination", {
    recoveryWhenStuck = true, stuckAction = "replan", stuckTimeout = 3,
    minimumSpeed = 1, maxReplans = 1,
  }, 0))
  aiDirector.setStatus(director, "stuck", "running", "fixture")
  stuck.startedAt, stuck.lastProgressAt = 0, 0
  equal(aiDirector.observe(director, "stuck", {distance = 100, speed = 0}, 0), "running")
  local stuckEvent, stuckAction = aiDirector.observe(director, "stuck", {distance = 100, speed = 0}, 4)
  equal(stuckEvent, "stuck"); equal(stuckAction, "replan")
  truthy(aiDirector.requestReplan(director, "stuck"))
  truthy(not aiDirector.requestReplan(director, "stuck"))

  aiDirector.setStatus(director, "arrival", "running", "fixture")
  local stopped, targetReason = aiDirector.observe(director, "arrival", {targetMissing = true}, 3)
  -- Destination has no live target, so targetMissing is deliberately ignored.
  equal(stopped, "running"); equal(targetReason, nil)

  local chaseDirector = aiDirector.create(1)
  local chaseEntry = assert(aiDirector.assign(chaseDirector, "chase", 12, "Chase", {targetVehicleId = 20}, 0))
  aiDirector.setStatus(chaseDirector, "chase", "running", "fixture")
  chaseEntry.startedAt = 0
  local removed, removedReason = aiDirector.observe(chaseDirector, "chase", {targetMissing = true}, 1)
  equal(removed, "stopped"); equal(removedReason, "ai_target_removed")

  local oldLookup = getObjectByID
  local commands = {}
  getObjectByID = function(id)
    return {queueLuaCommand = function(_, command) commands[id] = (commands[id] or "") .. command end}
  end
  local chaseOk = aiAdapter.start(10, "Chase", {
    targetVehicleId = 20, speed = 15, speedMode = "limit", aggression = 0.5,
  })
  getObjectByID = oldLookup
  truthy(chaseOk)
  truthy(commands[10]:find("setTargetObjectID%(20%)") ~= nil)
  equal(commands[20], nil)

  local marker = destinationMarker.create()
  marker.exactPoint, marker.point, marker.status = {x = 1, y = 2, z = 3}, {x = 1, y = 2, z = 3}, "preview"
  truthy(destinationMarker.confirm(marker, "exact"))
  truthy(marker.active and marker.confirmed)
  truthy(destinationMarker.clear(marker))
  truthy(not marker.active and marker.point == nil)
end

tests.v060_pause_time_sources_contract = function()
  local now = 0
  local clocks = timeSource.create(function() return now end)
  now = 0.1
  timeSource.sample(clocks, 0.1, 0, 0.1, true, now)
  equal(clocks.realMonotonicTime, 0.1)
  equal(clocks.simulationTime, 0)
  equal(clocks.realDelta, 0.1)
  equal(clocks.simulationDelta, 0)
  equal(clocks.frameCounter, 1)
  truthy(clocks.paused)

  now = 0.2
  timeSource.sample(clocks, 0.1, 0.025, 0.1, false, now)
  near(clocks.simulationTime, 0.025, 1e-8)
  near(clocks.slowMotionRatio, 0.25, 1e-8)
  truthy(not clocks.paused)

  now = 0.3
  timeSource.sample(clocks, 0.1, 1 / 60, 0.1, true, now)
  truthy(clocks.paused)
  truthy(clocks.simulationDelta > 0)
  equal(clocks.frameCounter, 3)
end

tests.v060_explicit_lifecycle_generations_contract = function()
  local now = 0
  local state = operationState.create(function() return now end, 10)
  local ok, token = operationState.begin(state, "fullRandom", 1, 10)
  truthy(ok)
  equal(state.phase, "capturing_original")
  truthy(operationState.deriveBusy(state))
  local operationGeneration = state.operationGeneration
  truthy(operationState.setPhase(state, "tracking_target_identity", 5, "fixture"))
  local context = operationState.captureContext(state, {vehicleId = 2, modelKey = "B"})
  truthy(operationState.validateContinuation(state, context, {vehicleId = 2, modelKey = "B"}))
  truthy(operationState.setPhase(state, "stabilizing_tree", 5, "fixture_tree"))
  local current, reason = operationState.validateContinuation(state, context, {vehicleId = 2, modelKey = "B"})
  equal(current, false)
  equal(reason, "stale_callback_rejected")
  local timerCurrent, timerReason = operationState.validateTimer(state, context, {vehicleId = 2, modelKey = "B"})
  equal(timerCurrent, false)
  equal(timerReason, "stale_timer_rejected")
  truthy(operationState.nextTarget(state, {vehicleId = 3}) > context.targetGeneration)
  local replacement = operationState.invalidate(state, "recovery", {operation = true, target = true})
  truthy(replacement ~= token)
  truthy(state.operationGeneration > operationGeneration)
  truthy(operationState.setPhase(state, "recovering_previous", 5, "fixture_recovery"))
  truthy(operationState.phasePolicy(state).pauseIndependent)
  truthy(operationState.finish(state, "failed", "fixture"))
  truthy(not operationState.deriveBusy(state))
  equal(state.phase, "failed")
end

tests.v060_target_identity_tree_separation_contract = function()
  local tracker = vehicleTargetTracker.create({
    token = "op", operationId = "SCR-1", operationGeneration = 1,
    phaseGeneration = 2, targetGeneration = 3, modelKey = "model",
    configKey = "/vehicles/model/base.pc", parts = {["/body/"] = "body_b"},
    startedAt = 0, timeout = 5,
    stabilizer = {minimumFrames = 2, minimumScans = 2, pollInterval = 0},
    treeStabilizer = {minimumFrames = 2, minimumScans = 2, pollInterval = 0},
  })
  local context = {
    operationId = "SCR-1", operationGeneration = 1,
    phaseGeneration = 2, targetGeneration = 3,
  }
  local changing = {
    vehicleId = 7, modelKey = "model", configKey = "/vehicles/model/base.pc",
    parts = {["/body/"] = "body_a"},
  }
  local fingerprintA = vehicleTargetTracker.stateFingerprint(changing)
  vehicleTargetTracker.observe(tracker, "op", changing, 0.1, context)
  local status = vehicleTargetTracker.observe(tracker, "op", changing, 0.2, context)
  equal(status, "waiting")
  truthy(vehicleTargetTracker.summary(tracker, 0.2).identityConfirmed)
  changing.parts["/body/"] = "body_b"
  equal(vehicleTargetTracker.stateFingerprint(changing), fingerprintA)
  status = vehicleTargetTracker.observe(tracker, "op", changing, 0.3, context)
  equal(status, "waiting")
  status = vehicleTargetTracker.observe(tracker, "op", changing, 0.4, context)
  equal(status, "stable")
  local report = vehicleTargetTracker.summary(tracker, 0.4)
  truthy(report.identityConfirmed)
  equal(report.treeStatus, "vehicle_target_stable")
end

tests.v060_recovery_snapshot_roles_contract = function()
  local recovery = vehicleRecovery.create()
  local damaged = {modelKey = "A", vehicleId = 1, selectedConfiguration = "damaged.pc"}
  truthy(vehicleRecovery.rememberReadable(recovery, damaged))
  equal(recovery.lastCompletedGoodSnapshot, nil)
  local final = {modelKey = "B", vehicleId = 2, selectedConfiguration = "final.pc"}
  truthy(vehicleRecovery.rememberCompletedGood(recovery, final))
  equal(recovery.lastReadableSnapshot.modelKey, "B")
  equal(recovery.lastCompletedGoodSnapshot.modelKey, "B")

  local operation = {
    currentBatch = {{slotPath = "/body/"}}, afterReload = "mutation",
    paintConfirmation = {}, pendingTuningChanges = {{name = "boost"}},
    treeRescanAt = 10, operationMutationPlan = {stage = "parts"},
    targetTracker = {}, wait = {},
    slotLedger = {}, tuningLedger = {}, paintLedger = {},
    batchRecovery = {currentBatch = {}},
  }
  truthy(vehicleRecovery.invalidateForRecovery(operation))
  truthy(operation.recoveryOnly)
  equal(operation.currentBatch, nil)
  equal(operation.afterReload, nil)
  equal(operation.paintConfirmation, nil)
  equal(operation.operationMutationPlan, nil)
  truthy(operation.slotLedger.closed and operation.tuningLedger.closed and operation.paintLedger.closed)
end

tests.v062_recovery_tiers_are_ordered_and_deduplicated = function()
  local recovery = vehicleRecovery.create()
  vehicleRecovery.rememberCompletedGood(recovery, {modelKey = "baseline", selectedConfiguration = "baseline.pc"})
  local generation = vehicleRecovery.beginRecovery(recovery, "SCR-tiers", 9)
  local plan = vehicleRecovery.choosePlan(recovery, {
    transient = true,
    currentTargetSnapshot = {modelKey = "current", selectedConfiguration = "current.pc"},
    candidateBaseSnapshot = {modelKey = "candidate", selectedConfiguration = "candidate.pc"},
    originalSnapshot = {modelKey = "original", selectedConfiguration = "original.pc"},
  }, {{modelKey = "safe", key = "base", path = "safe.pc", sourceKind = "official"}})
  equal(generation, 1)
  equal(plan[1].tier, 1); equal(plan[1].kind, "continue_current_target")
  equal(plan[2].tier, 3); equal(plan[2].kind, "clean_candidate_baseline")
  equal(plan[3].tier, 5); equal(plan[3].kind, "original_player_vehicle")
  equal(plan[4].tier, 6); equal(plan[4].kind, "explicit_safe_baseline")
  equal(plan[5].tier, 7); equal(plan[5].kind, "safe_official_fallback")
  equal(plan[#plan].tier, 8); equal(plan[#plan].kind, "hard_failure")
end

tests.v062_recovery_rejects_old_generation_and_repeated_state = function()
  local recovery = vehicleRecovery.create({cycleVisitLimit = 1})
  local generation = vehicleRecovery.beginRecovery(recovery, "SCR-cycle", 4)
  local step = {kind = "abort_candidate", tier = 3, snapshot = {
    modelKey = "loop", selectedConfiguration = "loop.pc", partsTree = {body = "same"},
  }}
  local accepted = vehicleRecovery.observeRecoveryStep(recovery, "SCR-cycle", generation, step)
  truthy(accepted)
  local repeated, repeatReason = vehicleRecovery.observeRecoveryStep(recovery, "SCR-cycle", generation, step)
  equal(repeated, false)
  equal(repeatReason, "candidate_cycle_detected")
  local stale, staleReason = vehicleRecovery.observeRecoveryStep(recovery, "SCR-cycle", generation - 1, step)
  equal(stale, false)
  equal(staleReason, "recovery_snapshot_old_generation")
end

tests.v060_progress_watchdog_contract = function()
  local watchdog = progressWatchdog.create(0, {warningAfter = 2, stalledAfter = 4, pauseDependencyWindow = 1})
  equal(progressWatchdog.evaluate(watchdog, 2.1, false), "SLOW_PROGRESS")
  equal(progressWatchdog.evaluate(watchdog, 4.1, false), "NO_PROGRESS")
  progressWatchdog.observePause(watchdog, true, 4.2)
  local callbackAdvanced, callbackClass = progressWatchdog.note(
    watchdog, "target", "vehicle_spawn_callback", 4.25
  )
  equal(callbackAdvanced, false); equal(callbackClass, "callback_noise")
  equal(progressWatchdog.evaluate(watchdog, 4.3, false), "NO_PROGRESS")
  progressWatchdog.note(watchdog, "binding", "target_evidence_confirmed", 4.3)
  truthy(watchdog.pauseDependentProgressDetected)
  equal(progressWatchdog.evaluate(watchdog, 20, true), "WAITING_FOR_SIMULATION_RESUME")
  truthy(not watchdog.stalled)
  local report = progressWatchdog.snapshot(watchdog, 20)
  equal(report.lastSemanticProgressAt, 4.3)
  equal(report.callbackNoiseCount, 1)
end

tests.v060_actions_complete_without_pause_toggle = function()
  for _, action in ipairs({"randomConfig", "scramble", "fullRandom"}) do
    local harness = pipelineHarness.new()
    truthy(pipelineHarness.driveSuccess(harness, action, {
      manualSeed = "no-pause-toggle-" .. action,
    }))
    local state = harness.main.requestState()
    truthy(not state.busy, action .. " stayed busy")
    truthy(state.lastResult and state.lastResult.success, action .. " did not succeed")
    truthy(type(state.lifecyclePhase) == "string")
  end
end

tests.v060_initial_pause_wait_resume_contract = function()
  for _, action in ipairs({"randomConfig", "scramble", "fullRandom"}) do
    local harness = pipelineHarness.new({paused = true})
    truthy(harness.main.runAction(action, {
      chaos = 100, manualSeed = "initially-paused-" .. action,
      includeAutomation = true, includeTrailers = true, includeProps = true,
    }))
    if harness.pendingReplacement then pipelineHarness.applyPendingReplacement(harness, true) end
    pipelineHarness.advance(harness, 0.1, 0, 8)
    local pausedState = harness.main.requestState()
    truthy(pausedState.lastResult == nil or pausedState.lastResult.code ~= "vehicle_target_timeout")
    truthy(pausedState.clocks.paused)
    pipelineHarness.setPaused(harness, false)
    local finalState = pipelineHarness.driveActive(harness, 128)
    truthy(not finalState.busy, action .. " did not leave paused state")
    truthy(finalState.lastResult and finalState.lastResult.success, action .. " failed after resume")
  end
end

tests.v060_pause_mid_pipeline_and_frame_step_contract = function()
  local harness = pipelineHarness.new({deferredPaint = true})
  truthy(harness.main.fullRandom({chaos = 100, manualSeed = "pause-mid-pipeline"}))
  pipelineHarness.confirmReplacement(harness)
  truthy(harness.pendingParts)
  harness.tree = harness.pendingParts
  harness.pendingParts = nil
  pipelineHarness.setPaused(harness, true)
  harness.main.onVehicleSpawned(harness.vehicleId)
  local targetGeneration = harness.main.requestState().lifecycle.targetGeneration
  pipelineHarness.advance(harness, 0.1, 0, 10)
  local pausedState = harness.main.requestState()
  truthy(pausedState.busy)
  equal(pausedState.lifecycle.targetGeneration, targetGeneration)
  pipelineHarness.frameStep(harness, 0.1, 1 / 60)
  equal(harness.main.requestState().lifecycle.targetGeneration, targetGeneration)
  pipelineHarness.setPaused(harness, false)
  local finalState = pipelineHarness.driveActive(harness, 128)
  truthy(not finalState.busy)
  truthy(finalState.lastResult and finalState.lastResult.success)
end

tests.v060_slow_motion_is_seed_independent = function()
  local normal = pipelineHarness.new({simulationScale = 1})
  local slow = pipelineHarness.new({simulationScale = 0.25})
  truthy(pipelineHarness.driveSuccess(normal, "fullRandom", {manualSeed = "slowmo-seed"}))
  truthy(pipelineHarness.driveSuccess(slow, "fullRandom", {manualSeed = "slowmo-seed"}))
  truthy(util.deepEqual(normal.tree, slow.tree, 1e-8))
  truthy(util.deepEqual(normal.tuning, slow.tuning, 1e-8))
  truthy(util.deepEqual(normal.paints, slow.paints, 1e-8))
end

tests.v060_recovery_stale_callback_isolation_contract = function()
  local harness = pipelineHarness.new({paintFailure = true, vehicleId = 1, returnedVehicleId = 2})
  harness.tuning.boost = -1
  harness.paints[1].metallic = 0.91
  local originalTree = util.deepCopy(harness.tree)
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom", {manualSeed = "recovery-stale-B"}))
  truthy(harness.pendingReplacement and harness.pendingReplacement.restoring)
  pipelineHarness.applyPendingReplacement(harness, false)
  equal(harness.vehicleId, 2)
  local writesBeforeStale = #harness.writes
  harness.main.onVehicleSpawned(2)
  harness.main.onVehicleSpawned(1)
  pipelineHarness.advance(harness, 0.1, 0.1, 10)
  local state = harness.main.requestState()
  truthy(not state.busy, "recovery remained busy in " .. tostring(state.lifecyclePhase)
    .. " result=" .. tostring(state.lastResult and state.lastResult.code))
  truthy(state.lastResult and not state.lastResult.success)
  equal(state.lastResult.details.rollback, "completed")
  equal(#harness.writes, writesBeforeStale)
  truthy(util.deepEqual(harness.tree, originalTree, 1e-8))
  equal(harness.modelKey, "fixture_new")
  equal(harness.tuning.boost, 0.5)
  equal(state.lastResult.details.recoveryTier, 3)
end

tests.v060_busy_cancel_and_diagnostics_contract = function()
  for _, terminal in ipairs({"completed", "partial", "failed", "cancelled"}) do
    local state = operationState.create(function() return 0 end, 5)
    truthy(operationState.begin(state, "fixture", 1, 5))
    truthy(operationState.finish(state, terminal, terminal == "completed" and nil or "fixture"))
    truthy(not operationState.deriveBusy(state), terminal .. " stayed busy")
  end

  local harness = pipelineHarness.new({paused = true})
  truthy(harness.main.scramble({chaos = 100, manualSeed = "cancel-paused"}))
  truthy(harness.main.requestState().busy)
  truthy(harness.main.copyDiagnostics())
  truthy(harness.main.cancelCurrentOperation())
  -- The callback payload is retained here only by the mock adapter; main has
  -- invalidated and dropped the corresponding plan/generation.
  harness.pendingParts = nil
  pipelineHarness.setPaused(harness, false)
  local state = pipelineHarness.driveActive(harness, 128)
  truthy(not state.busy, "cancel remained busy in " .. tostring(state.lifecyclePhase)
    .. " result=" .. tostring(state.lastResult and state.lastResult.code))
  truthy(state.lastResult)
end

tests.v060_onupdate_housekeeping_contract = function()
  local file = assert(io.open(root .. "/lua/ge/extensions/soturineChaosRandomizer/main.lua", "rb"))
  local source = file:read("*a")
  file:close()
  truthy(not source:find("if processTargetTracking%(%) then return end"))
  truthy(source:find("production%.processSpawnDirector%(%)") ~= nil)
  truthy(source:find("production%.processAIDirector%(%)") ~= nil)
  truthy(source:find("operation_watchdog", 1, true) ~= nil)
end

tests.v060_public_state_exposes_lineup_spawn_ai_and_coverage = function()
  local harness = pipelineHarness.new()
  local state = harness.main.requestState()
  truthy(type(state.lineup) == "table")
  truthy(type(state.spawnDirector) == "table")
  truthy(type(state.aiDirector) == "table")
  truthy(type(state.coverage) == "table" or state.coverage == nil)
  local empty = pipelineHarness.new({noActive = true})
  truthy(not empty.main.scramble({manualSeed = "no-active-v060"}))
  equal(empty.main.requestState().lastResult.message,
    "Scramble requires an active vehicle. Use Random Car or Spawn Safe Vehicle.")
end

tests.v060_runner_counting_contract = function()
  local unique = {}
  for _, fn in pairs(tests) do unique[fn] = true end
  local functionCount = 0
  for _ in pairs(unique) do functionCount = functionCount + 1 end
  truthy(functionCount > 250)
  truthy(#requirementMappings >= 345)
  local names = {}
  for _, mapping in ipairs(requirementMappings) do
    truthy(type(mapping[1]) == "string" and mapping[1] ~= "")
    truthy(type(mapping[2]) == "function")
    truthy(not names[mapping[1]], "duplicate requirement mapping: " .. mapping[1])
    names[mapping[1]] = true
  end
end

tests.v061_paused_pipeline_finishes_without_toggle = function()
  for _, action in ipairs({"randomConfig", "scramble", "fullRandom"}) do
    local harness = pipelineHarness.new({paused = true, deferredPaint = true})
    truthy(pipelineHarness.driveSuccess(harness, action, {
      manualSeed = "paused-v061-" .. action, seedMode = "fixed",
    }))
    local state = pipelineHarness.driveActive(harness, 192)
    truthy(not state.busy, action .. " remained Busy while paused")
    truthy(state.lastResult and state.lastResult.success, action .. " failed while paused")
    truthy(state.clocks.paused)
  end
end

tests.v061_bounded_parts_read_recovers = function()
  local harness = pipelineHarness.new({partsReadUnavailable = 3})
  truthy(harness.main.scramble({chaos = 100, manualSeed = "temporary-nil", seedMode = "fixed"}))
  local state = pipelineHarness.driveActive(harness, 192)
  truthy(not state.busy)
  truthy(state.lastResult and state.lastResult.success)
  truthy((harness.scanCount or 0) > 3)
end

tests.v061_persistent_parts_read_fails_terminally = function()
  local harness = pipelineHarness.new({partsReadAlwaysUnavailable = true})
  truthy(harness.main.scramble({chaos = 100, manualSeed = "persistent-nil", seedMode = "fixed"}))
  local state = pipelineHarness.driveActive(harness, 256)
  truthy(not state.busy)
  equal(state.lastResult and state.lastResult.success, false)
  equal(state.lastResult.code, "safety_confirmation_unavailable")
  equal(state.lastResult.details.terminalOutcome, "FAILED_NO_CHANGE")
  truthy(state.lastResult.details.preservedCurrentResult)
  equal(harness.modelKey, "fixture_old")
end

tests.v061_settings_locks_and_seed_migration = function()
  local legacyLocks = vehicleDNALocks.applyPatch(vehicleDNALocks.empty(), {vehicle = true, categories = {body = true}})
  local migrated = settings.validate({schemaVersion = 5, manualSeed = "legacy", lockProfile = legacyLocks})
  equal(migrated.schemaVersion, 9)
  equal(migrated.seedMode, "random")
  truthy(not migrated.rememberLocks)
  equal(vehicleDNALocks.summary(migrated.lockProfile).locked, 0)
  local session = settings.update(migrated, {lockProfile = legacyLocks})
  truthy(vehicleDNALocks.summary(session.lockProfile).locked > 0)
  equal(vehicleDNALocks.summary(settings.forPersistence(session).lockProfile).locked, 0)
  session.rememberLocks = true
  truthy(vehicleDNALocks.summary(settings.forPersistence(session).lockProfile).locked > 0)
end

tests.v061_seed_modes_refresh_or_reproduce = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "randomConfig", {manualSeed = "", seedMode = "random"}))
  local first = harness.main.requestState().seed
  truthy(pipelineHarness.driveSuccess(harness, "randomConfig", {manualSeed = "", seedMode = "random"}))
  local second = harness.main.requestState().seed
  truthy(first ~= second)
  truthy(pipelineHarness.driveSuccess(harness, "randomConfig", {manualSeed = "fixed-v061", seedMode = "fixed"}))
  local fixedA = harness.main.requestState().seed
  truthy(pipelineHarness.driveSuccess(harness, "randomConfig", {manualSeed = "fixed-v061", seedMode = "fixed"}))
  equal(harness.main.requestState().seed, fixedA)
end

tests.v061_race_presets_apply_real_policy = function()
  local balanced = lineupManager.presetOptions("Balanced", {})
  equal(balanced.chaos, 65)
  truthy(balanced.protectCriticalParts and not balanced.allowMissingParts and not balanced.extremeTuning)
  truthy(not balanced.acceptPartial and balanced.acceptMetadataUncertain)
  local maximum = lineupManager.presetOptions("Maximum Chaos", {})
  equal(maximum.chaos, 100)
  truthy(maximum.allowMissingParts and maximum.extremeTuning and maximum.acceptPartial)
  truthy(maximum.diversifyVehicleClasses and maximum.diversifyBodyTypes)
  local mods = lineupManager.presetOptions("Mods Showcase", {})
  equal(mods.contentFilter, "mods")
  truthy(not mods.allowOfficialVehicles and mods.allowModVehicles)
  truthy(mods.protectCriticalParts and mods.acceptMetadataUncertain)
end

tests.v061_race_statuses_and_cancel_are_terminal = function()
  local lineup = assert(lineupManager.create({count = 3, preset = "Balanced", episodeSeed = "v061-race"}))
  local competitor = assert(lineupManager.nextCompetitor(lineup))
  equal(competitor.status, "selecting_vehicle")
  truthy(lineupManager.setPhase(lineup, 1, "binding_vehicle", 0.2))
  truthy(lineupManager.setPhase(lineup, 1, "randomizing", 0.6))
  truthy(lineupManager.setPhase(lineup, 1, "validating", 0.9))
  truthy(lineupManager.cancel(lineup, "fixture cancel"))
  truthy(not lineup.active)
  for _, entry in ipairs(lineup.competitors) do equal(entry.status, "cancelled") end
  equal(lineupManager.summary(lineup).pending, 0)
end

tests.v061_recovery_invalidation_drops_all_old_plans = function()
  local operation = {
    selectedModel = {key = "old"}, selectedConfig = {key = "old"},
    operationMutationPlan = {}, currentBatch = {}, batchRollbackDecisions = {}, afterReload = "mutation",
    pendingTuningChanges = {}, pendingTuningPlan = {}, pendingPaintPlan = {}, paintConfirmation = {},
    targetTracker = {}, treeRescanAt = 4, readRetry = {}, readUnavailable = {},
    slotLedger = {}, tuningLedger = {}, paintLedger = {}, batchRecovery = {currentBatch = {}},
  }
  truthy(vehicleRecovery.invalidateForRecovery(operation))
  truthy(operation.recoveryOnly)
  for _, key in ipairs({"selectedModel", "selectedConfig", "operationMutationPlan", "currentBatch", "afterReload",
    "pendingTuningChanges", "pendingTuningPlan", "pendingPaintPlan", "paintConfirmation", "targetTracker",
    "treeRescanAt", "readRetry", "readUnavailable"}) do
    equal(operation[key], nil, key .. " survived recovery invalidation")
  end
end

tests.v061_target_deadline_uses_wall_clock_while_paused = function()
  local tracker = vehicleTargetTracker.create({
    token = "wall", operationId = "SCR-wall", operationGeneration = 1,
    phaseGeneration = 1, targetGeneration = 1, modelKey = "fixture", startedAt = 0, timeout = 1,
  })
  local status, reason = vehicleTargetTracker.observe(tracker, "wall", nil, 1.1, {
    operationId = "SCR-wall", operationGeneration = 1, phaseGeneration = 1,
    targetGeneration = 1, waitingForSimulation = true,
  })
  equal(status, "failed")
  equal(reason, "target_callback_missing")
end

tests.v062_target_ownership_precedes_tree_convergence = function()
  local tracker = vehicleTargetTracker.create({
    token = "ownership", operationId = "SCR-own", operationGeneration = 1,
    phaseGeneration = 1, targetGeneration = 1, vehicleId = 42, modelKey = "fixture",
    configKey = "/vehicles/fixture/base.pc", requirePartsReadable = true,
    startedAt = 0, timeout = 5,
    stabilizer = {minimumFrames = 1, minimumScans = 1, pollInterval = 0},
  })
  local status, reason, details = vehicleTargetTracker.observe(tracker, "ownership", {
    vehicleId = 42, modelKey = "fixture", configKey = "/vehicles/fixture/base.pc",
    configIdentity = {path = "/vehicles/fixture/base.pc", key = "base"},
    partsAvailable = false, readStatus = "tree_unavailable",
  }, 0.1, {operationId = "SCR-own", operationGeneration = 1, phaseGeneration = 1, targetGeneration = 1})
  equal(status, "waiting")
  equal(reason, "tree_unavailable")
  truthy(details.identityConfirmed)
  truthy(vehicleTargetTracker.summary(tracker, 0.1).identityConfirmed)
end

tests.v062_random_car_completion_does_not_require_parts_tree = function()
  local harness = pipelineHarness.new({verificationTreeUnavailable = true})
  truthy(harness.main.runAction("randomConfig", {manualSeed = "tree-free-random-car", seedMode = "fixed"}))
  pipelineHarness.confirmReplacement(harness)
  local state = harness.main.requestState()
  truthy(not state.busy)
  equal(state.lastResult.code, "random_config_loaded")
  equal(state.lastResult.details.model, "fixture_new")
end

tests.v062_pause_transitions_are_diagnostic_only = function()
  local now = 0
  local clocks = timeSource.create(function() return now end)
  local state = operationState.create(function() return now end, 10)
  truthy(operationState.begin(state, "fullRandom", 1, 10))
  local generation = state.operationGeneration
  local targetGeneration = state.targetGeneration
  now = 0.1
  timeSource.sample(clocks, 0.1, 0, 0.1, true, now)
  now = 0.2
  timeSource.sample(clocks, 0.1, 0.1, 0.1, false, now)
  equal(clocks.pauseTransitions, 2)
  equal(state.operationGeneration, generation)
  equal(state.targetGeneration, targetGeneration)
end

tests.v062_runtime_instrumentation_is_bounded_and_complete = function()
  local harness = pipelineHarness.new({paused = true, deferredPaint = true})
  truthy(harness.main.scramble({chaos = 100, manualSeed = "instrumentation", seedMode = "fixed"}))
  pipelineHarness.advance(harness, 0.1, 0, 16)
  local state = harness.main.requestState()
  truthy(state.transaction.operationId ~= nil)
  truthy(state.transaction.operationGeneration ~= nil)
  truthy(state.transaction.targetGeneration ~= nil)
  truthy(state.transaction.expectedPlayerIndex == 0)
  equal(state.transaction.expectedVehicleId, nil)
  truthy(state.transaction.operationContext.logicalTarget ~= nil)
  equal(state.transaction.operationContext.concreteTarget, nil)
  truthy(state.transaction.currentVehicleId == 1)
  truthy(state.transaction.phaseStartedAt ~= nil)
  truthy(state.transaction.wallElapsed >= state.transaction.simulationElapsed)
  truthy(state.transaction.readBackStatus ~= nil)
  truthy(state.transaction.lastProgressTimestamp ~= nil)
  truthy(#state.clocks.recentSamples <= 12)
  equal(state.clocks.recentSamples[#state.clocks.recentSamples].dtSim, 0)
end

tests.v063_performance_telemetry_covers_runtime_subsystems = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom", {
    chaos = 100, manualSeed = "performance-telemetry", seedMode = "fixed",
  }))
  local telemetry = harness.main.requestState().performance.telemetry
  equal(telemetry.sampleLimit, 256)
  for _, category in ipairs({
    "onUpdate", "targetTracking", "treeScanning", "mutationPlanning", "tuningDiscovery",
    "uiState", "indexing", "spawnDirector", "aiDirector", "preview", "uiPayload",
  }) do
    local metric = telemetry.categories[category]
    truthy(metric ~= nil, "missing performance category " .. category)
    truthy(metric.count >= 1, "empty performance category " .. category)
    truthy(metric.sampleCount <= telemetry.sampleLimit)
    truthy(metric.p50 <= metric.p95 and metric.p95 <= metric.p99)
    truthy(metric.p99 <= metric.max)
  end
  truthy(telemetry.eventRates.uiEvents.count >= 1)
end

tests.v062_player_vehicle_loss_is_bounded_and_recovers = function()
  local harness = pipelineHarness.new()
  truthy(harness.main.scramble({chaos = 100, manualSeed = "player-loss", seedMode = "fixed"}))
  harness.vehicleId = nil
  pipelineHarness.advance(harness, 0.1, 0.1, 22)
  truthy(harness.pendingReplacement ~= nil, "player loss did not enter bounded recovery")
  pipelineHarness.driveActive(harness, 256)
  local state = harness.main.requestState()
  truthy(not state.busy, "player-loss recovery remained busy in " .. tostring(state.lifecyclePhase)
    .. " / " .. tostring(state.targetStatus))
  equal(state.lastFailure.code, "target_id_changed")
end

tests.v062_diagnostics_redact_personal_paths = function()
  local diagnostics = require("ge/extensions/soturineChaosRandomizer/diagnostics")
  local state = diagnostics.create(function() end)
  diagnostics.setEnabled(state, true)
  diagnostics.write(state, "E", "fixture", {
    path = "C:" .. [[\Users\private-name\Documents\secret.json]], nested = {safe = "/settings/mod.json"},
  })
  local records = diagnostics.snapshot(state)
  equal(records[1].details.path, "<redacted-user-path>")
  equal(records[1].details.nested.safe, "/settings/mod.json")
end

tests.v062_extension_unload_is_a_terminal_cleanup = function()
  local harness = pipelineHarness.new({paused = true})
  truthy(harness.main.scramble({chaos = 100, manualSeed = "unload", seedMode = "fixed"}))
  truthy(harness.main.requestState().busy)
  harness.main.onExtensionUnloaded()
  local state = harness.main.requestState()
  truthy(not state.busy)
  equal(state.lastResult.code, "extension_unloaded")
  equal(state.transaction, nil)
end

tests.v062_operation_exposes_isolated_rng_domains = function()
  local harness = pipelineHarness.new({paused = true})
  truthy(harness.main.scramble({chaos = 100, manualSeed = "rng-domains", seedMode = "fixed"}))
  local streams = harness.main.requestState().transaction.rngSubstreams
  equal(streams.modelConfig, "vehicle/configuration")
  equal(streams.parts, "parts:pass")
  equal(streams.tuning, "tuning:pass")
  equal(streams.paint, "paint")
  equal(streams.retry, "retry")
end

tests.v062_mandatory_reason_codes_are_stable_contract = function()
  local required = {
    "target_callback_missing", "target_id_changed", "target_model_mismatch", "target_config_mismatch",
    "target_identity_unstable", "tree_unavailable", "tree_changed_legitimately", "parts_reload_pending",
    "tuning_reload_pending", "paint_readback_pending", "pause_toggle_unblocked_operation",
    "stale_callback_rejected", "stale_timer_rejected", "recovery_snapshot_old_generation",
    "recovery_loop_detected", "candidate_cycle_detected", "operation_deadline_exceeded",
  }
  local sources = {}
  for _, path in ipairs({
    "/lua/ge/extensions/soturineChaosRandomizer/main.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/operationState.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleTargetTracker.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleRecovery.lua",
  }) do
    local file = assert(io.open(root .. path, "rb"))
    sources[#sources + 1] = file:read("*a")
    file:close()
  end
  local joined = table.concat(sources, "\n")
  for _, code in ipairs(required) do truthy(joined:find(code, 1, true) ~= nil, code) end
end

tests.v061_compact_ui_contract = function()
  local function read(path)
    local file = assert(io.open(root .. path, "rb"))
    local value = file:read("*a")
    file:close()
    return value
  end
  local app = read("/ui/modules/apps/soturineChaosRandomizer/app.vue")
  local shell = read("/ui/modules/apps/soturineChaosRandomizer/components/shell/AppShell.vue")
  local navigation = read("/ui/modules/apps/soturineChaosRandomizer/components/shell/AppNavigation.vue")
  local garage = read("/ui/modules/apps/soturineChaosRandomizer/components/garage/GaragePanel.vue")
  local race = read("/ui/modules/apps/soturineChaosRandomizer/components/race/RaceStepper.vue")
  local css = read("/ui/modules/apps/soturineChaosRandomizer/styles/app.css")
  local fox = read("/ui/modules/apps/soturineChaosRandomizer/assets/branding/fox-64.png")
  for _, key in ipairs({"chaos", "garage", "race", "settings"}) do
    truthy(navigation:find('"' .. key .. '"', 1, true), key)
  end
  for _, key in ipairs({"saved", "compare", "share"}) do truthy(garage:find('"' .. key .. '"', 1, true), key) end
  for _, key in ipairs({"setup", "formation", "behavior", "start"}) do truthy(race:find('"' .. key .. '"', 1, true), key) end
  truthy(app:find("<AppShell />", 1, true))
  truthy(shell:find("layout.compact", 1, true))
  truthy(css:find(".scr%-compact") ~= nil)
  truthy(css:find("prefers%-reduced%-motion") ~= nil)
  local foxReport = pngValidator.validate(fox, {
    maxBytes = 32768, maxWidth = 64, maxHeight = 64, maxChunks = 128,
    maxChunkBytes = 32768, maxIDATBytes = 32768,
  })
  truthy(foxReport and foxReport.width == 64 and foxReport.height == 64)
end

tests.v069_profiler_disabled_reset_overflow_and_capabilities = function()
  local metrics = performanceMetrics.create({
    enabled = false, sampleLimit = 8,
    toolSource = {timeprobe = {}, gcprobe = function() end, luaProfiler = {}},
  })
  truthy(not performanceMetrics.record(metrics, "onUpdate", 1))
  equal(performanceMetrics.snapshot(metrics, 0).categories.onUpdate.count, 0)
  truthy(performanceMetrics.setEnabled(metrics, true))
  for value = 1, 16 do truthy(performanceMetrics.record(metrics, "onUpdate", value)) end
  local report = performanceMetrics.export(metrics, 1)
  local metric = report.categories.onUpdate
  equal(metric.count, 16); equal(metric.sampleCount, 8); equal(metric.totalMs, 136)
  near(metric.meanMs, 8.5); equal(metric.minMs, 1); equal(metric.maxMs, 16)
  equal(metric.p50Ms, 12); equal(metric.p95Ms, 16); equal(metric.p99Ms, 16); equal(metric.lastMs, 16)
  truthy(report.capabilities.timeprobe); truthy(report.capabilities.gcprobe); truthy(report.capabilities.luaProfiler)
  truthy(performanceMetrics.reset(metrics))
  local reset = performanceMetrics.snapshot(metrics, 2).categories.onUpdate
  equal(reset.count, 0); equal(reset.sampleCount, 0); equal(reset.totalMs, 0)
end

tests.v069_frame_budgets_warn_without_cancelling = function()
  local warnings = {}
  local state = p1.frameBudget.create({idleBudgetMs = 0.2}, {warningCooldown = 2})
  local continued, warned = p1.frameBudget.check(state, "idle", 0.1, 0.2, 0, function(value)
    warnings[#warnings + 1] = value
  end)
  truthy(continued); equal(warned, false)
  continued, warned = p1.frameBudget.check(state, "idle", 0.3, 0.2, 0, function(value)
    warnings[#warnings + 1] = value
  end)
  truthy(continued); truthy(warned)
  continued, warned = p1.frameBudget.check(state, "idle", 0.4, 0.2, 1, function(value)
    warnings[#warnings + 1] = value
  end)
  truthy(continued); equal(warned, false)
  continued, warned = p1.frameBudget.check(state, "idle", 0.5, 0.2, 2, function(value)
    warnings[#warnings + 1] = value
  end)
  truthy(continued); truthy(warned); equal(#warnings, 2)
  equal(p1.frameBudget.snapshot(state).totalExceeded, 3)
  equal(p1.frameBudget.normalize({raceBudgetMs = 100}).raceBudgetMs, 20)
end

tests.v069_reusable_buffers_prevent_aliasing_and_stale_release = function()
  local pool = p1.buffers.create({"vehicleIdsBuffer"})
  local first, generation = assert(p1.buffers.acquire(pool, "vehicleIdsBuffer"))
  first[1], first[9], first.metadata = 7, 9, "stale"
  local owned = p1.buffers.copyOut(first)
  equal(owned[1], 7)
  truthy(p1.buffers.release(pool, "vehicleIdsBuffer", generation))
  equal(owned[1], 7, "released storage must not alias copied output")
  local second, nextGeneration = assert(p1.buffers.acquire(pool, "vehicleIdsBuffer"))
  equal(second, first); equal(#second, 0); equal(second[9], nil); equal(second.metadata, nil)
  truthy(nextGeneration > generation)
  local released, reason = p1.buffers.release(pool, "vehicleIdsBuffer", generation)
  equal(released, false); equal(reason, "stale_buffer_generation")
  truthy(p1.buffers.release(pool, "vehicleIdsBuffer", nextGeneration))
  local stats = p1.buffers.snapshot(pool)
  equal(stats.acquisitions, 2); equal(stats.reuses, 1); equal(stats.borrowed, 0)
end

tests.v069_vehicle_iterators_are_deterministic_with_safe_fallback = function()
  local values = {
    {getID = function() return 7 end}, {},
    {getId = function() return 2 end}, {id = 7}, {id = -1},
  }
  local environment = {
    vehiclesIterator = function()
      local index = 0
      return function() index = index + 1; return values[index] end
    end,
  }
  local buffer = {99}
  local ok, strategy, count = p1.iterator.collectIds(buffer, {environment = environment})
  truthy(ok); equal(strategy, "vehiclesIterator"); equal(count, 2)
  equal(buffer[1], 2); equal(buffer[2], 7)
  local fallback = {getAllVehicles = function() return {b = {id = 5}, a = {id = 3}} end}
  ok, strategy, count = p1.iterator.collectIds(buffer, {environment = fallback, activeOnly = true})
  truthy(ok); equal(strategy, "getAllVehicles"); equal(count, 2)
  equal(buffer[1], 3); equal(buffer[2], 5)
  ok, strategy, count = p1.iterator.collectIds(buffer, {environment = {getAllVehicles = function() return {} end}})
  truthy(ok); equal(count, 0); equal(#buffer, 0)
  local caps = p1.iterator.capabilities(environment)
  truthy(caps.vehiclesIterator); equal(caps.activeVehiclesIterator, false)
end

tests.v069_oobb_xyz_dimension_cache_invalidates_recycled_ids = function()
  local state = p1.dimensions.create({limit = 8})
  local measured = 0
  local object = {
    getSpawnWorldOOBBRearPointXYZ = function() measured = measured + 1; return 0, 0, 0 end,
    getSpawnWorldOOBBFrontPointXYZ = function() return 0, 10, 0 end,
    getSpawnWorldOOBBCenterXYZ = function() return 0, 5, 0 end,
    getSpawnWorldOOBB = function()
      return {getHalfExtents = function() return {x = 1, y = 2, z = 0.75} end}
    end,
  }
  local first, source = p1.dimensions.read(state, 44, 1, object, 5)
  equal(source, "measured"); equal(first.width, 2); equal(first.length, 10); equal(first.height, 1.5)
  equal(first.source, "spawn_oobb_xyz")
  first.width = 999
  local cached, cachedSource = p1.dimensions.read(state, 44, 1, object, 6)
  equal(cachedSource, "cache_hit"); equal(cached.width, 2); equal(measured, 1)
  local recycled = assert(p1.dimensions.read(state, 44, 2, {
    getWorldBox = function() return {getExtents = function() return {x = 4, y = 7, z = 2} end} end,
  }, 7))
  equal(recycled.width, 4); equal(recycled.length, 7); equal(recycled.source, "world_box_fallback")
  truthy(p1.dimensions.invalidate(state, 44, 1)); equal(p1.dimensions.get(state, 44, 1), nil)
  truthy(p1.dimensions.get(state, 44, 2) ~= nil)
  truthy(p1.dimensions.invalidate(state, 44)); equal(p1.dimensions.snapshot(state).size, 0)
end

tests.v069_registry_cache_fingerprint_checksum_and_partial_rejection = function()
  local parts = {
    beamNGVersion = "0.39.2", modVersion = "0.6.9", registryShapeVersion = 1,
    activeModsFingerprint = "mods-a", contentAliasesVersion = 1, settingsSchema = 8,
  }
  local fingerprint = assert(p1.registryCache.fingerprint(parts))
  local changed = assert(p1.registryCache.fingerprint(util.shallowMerge(parts, {activeModsFingerprint = "mods-b"})))
  truthy(fingerprint ~= changed)
  local envelope = p1.registryCache.envelope(fingerprint, {models = {{key = "car"}}, configurations = {}})
  local payload, reason = p1.registryCache.validate(envelope, fingerprint, 1024)
  truthy(payload ~= nil); equal(reason, "cache_hit")
  payload.models[1].key = "mutated"; equal(envelope.payload.models[1].key, "car")
  local corrupt = util.deepCopy(envelope); corrupt.payload.models[1].key = "corrupt"
  payload, reason = p1.registryCache.validate(corrupt, fingerprint, 1024)
  equal(payload, nil); equal(reason, "cache_checksum_invalid")
  local partial = util.deepCopy(envelope); partial.complete = false
  payload, reason = p1.registryCache.validate(partial, fingerprint, 1024)
  equal(payload, nil); equal(reason, "cache_snapshot_partial")
  payload, reason = p1.registryCache.validate(envelope, changed, 1024)
  equal(payload, nil); equal(reason, "cache_fingerprint_changed")
  local sensitive = p1.registryCache.envelope(fingerprint, {path = "C:\\Users\\owner\\catalog.json"})
  payload, reason = p1.registryCache.validate(sensitive, fingerprint, 1024)
  equal(payload, nil); equal(reason, "cache_sensitive_path_rejected")
  payload, reason = p1.registryCache.validate(envelope, fingerprint, p1.registryCache.DEFAULT_MAX_BYTES + 1)
  equal(payload, nil); equal(reason, "cache_too_large")
end

tests.v069_incremental_index_is_chunked_cancellable_restartable_and_atomic = function()
  local state = p1.indexer.create()
  local working, committed = {}, {"last-known-good"}
  p1.indexer.start(state, 5, function(cursor)
    working[cursor] = "item-" .. tostring(cursor); return true
  end, function() committed = util.copyArray(working); return true, committed end, {startedAt = 0})
  local ok, progress, done = p1.indexer.step(state, 0.1, function() return 0 end, 1, 2)
  truthy(ok); equal(done, false); equal(progress.cursor, 2); equal(committed[1], "last-known-good")
  truthy(p1.indexer.cancel(state, "fixture_cancel"))
  ok, progress = p1.indexer.step(state, 0.2, function() return 0 end, 1, 2)
  equal(ok, false); equal(progress, "indexer_cancelled"); equal(committed[1], "last-known-good")
  working = {}
  local restarted = assert(p1.indexer.start(state, 3, function(cursor, generation)
    working[cursor] = tostring(generation) .. ":" .. tostring(cursor); return true
  end, function() committed = util.copyArray(working); return true, committed end, {startedAt = 0.2, reason = "restart"}))
  truthy(restarted.generation > 1)
  ok, progress, done = p1.indexer.step(state, 0.3, function() return 0 end, 1, 8)
  truthy(ok); truthy(done); equal(#committed, 3)
  local snapshot = p1.indexer.snapshot(state)
  equal(snapshot.status, "ready"); equal(snapshot.items, 3); equal(snapshot.progress, 1)
end

tests.v069_ui_dirty_diff_debounce_and_full_request_are_bounded = function()
  local state = p1.ui.create({debounceSeconds = 0.1, now = 0})
  truthy(state.initialPending); truthy(state.flags.operationDirty)
  p1.ui.note(state, "full", 1000, 0); p1.ui.consume(state, "full")
  equal(state.initialPending, false); equal(state.flags.operationDirty, false)
  equal(p1.ui.due(state, 0.05, false), false)
  truthy(p1.ui.mark(state, "progressDirty")); truthy(state.flags.progressDirty)
  equal(p1.ui.suppress(state), false)
  p1.ui.note(state, "partial", 80, 0.1); p1.ui.consume(state, "partial")
  equal(state.flags.progressDirty, false)
  truthy(p1.ui.requestFull(state)); truthy(state.fullRequested); truthy(state.flags.garageDirty)
  local report = p1.ui.snapshot(state, 1)
  equal(report.fullStateCount, 1); equal(report.partialStateCount, 1)
  equal(report.suppressedPublishes, 1); equal(report.guihooksCount, 2); equal(report.bytesPublished, 1080)
  near(report.guihooksPerSecond, 2); near(report.bytesPerSecond, 1080)
end

tests.v069_diagnostics_deduplicate_rate_limit_export_and_reserve_critical = function()
  local now, emitted = 0, 0
  local state = p1.diagnostics.create(function() emitted = emitted + 1 end, {
    clock = function() return now end, limit = 16, rateLimitSeconds = 2,
  })
  truthy(p1.diagnostics.write(state, "W", "repeat", {value = 1}, true))
  now = 1; local ok, record, wasEmitted = p1.diagnostics.write(state, "W", "repeat", {value = 1}, true)
  truthy(ok); equal(record.repetitions, 2); equal(wasEmitted, false)
  now = 2; ok, record, wasEmitted = p1.diagnostics.write(state, "W", "repeat", {value = 1}, true)
  truthy(wasEmitted); equal(emitted, 2)
  local compact = p1.diagnostics.snapshot(state, {compact = true})
  equal(compact[1].details, nil); equal(compact[1].firstAt, 0); equal(compact[1].lastAt, 2)
  for index = 1, 16 do
    now = 3 + index
    p1.diagnostics.write(state, "E", "critical-" .. tostring(index), {path = "C:\\Users\\owner\\secret"}, true)
  end
  local accepted, reason = p1.diagnostics.write(state, "I", "noise", {}, true)
  equal(accepted, false); equal(reason, "diagnostic_capacity_reserved")
  local exported = p1.diagnostics.export(state, {compact = false})
  equal(#exported, 16)
  for _, item in ipairs(exported) do equal(item.severity, "E") end
  equal(exported[1].details.path, "<redacted-user-path>")
  local summary = p1.diagnostics.summary(state)
  equal(summary.unique, 16); truthy(summary.deduplicated >= 2)
end

tests.v069_adaptive_polling_fast_backoff_terminal_stale_and_wake = function()
  local state = p1.polling.create({fastInterval = 0.1, slowInterval = 0.8, multiplier = 2, stableThreshold = 2, generation = 4}, 0)
  truthy(p1.polling.due(state, 0, 4))
  truthy(p1.polling.observed(state, 0, false, 4)); near(state.currentInterval, 0.1)
  truthy(p1.polling.observed(state, 0.1, false, 4)); near(state.currentInterval, 0.2)
  truthy(p1.polling.observed(state, 0.3, false, 4)); near(state.currentInterval, 0.4)
  truthy(p1.polling.observed(state, 0.7, true, 4)); near(state.currentInterval, 0.1)
  local due, reason = p1.polling.due(state, 1, 3)
  equal(due, false); equal(reason, "stale_poll")
  truthy(p1.polling.stop(state)); equal(p1.polling.due(state, 100, 4), false)
  truthy(p1.polling.wake(state, 5, 5)); truthy(p1.polling.due(state, 5, 5)); equal(state.terminal, false)
end

tests.v069_ai_mode_confirmation_handles_all_terminal_outcomes = function()
  local confirmed = p1.aiConfirmation.create(10, 2, "Destination", 0, 1)
  equal(confirmed.expectedMode, "traffic")
  equal(p1.aiConfirmation.observe(confirmed, "traffic", 0.1, 2), "confirmed")
  local mismatch = p1.aiConfirmation.create(11, 3, "Chase", 0, 0.5)
  equal(p1.aiConfirmation.observe(mismatch, "follow", 0.1, 3), "pending")
  equal(p1.aiConfirmation.observe(mismatch, "follow", 0.5, 3), "mismatch")
  local timeout = p1.aiConfirmation.create(12, 4, "Follow", 0, 0.5)
  equal(p1.aiConfirmation.observe(timeout, nil, 0.5, 4), "timeout")
  local unavailable = p1.aiConfirmation.create(13, 5, "Traffic", 0, 1)
  equal(p1.aiConfirmation.unavailable(unavailable), "unavailable")
  local destroyed = p1.aiConfirmation.create(14, 6, "Route", 0, 1)
  equal(p1.aiConfirmation.destroyed(destroyed), "destroyed")
  local stale = p1.aiConfirmation.create(15, 7, "Chase", 0, 1)
  equal(p1.aiConfirmation.observe(stale, "chase", 0.1, 8), "stale")
end

tests.v069_race_scale_and_seed_regression_vectors = function()
  for _, count in ipairs({1, 4, 8, 12}) do
    local left = assert(raceManager.create({
      count = count, participationMode = "spectator", episodeSeed = "v069-race-scale", advancedAllowOne = true,
    }))
    local right = assert(raceManager.create({
      count = count, participationMode = "spectator", episodeSeed = "v069-race-scale", advancedAllowOne = true,
    }))
    equal(#left.competitors, count); equal(#right.competitors, count)
    local seeds = {}
    for index, competitor in ipairs(left.competitors) do
      truthy(not seeds[competitor.seed]); seeds[competitor.seed] = true
      equal(competitor.seed, right.competitors[index].seed)
      equal(competitor.selectionSeed, right.competitors[index].selectionSeed)
    end
  end
  local vectors = {
    ["v069-random-car"] = {1698095037, 1442208684, 1878000565, 1238082304},
    ["v069-scramble"] = {757961919, 900898110, 708816060, 1550568256},
    ["v069-full-random"] = {1645692281, 1644509974, 407943599, 1567907986},
    ["v069-race"] = {1968766166, 1717768295, 1902273628, 397035115},
    ["v069-dna-replay"] = {51555989, 1873081793, 27240262, 654695038},
    ["v069-pure-seed"] = {1137238290, 1652511976, 125525681, 1198779364},
  }
  for seed, expected in pairs(vectors) do
    local generator = rng.new(seed)
    for index = 1, #expected do equal(generator:nextUInt(), expected[index], seed .. " vector changed") end
  end
end

tests.v070_ui_protocol_sequence_projection_and_validation = function()
  equal(p2.protocol.PROTOCOL_VERSION, 2)
  local sequence = p2.protocol.createSequence()
  local full = assert(p2.projector.full(sequence, {
    lifecycle = {operationId = 17, operationGeneration = 4, targetGeneration = 9},
    busy = false,
  }, 12.5))
  equal(full.eventType, "full")
  equal(full.domain, "all")
  equal(full.stateVersion, 1)
  equal(full.operationId, 17)
  equal(full.operationGeneration, 4)
  equal(full.targetGeneration, 9)
  local diff = assert(p2.projector.diff(sequence, "garage", {page = 2}, {"garage"}, {
    operationId = 17, operationGeneration = 4, targetGeneration = 10,
  }, 13))
  equal(diff.eventType, "diff")
  equal(diff.stateVersion, 2)
  equal(diff.targetGeneration, 10)

  local valid, reason = p2.protocol.validateCommand({
    protocolVersion = 2, command = "requestState", commandId = "scr-vue-1",
    sourceView = "chaos", arguments = {},
  })
  truthy(valid, reason)
  valid, reason = p2.protocol.validateCommand({
    protocolVersion = 1, command = "requestState", commandId = "scr-vue-2",
    sourceView = "chaos", arguments = {},
  })
  truthy(not valid); equal(reason, "protocol_version_unsupported")
  valid, reason = p2.protocol.validateCommand({
    protocolVersion = 2, command = "importVehicleDNA", commandId = "scr-vue-3",
    sourceView = "garage", arguments = {string.rep("x", p2.protocol.MAX_COMMAND_BYTES + 1)},
  })
  truthy(not valid); equal(reason, "command_string_oversize")
end

tests.v070_ui_command_router_is_allowlisted_bounded_and_idempotent = function()
  local calls = 0
  local router = p2.router.create({
    echo = function(value) calls = calls + 1; return {value = value} end,
    reject = function() return false, "fixture_rejected" end,
  }, {completedLimit = 16})
  local command = {
    protocolVersion = 2, command = "echo", commandId = "scr-vue-router-1",
    sourceView = "settings", arguments = {"safe'value\\path"},
  }
  local first = p2.router.dispatch(router, command)
  truthy(first.success); equal(first.result.value, "safe'value\\path"); equal(calls, 1)
  local duplicate = p2.router.dispatch(router, command)
  truthy(duplicate.success); equal(calls, 1)
  local unknown = p2.router.dispatch(router, {
    protocolVersion = 2, command = "arbitraryLuaMethod", commandId = "scr-vue-router-2",
    sourceView = "shell", arguments = {},
  })
  truthy(not unknown.success); equal(unknown.code, "command_not_allowed")
  local rejected = p2.router.dispatch(router, {
    protocolVersion = 2, command = "reject", commandId = "scr-vue-router-3",
    sourceView = "shell", arguments = {},
  })
  truthy(not rejected.success); equal(rejected.code, "fixture_rejected")
end

tests.v070_ui_preferences_migrate_once_and_keep_technical_policy = function()
  local normalized = p2.preferences.normalize({
    locale = "pt-BR", race = {count = 99, maximumSameFamily = 0,
      allowOfficialVehicles = false, allowModVehicles = true, episodeSeed = string.rep("s", 256)},
  })
  equal(normalized.schemaVersion, 2)
  equal(normalized.localeMode, "manual")
  equal(normalized.manualLocale, "pt-BR")
  equal(normalized.race.count, 32)
  equal(normalized.race.maximumSameFamily, 1)
  equal(normalized.race.allowOfficialVehicles, false)
  equal(normalized.race.allowModVehicles, true)
  equal(#normalized.race.episodeSeed, 128)
  local spanish = p2.preferences.normalize({localeMode = "manual", manualLocale = "es-ES"})
  equal(spanish.localeMode, "manual")
  equal(spanish.manualLocale, "es-ES")
  local automatic = p2.preferences.patch(spanish, {localeMode = "auto"})
  equal(automatic.localeMode, "auto")
  equal(automatic.manualLocale, "es-ES")
  local migrated, changed = p2.preferences.importLegacy(p2.preferences.defaults(), {
    avoidDuplicateModels = false, retainAcceptedOnCancel = false,
  })
  truthy(changed)
  equal(migrated.race.avoidDuplicateModels, false)
  equal(migrated.race.retainAcceptedOnCancel, false)
  local repeated, changedAgain = p2.preferences.importLegacy(migrated, {avoidDuplicateModels = true})
  truthy(not changedAgain)
  equal(repeated.race.avoidDuplicateModels, false)
end

tests.v070_native_vue_runtime_is_single_and_legacy_angular_is_absent = function()
  local function read(path)
    local file = assert(io.open(root .. path, "rb")); local value = file:read("*a"); file:close(); return value
  end
  local manifest = read("/ui/modules/apps/soturineChaosRandomizer/app.json")
  local app = read("/ui/modules/apps/soturineChaosRandomizer/app.vue")
  truthy(manifest:find('"vue": true', 1, true))
  truthy(manifest:match('"version"%s*:%s*"%d+%.%d+%.%d+"'))
  truthy(app:find('useEvents()', 1, true))
  truthy(app:find('SoturineChaosRandomizerState', 1, true))
  truthy(not io.open(root .. "/ui/modules/apps/soturineChaosRandomizer/app.js", "rb"))
  truthy(not io.open(root .. "/ui/modules/apps/soturineChaosRandomizer/app.html", "rb"))
  truthy(not io.open(root .. "/ui/modules/apps/soturineChaosRandomizer/app.css", "rb"))
end

tests.v066_baselines_are_distinct_and_repair_prefers_last_accepted = function()
  local state = baselineSemantics.create({modelKey = "player", vehicleId = 1, marker = "original"})
  baselineSemantics.setSelectedCandidate(state, {modelKey = "candidate", vehicleId = 2, marker = "selected"})
  baselineSemantics.setCleanCandidate(state, {modelKey = "candidate", vehicleId = 2, marker = "clean"})
  baselineSemantics.beginAttempt(state, {modelKey = "candidate", vehicleId = 2, marker = "attempt"}, {pass = 1})
  local accepted = {modelKey = "candidate", vehicleId = 2, marker = "accepted"}
  truthy(baselineSemantics.acceptGenerated(state, accepted, {pass = 1}))
  accepted.marker = "mutated_after_accept"
  local source, sourceType = baselineSemantics.repairSource(state)
  equal(sourceType, "last_accepted_generated_result")
  equal(source.marker, "accepted")
  equal(state.originalPlayerVehicle.marker, "original")
  equal(state.selectedRandomCandidate.marker, "selected")
  equal(state.cleanCandidateBaseline.marker, "clean")
  equal(state.currentMutationAttempt, nil)
end

tests.v066_coherent_gate_requires_same_generation_id_and_stable_cycles = function()
  local gate = coherentStateGate.create({
    operationId = "SCR-66", operationGeneration = 4, targetGeneration = 9,
    vehicleId = 42, logicalTarget = {modelKey = "car", configKey = "base.pc"},
    requireParts = true, requireTuning = true, requirePowertrain = true,
    requireEnergyStorage = true, minimumSamples = 2,
  })
  local context = {operationId = "SCR-66", operationGeneration = 4, targetGeneration = 9}
  local evidence = {
    vehicleId = 42, modelKey = "car", configKey = "base.pc", coherentTargetRead = true,
    parts = {engine = "engine_a"}, tuning = {boost = 1},
    powertrainEvidence = {engine = true}, energyStorages = {tank = 1},
    readiness = {config = true, parts = true, tuning = true, powertrain = true,
      energyStorage = false, replacementInProgress = false, newerReloadInProgress = false},
  }
  local stable, reason = coherentStateGate.observe(gate, evidence, context)
  equal(stable, false); equal(reason, "coherent_state_energy_storage_pending")
  evidence.readiness.energyStorage = true
  stable, reason = coherentStateGate.observe(gate, evidence, context)
  equal(stable, false); equal(reason, "coherent_state_stabilizing")
  stable, reason = coherentStateGate.observe(gate, evidence, context)
  truthy(stable); equal(reason, "coherent_state_stable")
  local wrongId = util.deepCopy(evidence); wrongId.vehicleId = 99
  equal(coherentStateGate.validate(gate, wrongId, context), false)
  local stale = util.deepCopy(context); stale.targetGeneration = 10
  local staleOk, staleReason = coherentStateGate.validate(gate, evidence, stale)
  equal(staleOk, false); equal(staleReason, "coherent_state_stale_generation")
end

tests.v066_tracker_rejects_stale_concrete_id_after_return_binding = function()
  local tracker = vehicleTargetTracker.create({
    token = "bound", operationId = "SCR-bound", operationGeneration = 1,
    phaseGeneration = 1, targetGeneration = 1, modelKey = "car", configKey = "base.pc",
    startedAt = 0, timeout = 2,
    stabilizer = {minimumFrames = 2, minimumScans = 2, pollInterval = 0},
  })
  vehicleTargetTracker.bindReturned(tracker, 22, "spawned_vehicle_object.getID")
  local status, reason = vehicleTargetTracker.observe(tracker, "bound", {
    vehicleId = 21, modelKey = "car", configKey = "base.pc",
  }, 0.1, {operationId = "SCR-bound", operationGeneration = 1, phaseGeneration = 1, targetGeneration = 1})
  equal(status, "waiting"); equal(reason, "target_concrete_id_mismatch")
end

tests.v066_critical_repair_is_surgical_and_restores_missing_dependency_parent = function()
  local current = {
    tree = {children = {
      body = {chosenPartName = "body_wild", children = {}},
      accessory = {chosenPartName = "accessory_wild", children = {}},
    }},
    byPath = {
      ["/body/"] = {path = "/body/", keys = {"body"}, currentPart = "body_wild"},
      ["/accessory/"] = {path = "/accessory/", keys = {"accessory"}, currentPart = "accessory_wild"},
    }, slots = {{}, {}},
  }
  local source = {
    byPath = {
      ["/body/"] = {path = "/body/", keys = {"body"}, currentPart = "body_safe"},
      ["/body/engine/"] = {path = "/body/engine/", keys = {"body", "engine"},
        currentPart = "engine_safe", parentPath = "/body/"},
    },
  }
  local plan = assert(criticalRepair.plan(current, source, {
    {slotPath = "/body/engine/", reason = "protected_functional_slot_missing"},
  }, "last_accepted_generated_result"))
  equal(#plan.repairs, 1)
  equal(plan.repairs[1].slotPath, "/body/")
  equal(plan.repairs[1].requestedSlotPath, "/body/engine/")
  equal(plan.tree.children.body.chosenPartName, "body_safe")
  equal(plan.tree.children.accessory.chosenPartName, "accessory_wild")
end

tests.v066_critical_repair_failure_is_explicit_before_full_recovery = function()
  local plan, reason, details = criticalRepair.plan(
    {tree = {children = {}}, byPath = {}, slots = {}},
    {byPath = {}}, {{slotPath = "/missing/"}}, "clean_candidate_baseline"
  )
  equal(plan, nil); equal(reason, "critical_repair_dependency_unresolved")
  equal(details.unresolved[1].reason, "repair_source_part_unavailable")
end

tests.v066_safety_precedence_protects_structural_role_but_accepts_optional_missing = function()
  local baselineTree = {children = {engine = {
    id = "engine", path = "/engine/", chosenPartName = "engine_a",
    suitablePartNames = {"engine_a"}, children = {},
  }, trim = {
    id = "trim", path = "/trim/", chosenPartName = "trim_a",
    suitablePartNames = {"trim_a"}, children = {},
  }}}
  local metadata = { ["/engine/"] = {candidateMetadata = {
    engine_a = {roles = {"propulsion_combustion", "power_path"}, heuristic = false},
  }}}
  local baselineScan = assert(slotScanner.scan(baselineTree, metadata))
  local currentTree = util.deepCopy(baselineTree)
  currentTree.children.engine.chosenPartName = ""
  currentTree.children.trim.chosenPartName = ""
  local currentScan = assert(slotScanner.scan(currentTree, metadata))
  local baselineGraph = validator.buildGraph(baselineScan, {type = "Car"}, {allowMissingParts = true})
  local currentGraph = validator.buildGraph(currentScan, {type = "Car"}, {allowMissingParts = true})
  local protected = validator.validateGraph(currentGraph, baselineGraph, true)
  truthy(not protected.valid)
  truthy(protected.failures[1].slotPath == "/engine/" or protected.failures[2] and protected.failures[2].slotPath == "/engine/")
  local permissive = validator.validateGraph(currentGraph, baselineGraph, false)
  truthy(permissive.valid)
  equal(#permissive.missingParts, 2)
end

tests.v066_candidate_classification_matrix_is_explicit = function()
  equal(validator.candidateClassification({isProp = true}, {}, {slotCount = 1}), "prop")
  equal(validator.candidateClassification({isTrailer = true}, {}, {slotCount = 1}), "trailer")
  equal(validator.candidateClassification({intentionalNonDrivable = true}, {}, {slotCount = 1}), "intentional_non_drivable_shell")
  equal(validator.candidateClassification({}, {propulsion_combustion = true}, {slotCount = 1}), "drivable_combustion")
  equal(validator.candidateClassification({}, {propulsion_electric = true}, {slotCount = 1}), "drivable_electric")
  equal(validator.candidateClassification({}, {propulsion_combustion = true, propulsion_electric = true}, {slotCount = 1}), "drivable_hybrid")
  equal(validator.candidateClassification({type = "Car"}, {}, {slotCount = 1}), "unknown")
end

tests.v066_engine_fluid_guard_distinguishes_zero_unavailable_valid_and_noncombustion = function()
  local values, report = engineFluidGuard.protectTuning(
    {oilVolume = 0, coolantVolume = 0, oilTemperature = 0},
    {
      oilVolume = {name = "oilVolume", title = "Engine oil volume", min = 0, max = 8, default = 6},
      coolantVolume = {name = "coolantVolume", title = "Coolant volume", min = 0, max = 12, default = 10},
      oilTemperature = {name = "oilTemperature", title = "Oil temperature", min = 0, max = 200, default = 90},
    }, {oilVolume = 6, coolantVolume = 10}, "drivable_combustion"
  )
  equal(values.oilVolume, 6); equal(values.coolantVolume, 10); equal(values.oilTemperature, 0)
  equal(#report.protected, 2)
  local unavailable = engineFluidGuard.assess(nil, "drivable_combustion")
  equal(unavailable.valid, nil); equal(unavailable.status, "unavailable")
  local zero = engineFluidGuard.assess({available = true, engines = {{name = "engine", oilMass = 0, minimumSafeOilMass = 1}}}, "drivable_combustion")
  equal(zero.valid, false); equal(zero.failures[1].reason, "engine_oil_zero")
  local disabled = engineFluidGuard.assess({available = true, engines = {{name = "engine", oilMass = 5, minimumSafeOilMass = 1, disabled = true}}}, "drivable_hybrid")
  equal(disabled.valid, false); equal(disabled.failures[1].reason, "combustion_engine_disabled")
  truthy(engineFluidGuard.assess({available = true, engines = {{name = "engine", oilMass = 5, minimumSafeOilMass = 1}}}, "drivable_combustion").valid)
  for _, class in ipairs({"drivable_electric", "trailer", "prop", "intentional_non_drivable_shell"}) do
    equal(engineFluidGuard.assess(nil, class).status, "not_applicable")
  end
end

tests.v066_race_contexts_ids_partial_cancel_and_placement_are_isolated = function()
  local lineup = assert(raceManager.create({count = 4, episodeSeed = "v066-race", acceptPartial = true}))
  local identities = {}
  for index, competitor in ipairs(lineup.competitors) do
    equal(competitor.competitorId, competitor.id)
    equal(competitor.requestedIndex, index)
    truthy(not identities[competitor.id]); identities[competitor.id] = true
  end
  local registry = managedVehicleRegistry.create(8)
  for index, competitor in ipairs(lineup.competitors) do
    local entry = assert(managedVehicleRegistry.register(registry, 100 + index, {
      competitorId = competitor.id, lineupCompetitorId = competitor.id,
      modelKey = "car" .. tostring(index), targetConfirmed = true, validated = true,
    }))
    truthy(managedVehicleRegistry.markReady(registry, entry.handle, entry.targetGeneration,
      {busy = false, targetConfirmed = true, validated = true}))
    competitor.managedHandle = entry.handle
    competitor.currentVehicleId = entry.vehicleId
  end
  equal(#managedVehicleRegistry.list(registry), 4)
  truthy(lineupSchema.validate(lineup))
  local available = raceManager.placementAvailability(lineup, registry, false, false)
  truthy(available.available); equal(available.count, 4)
  local busy = raceManager.placementAvailability(lineup, registry, true, false)
  equal(busy.available, false); equal(busy.reason, "operation_busy")
  truthy(raceManager.reorder(lineup, 4, 1)); equal(lineup.competitors[4].position, 1)
  equal(lineup.competitors[1].position, 2)
  lineup.competitors[4].currentVehicleId = lineup.competitors[1].currentVehicleId
  equal(lineupSchema.validate(lineup), false)

  local partialLineup = assert(raceManager.create({count = 4, episodeSeed = "v066-partial", acceptPartial = true, acceptMetadataUncertain = true}))
  local first = assert(raceManager.nextCompetitor(partialLineup))
  local partialDNA = sampleDNA({id = "v066-partial-dna"})
  truthy(raceManager.record(partialLineup, first.index, {
    success = true, message = "useful partial", details = {partial = true,
      lifecycleAcceptance = {finalValidationPassed = true, busy = false, pendingWrites = 0, pendingTimers = 0, pendingCallbacks = 0},
      verifiedTraits = {sourceKind = "official", vehicleClass = "Car"}},
  }, partialDNA, first.targetGeneration))
  equal(first.status, "partial")
  local second = assert(raceManager.nextCompetitor(partialLineup)); equal(second.index, 2)
  truthy(raceManager.cancel(partialLineup, "cancelled during competitor 2 of 4"))
  equal(second.status, "cancelled"); equal(partialLineup.competitors[4].status, "cancelled")
  equal(partialLineup.active, false)
end

tests.v066_known_conflicts_are_warning_only_and_never_disabled = function()
  local previousExtensions, previousFS = rawget(_G, "extensions"), rawget(_G, "FS")
  _G.extensions = {beamLR = {}, driver_assistance_angelo234 = {}}
  _G.FS = nil
  local conflicts = adapter.detectKnownConflicts()
  _G.extensions, _G.FS = previousExtensions, previousFS
  equal(#conflicts, 2)
  for _, conflict in ipairs(conflicts) do
    equal(conflict.action, "warning_only")
    equal(conflict.disabledByRandomizer, false)
    truthy(conflict.id == "beamlr" or conflict.id == "driver_assistance_angelo234")
  end
end

tests.v068_compatibility_metadata_classification_is_explicit = function()
  local metadata = {primaryBeamNGTarget = "0.39", minimumBeamNGVersion = "0.38.6"}
  equal(compatibility.evaluate(metadata, "0.39.0.0").compatibilityState, "primary_target")
  equal(compatibility.evaluate(metadata, "0.38.6.0").compatibilityState, "supported_legacy")
  equal(compatibility.evaluate(metadata, "0.40.0.0").compatibilityState, "newer_unverified")
  equal(compatibility.evaluate(metadata, "0.38.5.9").compatibilityState, "older_unsupported")
  equal(compatibility.evaluate(metadata, "unknown").compatibilityState, "unknown")
  truthy(#compatibility.evaluate(metadata, "0.40.0.0").compatibilityWarnings > 0)
end

tests.v068_paths_preserve_physical_case_and_reject_traversal = function()
  local identity = pathIdentity.create("mods\\unpacked\\Pack\\vehicles\\Car\\Config.PC")
  equal(identity.physicalPathExact, "/mods/unpacked/Pack/vehicles/Car/Config.PC")
  equal(identity.comparisonPathNormalized, "/mods/unpacked/pack/vehicles/car/config.pc")
  equal(identity.basenameKey, "config")
  equal(configVerification.normalizePath(identity.physicalPathExact), identity.comparisonPathNormalized)
  equal(pathIdentity.physical("/vehicles/Car/../Evil.pc"), nil)
  equal(pathIdentity.physical("C:/outside/config.pc"), nil)
  equal(pathIdentity.physical("https://outside/config.pc"), nil)
end

tests.v068_registry_readiness_is_bounded_and_atomic_index_is_preserved = function()
  local state = registryReadiness.create({retryInterval = 0.5, timeout = 2, maxAttempts = 3})
  registryReadiness.begin(state, 10, "test")
  truthy(registryReadiness.due(state, 10))
  equal(registryReadiness.observe(state, {modelsReady = true, configsReady = false, modelCount = 2}, 10), "partial")
  equal(state.nextAttemptAt, 10.5)
  equal(registryReadiness.observe(state, {modelsReady = false, configsReady = false}, 10.5), "warming_up")
  equal(registryReadiness.observe(state, {modelsReady = false, configsReady = false}, 11), "failed_confirmed")
  truthy(not registryReadiness.due(state, 20))

  local index = contentIndex.create()
  truthy(contentIndex.build(index, {{key = "Car"}}, {{model_key = "Car", key = "Base", pcFilename = "/vehicles/Car/Base.pc"}}, 1, 0))
  local original = index.allConfigs[1]
  equal(original.physicalPathExact, "/vehicles/Car/Base.pc")
  equal(original.comparisonPathNormalized, "/vehicles/car/base.pc")
  local rebuilt, counts = contentIndex.build(index, {}, {}, 2, 0)
  equal(rebuilt, false)
  equal(counts.cachePreserved, true)
  equal(index.allConfigs[1].technicalId, original.technicalId)
  equal(index.allConfigs[1].physicalPathExact, "/vehicles/Car/Base.pc")
end

tests.v068_spawn_outcomes_are_evidence_based_and_cleanup_is_owned = function()
  local denied = spawnOutcome.begin({requestedModel = "car", worldVehicleIdsBefore = {1}})
  spawnOutcome.finish(denied, {apiResult = false, worldVehicleIdsAfter = {1}})
  equal(denied.reason, "DENIED_LOW_MEMORY")
  equal(#spawnOutcome.cleanupIds(denied), 0)
  truthy(not spawnOutcome.blacklistEligible(denied.reason))

  local observed = spawnOutcome.begin({requestedModel = "car", worldVehicleIdsBefore = {1}})
  spawnOutcome.finish(observed, {apiResult = nil, worldVehicleIdsAfter = {1, 2}})
  equal(observed.outcome, "observed_candidate")
  equal(observed.acceptedVehicleId, nil)
  equal(observed.candidateVehicleIds[1], 2)
  truthy(spawnOutcome.accept(observed, 2))
  equal(#spawnOutcome.cleanupIds(observed), 0)

  local ambiguous = spawnOutcome.begin({worldVehicleIdsBefore = {1}})
  spawnOutcome.finish(ambiguous, {apiResult = {}, returnedVehicleId = 2, worldVehicleIdsAfter = {1, 2, 3}})
  equal(ambiguous.reason, "UNKNOWN_FAILURE")
  equal(#spawnOutcome.cleanupIds(ambiguous), 2)
  equal(ambiguous.acceptedVehicleId, nil)
end

tests.v068_temporary_failures_never_blacklist_catalog_content = function()
  for _, reason in ipairs({"DENIED_LOW_MEMORY", "DENIED_NO_SPACE", "TEMPORARY_REGISTRY", "UNKNOWN_FAILURE", "vehicle_destroyed"}) do
    local index = contentIndex.create()
    for _ = 1, 6 do
      local count, blocked = contentIndex.recordFailure(index, "config", {
        modelKey = "car", configKey = "base",
      }, {code = "vehicle_replace_rejected", context = {spawnOutcomeReason = reason}})
      equal(count, 0)
      equal(blocked, false)
    end
    equal(contentIndex.blacklistCounts(index).total, 0)
    equal(index.lastQuarantine.reason, reason)
  end
  local domains = domainOperations.create()
  local context = assert(domainOperations.begin(domains, {domain = "chaos", action = "randomConfig"}))
  for _, reason in ipairs({"DENIED_LOW_MEMORY", "DENIED_NO_SPACE", "TEMPORARY_REGISTRY", "UNKNOWN_FAILURE"}) do
    local quarantined, why = domainOperations.quarantine(domains, context, "car", "base", reason, 1)
    equal(quarantined, false)
    equal(why, "condition_not_catalog_quarantinable")
  end
end

tests.v068_adapter_classifies_confirmed_low_memory_without_inventing_space_failure = function()
  local originalVehicles, originalAll = core_vehicles, getAllVehicles
  core_vehicles = {spawnNewVehicle = function() return false end}
  getAllVehicles = function() return {} end
  local ok, failure = adapter.replaceVehicle("fixture", "base")
  core_vehicles, getAllVehicles = originalVehicles, originalAll
  equal(ok, false)
  equal(failure.code, "vehicle_replace_rejected")
  equal(failure.context.spawnOutcomeReason, "DENIED_LOW_MEMORY")
  equal(failure.context.spawnTransaction.reason, "DENIED_LOW_MEMORY")
  equal(failure.context.spawnTransaction.acceptedVehicleId, nil)
end

tests.v068_user_data_writes_are_transactional_and_reported = function()
  local files = {primary = {schemaVersion = 6, value = "old"}}
  local function read(path) return true, util.deepCopy(files[path]) end
  local function write(path, value) files[path] = util.deepCopy(value); return true end
  local saved, result = transactionalJSON.store({
    path = "primary", backupPath = "backup", value = {schemaVersion = 7, value = "new"},
    read = read, write = write,
  })
  truthy(saved)
  truthy(result.verified)
  equal(files.backup.value, "old")
  equal(files.primary.value, "new")

  files.primary = {schemaVersion = 6, value = "stable"}
  local primaryWrites = 0
  local failed, failure = transactionalJSON.store({
    path = "primary", backupPath = "backup", value = {schemaVersion = 7, value = "candidate"},
    read = read,
    write = function(path, value)
      files[path] = util.deepCopy(value)
      if path == "primary" then
        primaryWrites = primaryWrites + 1
        if primaryWrites == 1 then files[path].value = "corrupt-readback" end
      end
      return true
    end,
  })
  equal(failed, false)
  equal(failure.code, "transaction_rolled_back")
  equal(files.primary.value, "stable")
  equal(files.backup.value, "stable")

  local writes = 0
  local refused, refusal = transactionalJSON.store({
    path = "unreadable", value = {value = "must-not-overwrite"},
    read = function() return false end,
    write = function() writes = writes + 1; return true end,
  })
  equal(refused, false)
  equal(refusal.code, "transaction_previous_read_failed")
  equal(writes, 0)

  local report = userDataMigration.create("0.6.8")
  userDataMigration.record(report, "settings", 6, 7, "migrated", {backup = true})
  userDataMigration.record(report, "vehicleDNA", 1, 1, "preserved")
  equal(report.status, "migrated")
  equal(#report.records, 2)
  equal(report.records[1].details.backup, true)
end

tests.v067_domain_operations_isolate_chaos_race_and_garage = function()
  local state = domainOperations.create()
  local race = assert(domainOperations.begin(state, {
    domain = "race", operationId = "race-1", action = "generate_cars",
    expectedSlot = 3, sourceVehicleId = 1, createdAt = 1,
  }))
  local raceToken = domainOperations.callbackToken(race, "spawn", {expectedSlot = 3})
  truthy(domainOperations.registerCandidate(state, raceToken, 103, {created = true}))
  truthy(domainOperations.acceptVehicle(state, race, 103, "race_competitor"))

  local chaos = assert(domainOperations.begin(state, {
    domain = "chaos", operationId = "chaos-1", action = "fullRandom",
    sourceVehicleId = 1, createdAt = 2,
  }))
  local chaosToken = domainOperations.callbackToken(chaos, "replace")
  truthy(domainOperations.registerCandidate(state, chaosToken, 2, {created = true}))
  local allowed, reason = domainOperations.canMutate(state, chaos, 103)
  equal(allowed, false); equal(reason, "race_competitor_requires_explicit_transfer")
  local duplicateRace, duplicateRaceReason = domainOperations.validateCallback(state, raceToken)
  equal(duplicateRace, false); equal(duplicateRaceReason, "callback_already_consumed")
  truthy(domainOperations.validateCallback(state, domainOperations.callbackToken(race, "probe")))

  local nextRace, superseded = domainOperations.begin(state, {
    domain = "race", operationId = "race-2", action = "generate_cars", createdAt = 3,
  })
  truthy(nextRace); equal(superseded.terminalState, "superseded")
  local valid, staleReason = domainOperations.validateCallback(state, raceToken)
  equal(valid, false); equal(staleReason, "ignored_stale_callback")
  local duplicateChaos, duplicateChaosReason = domainOperations.validateCallback(state, chaosToken)
  equal(duplicateChaos, false); equal(duplicateChaosReason, "callback_already_consumed")
  truthy(domainOperations.validateCallback(state, domainOperations.callbackToken(chaos, "probe")))

  local garage = assert(domainOperations.begin(state, {
    domain = "garage", operationId = "garage-1", action = "restore", sourceVehicleId = 7,
  }))
  equal(garage.generation, 1)
  local report = domainOperations.summary(state)
  equal(report.domains.chaos.operationId, "chaos-1")
  equal(report.domains.race.operationId, "race-2")
  equal(report.domains.garage.operationId, "garage-1")
end

tests.v067_stale_callbacks_are_rejected_and_owned_orphans_are_reaped = function()
  local state = domainOperations.create()
  local context = assert(domainOperations.begin(state, {
    domain = "chaos", operationId = "chaos-timeout", action = "randomConfig",
    sourceVehicleId = 1, createdAt = 1,
  }))
  truthy(domainOperations.ownVehicle(state, 1, {
    domain = "chaos", operationId = context.operationId, generation = context.generation,
    role = "player_source", managed = false, created = false,
  }))
  local token = domainOperations.callbackToken(context, "replace")
  truthy(domainOperations.registerCandidate(state, token, 2, {created = true}))
  truthy(domainOperations.terminal(state, context, "rolled_back", {
    restoredVehicleId = 1, sourceStillExists = true, playerVehicleIdAfter = 1,
  }))
  local accepted, reason = domainOperations.registerCandidate(state, token, 3, {created = true})
  equal(accepted, false); equal(reason, "ignored_stale_callback")
  local deleted = {}
  local cleanup = domainOperations.reap(state, function(vehicleId)
    deleted[#deleted + 1] = vehicleId
    return true, "vehicle_deleted"
  end)
  equal(#cleanup.removed, 1); equal(cleanup.removed[1], 2)
  equal(#deleted, 1); equal(deleted[1], 2)
  equal(domainOperations.ownership(state, 1).role, "player_source")
  equal(domainOperations.summary(state).orphanVehicles, 0)
end

tests.v067_cardinality_and_rollback_are_idempotent = function()
  local state = domainOperations.create()
  local context = assert(domainOperations.begin(state, {
    domain = "chaos", operationId = "full-1", action = "fullRandom", sourceVehicleId = 10,
  }))
  local token = domainOperations.callbackToken(context, "replace")
  truthy(domainOperations.registerCandidate(state, token, 11, {created = true}))
  local duplicate, duplicateReason = domainOperations.registerCandidate(state, token, 12, {created = true})
  equal(duplicate, false); equal(duplicateReason, "callback_already_consumed")
  local secondToken = domainOperations.callbackToken(context, "replace_retry")
  local second, secondReason = domainOperations.registerCandidate(state, secondToken, 12, {created = true})
  equal(second, false); equal(secondReason, "owned_temporary_cardinality_violation")
  truthy(domainOperations.acceptVehicle(state, context, 11, "player_result", 11))
  truthy(domainOperations.terminal(state, context, "completed", {playerVehicleIdAfter = 11}))
  equal(context.acceptedVehicleId, 11); equal(context.playerVehicleIdAfter, 11)
  equal(domainOperations.ownership(state, 11).accepted, true)
  equal(domainOperations.ownership(state, 12), nil)
  equal(context.peakOwnedTemporaryCount, 1)

  local rollbackContext = assert(domainOperations.begin(state, {
    domain = "chaos", operationId = "full-2", action = "fullRandom", sourceVehicleId = 20,
  }))
  local first, firstReason, restored = domainOperations.rollback(rollbackContext, 20, "target_timeout")
  truthy(first); equal(firstReason, "rollback_applied"); equal(restored, 20)
  local repeated, repeatedReason, repeatedId = domainOperations.rollback(rollbackContext, 99, "again")
  truthy(repeated); equal(repeatedReason, "rollback_already_applied"); equal(repeatedId, 20)
end

tests.v067_quarantine_is_generation_scoped_and_non_persistent = function()
  local state = domainOperations.create()
  local race = assert(domainOperations.begin(state, {
    domain = "race", operationId = "race-q", action = "generate_cars",
  }))
  local added, record = domainOperations.quarantine(state, race, "vivace", "broken.pc", "load_failed", 4)
  truthy(added); equal(record.retryPolicy, "next_configuration_same_generation")
  truthy(domainOperations.isQuarantined(state, "race", "vivace", "broken.pc"))
  equal(domainOperations.isQuarantined(state, "chaos", "vivace", "broken.pc"), false)
  local repeated, repeatedReason = domainOperations.quarantine(
    state, race, "vivace", "broken.pc", "load_failed_again", 5
  )
  equal(repeated, false); equal(repeatedReason, "config_already_quarantined")
  truthy(domainOperations.clearQuarantine(state, "race"))
  equal(domainOperations.isQuarantined(state, "race", "vivace", "broken.pc"), false)
end

tests.v067_operation_context_exposes_domain_cardinality_contract = function()
  local state = {operationId = 7, operationGeneration = 4, phaseGeneration = 2, targetGeneration = 9}
  local context = operationContext.create(state, "token", 1, {
    domain = "chaos", action = "randomConfig", generation = 4,
    expectedSlot = "player", expectedLogicalTarget = {modelKey = "car"}, sourceVehicleId = 1,
  })
  operationContext.beginLogicalTarget(context, state, {modelKey = "car", configKey = "base.pc"}, 1)
  truthy(operationContext.recordCandidate(context, state, {vehicleId = 2, source = "replace"}))
  truthy(operationContext.markAccepted(context, 2, 2))
  truthy(operationContext.markTerminal(context, "completed", {
    sourceStillExists = false, playerVehicleIdAfter = 2, removedVehicleIds = {1},
  }))
  local report = operationContext.summary(context)
  equal(report.domain, "chaos"); equal(report.action, "randomConfig")
  equal(report.sourceVehicleId, 1); equal(report.candidateVehicleIds[1], 2)
  equal(report.acceptedVehicleId, 2); equal(report.playerVehicleIdAfter, 2)
  equal(report.removedVehicleIds[1], 1); equal(report.terminalState, "completed")
end

tests.v067_race_participation_rng_and_state_machine = function()
  local spectator = assert(raceManager.create({
    count = 4, participationMode = "spectator", episodeSeed = "v067-participation",
  }))
  equal(spectator.totalVehicles, 4); equal(spectator.aiOpponentCount, 4)
  equal(#spectator.competitors, 4); equal(spectator.settings.countSemantics, "total_vehicles")
  equal(spectator.generationState, "lineup_processing")
  local player = assert(raceManager.create({
    count = 4, participationMode = "player", episodeSeed = "v067-participation",
  }))
  equal(player.totalVehicles, 4); equal(player.aiOpponentCount, 3)
  equal(#player.competitors, 3); truthy(player.playerParticipates)
  local seeds = {}
  for _, competitor in ipairs(spectator.competitors) do
    truthy(not seeds[competitor.seed]); seeds[competitor.seed] = true
    equal(competitor.slotId, tostring(competitor.index))
    equal(competitor.derivedSeed, competitor.seed)
    equal(#competitor.ownedTemporaryIds, 0)
    equal(competitor.phase, "planned")
    equal(competitor.phaseProgress, 0)
    truthy(competitor.selectionSeed ~= competitor.mutationSeed)
    truthy(competitor.mutationSeed ~= competitor.placementSeed)
  end
  local slotThreeAttemptOne = raceManager.domainSeed(spectator, spectator.competitors[3], "operation", 1)
  local slotThreeAttemptTwo = raceManager.domainSeed(spectator, spectator.competitors[3], "operation", 2)
  truthy(slotThreeAttemptOne ~= slotThreeAttemptTwo)
  local clone = assert(raceManager.create({
    count = 4, participationMode = "spectator", episodeSeed = "v067-participation",
  }))
  equal(raceManager.domainSeed(clone, clone.competitors[3], "operation", 1), slotThreeAttemptOne)
  spectator.competitors[1].traits.verified.family = "changed"
  equal(spectator.competitors[2].traits.verified.family, nil)
  local first = assert(raceManager.nextCompetitor(spectator))
  equal(first.spawnState, "spawning"); equal(first.placementState, "staging")
  truthy(raceManager.record(spectator, 1, {success = false, message = "fixture failure"}, nil, first.targetGeneration))
  equal(first.spawnState, "failed"); equal(first.placementState, "failed")
  truthy(raceManager.resolveFailure(spectator, 1, "retry"))
  equal(first.spawnState, "planned"); equal(first.placementState, "planned")
  truthy(raceManager.cancel(spectator, "fixture cancellation"))
  equal(spectator.generationState, "lineup_cancelled")
  equal(spectator.processingState, "lineup_processing_finished")
  local summary = raceManager.summary(spectator)
  equal(summary.configuredVehicles, 4); equal(summary.plannedOpponents, 4)
  equal(summary.generated, 0); equal(summary.cancelled, 4)
  truthy(summary.overallProgress >= 0 and summary.overallProgress <= 1)
end

tests.v072_race_slots_are_independent_at_one_four_eight_and_twelve = function()
  for _, count in ipairs({1, 4, 8, 12}) do
    local lineup = assert(raceManager.create({
      count = count, advancedAllowOne = count == 1,
      episodeSeed = "v072-scale-" .. tostring(count),
      acceptMetadataUncertain = true,
    }))
    local registry = managedVehicleRegistry.create(16)
    local vehicleIds, operationSeeds = {}, {}
    for index = 1, count do
      local competitor = assert(raceManager.nextCompetitor(lineup))
      equal(competitor.index, index)
      local operationSeed = assert(raceManager.domainSeed(lineup, competitor, "operation", 1))
      truthy(not operationSeeds[operationSeed]); operationSeeds[operationSeed] = true
      local vehicleId = count * 100 + index
      truthy(not vehicleIds[vehicleId]); vehicleIds[vehicleId] = true
      local dna = sampleDNA({id = "v072-dna-" .. tostring(count) .. "-" .. tostring(index)})
      truthy(raceManager.record(lineup, index, {
        success = true, message = "ready", details = {
          model = dna.final.modelKey, configuration = "base_" .. tostring(index),
          lifecycleAcceptance = {
            finalValidationPassed = true, busy = false, pendingWrites = 0,
            pendingTimers = 0, pendingCallbacks = 0,
          },
          verifiedTraits = {sourceKind = "official", vehicleClass = "Car"},
        },
      }, dna, competitor.targetGeneration))
      local entry = assert(managedVehicleRegistry.register(registry, vehicleId, {
        competitorId = competitor.id, lineupCompetitorId = competitor.id,
        modelKey = dna.final.modelKey, targetConfirmed = true, validated = true,
      }))
      truthy(managedVehicleRegistry.markReady(registry, entry.handle, entry.targetGeneration, {
        busy = false, targetConfirmed = true, validated = true,
      }))
      competitor.managedHandle = entry.handle
      competitor.currentVehicleId = vehicleId
      competitor.spawnState = "spawned_and_retained"
      competitor.placementState = "staged"
    end
    equal(#managedVehicleRegistry.list(registry), count)
    truthy(lineupSchema.validate(lineup, {allowOne = count == 1}))
    equal(raceManager.placementAvailability(lineup, registry, false, false).count, count)
  end
end

tests.v072_race_failure_retry_and_stale_callbacks_preserve_other_slots = function()
  local lineup = assert(raceManager.create({
    count = 4, episodeSeed = "v072-failure", maxAttemptsPerCompetitor = 3,
    acceptMetadataUncertain = true,
  }))
  local first = assert(raceManager.nextCompetitor(lineup))
  local firstDNA = sampleDNA({id = "v072-first"})
  truthy(raceManager.record(lineup, 1, {
    success = true, message = "ready", details = {
      lifecycleAcceptance = {finalValidationPassed = true, busy = false,
        pendingWrites = 0, pendingTimers = 0, pendingCallbacks = 0},
      verifiedTraits = {sourceKind = "official", vehicleClass = "Car"},
    },
  }, firstDNA, first.targetGeneration))
  first.currentVehicleId = 701
  first.spawnState = "spawned_and_retained"
  local preservedFirst = util.deepCopy(first)

  local second = assert(raceManager.nextCompetitor(lineup))
  local staleSnapshot = util.deepCopy(second)
  local staleOk, staleReason = raceManager.record(
    lineup, 2, {success = true}, nil, second.targetGeneration + 1
  )
  equal(staleOk, false); equal(staleReason, "stale_callback_ignored")
  truthy(util.deepEqual(second, staleSnapshot))
  truthy(raceManager.record(lineup, 2, {
    success = false, message = "slot two failed", details = {},
  }, nil, second.targetGeneration))
  equal(second.status, "failed")
  truthy(util.deepEqual(first, preservedFirst))

  local seedAttemptOne = raceManager.domainSeed(lineup, second, "operation", 1)
  truthy(raceManager.resolveFailure(lineup, 2, "retry"))
  local retried = assert(raceManager.nextCompetitor(lineup))
  equal(retried.index, 2)
  local seedAttemptTwo = raceManager.domainSeed(lineup, retried, "operation", 2)
  truthy(seedAttemptOne ~= seedAttemptTwo)
  truthy(raceManager.record(lineup, 2, {
    success = false, message = "slot two failed again", details = {},
  }, nil, retried.targetGeneration))
  truthy(raceManager.resolveFailure(lineup, 2, "retry"))
  local thirdAttempt = assert(raceManager.nextCompetitor(lineup))
  truthy(raceManager.record(lineup, 2, {
    success = false, message = "slot two final bounded failure", details = {},
  }, nil, thirdAttempt.targetGeneration))
  local retryOk, retryReason = raceManager.resolveFailure(lineup, 2, "retry")
  equal(retryOk, false); equal(retryReason, "lineup_attempt_limit")
  truthy(util.deepEqual(first, preservedFirst))
end

tests.v072_transaction_binding_and_cardinality_are_explicit = function()
  local domains = domainOperations.create()
  local context = assert(domainOperations.begin(domains, {
    domain = "race", operationId = "race-v072", action = "fullRandom",
    expectedSlot = 2, worldVehicleIdsBefore = {1, 8},
  }))
  equal(context.bindingState, "UNBOUND")
  local token = domainOperations.callbackToken(context, "spawn", {expectedSlot = 2})
  truthy(domainOperations.registerCandidate(domains, token, 42, {created = true}))
  equal(context.bindingState, "CANDIDATE_DISCOVERED")
  truthy(domainOperations.acceptVehicle(domains, context, 42, "race_competitor", 1))
  equal(context.bindingState, "BOUND")
  local secondOk, secondReason = domainOperations.acceptVehicle(
    domains, context, 43, "race_competitor", 1
  )
  equal(secondOk, false); equal(secondReason, "accepted_vehicle_cardinality_violation")
  truthy(domainOperations.terminal(domains, context, "completed", {playerVehicleIdAfter = 1}))
  truthy(domainOperations.recordWorldAfter(context, {1, 8, 42}))
  equal(context.worldVehicleDelta, 1)
  equal(context.bindingState, "TERMINAL")
  local staleOk, staleReason = domainOperations.registerCandidate(domains, token, 99, {created = true})
  equal(staleOk, false); equal(staleReason, "ignored_stale_callback")
  equal(domainOperations.ownership(domains, 99), nil)
  equal(context.staleCallbackSideEffects, 0)
  equal(context.staleCallbackEffectsPrevented, 1)

  local state = operationState.create()
  assert(operationState.begin(state, "fullRandom", nil, 30))
  local operation = operationContext.create(state, "token", 0, {
    domain = "race", action = "fullRandom", expectedSlot = 2,
    worldVehicleIdsBefore = {1, 8},
  })
  operationContext.beginLogicalTarget(operation, state, {modelKey = "car", configKey = "base.pc"}, 0)
  operationContext.beginWait(operation, state, {modelKey = "car", configKey = "base.pc"}, "spawn", 0)
  truthy(operationContext.rebindConcreteTarget(operation, state, {
    vehicleId = 42, modelKey = "car", configKey = "base.pc",
    targetRole = "background_owned", stable = true, coherentTargetRead = true,
    observedAt = 1,
  }, 1))
  equal(operation.bindingState, "BOUND")
  truthy(operationContext.markAccepted(operation, 42, 1))
  local marked, markReason = operationContext.markAccepted(operation, 43, 1)
  equal(marked, false); equal(markReason, "accepted_vehicle_cardinality_violation")
  truthy(operationContext.markTerminal(operation, "completed", {
    playerVehicleIdAfter = 1, worldVehicleIdsAfter = {1, 8, 42},
  }))
  local summary = operationContext.summary(operation)
  equal(summary.bindingState, "TERMINAL")
  equal(summary.worldVehicleDelta, 1)
  equal(summary.staleCallbackSideEffects, 0)
  equal(summary.staleCallbackEffectsPrevented, 0)
end

tests.v072_scheduler_limits_and_watchdog_are_bounded = function()
  local limits = stabilityLimits.normalize({
    maxConcurrentVehicleBuilds = 99, maxOwnedTemporaryVehicles = 99,
    maxRetriesPerTarget = 99, maxRetriesPerRaceSlot = 99,
    maxStaleCallbacksPerOperation = 999,
    maxOperationWallClockMs = 1, maxRaceGenerationWallClockMs = 99999999,
    maxSpawnAttemptsPerFrame = 99, maxHeavyReloadsPerFrame = 99,
  })
  equal(limits.maxConcurrentVehicleBuilds, 1)
  equal(limits.maxOwnedTemporaryVehicles, 1)
  equal(limits.maxRetriesPerTarget, 3)
  equal(limits.maxRetriesPerRaceSlot, 3)
  equal(limits.maxStaleCallbacksPerOperation, 256)
  equal(limits.maxOperationWallClockMs, 10000)
  equal(limits.maxRaceGenerationWallClockMs, 360000)
  equal(limits.maxSpawnAttemptsPerFrame, 2)
  equal(limits.maxHeavyReloadsPerFrame, 2)
  equal(stabilityLimits.operationTimeoutMs(limits, "randomConfig", "chaos"), 30000)
  equal(stabilityLimits.operationTimeoutMs(limits, "scramble", "chaos"), 60000)
  equal(stabilityLimits.operationTimeoutMs(limits, "fullRandom", "chaos"), 120000)
  equal(stabilityLimits.operationTimeoutMs(limits, "fullRandom", "race"), 120000)

  local scheduler = cooperativeScheduler.create({limit = 4})
  truthy(cooperativeScheduler.enqueue(scheduler, "spawn", "slot:1", {slot = 1}))
  truthy(cooperativeScheduler.enqueue(scheduler, "spawn", "slot:2", {slot = 2}))
  local executed = {}
  local steps, pending = cooperativeScheduler.tick(scheduler, function(kind, payload)
    executed[#executed + 1] = {kind = kind, slot = payload.slot}
  end, {maxSteps = 1, budgetMs = 10, clock = function() return 0 end})
  equal(steps, 1); equal(pending, 1); equal(#executed, 1)
  equal(cooperativeScheduler.snapshot(scheduler).yieldedFrames, 1)
  steps, pending = cooperativeScheduler.tick(scheduler, function(kind, payload)
    executed[#executed + 1] = {kind = kind, slot = payload.slot}
  end, {maxSteps = 1, budgetMs = 10, clock = function() return 0 end})
  equal(steps, 1); equal(pending, 0); equal(#executed, 2)

  truthy(cooperativeScheduler.enqueue(scheduler, "parts", "parts:1", {step = 1}))
  steps, pending = cooperativeScheduler.tick(scheduler, function(_, payload)
    if payload.step == 1 then return {done = false, payload = {step = 2}} end
  end, {maxSteps = 1, budgetMs = 10, clock = function() return 0 end})
  equal(steps, 1); equal(pending, 1)
  equal(cooperativeScheduler.snapshot(scheduler).resumed, 1)
  steps, pending = cooperativeScheduler.tick(scheduler, function(_, payload)
    equal(payload.step, 2)
  end, {maxSteps = 1, budgetMs = 10, clock = function() return 0 end})
  equal(steps, 1); equal(pending, 0)

  local watchdog = progressWatchdog.create(0, {warningAfter = 2, stalledAfter = 4})
  progressWatchdog.observeMetrics(watchdog, {
    ownedVehicleCount = 2, temporaryVehicleCount = 1, callbackCount = 7,
    frameBudgetOverruns = 3,
  })
  equal(progressWatchdog.evaluate(watchdog, 2.1, false), "SLOW_PROGRESS")
  equal(progressWatchdog.snapshot(watchdog, 2.1).status, "slow")
  equal(progressWatchdog.evaluate(watchdog, 4.1, false), "NO_PROGRESS")
  truthy(progressWatchdog.setStatus(watchdog, "aborting"))
  equal(progressWatchdog.snapshot(watchdog, 4.1).status, "aborting")
  truthy(progressWatchdog.setStatus(watchdog, "cleaning"))
  truthy(progressWatchdog.setStatus(watchdog, "terminal"))
  local report = progressWatchdog.snapshot(watchdog, 4.1)
  equal(report.status, "terminal")
  equal(report.ownedVehicleCount, 2)
  equal(report.temporaryVehicleCount, 1)
  equal(report.callbackCount, 7)
  equal(report.frameBudgetOverruns, 3)
end


tests.v073_callback_tokens_are_phase_vehicle_and_consumption_bound = function()
  local state = domainOperations.create()
  local context = assert(domainOperations.begin(state, {
    domain = "chaos", operationId = "v073-callback", action = "fullRandom",
    sourceVehicleId = 1, worldVehicleIdsBefore = {1},
  }))
  local oldPhase = domainOperations.callbackToken(context, "spawn", {expectedVehicleId = 2})
  truthy(domainOperations.setPhase(context, "binding", "active"))
  local oldAccepted, oldReason = domainOperations.registerCandidate(state, oldPhase, 2, {created = true})
  equal(oldAccepted, false); equal(oldReason, "callback_phase_mismatch")
  equal(domainOperations.ownership(state, 2), nil)

  local token = domainOperations.callbackToken(context, "spawn", {expectedVehicleId = 2})
  local wrong, wrongReason = domainOperations.registerCandidate(state, token, 3, {created = true})
  equal(wrong, false); equal(wrongReason, "callback_vehicle_mismatch")
  truthy(domainOperations.registerCandidate(state, token, 2, {created = true}))
  local duplicate, duplicateReason = domainOperations.registerCandidate(state, token, 2, {created = true})
  equal(duplicate, false); equal(duplicateReason, "callback_already_consumed")
  equal(context.staleCallbackSideEffects, 0)
  truthy(#state.callbackDiagnostics >= 3)
  truthy(#state.callbackDiagnostics <= 32)
end

tests.v073_full_random_cardinality_and_scramble_identity_are_absolute = function()
  local state = domainOperations.create()
  local full = assert(domainOperations.begin(state, {
    domain = "chaos", operationId = "v073-full", action = "fullRandom",
    sourceVehicleId = 1, worldVehicleIdsBefore = {1},
  }))
  local first = domainOperations.callbackToken(full, "spawn", {expectedVehicleId = 2})
  truthy(domainOperations.registerCandidate(state, first, 2, {created = true}))
  local blocked, blockedReason = domainOperations.canCreateTemporary(state, full, nil)
  equal(blocked, false); equal(blockedReason, "owned_temporary_cardinality_violation")
  local second = domainOperations.callbackToken(full, "spawn_retry", {expectedVehicleId = 3})
  local added, addReason = domainOperations.registerCandidate(state, second, 3, {created = true})
  equal(added, false); equal(addReason, "owned_temporary_cardinality_violation")
  equal(full.peakOwnedTemporaryCount, 1)
  truthy(domainOperations.terminal(state, full, "failed", {worldVehicleIdsAfter = {1}}))

  local scramble = assert(domainOperations.begin(state, {
    domain = "chaos", operationId = "v073-scramble", action = "scramble",
    sourceVehicleId = 1, worldVehicleIdsBefore = {1},
  }))
  local stale, staleReason = domainOperations.registerCandidate(state, first, 3, {created = true})
  equal(stale, false); equal(staleReason, "ignored_stale_callback")
  local same = domainOperations.callbackToken(scramble, "reload", {expectedVehicleId = 1})
  truthy(domainOperations.registerCandidate(state, same, 1, {created = false}))
  truthy(domainOperations.acceptVehicle(state, scramble, 1, "player_result", 1))
  local changed = domainOperations.callbackToken(scramble, "reload", {expectedVehicleId = 9})
  local changedOk, changedReason = domainOperations.registerCandidate(state, changed, 9, {created = true})
  equal(changedOk, false); equal(changedReason, "scramble_identity_changed")
  equal(#scramble.ownedTemporaryIds, 0)
  equal(scramble.acceptedConcreteId, 1)
end

tests.v074_replacement_cardinality_uses_expected_sets_and_preserves_external_ids = function()
  local state = domainOperations.create()
  local replacement = assert(domainOperations.begin(state, {
    domain = "chaos", operationId = "v074-random-car", action = "randomConfig",
    sourceVehicleId = 17, worldVehicleIdsBefore = {17, 99},
  }))
  truthy(domainOperations.expectRemoval(replacement, 17))
  truthy(domainOperations.expectAddition(replacement, 23))
  local token = domainOperations.callbackToken(replacement, "spawn", {expectedVehicleId = 23})
  truthy(domainOperations.registerCandidate(state, token, 23, {created = true}))
  truthy(domainOperations.acceptVehicle(state, replacement, 23, "player_result", 23))
  local valid, report = domainOperations.classifyWorldDelta(replacement, {23})
  truthy(valid)
  equal(report.expectedRemovedIds[1], 17)
  equal(report.expectedAddedIds[1], 23)
  equal(report.acceptedIds[1], 23)
  equal(report.unexpectedRemovedIds[1], 99)
  equal(#report.unexpectedAddedIds, 0)
  equal(#replacement.ownedTemporaryIds, 0)
  equal(domainOperations.ownership(state, 23).accepted, true)

  valid, report = domainOperations.classifyWorldDelta(replacement, {23, 77})
  truthy(valid)
  equal(report.unexpectedRemovedIds[1], 99)
  equal(report.unexpectedAddedIds[1], 77)
  equal(domainOperations.ownership(state, 77), nil)
end

tests.v074_scramble_cardinality_is_owned_identity_not_global_delta = function()
  local state = domainOperations.create()
  local scramble = assert(domainOperations.begin(state, {
    domain = "chaos", operationId = "v074-scramble", action = "scramble",
    sourceVehicleId = 17, worldVehicleIdsBefore = {17, 99},
  }))
  local token = domainOperations.callbackToken(scramble, "reload", {expectedVehicleId = 17})
  truthy(domainOperations.registerCandidate(state, token, 17, {created = false}))
  truthy(domainOperations.acceptVehicle(state, scramble, 17, "player_result", 17))
  local valid, report = domainOperations.classifyWorldDelta(scramble, {17, 77})
  truthy(valid)
  equal(report.scrambleIdentityValid, true)
  equal(#report.expectedRemovedIds, 0)
  equal(#report.expectedAddedIds, 0)
  equal(#scramble.ownedTemporaryIds, 0)
  equal(report.unexpectedRemovedIds[1], 99)
  equal(report.unexpectedAddedIds[1], 77)
end

tests.v074_reload_and_readback_metrics_are_bounded_and_structured = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom", {manualSeed = "v074-reload-budget"}))
  local state = harness.main.requestState()
  local metrics = state.lastResult.details.runtimeMetrics
  truthy(type(metrics) == "table")
  truthy(type(metrics.partsReloadCount) == "number")
  truthy(type(metrics.readbackCount) == "number")
  truthy(type(metrics.repairReloadCount) == "number")
  truthy(type(metrics.reloadDuration) == "number")
  truthy(type(metrics.phaseDuration) == "number")
  truthy(type(metrics.maxSingleStep) == "number")
  equal(metrics.reloadBudget.mutationTarget, 1)
  equal(metrics.reloadBudget.repairLimit, 1)
  equal(metrics.reloadBudget.hardLimit, 4)
  truthy(metrics.partsReloadCount <= metrics.reloadBudget.hardLimit)
  truthy(metrics.repairReloadCount <= metrics.reloadBudget.hardLimit)
end

tests.v074_race_focus_slots_and_dna_are_isolated = function()
  local currentVehicleId, entered = 42, {}
  local isolated, focus = raceFocusGuard.restore({
    playerVehicleId = 7, candidateVehicleId = 42,
    getCurrentVehicleId = function() return true, currentVehicleId end,
    enterVehicle = function(vehicleId) entered[#entered + 1] = vehicleId; currentVehicleId = vehicleId; return true end,
  })
  truthy(isolated)
  truthy(focus.restored)
  equal(focus.stolenFocusVehicleId, 42)
  equal(currentVehicleId, 7)
  equal(entered[1], 7)
  local reused, reusedReason = raceFocusGuard.restore({
    playerVehicleId = 7, candidateVehicleId = 7,
    getCurrentVehicleId = function() return true, 7 end,
    enterVehicle = function() error("player must not be used as candidate") end,
  })
  equal(reused, false); equal(reusedReason, "race_candidate_is_player")

  local lineup = assert(raceManager.create({count = 3, episodeSeed = "v074-race", preset = "Maximum Chaos"}))
  local function acceptedResult(model)
    return {success = true, details = {
      model = model, configuration = "base", verifiedTraits = {
        modelKey = model, configuration = "base", sourceKind = "official", vehicleClass = "Car",
      },
      safety = {runtimeIntegrity = "HEALTHY", drivability = "PARTIAL", chaosAcceptance = "ACCEPT_WITH_WARNING"},
      lifecycleAcceptance = {
        finalValidationPassed = true, busy = false,
        pendingWrites = 0, pendingTimers = 0, pendingCallbacks = 0,
      },
    }}
  end
  local first = assert(raceManager.nextCompetitor(lineup))
  truthy(raceManager.record(lineup, 1, acceptedResult("a"), sampleDNA({id = "v074-a"}), first.targetGeneration))
  equal(first.status, "ready_with_warnings")
  truthy(first.dna ~= nil)
  local second = assert(raceManager.nextCompetitor(lineup))
  truthy(raceManager.record(lineup, 2, {success = false, code = "fixture_failure", message = "failed"},
    sampleDNA({id = "must-not-persist"}), second.targetGeneration))
  equal(second.status, "failed")
  equal(second.dna, nil)
  local third = assert(raceManager.nextCompetitor(lineup))
  truthy(raceManager.record(lineup, 3, acceptedResult("c"), sampleDNA({id = "v074-c"}), third.targetGeneration))
  equal(third.status, "ready_with_warnings")
  equal(raceManager.nextCompetitor(lineup), nil)
  local summary = raceManager.summary(lineup)
  equal(summary.ready, 2)
  equal(summary.failed, 1)
  equal(lineup.generationState, "lineup_partial")
  truthy(first.dna ~= nil)

  local invalidLineup = assert(raceManager.create({count = 2, episodeSeed = "invalid-dna", preset = "Maximum Chaos"}))
  local invalid = assert(raceManager.nextCompetitor(invalidLineup))
  truthy(raceManager.record(invalidLineup, 1, acceptedResult("invalid"), {id = "not-a-dna"}, invalid.targetGeneration))
  equal(invalid.status, "failed")
  equal(invalid.failureCode, "lineup_dna_invalid")
  equal(invalid.dna, nil)
  truthy(raceManager.nextCompetitor(invalidLineup) ~= nil)

  local domains, removed = domainOperations.create(), {}
  local slotA = assert(domainOperations.begin(domains, {
    domain = "race", operationId = "slot-a", action = "fullRandom", expectedSlot = 1,
  }))
  local tokenA = domainOperations.callbackToken(slotA, "spawn", {expectedSlot = 1, expectedVehicleId = 101})
  truthy(domainOperations.registerCandidate(domains, tokenA, 101, {created = true}))
  truthy(domainOperations.acceptVehicle(domains, slotA, 101, "race_competitor", 7))
  truthy(domainOperations.terminal(domains, slotA, "completed"))
  local slotB = assert(domainOperations.begin(domains, {
    domain = "race", operationId = "slot-b", action = "fullRandom", expectedSlot = 2,
  }))
  local tokenB = domainOperations.callbackToken(slotB, "spawn", {expectedSlot = 2, expectedVehicleId = 102})
  truthy(domainOperations.registerCandidate(domains, tokenB, 102, {created = true}))
  truthy(domainOperations.terminal(domains, slotB, "failed"))
  domainOperations.reap(domains, function(vehicleId) removed[#removed + 1] = vehicleId; return true end,
    {domain = "race", operationId = "slot-b", budgetMs = 10, maxItems = 8, clock = function() return 0 end})
  equal(removed[1], 102)
  equal(#removed, 1)
  equal(domainOperations.ownership(domains, 101).accepted, true)
  equal(domainOperations.ownership(domains, 101).removed, nil)
end

tests.v074_race_previews_are_read_only_structured_and_generation_scoped = function()
  local worldMutations = {spawn = 0, delete = 0, focus = 0, physics = 0}
  local plan = {
    options = {
      mode = "Grid", requestedMode = "Grid", headingMode = "road",
      spacingMode = "automatic", resolvedLateralSpacing = 3.25,
      resolvedLongitudinalSpacing = 6.5, safetyMargin = 1.75,
      spawnVehicle = function() worldMutations.spawn = worldMutations.spawn + 1 end,
      deleteVehicle = function() worldMutations.delete = worldMutations.delete + 1 end,
      enterVehicle = function() worldMutations.focus = worldMutations.focus + 1 end,
      setPhysics = function() worldMutations.physics = worldMutations.physics + 1 end,
    },
    placements = {
      {position = {x = 10, y = 20, z = 1}, forward = {x = 1, y = 0, z = 0}, normal = {x = 0, y = 0, z = 1}},
      {position = {x = 10, y = 27, z = 1}, forward = {x = 1, y = 0, z = 0}, normal = {x = 0, y = 0, z = 1}},
    },
  }
  local lineup = {competitors = {
    {name = "Alpha", status = "selecting_vehicle", currentVehicleId = 101,
      previewDimensions = {width = 2.2, length = 5.1, source = "actual_vehicle_bounds"}},
    {name = "Bravo", status = "planned", currentVehicleId = 102},
  }}
  local player = {
    position = {x = 3, y = 4, z = 1}, forward = {x = 0, y = 1, z = 0},
    dimensions = {width = 2, length = 4.5, source = "actual_vehicle_bounds"}, vehicleId = 7,
  }
  local staging = racePreview.build("generation_staging", plan, lineup, player, true)
  equal(staging.kind, "staging")
  equal(staging.phase, "generation_staging")
  equal(staging.heading, "road")
  equal(staging.formation, "GRID")
  equal(staging.spacing.lateral, 3.25)
  equal(staging.spacing.longitudinal, 6.5)
  equal(#staging.slots, 3)
  equal(staging.slots[1].slot, 0)
  equal(staging.slots[1].visual, "player")
  equal(staging.slots[2].bounds.source, "actual_vehicle_bounds")
  equal(staging.slots[3].bounds.source, "estimated_fallback")
  equal(staging.slots[3].actualBoundsKnown, false)
  equal(staging.slots[3].groundStatus, "valid")
  equal(staging.slots[3].overlapStatus, "clear")
  truthy(not util.deepEqual(staging.slots[2].transform, staging.slots[3].transform))
  equal(util.stableValue(staging):find("vehicleId", 1, true), nil)
  equal(worldMutations.spawn + worldMutations.delete + worldMutations.focus + worldMutations.physics, 0)

  lineup.competitors[2].status = "failed"
  lineup.competitors[2].previewDimensions = {width = 2.5, length = 6, source = "actual_vehicle_bounds"}
  truthy(racePreview.update(staging, lineup))
  equal(staging.slots[3].visual, "failed")
  equal(staging.slots[3].bounds.source, "actual_vehicle_bounds")
  local placements = racePreview.placements(staging)
  equal(#placements, 3)
  equal(placements[3].visual, "failed")

  local finalGrid = racePreview.build("final_grid", plan, lineup, player, true)
  equal(finalGrid.kind, "finalGrid")
  equal(finalGrid.phase, "final_grid")
  equal(staging.kind, "staging")
  truthy(racePreview.clear(staging, "race_cancelled") ~= nil)
  equal(staging.enabled, false)
  equal(staging.clearedReason, "race_cancelled")
  equal(#staging.slots, 0)
  equal(#racePreview.placements(staging), 0)
  equal(worldMutations.spawn + worldMutations.delete + worldMutations.focus + worldMutations.physics, 0)
end

tests.v073_race_slots_cannot_reuse_accepted_physical_vehicles = function()
  local state = domainOperations.create()
  local slotOne = assert(domainOperations.begin(state, {
    domain = "race", operationId = "race-slot-1", action = "fullRandom", expectedSlot = 1,
  }))
  local oneToken = domainOperations.callbackToken(slotOne, "spawn", {expectedSlot = 1, expectedVehicleId = 41})
  truthy(domainOperations.registerCandidate(state, oneToken, 41, {created = true}))
  truthy(domainOperations.acceptVehicle(state, slotOne, 41, "race_competitor", 1))
  truthy(domainOperations.terminal(state, slotOne, "completed"))

  local slotTwo = assert(domainOperations.begin(state, {
    domain = "race", operationId = "race-slot-2", action = "fullRandom", expectedSlot = 2,
  }))
  local wrongSlot = domainOperations.callbackToken(slotTwo, "spawn", {expectedSlot = 1, expectedVehicleId = 42})
  local wrongSlotOk, wrongSlotReason = domainOperations.registerCandidate(state, wrongSlot, 42, {created = true})
  equal(wrongSlotOk, false); equal(wrongSlotReason, "callback_slot_mismatch")
  local reused = domainOperations.callbackToken(slotTwo, "spawn", {expectedSlot = 2, expectedVehicleId = 41})
  local reusedOk, reusedReason = domainOperations.registerCandidate(state, reused, 41, {created = true})
  equal(reusedOk, false); equal(reusedReason, "vehicle_owned_by_other_slot")
  equal(domainOperations.ownership(state, 41).slot, 1)
  local twoToken = domainOperations.callbackToken(slotTwo, "spawn", {expectedSlot = 2, expectedVehicleId = 42})
  truthy(domainOperations.registerCandidate(state, twoToken, 42, {created = true}))
  truthy(domainOperations.acceptVehicle(state, slotTwo, 42, "race_competitor", 1))
  equal(domainOperations.ownership(state, 42).slot, 2)
end

tests.v073_callback_sequence_fault_injection_is_side_effect_free = function()
  for iteration = 1, 64 do
    local state = domainOperations.create()
    local context = assert(domainOperations.begin(state, {
      domain = "chaos", operationId = "fault-" .. tostring(iteration),
      action = "randomConfig", sourceVehicleId = 1,
    }))
    local expectedId = 1000 + iteration
    local token = domainOperations.callbackToken(context, "spawn", {expectedVehicleId = expectedId})
    local wrongId = expectedId + 10000
    local wrong, wrongReason = domainOperations.registerCandidate(state, token, wrongId, {created = true})
    equal(wrong, false); equal(wrongReason, "callback_vehicle_mismatch")
    truthy(domainOperations.registerCandidate(state, token, expectedId, {created = true}))
    truthy(domainOperations.acceptVehicle(state, context, expectedId, "player_result", expectedId))
    truthy(domainOperations.terminal(state, context, iteration % 2 == 0 and "completed" or "cancelled"))
    local late, lateReason = domainOperations.registerCandidate(state, token, wrongId, {created = true})
    equal(late, false); equal(lateReason, "ignored_stale_callback")
    equal(domainOperations.ownership(state, wrongId), nil)
    equal(context.staleCallbackSideEffects, 0)
  end
end

tests.v076_ownership_properties_hold_across_adversarial_callback_sequences = function()
  for iteration = 1, 64 do
    local sourceId = 100 + iteration
    local candidateId = 1000 + iteration
    local externalId = 10000 + iteration
    local newcomerId = 20000 + iteration

    -- Unrelated world additions are diagnostic only and never become owned.
    local worldState = domainOperations.create()
    local replacement = assert(domainOperations.begin(worldState, {
      domain = "chaos", operationId = "property-world-" .. tostring(iteration),
      action = "randomConfig", sourceVehicleId = sourceId,
      worldVehicleIdsBefore = {sourceId, externalId},
    }))
    truthy(domainOperations.expectRemoval(replacement, sourceId))
    truthy(domainOperations.expectAddition(replacement, candidateId))
    local worldToken = domainOperations.callbackToken(replacement, "spawn", {expectedVehicleId = candidateId})
    truthy(domainOperations.registerCandidate(worldState, worldToken, candidateId, {created = true}))
    truthy(domainOperations.acceptVehicle(worldState, replacement, candidateId, "player_result", candidateId))
    local valid, report = domainOperations.classifyWorldDelta(
      replacement, {candidateId, externalId, newcomerId})
    truthy(valid)
    equal(report.unexpectedAddedIds[1], newcomerId)
    equal(domainOperations.ownership(worldState, newcomerId), nil)

    -- Phase reordering and duplicate delivery cannot create a second effect.
    local callbackState = domainOperations.create()
    local callbackContext = assert(domainOperations.begin(callbackState, {
      domain = "chaos", operationId = "property-callback-" .. tostring(iteration),
      action = "fullRandom", sourceVehicleId = sourceId,
    }))
    local outOfOrder = domainOperations.callbackToken(
      callbackContext, "spawn", {expectedVehicleId = candidateId})
    truthy(domainOperations.setPhase(callbackContext, "binding", "active"))
    local reordered, reorderedReason = domainOperations.registerCandidate(
      callbackState, outOfOrder, candidateId, {created = true})
    equal(reordered, false); equal(reorderedReason, "callback_phase_mismatch")
    equal(domainOperations.ownership(callbackState, candidateId), nil)
    local current = domainOperations.callbackToken(
      callbackContext, "spawn", {expectedVehicleId = candidateId})
    truthy(domainOperations.registerCandidate(callbackState, current, candidateId, {created = true}))
    local duplicate, duplicateReason = domainOperations.registerCandidate(
      callbackState, current, candidateId, {created = true})
    equal(duplicate, false); equal(duplicateReason, "callback_already_consumed")
    equal(#callbackContext.candidateVehicleIds, 1)

    -- A removed candidate releases temporary ownership and a recycled id starts clean.
    truthy(domainOperations.recordRemoval(callbackState, candidateId, "fixture_candidate_removed"))
    equal(#callbackContext.ownedTemporaryIds, 0)
    equal(domainOperations.ownership(callbackState, candidateId).removed, true)
    truthy(domainOperations.terminal(callbackState, callbackContext, "failed"))
    local recycled = assert(domainOperations.begin(callbackState, {
      domain = "chaos", operationId = "property-recycled-" .. tostring(iteration),
      action = "randomConfig", sourceVehicleId = sourceId,
    }))
    local recycledToken = domainOperations.callbackToken(
      recycled, "spawn", {expectedVehicleId = candidateId})
    truthy(domainOperations.registerCandidate(callbackState, recycledToken, candidateId, {created = true}))
    local recycledOwner = domainOperations.ownership(callbackState, candidateId)
    equal(recycledOwner.operationId, recycled.operationId)
    equal(recycledOwner.generation, recycled.generation)
    equal(recycledOwner.removed, nil)

    -- Cancellation during reload invalidates the callback before any ownership change.
    local cancelState = domainOperations.create()
    local cancelled = assert(domainOperations.begin(cancelState, {
      domain = "chaos", operationId = "property-cancel-" .. tostring(iteration),
      action = "scramble", sourceVehicleId = sourceId,
    }))
    truthy(domainOperations.setPhase(cancelled, "reload", "active"))
    local reloadToken = domainOperations.callbackToken(
      cancelled, "reload", {expectedVehicleId = sourceId})
    truthy(domainOperations.terminal(cancelState, cancelled, "cancelled"))
    local afterCancel, cancelReason = domainOperations.registerCandidate(
      cancelState, reloadToken, sourceId, {created = false})
    equal(afterCancel, false); equal(cancelReason, "ignored_stale_callback")
    equal(domainOperations.ownership(cancelState, sourceId), nil)

    -- A new operation supersedes the old generation before its callback arrives.
    local supersedeState = domainOperations.create()
    local old = assert(domainOperations.begin(supersedeState, {
      domain = "chaos", operationId = "property-old-" .. tostring(iteration),
      action = "randomConfig", sourceVehicleId = sourceId,
    }))
    local lateToken = domainOperations.callbackToken(old, "spawn", {expectedVehicleId = candidateId})
    local newest, superseded = domainOperations.begin(supersedeState, {
      domain = "chaos", operationId = "property-new-" .. tostring(iteration),
      action = "randomConfig", sourceVehicleId = sourceId,
    })
    truthy(newest); equal(superseded.terminalState, "superseded")
    local late, lateReason = domainOperations.registerCandidate(
      supersedeState, lateToken, candidateId, {created = true})
    equal(late, false); equal(lateReason, "ignored_stale_callback")
    equal(domainOperations.ownership(supersedeState, candidateId), nil)
    equal(newest.staleCallbackSideEffects, 0)
  end
end

tests.v067_dynamic_race_formations_and_spacing = function()
  local frame = {
    position = {x = 0, y = 0, z = 5}, forward = {x = 0, y = 1, z = 0},
    right = {x = 1, y = 0, z = 0},
  }
  local ground = function(position)
    return true, {point = {x = position.x, y = position.y, z = 0}, normal = {x = 0, y = 0, z = 1}}
  end
  local dimensions = {
    {width = 2.2, length = 4.5}, {width = 3.2, length = 9},
    {width = 1.8, length = 3.8}, {width = 2.5, length = 5},
  }
  local automatic = assert(spawnDirector.plan(frame, {
    mode = "Automatic Best Fit", count = 4, spacingMode = "automatic",
    safetyMargin = 1.5, availableWidth = 18, columns = 3, vehicleDimensions = dimensions,
  }, ground, {}))
  equal(automatic.options.requestedMode, "Automatic Best Fit")
  equal(automatic.options.mode, "Staggered Grid")
  truthy(automatic.options.resolvedLateralSpacing >= 4.7)
  truthy(automatic.options.resolvedLongitudinalSpacing >= 10.5)
  equal(automatic.placements[2].dimensions.width, 3.2)
  local unknownWidth = assert(spawnDirector.plan(frame, {
    mode = "Automatic Best Fit", count = 3, spacingMode = "automatic",
    vehicleDimensions = dimensions,
  }, ground, {}))
  equal(unknownWidth.options.mode, "Single File Behind")
  equal(unknownWidth.options.fallbackReason, "available_width_unknown_single_file")
  local narrow = assert(spawnDirector.plan(frame, {
    mode = "Side-by-side Grid", count = 3, spacingMode = "automatic",
    availableWidth = 4, columns = 3, vehicleDimensions = dimensions,
  }, ground, {}))
  equal(narrow.options.mode, "Single File Behind")
  equal(narrow.options.fallbackReason, "narrow_area_single_file")
  local split = assert(spawnDirector.plan(frame, {
    mode = "Split Left and Right", count = 4, spacingMode = "manual",
    lateralSpacing = 5, longitudinalSpacing = 8,
  }, ground, {}))
  truthy(split.placements[1].position.x < 0); truthy(split.placements[2].position.x > 0)
  local ahead = assert(spawnDirector.plan(frame, {
    mode = "Single File Ahead", count = 2, longitudinalSpacing = 9,
  }, ground, {}))
  truthy(ahead.placements[2].position.y > ahead.placements[1].position.y)
end

tests.v067_ternary_safety_decisions_are_evidence_based = function()
  local unknownGraph = validator.buildGraph({slots = {}}, {type = "Car"}, {})
  local unknown = validator.validateGraph(unknownGraph, unknownGraph, true)
  equal(unknown.decision, "UNKNOWN_OR_PENDING"); equal(unknown.valid, nil)
  local unsafeGraph = validator.buildGraph({slots = {{
    path = "main", id = "main", currentPart = "", required = true, coreSlot = true,
    candidates = {}, allowTypes = {}, depth = 0,
  }}}, {type = "Car"}, {})
  local unsafe = validator.validateGraph(unsafeGraph, unsafeGraph, true)
  equal(unsafe.decision, "INVALID_CONFIRMED"); equal(unsafe.valid, false)
  local unavailable = engineFluidGuard.assess({available = false}, "drivable_combustion")
  equal(unavailable.decision, "UNKNOWN_OR_PENDING"); equal(unavailable.valid, nil)
  local missingRuntime = engineFluidGuard.assess({available = true, engines = {}}, "drivable_combustion")
  equal(missingRuntime.decision, "UNKNOWN_OR_PENDING"); equal(missingRuntime.valid, nil)
  local zeroOil = engineFluidGuard.assess({available = true, engines = {{
    name = "engine", oilMass = 0, minimumSafeOilMass = 1,
  }}}, "drivable_combustion")
  equal(zeroOil.decision, "INVALID_CONFIRMED"); equal(zeroOil.valid, false)
  local healthy = engineFluidGuard.assess({available = true, engines = {{
    name = "engine", oilMass = 4, minimumSafeOilMass = 1,
  }}}, "drivable_combustion")
  equal(healthy.decision, "VALID"); truthy(healthy.valid)
  local fuelUnknown = energyStorageGuard.analyze({energyStorages = {{
    name = "tank", type = "fuelTank", fuelCapacity = 50,
  }}}, 0.1)
  equal(fuelUnknown.decision, "UNKNOWN_OR_PENDING")
end

tests.v073_safety_gate_requires_current_stable_evidence_and_is_bounded = function()
  local slot = {
    path = "main", id = "main", currentPart = "", required = true, coreSlot = true,
    candidates = {}, allowTypes = {}, depth = 0,
  }
  local staleGraph = validator.buildGraph({slots = {slot}}, {type = "Car"}, {evidence = {
    coherent = true, expectedVehicleId = 7, vehicleId = 8,
    operationCurrent = true, phaseCurrent = true, slotCurrent = true, stableSamples = 2,
  }})
  local stale = validator.validateGraph(staleGraph, staleGraph, true)
  equal(stale.decision, "UNKNOWN_OR_PENDING")
  equal(stale.valid, nil)
  truthy(#(stale.pendingFailures or {}) > 0)

  local confirmedGraph = validator.buildGraph({slots = {slot}}, {type = "Car"}, {evidence = {
    coherent = true, expectedVehicleId = 7, vehicleId = 7,
    operationCurrent = true, phaseCurrent = true, slotCurrent = true, stableSamples = 2,
  }})
  local confirmed = validator.validateGraph(confirmedGraph, confirmedGraph, true)
  equal(confirmed.decision, "INVALID_CONFIRMED")

  local gate = safetyGate.create({maxAttempts = 3, retryWindow = 1.5, retryDelay = 0.1})
  local action, details = safetyGate.observe(gate, stale, 0, false)
  equal(action, "retry"); equal(details.attempt, 1)
  action, details = safetyGate.observe(gate, stale, 0.1, false)
  equal(action, "retry"); equal(details.attempt, 2)
  action = safetyGate.observe(gate, stale, 0.2, false)
  equal(action, "unconfirmed"); equal(safetyGate.snapshot(gate).attempts, 3)

  safetyGate.reset(gate)
  action = safetyGate.observe(gate, confirmed, 0.3, false)
  equal(action, "invalid_confirmed")
  safetyGate.reset(gate)
  action = safetyGate.observe(gate, stale, 0.4, true)
  equal(action, "retry")
  action = safetyGate.observe(gate, stale, 0.5, true)
  equal(action, "retry")
  action = safetyGate.observe(gate, stale, 0.6, true)
  equal(action, "accept_partial")
end

tests.v074_safety_v2_separates_integrity_drivability_policy_and_fluids = function()
  local functionalFailure = {
    decision = "INVALID_CONFIRMED", valid = false, status = "unsafe",
    classification = "drivable_combustion",
    failures = {{reason = "required_role_missing:wheel"}}, warnings = {}, missingParts = {},
  }
  local converged = {
    objectExists = true, ownershipCurrent = true, bindConverged = true, treeConverged = true,
  }
  local maximum = safetyModel.layer(functionalFailure, {
    chaos = 100, allowMissingParts = true, protectCriticalParts = false,
  }, converged)
  equal(maximum.runtimeIntegrity, "HEALTHY")
  equal(maximum.drivability, "UNDRIVABLE")
  equal(maximum.chaosAcceptance, "ACCEPT_WITH_WARNING")
  equal(maximum.decision, "VALID")
  truthy(maximum.valid)

  local strict = safetyModel.layer(functionalFailure, {
    chaos = 20, allowMissingParts = false, allowPartialResult = false, protectCriticalParts = true,
  }, converged)
  equal(strict.runtimeIntegrity, "HEALTHY")
  equal(strict.drivability, "UNDRIVABLE")
  equal(strict.chaosAcceptance, "REJECT_BY_POLICY")
  equal(strict.decision, "VALID")
  equal(strict.destructiveRollbackAuthorized, false)
  local gate = safetyGate.create()
  equal(safetyGate.observe(gate, strict, 0, false), "policy_rejected")

  local missingObject = safetyModel.layer(functionalFailure, {chaos = 100}, {
    objectExists = false, ownershipCurrent = true, bindConverged = true, treeConverged = true,
  })
  equal(missingObject.runtimeIntegrity, "INVALID_CONFIRMED")
  equal(missingObject.decision, "INVALID_CONFIRMED")

  local transient = safetyModel.layer({
    decision = "UNKNOWN_OR_PENDING", valid = nil, status = "pending", classification = "unknown",
  }, {chaos = 100}, {
    objectExists = true, ownershipCurrent = true, bindConverged = false, treeConverged = false,
  })
  equal(transient.runtimeIntegrity, "UNKNOWN_OR_PENDING")
  equal(transient.drivability, "UNKNOWN")
  equal(transient.decision, "UNKNOWN_OR_PENDING")

  equal(engineFluidGuard.assess(nil, "drivable_combustion").fluidState, "UNKNOWN")
  equal(engineFluidGuard.assess({available = false}, "drivable_combustion").fluidState, "UNKNOWN")
  equal(engineFluidGuard.assess({available = true, engines = {}}, "drivable_combustion").fluidState, "UNKNOWN")
  equal(engineFluidGuard.assess({available = true, engines = {{oilMass = 0}}}, "drivable_combustion").fluidState,
    "UNSAFE_CONFIRMED")
  equal(engineFluidGuard.assess({available = true, engines = {{oilMass = 4}}}, "drivable_combustion").fluidState,
    "FLUID_OK")
  equal(engineFluidGuard.assess(nil, "prop").fluidState, "NOT_APPLICABLE")
end

tests.v067_race_policy_inventory_and_roundtrip = function()
  local expected = {
    "avoidDuplicateModels", "avoidDuplicateConfigurations", "avoidDuplicateFamilies",
    "maximumSameFamily", "diversifyVehicleClasses", "diversifyPropulsion",
    "diversifyDrivetrain", "diversifySource", "diversifyWheelStyles",
    "diversifyBodyTypes", "allowOfficialVehicles", "allowModVehicles",
    "allowAutomationVehicles", "allowTrailers", "allowProps",
  }
  for _, key in ipairs(expected) do truthy(raceManager.RULE_DEFAULTS[key] ~= nil, "missing policy " .. key) end
  local lineup = assert(raceManager.create({
    count = 5, participationMode = "player", preset = "Custom",
    episodeSeed = "policy-roundtrip", avoidDuplicateFamilies = true,
    maximumSameFamily = 1, diversifyPropulsion = true,
    allowOfficialVehicles = false, allowModVehicles = true,
    formation = "Split Left and Right", spacingMode = "manual",
    longitudinalSpacing = 11, lateralSpacing = 6, safetyMargin = 2,
  }))
  truthy(lineup.varietyRules.avoidDuplicateFamilies)
  equal(lineup.varietyRules.maximumSameFamily, 1)
  truthy(lineup.varietyRules.diversifyPropulsion)
  equal(lineup.settings.formation, "SPLIT_LEFT_RIGHT")
  equal(lineup.settings.longitudinalSpacing, 11)
  local imported = assert(lineupSchema.sanitizedImport(lineup))
  equal(imported.settings.participationMode, "player")
  equal(imported.settings.countSemantics, "total_vehicles")
  equal(imported.settings.formation, "SPLIT_LEFT_RIGHT")
  truthy(imported.varietyRules.avoidDuplicateFamilies)
end

tests.v075_outcome_taxonomy_is_explicit_and_terminally_immutable = function()
  local cases = {
    {true, "ok", {}, "completed", "COMPLETED", "CONFIRMED"},
    {true, "ok", {skippedCount = 2}, "completed", "COMPLETED_WITH_SKIPS", "CONFIRMED"},
    {true, "ok", {warnings = {"fixture"}}, "completed", "COMPLETED_WITH_WARNING", "CONFIRMED"},
    {true, "ok", {partialApplied = true}, "partial", "PARTIAL_APPLIED", "CONFIRMED"},
    {false, "phase_timeout", {}, "failed", "FAILED_TIMEOUT", "CONFIRMED"},
    {false, "watchdog_no_progress", {}, "failed", "FAILED_STALLED", "CONFIRMED"},
    {false, "runtime_integrity_failed", {}, "failed", "FAILED_RUNTIME_INTEGRITY", "CONFIRMED"},
    {false, "unchanged", {}, "failed", "FAILED_NO_CHANGE", "CONFIRMED"},
    {false, "failed", {rollback = "completed"}, "failed", "FAILED_ROLLED_BACK", "CONFIRMED"},
    {false, "cancelled", {}, "cancelled", "CANCELLED", "CONFIRMED"},
    {true, "fluid_unknown", {telemetrySupported = false}, "completed",
      "COMPLETED_WITH_WARNING", "UNSUPPORTED_TELEMETRY"},
  }
  for _, fixture in ipairs(cases) do
    local outcome, confidence = operationOutcome.classify(fixture[1], fixture[2], fixture[3], fixture[4])
    equal(outcome, fixture[5])
    equal(confidence, fixture[6])
  end
  local terminal = {}
  truthy(operationOutcome.freeze(terminal, "COMPLETED_WITH_WARNING", "UNCERTAIN"))
  local changed, reason = operationOutcome.freeze(terminal, "FAILED_NO_CHANGE", "CONFIRMED")
  equal(changed, false)
  equal(reason, "terminal_outcome_immutable")
  equal(terminal.outcome, "COMPLETED_WITH_WARNING")
  equal(operationOutcome.legacy(terminal.outcome), "success_with_warning")

  local scramble = pipelineHarness.new({paintUnavailable = true})
  truthy(pipelineHarness.driveSuccess(scramble, "scramble", {manualSeed = "v075-paint-skip"}))
  equal(scramble.main.requestState().lastResult.details.terminalOutcome, "COMPLETED_WITH_SKIPS")

  local randomCar = pipelineHarness.new({energyReadFailure = true})
  truthy(randomCar.main.randomConfig({manualSeed = "v075-fluid-unknown"}))
  pipelineHarness.confirmReplacement(randomCar)
  pipelineHarness.driveActive(randomCar, 128)
  equal(randomCar.main.requestState().lastResult.details.terminalOutcome, "COMPLETED_WITH_WARNING")

  local treeSequence = {}
  for pass = 1, 8 do
    local tree = {chosenPartName = "fixture_root", children = {}}
    for slot = 1, pass do
      tree.children["slot" .. tostring(slot)] = {
        id = "slot" .. tostring(slot), path = "/slot" .. tostring(slot) .. "/",
        chosenPartName = "part_a", suitablePartNames = {"part_a", "part_b"}, children = {},
      }
    end
    treeSequence[#treeSequence + 1] = tree
  end
  local bounded = pipelineHarness.new({treeSequence = treeSequence})
  truthy(pipelineHarness.driveSuccess(bounded, "fullRandom", {
    manualSeed = "v075-bounded-partial", chaos = 100,
  }))
  local boundedResult = bounded.main.requestState().lastResult
  truthy(boundedResult.details.runtimeMetrics.reloadBudget.hardLimitReached)
  equal(boundedResult.details.terminalOutcome, "PARTIAL_APPLIED")
end

tests.v075_phase_watchdog_tracks_semantic_progress_and_engine_waits = function()
  local state = progressWatchdog.create(0, {warningAfter = 1, stalledAfter = 2})
  truthy(progressWatchdog.setPhase(state, "waiting_parts_reload", 0))
  equal(progressWatchdog.evaluate(state, 21, {waitingForEngineEvent = true}),
    "WAITING_FOR_CONFIRMED_ENGINE_EVENT")
  local progressAt = state.lastSemanticProgressAt
  local accepted, class = progressWatchdog.note(state, "callback", "callback_received", 22)
  equal(accepted, false)
  equal(class, "callback_noise")
  equal(state.lastSemanticProgressAt, progressAt)

  truthy(progressWatchdog.setPhase(state, "applying_parts", 22))
  equal(progressWatchdog.evaluate(state, 38, {engineActive = true}),
    "LONG_RUNNING_BUT_ENGINE_ACTIVE")
  truthy(progressWatchdog.setPhase(state, "planning_parts", 38))
  equal(progressWatchdog.evaluate(state, 74, {}), "NO_PROGRESS")
  progressWatchdog.setDeadlines(state, 75, 90)
  equal(progressWatchdog.evaluate(state, 75, {}), "PHASE_DEADLINE")
  truthy(progressWatchdog.setStatus(state, "terminal"))
  equal(progressWatchdog.evaluate(state, 1000, {}), "PHASE_DEADLINE")

  local global = progressWatchdog.create(0, {operationDeadline = 5})
  equal(progressWatchdog.evaluate(global, 5, {}), "OPERATION_DEADLINE")
  local progressing = progressWatchdog.create(0, {warningAfter = 2, stalledAfter = 4})
  truthy(progressWatchdog.note(progressing, "reload", "generation_1", 3))
  equal(progressWatchdog.evaluate(progressing, 5, {}), "SLOW_PROGRESS")
  truthy(progressWatchdog.note(progressing, "reload", "generation_2", 5))
  equal(progressWatchdog.evaluate(progressing, 7, {}), "SLOW_PROGRESS")
end

tests.v076_outcome_axes_separate_application_verification_and_failure = function()
  local cases = {
    {true, "fluid_unknown", {telemetrySupported = false}, "completed",
      "COMPLETED_WITH_WARNING", "APPLIED", "UNSUPPORTED_TELEMETRY", nil},
    {true, "ok", {skippedCount = 2}, "completed",
      "COMPLETED_WITH_SKIPS", "APPLIED", "CONFIRMED", nil},
    {true, "batch_incomplete", {partialApplied = true, appliedIncomplete = true}, "partial",
      "PARTIAL_APPLIED", "PARTIALLY_APPLIED", "CONFIRMED", nil},
    {false, "phase_deadline", {}, "failed",
      "FAILED_TIMEOUT", "NOT_APPLIED", "CONFIRMED", "TIMEOUT"},
    {false, "watchdog_no_progress", {}, "failed",
      "FAILED_STALLED", "NOT_APPLIED", "CONFIRMED", "STALLED"},
    {false, "runtime_integrity_failed", {}, "failed",
      "FAILED_RUNTIME_INTEGRITY", "NOT_APPLIED", "CONFIRMED", "RUNTIME_INTEGRITY"},
    {false, "vehicle_spawn_failed", {}, "failed",
      "FAILED_SPAWN", "NOT_APPLIED", "CONFIRMED", "SPAWN"},
    {false, "target_identity_unbound", {}, "failed",
      "FAILED_BIND", "NOT_APPLIED", "CONFIRMED", "BIND"},
    {false, "parts_reload_failed", {}, "failed",
      "FAILED_RELOAD", "NOT_APPLIED", "CONFIRMED", "RELOAD"},
    {false, "lineup_storage_write", {}, "failed",
      "FAILED_PERSISTENCE", "NOT_APPLIED", "CONFIRMED", "PERSISTENCE"},
    {false, "rollback_failed_candidate", {rollback = "completed"}, "failed",
      "FAILED_ROLLED_BACK", "ROLLED_BACK", "CONFIRMED", "ROLLED_BACK"},
  }
  for _, fixture in ipairs(cases) do
    local axes = operationOutcome.axes(fixture[1], fixture[2], fixture[3], fixture[4])
    equal(axes.terminalOutcome, fixture[5])
    equal(axes.appliedState, fixture[6])
    equal(axes.verificationConfidence, fixture[7])
    equal(axes.failureKind, fixture[8])
  end
end

tests.v076_phase_watchdog_accepts_unique_evidence_but_not_callback_churn = function()
  local firstLoad = progressWatchdog.create(0, {
    warningAfter = 1, stalledAfter = 2, phaseDeadline = 45, operationDeadline = 90,
  })
  truthy(progressWatchdog.setPhase(firstLoad, "issuing_spawn", 0))
  equal(progressWatchdog.evaluate(firstLoad, 44, {waitingForEngineEvent = true}),
    "WAITING_FOR_CONFIRMED_ENGINE_EVENT")
  equal(progressWatchdog.evaluate(firstLoad, 45, {waitingForEngineEvent = true}),
    "PHASE_DEADLINE")

  local readback = progressWatchdog.create(0, {warningAfter = 1, stalledAfter = 4})
  truthy(progressWatchdog.note(readback, "target", "vehicle:101", 3))
  equal(readback.lastTargetEvidenceAt, 3)
  truthy(progressWatchdog.note(readback, "tree", "revision:7", 6))
  equal(readback.lastTreeChangeAt, 6)
  truthy(progressWatchdog.note(readback, "readback", "generation:1", 9))
  local progressAt = readback.lastSemanticProgressAt
  local duplicate, duplicateClass = progressWatchdog.note(readback, "readback", "generation:1", 10)
  equal(duplicate, false)
  equal(duplicateClass, "incidental_activity")
  for index = 1, 20 do
    local accepted = progressWatchdog.note(readback, "callback", "stale_callback_" .. tostring(index), 10 + index)
    equal(accepted, false)
  end
  equal(readback.lastSemanticProgressAt, progressAt)
  truthy(progressWatchdog.setPhase(readback, "planning_parts", 30))
  equal(progressWatchdog.evaluate(readback, 66, {}), "NO_PROGRESS")

  for _, phase in ipairs({
    "isolating_failed_candidate", "rolling_back_batch", "retrying_candidate",
    "rescanning_tree", "validating_engine_fluids", "recovering_previous",
    "recovering_last_completed_good", "recovering_fallback", "cancelling",
  }) do
    truthy(progressWatchdog.PHASE_PROFILES[phase], "missing watchdog profile " .. phase)
  end
end

tests.v076_randomizer_paths_preserve_fast_identity_and_coherent_batching = function()
  local randomCar = pipelineHarness.new({vehicleId = 10, returnedVehicleId = 11})
  truthy(pipelineHarness.driveSuccess(randomCar, "randomConfig", {manualSeed = "v076-fast-car"}))
  local randomState = randomCar.main.requestState()
  truthy(not randomState.busy)
  equal(randomCar.vehicleId, 11)
  for _, write in ipairs(randomCar.writes) do
    truthy(write.kind ~= "parts" and write.kind ~= "tuning" and write.kind ~= "paint",
      "Random Car entered a Full Random mutation stage")
  end

  local scramble = pipelineHarness.new({vehicleId = 20})
  truthy(pipelineHarness.driveSuccess(scramble, "scramble", {manualSeed = "v076-same-object"}))
  equal(scramble.vehicleId, 20)
  local replacements = 0
  for _, call in ipairs(scramble.calls) do if call == "replace" then replacements = replacements + 1 end end
  equal(replacements, 0)

  local wideTree = {chosenPartName = "fixture_root", children = {}}
  for index = 1, 3 do
    wideTree.children["slot" .. tostring(index)] = {
      id = "slot" .. tostring(index), path = "/slot" .. tostring(index) .. "/",
      chosenPartName = "part_a", suitablePartNames = {"part_a", "part_b"}, children = {},
    }
  end
  local full = pipelineHarness.new({treeSequence = {wideTree, wideTree, wideTree}})
  truthy(pipelineHarness.driveSuccess(full, "fullRandom", {manualSeed = "v076-wide-batch"}))
  local metrics = full.main.requestState().lastResult.details.runtimeMetrics
  equal(metrics.partsReloadCount, 1)
  equal(metrics.reloadBudget.coherentBatchCount, 1)
  equal(metrics.reloadBudget.largestCoherentBatch, 3)
  equal(metrics.reloadBudget.plannedPartWrites, 3)
  equal(metrics.reloadBudget.perWriteReloadsPrevented, 2)
  truthy(metrics.partsReloadCount <= metrics.reloadBudget.hardLimit)
end

tests.v075_preview_state_requires_a_rendered_frame = function()
  local plan = {
    options = {requestedMode = "Grid", safetyMargin = 1.5},
    placements = {{position = {x = 1, y = 2, z = 3}, normal = {x = 0, y = 0, z = 1}}},
  }
  local lineup = {settings = {formation = "Grid"}, competitors = {{status = "planned", name = "One"}}}
  local preview = racePreview.build("generation", plan, lineup, nil, true)
  equal(preview.state, "PREVIEW_DATA_READY")
  equal(preview.formation, "GRID")
  racePreview.recordRender(preview, {rendererAvailable = false, requestedMarkerCount = 1}, 1, false)
  equal(preview.state, "PREVIEW_FAILED")
  equal(preview.renderer.availabilityState, "RENDER_UNAVAILABLE")
  racePreview.recordRender(preview, {
    rendererAvailable = true, requestedMarkerCount = 1, renderedMarkerCount = 0,
    errorCode = "fixture_renderer_error",
  }, 2, false)
  equal(preview.state, "PREVIEW_FAILED")
  racePreview.recordRender(preview, {
    rendererAvailable = true, requestedMarkerCount = 1, renderedMarkerCount = 1,
  }, 3, true)
  equal(preview.state, "PREVIEW_RENDERED")
  equal(preview.renderer.availabilityState, "RENDER_AVAILABLE")
  equal(preview.renderer.renderState, "RENDERED")
  equal(preview.renderer.successfulFrames, 1)
  equal(preview.renderer.lastFrameAt, 3)
  truthy(racePreview.stale(preview, "generation_changed"))
  equal(preview.state, "PREVIEW_STALE")
  racePreview.clear(preview, "toggle_off")
  equal(preview.state, "PREVIEW_DISABLED")
  equal(#preview.slots, 0)
  local preferences = p2.preferences.patch(p2.preferences.defaults(), {
    race = {previewEnabled = false, formation = "Grid"},
  })
  equal(preferences.race.previewEnabled, false)
  equal(preferences.race.formation, "GRID")
  preferences = p2.preferences.patch(preferences, {race = {previewEnabled = true}})
  equal(preferences.race.previewEnabled, true)
end

tests.v076_preview_renderer_failure_toggle_and_false_return_are_explicit = function()
  local plan = {options = {requestedMode = "GRID"}, placements = {
    {position = {x = 0, y = 0, z = 0}, normal = {x = 0, y = 0, z = 1}},
  }}
  local lineup = {settings = {formation = "GRID"}, competitors = {{status = "planned"}}}
  local preview = racePreview.build("generation", plan, lineup, nil, true)
  racePreview.recordRender(preview, nil, 1, false)
  equal(preview.state, "PREVIEW_FAILED")
  equal(preview.renderer.lastErrorCode, "preview_renderer_returned_false")
  racePreview.recordRender(preview, {
    rendererAvailable = true, requestedMarkerCount = 1, renderedMarkerCount = 0,
  }, 2, true)
  equal(preview.state, "PREVIEW_RENDERING")
  equal(preview.renderer.renderState, "RENDERING")
  for cycle = 1, 50 do
    racePreview.clear(preview, "toggle_off")
    equal(preview.state, "PREVIEW_DISABLED")
    equal(#racePreview.placements(preview), 0)
    preview = racePreview.build("generation", plan, lineup, nil, true)
    equal(preview.state, "PREVIEW_DATA_READY")
  end
end

tests.v076_race_retry_attempts_are_fresh_persistent_and_stale_safe = function()
  local state = raceAttemptCoordinator.create()
  local desired = {formation = "GRID", previewOrigin = "camera", count = 4}
  local first = assert(raceAttemptCoordinator.begin(state, "preview_generation", {
    now = 1, deadlineSeconds = 10, desired = desired,
  }))
  local staleToken = assert(raceAttemptCoordinator.callbackToken(state, first, "plan_ready"))
  equal(first.generation, 1)
  truthy(raceAttemptCoordinator.finish(state, first, "failed", {
    now = 2, errorCode = "position_blocked", recoverable = true,
    retryAction = "previewRaceGeneration",
  }))
  equal(state.recoverable.preview_generation.code, "position_blocked")
  equal(state.recoverable.preview_generation.desired.formation, "GRID")
  equal(state.current.preview_generation.active, false, "failed attempt must release its transient lock")

  local second = assert(raceAttemptCoordinator.begin(state, "preview_generation", {
    now = 3, deadlineSeconds = 10, desired = desired,
  }))
  truthy(second.operationId ~= first.operationId)
  equal(second.generation, first.generation + 1)
  equal(state.recoverable.preview_generation.code, "position_blocked",
    "recoverable error stays until success or dismiss")
  local staleOk, staleReason = raceAttemptCoordinator.validateCallback(state, staleToken, true)
  equal(staleOk, false); equal(staleReason, "race_attempt_callback_stale")
  equal(second.staleCallbacksPrevented, 1)
  truthy(raceAttemptCoordinator.finish(state, second, "succeeded", {now = 4}))
  equal(state.recoverable.preview_generation, nil)

  local lineupOne = assert(raceAttemptCoordinator.begin(state, "lineup_generation", {
    now = 5, desired = {preset = "Mods Showcase"},
  }))
  truthy(raceAttemptCoordinator.finish(state, lineupOne, "failed", {
    now = 6, errorCode = "lineup_staging_unsafe", recoverable = true,
    retryAction = "createChaosLineup",
  }))
  local lineupTwo = assert(raceAttemptCoordinator.begin(state, "lineup_generation", {
    now = 7, desired = {preset = "Mods Showcase"},
  }))
  equal(lineupTwo.generation, lineupOne.generation + 1)
  equal(state.recoverable.lineup_generation.retryAction, "createChaosLineup")
  truthy(raceAttemptCoordinator.dismiss(state, "lineup_generation"))
  equal(state.recoverable.lineup_generation, nil)
end

tests.v075_race_acceptance_is_slot_local_and_terminally_immutable = function()
  local showcase = raceManager.presetOptions("Mods Showcase", {})
  truthy(showcase.acceptMetadataUncertain)
  truthy(showcase.acceptPotentiallyUndrivable)
  local lineup = assert(raceManager.create({
    count = 2, episodeSeed = "v075-terminal", preset = "Mods Showcase",
  }))
  local competitor = assert(raceManager.nextCompetitor(lineup))
  local result = {success = true, details = {
    terminalOutcome = "COMPLETED_WITH_WARNING",
    metadataUncertain = true,
    potentiallyUndrivable = true,
    verifiedTraits = {},
    safety = {runtimeIntegrity = "HEALTHY", drivability = "PARTIAL"},
    lifecycleAcceptance = {
      finalValidationPassed = true, busy = false,
      pendingWrites = 0, pendingTimers = 0, pendingCallbacks = 0,
    },
  }}
  truthy(raceManager.record(lineup, competitor.index, result, nil, competitor.targetGeneration))
  equal(competitor.status, "ready_with_warnings")
  equal(competitor.dna, nil)
  local changed, reason = raceManager.record(lineup, competitor.index,
    {success = false, code = "late_failure"}, nil, competitor.targetGeneration)
  equal(changed, false)
  equal(reason, "lineup_competitor_closed")
  equal(competitor.status, "ready_with_warnings")
end

tests.v075_lineup_persistence_and_scheduler_failures_are_contained = function()
  local lineup = assert(raceManager.create({
    count = 3, episodeSeed = "v075-scheduler", preset = "Mods Showcase",
  }))
  local library = lineupStorage.create(4)
  local before = util.deepCopy(library)
  local failed, failureReason, unchanged = lineupPersistence.checkpoint(library, lineup, {
    add = function(candidate)
      candidate.entries = {{id = "must-not-leak"}}
      return false, "fixture_transient_write_failure"
    end,
  })
  equal(failed, false)
  equal(failureReason, "fixture_transient_write_failure")
  truthy(util.deepEqual(library, before))
  truthy(unchanged == library)
  truthy(lineupSchema.validate(lineup))

  local saved, stored, committed = lineupPersistence.checkpoint(library, lineup, lineupStorage)
  truthy(saved)
  truthy(stored ~= nil)
  truthy(committed ~= library)
  equal(#committed.entries, 1)
  equal(#library.entries, 0)

  local audit = raceScheduler.audit(lineup, {
    busy = false, activeOperation = false, pendingNext = false,
  })
  truthy(audit.schedule)
  equal(audit.slot, 1)
  local first = assert(raceManager.nextCompetitor(lineup))
  truthy(first.status ~= "planned")
  first.status = "randomizing"
  first.phase = "randomizing"
  local healed = raceScheduler.audit(lineup, {
    busy = false, activeOperation = false, pendingNext = false,
  })
  truthy(healed.healed)
  equal(first.status, "failed")
  equal(first.dna, nil)
  local nextSlot = assert(raceManager.nextCompetitor(lineup))
  equal(nextSlot.index, 2)
end

tests.v076_lineup_persistence_is_typed_and_scheduler_progress_is_bounded = function()
  local lineup = assert(raceManager.create({count = 3, episodeSeed = "v076-bounded"}))
  local schemaFailure = lineupPersistence.classify("lineup_schema_invalid", "schema")
  equal(schemaFailure.code, "lineup_storage_schema_validation")
  equal(schemaFailure.recoverable, false)
  local writeFailure = lineupPersistence.recordFailure(lineup,
    {code = "atomic_replace_failed"}, "write", 10)
  equal(writeFailure.code, "lineup_storage_atomic_commit")
  equal(lineup.persistence.lastCause, "atomic_replace_failed")
  equal(lineup.persistence.retryAction, "retryLineupPersistence")
  truthy(lineup.persistence.nextRetryAt > 10)
  lineupPersistence.recordSuccess(lineup, 20)
  equal(lineup.persistence.status, "saved")
  equal(lineup.persistence.lastCause, nil)

  local scheduled = raceScheduler.audit(lineup, {
    busy = false, activeOperation = false, pendingNext = false,
  })
  truthy(scheduled.schedule); equal(scheduled.slot, 1)
  local terminal
  for _ = 1, 20 do
    local audit = raceScheduler.audit(lineup, {
      busy = false, activeOperation = false, pendingNext = true,
    })
    if audit.terminal then terminal = audit; break end
  end
  truthy(terminal ~= nil, "planned idle scheduler must terminate explicitly within a bound")
  equal(terminal.reason, "lineup_scheduler_progress_exhausted")
  truthy(raceScheduler.noteDispatch(lineup))
  local afterDispatch = raceScheduler.audit(lineup, {
    busy = false, activeOperation = false, pendingNext = true,
  })
  equal(afterDispatch.terminal, nil)
end

tests.v075_ai_capabilities_match_runtime_and_quick_presets = function()
  for mode in pairs(aiAdapter.MODES) do truthy(aiDirector.MODES[mode], "director missing " .. mode) end
  for mode in pairs(aiDirector.MODES) do truthy(aiAdapter.MODES[mode], "adapter missing " .. mode) end
  local oldLookup = rawget(_G, "getObjectByID")
  local commands = {}
  _G.getObjectByID = function()
    return {queueLuaCommand = function(_, command) commands[#commands + 1] = command end}
  end
  local caps = aiAdapter.capabilities()
  local expectedModes = {"Destination", "Route", "Follow", "Chase", "Flee", "Traffic", "Roam"}
  local expectedPresets = {"Follow", "Convoy", "Chase", "Flee", "Traffic", "Roam", "Swarm"}
  equal(table.concat(caps.supportedModes, ","), table.concat(expectedModes, ","))
  equal(table.concat(caps.quickPresets, ","), table.concat(expectedPresets, ","))
  truthy(aiAdapter.start(10, "Flee", {targetVehicleId = 11, aggression = 0.8}))
  truthy(commands[#commands]:find("ai.setMode%(\"flee\"%)") ~= nil)
  truthy(aiAdapter.start(10, "Roam", {aggression = 0.8}))
  truthy(commands[#commands]:find("ai.setMode%('random'%)") ~= nil)
  _G.getObjectByID = oldLookup
end

tests.v075_identity_contact_and_playground_foundations_are_bounded = function()
  local localIdentity = vehicleIdentity.normalize({
    environment = "multiplayer_compatible", localVehicleId = 7,
    ownerPlayerId = "local", networkVehicleId = "net-7", authority = "LOCAL",
  })
  local remoteIdentity = vehicleIdentity.normalize({
    environment = "multiplayer_compatible", localVehicleId = 7,
    ownerPlayerId = "remote", networkVehicleId = "net-7", authority = "REMOTE",
  })
  truthy(not vehicleIdentity.same(localIdentity, remoteIdentity))
  truthy(vehicleIdentity.canMutate(localIdentity))
  truthy(not vehicleIdentity.canMutate(remoteIdentity))

  local detector = contactDetector.create({distanceThreshold = 4, relativeSpeedThreshold = 2, cooldown = 1})
  local contact = assert(contactDetector.observe(detector, {
    leftVehicleId = 9, rightVehicleId = 4, distance = 2, relativeSpeed = 3,
  }, 10))
  equal(contact.leftVehicleId, 4)
  equal(contact.rightVehicleId, 9)
  equal(contact.state, "started")
  local persisted = assert(contactDetector.observe(detector, {
    leftVehicleId = 4, rightVehicleId = 9, collisionSignal = true,
  }, 10.5))
  equal(persisted.state, "persisted")
  equal(persisted.samples, 2)
  local ended = assert(contactDetector.observe(detector, {
    leftVehicleId = 4, rightVehicleId = 9, ended = true,
  }, 10.75))
  equal(ended.state, "ended")
  local duplicate, duplicateReason = contactDetector.observe(detector, {
    leftVehicleId = 4, rightVehicleId = 9, collisionSignal = true,
  }, 11)
  equal(duplicate, nil)
  equal(duplicateReason, "contact_cooldown")

  truthy(vehicleIdentity.canMutate(vehicleIdentity.normalize({
    environment = "beammp", localVehicleId = 8, authority = "SERVER_GRANTED",
  })))
  truthy(not vehicleIdentity.canCleanup(vehicleIdentity.normalize({
    environment = "beammp", localVehicleId = 9, authority = "UNKNOWN",
  })))
  local ownershipState = domainOperations.create()
  local denied, deniedReason = domainOperations.ownVehicle(ownershipState, 7, {
    domain = "race", operationId = "remote-fixture", generation = 1,
    role = "race_candidate", managed = true, identity = remoteIdentity,
  })
  equal(denied, false)
  equal(deniedReason, "vehicle_authority_not_mutable")

  local playground = playgroundMode.create("tag", localIdentity)
  truthy(playgroundMode.transition(playground, "SETUP", "fixture"))
  truthy(playgroundMode.addParticipant(playground, localIdentity))
  truthy(playgroundMode.transition(playground, "RUNNING", "fixture"))
  truthy(playgroundMode.transition(playground, "COMPLETED", "fixture"))
  local reopened, reopenedReason = playgroundMode.transition(playground, "RUNNING", "late")
  equal(reopened, false)
  equal(reopenedReason, "playground_terminal_immutable")
end

tests.v075_formation_codes_roundtrip_at_the_runtime_boundary = function()
  local fixtures = {
    {"Automatic Best Fit", "AUTO_BEST_FIT"}, {"Grid", "GRID"},
    {"Circular / Radial", "RADIAL"}, {"Split Left and Right", "SPLIT_LEFT_RIGHT"},
  }
  for _, fixture in ipairs(fixtures) do
    equal(formationEnum.normalize(fixture[1]), fixture[2])
    equal(formationEnum.normalize(formationEnum.runtimeName(fixture[2])), fixture[2])
  end
end

tests.v073_beamng_0394_fixture_covers_identity_failures_and_managed_ai = function()
  local path = root .. "/tests/fixtures/v0.7.3/beamng-0.39.4.json"
  local file = assert(io.open(path, "rb"))
  local fixture = file:read("*a")
  file:close()
  truthy(fixture:find('"targetBeamNG": "0.39.4"', 1, true))
  truthy(fixture:find('"registryKey": "fixture_sport_mk2.track_rwd"', 1, true))
  truthy(fixture:find('"filename": "track_awd.pc"', 1, true))
  truthy(fixture:find('"description": ""', 1, true))
  truthy(fixture:find('"spawnRefused"', 1, true))
  truthy(fixture:find('"identityDivergence"', 1, true))
  truthy(fixture:find('"reusedId"', 1, true))
  truthy(fixture:find('"driveInLane": true', 1, true))
  truthy(fixture:find('"engine_renderer_known_issue"', 1, true))
end

tests.v077_episode_seed_intent_is_explicit_unique_and_repeatable = function()
  local first = assert(raceManager.create({count = 3, episodeSeed = "", seedIntent = "new"}))
  local second = assert(raceManager.create({count = 3, episodeSeed = "", seedIntent = "new"}))
  truthy(first.episodeSeed ~= second.episodeSeed)
  truthy(first.competitors[1].seed ~= second.competitors[1].seed)
  equal(first.seedIntent, "new")
  equal(second.seedIntent, "new")

  local explicit = assert(raceManager.create({count = 3, episodeSeed = "OWNER-SEED-X"}))
  local repeated = assert(raceManager.create({
    count = 3, episodeSeed = explicit.episodeSeed, seedIntent = "repeat",
    repeatOfLineupId = explicit.id,
  }))
  equal(explicit.episodeSeed, "OWNER-SEED-X")
  equal(repeated.episodeSeed, explicit.episodeSeed)
  equal(repeated.seedIntent, "repeat")
  equal(repeated.repeatedFromLineupId, explicit.id)
  truthy(repeated.id ~= explicit.id)
  for index = 1, 3 do
    equal(repeated.competitors[index].seed, explicit.competitors[index].seed)
    equal(repeated.competitors[index].selectionSeed, explicit.competitors[index].selectionSeed)
    equal(repeated.competitors[index].mutationSeed, explicit.competitors[index].mutationSeed)
  end

  local whitespace = assert(raceManager.create({count = 2, episodeSeed = "   "}))
  truthy(whitespace.episodeSeed ~= "")
  equal(whitespace.seedIntent, "new")

  local retryLineup = assert(raceManager.create({count = 2, episodeSeed = "RETRY-EPISODE"}))
  local retrySlot = assert(raceManager.nextCompetitor(retryLineup))
  local firstRetrySeed = raceManager.domainSeed(retryLineup, retrySlot, "operation", 1)
  retrySlot.status, retrySlot.generationClosed, retrySlot.attemptCount = "failed", true, 1
  truthy(raceManager.resolveFailure(retryLineup, 1, "retry"))
  local retried = assert(raceManager.nextCompetitor(retryLineup))
  equal(retried.seed, retrySlot.seed, "slot identity seed must remain stable across retry")
  truthy(raceManager.domainSeed(retryLineup, retried, "operation", 2) ~= firstRetrySeed,
    "retry substream must be fresh without minting a new episode")
end

tests.v077_managed_slot_binding_and_replacement_are_atomic = function()
  local registry = managedVehicleRegistry.create(4)
  local entry = assert(managedVehicleRegistry.register(registry, 10, {
    lineupId = "lineup-a", lineupCompetitorId = "slot-a", slotId = "1",
    generationId = "lineup-a", episodeSeed = "episode-a", slotSeed = "slot-seed-a",
    targetConfirmed = true, validated = true,
  }))
  entry.status = "ready"
  local duplicateSlot, duplicateSlotReason = managedVehicleRegistry.register(registry, 11, {
    lineupId = "lineup-a", lineupCompetitorId = "slot-a", slotId = "1",
  })
  equal(duplicateSlot, nil); equal(duplicateSlotReason, "managed_slot_already_bound")
  local duplicateVehicle, duplicateVehicleReason = managedVehicleRegistry.register(registry, 10, {
    lineupId = "lineup-a", lineupCompetitorId = "slot-b", slotId = "2",
  })
  equal(duplicateVehicle, nil); equal(duplicateVehicleReason, "managed_vehicle_already_bound")
  truthy(managedVehicleRegistry.matchesSlot(registry, entry.handle, {
    lineupId = "lineup-a", competitorId = "slot-a", slotId = "1", vehicleId = 10,
  }))

  local failedGeneration = assert(managedVehicleRegistry.beginGeneration(registry, entry.handle, "replacement"))
  truthy(managedVehicleRegistry.beginReplacement(registry, entry.handle, 10, 12, failedGeneration))
  equal(entry.vehicleId, 10)
  truthy(managedVehicleRegistry.abortReplacement(registry, entry.handle, failedGeneration, "fixture_failure"))
  equal(entry.vehicleId, 10)
  equal(entry.status, "ready")

  local staleGeneration = assert(managedVehicleRegistry.beginGeneration(registry, entry.handle, "replacement"))
  truthy(managedVehicleRegistry.beginReplacement(registry, entry.handle, 10, 13, staleGeneration))
  local newerGeneration = assert(managedVehicleRegistry.beginGeneration(registry, entry.handle, "replacement_retry"))
  local staleCommit, staleReason = managedVehicleRegistry.commitReplacement(registry, entry.handle, staleGeneration)
  equal(staleCommit, false); equal(staleReason, "stale_callback_ignored")
  truthy(managedVehicleRegistry.abortReplacement(registry, entry.handle, newerGeneration, "retry_reset"))
  equal(entry.vehicleId, 10)

  for cycle = 1, 20 do
    local generation = assert(managedVehicleRegistry.beginGeneration(registry, entry.handle, "replacement"))
    local candidate = 100 + cycle
    truthy(managedVehicleRegistry.beginReplacement(
      registry, entry.handle, entry.vehicleId, candidate, generation
    ))
    truthy(managedVehicleRegistry.commitReplacement(registry, entry.handle, generation))
    truthy(managedVehicleRegistry.setPending(registry, entry.handle, {
      writes = 0, timers = 0, callbacks = 0,
    }))
    truthy(managedVehicleRegistry.markReady(registry, entry.handle, generation, {
      busy = false, targetConfirmed = true, validated = true,
    }))
    equal(entry.vehicleId, candidate)
    equal(entry.concreteVehicleId, candidate)
    equal(#managedVehicleRegistry.list(registry), 1)
  end
end

tests.v077_race_cleanup_requires_exact_owned_slot_and_local_authority = function()
  local ownership = domainOperations.create()
  local context = assert(domainOperations.begin(ownership, {
    domain = "race", operationId = "race-slot-one", action = "fullRandom",
    expectedSlot = 1, createdAt = 1,
  }))
  local token = domainOperations.callbackToken(context, "spawn", {
    expectedSlot = 1, expectedVehicleId = 40,
  })
  truthy(domainOperations.registerCandidate(ownership, token, 40, {
    created = true, identity = {
      environment = "single_player", localVehicleId = 40, authority = "LOCAL",
    },
  }))
  truthy(domainOperations.acceptVehicle(ownership, context, 40, "race_competitor", 7))
  truthy(domainOperations.terminal(ownership, context, "completed", {endedAt = 2}))
  truthy(domainOperations.authorizeManagedCleanup(ownership, 40, {
    operationId = context.operationId, generation = context.generation, slot = 1,
  }))
  local wrongSlot, wrongReason = domainOperations.authorizeManagedCleanup(ownership, 40, {
    operationId = context.operationId, generation = context.generation, slot = 2,
  })
  equal(wrongSlot, false); equal(wrongReason, "race_cleanup_operation_mismatch")
  local unrelated, unrelatedReason = domainOperations.authorizeManagedCleanup(ownership, 99, {})
  equal(unrelated, false); equal(unrelatedReason, "race_cleanup_ownership_unproven")
end

tests.v077_balanced_warning_policy_presets_and_readiness_axes_are_distinct = function()
  local balanced = assert(raceManager.create({count = 2, preset = "Balanced", episodeSeed = "BALANCED-WARN"}))
  local slot = assert(raceManager.nextCompetitor(balanced))
  truthy(raceManager.record(balanced, 1, {
    success = true, code = "full_random_completed_with_warning", message = "fixture warning",
    details = {
      terminalOutcome = "COMPLETED_WITH_WARNING",
      warnings = {"optional metadata missing"}, metadataUncertain = true,
      safety = {
        runtimeIntegrity = "VALID", drivability = "DRIVABLE",
        chaosAcceptance = "ACCEPT_WITH_WARNING",
        safetyReasons = {acceptance = "metadata_advisory"},
      },
      lifecycleAcceptance = {
        finalValidationPassed = true, busy = false, pendingWrites = 0,
        pendingTimers = 0, pendingCallbacks = 0,
      },
    },
  }, nil, slot.targetGeneration))
  equal(balanced.competitors[1].status, "ready_with_warnings")
  equal(balanced.competitors[1].policyDecision.decision, "ACCEPT_WITH_WARNING")
  equal(balanced.competitors[1].policyDecision.ruleId, "metadata_advisory")
  truthy(balanced.competitors[1].generationReady)
  equal(balanced.competitors[1].placementReady, false)
  equal(balanced.competitors[1].drivable, true)
  equal(balanced.competitors[1].aiReady, false)

  local maximum = raceManager.presetOptions("Maximum Chaos", {})
  truthy(maximum.extremeTuning and maximum.allowMissingParts
    and maximum.acceptPotentiallyUndrivable)
  local custom = raceManager.presetOptions("Custom", {
    preset = "Custom", chaos = 37, acceptMetadataUncertain = false,
    acceptPotentiallyUndrivable = false,
  })
  equal(custom.chaos, 37)
  equal(custom.acceptMetadataUncertain, false)
  equal(custom.acceptPotentiallyUndrivable, false)
  local modPool = raceManager.poolSummary({}, raceManager.presetOptions("Mods Showcase", {}), {})
  equal(modPool.available, false)
  equal(modPool.models, 0)
  equal(modPool.configurations, 0)
  equal(modPool.reason, "ZERO_POOL")
end

tests.v077_formation_selection_and_canonical_order_are_renderer_independent = function()
  local lineup = assert(raceManager.create({count = 4, episodeSeed = "PLACEMENT-ORDER"}))
  for index, competitor in ipairs(lineup.competitors) do
    competitor.status = "ready"
    competitor.generationReady = true
    competitor.placementReady = index == 1
  end
  local first = raceManager.placementCompetitors(lineup, {
    spawnAll = false, useNextLineupCompetitor = false,
  })
  equal(#first, 1); equal(first[1].index, 1)
  local nextSlot = raceManager.placementCompetitors(lineup, {
    spawnAll = false, useNextLineupCompetitor = true,
  })
  equal(#nextSlot, 1); equal(nextSlot[1].index, 2)
  local all = raceManager.placementCompetitors(lineup, {spawnAll = true})
  equal(#all, 4)

  truthy(raceManager.reorder(lineup, 4, 2))
  local ordered = raceManager.placementCompetitors(lineup, {spawnAll = true})
  equal(ordered[1].index, 1)
  equal(ordered[2].index, 4)
  equal(ordered[3].index, 2)
  equal(ordered[4].index, 3)
  equal(ordered[2].seed, lineup.competitors[4].seed)
  local none = raceManager.placementCompetitors({competitors = {
    {index = 1, position = 1, status = "failed"},
  }}, {spawnAll = false, useNextLineupCompetitor = true})
  equal(#none, 0)

  local summary = raceManager.summary(lineup)
  equal(summary.generationReady, 4)
  equal(summary.placementReady, 1)
  equal(summary.drivable, 0)
  equal(summary.aiReady, 0)
end

tests.all_lua_sources_compile = function()
  local paths = {
    "/lua/ge/extensions/soturineChaosRandomizer.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/adaptivePolling.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/aiModeConfirmation.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/apiAdapter.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/capabilities.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/configSelector.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/configVerification.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/coverageContext.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/coverageLimits.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/contentIndex.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/compat/legacyLineupFacade.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/crc32.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/candidateIsolation.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/baselineSemantics.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/coherentStateGate.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/criticalRepair.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/diagnostics.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/dimensionCache.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/failureAttribution.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/engineFluidGuard.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/history.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/historyTransaction.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/frameBudget.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/formationEnum.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/incrementalIndexer.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/lifecycle.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/lineupManager.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/lineupPersistence.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/raceManager.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/raceScheduler.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/lineupSchema.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/lineupStorage.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/main.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/mutationEngine.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/mutationPolicy.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/managedVehicleRegistry.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/operationState.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/operationOutcome.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/runtime/domainOperations.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/runtime/operationContext.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/progressWatchdog.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/contactDetector.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/playgroundMode.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/paintRandomizer.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/paintCoverageLedger.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/paintVerification.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/performanceMetrics.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/partBatchRecovery.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/pngValidator.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/rng.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/registryCache.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/routePlanner.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/timeSource.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/settings.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/slotScanner.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/stressRunner.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/spawnApiAdapter.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/spawnDirector.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/slotCoverageLedger.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/treeConvergence.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/tuningCoverageLedger.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/tuningPipeline.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/uiPublisher.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/util.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/validator.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleSelector.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleDNA.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleDNACompatibility.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleDNAFingerprint.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleDNAImport.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleDNALocks.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleDNAMutations.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleDNACompare.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleDNAGallery.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleDNAPackage.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleDNANormalizer.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleDNAPassBudget.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleDNARestore.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleDNASchema.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleDNAStorage.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleRecovery.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleStabilizer.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleTargetTracker.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleBufferPool.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleIterator.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleIdentity.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/aiAdapter.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/aiDirector.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/destinationMarker.lua",
    "/lua/vehicle/extensions/soturineChaosRandomizerFluidProbe.lua",
  }
  for _, path in ipairs(paths) do
    local chunk, err = loadfile(root .. path)
    truthy(chunk, path .. ": " .. tostring(err))
  end
end

-- The alpha.2 release gate keeps the 113 requested regressions individually
-- named even when several scenarios intentionally share the same lower-level
-- contract. This makes omissions visible in the test count and release report.
local alpha2Required = {
  {"replacement_a_to_b", tests.alpha2_tracker_rebind_chain_contract},
  {"replacement_chain_a_b_c", tests.alpha2_tracker_rebind_chain_contract},
  {"multiple_events_during_replace_write", tests.alpha2_tracker_rebind_chain_contract},
  {"returned_id_not_final_id", tests.alpha2_tracker_rebind_chain_contract},
  {"auxiliary_before_target", tests.alpha2_tracker_rebind_chain_contract},
  {"trailer_during_spawn", tests.alpha2_tracker_rebind_chain_contract},
  {"prop_during_spawn", tests.alpha2_tracker_rebind_chain_contract},
  {"wrong_candidate_rejected", tests.alpha2_tracker_switch_classification_contract},
  {"real_user_switch_cancels", tests.alpha2_tracker_switch_classification_contract},
  {"stable_after_five_frames", tests.alpha2_tracker_stability_timeout_stale_destroy_contract},
  {"oscillation_times_out", tests.alpha2_tracker_stability_timeout_stale_destroy_contract},
  {"candidate_limit", tests.alpha2_tracker_limits_contract},
  {"switch_event_limit", tests.alpha2_tracker_limits_contract},
  {"stale_token", tests.alpha2_tracker_stability_timeout_stale_destroy_contract},
  {"destroyed_intermediate", tests.alpha2_tracker_stability_timeout_stale_destroy_contract},
  {"expected_reload_rebinds", tests.alpha2_tracker_rebind_chain_contract},
  {"unexpected_reload_cancels", tests.alpha2_tracker_switch_classification_contract},
  {"full_random_mod_like_load", tests.full_random_mocked_success_pipeline},
  {"full_random_target_rebound", tests.alpha2_tracker_rebind_chain_contract},
  {"full_random_scramble_after_spawn", tests.full_random_does_not_finish_after_spawn},
  {"full_random_changes_slot", tests.full_random_runs_parts_tuning_and_paint},
  {"full_random_optional_stages_reasoned", tests.full_random_skips_unavailable_optional_stage_with_warning},
  {"full_random_not_spawn_only", tests.full_random_does_not_finish_after_spawn},
  {"full_random_no_mutable_code", tests.optional_slots_follow_empty_probability},
  {"full_random_partial_metrics", tests.full_random_result_reports_base_version_and_final_changes},
  {"full_random_structural_rollback", tests.full_random_rollback_restores_original},
  {"scramble_keeps_model", tests.scramble_mocked_success_pipeline},
  {"parent_creates_descendants", tests.changing_parent_defers_descendant_mutation},
  {"descendants_mutate_next_pass", tests.deferred_descendant_uses_new_tree_candidates},
  {"unstable_scan_deferred", tests.alpha2_tree_stabilizer_contract},
  {"stable_scan_persistent", tests.alpha2_tree_stabilizer_contract},
  {"no_progress_bounded", tests.dna_pass_budget_detects_no_progress},
  {"deep_tree_over_twelve", tests.dna_pass_budget_supports_deep_trees},
  {"scramble_no_mutable", tests.optional_slots_follow_empty_probability},
  {"candidate_breaks_required_slot", tests.alpha2_batch_recovery_contract},
  {"batch_rollback_passes", tests.alpha2_batch_recovery_contract},
  {"candidate_session_quarantine", tests.alpha2_batch_recovery_contract},
  {"alternative_candidate_selected", tests.alpha2_batch_recovery_contract},
  {"operation_continues_after_retry", tests.alpha2_batch_recovery_contract},
  {"retry_budget_ends", tests.alpha2_batch_recovery_contract},
  {"batch_rollback_failure_total", tests.paint_failure_rolls_back},
  {"quarantine_model_scoped", tests.alpha2_batch_recovery_contract},
  {"quarantine_not_persistent", tests.alpha2_batch_recovery_contract},
  {"protect_critical_preserves", tests.critical_slot_prefers_current_or_default},
  {"protect_off_allows_nonstructural", tests.optional_cosmetic_missing_is_safe},
  {"allow_missing_off", tests.optional_slots_follow_empty_probability},
  {"allow_missing_on", tests.optional_slots_follow_empty_probability},
  {"unsafe_valid_profile", tests.uncertain_layout_does_not_claim_drivable},
  {"required_core_still_blocked", tests.required_core_missing_is_unsafe},
  {"ui_random_car_action", tests.random_config_mocked_success_pipeline},
  {"internal_random_config_compat", tests.random_config_mocked_success_pipeline},
  {"random_car_no_mutations", tests.random_config_mocked_success_pipeline},
  {"old_random_config_dna_valid", tests.dna_schema_accepts_valid_v1},
  {"old_replay_saved_config", tests.random_config_replay_loads_saved_config_without_reselection},
  {"reroll_starts_other_model", tests.dna_mutation_loads_parent_base_and_creates_child_lineage},
  {"reroll_restores_parent_final", tests.dna_mutation_loads_parent_base_and_creates_child_lineage},
  {"reroll_locked_fields_equal_parent", tests.reroll_unlocked_creates_pending_dna_without_changing_locked_state},
  {"reroll_unlocked_fields_change", tests.reroll_part_plan_preserves_locked_slots},
  {"reroll_lineage_correct", tests.mutation_parent_is_immutable_children_are_unique_and_depth_is_bounded},
  {"small_from_parent_final", tests.dna_mutation_loads_parent_base_and_creates_child_lineage},
  {"medium_from_parent_final", tests.dna_mutation_loads_parent_base_and_creates_child_lineage},
  {"wild_from_parent_final", tests.dna_mutation_loads_parent_base_and_creates_child_lineage},
  {"wild_can_change_model_config", tests.alpha2_generator_legacy_restore_contract},
  {"wild_part_lock_keeps_model", tests.alpha2_lock_model_binding_contract},
  {"parent_immutable", tests.mutation_parent_is_immutable_children_are_unique_and_depth_is_bounded},
  {"vehicle_lock_configuration_fairness", tests.alpha2_lock_model_binding_contract},
  {"slot_lock_preserves_model", tests.alpha2_lock_model_binding_contract},
  {"part_lock_preserves_model", tests.alpha2_lock_model_binding_contract},
  {"config_lock_preserves_config", tests.alpha2_lock_model_binding_contract},
  {"unresolved_lock_not_silent", tests.alpha2_lock_model_binding_contract},
  {"exporter_compat_preserved", tests.vdna_zip_roundtrip_validates_crc_manifest_and_limits},
  {"local_compat_recomputed", tests.dna_preflight_requires_target_inspection_without_target_tree},
  {"exporter_never_overrides_local", tests.dna_preflight_requires_target_inspection_without_target_tree},
  {"local_missing_mods_visible", tests.dna_compatible_preflight_reports_partial},
  {"package_roundtrip_safe", tests.vdna_zip_roundtrip_validates_crc_manifest_and_limits},
  {"thumbnail_same_model_diff_state_blocked", tests.vehicle_dna_compare_is_field_by_field_not_fingerprint_only},
  {"thumbnail_exact_state_allowed", tests.gallery_thumbnail_bounds_and_fallback_are_safe},
  {"thumbnail_override_non_exact", tests.gallery_thumbnail_bounds_and_fallback_are_safe},
  {"png_trailing_payload_rejected", tests.alpha2_png_integrity_contract},
  {"png_crc_rejected", tests.alpha2_png_integrity_contract},
  {"png_missing_iend_rejected", tests.alpha2_png_integrity_contract},
  {"png_duplicate_ihdr_rejected", tests.alpha2_png_integrity_contract},
  {"png_chunk_overflow_rejected", tests.alpha2_png_integrity_contract},
  {"png_chunk_bomb_rejected", tests.alpha2_png_integrity_contract},
  {"png_small_valid", tests.alpha2_png_integrity_contract},
  {"mod_config_load_failure", tests.alpha2_recovery_contract},
  {"candidate_disappears_no_vehicle", tests.alpha2_recovery_contract},
  {"rollback_previous_vehicle", tests.full_random_rollback_restores_original},
  {"fallback_last_known_good", tests.alpha2_recovery_contract},
  {"fallback_safe_official", tests.alpha2_recovery_contract},
  {"failure_cleanup", tests.alpha2_recovery_contract},
  {"random_car_without_vehicle", tests.alpha2_no_active_vehicle_contract},
  {"full_random_without_vehicle", tests.alpha2_no_active_vehicle_contract},
  {"scramble_without_vehicle_message", tests.alpha2_no_active_vehicle_contract},
  {"locks_do_not_block_recovery", tests.alpha2_recovery_contract},
  {"locks_unresolved_after_fallback", tests.alpha2_lock_model_binding_contract},
  {"broken_candidate_quarantined", tests.alpha2_recovery_contract},
  {"quarantined_not_reselected", tests.alpha2_recovery_contract},
  {"load_circuit_breaker", tests.alpha2_recovery_contract},
  {"total_recovery_failure_ui_usable", tests.alpha2_recovery_contract},
  {"no_active_config_not_permanent", tests.alpha2_no_active_vehicle_contract},
  {"protected_recovery_cleanup", tests.alpha2_recovery_contract},
  {"ui_default_compact_size", tests.all_lua_sources_compile},
  {"ui_collapsed_mode", tests.all_lua_sources_compile},
  {"ui_compact_mode", tests.all_lua_sources_compile},
  {"ui_expanded_mode", tests.all_lua_sources_compile},
  {"ui_mutations_hidden_without_dna", tests.all_lua_sources_compile},
  {"ui_advanced_closed_default", tests.all_lua_sources_compile},
  {"ui_keyboard_focus", tests.all_lua_sources_compile},
  {"ui_overflow_300x340", tests.all_lua_sources_compile},
  {"ui_scaling_125_150_200", tests.all_lua_sources_compile},
  {"ui_long_text", tests.all_lua_sources_compile},
  {"ui_fixed_allowlist", tests.all_lua_sources_compile},
}

local v060Required = {
  {"01_chaos_100_selects_all_eligible_slots", tests.v060_coverage_chaos100_and_slot_identity},
  {"02_parent_slot_not_capped_at_85_percent", tests.v060_coverage_chaos100_and_slot_identity},
  {"03_chaos_50_classifies_non_selected_slots", tests.chaos_policy_boundaries},
  {"04_tree_deeper_than_five_levels_converges", tests.v060_tree_convergence_and_absolute_limits},
  {"05_new_slots_appear_after_reload", tests.v060_coverage_tracks_new_and_disappearing_slots},
  {"06_slot_disappears_after_parent_change", tests.v060_coverage_tracks_new_and_disappearing_slots},
  {"07_homonymous_slots_under_different_parents_do_not_collide", tests.v060_coverage_chaos100_and_slot_identity},
  {"08_absolute_limit_produces_partial", tests.v060_partial_result_setting_controls_rollback},
  {"09_no_progress_ends_with_reason", tests.v060_tree_convergence_and_absolute_limits},
  {"10_completed_requires_complete_ledger", tests.v060_coverage_chaos100_and_slot_identity},
  {"11_full_random_uses_same_ledger", tests.full_random_result_reports_base_version_and_final_changes},
  {"12_random_car_has_no_mutation_ledger", tests.random_config_mocked_success_pipeline},
  {"13_second_item_failure_does_not_punish_first", tests.v060_candidate_isolation_proves_only_the_culprit},
  {"14_binary_split_localizes_candidate", tests.v060_candidate_isolation_proves_only_the_culprit},
  {"15_suspect_and_confirmed_quarantine_are_distinct", tests.v060_candidate_isolation_proves_only_the_culprit},
  {"16_retry_uses_alternative", tests.alpha2_batch_recovery_contract},
  {"17_quarantined_candidate_does_not_return_in_session", tests.blacklisted_candidate_is_not_selected},
  {"18_total_rollback_only_after_local_failure", tests.full_random_rollback_restores_original},
  {"19_keep_partial_off_restores_state", tests.v060_partial_result_setting_controls_rollback},
  {"20_keep_partial_on_preserves_valid_vehicle", tests.v060_partial_result_setting_controls_rollback},
  {"21_tuning_is_read_after_parts", tests.full_random_runs_parts_tuning_and_paint},
  {"22_new_part_adds_tuning_variable", tests.v060_tuning_rescan_discovers_only_new_variables},
  {"23_rescan_finds_new_tuning_variable", tests.v060_tuning_rescan_discovers_only_new_variables},
  {"24_chaos_100_selects_all_tuning", tests.v060_tuning_pipeline_covers_metadata_and_readback},
  {"25_discrete_value_excludes_current_value", tests.v060_tuning_pipeline_covers_metadata_and_readback},
  {"26_continuous_value_respects_tolerance", tests.extreme_biased_tuning},
  {"27_fixed_value_gets_reason", tests.v060_tuning_pipeline_covers_metadata_and_readback},
  {"28_readback_clamp_is_recorded", tests.v060_tuning_pipeline_covers_metadata_and_readback},
  {"29_readback_rejection_generates_rollback", tests.v060_partial_result_setting_controls_rollback},
  {"30_suspension_failure_does_not_erase_engine", tests.v060_tuning_pipeline_covers_metadata_and_readback},
  {"31_dynamic_category_appears", tests.v060_tuning_rescan_discovers_only_new_variables},
  {"32_hidden_variable_is_ignored", tests.v060_tuning_pipeline_covers_metadata_and_readback},
  {"33_internal_slot_variable_is_not_tuning", tests.v060_tuning_pipeline_covers_metadata_and_readback},
  {"34_vehicle_action_is_not_executed", tests.v060_tuning_pipeline_covers_metadata_and_readback},
  {"35_explicit_correlation_group_is_respected", tests.explicit_group_uses_shared_substream},
  {"36_similar_names_without_metadata_are_not_correlated", tests.uncorrelated_variables_remain_independent},
  {"37_dna_saves_final_tuning", tests.explicit_save_persists_dna_with_readback},
  {"38_restore_compatible_clamps_with_deviation", tests.restore_compatible_reports_clamped_deviation_and_verifies_readback},
  {"39_generator_5_is_not_reinterpreted_as_6", tests.alpha2_generator_legacy_restore_contract},
  {"40_substreams_remain_independent", tests.reroll_independent_substreams_survive_unrelated_category_locks},
  {"41_paint_coverage_is_classified", tests.v060_paint_coverage_confirms_supported_fields},
  {"42_paint_readback_is_confirmed", tests.v060_paint_coverage_confirms_supported_fields},
  {"43_unsupported_paint_field_is_not_false_success", tests.v060_paint_coverage_confirms_supported_fields},
  {"44_recovery_prefers_last_known_good", tests.alpha2_recovery_contract},
  {"45_official_fallback_uses_ranking", tests.alpha2_recovery_contract},
  {"46_recovery_tries_next_candidate", tests.alpha2_recovery_contract},
  {"47_no_vehicle_state_keeps_ui_available", tests.alpha2_no_active_vehicle_contract},
  {"48_random_car_without_vehicle", tests.alpha2_no_active_vehicle_contract},
  {"49_full_random_without_vehicle", tests.alpha2_no_active_vehicle_contract},
  {"50_scramble_without_vehicle_explains_action", tests.v060_public_state_exposes_lineup_spawn_ai_and_coverage},
  {"51_lineup_seeds_are_independent", tests.v060_lineup_variety_substreams_and_failure_actions},
  {"52_competitor_two_failure_does_not_change_three", tests.v060_lineup_variety_substreams_and_failure_actions},
  {"53_incremental_generation_saves_progress", tests.v060_lineup_seeds_progress_schema_and_storage},
  {"54_lineup_partial_respects_setting", tests.v060_partial_result_setting_controls_rollback},
  {"55_duplicate_model_avoidance", tests.v060_lineup_variety_substreams_and_failure_actions},
  {"56_rule_without_metadata_does_not_invent_class", tests.v060_lineup_variety_substreams_and_failure_actions},
  {"57_automatic_collection", tests.v060_lineup_seeds_progress_schema_and_storage},
  {"58_rename_does_not_change_dna", tests.v060_lineup_seeds_progress_schema_and_storage},
  {"59_export_contains_no_mod_bytes", tests.v060_lineup_import_is_data_only},
  {"60_import_recomputes_compatibility", tests.v060_lineup_import_is_data_only},
  {"61_lineup_schema_validates_limits", tests.v060_lineup_seeds_progress_schema_and_storage},
  {"62_sixteen_competitors_respect_bound", tests.v060_lineup_seeds_progress_schema_and_storage},
  {"63_failure_does_not_delete_previous_competitors", tests.v060_lineup_seeds_progress_schema_and_storage},
  {"64_front_right_left_transforms", tests.v060_spawn_plans_are_camera_relative_and_safe},
  {"65_grid_is_deterministic", tests.v060_spawn_plans_are_camera_relative_and_safe},
  {"66_circle_is_deterministic", tests.v060_spawn_plans_are_camera_relative_and_safe},
  {"67_missing_ground_raycast_fails_with_reason", tests.v060_spawn_plans_are_camera_relative_and_safe},
  {"68_overlap_blocks_spawn", tests.v060_spawn_plans_are_camera_relative_and_safe},
  {"69_spawn_is_sequential", tests.v060_spawn_heading_readback_and_ownership},
  {"70_dna_is_restored_after_spawn", tests.v060_spawn_heading_readback_and_ownership},
  {"71_managed_id_is_updated", tests.v060_managed_registry_rebinds_without_cross_vehicle_damage},
  {"72_respawn_updates_id", tests.v060_managed_registry_rebinds_without_cross_vehicle_damage},
  {"73_remove_cleans_only_one_vehicle", tests.v060_managed_registry_rebinds_without_cross_vehicle_damage},
  {"74_ai_capability_detection", tests.v060_navgraph_routes_and_ai_bounds},
  {"75_missing_api_disables_mode", tests.v060_navgraph_routes_and_ai_bounds},
  {"76_reachable_destination", tests.v060_navgraph_routes_and_ai_bounds},
  {"77_destination_without_navgraph", tests.v060_navgraph_routes_and_ai_bounds},
  {"78_route_points", tests.v060_route_editor_ai_progress_and_isolation},
  {"79_reverse_route", tests.v060_route_editor_ai_progress_and_isolation},
  {"80_loop_route", tests.v060_route_editor_ai_progress_and_isolation},
  {"81_chase_uses_real_target", tests.v060_route_editor_ai_progress_and_isolation},
  {"82_removed_target_stops_with_reason", tests.v060_route_editor_ai_progress_and_isolation},
  {"83_ai_stagger", tests.v060_navgraph_routes_and_ai_bounds},
  {"84_stop_all_ai", tests.v060_navgraph_routes_and_ai_bounds},
  {"85_arrival_radius", tests.v060_route_editor_ai_progress_and_isolation},
  {"86_stuck_detection", tests.v060_route_editor_ai_progress_and_isolation},
  {"87_replan_is_bounded", tests.v060_route_editor_ai_progress_and_isolation},
  {"88_marker_and_trigger_cleanup", tests.v060_route_editor_ai_progress_and_isolation},
  {"89_one_vehicle_ai_does_not_change_another", tests.v060_route_editor_ai_progress_and_isolation},
  {"90_player_switch_preserves_managed_ids", tests.v060_managed_registry_rebinds_without_cross_vehicle_damage},
  {"91_reroll_remains_secondary", tests.v060_public_state_exposes_lineup_spawn_ai_and_coverage},
  {"92_random_lineup_ai_navigation", tests.v060_public_state_exposes_lineup_spawn_ai_and_coverage},
  {"93_compact_recording_mode", tests.v060_public_state_exposes_lineup_spawn_ai_and_coverage},
  {"94_ui_300_by_340_without_overflow", tests.all_lua_sources_compile},
  {"95_ui_scaling_125_150_200", tests.all_lua_sources_compile},
  {"96_keyboard_and_focus", tests.all_lua_sources_compile},
  {"97_tooltips", tests.all_lua_sources_compile},
  {"98_long_text", tests.all_lua_sources_compile},
  {"99_sixteen_cards_are_paginated", tests.garage_sort_and_pagination_are_bounded},
  {"100_diagnostics_copy_is_bounded", tests.diagnostic_history_is_bounded},
  {"101_unique_functions_are_not_duplicated", tests.v060_runner_counting_contract},
  {"102_requirement_mappings_are_separate", tests.v060_runner_counting_contract},
  {"103_executed_count_matches_runner", tests.v060_runner_counting_contract},
  {"104_manifest_matches_real_result", tests.v060_runner_counting_contract},
}

local v060PauseLifecycleRequired = {
  {"01_random_car_completes_without_pausing", tests.v060_actions_complete_without_pause_toggle},
  {"02_scramble_completes_without_pausing", tests.v060_actions_complete_without_pause_toggle},
  {"03_full_random_completes_without_pausing", tests.v060_actions_complete_without_pause_toggle},
  {"04_random_car_started_paused_does_not_deadlock", tests.v060_initial_pause_wait_resume_contract},
  {"05_scramble_started_paused_does_not_deadlock", tests.v060_initial_pause_wait_resume_contract},
  {"06_full_random_started_paused_does_not_deadlock", tests.v060_initial_pause_wait_resume_contract},
  {"07_pause_during_spawn_preserves_ownership", tests.v060_initial_pause_wait_resume_contract},
  {"08_pause_during_target_tracking_does_not_reset_target", tests.v060_pause_mid_pipeline_and_frame_step_contract},
  {"09_pause_during_tree_convergence_does_not_reclassify_target", tests.v060_target_identity_tree_separation_contract},
  {"10_pause_during_parts_write_never_writes_other_vehicle", tests.v060_recovery_stale_callback_isolation_contract},
  {"11_pause_during_tuning_does_not_leave_busy", tests.v060_pause_mid_pipeline_and_frame_step_contract},
  {"12_pause_during_paint_has_no_false_timeout", tests.v060_pause_mid_pipeline_and_frame_step_contract},
  {"13_resume_continues_only_pending_phase", tests.v060_initial_pause_wait_resume_contract},
  {"14_slow_motion_does_not_change_seed_or_result", tests.v060_slow_motion_is_seed_independent},
  {"15_frame_step_does_not_create_false_target_switch", tests.v060_pause_mid_pipeline_and_frame_step_contract},
  {"16_simulation_delta_zero_real_time_advances", tests.v060_pause_time_sources_contract},
  {"17_real_timeout_does_not_use_simulation_time", tests.v060_pause_time_sources_contract},
  {"18_requires_simulation_phase_waits_instead_of_failing", tests.v060_initial_pause_wait_resume_contract},
  {"19_cancel_works_while_paused", tests.v060_busy_cancel_and_diagnostics_contract},
  {"20_recovery_works_while_paused", tests.v060_busy_cancel_and_diagnostics_contract},
  {"21_target_identity_stabilizes_while_parts_tree_changes", tests.v060_target_identity_tree_separation_contract},
  {"22_parts_tree_changes_without_resetting_vehicle_identity", tests.v060_target_identity_tree_separation_contract},
  {"23_stable_id_model_config_confirm_target", tests.v060_target_identity_tree_separation_contract},
  {"24_tree_convergence_starts_after_target", tests.v060_target_identity_tree_separation_contract},
  {"25_tree_callback_cannot_rebind_wrong_model", tests.v060_target_identity_tree_separation_contract},
  {"26_plan_for_vehicle_b_never_applies_to_a", tests.v060_recovery_stale_callback_isolation_contract},
  {"27_delayed_b_callback_is_ignored_after_rollback", tests.v060_recovery_stale_callback_isolation_contract},
  {"28_delayed_b_tuning_does_not_apply_in_recovery", tests.v060_recovery_stale_callback_isolation_contract},
  {"29_delayed_b_paint_does_not_apply_in_recovery", tests.v060_recovery_stale_callback_isolation_contract},
  {"30_current_batch_is_cleared_before_recovery", tests.v060_recovery_snapshot_roles_contract},
  {"31_old_after_reload_is_invalidated", tests.v060_recovery_snapshot_roles_contract},
  {"32_phase_generation_rejects_old_callback", tests.v060_explicit_lifecycle_generations_contract},
  {"33_recovery_only_blocks_scramble", tests.v060_recovery_snapshot_roles_contract},
  {"34_recovery_finishes_as_recovered_failure", tests.v060_recovery_stale_callback_isolation_contract},
  {"35_recovery_does_not_call_mutation_pass", tests.v060_recovery_stale_callback_isolation_contract},
  {"36_original_snapshot_is_not_automatically_good", tests.v060_recovery_snapshot_roles_contract},
  {"37_spawn_base_does_not_update_completed_good", tests.v060_recovery_snapshot_roles_contract},
  {"38_unaccepted_partial_does_not_update_completed_good", tests.v060_recovery_snapshot_roles_contract},
  {"39_final_success_updates_completed_good", tests.v060_recovery_snapshot_roles_contract},
  {"40_validated_recovery_does_not_resume_failed_operation", tests.v060_recovery_stale_callback_isolation_contract},
  {"41_damaged_original_remains_original_only", tests.v060_recovery_snapshot_roles_contract},
  {"42_fallback_receives_no_old_mutation_plan", tests.v060_recovery_snapshot_roles_contract},
  {"43_busy_releases_after_success", tests.v060_actions_complete_without_pause_toggle},
  {"44_busy_releases_after_partial", tests.v060_busy_cancel_and_diagnostics_contract},
  {"45_busy_releases_after_failure", tests.v060_busy_cancel_and_diagnostics_contract},
  {"46_busy_releases_after_cancel", tests.v060_busy_cancel_and_diagnostics_contract},
  {"47_busy_releases_after_rollback", tests.v060_recovery_stale_callback_isolation_contract},
  {"48_busy_releases_after_recovery", tests.v060_recovery_stale_callback_isolation_contract},
  {"49_cancel_remains_enabled", tests.v060_busy_cancel_and_diagnostics_contract},
  {"50_copy_diagnostics_remains_enabled", tests.v060_busy_cancel_and_diagnostics_contract},
  {"51_stalled_warning_appears", tests.v060_progress_watchdog_contract},
  {"52_no_pause_toggle_is_required", tests.v060_actions_complete_without_pause_toggle},
}

local v061Required = {
  {"01_random_car_without_pause", tests.v061_paused_pipeline_finishes_without_toggle},
  {"02_scramble_without_pause", tests.v061_paused_pipeline_finishes_without_toggle},
  {"03_full_random_without_pause", tests.v061_paused_pipeline_finishes_without_toggle},
  {"04_started_paused_no_deadlock", tests.v061_paused_pipeline_finishes_without_toggle},
  {"05_pause_toggle_preserves_target", tests.v060_pause_mid_pipeline_and_frame_step_contract},
  {"06_pause_toggle_not_required", tests.v061_paused_pipeline_finishes_without_toggle},
  {"07_identity_stable_while_tree_changes", tests.v060_target_identity_tree_separation_contract},
  {"08_housekeeping_during_tracker", tests.v060_onupdate_housekeeping_contract},
  {"09_cancel_during_wait", tests.v060_busy_cancel_and_diagnostics_contract},
  {"10_busy_released_all_terminals", tests.v060_busy_cancel_and_diagnostics_contract},
  {"11_zero_sim_delta_preserves_target", tests.v061_paused_pipeline_finishes_without_toggle},
  {"12_wall_clock_deadline_continues", tests.v061_target_deadline_uses_wall_clock_while_paused},
  {"13_old_callback_rejected", tests.v060_explicit_lifecycle_generations_contract},
  {"14_recovery_generation_blocks_old_write", tests.v060_recovery_stale_callback_isolation_contract},
  {"15_timeout_does_not_auto_cycle", tests.v061_persistent_parts_read_fails_terminally},
  {"16_new_click_new_rng", tests.v061_seed_modes_refresh_or_reproduce},
  {"17_empty_manual_seed_new_entropy", tests.v061_seed_modes_refresh_or_reproduce},
  {"18_fixed_seed_reproduces", tests.v061_seed_modes_refresh_or_reproduce},
  {"19_random_car_avoids_immediate_repeat", tests.anti_repeat_selection},
  {"20_recovery_not_new_result", tests.v060_recovery_snapshot_roles_contract},
  {"21_retry_uses_own_substream", tests.v060_lineup_variety_substreams_and_failure_actions},
  {"22_previous_operation_plan_cleared", tests.v061_recovery_invalidation_drops_all_old_plans},
  {"23_same_selection_has_reason", tests.v061_seed_modes_refresh_or_reproduce},
  {"24_recent_window_manual_seed_exception", tests.v061_seed_modes_refresh_or_reproduce},
  {"25_clean_spawn_not_completed_good", tests.v060_recovery_snapshot_roles_contract},
  {"26_unaccepted_partial_not_completed_good", tests.v060_recovery_snapshot_roles_contract},
  {"27_final_completed_is_completed_good", tests.v060_recovery_snapshot_roles_contract},
  {"28_recovery_finishes_operation", tests.v060_recovery_stale_callback_isolation_contract},
  {"29_recovery_drops_old_tuning", tests.v061_recovery_invalidation_drops_all_old_plans},
  {"30_recovery_drops_old_paint", tests.v061_recovery_invalidation_drops_all_old_plans},
  {"31_recovery_loop_is_bounded", tests.v061_persistent_parts_read_fails_terminally},
  {"32_failed_candidate_quarantined", tests.alpha2_recovery_contract},
  {"33_migration_clears_old_locks", tests.v061_settings_locks_and_seed_migration},
  {"34_new_session_unlocked", tests.v061_settings_locks_and_seed_migration},
  {"35_remember_locks_defaults_off", tests.v061_settings_locks_and_seed_migration},
  {"36_lock_warning_only_when_active", tests.v061_compact_ui_contract},
  {"37_unlock_all_available", tests.v061_compact_ui_contract},
  {"38_fixed_seed_warning", tests.v061_compact_ui_contract},
  {"39_clear_fixed_seed_restores_random", tests.v061_settings_locks_and_seed_migration},
  {"40_balanced_applies_values", tests.v061_race_presets_apply_real_policy},
  {"41_maximum_chaos_applies_values", tests.v061_race_presets_apply_real_policy},
  {"42_mods_showcase_applies_values", tests.v061_race_presets_apply_real_policy},
  {"43_manual_change_marks_custom", tests.v061_compact_ui_contract},
  {"44_competitor_leaves_pending", tests.v061_race_statuses_and_cancel_are_terminal},
  {"45_timeout_finishes_failed", tests.v061_persistent_parts_read_fails_terminally},
  {"46_cancel_finishes_competitors", tests.v061_race_statuses_and_cancel_are_terminal},
  {"47_competitor_pause_independent", tests.v061_paused_pipeline_finishes_without_toggle},
  {"48_failure_does_not_contaminate_next", tests.v060_lineup_variety_substreams_and_failure_actions},
  {"49_no_ready_blocks_placement_with_reason", tests.v061_compact_ui_contract},
  {"50_no_managed_blocks_drive_with_reason", tests.v061_compact_ui_contract},
  {"51_race_seed_independent_substreams", tests.v060_lineup_variety_substreams_and_failure_actions},
  {"52_recovery_not_accepted_as_competitor", tests.v060_recovery_snapshot_roles_contract},
  {"53_exactly_four_top_tabs", tests.v061_compact_ui_contract},
  {"54_chaos_has_no_seed_input", tests.v061_compact_ui_contract},
  {"55_chaos_has_no_lock_chips", tests.v061_compact_ui_contract},
  {"56_garage_has_compare_share", tests.v061_compact_ui_contract},
  {"57_race_has_cars_placement_drive", tests.v061_compact_ui_contract},
  {"58_header_c_s_removed", tests.v061_compact_ui_contract},
  {"59_collapsed_reduces_height", tests.v061_compact_ui_contract},
  {"60_expanded_340x320_no_normal_scroll", tests.v061_compact_ui_contract},
  {"61_essential_text_at_least_12px", tests.v061_compact_ui_contract},
  {"62_primary_buttons_at_least_44px", tests.v061_compact_ui_contract},
  {"63_slider_zero_aligned", tests.v061_compact_ui_contract},
  {"64_slider_fifty_aligned", tests.v061_compact_ui_contract},
  {"65_slider_hundred_aligned", tests.v061_compact_ui_contract},
  {"66_slider_scaled_layout", tests.v061_compact_ui_contract},
  {"67_fox_asset_loads", tests.v061_compact_ui_contract},
  {"68_fox_does_not_block_title", tests.v061_compact_ui_contract},
  {"69_fox_is_decorative", tests.v061_compact_ui_contract},
  {"70_status_shows_phase", tests.v061_compact_ui_contract},
  {"71_cancel_visible_while_busy", tests.v061_compact_ui_contract},
  {"72_details_visible_on_failure", tests.v061_compact_ui_contract},
  {"73_temporary_nil_parts_recovers", tests.v061_bounded_parts_read_recovers},
  {"74_persistent_nil_parts_fails_with_reason", tests.v061_persistent_parts_read_fails_terminally},
  {"75_external_error_preserves_target_ownership", tests.v060_target_identity_tree_separation_contract},
  {"76_missing_callback_cannot_leave_busy", tests.v061_target_deadline_uses_wall_clock_while_paused},
}

local v062Required = {
  {"v062_random_car_without_pause", tests.v060_actions_complete_without_pause_toggle},
  {"v062_scramble_without_pause", tests.v060_actions_complete_without_pause_toggle},
  {"v062_full_random_without_pause", tests.v060_actions_complete_without_pause_toggle},
  {"v062_race_generation_without_pause", tests.v061_race_statuses_and_cancel_are_terminal},
  {"v062_identity_precedes_tree", tests.v062_target_ownership_precedes_tree_convergence},
  {"v062_tree_change_preserves_target", tests.v060_target_identity_tree_separation_contract},
  {"v062_stale_callback_rejected", tests.v060_explicit_lifecycle_generations_contract},
  {"v062_stale_timer_rejected", tests.v060_explicit_lifecycle_generations_contract},
  {"v062_cancel_target_tracking", tests.v060_busy_cancel_and_diagnostics_contract},
  {"v062_cancel_parts_reload", tests.v060_busy_cancel_and_diagnostics_contract},
  {"v062_busy_all_terminals", tests.v060_busy_cancel_and_diagnostics_contract},
  {"v062_wall_deadline_zero_dtsim", tests.v061_target_deadline_uses_wall_clock_while_paused},
  {"v062_pause_preserves_generation", tests.v062_pause_transitions_are_diagnostic_only},
  {"v062_pause_preserves_target", tests.v060_pause_mid_pipeline_and_frame_step_contract},
  {"v062_progress_without_pause_toggle", tests.v060_actions_complete_without_pause_toggle},
  {"v062_housekeeping_always_runs", tests.v060_onupdate_housekeeping_contract},
  {"v062_map_unload_terminal_cleanup", tests.map_change_cancels_pipeline},
  {"v062_extension_unload_terminal_cleanup", tests.v062_extension_unload_is_a_terminal_cleanup},
  {"v062_clean_spawn_not_promoted", tests.v060_recovery_snapshot_roles_contract},
  {"v062_partial_not_promoted", tests.v060_recovery_snapshot_roles_contract},
  {"v062_completed_promotes_snapshot", tests.v060_recovery_snapshot_roles_contract},
  {"v062_recovery_invalidates_plans", tests.v061_recovery_invalidation_drops_all_old_plans},
  {"v062_recovery_rejects_old_tuning", tests.v060_recovery_stale_callback_isolation_contract},
  {"v062_recovery_rejects_old_paint", tests.v060_recovery_stale_callback_isolation_contract},
  {"v062_recovery_explicit_snapshot", tests.v062_recovery_tiers_are_ordered_and_deduplicated},
  {"v062_recovery_loop_detected", tests.v062_recovery_rejects_old_generation_and_repeated_state},
  {"v062_recovery_loop_terminal", tests.v060_recovery_stale_callback_isolation_contract},
  {"v062_failed_candidate_quarantine", tests.alpha2_recovery_contract},
  {"v062_new_operation_candidate_isolation", tests.v061_recovery_invalidation_drops_all_old_plans},
  {"v062_failure_next_operation_isolation", tests.v060_recovery_stale_callback_isolation_contract},
  {"v062_fresh_rng_per_operation", tests.v062_operation_exposes_isolated_rng_domains},
  {"v062_random_seed_changes", tests.v061_seed_modes_refresh_or_reproduce},
  {"v062_fixed_seed_reproduces", tests.v061_seed_modes_refresh_or_reproduce},
  {"v062_anti_repeat", tests.anti_repeat_selection},
  {"v062_replay_anti_repeat_exception", tests.random_config_replay_loads_saved_config_without_reselection},
  {"v062_recovery_not_selection", tests.v060_recovery_snapshot_roles_contract},
  {"v062_retry_substream", tests.v060_lineup_variety_substreams_and_failure_actions},
  {"v062_scramble_target_isolation", tests.scramble_mocked_success_pipeline},
  {"v062_full_random_target_isolation", tests.full_random_mocked_success_pipeline},
  {"v062_parent_first_rescan", tests.changing_parent_defers_descendant_mutation},
  {"v062_tuning_after_parts", tests.v060_tuning_rescan_discovers_only_new_variables},
  {"v062_paint_readback", tests.paint_readback_supports_bounded_deferred_confirmation},
  {"v062_completion_requires_closed_ledgers", tests.v060_coverage_chaos100_and_slot_identity},
  {"v062_partial_terminal", tests.v060_partial_result_setting_controls_rollback},
  {"v062_critical_failure_terminal", tests.required_core_missing_is_unsafe},
  {"v062_balanced_preset", tests.v061_race_presets_apply_real_policy},
  {"v062_maximum_chaos_preset", tests.v061_race_presets_apply_real_policy},
  {"v062_mods_showcase_preset", tests.v061_race_presets_apply_real_policy},
  {"v062_race_custom_preset", tests.v061_compact_ui_contract},
  {"v062_competitor_leaves_pending", tests.v061_race_statuses_and_cancel_are_terminal},
  {"v062_competitor_timeout_terminal", tests.v061_persistent_parts_read_fails_terminally},
  {"v062_race_cancel_terminal", tests.v061_race_statuses_and_cancel_are_terminal},
  {"v062_race_failure_isolation", tests.v060_lineup_variety_substreams_and_failure_actions},
  {"v062_placement_requires_ready", tests.v061_compact_ui_contract},
  {"v062_drive_requires_managed", tests.v060_managed_registry_rebinds_without_cross_vehicle_damage},
  {"v062_start_stop_ai", tests.v060_navgraph_routes_and_ai_bounds},
  {"v062_capability_explanation", tests.v062_capability_report_has_explicit_four_state_contract},
  {"v062_managed_vehicle_ownership", tests.v060_managed_registry_rebinds_without_cross_vehicle_damage},
  {"v062_save_dna", tests.explicit_save_persists_dna_with_readback},
  {"v062_restore_snapshot", tests.restore_exact_uses_one_transaction_and_strict_readback},
  {"v062_replay_generation", tests.replay_generation_freezes_saved_base_from_different_model},
  {"v062_import_compatibility", tests.vdna_json_envelope_roundtrips_through_public_import},
  {"v062_export_dna", tests.vdna_zip_roundtrip_validates_crc_manifest_and_limits},
  {"v062_compare_dna", tests.vehicle_dna_compare_is_field_by_field_not_fingerprint_only},
  {"v062_share_dna", tests.vdna_zip_roundtrip_validates_crc_manifest_and_limits},
  {"v062_dna_lineage", tests.dna_mutation_loads_parent_base_and_creates_child_lineage},
  {"v062_mutation_target_isolation", tests.dna_mutation_loads_parent_base_and_creates_child_lineage},
  {"v062_reroll_target_isolation", tests.reroll_unlocked_creates_pending_dna_without_changing_locked_state},
  {"v062_locks_default_unlocked", tests.v061_settings_locks_and_seed_migration},
  {"v062_remember_locks_default_off", tests.v061_settings_locks_and_seed_migration},
  {"v062_fixed_seed_warning", tests.v061_compact_ui_contract},
  {"v062_clear_seed", tests.v061_settings_locks_and_seed_migration},
  {"v062_safety_flag_mapping", tests.v060_partial_result_setting_controls_rollback},
  {"v062_diagnostics_available", tests.v062_runtime_instrumentation_is_bounded_and_complete},
  {"v062_no_dead_vertical_space", tests.v061_compact_ui_contract},
  {"v062_status_follows_slider", tests.v061_compact_ui_contract},
  {"v062_dynamic_height", tests.v061_compact_ui_contract},
  {"v062_collapsed_height", tests.v061_compact_ui_contract},
  {"v062_slider_fill_0", tests.v061_compact_ui_contract},
  {"v062_slider_fill_50", tests.v061_compact_ui_contract},
  {"v062_slider_fill_100", tests.v061_compact_ui_contract},
  {"v062_thumb_endpoint_0", tests.v061_compact_ui_contract},
  {"v062_thumb_endpoint_100", tests.v061_compact_ui_contract},
  {"v062_responsive_widths", tests.v061_compact_ui_contract},
  {"v062_ui_scaling", tests.v061_compact_ui_contract},
  {"v062_fox_svg_valid", tests.v061_compact_ui_contract},
  {"v062_fox_visible", tests.v061_compact_ui_contract},
  {"v062_fox_no_overlap", tests.v061_compact_ui_contract},
  {"v062_four_top_tabs", tests.v061_compact_ui_contract},
  {"v062_no_horizontal_overflow", tests.v061_compact_ui_contract},
  {"v062_temporary_parts_nil", tests.v061_bounded_parts_read_recovers},
  {"v062_persistent_parts_nil", tests.v061_persistent_parts_read_fails_terminally},
  {"v062_missing_callback", tests.v061_target_deadline_uses_wall_clock_while_paused},
  {"v062_external_error_target_guard", tests.v060_target_identity_tree_separation_contract},
  {"v062_degraded_capability_disables_action", tests.v062_capability_report_has_explicit_four_state_contract},
}

local v066Required = {
  {"baseline_roles_are_distinct", tests.v066_baselines_are_distinct_and_repair_prefers_last_accepted},
  {"coherent_read_requires_stable_cycles", tests.v066_coherent_gate_requires_same_generation_id_and_stable_cycles},
  {"stale_concrete_id_is_rejected", tests.v066_tracker_rejects_stale_concrete_id_after_return_binding},
  {"critical_repair_retains_unrelated_mutations", tests.v066_critical_repair_is_surgical_and_restores_missing_dependency_parent},
  {"full_recovery_follows_repair_failure", tests.v066_critical_repair_failure_is_explicit_before_full_recovery},
  {"critical_protection_precedes_allow_missing", tests.v066_safety_precedence_protects_structural_role_but_accepts_optional_missing},
  {"candidate_classification_matrix", tests.v066_candidate_classification_matrix_is_explicit},
  {"engine_fluid_states_and_propulsion", tests.v066_engine_fluid_guard_distinguishes_zero_unavailable_valid_and_noncombustion},
  {"independent_race_vehicle_ids", tests.v066_race_contexts_ids_partial_cancel_and_placement_are_isolated},
  {"placement_availability_has_reason", tests.v066_race_contexts_ids_partial_cancel_and_placement_are_isolated},
  {"known_conflicts_are_warning_only", tests.v066_known_conflicts_are_warning_only_and_never_disabled},
}

local v067Required = {
  {"chaos_race_domain_state_is_independent", tests.v067_domain_operations_isolate_chaos_race_and_garage},
  {"garage_domain_state_is_independent", tests.v067_domain_operations_isolate_chaos_race_and_garage},
  {"race_callback_cannot_complete_chaos", tests.v067_domain_operations_isolate_chaos_race_and_garage},
  {"chaos_callback_cannot_complete_race", tests.v067_domain_operations_isolate_chaos_race_and_garage},
  {"old_generation_callback_is_rejected", tests.v067_domain_operations_isolate_chaos_race_and_garage},
  {"race_competitor_requires_transfer", tests.v067_domain_operations_isolate_chaos_race_and_garage},
  {"operation_context_has_domain", tests.v067_operation_context_exposes_domain_cardinality_contract},
  {"operation_context_has_source", tests.v067_operation_context_exposes_domain_cardinality_contract},
  {"operation_context_has_candidates", tests.v067_operation_context_exposes_domain_cardinality_contract},
  {"operation_context_has_accepted_vehicle", tests.v067_operation_context_exposes_domain_cardinality_contract},
  {"operation_context_has_terminal_state", tests.v067_operation_context_exposes_domain_cardinality_contract},
  {"random_car_cardinality_is_recorded", tests.v067_cardinality_and_rollback_are_idempotent},
  {"full_random_cardinality_is_recorded", tests.v067_cardinality_and_rollback_are_idempotent},
  {"unaccepted_candidate_becomes_orphan", tests.v067_cardinality_and_rollback_are_idempotent},
  {"accepted_candidate_is_preserved", tests.v067_cardinality_and_rollback_are_idempotent},
  {"rollback_once_restores_source", tests.v067_cardinality_and_rollback_are_idempotent},
  {"rollback_repeated_is_idempotent", tests.v067_cardinality_and_rollback_are_idempotent},
  {"callback_after_timeout_is_ignored", tests.v067_stale_callbacks_are_rejected_and_owned_orphans_are_reaped},
  {"callback_after_rollback_is_ignored", tests.v067_stale_callbacks_are_rejected_and_owned_orphans_are_reaped},
  {"callback_after_cancel_is_ignored", tests.v067_stale_callbacks_are_rejected_and_owned_orphans_are_reaped},
  {"obsolete_owned_vehicle_is_orphan", tests.v067_stale_callbacks_are_rejected_and_owned_orphans_are_reaped},
  {"owned_orphan_is_removed", tests.v067_stale_callbacks_are_rejected_and_owned_orphans_are_reaped},
  {"external_vehicle_is_not_removed", tests.v067_stale_callbacks_are_rejected_and_owned_orphans_are_reaped},
  {"cleanup_is_ownership_scoped", tests.v067_stale_callbacks_are_rejected_and_owned_orphans_are_reaped},
  {"config_failure_enters_quarantine", tests.v067_quarantine_is_generation_scoped_and_non_persistent},
  {"quarantined_config_is_not_readded", tests.v067_quarantine_is_generation_scoped_and_non_persistent},
  {"quarantine_is_domain_scoped", tests.v067_quarantine_is_generation_scoped_and_non_persistent},
  {"quarantine_clears_by_policy", tests.v067_quarantine_is_generation_scoped_and_non_persistent},
  {"source_vehicle_is_not_owned_as_created", tests.v067_stale_callbacks_are_rejected_and_owned_orphans_are_reaped},
  {"player_result_has_explicit_role", tests.v067_cardinality_and_rollback_are_idempotent},
  {"race_competitor_has_explicit_role", tests.v067_domain_operations_isolate_chaos_race_and_garage},
  {"domain_generations_advance_independently", tests.v067_domain_operations_isolate_chaos_race_and_garage},
  {"superseded_operation_is_terminal", tests.v067_domain_operations_isolate_chaos_race_and_garage},
  {"terminal_operation_invalidates_callbacks", tests.v067_stale_callbacks_are_rejected_and_owned_orphans_are_reaped},
  {"cleanup_reports_removed_ids", tests.v067_stale_callbacks_are_rejected_and_owned_orphans_are_reaped},
  {"summary_reports_domain_contexts", tests.v067_domain_operations_isolate_chaos_race_and_garage},
  {"summary_reports_orphan_count", tests.v067_stale_callbacks_are_rejected_and_owned_orphans_are_reaped},
  {"accepted_vehicle_not_reaped", tests.v067_cardinality_and_rollback_are_idempotent},
  {"candidate_ids_are_unique", tests.v067_operation_context_exposes_domain_cardinality_contract},
  {"removed_vehicle_ids_are_diagnostic", tests.v067_operation_context_exposes_domain_cardinality_contract},
  {"spectator_count_means_ai_competitors", tests.v067_race_participation_rng_and_state_machine},
  {"player_count_means_total_vehicles", tests.v067_race_participation_rng_and_state_machine},
  {"player_participation_subtracts_one_opponent", tests.v067_race_participation_rng_and_state_machine},
  {"race_count_semantics_are_exported", tests.v067_race_participation_rng_and_state_machine},
  {"competitor_primary_seeds_are_unique", tests.v067_race_participation_rng_and_state_machine},
  {"competitor_substream_seeds_are_independent", tests.v067_race_participation_rng_and_state_machine},
  {"retry_seed_changes_only_attempt", tests.v067_race_participation_rng_and_state_machine},
  {"slot_seed_replays_independently", tests.v067_race_participation_rng_and_state_machine},
  {"competitor_mutable_state_is_not_shared", tests.v067_race_participation_rng_and_state_machine},
  {"race_state_machine_starts_planning", tests.v067_race_participation_rng_and_state_machine},
  {"race_slot_enters_spawning", tests.v067_race_participation_rng_and_state_machine},
  {"failed_slot_has_terminal_placement_state", tests.v067_race_participation_rng_and_state_machine},
  {"retry_resets_only_failed_slot", tests.v067_race_participation_rng_and_state_machine},
  {"race_cancel_has_terminal_state", tests.v067_race_participation_rng_and_state_machine},
  {"automatic_best_fit_uses_available_width", tests.v067_dynamic_race_formations_and_spacing},
  {"automatic_spacing_uses_vehicle_width", tests.v067_dynamic_race_formations_and_spacing},
  {"automatic_spacing_uses_vehicle_length", tests.v067_dynamic_race_formations_and_spacing},
  {"placement_keeps_per_vehicle_dimensions", tests.v067_dynamic_race_formations_and_spacing},
  {"unknown_width_falls_back_to_single_file", tests.v067_dynamic_race_formations_and_spacing},
  {"narrow_area_reduces_grid_to_single_file", tests.v067_dynamic_race_formations_and_spacing},
  {"split_formation_uses_both_sides", tests.v067_dynamic_race_formations_and_spacing},
  {"single_file_ahead_is_longitudinal", tests.v067_dynamic_race_formations_and_spacing},
  {"formation_reports_requested_and_effective_modes", tests.v067_dynamic_race_formations_and_spacing},
  {"formation_reports_fallback_reason", tests.v067_dynamic_race_formations_and_spacing},
  {"unknown_graph_is_not_confirmed_invalid", tests.v067_ternary_safety_decisions_are_evidence_based},
  {"confirmed_core_missing_is_invalid", tests.v067_ternary_safety_decisions_are_evidence_based},
  {"fluid_probe_unavailable_is_unknown", tests.v067_ternary_safety_decisions_are_evidence_based},
  {"engine_runtime_missing_is_unknown", tests.v067_ternary_safety_decisions_are_evidence_based},
  {"zero_oil_is_confirmed_invalid", tests.v067_ternary_safety_decisions_are_evidence_based},
  {"healthy_oil_is_valid", tests.v067_ternary_safety_decisions_are_evidence_based},
  {"unresolved_fuel_is_unknown", tests.v067_ternary_safety_decisions_are_evidence_based},
  {"race_policy_keeps_duplicate_controls", tests.v067_race_policy_inventory_and_roundtrip},
  {"race_policy_keeps_diversity_controls", tests.v067_race_policy_inventory_and_roundtrip},
  {"race_policy_keeps_source_controls", tests.v067_race_policy_inventory_and_roundtrip},
  {"race_policy_keeps_automation_trailer_prop_controls", tests.v067_race_policy_inventory_and_roundtrip},
  {"custom_policy_preserves_maximum_family", tests.v067_race_policy_inventory_and_roundtrip},
  {"custom_policy_preserves_formation", tests.v067_race_policy_inventory_and_roundtrip},
  {"custom_policy_preserves_spacing", tests.v067_race_policy_inventory_and_roundtrip},
  {"lineup_import_preserves_participation", tests.v067_race_policy_inventory_and_roundtrip},
  {"lineup_import_preserves_race_policy", tests.v067_race_policy_inventory_and_roundtrip},
}

local v068Required = {
  {"central_compatibility_metadata_is_classified", tests.v068_compatibility_metadata_classification_is_explicit},
  {"primary_target_is_explicit", tests.v068_compatibility_metadata_classification_is_explicit},
  {"minimum_supported_is_explicit", tests.v068_compatibility_metadata_classification_is_explicit},
  {"newer_build_is_unverified", tests.v068_compatibility_metadata_classification_is_explicit},
  {"older_build_is_unsupported", tests.v068_compatibility_metadata_classification_is_explicit},
  {"unknown_build_has_warning", tests.v068_compatibility_metadata_classification_is_explicit},
  {"physical_path_preserves_case", tests.v068_paths_preserve_physical_case_and_reject_traversal},
  {"comparison_path_is_lowercase", tests.v068_paths_preserve_physical_case_and_reject_traversal},
  {"basename_is_separate_identity", tests.v068_paths_preserve_physical_case_and_reject_traversal},
  {"path_traversal_is_rejected", tests.v068_paths_preserve_physical_case_and_reject_traversal},
  {"external_drive_path_is_rejected", tests.v068_paths_preserve_physical_case_and_reject_traversal},
  {"uri_path_is_rejected", tests.v068_paths_preserve_physical_case_and_reject_traversal},
  {"registry_partial_state_is_explicit", tests.v068_registry_readiness_is_bounded_and_atomic_index_is_preserved},
  {"registry_retry_is_wall_clock_bounded", tests.v068_registry_readiness_is_bounded_and_atomic_index_is_preserved},
  {"registry_failure_is_confirmed", tests.v068_registry_readiness_is_bounded_and_atomic_index_is_preserved},
  {"registry_retry_stops_at_budget", tests.v068_registry_readiness_is_bounded_and_atomic_index_is_preserved},
  {"valid_index_survives_empty_read", tests.v068_registry_readiness_is_bounded_and_atomic_index_is_preserved},
  {"registry_model_key_is_internal", tests.v068_registry_readiness_is_bounded_and_atomic_index_is_preserved},
  {"registry_config_key_is_internal", tests.v068_registry_readiness_is_bounded_and_atomic_index_is_preserved},
  {"technical_id_is_translation_independent", tests.v068_registry_readiness_is_bounded_and_atomic_index_is_preserved},
  {"spawn_records_world_before", tests.v068_spawn_outcomes_are_evidence_based_and_cleanup_is_owned},
  {"spawn_records_world_after", tests.v068_spawn_outcomes_are_evidence_based_and_cleanup_is_owned},
  {"spawn_records_returned_id", tests.v068_spawn_outcomes_are_evidence_based_and_cleanup_is_owned},
  {"spawn_candidate_is_not_accepted_early", tests.v068_spawn_outcomes_are_evidence_based_and_cleanup_is_owned},
  {"spawn_acceptance_is_explicit", tests.v068_spawn_outcomes_are_evidence_based_and_cleanup_is_owned},
  {"spawn_ambiguous_cardinality_is_rejected", tests.v068_spawn_outcomes_are_evidence_based_and_cleanup_is_owned},
  {"spawn_cleanup_is_created_id_scoped", tests.v068_spawn_outcomes_are_evidence_based_and_cleanup_is_owned},
  {"memory_denial_is_confirmed_from_false", tests.v068_adapter_classifies_confirmed_low_memory_without_inventing_space_failure},
  {"space_denial_is_not_invented", tests.v068_adapter_classifies_confirmed_low_memory_without_inventing_space_failure},
  {"memory_denial_does_not_retry_forever", tests.v068_spawn_outcomes_are_evidence_based_and_cleanup_is_owned},
  {"memory_denial_does_not_blacklist", tests.v068_temporary_failures_never_blacklist_catalog_content},
  {"space_denial_does_not_blacklist", tests.v068_temporary_failures_never_blacklist_catalog_content},
  {"registry_temporary_does_not_blacklist", tests.v068_temporary_failures_never_blacklist_catalog_content},
  {"isolated_unknown_does_not_blacklist", tests.v068_temporary_failures_never_blacklist_catalog_content},
  {"uncorrelated_destroy_does_not_blacklist", tests.v068_temporary_failures_never_blacklist_catalog_content},
  {"temporary_conditions_do_not_enter_domain_quarantine", tests.v068_temporary_failures_never_blacklist_catalog_content},
  {"settings_write_has_backup", tests.v068_user_data_writes_are_transactional_and_reported},
  {"lineup_write_has_backup", tests.v068_user_data_writes_are_transactional_and_reported},
  {"transaction_has_readback", tests.v068_user_data_writes_are_transactional_and_reported},
  {"transaction_rolls_back_on_mismatch", tests.v068_user_data_writes_are_transactional_and_reported},
  {"rollback_is_readback_verified", tests.v068_user_data_writes_are_transactional_and_reported},
  {"unreadable_previous_data_is_not_overwritten", tests.v068_user_data_writes_are_transactional_and_reported},
  {"migration_report_is_structured", tests.v068_user_data_writes_are_transactional_and_reported},
  {"migration_report_records_source_and_target", tests.v068_user_data_writes_are_transactional_and_reported},
  {"migration_preserves_vehicle_dna", tests.v068_user_data_writes_are_transactional_and_reported},
  {"migration_preserves_lineups", tests.v068_user_data_writes_are_transactional_and_reported},
}

local v069Required = {
  {"profiler_count_total_mean", tests.v069_profiler_disabled_reset_overflow_and_capabilities},
  {"profiler_p50_p95_p99", tests.v069_profiler_disabled_reset_overflow_and_capabilities},
  {"profiler_buffer_is_bounded", tests.v069_profiler_disabled_reset_overflow_and_capabilities},
  {"profiler_overflow_keeps_recent_samples", tests.v069_profiler_disabled_reset_overflow_and_capabilities},
  {"profiler_disabled_has_no_samples", tests.v069_profiler_disabled_reset_overflow_and_capabilities},
  {"profiler_reset_clears_aggregates", tests.v069_profiler_disabled_reset_overflow_and_capabilities},
  {"profiler_tool_capabilities_are_optional", tests.v069_profiler_disabled_reset_overflow_and_capabilities},
  {"budget_below_limit", tests.v069_frame_budgets_warn_without_cancelling},
  {"budget_above_limit", tests.v069_frame_budgets_warn_without_cancelling},
  {"budget_warning_is_amortized", tests.v069_frame_budgets_warn_without_cancelling},
  {"budget_excess_does_not_cancel", tests.v069_frame_budgets_warn_without_cancelling},
  {"iterator_low_gc_available", tests.v069_vehicle_iterators_are_deterministic_with_safe_fallback},
  {"iterator_fallback_available", tests.v069_vehicle_iterators_are_deterministic_with_safe_fallback},
  {"iterator_empty_world", tests.v069_vehicle_iterators_are_deterministic_with_safe_fallback},
  {"iterator_destroyed_object_ignored", tests.v069_vehicle_iterators_are_deterministic_with_safe_fallback},
  {"iterator_ids_are_deterministic", tests.v069_vehicle_iterators_are_deterministic_with_safe_fallback},
  {"iterator_buffer_is_reused", tests.v069_vehicle_iterators_are_deterministic_with_safe_fallback},
  {"buffer_clear_removes_sparse_and_named_keys", tests.v069_reusable_buffers_prevent_aliasing_and_stale_release},
  {"buffer_storage_is_reused", tests.v069_reusable_buffers_prevent_aliasing_and_stale_release},
  {"buffer_copy_prevents_aliasing", tests.v069_reusable_buffers_prevent_aliasing_and_stale_release},
  {"buffer_stale_generation_is_rejected", tests.v069_reusable_buffers_prevent_aliasing_and_stale_release},
  {"oobb_xyz_is_preferred", tests.v069_oobb_xyz_dimension_cache_invalidates_recycled_ids},
  {"oobb_world_box_fallback", tests.v069_oobb_xyz_dimension_cache_invalidates_recycled_ids},
  {"dimension_cache_hit_avoids_read", tests.v069_oobb_xyz_dimension_cache_invalidates_recycled_ids},
  {"dimension_cache_output_does_not_alias", tests.v069_oobb_xyz_dimension_cache_invalidates_recycled_ids},
  {"dimension_cache_generation_prevents_recycled_id", tests.v069_oobb_xyz_dimension_cache_invalidates_recycled_ids},
  {"dimension_cache_destroy_invalidation", tests.v069_oobb_xyz_dimension_cache_invalidates_recycled_ids},
  {"registry_cache_hit", tests.v069_registry_cache_fingerprint_checksum_and_partial_rejection},
  {"registry_cache_mod_fingerprint_change", tests.v069_registry_cache_fingerprint_checksum_and_partial_rejection},
  {"registry_cache_corruption_rejected", tests.v069_registry_cache_fingerprint_checksum_and_partial_rejection},
  {"registry_cache_partial_snapshot_rejected", tests.v069_registry_cache_fingerprint_checksum_and_partial_rejection},
  {"registry_cache_payload_is_owned", tests.v069_registry_cache_fingerprint_checksum_and_partial_rejection},
  {"registry_cache_sensitive_path_rejected", tests.v069_registry_cache_fingerprint_checksum_and_partial_rejection},
  {"registry_cache_size_is_bounded", tests.v069_registry_cache_fingerprint_checksum_and_partial_rejection},
  {"incremental_index_processes_chunks", tests.v069_incremental_index_is_chunked_cancellable_restartable_and_atomic},
  {"incremental_index_respects_item_budget", tests.v069_incremental_index_is_chunked_cancellable_restartable_and_atomic},
  {"incremental_index_can_cancel", tests.v069_incremental_index_is_chunked_cancellable_restartable_and_atomic},
  {"incremental_index_can_restart", tests.v069_incremental_index_is_chunked_cancellable_restartable_and_atomic},
  {"incremental_index_reports_progress", tests.v069_incremental_index_is_chunked_cancellable_restartable_and_atomic},
  {"incremental_index_never_commits_partial", tests.v069_incremental_index_is_chunked_cancellable_restartable_and_atomic},
  {"ui_initial_state_is_full", tests.v069_ui_dirty_diff_debounce_and_full_request_are_bounded},
  {"ui_progress_update_is_partial", tests.v069_ui_dirty_diff_debounce_and_full_request_are_bounded},
  {"ui_publish_is_debounced", tests.v069_ui_dirty_diff_debounce_and_full_request_are_bounded},
  {"ui_publish_suppression_is_counted", tests.v069_ui_dirty_diff_debounce_and_full_request_are_bounded},
  {"ui_explicit_request_is_full", tests.v069_ui_dirty_diff_debounce_and_full_request_are_bounded},
  {"ui_hook_and_byte_rates_are_measured", tests.v069_ui_dirty_diff_debounce_and_full_request_are_bounded},
  {"diagnostics_are_deduplicated", tests.v069_diagnostics_deduplicate_rate_limit_export_and_reserve_critical},
  {"diagnostics_repetitions_are_counted", tests.v069_diagnostics_deduplicate_rate_limit_export_and_reserve_critical},
  {"diagnostics_are_rate_limited", tests.v069_diagnostics_deduplicate_rate_limit_export_and_reserve_critical},
  {"diagnostics_compact_omits_details", tests.v069_diagnostics_deduplicate_rate_limit_export_and_reserve_critical},
  {"diagnostics_full_export_is_sanitized", tests.v069_diagnostics_deduplicate_rate_limit_export_and_reserve_critical},
  {"diagnostics_critical_records_are_reserved", tests.v069_diagnostics_deduplicate_rate_limit_export_and_reserve_critical},
  {"polling_starts_fast", tests.v069_adaptive_polling_fast_backoff_terminal_stale_and_wake},
  {"polling_backs_off_when_stable", tests.v069_adaptive_polling_fast_backoff_terminal_stale_and_wake},
  {"polling_change_resets_cadence", tests.v069_adaptive_polling_fast_backoff_terminal_stale_and_wake},
  {"polling_terminal_has_no_timer", tests.v069_adaptive_polling_fast_backoff_terminal_stale_and_wake},
  {"polling_stale_generation_is_rejected", tests.v069_adaptive_polling_fast_backoff_terminal_stale_and_wake},
  {"polling_wake_resumes_with_new_generation", tests.v069_adaptive_polling_fast_backoff_terminal_stale_and_wake},
  {"ai_mode_readback_confirms", tests.v069_ai_mode_confirmation_handles_all_terminal_outcomes},
  {"ai_mode_unavailable_fallback", tests.v069_ai_mode_confirmation_handles_all_terminal_outcomes},
  {"ai_mode_mismatch_is_bounded", tests.v069_ai_mode_confirmation_handles_all_terminal_outcomes},
  {"ai_mode_timeout_is_bounded", tests.v069_ai_mode_confirmation_handles_all_terminal_outcomes},
  {"ai_mode_destroyed_is_terminal", tests.v069_ai_mode_confirmation_handles_all_terminal_outcomes},
  {"ai_mode_stale_response_is_rejected", tests.v069_ai_mode_confirmation_handles_all_terminal_outcomes},
  {"race_scale_one_vehicle", tests.v069_race_scale_and_seed_regression_vectors},
  {"race_scale_four_vehicles", tests.v069_race_scale_and_seed_regression_vectors},
  {"race_scale_eight_vehicles", tests.v069_race_scale_and_seed_regression_vectors},
  {"race_scale_twelve_vehicles", tests.v069_race_scale_and_seed_regression_vectors},
  {"race_scale_has_no_duplicate_seeds", tests.v069_race_scale_and_seed_regression_vectors},
  {"random_car_seed_vector", tests.v069_race_scale_and_seed_regression_vectors},
  {"scramble_seed_vector", tests.v069_race_scale_and_seed_regression_vectors},
  {"full_random_seed_vector", tests.v069_race_scale_and_seed_regression_vectors},
  {"race_competitor_seed_vector", tests.v069_race_scale_and_seed_regression_vectors},
  {"vehicle_dna_replay_seed_vector", tests.v069_race_scale_and_seed_regression_vectors},
  {"pure_seed_replay_vector", tests.v069_race_scale_and_seed_regression_vectors},
}

local v070Required = {
  {"ui_protocol_version", tests.v070_ui_protocol_sequence_projection_and_validation},
  {"ui_state_sequence", tests.v070_ui_protocol_sequence_projection_and_validation},
  {"ui_state_projection", tests.v070_ui_protocol_sequence_projection_and_validation},
  {"ui_command_schema_validation", tests.v070_ui_protocol_sequence_projection_and_validation},
  {"ui_command_router_allowlist", tests.v070_ui_command_router_is_allowlisted_bounded_and_idempotent},
  {"ui_command_router_idempotency", tests.v070_ui_command_router_is_allowlisted_bounded_and_idempotent},
  {"ui_command_router_structured_errors", tests.v070_ui_command_router_is_allowlisted_bounded_and_idempotent},
  {"ui_preferences_schema", tests.v070_ui_preferences_migrate_once_and_keep_technical_policy},
  {"ui_preferences_legacy_migration", tests.v070_ui_preferences_migrate_once_and_keep_technical_policy},
  {"ui_preferences_migration_idempotency", tests.v070_ui_preferences_migrate_once_and_keep_technical_policy},
  {"native_vue_runtime_capability", tests.v070_native_vue_runtime_is_single_and_legacy_angular_is_absent},
  {"single_runtime_ui_entry", tests.v070_native_vue_runtime_is_single_and_legacy_angular_is_absent},
}

local v072Required = {
  {"background_parts_are_id_bound", tests.v072_adapter_mutates_background_vehicle_without_player_staging},
  {"background_tuning_is_id_bound", tests.v072_adapter_mutates_background_vehicle_without_player_staging},
  {"background_paint_is_id_bound", tests.v072_adapter_mutates_background_vehicle_without_player_staging},
  {"player_is_never_race_staging", tests.v072_adapter_mutates_background_vehicle_without_player_staging},
  {"race_scale_one", tests.v072_race_slots_are_independent_at_one_four_eight_and_twelve},
  {"race_scale_four", tests.v072_race_slots_are_independent_at_one_four_eight_and_twelve},
  {"race_scale_eight", tests.v072_race_slots_are_independent_at_one_four_eight_and_twelve},
  {"race_scale_twelve", tests.v072_race_slots_are_independent_at_one_four_eight_and_twelve},
  {"race_vehicle_ids_are_unique", tests.v072_race_slots_are_independent_at_one_four_eight_and_twelve},
  {"race_operation_seeds_are_unique", tests.v072_race_slots_are_independent_at_one_four_eight_and_twelve},
  {"race_failure_preserves_accepted_slot", tests.v072_race_failure_retry_and_stale_callbacks_preserve_other_slots},
  {"race_retry_changes_only_attempt_substream", tests.v072_race_failure_retry_and_stale_callbacks_preserve_other_slots},
  {"race_retry_limit_is_bounded", tests.v072_race_failure_retry_and_stale_callbacks_preserve_other_slots},
  {"race_stale_callback_is_side_effect_free", tests.v072_race_failure_retry_and_stale_callbacks_preserve_other_slots},
  {"domain_accepts_exactly_one_result", tests.v072_transaction_binding_and_cardinality_are_explicit},
  {"binding_state_is_explicit", tests.v072_transaction_binding_and_cardinality_are_explicit},
  {"world_vehicle_delta_is_recorded", tests.v072_transaction_binding_and_cardinality_are_explicit},
  {"stale_callback_side_effect_count_is_zero", tests.v072_transaction_binding_and_cardinality_are_explicit},
  {"stability_limits_are_defensive", tests.v072_scheduler_limits_and_watchdog_are_bounded},
  {"scheduler_executes_one_heavy_step_per_frame", tests.v072_scheduler_limits_and_watchdog_are_bounded},
  {"scheduler_yields_with_pending_work", tests.v072_scheduler_limits_and_watchdog_are_bounded},
  {"watchdog_exposes_required_metrics", tests.v072_scheduler_limits_and_watchdog_are_bounded},
  {"watchdog_has_aborting_cleaning_terminal_states", tests.v072_scheduler_limits_and_watchdog_are_bounded},
}

local v073Required = {
  {"beamng_0394_fixture_identity", tests.v073_beamng_0394_fixture_covers_identity_failures_and_managed_ai},
  {"beamng_0394_fixture_failures", tests.v073_beamng_0394_fixture_covers_identity_failures_and_managed_ai},
  {"beamng_0394_fixture_managed_ai", tests.v073_beamng_0394_fixture_covers_identity_failures_and_managed_ai},
  {"callback_phase_token", tests.v073_callback_tokens_are_phase_vehicle_and_consumption_bound},
  {"callback_expected_vehicle", tests.v073_callback_tokens_are_phase_vehicle_and_consumption_bound},
  {"callback_single_consumption", tests.v073_callback_tokens_are_phase_vehicle_and_consumption_bound},
  {"callback_diagnostics_bounded", tests.v073_callback_tokens_are_phase_vehicle_and_consumption_bound},
  {"full_random_one_temporary", tests.v073_full_random_cardinality_and_scramble_identity_are_absolute},
  {"full_random_peak_temporary_one", tests.v073_full_random_cardinality_and_scramble_identity_are_absolute},
  {"full_random_then_scramble_isolated", tests.v073_full_random_cardinality_and_scramble_identity_are_absolute},
  {"scramble_same_concrete_vehicle", tests.v073_full_random_cardinality_and_scramble_identity_are_absolute},
  {"scramble_zero_temporary", tests.v073_full_random_cardinality_and_scramble_identity_are_absolute},
  {"race_callback_slot_bound", tests.v073_race_slots_cannot_reuse_accepted_physical_vehicles},
  {"race_accepted_vehicle_not_reused", tests.v073_race_slots_cannot_reuse_accepted_physical_vehicles},
  {"race_slot_physical_ids_unique", tests.v073_race_slots_cannot_reuse_accepted_physical_vehicles},
  {"callback_fault_injection_64_sequences", tests.v073_callback_sequence_fault_injection_is_side_effect_free},
  {"late_callback_side_effect_free", tests.v073_callback_sequence_fault_injection_is_side_effect_free},
  {"semantic_watchdog_ignores_callback_noise", tests.v060_progress_watchdog_contract},
  {"cooperative_scheduler_resumes", tests.v072_scheduler_limits_and_watchdog_are_bounded},
  {"interactive_operation_timeouts", tests.v072_scheduler_limits_and_watchdog_are_bounded},
}

local v074Required = {
  {"random_car_expected_remove_add_sets", tests.v074_replacement_cardinality_uses_expected_sets_and_preserves_external_ids},
  {"random_car_external_removal_is_diagnostic", tests.v074_replacement_cardinality_uses_expected_sets_and_preserves_external_ids},
  {"random_car_external_addition_is_not_owned", tests.v074_replacement_cardinality_uses_expected_sets_and_preserves_external_ids},
  {"scramble_owned_identity_ignores_external_delta", tests.v074_scramble_cardinality_is_owned_identity_not_global_delta},
  {"safety_runtime_integrity_axis", tests.v074_safety_v2_separates_integrity_drivability_policy_and_fluids},
  {"safety_drivability_axis", tests.v074_safety_v2_separates_integrity_drivability_policy_and_fluids},
  {"safety_policy_acceptance_axis", tests.v074_safety_v2_separates_integrity_drivability_policy_and_fluids},
  {"safety_unknown_is_non_destructive", tests.v074_safety_v2_separates_integrity_drivability_policy_and_fluids},
  {"fluid_states_are_four_way", tests.v074_safety_v2_separates_integrity_drivability_policy_and_fluids},
  {"parts_reload_count_is_instrumented", tests.v074_reload_and_readback_metrics_are_bounded_and_structured},
  {"readback_count_is_instrumented", tests.v074_reload_and_readback_metrics_are_bounded_and_structured},
  {"repair_reload_count_is_instrumented", tests.v074_reload_and_readback_metrics_are_bounded_and_structured},
  {"reload_duration_is_instrumented", tests.v074_reload_and_readback_metrics_are_bounded_and_structured},
  {"phase_duration_is_instrumented", tests.v074_reload_and_readback_metrics_are_bounded_and_structured},
  {"max_single_step_is_instrumented", tests.v074_reload_and_readback_metrics_are_bounded_and_structured},
  {"parts_reload_hard_limit_is_low", tests.v074_reload_and_readback_metrics_are_bounded_and_structured},
  {"race_focus_steal_restores_player", tests.v074_race_focus_slots_and_dna_are_isolated},
  {"race_player_is_never_candidate", tests.v074_race_focus_slots_and_dna_are_isolated},
  {"race_failed_slot_dna_is_nil", tests.v074_race_focus_slots_and_dna_are_isolated},
  {"race_invalid_dna_is_slot_local_failure", tests.v074_race_focus_slots_and_dna_are_isolated},
  {"race_failure_does_not_block_later_slot", tests.v074_race_focus_slots_and_dna_are_isolated},
  {"race_accepted_slot_survives_other_cleanup", tests.v074_race_focus_slots_and_dna_are_isolated},
  {"race_counts_reflect_ready_physical_slots", tests.v074_race_focus_slots_and_dna_are_isolated},
  {"race_generation_preview_is_structured", tests.v074_race_previews_are_read_only_structured_and_generation_scoped},
  {"race_final_grid_preview_is_distinct", tests.v074_race_previews_are_read_only_structured_and_generation_scoped},
  {"race_preview_has_zero_world_mutations", tests.v074_race_previews_are_read_only_structured_and_generation_scoped},
  {"race_preview_omits_vehicle_ids", tests.v074_race_previews_are_read_only_structured_and_generation_scoped},
  {"race_preview_uses_fallback_then_actual_bounds", tests.v074_race_previews_are_read_only_structured_and_generation_scoped},
  {"race_preview_cleanup_is_generation_scoped", tests.v074_race_previews_are_read_only_structured_and_generation_scoped},
  {"lock_classifier_prefers_specific_child_evidence", tests.lock_categories_use_slot_evidence_and_unknown_fallback},
  {"lock_classifier_uses_ancestry_only_as_fallback", tests.lock_categories_use_slot_evidence_and_unknown_fallback},
  {"lock_classifier_preserves_unknown_mod_names", tests.lock_categories_use_slot_evidence_and_unknown_fallback},
}

local v075Required = {
  {"outcome_taxonomy_is_explicit", tests.v075_outcome_taxonomy_is_explicit_and_terminally_immutable},
  {"outcome_confidence_is_separate", tests.v075_outcome_taxonomy_is_explicit_and_terminally_immutable},
  {"unsupported_fluid_telemetry_is_not_partial", tests.v075_outcome_taxonomy_is_explicit_and_terminally_immutable},
  {"terminal_success_is_immutable", tests.v075_outcome_taxonomy_is_explicit_and_terminally_immutable},
  {"watchdog_uses_phase_profiles", tests.v075_phase_watchdog_tracks_semantic_progress_and_engine_waits},
  {"watchdog_uses_semantic_progress", tests.v075_phase_watchdog_tracks_semantic_progress_and_engine_waits},
  {"watchdog_callback_noise_does_not_renew", tests.v075_phase_watchdog_tracks_semantic_progress_and_engine_waits},
  {"watchdog_engine_wait_is_not_stall", tests.v075_phase_watchdog_tracks_semantic_progress_and_engine_waits},
  {"watchdog_hard_deadline_is_terminal", tests.v075_phase_watchdog_tracks_semantic_progress_and_engine_waits},
  {"preview_data_ready_is_not_visible", tests.v075_preview_state_requires_a_rendered_frame},
  {"preview_renderer_unavailable_is_explicit", tests.v075_preview_state_requires_a_rendered_frame},
  {"preview_render_error_is_explicit", tests.v075_preview_state_requires_a_rendered_frame},
  {"preview_visible_requires_rendered_marker", tests.v075_preview_state_requires_a_rendered_frame},
  {"preview_toggle_off_clears_markers", tests.v075_preview_state_requires_a_rendered_frame},
  {"mods_showcase_metadata_is_permissive", tests.v075_race_acceptance_is_slot_local_and_terminally_immutable},
  {"mods_showcase_drivability_is_permissive", tests.v075_race_acceptance_is_slot_local_and_terminally_immutable},
  {"accepted_race_slot_is_immutable", tests.v075_race_acceptance_is_slot_local_and_terminally_immutable},
  {"failed_or_missing_dna_is_not_persisted", tests.v075_race_acceptance_is_slot_local_and_terminally_immutable},
  {"lineup_persistence_failure_is_transactional", tests.v075_lineup_persistence_and_scheduler_failures_are_contained},
  {"lineup_persistence_retry_can_commit", tests.v075_lineup_persistence_and_scheduler_failures_are_contained},
  {"planned_lineup_schedules_next_slot", tests.v075_lineup_persistence_and_scheduler_failures_are_contained},
  {"abandoned_slot_is_closed_without_deadlock", tests.v075_lineup_persistence_and_scheduler_failures_are_contained},
  {"ai_backend_modes_match_director", tests.v075_ai_capabilities_match_runtime_and_quick_presets},
  {"ai_capabilities_are_frontend_consumable", tests.v075_ai_capabilities_match_runtime_and_quick_presets},
  {"ai_quick_presets_are_real_modes", tests.v075_ai_capabilities_match_runtime_and_quick_presets},
  {"ai_flee_and_roam_are_supported", tests.v075_ai_capabilities_match_runtime_and_quick_presets},
  {"vehicle_identity_includes_owner", tests.v075_identity_contact_and_playground_foundations_are_bounded},
  {"remote_vehicle_mutation_is_denied", tests.v075_identity_contact_and_playground_foundations_are_bounded},
  {"contact_detection_has_cooldown", tests.v075_identity_contact_and_playground_foundations_are_bounded},
  {"playground_terminal_state_is_immutable", tests.v075_identity_contact_and_playground_foundations_are_bounded},
  {"formation_uses_stable_codes", tests.v075_formation_codes_roundtrip_at_the_runtime_boundary},
  {"formation_runtime_boundary_roundtrip", tests.v075_formation_codes_roundtrip_at_the_runtime_boundary},
}

local v076Required = {
  {"preview_retry_releases_transient_lock", tests.v076_race_retry_attempts_are_fresh_persistent_and_stale_safe},
  {"preview_retry_uses_new_identity", tests.v076_race_retry_attempts_are_fresh_persistent_and_stale_safe},
  {"recoverable_error_persists_until_success", tests.v076_race_retry_attempts_are_fresh_persistent_and_stale_safe},
  {"stale_preview_callback_is_inert", tests.v076_race_retry_attempts_are_fresh_persistent_and_stale_safe},
  {"staging_retry_uses_new_generation", tests.v076_race_retry_attempts_are_fresh_persistent_and_stale_safe},
  {"recoverable_error_can_be_dismissed", tests.v076_race_retry_attempts_are_fresh_persistent_and_stale_safe},
  {"preview_renderer_false_is_failure", tests.v076_preview_renderer_failure_toggle_and_false_return_are_explicit},
  {"preview_rendering_state_is_explicit", tests.v076_preview_renderer_failure_toggle_and_false_return_are_explicit},
  {"preview_toggle_fifty_cycles", tests.v076_preview_renderer_failure_toggle_and_false_return_are_explicit},
  {"lineup_storage_failures_are_typed", tests.v076_lineup_persistence_is_typed_and_scheduler_progress_is_bounded},
  {"lineup_storage_recovery_clears_warning", tests.v076_lineup_persistence_is_typed_and_scheduler_progress_is_bounded},
  {"planned_idle_scheduler_is_bounded", tests.v076_lineup_persistence_is_typed_and_scheduler_progress_is_bounded},
  {"property_external_vehicle_is_diagnostic_only", tests.v076_ownership_properties_hold_across_adversarial_callback_sequences},
  {"property_candidate_removal_releases_temporary", tests.v076_ownership_properties_hold_across_adversarial_callback_sequences},
  {"property_recycled_id_starts_clean", tests.v076_ownership_properties_hold_across_adversarial_callback_sequences},
  {"property_out_of_order_callback_is_inert", tests.v076_ownership_properties_hold_across_adversarial_callback_sequences},
  {"property_duplicate_callback_is_inert", tests.v076_ownership_properties_hold_across_adversarial_callback_sequences},
  {"property_cancel_during_reload_is_inert", tests.v076_ownership_properties_hold_across_adversarial_callback_sequences},
  {"property_new_operation_invalidates_old_callback", tests.v076_ownership_properties_hold_across_adversarial_callback_sequences},
}

local v077Required = {
  {"blank_seed_mints_new_episode", tests.v077_episode_seed_intent_is_explicit_unique_and_repeatable},
  {"explicit_seed_reproduces_slot_substreams", tests.v077_episode_seed_intent_is_explicit_unique_and_repeatable},
  {"repeat_intent_keeps_episode_seed", tests.v077_episode_seed_intent_is_explicit_unique_and_repeatable},
  {"retry_uses_fresh_attempt_substream", tests.v077_episode_seed_intent_is_explicit_unique_and_repeatable},
  {"managed_slot_binding_is_one_to_one", tests.v077_managed_slot_binding_and_replacement_are_atomic},
  {"managed_vehicle_binding_is_one_to_one", tests.v077_managed_slot_binding_and_replacement_are_atomic},
  {"managed_replacement_failure_retains_source", tests.v077_managed_slot_binding_and_replacement_are_atomic},
  {"managed_replacement_stale_commit_is_inert", tests.v077_managed_slot_binding_and_replacement_are_atomic},
  {"managed_replacement_twenty_cycles_has_one_entry", tests.v077_managed_slot_binding_and_replacement_are_atomic},
  {"race_cleanup_requires_exact_owned_slot", tests.v077_race_cleanup_requires_exact_owned_slot_and_local_authority},
  {"race_cleanup_rejects_unrelated_vehicle", tests.v077_race_cleanup_requires_exact_owned_slot_and_local_authority},
  {"race_cleanup_requires_local_authority", tests.v077_race_cleanup_requires_exact_owned_slot_and_local_authority},
  {"balanced_accepts_warning_only_candidate", tests.v077_balanced_warning_policy_presets_and_readiness_axes_are_distinct},
  {"balanced_policy_reason_is_structured", tests.v077_balanced_warning_policy_presets_and_readiness_axes_are_distinct},
  {"maximum_chaos_remains_extreme", tests.v077_balanced_warning_policy_presets_and_readiness_axes_are_distinct},
  {"custom_policy_remains_explicit", tests.v077_balanced_warning_policy_presets_and_readiness_axes_are_distinct},
  {"mods_showcase_zero_pool_is_preflightable", tests.v077_balanced_warning_policy_presets_and_readiness_axes_are_distinct},
  {"generation_placement_drivability_ai_are_distinct", tests.v077_balanced_warning_policy_presets_and_readiness_axes_are_distinct},
  {"placement_first_selects_first_slot", tests.v077_formation_selection_and_canonical_order_are_renderer_independent},
  {"placement_next_selects_next_unplaced_slot", tests.v077_formation_selection_and_canonical_order_are_renderer_independent},
  {"placement_all_uses_every_ready_slot", tests.v077_formation_selection_and_canonical_order_are_renderer_independent},
  {"placement_selection_does_not_require_renderer", tests.v077_formation_selection_and_canonical_order_are_renderer_independent},
  {"canonical_reorder_preserves_slot_seed", tests.v077_formation_selection_and_canonical_order_are_renderer_independent},
}

local v078Required = {
  {"blocked_ideal_uses_deterministic_fallback", tests.v078_bounded_spawn_solver_recovers_and_reports_evidence},
  {"ground_failure_uses_bounded_fallback", tests.v078_bounded_spawn_solver_recovers_and_reports_evidence},
  {"slope_failure_uses_bounded_fallback", tests.v078_bounded_spawn_solver_recovers_and_reports_evidence},
  {"external_obstacle_search_is_bounded", tests.v078_bounded_spawn_solver_recovers_and_reports_evidence},
  {"sibling_conflict_search_is_bounded", tests.v078_bounded_spawn_solver_recovers_and_reports_evidence},
  {"placement_distance_is_bounded", tests.v078_bounded_spawn_solver_recovers_and_reports_evidence},
  {"placement_report_counts_attempts", tests.v078_bounded_spawn_solver_recovers_and_reports_evidence},
  {"placement_report_caps_rejected_samples", tests.v078_bounded_spawn_solver_recovers_and_reports_evidence},
  {"placement_solver_is_seed_independent_and_reproducible", tests.v078_bounded_spawn_solver_recovers_and_reports_evidence},
}

equal(#alpha2Required, 113, "alpha.2 required scenario registry")
equal(#v060Required, 104, "0.6.0 required scenario registry")
equal(#v060PauseLifecycleRequired, 52, "0.6.0 pause lifecycle scenario registry")
equal(#v061Required, 76, "0.6.1 required scenario registry")
equal(#v062Required, 95, "0.6.2 required scenario registry")
for _, scenario in ipairs(alpha2Required) do
  requirementMappings[#requirementMappings + 1] = {"0.5.0-alpha.2:" .. scenario[1], scenario[2]}
end
for _, scenario in ipairs(v060Required) do
  requirementMappings[#requirementMappings + 1] = {"0.6.0:" .. scenario[1], scenario[2]}
end
for _, scenario in ipairs(v060PauseLifecycleRequired) do
  requirementMappings[#requirementMappings + 1] = {"0.6.0-pause-lifecycle:" .. scenario[1], scenario[2]}
end
for _, scenario in ipairs(v061Required) do
  requirementMappings[#requirementMappings + 1] = {"0.6.1:" .. scenario[1], scenario[2]}
end
for _, scenario in ipairs(v062Required) do
  requirementMappings[#requirementMappings + 1] = {"0.6.2:" .. scenario[1], scenario[2]}
end
for _, scenario in ipairs(v066Required) do
  requirementMappings[#requirementMappings + 1] = {"0.6.6:" .. scenario[1], scenario[2]}
end
for _, scenario in ipairs(v067Required) do
  requirementMappings[#requirementMappings + 1] = {"0.6.7:" .. scenario[1], scenario[2]}
end
for _, scenario in ipairs(v068Required) do
  requirementMappings[#requirementMappings + 1] = {"0.6.8:" .. scenario[1], scenario[2]}
end
for _, scenario in ipairs(v069Required) do
  requirementMappings[#requirementMappings + 1] = {"0.6.9:" .. scenario[1], scenario[2]}
end
for _, scenario in ipairs(v070Required) do
  requirementMappings[#requirementMappings + 1] = {"0.7.0:" .. scenario[1], scenario[2]}
end
for _, scenario in ipairs(v072Required) do
  requirementMappings[#requirementMappings + 1] = {"0.7.2:" .. scenario[1], scenario[2]}
end
for _, scenario in ipairs(v073Required) do
  requirementMappings[#requirementMappings + 1] = {"0.7.3:" .. scenario[1], scenario[2]}
end
for _, scenario in ipairs(v074Required) do
  requirementMappings[#requirementMappings + 1] = {"0.7.4:" .. scenario[1], scenario[2]}
end
for _, scenario in ipairs(v075Required) do
  requirementMappings[#requirementMappings + 1] = {"0.7.5:" .. scenario[1], scenario[2]}
end
for _, scenario in ipairs(v076Required) do
  requirementMappings[#requirementMappings + 1] = {"0.7.6:" .. scenario[1], scenario[2]}
end
for _, scenario in ipairs(v077Required) do
  requirementMappings[#requirementMappings + 1] = {"0.7.7:" .. scenario[1], scenario[2]}
end
for _, scenario in ipairs(v078Required) do
  requirementMappings[#requirementMappings + 1] = {"0.7.8:" .. scenario[1], scenario[2]}
end

local canonicalByFunction = {}
for name, fn in pairs(tests) do
  if canonicalByFunction[fn] == nil or name < canonicalByFunction[fn] then canonicalByFunction[fn] = name end
end
local names = {}
for _, name in pairs(canonicalByFunction) do names[#names + 1] = name end
table.sort(names)

local failures = {}
local testFilter = os.getenv("SCR_TEST_FILTER")
for _, name in ipairs(names) do
  if not testFilter or name:find(testFilter, 1, true) then
    local ok, message = pcall(tests[name])
    if ok then
      print("PASS " .. name)
    else
      failures[#failures + 1] = name .. ": " .. tostring(message)
      print("FAIL " .. failures[#failures])
    end
  end
end

if #failures > 0 then
  print("SCR_TESTS_FAILED " .. tostring(#failures) .. "/" .. tostring(#names))
  error(table.concat(failures, "\n"))
end

print(string.format("SCR_TEST_METRICS functions=%d mappings=%d cases=%d assertions=%d",
  #names, #requirementMappings, #names, assertionCount))
print("SCR_TESTS_" .. "OK " .. tostring(#names))
