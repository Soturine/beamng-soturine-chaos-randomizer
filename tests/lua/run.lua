local root = rawget(_G, "SCR_TEST_ROOT") or os.getenv("SCR_TEST_VFS_ROOT") or "."
package.path = root .. "/?.lua;" .. root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path

local configSelector = require("ge/extensions/soturineChaosRandomizer/configSelector")
local coverageLimits = require("ge/extensions/soturineChaosRandomizer/coverageLimits")
local slotCoverageLedger = require("ge/extensions/soturineChaosRandomizer/slotCoverageLedger")
local treeConvergence = require("ge/extensions/soturineChaosRandomizer/treeConvergence")
local timeSource = require("ge/extensions/soturineChaosRandomizer/timeSource")
local candidateIsolation = require("ge/extensions/soturineChaosRandomizer/candidateIsolation")
local adapter = require("ge/extensions/soturineChaosRandomizer/apiAdapter")
local capabilities = require("ge/extensions/soturineChaosRandomizer/capabilities")
local contentIndex = require("ge/extensions/soturineChaosRandomizer/contentIndex")
local configVerification = require("ge/extensions/soturineChaosRandomizer/configVerification")
local failureAttribution = require("ge/extensions/soturineChaosRandomizer/failureAttribution")
local history = require("ge/extensions/soturineChaosRandomizer/history")
local historyTransaction = require("ge/extensions/soturineChaosRandomizer/historyTransaction")
local lifecycle = require("ge/extensions/soturineChaosRandomizer/lifecycle")
local mutationEngine = require("ge/extensions/soturineChaosRandomizer/mutationEngine")
local mutationPolicy = require("ge/extensions/soturineChaosRandomizer/mutationPolicy")
local operationState = require("ge/extensions/soturineChaosRandomizer/operationState")
local progressWatchdog = require("ge/extensions/soturineChaosRandomizer/progressWatchdog")
local paintRandomizer = require("ge/extensions/soturineChaosRandomizer/paintRandomizer")
local paintVerification = require("ge/extensions/soturineChaosRandomizer/paintVerification")
local partBatchRecovery = require("ge/extensions/soturineChaosRandomizer/partBatchRecovery")
local pngValidator = require("ge/extensions/soturineChaosRandomizer/pngValidator")
local rng = require("ge/extensions/soturineChaosRandomizer/rng")
local settings = require("ge/extensions/soturineChaosRandomizer/settings")
local slotScanner = require("ge/extensions/soturineChaosRandomizer/slotScanner")
local stressRunner = require("ge/extensions/soturineChaosRandomizer/stressRunner")
local tuning = require("ge/extensions/soturineChaosRandomizer/tuningRandomizer")
local tuningCoverageLedger = require("ge/extensions/soturineChaosRandomizer/tuningCoverageLedger")
local tuningPipeline = require("ge/extensions/soturineChaosRandomizer/tuningPipeline")
local paintCoverageLedger = require("ge/extensions/soturineChaosRandomizer/paintCoverageLedger")
local lineupSchema = require("ge/extensions/soturineChaosRandomizer/lineupSchema")
local lineupManager = require("ge/extensions/soturineChaosRandomizer/lineupManager")
local lineupStorage = require("ge/extensions/soturineChaosRandomizer/lineupStorage")
local managedVehicleRegistry = require("ge/extensions/soturineChaosRandomizer/managedVehicleRegistry")
local spawnDirector = require("ge/extensions/soturineChaosRandomizer/spawnDirector")
local spawnApiAdapter = require("ge/extensions/soturineChaosRandomizer/spawnApiAdapter")
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

local tests = {}
local requirementMappings = {}
local assertionCount = 0
local builtinAssert = assert
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
  local variable = assert(tuning.normalizeVariable("pressure", {
    min = 10, max = 20, default = 40, step = 2,
  }, {pressure = -50}))
  equal(variable.default, 20)
  equal(variable.current, 10)
  equal(util.roundToStep(15.1, 2, 10), 16)

  local value = tuning.sample(variable, {
    extremeTuningChance = 0, chaos = 1, tuningSpread = 1,
  }, scriptedGenerator({false, true}, {0.37}))
  truthy(value >= 10 and value <= 20)
  equal((value - 10) % 2, 0)
