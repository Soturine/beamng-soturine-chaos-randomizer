local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local function checkpoint(library, lineup, storage)
  if type(library) ~= "table" or type(lineup) ~= "table"
    or type(storage) ~= "table" or type(storage.add) ~= "function"
  then return false, "lineup_persistence_contract_invalid", library end
  local candidateLibrary = util.deepCopy(library)
  local added, result = storage.add(candidateLibrary, lineup)
  if not added then return false, result, library end
  return true, result, candidateLibrary
end

M.checkpoint = checkpoint

return M
