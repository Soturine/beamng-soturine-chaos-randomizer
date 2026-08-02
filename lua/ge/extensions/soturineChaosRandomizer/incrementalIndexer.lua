local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local function create()
  return {
    generation = 0, active = nil, last = nil,
    cacheHits = 0, cacheMisses = 0,
  }
end

local function start(state, totalItems, processor, finisher, options)
  if type(processor) ~= "function" or type(finisher) ~= "function" then
    return nil, "indexer_callbacks_invalid"
  end
  if state.active then state.active.cancelled = true end
  state.generation = state.generation + 1
  options = type(options) == "table" and options or {}
  state.active = {
    generation = state.generation, cursor = 0,
    totalItems = math.max(0, math.floor(tonumber(totalItems) or 0)),
    chunks = 0, processed = 0, startedAt = tonumber(options.startedAt) or 0,
    reason = options.reason or "rebuild", processor = processor, finisher = finisher,
    cancelled = false, status = "indexing", lastChunkMs = 0,
  }
  return state.active
end

local function step(state, now, clock, budgetMs, maxItems)
  local job = state.active
  if not job then return false, "indexer_idle" end
  if job.cancelled then state.active = nil; job.status = "cancelled"; state.last = job; return false, "indexer_cancelled" end
  clock = type(clock) == "function" and clock or os.clock
  local started = clock()
  local budgetSeconds = math.max(0.00005, (tonumber(budgetMs) or 1) / 1000)
  maxItems = math.max(1, math.floor(tonumber(maxItems) or 64))
  local processed = 0
  while job.cursor < job.totalItems and processed < maxItems do
    local nextCursor = job.cursor + 1
    local ok, reason = job.processor(nextCursor, job.generation)
    if ok == false then
      job.status, job.failure = "failed", reason or "index_item_failed"
      state.active, state.last = nil, job
      return false, job.failure
    end
    job.cursor, job.processed = nextCursor, job.processed + 1
    processed = processed + 1
    if clock() - started >= budgetSeconds then break end
  end
  job.chunks = job.chunks + 1
  job.lastChunkMs = math.max(0, (clock() - started) * 1000)
  job.progress = job.totalItems > 0 and job.cursor / job.totalItems or 1
  if job.cursor >= job.totalItems then
    local ok, result = job.finisher(job.generation, tonumber(now) or 0)
    job.status, job.result, job.endedAt = ok == false and "failed" or "ready", result, tonumber(now) or 0
    job.totalMs = math.max(0, (job.endedAt - job.startedAt) * 1000)
    state.active, state.last = nil, job
    return ok ~= false, result, true
  end
  return true, {processed = processed, cursor = job.cursor, total = job.totalItems, progress = job.progress}, false
end

local function cancel(state, reason)
  if not state.active then return false, "indexer_idle" end
  state.active.cancelled, state.active.cancelReason = true, reason or "cancelled"
  return true
end

local function snapshot(state)
  local job = state.active or state.last
  return {
    active = state.active ~= nil,
    generation = job and job.generation or state.generation,
    status = job and job.status or "idle", reason = job and job.reason,
    chunks = job and job.chunks or 0, items = job and job.processed or 0,
    totalItems = job and job.totalItems or 0, progress = job and (job.progress or 0) or 0,
    totalMs = job and job.totalMs or 0,
    cacheHits = state.cacheHits, cacheMisses = state.cacheMisses,
  }
end

M.create = create
M.start = start
M.step = step
M.cancel = cancel
M.snapshot = snapshot

return M
