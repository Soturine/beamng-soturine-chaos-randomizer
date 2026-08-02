local crc32 = require("ge/extensions/soturineChaosRandomizer/crc32")
local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local CACHE_VERSION = 1
local DEFAULT_MAX_BYTES = 4 * 1024 * 1024

local function canonical(value, seen, depth)
  local kind = type(value)
  if kind == "nil" then return "null" end
  if kind == "boolean" then return value and "true" or "false" end
  if kind == "number" then return util.isFinite(value) and string.format("%.17g", value) or "null" end
  if kind == "string" then return string.format("%q", value) end
  if kind ~= "table" then return "null" end
  seen, depth = seen or {}, depth or 0
  if seen[value] or depth > 24 then return "null" end
  seen[value] = true
  local keys = util.sortedKeys(value)
  local values = {}
  for _, key in ipairs(keys) do
    values[#values + 1] = canonical(tostring(key), seen, depth + 1) .. ":" .. canonical(value[key], seen, depth + 1)
  end
  seen[value] = nil
  return "{" .. table.concat(values, ",") .. "}"
end

local function checksum(value)
  local digest = crc32.digest(canonical(value))
  return digest and string.format("%08x", digest) or nil
end

local function fingerprint(parts)
  parts = type(parts) == "table" and parts or {}
  local required = {
    beamNGVersion = tostring(parts.beamNGVersion or "unknown"),
    modVersion = tostring(parts.modVersion or "unknown"),
    registryShapeVersion = tostring(parts.registryShapeVersion or "1"),
    activeModsFingerprint = tostring(parts.activeModsFingerprint or "unknown"),
    contentAliasesVersion = tostring(parts.contentAliasesVersion or "1"),
    settingsSchema = tostring(parts.settingsSchema or "unknown"),
  }
  return checksum(required), required
end

local function envelope(cacheFingerprint, payload, metadata)
  local value = {
    cacheVersion = CACHE_VERSION,
    fingerprint = cacheFingerprint,
    complete = true,
    metadata = type(metadata) == "table" and util.deepCopy(metadata) or {},
    payload = util.deepCopy(payload),
  }
  value.checksum = checksum({
    cacheVersion = value.cacheVersion, fingerprint = value.fingerprint,
    complete = value.complete, metadata = value.metadata, payload = value.payload,
  })
  return value
end

local function containsSensitivePath(value, seen)
  if type(value) == "string" then
    return value:match("%a:[/\\][Uu]sers[/\\]") ~= nil or value:sub(1, 2) == "\\\\"
  end
  if type(value) ~= "table" then return false end
  seen = seen or {}
  if seen[value] then return false end
  seen[value] = true
  for key, child in pairs(value) do
    if containsSensitivePath(key, seen) or containsSensitivePath(child, seen) then return true end
  end
  return false
end

local function validate(value, expectedFingerprint, encodedBytes, maxBytes)
  maxBytes = math.max(1024, tonumber(maxBytes) or DEFAULT_MAX_BYTES)
  if type(value) ~= "table" then return nil, "cache_missing" end
  if tonumber(encodedBytes) and encodedBytes > maxBytes then return nil, "cache_too_large" end
  if value.cacheVersion ~= CACHE_VERSION then return nil, "cache_version_changed" end
  if value.complete ~= true then return nil, "cache_snapshot_partial" end
  if value.fingerprint ~= expectedFingerprint then return nil, "cache_fingerprint_changed" end
  if type(value.payload) ~= "table" then return nil, "cache_payload_invalid" end
  if containsSensitivePath(value.payload) then return nil, "cache_sensitive_path_rejected" end
  local expectedChecksum = checksum({
    cacheVersion = value.cacheVersion, fingerprint = value.fingerprint,
    complete = value.complete, metadata = value.metadata or {}, payload = value.payload,
  })
  if type(value.checksum) ~= "string" or value.checksum ~= expectedChecksum then
    return nil, "cache_checksum_invalid"
  end
  return util.deepCopy(value.payload), "cache_hit"
end

M.CACHE_VERSION = CACHE_VERSION
M.DEFAULT_MAX_BYTES = DEFAULT_MAX_BYTES
M.canonical = canonical
M.checksum = checksum
M.fingerprint = fingerprint
M.envelope = envelope
M.validate = validate
M.containsSensitivePath = containsSensitivePath

return M
