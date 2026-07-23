local root = os.getenv("SCR_TEST_VFS_ROOT") or "."
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path

local configSelector = require("ge/extensions/soturineChaosRandomizer/configSelector")
local contentIndex = require("ge/extensions/soturineChaosRandomizer/contentIndex")
local history = require("ge/extensions/soturineChaosRandomizer/history")
local mutationEngine = require("ge/extensions/soturineChaosRandomizer/mutationEngine")
local mutationPolicy = require("ge/extensions/soturineChaosRandomizer/mutationPolicy")
local operationState = require("ge/extensions/soturineChaosRandomizer/operationState")
local rng = require("ge/extensions/soturineChaosRandomizer/rng")
local settings = require("ge/extensions/soturineChaosRandomizer/settings")
local slotScanner = require("ge/extensions/soturineChaosRandomizer/slotScanner")
local tuning = require("ge/extensions/soturineChaosRandomizer/tuningRandomizer")
local util = require("ge/extensions/soturineChaosRandomizer/util")
local validator = require("ge/extensions/soturineChaosRandomizer/validator")
local vehicleSelector = require("ge/extensions/soturineChaosRandomizer/vehicleSelector")

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
    allowMissingParts = true, emptySlotChance = 1, keepVehicleDrivable = false,
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
    allowMissingParts = true, emptySlotChance = 1, keepVehicleDrivable = false,
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
    allowMissingParts = false, emptySlotChance = 0, keepVehicleDrivable = false,
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
  equal(migrated.schemaVersion, 1)
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

print("SCR_TESTS_OK " .. tostring(#names))
