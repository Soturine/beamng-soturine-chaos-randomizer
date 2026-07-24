local M = {}

local function bxor(left, right)
  local result, bit = 0, 1
  left, right = math.floor(left), math.floor(right)
  for _ = 1, 32 do
    local a, b = left % 2, right % 2
    if a ~= b then result = result + bit end
    left, right, bit = math.floor(left / 2), math.floor(right / 2), bit * 2
  end
  return result
end

local CRC_TABLE = {}
for index = 0, 255 do
  local value = index
  for _ = 1, 8 do
    if value % 2 == 1 then value = bxor(math.floor(value / 2), 3988292384)
    else value = math.floor(value / 2) end
  end
  CRC_TABLE[index] = value
end

local function crc32(data)
  local crc = 4294967295
  for index = 1, #data do
    local lookup = bxor(crc % 256, data:byte(index))
    crc = bxor(math.floor(crc / 256), CRC_TABLE[lookup])
  end
  return bxor(crc, 4294967295)
end

M.DEFAULT_LIMITS = {
  maxBytes = 262144,
  maxWidth = 500,
  maxHeight = 281,
  maxChunks = 128,
  maxChunkBytes = 262144,
  maxIDATBytes = 262144,
}

local function u32(data, offset)
  local a, b, c, d = data:byte(offset, offset + 3)
  if not d then return nil end
  return ((a * 256 + b) * 256 + c) * 256 + d
end

local function validate(data, limits)
  limits = type(limits) == "table" and limits or M.DEFAULT_LIMITS
  if type(data) ~= "string" or #data < 45 or data:sub(1, 8) ~= "\137PNG\13\10\26\10" then
    return nil, "thumbnail_png_invalid"
  end
  if #data > (limits.maxBytes or M.DEFAULT_LIMITS.maxBytes) then return nil, "thumbnail_size_limit" end
  local offset, chunkCount, ihdrCount, iendCount, idatCount, idatBytes = 9, 0, 0, 0, 0, 0
  local width, height
  while offset <= #data do
    if offset + 11 > #data then return nil, "thumbnail_chunk_truncated" end
    local length = u32(data, offset)
    if not length or length > (limits.maxChunkBytes or M.DEFAULT_LIMITS.maxChunkBytes) then
      return nil, "thumbnail_chunk_length_limit"
    end
    local chunkType = data:sub(offset + 4, offset + 7)
    if #chunkType ~= 4 or not chunkType:match("^[A-Za-z][A-Za-z][A-Za-z][A-Za-z]$") then
      return nil, "thumbnail_chunk_type_invalid"
    end
    local dataStart, dataEnd = offset + 8, offset + 7 + length
    local crcOffset = dataEnd + 1
    if dataEnd > #data or crcOffset + 3 > #data then return nil, "thumbnail_chunk_overflow" end
    local expectedCRC = u32(data, crcOffset)
    local actualCRC = crc32(chunkType .. data:sub(dataStart, dataEnd))
    if expectedCRC ~= actualCRC then return nil, "thumbnail_crc_invalid" end
    chunkCount = chunkCount + 1
    if chunkCount > (limits.maxChunks or M.DEFAULT_LIMITS.maxChunks) then return nil, "thumbnail_chunk_count_limit" end
    if chunkCount == 1 and chunkType ~= "IHDR" then return nil, "thumbnail_ihdr_not_first" end
    if chunkType == "IHDR" then
      ihdrCount = ihdrCount + 1
      if ihdrCount ~= 1 or length ~= 13 then return nil, "thumbnail_ihdr_invalid" end
      width, height = u32(data, dataStart), u32(data, dataStart + 4)
      if not width or not height or width < 1 or height < 1
        or width > (limits.maxWidth or M.DEFAULT_LIMITS.maxWidth)
        or height > (limits.maxHeight or M.DEFAULT_LIMITS.maxHeight)
      then return nil, "thumbnail_dimensions_limit" end
      local compression, filter, interlace = data:byte(dataStart + 10, dataStart + 12)
      if compression ~= 0 or filter ~= 0 or (interlace ~= 0 and interlace ~= 1) then
        return nil, "thumbnail_ihdr_encoding_invalid"
      end
    elseif chunkType == "IDAT" then
      if ihdrCount ~= 1 or iendCount > 0 then return nil, "thumbnail_idat_order_invalid" end
      idatCount = idatCount + 1
      idatBytes = idatBytes + length
      if idatBytes > (limits.maxIDATBytes or M.DEFAULT_LIMITS.maxIDATBytes) then
        return nil, "thumbnail_idat_limit"
      end
    elseif chunkType == "IEND" then
      iendCount = iendCount + 1
      if iendCount ~= 1 or length ~= 0 or idatCount < 1 then return nil, "thumbnail_iend_invalid" end
      if crcOffset + 4 ~= #data + 1 then return nil, "thumbnail_trailing_payload" end
    elseif chunkType:sub(1, 1):match("[A-Z]") and chunkType ~= "PLTE" then
      return nil, "thumbnail_unknown_critical_chunk"
    end
    offset = crcOffset + 4
    if iendCount == 1 then break end
  end
  if ihdrCount ~= 1 then return nil, "thumbnail_ihdr_missing" end
  if iendCount ~= 1 then return nil, "thumbnail_iend_missing" end
  if idatCount < 1 then return nil, "thumbnail_idat_missing" end
  if offset ~= #data + 1 then return nil, "thumbnail_trailing_payload" end
  return {width = width, height = height, bytes = #data, chunks = chunkCount, idatBytes = idatBytes}
end

M.u32 = u32
M.crc32 = crc32
M.validate = validate

return M
