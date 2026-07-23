local util = require("ge/extensions/soturineChaosRandomizer/util")
local schema = require("ge/extensions/soturineChaosRandomizer/vehicleDNASchema")
local fingerprint = require("ge/extensions/soturineChaosRandomizer/vehicleDNAFingerprint")
local gallery = require("ge/extensions/soturineChaosRandomizer/vehicleDNAGallery")

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

local function metrics(library)
  local canonical, reason, canonicalMetrics = fingerprint.canonicalize(library, {maxElements = 30000, maxStringLength = 4096})
  if not canonical then return nil, reason end
  local largestEntryBytes = 0
  for _, entry in ipairs(type(library) == "table" and library.entries or {}) do
    local entryCanonical = fingerprint.canonicalize(entry)
    if entryCanonical then largestEntryBytes = math.max(largestEntryBytes, #entryCanonical) end
  end
  return {
    entryCount = #(library.entries or {}),
    entryLimit = tonumber(library.limit) or M.DEFAULT_LIMIT,
    canonicalBytes = #canonical,
    byteLimit = M.MAX_TOTAL_BYTES,
    elementCount = canonicalMetrics and canonicalMetrics.elements or 0,
    elementLimit = 30000,
    largestEntryBytes = largestEntryBytes,
  }
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
  for childIndex, child in ipairs(current.entries) do
    if type(child.lineage) == "table" and child.lineage.parentId == id then
      child.lineage.parentMissing = true
      child.updatedAt = os.time()
      current.entries[childIndex] = child
    end
  end
  current.revision = current.revision + 1
  return normalizeLibrary(current)
end

local function updateEntry(library, id, updater)
  local current, err = normalizeLibrary(library)
  if not current then return nil, err end
  local entry, index = find(current, id)
  if not index then return nil, "dna_not_found" end
  local updated, updateError = updater(util.deepCopy(entry))
  if not updated then return nil, updateError or "dna_metadata_invalid" end
  updated.updatedAt = os.time()
  local valid, reason = schema.validateEntry(updated)
  if not valid then return nil, reason end
  current.entries[index] = updated
  current.revision = current.revision + 1
  return normalizeLibrary(current)
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
  return updateEntry(library, id, function(entry) entry.favorite = favorite == true; return entry end)
end

local function setPinned(library, id, pinned)
  return updateEntry(library, id, function(entry) entry.pinned = pinned == true; return entry end)
end

local function setRating(library, id, rating)
  rating = rating == nil and nil or math.floor(tonumber(rating) or -1)
  if rating ~= nil and (rating < 0 or rating > 5) then return nil, "dna_rating_invalid" end
  return updateEntry(library, id, function(entry) entry.rating = rating; return entry end)
end

local function cleanText(value, maximum, allowEmpty)
  if type(value) ~= "string" then return nil end
  local result = value:gsub("[%z\1-\31]", " "):gsub("^%s+", ""):gsub("%s+$", ""):sub(1, maximum)
  if result == "" and not allowEmpty then return nil end
  return result
end

local function setTags(library, id, tags)
  if type(tags) ~= "table" or #tags > schema.MAX_TAGS then return nil, "dna_tags_limit" end
  local cleaned, seen = {}, {}
  for _, tag in ipairs(tags) do
    local value = cleanText(tag, 64, false)
    if not value or seen[value:lower()] then return nil, "dna_tag_invalid" end
    seen[value:lower()] = true
    cleaned[#cleaned + 1] = value
  end
  return updateEntry(library, id, function(entry) entry.tags = cleaned; return entry end)
end

local function setCollection(library, id, collection)
  local value = cleanText(collection or "", 80, true)
  if value == nil then return nil, "dna_collection_invalid" end
  return updateEntry(library, id, function(entry) entry.collection = value; return entry end)
end

local function setNotes(library, id, notes)
  local value = cleanText(notes or "", 2048, true)
  if value == nil then return nil, "dna_notes_invalid" end
  return updateEntry(library, id, function(entry) entry.notes = value; return entry end)
end

local function setLockProfile(library, id, lockProfile)
  return updateEntry(library, id, function(entry) entry.lockProfile = util.deepCopy(lockProfile); return entry end)
end

local function setThumbnail(library, id, thumbnail)
  return updateEntry(library, id, function(entry) entry.thumbnail = thumbnail and util.deepCopy(thumbnail) or nil; return entry end)
end

local function duplicate(library, id)
  local entry = find(library, id)
  if not entry then return nil, "dna_not_found" end
  local origin = entry.id
  entry.id = uniqueId(library, origin .. "-copy")
  entry.name = cleanText(entry.name .. " Copy", schema.MAX_NAME_LENGTH, false)
  entry.createdAt, entry.updatedAt = os.time(), os.time()
  entry.favorite, entry.pinned = false, false
  entry.thumbnail = nil
  entry.lineage = {
    parentId = origin,
    rootId = entry.lineage and entry.lineage.rootId or origin,
    generation = math.min(32, math.floor(tonumber(entry.lineage and entry.lineage.generation) or 0) + 1),
    createdFrom = "duplicate",
  }
  return add(library, entry)
end

local function summary(entry)
  return {
    id = entry.id,
    name = entry.name,
    modelKey = entry.final and entry.final.modelKey,
    configKey = entry.base and entry.base.configKey,
    configName = entry.base and entry.base.configName,
    configPath = entry.base and entry.base.configPath,
    seed = entry.generation and entry.generation.seed,
    operation = entry.generation and entry.generation.operation,
    createdAt = entry.createdAt,
    updatedAt = entry.updatedAt,
    favorite = entry.favorite == true,
    pinned = entry.pinned == true,
    rating = entry.rating,
    tags = util.deepCopy(entry.tags or {}),
    collection = entry.collection or "",
    sortOrder = entry.sortOrder or 0,
    validationStatus = entry.validation and entry.validation.status or "unknown",
    lineage = util.deepCopy(entry.lineage or {}),
    thumbnail = entry.thumbnail and util.deepCopy(entry.thumbnail) or gallery.fallback(entry),
    dependencyCount = #(entry.dependencies and entry.dependencies.parts or {}),
    deviationCount = #(entry.deviations or {}),
  }
end

local function containsText(entry, search)
  if search == "" then return true end
  local values = {entry.name, entry.final and entry.final.modelKey, entry.base and entry.base.configName, entry.collection}
  for _, tag in ipairs(entry.tags or {}) do values[#values + 1] = tag end
  for _, value in ipairs(values) do if util.normalizeText(value):find(search, 1, true) then return true end end
  return false
end

local function matchesFilter(entry, options)
  local filter = options.filter or "all"
  if filter == "favorites" and entry.favorite ~= true then return false end
  if filter == "pinned" and entry.pinned ~= true then return false end
  if filter == "exact" and #(entry.deviations or {}) > 0 then return false end
  if filter == "partial" and #(entry.deviations or {}) == 0 then return false end
  if filter == "missing" then
    local missing = false
    for _, deviation in ipairs(entry.deviations or {}) do
      if tostring(deviation.reason):find("missing", 1, true) or tostring(deviation.reason):find("omitted", 1, true) then missing = true; break end
    end
    if not missing then return false end
  end
  if options.model and options.model ~= "" and entry.final and entry.final.modelKey ~= options.model then return false end
  if options.tag and options.tag ~= "" then
    local found = false
    for _, tag in ipairs(entry.tags or {}) do if tag:lower() == options.tag:lower() then found = true; break end end
    if not found then return false end
  end
  if options.collection and options.collection ~= "" and entry.collection ~= options.collection then return false end
  return containsText(entry, util.normalizeText(options.search or ""))
end

local function query(library, options)
  options = type(options) == "table" and options or {}
  local values = {}
  for _, entry in ipairs(type(library) == "table" and library.entries or {}) do
    if matchesFilter(entry, options) then values[#values + 1] = entry end
  end
  local sort = options.sort or "updated"
  table.sort(values, function(a, b)
    if a.pinned ~= b.pinned then return a.pinned == true end
    if sort == "name" and a.name ~= b.name then return a.name:lower() < b.name:lower() end
    if sort == "rating" and (a.rating or -1) ~= (b.rating or -1) then return (a.rating or -1) > (b.rating or -1) end
    if sort == "created" and a.createdAt ~= b.createdAt then return (a.createdAt or 0) > (b.createdAt or 0) end
    if (a.sortOrder or 0) ~= (b.sortOrder or 0) then return (a.sortOrder or 0) < (b.sortOrder or 0) end
    if a.favorite ~= b.favorite then return a.favorite == true end
    if a.updatedAt ~= b.updatedAt then return (a.updatedAt or 0) > (b.updatedAt or 0) end
    return a.id < b.id
  end)
  local offset = math.max(0, math.floor(tonumber(options.offset) or 0))
  local limit = math.max(1, math.min(25, math.floor(tonumber(options.limit) or 10)))
  local result = {}
  for index = offset + 1, math.min(#values, offset + limit) do result[#result + 1] = summary(values[index]) end
  return result, #values
end

local function summaries(library, offset, limit)
  return query(library, {offset = offset, limit = limit})
end

M.create = create
M.normalizeLibrary = normalizeLibrary
M.find = find
M.add = add
M.remove = remove
M.rename = rename
M.setFavorite = setFavorite
M.setPinned = setPinned
M.setRating = setRating
M.setTags = setTags
M.setCollection = setCollection
M.setNotes = setNotes
M.setLockProfile = setLockProfile
M.setThumbnail = setThumbnail
M.updateEntry = updateEntry
M.duplicate = duplicate
M.query = query
M.summary = summary
M.summaries = summaries
M.uniqueId = uniqueId
M.metrics = metrics

return M
