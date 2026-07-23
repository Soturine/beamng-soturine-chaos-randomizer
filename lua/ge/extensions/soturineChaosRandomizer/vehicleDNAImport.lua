local util = require("ge/extensions/soturineChaosRandomizer/util")
local schema = require("ge/extensions/soturineChaosRandomizer/vehicleDNASchema")
local fingerprint = require("ge/extensions/soturineChaosRandomizer/vehicleDNAFingerprint")
local configVerification = require("ge/extensions/soturineChaosRandomizer/configVerification")

local M = {}

M.MAX_IMPORT_BYTES = 131072

local KNOWN_FIELDS = {
  format = true, kind = true, schemaVersion = true, generatorVersion = true,
  id = true, name = true, description = true, createdAt = true, updatedAt = true,
  favorite = true, tags = true, environment = true, generation = true, base = true, final = true,
  pinned = true, rating = true, notes = true, collection = true, sortOrder = true, lockProfile = true,
  operation = true, seed = true,
  safety = true, warnings = true, metrics = true, dependencies = true, fingerprints = true,
  validation = true, lineage = true, extensions = true,
}

local function sanitize(value)
  if type(value) ~= "table" then return nil, "dna_import_not_object" end
  local result = {}
  for _, key in ipairs(util.sortedKeys(value)) do
    if KNOWN_FIELDS[key] then result[key] = util.deepCopy(value[key]) end
  end
  local canonical, canonicalError = fingerprint.canonicalize(result, {
    maxDepth = 32, maxElements = 10000, maxStringLength = 4096, maxPathLength = 512,
  })
  if not canonical then return nil, canonicalError end
  if #canonical > M.MAX_IMPORT_BYTES then return nil, "dna_import_size_limit" end
  local function safeConfigPath(pathValue)
    if pathValue == nil then return nil end
    if type(pathValue) ~= "string" or pathValue:find("..", 1, true) or pathValue:match("^[A-Za-z]:")
      or pathValue:match("^[/\\][/\\]")
    then return nil, "dna_import_path_invalid" end
    return configVerification.normalizePath(pathValue)
  end
  local normalizedPath, pathError = safeConfigPath(result.base and result.base.configPath)
  if pathError then return nil, pathError end
  if result.base then result.base.configPath = normalizedPath end
  normalizedPath, pathError = safeConfigPath(result.final and result.final.configIdentity)
  if pathError then return nil, pathError end
  if result.final then result.final.configIdentity = normalizedPath end
  if result.dependencies and type(result.dependencies.baseConfiguration) == "table" then
    normalizedPath, pathError = safeConfigPath(result.dependencies.baseConfiguration.configPath)
    if pathError then return nil, pathError end
    result.dependencies.baseConfiguration.configPath = normalizedPath
  end
  -- Managed thumbnail paths are local-only. JSON import always derives a safe fallback.
  result.thumbnail = nil
  if type(result.fingerprints) == "table" then
    result.fingerprints.base = fingerprint.fingerprint(result.base)
    result.fingerprints.final = fingerprint.fingerprint(result.final)
    result.fingerprints.dependencies = fingerprint.fingerprint(result.dependencies or {})
  end
  local valid, reason = schema.validateEntry(result)
  if not valid then return nil, reason end
  return result
end

M.sanitize = sanitize

return M
