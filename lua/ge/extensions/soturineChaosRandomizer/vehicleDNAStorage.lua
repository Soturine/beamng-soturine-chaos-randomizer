local util = require("ge/extensions/soturineChaosRandomizer/util")
local schema = require("ge/extensions/soturineChaosRandomizer/vehicleDNASchema")
local fingerprint = require("ge/extensions/soturineChaosRandomizer/vehicleDNAFingerprint")

local M = {}

M.STORE_VERSION = 1
M.DEFAULT_LIMIT = 100
M.MAX_LIMIT = 100
M.MAX_TOTAL_BYTES = 1048576

local function create(limit)
  return {
    kind = "soturineVehicleDNALibrary",
    storeVersion = M.STORE_VERSION,
    revision = 0,
    limit = math.max(1, math.min(M.MAX_LIMIT, math.floor(tonumber(limit) or M.DEFAULT_LIMIT))),
    entries = {},
  }
end

local function normalizeLibrary(library, limit)
  if type(library) ~= "table" or library.kind ~= "soturineVehicleDNALibrary"
    or tonumber(library.storeVersion) ~= M.STORE_VERSION or type(library.entries) ~= "table"
  then return nil, "dna_library_invalid" end
  local normalized = create(limit or library.limit)
  normalized.revision = math.max(0, math.floor(tonumber(library.revision) or 0))
  local seen = {}
  for _, entry in ipairs(library.entries) do
    local valid, reason = schema.validateEntry(entry)
    if not valid then return nil, reason end
    if seen[entry.id] then return nil, "dna_library_duplicate_id" end
    seen[entry.id] = true
    normalized.entries[#normalized.entries + 1] = util.deepCopy(entry)
  end
  if #normalized.entries > normalized.limit then
    return nil, "dna_library_entry_limit"
  end
  local canonical, canonicalError = fingerprint.canonicalize(normalized, {maxElements = 30000, maxStringLength = 4096})
  if not canonical then return nil, canonicalError end
  if #canonical > M.MAX_TOTAL_BYTES then return nil, "dna_library_size_limit" end
  return normalized, nil, {canonicalBytes = #canonical}
end

local function find(library, id)
  for index, entry in ipairs(type(library) == "table" and library.entries or {}) do
    if entry.id == id then return util.deepCopy(entry), index end
  end
  return nil
end

local function uniqueId(library, requested)
  local base = tostring(requested or "dna"):gsub("[^A-Za-z0-9_-]", "-"):sub(1, 96)
  if base == "" then base = "dna" end
  local candidate = base
  local suffix = 2
  while find(library, candidate) do
    candidate = base .. "-" .. suffix
    suffix = suffix + 1
  end
  return candidate
end

local function add(library, entry)
  local current, libraryError = normalizeLibrary(library)
  if not current then return nil, libraryError end
  local valid, entryError = schema.validateEntry(entry)
  if not valid then return nil, entryError end
  if #current.entries >= current.limit then return nil, "dna_library_entry_limit" end
  local copy = util.deepCopy(entry)
  copy.id = uniqueId(current, copy.id)
  current.entries[#current.entries + 1] = copy
  current.revision = current.revision + 1
  local normalized, reason = normalizeLibrary(current)
  return normalized, reason, copy.id
end

local function remove(library, id)
  local current, err = normalizeLibrary(library)
  if not current then return nil, err end
  local _, index = find(current, id)
  if not index then return nil, "dna_not_found" end
  table.remove(current.entries, index)
  current.revision = current.revision + 1
  return current
end

local function rename(library, id, name)
  local current, err = normalizeLibrary(library)
  if not current then return nil, err end
  local entry, index = find(current, id)
  if not index then return nil, "dna_not_found" end
  local normalizedName = tostring(name or ""):gsub("[%z\1-\31]", " "):gsub("^%s+", ""):gsub("%s+$", ""):sub(1, schema.MAX_NAME_LENGTH)
  if normalizedName == "" then return nil, "dna_name_invalid" end
  entry.name = normalizedName
  entry.updatedAt = os.time()
  current.entries[index] = entry
  current.revision = current.revision + 1
  return current
end

local function setFavorite(library, id, favorite)
  local current, err = normalizeLibrary(library)
  if not current then return nil, err end
  local entry, index = find(current, id)
  if not index then return nil, "dna_not_found" end
  entry.favorite = favorite == true
  entry.updatedAt = os.time()
  current.entries[index] = entry
  current.revision = current.revision + 1
  return current
end

local function summaries(library, offset, limit)
  offset = math.max(0, math.floor(tonumber(offset) or 0))
  limit = math.max(1, math.min(25, math.floor(tonumber(limit) or 10)))
  local values = {}
  for _, entry in ipairs(type(library) == "table" and library.entries or {}) do values[#values + 1] = entry end
  table.sort(values, function(a, b)
    if a.favorite ~= b.favorite then return a.favorite == true end
    if a.updatedAt ~= b.updatedAt then return (a.updatedAt or 0) > (b.updatedAt or 0) end
    return a.id < b.id
  end)
  local result = {}
  for index = offset + 1, math.min(#values, offset + limit) do
    local entry = values[index]
    result[#result + 1] = {
      id = entry.id,
      name = entry.name,
      modelKey = entry.final and entry.final.modelKey,
      seed = entry.generation and entry.generation.seed,
      operation = entry.generation and entry.generation.operation,
      createdAt = entry.createdAt,
      updatedAt = entry.updatedAt,
      favorite = entry.favorite == true,
      validationStatus = entry.validation and entry.validation.status or "unknown",
    }
  end
  return result, #values
end

M.create = create
M.normalizeLibrary = normalizeLibrary
M.find = find
M.add = add
M.remove = remove
M.rename = rename
M.setFavorite = setFavorite
M.summaries = summaries
M.uniqueId = uniqueId

return M
