local root = rawget(_G, "SCR_TEST_ROOT") or os.getenv("SCR_TEST_VFS_ROOT") or "."
package.path = root .. "/?.lua;" .. root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path

local adaptivePolling = require("ge/extensions/soturineChaosRandomizer/adaptivePolling")
local bufferPool = require("ge/extensions/soturineChaosRandomizer/vehicleBufferPool")
local contentIndex = require("ge/extensions/soturineChaosRandomizer/contentIndex")
local diagnostics = require("ge/extensions/soturineChaosRandomizer/diagnostics")
local mutationEngine = require("ge/extensions/soturineChaosRandomizer/mutationEngine")
local mutationPolicy = require("ge/extensions/soturineChaosRandomizer/mutationPolicy")
local registryCache = require("ge/extensions/soturineChaosRandomizer/registryCache")
local rng = require("ge/extensions/soturineChaosRandomizer/rng")
local slotScanner = require("ge/extensions/soturineChaosRandomizer/slotScanner")
local spawnDirector = require("ge/extensions/soturineChaosRandomizer/spawnDirector")
local uiPublisher = require("ge/extensions/soturineChaosRandomizer/uiPublisher")
local vehicleDNAStorage = require("ge/extensions/soturineChaosRandomizer/vehicleDNAStorage")

local clock = type(os.clockhp) == "function" and os.clockhp or os.clock

