local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local function create(limit)
  return {
    limit = math.max(1, math.floor(tonumber(limit) or 10)),
    entries = {},
  }
end

local function setLimit(history, limit)
  history.limit = math.max(1, math.floor(tonumber(limit) or history.limit or 10))
  while #history.entries > history.limit do
    table.remove(history.entries, 1)
  end
end

local function push(history, entry)
  if type(entry) ~= "table" then return false end
  history.entries[#history.entries + 1] = util.deepCopy(entry)
  while #history.entries > history.limit do
    table.remove(history.entries, 1)
  end
  return true
end

local function peek(history)
  local entry = history.entries[#history.entries]
  return entry and util.deepCopy(entry) or nil
end

local function pop(history)
  local entry = table.remove(history.entries)
  return entry and util.deepCopy(entry) or nil
end

local function summaries(history)
  local result = {}
  for index = #history.entries, 1, -1 do
    local entry = history.entries[index]
    result[#result + 1] = {
      modelKey = entry.modelKey,
      operationType = entry.operationType,
      seed = entry.seed,
      timestamp = entry.timestamp,
    }
  end
  return result
end

M.create = create
M.setLimit = setLimit
M.push = push
M.peek = peek
M.pop = pop
M.summaries = summaries

return M
