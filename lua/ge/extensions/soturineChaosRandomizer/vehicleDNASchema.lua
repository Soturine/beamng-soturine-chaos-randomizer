local util = require("ge/extensions/soturineChaosRandomizer/util")
local fingerprint = require("ge/extensions/soturineChaosRandomizer/vehicleDNAFingerprint")
local vehicleDNALocks = require("ge/extensions/soturineChaosRandomizer/vehicleDNALocks")
local vehicleDNAGallery = require("ge/extensions/soturineChaosRandomizer/vehicleDNAGallery")

local M = {}

M.SCHEMA_VERSION = 1
M.GENERATOR_VERSION = 6
M.LEGACY_GENERATOR_VERSION = 4
M.PREVIOUS_GENERATOR_VERSION = 5
M.MAX_SLOTS = 2048
M.MAX_TUNING = 2048
M.MAX_PAINTS = 32
M.MAX_TAGS = 20
M.MAX_DEPENDENCIES = 512
M.MAX_WARNINGS = 128
M.MAX_DEVIATIONS = 512
M.MAX_LINEAGE_ELEMENTS = 64
M.MAX_EXTENSION_ELEMENTS = 256
M.MAX_LOCK_ELEMENTS = 8192
M.MAX_NAME_LENGTH = 80
M.MAX_ENTRY_BYTES = 131072

local OPERATIONS = {randomConfig = true, scramble = true, fullRandom = true}
local SOURCE_KINDS = {official = true, mod = true, user = true, unknown = true}

local function supportedGenerator(value)
  value = tonumber(value)
  return value == M.GENERATOR_VERSION or value == M.PREVIOUS_GENERATOR_VERSION
    or value == M.LEGACY_GENERATOR_VERSION
end

local function stringValue(value, maximum)
  return type(value) == "string" and #value > 0 and #value <= (maximum or 512)
end

local function arrayWithin(value, maximum)
  if type(value) ~= "table" or #value > maximum then return false end
  for key in pairs(value) do
    if type(key) ~= "number" or key < 1 or key > #value or key ~= math.floor(key) then return false end
  end
  return true
end

local function boundedMetadata(value, maximum, path)
  if value == nil then return true end
  if type(value) ~= "table" then return false, path .. "_invalid" end
  local canonical, reason, metrics = fingerprint.canonicalize(value, {
    maxDepth = 16, maxElements = maximum, maxStringLength = 2048, maxPathLength = 512,
  })
  if not canonical then return false, reason end
  if not metrics or metrics.elements > maximum then return false, path .. "_limit" end
  return true
end

