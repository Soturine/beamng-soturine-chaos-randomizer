local root = rawget(_G, "SCR_TEST_ROOT") or os.getenv("SCR_TEST_VFS_ROOT") or "."
package.path = root .. "/?.lua;" .. root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path

local contentIndex = require("ge/extensions/soturineChaosRandomizer/contentIndex")
local mutationEngine = require("ge/extensions/soturineChaosRandomizer/mutationEngine")
local mutationPolicy = require("ge/extensions/soturineChaosRandomizer/mutationPolicy")
local rng = require("ge/extensions/soturineChaosRandomizer/rng")
local slotScanner = require("ge/extensions/soturineChaosRandomizer/slotScanner")

local clock = type(os.clockhp) == "function" and os.clockhp or os.clock

local models = {}
local configs = {}
for modelIndex = 1, 500 do
  local modelKey = string.format("profile_model_%04d", modelIndex)
  models[modelKey] = {key = modelKey, Source = "BeamNG - Official", Type = "Car"}
  for configIndex = 1, 10 do
    local configKey = string.format("profile_config_%04d_%02d", modelIndex, configIndex)
    configs[configKey] = {model_key = modelKey, key = configKey, Source = "BeamNG - Official"}
  end
end

local index = contentIndex.create()
local indexStarted = clock()
contentIndex.build(index, models, configs, 0, 0)
local indexDuration = clock() - indexStarted

local tree = {chosenPartName = "root", children = {}}
local node = tree
for depth = 1, 120 do
  local key = "slot" .. depth
  local candidates = {}
  for candidate = 1, 20 do candidates[candidate] = key .. "_part" .. candidate end
  node.children[key] = {
    id = key,
    path = "/" .. string.rep("nested/", depth - 1) .. key .. "/",
    chosenPartName = candidates[1],
    suitablePartNames = candidates,
    children = {},
  }
  node = node.children[key]
end

local scanStarted = clock()
local scan = assert(slotScanner.scan(tree, {}))
local scanDuration = clock() - scanStarted
local planStarted = clock()
mutationEngine.plan(scan, nil, mutationPolicy.fromSettings({chaos = 100}), rng.new("profile"), {passNumber = 1})
local planDuration = clock() - planStarted

print(string.format(
  "SCR_PROFILE models=%d configs=%d index_seconds=%.9f slots=%d depth=%d candidates=%d scan_seconds=%.9f plan_seconds=%.9f",
  #index.models,
  #index.allConfigs,
  indexDuration,
  scan.metrics.slotCount,
  scan.metrics.maxDepth,
  scan.metrics.candidateCount,
  scanDuration,
  planDuration
))
