local util = require("ge/extensions/soturineChaosRandomizer/util")
local schema = require("ge/extensions/soturineChaosRandomizer/lineupSchema")

local M = {}

local function create(limit)
  return {kind = "soturineChaosLineupLibrary", lineupSchemaVersion = schema.SCHEMA_VERSION, limit = math.max(1, math.min(50, tonumber(limit) or 20)), entries = {}, revision = 0}
end

local function add(library, lineup)
  local valid, reason = schema.validate(lineup, {allowOne = true})
  if not valid then return false, reason end
  local copy = util.deepCopy(lineup)
  copy.active, copy.nextIndex = nil, nil
  for index = #library.entries, 1, -1 do if library.entries[index].id == copy.id then table.remove(library.entries, index) end end
  table.insert(library.entries, 1, copy)
  while #library.entries > library.limit do table.remove(library.entries) end
  library.revision = library.revision + 1
  return true, copy
end

local function load(value, limit)
  if type(value) ~= "table" or value.kind ~= "soturineChaosLineupLibrary" or type(value.entries) ~= "table" then return create(limit), "empty" end
  local library = create(limit or value.limit)
  for _, lineup in ipairs(value.entries) do if schema.validate(lineup, {allowOne = true}) then library.entries[#library.entries + 1] = util.deepCopy(lineup) end end
  library.revision = math.max(0, math.floor(tonumber(value.revision) or 0))
  return library, "loaded"
end

M.create = create
M.add = add
M.load = load

return M
