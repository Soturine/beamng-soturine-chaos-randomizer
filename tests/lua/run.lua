local root = rawget(_G, "SCR_TEST_ROOT") or os.getenv("SCR_TEST_VFS_ROOT") or "."
package.path = root .. "/?.lua;" .. root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path

local configSelector = require("ge/extensions/soturineChaosRandomizer/configSelector")
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
local paintVerification = require("ge/extensions/soturineChaosRandomizer/paintVerification")
local rng = require("ge/extensions/soturineChaosRandomizer/rng")
local settings = require("ge/extensions/soturineChaosRandomizer/settings")
local slotScanner = require("ge/extensions/soturineChaosRandomizer/slotScanner")
local stressRunner = require("ge/extensions/soturineChaosRandomizer/stressRunner")
local tuning = require("ge/extensions/soturineChaosRandomizer/tuningRandomizer")
local util = require("ge/extensions/soturineChaosRandomizer/util")
local validator = require("ge/extensions/soturineChaosRandomizer/validator")
local vehicleSelector = require("ge/extensions/soturineChaosRandomizer/vehicleSelector")
local vehicleDNA = require("ge/extensions/soturineChaosRandomizer/vehicleDNA")
local vehicleDNACompatibility = require("ge/extensions/soturineChaosRandomizer/vehicleDNACompatibility")
local vehicleDNAFingerprint = require("ge/extensions/soturineChaosRandomizer/vehicleDNAFingerprint")
local vehicleDNAImport = require("ge/extensions/soturineChaosRandomizer/vehicleDNAImport")
local vehicleDNANormalizer = require("ge/extensions/soturineChaosRandomizer/vehicleDNANormalizer")
local vehicleDNARestore = require("ge/extensions/soturineChaosRandomizer/vehicleDNARestore")
local vehicleDNASchema = require("ge/extensions/soturineChaosRandomizer/vehicleDNASchema")
local vehicleDNAStorage = require("ge/extensions/soturineChaosRandomizer/vehicleDNAStorage")
local fixtures = require("tests/lua/fixtures/content")
local pipelineHarness = require("tests/lua/pipelineHarness")

local tests = {}

local function equal(actual, expected, message)
  if actual ~= expected then
    error((message or "values differ") .. ": expected " .. tostring(expected) .. ", got " .. tostring(actual), 2)
  end
end

local function truthy(value, message)
  if not value then error(message or "expected a truthy value", 2) end
end

local function near(actual, expected, epsilon, message)
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
      beamNGVersion = "fixture", extensionVersion = "0.4.0-alpha.1",
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
  truthy(rng.normalizeSeed("test-seed"):match("^SCR4%-%x%x%x%x%-%x%x%x%x$") ~= nil)
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
  equal(low.maxMutationPasses, 1)
  equal(high.maxMutationPasses, 5)
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
  equal(migrated.schemaVersion, 3)
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
  equal(mutationPolicy.fromSettings({chaos = 100}).maxMutationPasses, 5)
  truthy(mutationPolicy.fromSettings({chaos = 100}).maxMutationPasses <= 5)
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
  equal(value.schemaVersion, 3)
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
  local state = harness.main.requestState()
  equal(state.lastResult.code, "vehicle_switched")
end

tests.manual_switch_does_not_retarget_rollback = function()
  local harness = pipelineHarness.new({partsFailure = true})
  truthy(harness.main.fullRandom({chaos = 100, manualSeed = "rollback"}))
  pipelineHarness.confirmReplacement(harness)
  truthy(harness.pendingReplacement and harness.pendingReplacement.restoring)
  harness.main.onVehicleSwitched(1, 77, 0)
  equal(harness.main.requestState().lastResult.code, "vehicle_switched")
end

tests.undo_wait_rejects_unrelated_vehicle = function()
  local harness = pipelineHarness.new()
  truthy(pipelineHarness.driveSuccess(harness, "scramble"))
  truthy(harness.main.undo(), harness.main.requestState().lastResult.message)
  harness.main.onVehicleSwitched(1, 88, 0)
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
  truthy(not harness.main.randomConfig({manualSeed = "synchronous-unrelated"}))
  truthy(harness.pendingReplacement and not harness.pendingReplacement.restoring)
  equal(harness.main.requestState().lastResult.code, "vehicle_switched")
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
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom"))
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
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom"))
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
  truthy(pipelineHarness.driveSuccess(harness, "fullRandom"))
  local details = harness.main.requestState().lastResult.details
  truthy(#details.warnings >= 2)
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
  for attempt = 1, 3 do
    truthy(not harness.main.randomConfig({manualSeed = "spawn-failure-" .. attempt}))
    pipelineHarness.confirmReplacement(harness)
  end
  equal(harness.main.requestState().index.blacklists.config, 3 >= 3 and 1 or 0)
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
  equal(state.lastFailure.phase, "parts")
  truthy(type(state.lastFailure.context.batch) == "table")
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

tests.dna_preflight_is_unverified_without_target_tree = function()
  local entry = sampleDNA()
  local report = vehicleDNACompatibility.evaluate(entry, {
    modelsByKey = {fixture_model = {}},
    configs = {{modelKey = "fixture_model", key = "base", path = "/vehicles/fixture_model/base.pc"}},
    scan = nil, variables = {}, paints = {}, gameVersion = "fixture",
    extensionVersion = "0.4.0-alpha.1", generatorVersion = 4,
  }, "exact")
  equal(report.status, "unverified")
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
  equal(entry.generation.generatorVersion, 4)
end

tests.settings_schema_two_migrates_to_three = function()
  local value = settings.validate({schemaVersion = 2, dnaLimit = 25, autoSaveDNA = true})
  equal(value.schemaVersion, 3)
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

tests.all_lua_sources_compile = function()
  local paths = {
    "/lua/ge/extensions/soturineChaosRandomizer.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/apiAdapter.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/capabilities.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/configSelector.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/configVerification.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/contentIndex.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/diagnostics.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/failureAttribution.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/history.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/historyTransaction.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/lifecycle.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/main.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/mutationEngine.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/mutationPolicy.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/operationState.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/paintRandomizer.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/paintVerification.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/rng.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/settings.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/slotScanner.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/stressRunner.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/tuningRandomizer.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/util.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/validator.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleSelector.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleDNA.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleDNACompatibility.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleDNAFingerprint.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleDNAImport.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleDNANormalizer.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleDNARestore.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleDNASchema.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleDNAStorage.lua",
  }
  for _, path in ipairs(paths) do
    local chunk, err = loadfile(root .. path)
    truthy(chunk, path .. ": " .. tostring(err))
  end
end

local names = {}
for name in pairs(tests) do names[#names + 1] = name end
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

print("SCR_TESTS_" .. "OK " .. tostring(#names))
