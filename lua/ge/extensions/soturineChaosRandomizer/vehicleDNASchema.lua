local util = require("ge/extensions/soturineChaosRandomizer/util")
local fingerprint = require("ge/extensions/soturineChaosRandomizer/vehicleDNAFingerprint")

local M = {}

M.SCHEMA_VERSION = 1
M.GENERATOR_VERSION = 4
M.MAX_SLOTS = 2048
M.MAX_TUNING = 2048
M.MAX_PAINTS = 32
M.MAX_TAGS = 20
M.MAX_NAME_LENGTH = 80
M.MAX_ENTRY_BYTES = 131072

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
  if type(entry.environment) ~= "table" or type(entry.generation) ~= "table" then return false, "dna_context_missing" end
  if tonumber(entry.generatorVersion) ~= M.GENERATOR_VERSION then return false, "dna_generator_version_invalid" end
  if tonumber(entry.generation.generatorVersion) ~= M.GENERATOR_VERSION then return false, "dna_generator_version_invalid" end
  if type(entry.base) ~= "table" or not stringValue(entry.base.modelKey, 256) then return false, "dna_base_invalid" end
  if type(entry.final) ~= "table" then return false, "dna_final_missing" end
  if not arrayWithin(entry.final.slots, M.MAX_SLOTS) then return false, "dna_slots_limit" end
  if not arrayWithin(entry.final.tuning, M.MAX_TUNING) then return false, "dna_tuning_limit" end
  if not arrayWithin(entry.final.paints, M.MAX_PAINTS) then return false, "dna_paints_limit" end
  if entry.tags ~= nil and not arrayWithin(entry.tags, M.MAX_TAGS) then return false, "dna_tags_limit" end
  if type(entry.fingerprints) ~= "table" then return false, "dna_fingerprints_missing" end

  local seenPaths = {}
  for _, slot in ipairs(entry.final.slots) do
    if type(slot) ~= "table" or not stringValue(slot.path, 512) or not stringValue(slot.slotId, 256)
      or type(slot.partName) ~= "string"
    then return false, "dna_slot_invalid" end
    if seenPaths[slot.path] then return false, "dna_slot_duplicate_path" end
    seenPaths[slot.path] = true
  end
  local seenTuning = {}
  for _, variable in ipairs(entry.final.tuning) do
    if type(variable) ~= "table" or not stringValue(variable.name, 256)
      or not util.isFinite(tonumber(variable.value))
    then return false, "dna_tuning_invalid" end
    if seenTuning[variable.name] then return false, "dna_tuning_duplicate" end
    seenTuning[variable.name] = true
  end
  for _, paint in ipairs(entry.final.paints) do
    if type(paint) ~= "table" then return false, "dna_paint_invalid" end
  end

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
M.migrateEntry = migrateEntry

return M