local function percentile(sorted, ratio)
  return sorted[math.max(1, math.ceil(#sorted * ratio))] or 0
end

local function measure(name, iterations, callback, counters)
  local samples, total = {}, 0
  collectgarbage("collect")
  for iteration = 1, iterations do
    local started = clock()
    callback(iteration)
    local elapsed = math.max(0, (clock() - started) * 1000)
    samples[iteration], total = elapsed, total + elapsed
  end
  table.sort(samples)
  counters = type(counters) == "function" and counters() or counters or {}
  print(string.format(
    "SCR_V069_BENCH|%s|%d|%.6f|%.6f|%.6f|%.6f|%.6f|%d|%d|%d",
    name, iterations, total, total / iterations,
    percentile(samples, 0.50), percentile(samples, 0.95), percentile(samples, 0.99),
    counters.bufferReuses or 0, counters.guihooksCount or 0, counters.diagnosticCount or 0
  ))
end

local pool = bufferPool.create({"vehicleIdsBuffer"})
local polling = adaptivePolling.create({fastInterval = 0.01, slowInterval = 0.5}, 0)
measure("idle", 2000, function(iteration)
  local values, generation = assert(bufferPool.acquire(pool, "vehicleIdsBuffer"))
  values[1] = iteration
  bufferPool.release(pool, "vehicleIdsBuffer", generation)
  if adaptivePolling.due(polling, iteration, 0) then adaptivePolling.observed(polling, iteration, false, 0) end
end, function() return {bufferReuses = bufferPool.snapshot(pool).reuses} end)

local tree = {chosenPartName = "root", children = {}}
for slot = 1, 24 do
  local candidates = {}
  for candidate = 1, 8 do candidates[candidate] = "part_" .. slot .. "_" .. candidate end
  tree.children["slot_" .. slot] = {
    id = "slot_" .. slot, path = "/slot_" .. slot .. "/", chosenPartName = candidates[1],
    suitablePartNames = candidates, children = {},
  }
end
local scan = assert(slotScanner.scan(tree, {}))
local chaosPolicy = mutationPolicy.fromSettings({chaos = 100, allowMissingParts = true})
measure("Chaos active", 300, function(iteration)
  mutationEngine.plan(scan, nil, chaosPolicy, rng.new("v069-chaos:" .. iteration), {passNumber = 1})
end)

local frame = {
  position = {x = 0, y = 0, z = 1}, right = {x = 1, y = 0, z = 0},
  forward = {x = 0, y = 1, z = 0}, playerForward = {x = 0, y = 1, z = 0},
}
local function ground(position)
  return true, {point = {x = position.x, y = position.y, z = 0}, normal = {x = 0, y = 0, z = 1}}
end
for _, count in ipairs({4, 8, 12}) do
  measure("Race " .. count, 300, function()
    assert(spawnDirector.plan(frame, {
      mode = "Staggered Grid", count = count, columns = 3, spacingMode = "automatic",
      vehicleDimensions = {}, availableWidth = 40, safetyMargin = 2.5,
    }, ground, {}))
  end)
end

local function garage(entries)
  local library = {entries = {}}
  for index = 1, entries do
    library.entries[index] = {
      id = "dna-" .. index, name = string.format("Garage Vehicle %04d", index),
      createdAt = index, updatedAt = entries - index, favorite = index % 7 == 0,
      pinned = index % 31 == 0, rating = index % 6, tags = {"synthetic", "v069"},
      collection = index % 2 == 0 and "even" or "odd", sortOrder = index,
      base = {configKey = "base", configPath = "/vehicles/fixture/base.pc", sourceKind = "official"},
      final = {modelKey = "fixture_" .. (index % 20), paints = {}},
      generation = {seed = "SCR6-0000-0001", operation = "fullRandom"},
      validation = {status = "captured"}, dependencies = {}, deviations = {}, lineage = {},
    }
  end
  return library
end
local garage100, garage500 = garage(100), garage(500)
measure("Garage 100 entries", 300, function()
  vehicleDNAStorage.query(garage100, {search = "vehicle", sort = "name", offset = 0, limit = 8})
end)
measure("Garage 500 entries", 150, function()
  vehicleDNAStorage.query(garage500, {search = "vehicle", sort = "name", offset = 0, limit = 8})
end)

local diagnosticNow = 0
local diagnosticState = diagnostics.create(function() end, {
  clock = function() return diagnosticNow or 0 end, limit = 200, rateLimitSeconds = 2,
})
for index = 1, 200 do
  diagnosticNow = index
  diagnostics.write(diagnosticState, index % 17 == 0 and "E" or "W", "fixture-" .. index, {
    stage = "synthetic", payload = string.rep("x", 64),
  }, true)
end
local closedUI = uiPublisher.create({debounceSeconds = 0})
measure("Details closed", 1000, function(iteration)
  diagnostics.snapshot(diagnosticState, {compact = true, limit = 8})
  uiPublisher.note(closedUI, "partial", 256, iteration)
end, function()
  return {guihooksCount = uiPublisher.snapshot(closedUI, 1000).guihooksCount, diagnosticCount = 200}
end)
local openUI = uiPublisher.create({debounceSeconds = 0})
measure("Details open", 300, function(iteration)
  diagnostics.export(diagnosticState, {compact = false, limit = 200})
  uiPublisher.note(openUI, "full", 32768, iteration)
end, function()
  return {guihooksCount = uiPublisher.snapshot(openUI, 300).guihooksCount, diagnosticCount = 200}
end)

local fingerprint = assert(registryCache.fingerprint({
  beamNGVersion = "0.39.2", modVersion = "0.6.9", registryShapeVersion = 1,
  activeModsFingerprint = "synthetic", contentAliasesVersion = 1, settingsSchema = 8,
}))
local cachedEnvelope = registryCache.envelope(fingerprint, {
  models = {{key = "fixture"}}, configurations = {{modelKey = "fixture", key = "base"}},
})
measure("index cache hit", 1000, function()
  assert(registryCache.validate(cachedEnvelope, fingerprint, 2048))
end)

local models, configs = {}, {}
for modelIndex = 1, 250 do
  local modelKey = string.format("benchmark_model_%03d", modelIndex)
  models[modelKey] = {key = modelKey, Source = "BeamNG - Official", Type = "Car"}
  for configIndex = 1, 10 do
    local configKey = string.format("benchmark_config_%03d_%02d", modelIndex, configIndex)
    configs[configKey] = {model_key = modelKey, key = configKey, Source = "BeamNG - Official"}
  end
end
measure("index full rebuild", 20, function()
  local index = contentIndex.create()
  assert(contentIndex.build(index, models, configs, 0, {}))
end)

print("SCR_V069_BENCH_OK 11")
