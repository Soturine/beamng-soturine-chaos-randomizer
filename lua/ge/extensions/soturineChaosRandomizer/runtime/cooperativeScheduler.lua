local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local function create(options)
  options = type(options) == "table" and options or {}
  return {
    queue = {},
    head = 1,
    queuedKeys = {},
    limit = math.max(4, math.min(64, math.floor(tonumber(options.limit) or 32))),
    executed = 0,
    yieldedFrames = 0,
    dropped = 0,
    lastKind = nil,
  }
end

local function enqueue(state, kind, key, payload)
  if type(kind) ~= "string" or kind == "" then return false, "scheduler_kind_invalid" end
  key = tostring(key or kind)
  if state.queuedKeys[key] then return true, "scheduler_already_queued" end
  local pending = #state.queue - state.head + 1
  if pending >= state.limit then state.dropped = state.dropped + 1; return false, "scheduler_queue_limit" end
  state.queue[#state.queue + 1] = {kind = kind, key = key, payload = util.deepCopy(payload)}
  state.queuedKeys[key] = true
  return true, "scheduler_enqueued"
end

local function tick(state, handler, options)
  options = type(options) == "table" and options or {}
  local maxSteps = math.max(1, math.min(2, math.floor(tonumber(options.maxSteps) or 1)))
  local clock = type(options.clock) == "function" and options.clock or os.clock
  local budgetSeconds = math.max(0.00005, (tonumber(options.budgetMs) or 0.5) / 1000)
  local started, executed = clock(), 0
  while state.head <= #state.queue and executed < maxSteps
    and clock() - started < budgetSeconds
  do
    local item = state.queue[state.head]
    state.head = state.head + 1
    state.queuedKeys[item.key] = nil
    executed = executed + 1
    state.executed = state.executed + 1
    state.lastKind = item.kind
    handler(item.kind, util.deepCopy(item.payload), item.key)
  end
  if state.head > #state.queue then
    state.queue, state.head = {}, 1
  elseif state.head > 32 then
    local compact = {}
    for index = state.head, #state.queue do compact[#compact + 1] = state.queue[index] end
    state.queue, state.head = compact, 1
  end
  local pending = math.max(0, #state.queue - state.head + 1)
  if pending > 0 then state.yieldedFrames = state.yieldedFrames + 1 end
  return executed, pending
end

local function clear(state)
  state.queue, state.head, state.queuedKeys = {}, 1, {}
  return true
end

local function snapshot(state)
  return {
    pending = math.max(0, #state.queue - state.head + 1),
    executed = state.executed,
    yieldedFrames = state.yieldedFrames,
    dropped = state.dropped,
    lastKind = state.lastKind,
  }
end

M.create = create
M.enqueue = enqueue
M.tick = tick
M.clear = clear
M.snapshot = snapshot

return M
