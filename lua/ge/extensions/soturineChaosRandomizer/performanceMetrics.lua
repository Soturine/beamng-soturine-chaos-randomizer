local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local DEFAULT_SAMPLE_LIMIT = 256
local DEFAULT_EVENT_LIMIT = 512

local function create(options)
  options = type(options) == "table" and options or {}
  return {
    sampleLimit = math.max(8, math.floor(tonumber(options.sampleLimit) or DEFAULT_SAMPLE_LIMIT)),
    eventLimit = math.max(16, math.floor(tonumber(options.eventLimit) or DEFAULT_EVENT_LIMIT)),
    categories = {}, events = {},
  }
end

local function record(state, category, durationMs)
  if type(state) ~= "table" or type(category) ~= "string" or category == ""
    or not util.isFinite(durationMs) or durationMs < 0
  then return false end
  local metric = state.categories[category]
  if not metric then
    metric = {samples = {}, nextIndex = 1, count = 0, max = 0}
    state.categories[category] = metric
  end
  metric.count = metric.count + 1
  metric.max = math.max(metric.max, durationMs)
  if #metric.samples < state.sampleLimit then
    metric.samples[#metric.samples + 1] = durationMs
  else
    metric.samples[metric.nextIndex] = durationMs
    metric.nextIndex = metric.nextIndex % state.sampleLimit + 1
  end
  return true
end

local function recordEvent(state, category, now)
  if type(state) ~= "table" or type(category) ~= "string" or category == ""
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

local function snapshot(state, now)
  local result = {sampleLimit = state.sampleLimit, categories = {}, eventRates = {}}
  for _, category in ipairs(util.sortedKeys(state.categories)) do
    local metric = state.categories[category]
    local samples = util.deepCopy(metric.samples)
    table.sort(samples)
    result.categories[category] = {
      count = metric.count, sampleCount = #samples,
      p50 = percentile(samples, 0.50), p95 = percentile(samples, 0.95),
      p99 = percentile(samples, 0.99), max = metric.max,
    }
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

M.DEFAULT_SAMPLE_LIMIT = DEFAULT_SAMPLE_LIMIT
M.create = create
M.record = record
M.recordEvent = recordEvent
M.snapshot = snapshot

return M
