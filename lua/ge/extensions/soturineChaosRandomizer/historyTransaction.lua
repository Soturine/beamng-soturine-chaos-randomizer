local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local function capture(active, snapshot)
  if type(active) ~= "table" or type(snapshot) ~= "table" then return false end
  active.originalState = util.deepCopy(snapshot)
  return true
end

local function commit(active, history, push)
  if type(active) ~= "table" or active.kind == "undo" then return true, false end
  if active.historyCommitted then return true, false end
  if type(active.originalState) ~= "table" then return false, false end
  if not push(history, active.originalState) then return false, false end
  active.historyCommitted = true
  active.destructiveStarted = true
  return true, true
end

local function rollbackSucceeded(active, history, pop)
  if type(active) ~= "table" or not active.historyCommitted then return false end
  pop(history)
  active.historyCommitted = false
  return true
end

M.capture = capture
M.commit = commit
M.rollbackSucceeded = rollbackSucceeded

return M