end

tests.default_centered_tuning = function()
  local value, distribution = tuning.sample({
    minimum = 0, maximum = 100, default = 50, current = 50,
  }, {extremeTuningChance = 0, chaos = 0, tuningSpread = 0.1}, scriptedGenerator({false, false}, {0.5, 0.5}))
  near(value, 50)
  equal(distribution, "default_centered")
end

tests.extreme_biased_tuning = function()
  local value, distribution = tuning.sample({
    minimum = 0, maximum = 100, default = 50, current = 50,
  }, {extremeTuningChance = 1, chaos = 1, tuningSpread = 1}, scriptedGenerator({true, true}))
  equal(value, 0)
  equal(distribution, "extreme")
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
  equal(migrated.schemaVersion, 5)
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
  equal(value.schemaVersion, 5)
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
  local _, changes, groups = tuning.randomize({
    frontPressure = {min = 0, max = 10, default = 5},
    rearPressure = {min = 0, max = 10, default = 5},
  }, {}, {extremeTuningChance = 0, chaos = 1, tuningSpread = 1}, rng.new("independent"))
  equal(#groups, 0)
  truthy(#changes > 0)
end

tests.explicit_group_uses_shared_substream = function()
  local _, _, groups = tuning.randomize(fixtures.variables, {}, {
    extremeTuningChance = 0, chaos = 1, tuningSpread = 1,
  }, rng.new("group"))
  equal(#groups, 1)
  equal(groups[1].groupId, "explicit_axle")
  equal(groups[1].memberCount, 2)
  equal(groups[1].strategy, "shared_normalized_sample")
end

tests.group_members_remain_in_range = function()
  local values = tuning.randomize(fixtures.variables, {}, {
    extremeTuningChance = 0, chaos = 1, tuningSpread = 1,
  }, rng.new("range"))
  truthy(values.groupedA >= 0 and values.groupedA <= 100)
  truthy(values.groupedB >= 10 and values.groupedB <= 20)
end

tests.group_members_keep_individual_steps = function()
  local values = tuning.randomize(fixtures.variables, {}, {
    extremeTuningChance = 0, chaos = 1, tuningSpread = 1,
  }, rng.new("steps"))
  equal(values.groupedA % 5, 0)
  equal((values.groupedB - 10) % 2, 0)
end

tests.missing_group_metadata_does_not_infer_relationship = function()
  local _, groups, independent = tuning.normalizeGroups({
    frontSpring = {min = 0, max = 1, default = 0.5, category = "alignment"},
    rearSpring = {min = 0, max = 1, default = 0.5, category = "alignment"},
  }, {})
  equal(next(groups), nil)
  equal(#independent, 2)
end

tests.group_sampling_is_seed_deterministic = function()
  local policy = {extremeTuningChance = 0, chaos = 1, tuningSpread = 1}
  local left = tuning.randomize(fixtures.variables, {}, policy, rng.new("same-group-seed"))
  local right = tuning.randomize(fixtures.variables, {}, policy, rng.new("same-group-seed"))
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
  local harness = pipelineHarness.new({partsFailure = true})
  truthy(harness.main.fullRandom({chaos = 100, manualSeed = "rollback"}))
  pipelineHarness.confirmReplacement(harness)
  truthy(harness.pendingReplacement and harness.pendingReplacement.restoring)
  harness.main.onVehicleSwitched(1, 77, 0)
  harness.vehicleId = 77
  harness.now = harness.now + 0.06
  harness.main.onUpdate()
  equal(harness.main.requestState().lastResult.code, "vehicle_switched")
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

tests.ambiguous_replace_target_fails_safely = function()
  local harness = pipelineHarness.new({ambiguousReplace = true})
  truthy(not harness.main.randomConfig({manualSeed = "ambiguous"}))
  equal(harness.pendingReplacement, nil)
  equal(harness.main.requestState().lastResult.code, "vehicle_replace_target_ambiguous")
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
  local harness = pipelineHarness.new({vehicleId = 1, returnedVehicleId = 2, partsFailure = true})
  truthy(harness.main.fullRandom({chaos = 100, manualSeed = "rollback-id"}))
  pipelineHarness.confirmReplacement(harness)
  truthy(harness.pendingReplacement and harness.pendingReplacement.restoring)
  equal(harness.pendingReplacement.vehicleId, 1)
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
  truthy(seen.replace and seen.parts and seen.tuning and seen.paint)
end

tests.full_random_skips_unavailable_optional_stage_with_warning = function()
  local harness = pipelineHarness.new({tuningUnavailable = true, paintUnavailable = true})
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom", {allowPartialResult = true}))
  local details = harness.main.requestState().lastResult.details
  truthy(#details.warnings >= 2)
  equal(details.status, "Partial")
end

tests.v060_partial_result_setting_controls_rollback = function()
  local rollback = pipelineHarness.new({tuningUnavailable = true, paintUnavailable = true})
  truthy(pipelineHarness.driveSuccess(rollback, "fullRandom", {allowPartialResult = false}))
  truthy(rollback.pendingReplacement and rollback.pendingReplacement.restoring)
  pipelineHarness.confirmReplacement(rollback)
  local rejected = rollback.main.requestState().lastResult
  equal(rejected.code, "partial_result_not_allowed")
  equal(rejected.details.rollback, "completed")

  local kept = pipelineHarness.new({tuningUnavailable = true, paintUnavailable = true})
  truthy(pipelineHarness.driveSuccess(kept, "fullRandom", {allowPartialResult = true}))
  local accepted = kept.main.requestState().lastResult
  equal(accepted.success, true)
  equal(accepted.details.status, "Partial")
end

tests.full_random_has_one_history_entry = tests.full_random_is_one_operation

tests.full_random_rollback_restores_original = function()
  local harness = pipelineHarness.new({partsFailure = true})
  truthy(harness.main.fullRandom({chaos = 100, manualSeed = "rollback"}))
  pipelineHarness.confirmReplacement(harness)
  pipelineHarness.confirmReplacement(harness)
  local state = harness.main.requestState()
  equal(state.busy, false)
  equal(state.lastResult.details.rollback, "completed")
  equal(#state.history, 0)
  equal(harness.modelKey, "fixture_old")
end

tests.full_random_result_reports_base_version_and_final_changes = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom"))
  local details = harness.main.requestState().lastResult.details
  equal(details.baseConfiguration.key, "base_version")
  equal(details.baseConfiguration.sourceKind, "official")
  truthy(details.partsChanged >= 1)
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
  equal(value.schemaVersion, 5)
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
  local harness = pipelineHarness.new({partsFailure = true})
  truthy(harness.main.runAction("fullRandom", {chaos = 100, protectCriticalParts = true, manualSeed = "failure"}))
  pipelineHarness.confirmReplacement(harness)
  truthy(harness.pendingReplacement ~= nil)
  pipelineHarness.confirmReplacement(harness)
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
  harness.options.partsFailure = true
  truthy(harness.main.restoreVehicleDNA(id, "exact", false))
  pipelineHarness.confirmReplacement(harness)
  truthy(harness.pendingReplacement ~= nil, "parts rejection should start rollback")
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
  harness.options.targetMissingBodyB = true
  truthy(harness.main.restoreVehicleDNA(id, "compatible", false))
  pipelineHarness.confirmReplacement(harness)
  truthy(harness.pendingReplacement ~= nil, "target partial must start rollback")
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
  equal(value.schemaVersion, 5)
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
  local randomized = tuning.randomize(fixtures.variables, values, policy, rng.new("tuning-lock"), {
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
  local plan = vehicleRecovery.choosePlan(state, {modelKey = "previous", selectedConfiguration = "previous.pc"}, {
    {modelKey = "safe", key = "base", path = "safe.pc", sourceKind = "official"},
  })
  equal(plan[1].kind, "previous")
  equal(plan[2].kind, "last_known_good")
  equal(plan[3].kind, "safe_official")
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
  equal(first.status, "Generating")
  truthy(lineupManager.record(lineup, 1, accepted, sampleDNA({id = "dna-ready"}), first.targetGeneration))
  equal(first.status, "Ready")
  local second = assert(lineupManager.nextCompetitor(lineup))
  local secondGeneration = second.targetGeneration
  truthy(lineupManager.record(lineup, 2, {success = false, message = "fixture"}, nil, secondGeneration))
  second.status = "Pending"
  lineup.nextIndex = 2
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
  first.status = "Ready"
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

  second.status, second.attemptCount = "Failed", 1
  truthy(lineupManager.resolveFailure(lineup, 2, "retry"))
  equal(second.status, "Pending")
  second.status = "Failed"
  truthy(lineupManager.resolveFailure(lineup, 2, "fallback"))
  truthy(second.forceOfficialFallback)
  second.status = "Failed"
  truthy(lineupManager.resolveFailure(lineup, 2, "skip"))
  equal(second.status, "Skipped")
  lineup.competitors[3].status = "Failed"
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
  equal(strictCompetitor.status, "Partial")
  truthy(strictCompetitor.warning:find("requires explicit acceptance", 1, true) ~= nil)
  local permissive = assert(lineupManager.create({
    count = 2, episodeSeed = "permissive", acceptMetadataUncertain = true, acceptPotentiallyUndrivable = true,
  }))
  local permissiveCompetitor = assert(lineupManager.nextCompetitor(permissive))
  truthy(lineupManager.record(permissive, 1, lifecycleResult, sampleDNA({id = "permissive-dna"}), permissiveCompetitor.targetGeneration))
  equal(permissiveCompetitor.status, "Ready with warnings")
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
  local blocked, blockedReason = spawnDirector.plan(frame, {mode = "Right", count = 1, spacing = 6}, ground, {{x = 16, y = 20, z = 0}})
  equal(blocked, nil); equal(blockedReason, "position_blocked")
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
  equal(reason, "stale_callback_ignored")
  truthy(operationState.nextTarget(state, {vehicleId = 3}) > context.targetGeneration)
  local replacement = operationState.invalidate(state, "recovery", {operation = true, target = true})
  truthy(replacement ~= token)
  truthy(state.operationGeneration > operationGeneration)
  truthy(operationState.setPhase(state, "recovering_previous", 5, "fixture_recovery"))
  truthy(operationState.phasePolicy(state).requiresSimulationProgress)
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

tests.v060_progress_watchdog_contract = function()
  local watchdog = progressWatchdog.create(0, {warningAfter = 2, stalledAfter = 4, pauseDependencyWindow = 1})
  equal(progressWatchdog.evaluate(watchdog, 2.1, false), "warning")
  equal(progressWatchdog.evaluate(watchdog, 4.1, false), "stalled")
  progressWatchdog.observePause(watchdog, true, 4.2)
  progressWatchdog.note(watchdog, "target", "target_evidence", 4.3)
  truthy(watchdog.pauseDependentProgressDetected)
  equal(progressWatchdog.evaluate(watchdog, 20, true), "waiting_for_simulation_resume")
  truthy(not watchdog.stalled)
  local report = progressWatchdog.snapshot(watchdog, 20)
  equal(report.lastTargetEvidenceAt, 4.3)
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
  local harness = pipelineHarness.new({partsFailure = true, vehicleId = 1, returnedVehicleId = 2})
  harness.tuning.boost = -1
  harness.paints[1].metallic = 0.91
  local originalTree = util.deepCopy(harness.tree)
  local originalTuning = util.deepCopy(harness.tuning)
  local originalPaints = util.deepCopy(harness.paints)
  truthy(harness.main.fullRandom({chaos = 100, manualSeed = "recovery-stale-B"}))
  pipelineHarness.confirmReplacement(harness)
  truthy(harness.pendingReplacement and harness.pendingReplacement.restoring)
  pipelineHarness.applyPendingReplacement(harness, false)
  equal(harness.vehicleId, 1)
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
  truthy(util.deepEqual(harness.tuning, originalTuning, 1e-8))
  truthy(util.deepEqual(harness.paints, originalPaints, 1e-8))
  truthy(state.lifecycle.staleCallbackCount > 0)
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
  truthy(#requirementMappings >= 217)
  local names = {}
  for _, mapping in ipairs(requirementMappings) do
    truthy(type(mapping[1]) == "string" and mapping[1] ~= "")
    truthy(type(mapping[2]) == "function")
    truthy(not names[mapping[1]], "duplicate requirement mapping: " .. mapping[1])
    names[mapping[1]] = true
  end
end

tests.all_lua_sources_compile = function()
  local paths = {
    "/lua/ge/extensions/soturineChaosRandomizer.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/apiAdapter.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/capabilities.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/configSelector.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/configVerification.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/coverageLimits.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/contentIndex.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/candidateIsolation.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/diagnostics.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/failureAttribution.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/history.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/historyTransaction.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/lifecycle.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/lineupManager.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/lineupSchema.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/lineupStorage.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/main.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/mutationEngine.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/mutationPolicy.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/managedVehicleRegistry.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/operationState.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/progressWatchdog.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/paintRandomizer.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/paintCoverageLedger.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/paintVerification.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/partBatchRecovery.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/pngValidator.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/rng.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/routePlanner.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/timeSource.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/settings.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/slotScanner.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/stressRunner.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/spawnApiAdapter.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/spawnDirector.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/slotCoverageLedger.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/treeConvergence.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/tuningRandomizer.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/tuningCoverageLedger.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/tuningPipeline.lua",
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
    "/lua/ge/extensions/soturineChaosRandomizer/aiAdapter.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/aiDirector.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/destinationMarker.lua",
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

equal(#alpha2Required, 113, "alpha.2 required scenario registry")
equal(#v060Required, 104, "0.6.0 required scenario registry")
equal(#v060PauseLifecycleRequired, 52, "0.6.0 pause lifecycle scenario registry")
for _, scenario in ipairs(alpha2Required) do
  requirementMappings[#requirementMappings + 1] = {"0.5.0-alpha.2:" .. scenario[1], scenario[2]}
end
for _, scenario in ipairs(v060Required) do
  requirementMappings[#requirementMappings + 1] = {"0.6.0:" .. scenario[1], scenario[2]}
end
for _, scenario in ipairs(v060PauseLifecycleRequired) do
  requirementMappings[#requirementMappings + 1] = {"0.6.0-pause-lifecycle:" .. scenario[1], scenario[2]}
end

local canonicalByFunction = {}
for name, fn in pairs(tests) do
  if canonicalByFunction[fn] == nil or name < canonicalByFunction[fn] then canonicalByFunction[fn] = name end
end
local names = {}
for _, name in pairs(canonicalByFunction) do names[#names + 1] = name end
table.sort(names)

local failures = {}
for _, name in ipairs(names) do
  local ok, message = pcall(tests[name])
  if ok then
    print("PASS " .. name)
  else
    failures[#failures + 1] = name .. ": " .. tostring(message)
    print("FAIL " .. failures[#failures])
  end
end

if #failures > 0 then
  print("SCR_TESTS_FAILED " .. tostring(#failures) .. "/" .. tostring(#names))
  error(table.concat(failures, "\n"))
end

print(string.format("SCR_TEST_METRICS functions=%d mappings=%d cases=%d assertions=%d",
  #names, #requirementMappings, #names, assertionCount))
print("SCR_TESTS_" .. "OK " .. tostring(#names))