local function validateEntry(entry, options)
  options = options or {}
  if type(entry) ~= "table" then return false, "dna_entry_not_table" end
  local schemaVersion = math.floor(tonumber(entry.schemaVersion) or -1)
  if schemaVersion > M.SCHEMA_VERSION then return false, "dna_future_schema_read_only" end
  if schemaVersion ~= M.SCHEMA_VERSION then return false, "dna_schema_unsupported" end
  if entry.format ~= "SoturineVehicleDNA" then return false, "dna_format_invalid" end
  if entry.kind ~= "soturineVehicleDNA" then return false, "dna_kind_invalid" end
  if not stringValue(entry.id, 128) then return false, "dna_id_invalid" end
  if not stringValue(entry.name, M.MAX_NAME_LENGTH) then return false, "dna_name_invalid" end
  if entry.description ~= nil and type(entry.description) ~= "string" then return false, "dna_description_invalid" end
  if entry.favorite ~= nil and type(entry.favorite) ~= "boolean" then return false, "dna_favorite_invalid" end
  if entry.pinned ~= nil and type(entry.pinned) ~= "boolean" then return false, "dna_pinned_invalid" end
  local rating = entry.rating ~= nil and tonumber(entry.rating) or nil
  if rating and (not util.isFinite(rating) or rating ~= math.floor(rating) or rating < 0 or rating > 5) then
    return false, "dna_rating_invalid"
  end
  if entry.notes ~= nil and (type(entry.notes) ~= "string" or #entry.notes > 2048) then return false, "dna_notes_invalid" end
  if entry.collection ~= nil and (type(entry.collection) ~= "string" or #entry.collection > 80) then return false, "dna_collection_invalid" end
  if entry.sortOrder ~= nil and (not util.isFinite(tonumber(entry.sortOrder)) or math.abs(entry.sortOrder) > 1000000000) then
    return false, "dna_sort_order_invalid"
  end
  local createdAt, updatedAt = tonumber(entry.createdAt), tonumber(entry.updatedAt)
  if not util.isFinite(createdAt) or not util.isFinite(updatedAt) or createdAt < 0 or updatedAt < createdAt then
    return false, "dna_timestamp_invalid"
  end
  if type(entry.environment) ~= "table" or type(entry.generation) ~= "table" then return false, "dna_context_missing" end
  local generatorVersion = tonumber(entry.generatorVersion)
  if not supportedGenerator(generatorVersion) then return false, "dna_generator_version_invalid" end
  if tonumber(entry.generation.generatorVersion) ~= generatorVersion then return false, "dna_generator_version_invalid" end
  if type(entry.base) ~= "table" or not stringValue(entry.base.modelKey, 256) then return false, "dna_base_invalid" end
  if type(entry.final) ~= "table" or not stringValue(entry.final.modelKey, 256) then return false, "dna_final_missing" end
  if generatorVersion == M.LEGACY_GENERATOR_VERSION and entry.base.modelKey ~= entry.final.modelKey then
    return false, "dna_model_identity_mismatch"
  end
  local operation = entry.generation.operation
  if not OPERATIONS[operation] or entry.operation ~= operation then return false, "dna_operation_invalid" end
  if not stringValue(entry.generation.seed, 256) or type(entry.seed) ~= "table"
    or entry.seed.display ~= entry.generation.seed or type(entry.seed.legacy) ~= "boolean"
  then return false, "dna_seed_invalid" end
  if not arrayWithin(entry.final.slots, M.MAX_SLOTS) then return false, "dna_slots_limit" end
  if not arrayWithin(entry.final.tuning, M.MAX_TUNING) then return false, "dna_tuning_limit" end
  if not arrayWithin(entry.final.paints, M.MAX_PAINTS) then return false, "dna_paints_limit" end
  if entry.tags ~= nil and not arrayWithin(entry.tags, M.MAX_TAGS) then return false, "dna_tags_limit" end
  local seenTags = {}
  for _, tag in ipairs(entry.tags or {}) do
    if not stringValue(tag, 64) then return false, "dna_tag_invalid" end
    local normalized = tag:lower()
    if seenTags[normalized] then return false, "dna_tag_duplicate" end
    seenTags[normalized] = true
  end
  if type(entry.fingerprints) ~= "table" then return false, "dna_fingerprints_missing" end

  local seenPaths = {}
  for _, slot in ipairs(entry.final.slots) do
    if type(slot) ~= "table" or not stringValue(slot.path, 512) or not stringValue(slot.slotId, 256)
      or type(slot.partName) ~= "string"
    then return false, "dna_slot_invalid" end
    if seenPaths[slot.path] then return false, "dna_slot_duplicate_path" end
    if slot.parentPath ~= nil and type(slot.parentPath) ~= "string" then return false, "dna_slot_parent_invalid" end
    if slot.parentPart ~= nil and type(slot.parentPart) ~= "string" then return false, "dna_slot_parent_invalid" end
    if slot.defaultPart ~= nil and type(slot.defaultPart) ~= "string" then return false, "dna_slot_default_invalid" end
    if slot.sourceKind ~= nil and not SOURCE_KINDS[slot.sourceKind] then return false, "dna_source_kind_invalid" end
    if slot.resolutionStrategy ~= nil and not stringValue(slot.resolutionStrategy, 128) then return false, "dna_resolution_strategy_invalid" end
    seenPaths[slot.path] = true
  end
  local seenTuning = {}
  for _, variable in ipairs(entry.final.tuning) do
    if type(variable) ~= "table" or not stringValue(variable.name, 256)
      or not util.isFinite(tonumber(variable.value))
    then return false, "dna_tuning_invalid" end
    if seenTuning[variable.name] then return false, "dna_tuning_duplicate" end
    local minimum, maximum = tonumber(variable.minimum), tonumber(variable.maximum)
    if variable.minimum ~= nil and not util.isFinite(minimum) then return false, "dna_tuning_metadata_invalid" end
    if variable.maximum ~= nil and not util.isFinite(maximum) then return false, "dna_tuning_metadata_invalid" end
    if minimum and maximum and minimum > maximum then return false, "dna_tuning_metadata_invalid" end
    seenTuning[variable.name] = true
  end
  for _, paint in ipairs(entry.final.paints) do
    if type(paint) ~= "table" then return false, "dna_paint_invalid" end
  end

  if entry.base.sourceKind ~= nil and not SOURCE_KINDS[entry.base.sourceKind] then return false, "dna_source_kind_invalid" end
  for _, key in ipairs({"parts", "wheelTire", "mods", "official", "user", "unknown"}) do
    local list = entry.dependencies and entry.dependencies[key]
    if list ~= nil and not arrayWithin(list, M.MAX_DEPENDENCIES) then return false, "dna_dependencies_limit" end
  end
  if entry.warnings ~= nil and not arrayWithin(entry.warnings, M.MAX_WARNINGS) then return false, "dna_warnings_limit" end
  if entry.deviations ~= nil and not arrayWithin(entry.deviations, M.MAX_DEVIATIONS) then return false, "dna_deviations_limit" end
  local metadataValid, metadataReason = boundedMetadata(entry.lineage or {}, M.MAX_LINEAGE_ELEMENTS, "dna_lineage")
  if not metadataValid then return false, metadataReason end
  if entry.lineage ~= nil then
    local lineage = entry.lineage
    for _, key in ipairs({"parentId", "rootId", "createdFrom", "parentSeed", "originId", "importStrategy"}) do
      if lineage[key] ~= nil and not stringValue(lineage[key], 256) then return false, "dna_lineage_invalid" end
    end
    local generation = lineage.generation ~= nil and tonumber(lineage.generation) or nil
    local mutationIndex = lineage.mutationIndex ~= nil and tonumber(lineage.mutationIndex) or nil
    if generation and (generation ~= math.floor(generation) or generation < 0 or generation > 32) then return false, "dna_lineage_invalid" end
    if mutationIndex and (mutationIndex ~= math.floor(mutationIndex) or mutationIndex < 1 or mutationIndex > 1000000) then return false, "dna_lineage_invalid" end
    if lineage.mutationStrength ~= nil and lineage.mutationStrength ~= "small"
      and lineage.mutationStrength ~= "medium" and lineage.mutationStrength ~= "wild"
    then return false, "dna_lineage_invalid" end
    if lineage.parentMissing ~= nil and type(lineage.parentMissing) ~= "boolean" then return false, "dna_lineage_invalid" end
    if lineage.importedAt ~= nil and (not util.isFinite(tonumber(lineage.importedAt)) or tonumber(lineage.importedAt) < 0) then
      return false, "dna_lineage_invalid"
    end
  end
  if entry.lockProfile ~= nil then
    metadataValid, metadataReason = boundedMetadata(entry.lockProfile, M.MAX_LOCK_ELEMENTS, "dna_lock_profile")
    if not metadataValid then return false, metadataReason end
    local normalizedLocks = vehicleDNALocks.normalize(entry.lockProfile)
    if not util.deepEqual(entry.lockProfile, normalizedLocks) then return false, "dna_lock_profile_invalid" end
  end
  if entry.thumbnail ~= nil then
    if type(entry.thumbnail) ~= "table" or (entry.thumbnail.kind ~= "fallback" and entry.thumbnail.kind ~= "managed") then
      return false, "dna_thumbnail_invalid"
    end
    if entry.thumbnail.kind == "managed" then
      local managedId = vehicleDNAGallery.safeId(entry.thumbnail.managedId)
      if not managedId or managedId ~= entry.thumbnail.managedId
        or tonumber(entry.thumbnail.width) < 1 or tonumber(entry.thumbnail.width) > vehicleDNAGallery.MAX_WIDTH
        or tonumber(entry.thumbnail.height) < 1 or tonumber(entry.thumbnail.height) > vehicleDNAGallery.MAX_HEIGHT
        or tonumber(entry.thumbnail.bytes) < 1 or tonumber(entry.thumbnail.bytes) > vehicleDNAGallery.MAX_BYTES
      then return false, "dna_thumbnail_invalid" end
    end
  end
  metadataValid, metadataReason = boundedMetadata(entry.extensions or {}, M.MAX_EXTENSION_ELEMENTS, "dna_extensions")
  if not metadataValid then return false, metadataReason end

  for key, value in pairs({
    settings = entry.generation.settings,
    environment = entry.environment,
    base = entry.base,
    final = entry.final,
    dependencies = entry.dependencies or {},
  }) do
    local expected = fingerprint.fingerprint(value)
    if type(entry.fingerprints[key]) ~= "string" or entry.fingerprints[key] ~= expected then
      return false, "dna_fingerprint_mismatch:" .. key
    end
  end
  if type(entry.generation.startingStateFingerprint) ~= "string" then
    return false, "dna_starting_fingerprint_missing"
  end

  local canonical, canonicalError = fingerprint.canonicalize(entry)
  if not canonical then return false, canonicalError end
  if #canonical > (options.maxEntryBytes or M.MAX_ENTRY_BYTES) then return false, "dna_entry_size_limit" end
  return true, nil, {canonicalBytes = #canonical}
end

local function migrateEntry(entry)
  if type(entry) ~= "table" then return nil, "dna_entry_not_table" end
  local version = math.floor(tonumber(entry.schemaVersion) or -1)
  if version > M.SCHEMA_VERSION then return nil, "dna_future_schema_read_only" end
  if version ~= M.SCHEMA_VERSION then return nil, "dna_schema_unsupported" end
  local copy = util.deepCopy(entry)
  local valid, reason = validateEntry(copy)
  if not valid then return nil, reason end
  return copy
end

M.validateEntry = validateEntry
M.isSupportedGenerator = supportedGenerator
M.migrateEntry = migrateEntry

return M
