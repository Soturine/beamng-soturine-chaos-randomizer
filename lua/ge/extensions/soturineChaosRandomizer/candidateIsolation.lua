local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

-- Produces deterministic small groups. A failing group is split until the
-- culprit is individually proven; no arbitrary first item is blamed.
local function create(changes, maxAttempts)
  local ordered = util.deepCopy(changes or {})
  table.sort(ordered, function(a, b)
    if tostring(a.slotPath) ~= tostring(b.slotPath) then return tostring(a.slotPath) < tostring(b.slotPath) end
    return tostring(a.selectedPart) < tostring(b.selectedPart)
  end)
  return {
    queue = #ordered > 0 and {ordered} or {},
    current = nil,
    confirmed = {},
    suspects = {},
    attempts = 0,
    maxAttempts = tonumber(maxAttempts) or 4096,
  }
end

local function nextBatch(state)
  if state.attempts >= state.maxAttempts then return nil, "candidate_attempt_limit" end
  state.current = table.remove(state.queue, 1)
  if not state.current then return nil, "candidate_isolation_complete" end
  state.attempts = state.attempts + #state.current
  return util.deepCopy(state.current)
end

local function record(state, success, reason)
  local batch = state.current or {}
  state.current = nil
  if success then
    for _, change in ipairs(batch) do
      state.confirmed[#state.confirmed + 1] = util.deepCopy(change)
    end
    return "confirmed"
  end
  if #batch <= 1 then
    if batch[1] then
      local suspect = util.deepCopy(batch[1])
      suspect.reason = reason or "candidate_failed_individually"
      suspect.confidence = "confirmed"
      state.suspects[#state.suspects + 1] = suspect
    end
    return "culprit_confirmed"
  end
  local midpoint = math.floor(#batch / 2)
  local left, right = {}, {}
  for index, change in ipairs(batch) do
    if index <= midpoint then left[#left + 1] = change else right[#right + 1] = change end
  end
  table.insert(state.queue, 1, right)
  table.insert(state.queue, 1, left)
  return "batch_split"
end

M.create = create
M.nextBatch = nextBatch
M.record = record
M.complete = function(state) return state.current == nil and #state.queue == 0 end
M.metrics = function(state)
  return {attempts = state.attempts, confirmed = #state.confirmed, suspects = #state.suspects, pendingBatches = #state.queue}
end

return M
