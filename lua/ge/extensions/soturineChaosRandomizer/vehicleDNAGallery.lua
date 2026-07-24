local fingerprint = require("ge/extensions/soturineChaosRandomizer/vehicleDNAFingerprint")
local util = require("ge/extensions/soturineChaosRandomizer/util")
local pngValidator = require("ge/extensions/soturineChaosRandomizer/pngValidator")

local M = {}

M.MAX_WIDTH = 500
M.MAX_HEIGHT = 281
M.MAX_BYTES = 262144
M.MAX_MANAGED_THUMBNAILS = 100

local function safeId(id)
  local value = tostring(id or ""):gsub("[^A-Za-z0-9_-]", "-"):sub(1, 96)
  return value ~= "" and value or nil
end

local function pngDimensions(data)
  return pngValidator.validate(data, {
    maxWidth = M.MAX_WIDTH,
    maxHeight = M.MAX_HEIGHT,
    maxBytes = M.MAX_BYTES,
    maxChunks = 128,
    maxChunkBytes = M.MAX_BYTES,
    maxIDATBytes = M.MAX_BYTES,
  })
end

local function fallback(entry)
  local firstPaint = entry and entry.final and entry.final.paints and entry.final.paints[1] or {}
  local color = type(firstPaint) == "table" and firstPaint.baseColor or nil
  if type(color) ~= "table" then color = {0.96, 0.43, 0.12, 1} end
  local identity = fingerprint.fingerprint({
    model = entry and entry.final and entry.final.modelKey,
    source = entry and entry.base and entry.base.sourceKind,
    color = color,
  })
  return {
    kind = "fallback",
    variant = identity and identity:sub(-8) or "default",
    sourceKind = entry and entry.base and entry.base.sourceKind or "unknown",
    color = {
      util.clamp(tonumber(color[1]) or 0.96, 0, 1),
      util.clamp(tonumber(color[2]) or 0.43, 0, 1),
      util.clamp(tonumber(color[3]) or 0.12, 0, 1),
      1,
    },
  }
end

local function managedMetadata(id, dimensions, options)
  local managedId = safeId(id)
  if not managedId or type(dimensions) ~= "table" then return nil, "thumbnail_metadata_invalid" end
  options = type(options) == "table" and options or {}
  return {
    kind = "managed",
    managedId = managedId,
    width = dimensions.width,
    height = dimensions.height,
    bytes = dimensions.bytes,
    exactState = options.exactState ~= false,
    capturedFingerprint = type(options.capturedFingerprint) == "string" and options.capturedFingerprint or nil,
  }
end

M.safeId = safeId
M.pngDimensions = pngDimensions
M.fallback = fallback
M.managedMetadata = managedMetadata

return M
