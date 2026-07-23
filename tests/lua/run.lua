local root = rawget(_G, "SCR_TEST_ROOT") or os.getenv("SCR_TEST_VFS_ROOT") or "."
package.path = root .. "/?.lua;" .. root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path

local configSelector = require("ge/extensions/soturineChaosRandomizer/configSelector")
local adapter = require("ge/extensions/soturineChaosRandomizer/apiAdapter")
local capabilities = require("ge/extensions/soturineChaosRandomizer/capabilities")
local contentIndex = require("ge/extensions/soturineChaosRandomizer/contentIndex")
local failureAttribution = require("ge/extensions/soturineChaosRandomizer/failureAttribution")
local history = require("ge/extensions/soturineChaosRandomizer/history")
local historyTransaction = require("ge/extensions/soturineChaosRandomizer/historyTransaction")
local lifecycle = require("ge/extensions/soturineChaosRandomizer/lifecycle")
local mutationEngine = require("ge/extensions/soturineChaosRandomizer/mutationEngine")
local mutationPolicy = require("ge/extensions/soturineChaosRandomizer/mutationPolicy")
local operationState = require("ge/extensions/soturineChaosRandomizer/operationState")
local rng = require("ge/extensions/soturineChaosRandomizer/rng")
local settings = require("ge/extensions/soturineChaosRandomizer/settings")
local slotScanner = require("ge/extensions/soturineChaosRandomizer/slotScanner")
local stressRunner = require("ge/extensions/soturineChaosRandomizer/stressRunner")
local tuning = require("ge/extensions/soturineChaosRandomizer/tuningRandomizer")
local util = require("ge/extensions/soturineChaosRandomizer/util")
local validator = require("ge/extensions/soturineChaosRandomizer/validator")
local vehicleSelector = require("ge/extensions/soturineChaosRandomizer/vehicleSelector")
local fixtures = require("tests/lua/fixtures/content")

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

tests.deterministic_prng = function()
  local left = rng.new("test-seed")
  local right = rng.new("test-seed")
  for _ = 1, 20 do equal(left:nextUInt(), right:nextUInt()) end
  local other = rng.new("different-seed")
  truthy(left:nextUInt() ~= other:nextUInt(), "different seeds should diverge")
end

tests.seed_normalization = function()
  equal(rng.normalizeSeed("  test-seed  "), rng.normalizeSeed("test-seed"))
  truthy(rng.normalizeSeed("test-seed"):match("^%x%x%x%x%-%x%x%x%x$") ~= nil)
  equal(rng.new("8F31-A902").seed, rng.new("8f31a902").seed)
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
  equal(migrated.schemaVersion, 2)
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
  local ok, err = adapter.applyPaints({{baseColor = {1, 1, 1, 1}}})
  core_vehicle_partmgmt = original
  equal(ok, false)
  equal(err.code, "paint_apply_unconfirmed")
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
  truthy(decisions[1].reason:find("critical_current_preserved", 1, true) == 1)
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
  equal(value.schemaVersion, 2)
  equal(value.protectCriticalParts, true)
  equal(value.keepVehicleDrivable, nil)
end

tests.protection_reason_is_exposed = function()
  local valid, reason = validator.validateSelection({
    id = "wheel", description = "Wheel", currentPart = "wheel_a", defaultPart = "wheel_a",
    candidates = {"wheel_a", "wheel_b"},
  }, "wheel_b", true)
  equal(valid, false)
  truthy(reason:find("critical_candidate_unproven", 1, true) == 1)
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
  equal(index.suspects.part[contentIndex.identifier("part", context)], 1)
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
  equal(reason, "config_mismatch")
  local paintExpectation = lifecycle.createExpectation({phase = "undo", paints = fixtures.paints.one})
  local paintVerified, paintReason = lifecycle.verify(paintExpectation, {paints = fixtures.paints.three})
  equal(paintVerified, false)
  equal(paintReason, "paint_state_mismatch")
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

tests.all_lua_sources_compile = function()
  local paths = {
    "/lua/ge/extensions/soturineChaosRandomizer.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/apiAdapter.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/capabilities.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/configSelector.lua",
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
    "/lua/ge/extensions/soturineChaosRandomizer/rng.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/settings.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/slotScanner.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/stressRunner.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/tuningRandomizer.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/util.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/validator.lua",
    "/lua/ge/extensions/soturineChaosRandomizer/vehicleSelector.lua",
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
