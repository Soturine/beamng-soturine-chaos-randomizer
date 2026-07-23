local fingerprint = require("ge/extensions/soturineChaosRandomizer/vehicleDNAFingerprint")
local util = require("ge/extensions/soturineChaosRandomizer/util")

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
  if type(data) ~= "string" or #data < 24 or data:sub(1, 8) ~= "\137PNG\13\10\26\10" then
    return nil, "thumbnail_png_invalid"
  end
  local function u32(offset)
    local a, b, c, d = data:byte(offset, offset + 3)
    return ((a * 256 + b) * 256 + c) * 256 + d
  end
  local width, height = u32(17), u32(21)
  if width < 1 or height < 1 or width > M.MAX_WIDTH or height > M.MAX_HEIGHT then
    return nil, "thumbnail_dimensions_limit"
  end
  if #data > M.MAX_BYTES then return nil, "thumbnail_size_limit" end
  return {width = width, height = height, bytes = #data}
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

local function managedMetadata(id, dimensions)
  local managedId = safeId(id)
  if not managedId or type(dimensions) ~= "table" then return nil, "thumbnail_metadata_invalid" end
  return {
    kind = "managed",
    managedId = managedId,
    width = dimensions.width,
    height = dimensions.height,
    bytes = dimensions.bytes,
  }
end

M.safeId = safeId
M.pngDimensions = pngDimensions
M.fallback = fallback
M.managedMetadata = managedMetadata

return M
