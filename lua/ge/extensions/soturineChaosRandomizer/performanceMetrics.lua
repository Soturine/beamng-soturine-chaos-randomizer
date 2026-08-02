local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local DEFAULT_SAMPLE_LIMIT = 256
local DEFAULT_EVENT_LIMIT = 512
local DEFAULT_METRICS = {
  "onUpdate", "targetTracking", "spawnDirector", "aiDirector", "fluidGuard",
  "paintConfirmation", "treeRescan", "raceGeneration", "registryIndexing",
  "uiPublish", "diagnosticsSerialization", "vehicleEnumeration",
  "vehicleDimensionRead", "configVerification", "ownershipCleanup",
  "orphanReaper", "garageLoad", "dnaCompatibility",
}

local function clearArray(values)
  for index = #values, 1, -1 do values[index] = nil end
  return values
end

local function metricState()
  return {
    samples = {}, nextIndex = 1, count = 0, totalMs = 0,
    minMs = nil, maxMs = 0, lastMs = 0,
  }
end

local function toolCapabilities(source)
  source = type(source) == "table" and source or _G or {}
  return {
    timeprobe = type(source.timeprobe) == "table" or type(source.timeprobe) == "function",
    gcprobe = type(source.gcprobe) == "table" or type(source.gcprobe) == "function",
    luaProfiler = type(source.luaProfiler) == "table" or type(source.luaProfiler) == "function",
  }
end

local function create(options)
  options = type(options) == "table" and options or {}
  local state = {
    enabled = options.enabled ~= false,
    sampleLimit = math.max(8, math.floor(tonumber(options.sampleLimit) or DEFAULT_SAMPLE_LIMIT)),
    eventLimit = math.max(16, math.floor(tonumber(options.eventLimit) or DEFAULT_EVENT_LIMIT)),
    categories = {}, events = {}, metricsBuffer = {},
    capabilities = toolCapabilities(options.toolSource),
  }
  local names = type(options.metrics) == "table" and options.metrics or DEFAULT_METRICS
  for _, name in ipairs(names) do
    if type(name) == "string" and name ~= "" and not state.categories[name] then
      state.categories[name] = metricState()
    end
  end
  return state
end

local function setEnabled(state, enabled)
  if type(state) ~= "table" then return false end
  state.enabled = enabled == true
  return state.enabled
end

local function recordOne(state, category, durationMs)
  local metric = state.categories[category]
  if not metric then metric = metricState(); state.categories[category] = metric end
  metric.count = metric.count + 1
  metric.totalMs = metric.totalMs + durationMs
  metric.lastMs = durationMs
  metric.minMs = metric.minMs == nil and durationMs or math.min(metric.minMs, durationMs)
  metric.maxMs = math.max(metric.maxMs, durationMs)
  if #metric.samples < state.sampleLimit then
    metric.samples[#metric.samples + 1] = durationMs
  else
    metric.samples[metric.nextIndex] = durationMs
    metric.nextIndex = metric.nextIndex % state.sampleLimit + 1
  end
end

local function record(state, category, durationMs)
  if type(state) ~= "table" or state.enabled ~= true then return false end
  if type(category) ~= "string" or category == ""
    or not util.isFinite(durationMs) or durationMs < 0
  then return false end
  recordOne(state, category, durationMs)
  -- v0.6.8 exposed this category name; keep it as a measured alias while the
  -- v0.6.9 profiler uses the more precise registryIndexing metric.
  if category == "registryIndexing" then recordOne(state, "indexing", durationMs) end
  return true
end

local function recordEvent(state, category, now)
  if type(state) ~= "table" or state.enabled ~= true or type(category) ~= "string" or category == ""
    or not util.isFinite(now)
  then return false end
  local event = state.events[category]
  if not event then event = {timestamps = {}, nextIndex = 1, count = 0}; state.events[category] = event end
  event.count = event.count + 1
  if #event.timestamps < state.eventLimit then
    event.timestamps[#event.timestamps + 1] = now
  else
    event.timestamps[event.nextIndex] = now
    event.nextIndex = event.nextIndex % state.eventLimit + 1
  end
  return true
end

local function percentile(sorted, ratio)
  if #sorted == 0 then return 0 end
  return sorted[math.max(1, math.ceil(#sorted * ratio))]
end

local function metricSnapshot(state, metric)
  local sorted = clearArray(state.metricsBuffer)
  for index = 1, #metric.samples do sorted[index] = metric.samples[index] end
  table.sort(sorted)
  local value = {
    count = metric.count,
    sampleCount = #sorted,
    totalMs = metric.totalMs,
    minMs = metric.minMs or 0,
    maxMs = metric.maxMs,
    meanMs = metric.count > 0 and metric.totalMs / metric.count or 0,
    p50Ms = percentile(sorted, 0.50),
    p95Ms = percentile(sorted, 0.95),
    p99Ms = percentile(sorted, 0.99),
    lastMs = metric.lastMs,
  }
  -- Compatibility aliases retained for v0.6.8 diagnostics consumers.
  value.p50, value.p95, value.p99, value.max = value.p50Ms, value.p95Ms, value.p99Ms, value.maxMs
  return value
end

local function snapshot(state, now)
  if type(state) ~= "table" then return {enabled = false, categories = {}, eventRates = {}} end
  local result = {
    enabled = state.enabled == true,
    sampleLimit = state.sampleLimit,
    categories = {}, eventRates = {},
    capabilities = util.shallowMerge({}, state.capabilities or {}),
  }
  for _, category in ipairs(util.sortedKeys(state.categories)) do
    result.categories[category] = metricSnapshot(state, state.categories[category])
  end
  now = tonumber(now) or 0
  for _, category in ipairs(util.sortedKeys(state.events)) do
    local event, recent = state.events[category], 0
    for _, timestamp in ipairs(event.timestamps) do
      if timestamp > now - 1 and timestamp <= now then recent = recent + 1 end
    end
    result.eventRates[category] = {count = event.count, perSecond = recent}
  end
  return result
end

local function reset(state)
  if type(state) ~= "table" then return false end
  for name in pairs(state.categories) do state.categories[name] = metricState() end
  state.events = {}
  clearArray(state.metricsBuffer)
  return true
end

local function finish(state, category, startedAt, clock)
  if type(state) ~= "table" or state.enabled ~= true then return false end
  clock = type(clock) == "function" and clock or os.clock
  local endedAt = clock()
  if not util.isFinite(startedAt) or not util.isFinite(endedAt) then return false end
  return record(state, category, math.max(0, (endedAt - startedAt) * 1000))
end

M.DEFAULT_SAMPLE_LIMIT = DEFAULT_SAMPLE_LIMIT
M.DEFAULT_METRICS = DEFAULT_METRICS
M.create = create
M.setEnabled = setEnabled
M.record = record
M.recordEvent = recordEvent
M.snapshot = snapshot
M.export = snapshot
M.reset = reset
M.finish = finish
M.toolCapabilities = toolCapabilities

return M
