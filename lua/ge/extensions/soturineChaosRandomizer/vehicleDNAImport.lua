local util = require("ge/extensions/soturineChaosRandomizer/util")
local schema = require("ge/extensions/soturineChaosRandomizer/vehicleDNASchema")
local fingerprint = require("ge/extensions/soturineChaosRandomizer/vehicleDNAFingerprint")

local M = {}

M.MAX_IMPORT_BYTES = 131072

local KNOWN_FIELDS = {
  format = true, kind = true, schemaVersion = true, generatorVersion = true,
  id = true, name = true, description = true, createdAt = true, updatedAt = true,
  favorite = true, tags = true, environment = true, generation = true, base = true, final = true,
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
  local valid, reason = schema.validateEntry(result)
  if not valid then return nil, reason end
  return result
end

M.sanitize = sanitize

return M
