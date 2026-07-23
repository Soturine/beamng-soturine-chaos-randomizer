local gallery = require("ge/extensions/soturineChaosRandomizer/vehicleDNAGallery")
local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

M.PACKAGE_VERSION = 1
M.MAX_ARCHIVE_BYTES = 524288
M.MAX_ENTRY_BYTES = 262144
M.MAX_TOTAL_UNCOMPRESSED = 524288
M.MAX_ENTRIES = 5
M.MAX_COMPRESSION_RATIO = 100

local ALLOWED = {
  ["manifest.json"] = true,
  ["vehicle.vdna.json"] = true,
  ["compatibility.json"] = true,
  ["thumbnail.png"] = true,
  ["README.txt"] = true,
}

local ORDER = {
  ["manifest.json"] = 1,
  ["vehicle.vdna.json"] = 2,
  ["compatibility.json"] = 3,
  ["thumbnail.png"] = 4,
  ["README.txt"] = 5,
}

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

local function le16(value)
  value = math.floor(value) % 65536
  return string.char(value % 256, math.floor(value / 256))
end

local function le32(value)
  value = math.floor(value) % 4294967296
  return string.char(
    value % 256,
    math.floor(value / 256) % 256,
    math.floor(value / 65536) % 256,
    math.floor(value / 16777216) % 256
  )
end

local function u16(data, offset)
  local a, b = data:byte(offset, offset + 1)
  if not b then return nil end
  return a + b * 256
end

local function u32(data, offset)
  local a, b, c, d = data:byte(offset, offset + 3)
  if not d then return nil end
  return a + b * 256 + c * 65536 + d * 16777216
end

local function safeName(name)
  return type(name) == "string" and ALLOWED[name] == true and not name:find("..", 1, true)
    and not name:find("/", 1, true) and not name:find("\\", 1, true) and not name:find(":", 1, true)
end

local function sortedNames(files)
  local names = {}
  for name in pairs(files or {}) do names[#names + 1] = name end
  table.sort(names, function(a, b) return (ORDER[a] or 99) < (ORDER[b] or 99) end)
  return names
end

local function build(files)
  if type(files) ~= "table" then return nil, "vdna_package_files_invalid" end
  local names = sortedNames(files)
  if #names < 4 or #names > M.MAX_ENTRIES or not files["manifest.json"] or not files["vehicle.vdna.json"]
    or not files["compatibility.json"] or not files["README.txt"]
  then
    return nil, "vdna_package_entries_invalid"
  end
  local localChunks, centralChunks, offset, total = {}, {}, 0, 0
  for _, name in ipairs(names) do
    local data = files[name]
    if not safeName(name) or type(data) ~= "string" or #data > M.MAX_ENTRY_BYTES then
      return nil, "vdna_package_entry_invalid"
    end
    total = total + #data
    if total > M.MAX_TOTAL_UNCOMPRESSED then return nil, "vdna_package_uncompressed_limit" end
    if name == "thumbnail.png" then
      local dimensions, reason = gallery.pngDimensions(data)
      if not dimensions then return nil, reason end
    end
    local crc = crc32(data)
    local localHeader = table.concat({
      le32(67324752), le16(20), le16(0), le16(0), le16(0), le16(33),
      le32(crc), le32(#data), le32(#data), le16(#name), le16(0), name,
    })
    localChunks[#localChunks + 1] = localHeader .. data
    centralChunks[#centralChunks + 1] = table.concat({
      le32(33639248), le16(20), le16(20), le16(0), le16(0), le16(0), le16(33),
      le32(crc), le32(#data), le32(#data), le16(#name), le16(0), le16(0),
      le16(0), le16(0), le32(0), le32(offset), name,
    })
    offset = offset + #localHeader + #data
  end
  local central = table.concat(centralChunks)
  local result = table.concat(localChunks) .. central .. table.concat({
    le32(101010256), le16(0), le16(0), le16(#names), le16(#names),
    le32(#central), le32(offset), le16(0),
  })
  if #result > M.MAX_ARCHIVE_BYTES then return nil, "vdna_package_archive_limit" end
  return result
end

local function findEOCD(data)
  local minimum = math.max(1, #data - 65557)
  for offset = #data - 21, minimum, -1 do
    if u32(data, offset) == 101010256 then return offset end
  end
  return nil
end

local function inspect(data)
  if type(data) ~= "string" or #data < 22 or #data > M.MAX_ARCHIVE_BYTES then
    return nil, "vdna_package_archive_limit"
  end
  local eocd = findEOCD(data)
  if not eocd then return nil, "vdna_package_eocd_missing" end
  local disk, centralDisk = u16(data, eocd + 4), u16(data, eocd + 6)
  local diskEntries, entryCount = u16(data, eocd + 8), u16(data, eocd + 10)
  local centralSize, centralOffset = u32(data, eocd + 12), u32(data, eocd + 16)
  local commentLength = u16(data, eocd + 20)
  if disk ~= 0 or centralDisk ~= 0 or diskEntries ~= entryCount or entryCount < 2 or entryCount > M.MAX_ENTRIES
    or commentLength ~= #data - (eocd + 21)
    or centralOffset + centralSize ~= eocd - 1
  then return nil, "vdna_package_directory_invalid" end
  local records, seen, cursor, total = {}, {}, centralOffset + 1, 0
  for _ = 1, entryCount do
    if cursor < 1 or cursor + 45 > eocd - 1 then return nil, "vdna_package_central_truncated" end
    if u32(data, cursor) ~= 33639248 then return nil, "vdna_package_central_invalid" end
    local flag, method = u16(data, cursor + 8), u16(data, cursor + 10)
    local crc, compressed, uncompressed = u32(data, cursor + 16), u32(data, cursor + 20), u32(data, cursor + 24)
    local nameLength, extraLength, itemComment = u16(data, cursor + 28), u16(data, cursor + 30), u16(data, cursor + 32)
    local diskStart, external, localOffset = u16(data, cursor + 34), u32(data, cursor + 38), u32(data, cursor + 42)
    local name = data:sub(cursor + 46, cursor + 45 + nameLength)
    local mode = math.floor(external / 65536)
    local fileType = math.floor(mode / 4096) % 16
    if cursor + 45 + nameLength + extraLength + itemComment > eocd - 1
      or not safeName(name) or seen[name] or diskStart ~= 0 or flag ~= 0 or method ~= 0
      or fileType == 10
      or compressed ~= uncompressed or uncompressed > M.MAX_ENTRY_BYTES
      or (compressed > 0 and uncompressed / compressed > M.MAX_COMPRESSION_RATIO)
    then return nil, "vdna_package_entry_unsafe" end
    total = total + uncompressed
    if total > M.MAX_TOTAL_UNCOMPRESSED then return nil, "vdna_package_uncompressed_limit" end
    seen[name] = true
    records[#records + 1] = {
      name = name, crc = crc, compressedBytes = compressed, bytes = uncompressed,
      localOffset = localOffset,
    }
    cursor = cursor + 46 + nameLength + extraLength + itemComment
  end
  if cursor ~= eocd then return nil, "vdna_package_central_size_mismatch" end
  if not seen["manifest.json"] or not seen["vehicle.vdna.json"]
    or not seen["compatibility.json"] or not seen["README.txt"]
  then return nil, "vdna_package_required_entry_missing" end

  table.sort(records, function(left, right) return left.localOffset < right.localOffset end)
  local entries = {}
  local expectedLocalOffset = 0
  for _, record in ipairs(records) do
    local offset = record.localOffset + 1
    if record.localOffset ~= expectedLocalOffset or record.localOffset >= centralOffset
      or offset < 1 or offset + 29 > centralOffset
    then
      return nil, "vdna_package_local_bounds_invalid"
    end
    if u32(data, offset) ~= 67324752 then return nil, "vdna_package_local_invalid" end
    local flag, method = u16(data, offset + 6), u16(data, offset + 8)
    local crc, compressed, uncompressed = u32(data, offset + 14), u32(data, offset + 18), u32(data, offset + 22)
    local nameLength, extraLength = u16(data, offset + 26), u16(data, offset + 28)
    local name = data:sub(offset + 30, offset + 29 + nameLength)
    local dataStart = offset + 30 + nameLength + extraLength
    local dataEnd = dataStart + compressed - 1
    if name ~= record.name or flag ~= 0 or method ~= 0 or crc ~= record.crc
      or compressed ~= record.compressedBytes or uncompressed ~= record.bytes
      or dataStart > centralOffset + 1 or dataEnd >= centralOffset + 1
    then return nil, "vdna_package_local_mismatch" end
    local content = data:sub(dataStart, dataEnd)
    if #content ~= record.bytes or crc32(content) ~= record.crc then return nil, "vdna_package_checksum_mismatch" end
    if name == "thumbnail.png" then
      local dimensions, reason = gallery.pngDimensions(content)
      if not dimensions then return nil, reason end
    end
    entries[name] = content
    expectedLocalOffset = dataEnd
  end
  if expectedLocalOffset ~= centralOffset then return nil, "vdna_package_local_size_mismatch" end
  return {entries = entries, records = records, archiveBytes = #data, uncompressedBytes = total}
end

local function validateManifest(manifest, inspected, sha256)
  if type(manifest) ~= "table" or manifest.format ~= "SoturineVehicleDNAPackage"
    or tonumber(manifest.packageVersion) ~= M.PACKAGE_VERSION or type(manifest.files) ~= "table"
    or type(inspected) ~= "table" or type(inspected.entries) ~= "table" or type(sha256) ~= "function"
  then return false, "vdna_package_manifest_invalid" end
  local seen = {}
  for _, file in ipairs(manifest.files) do
    local content = type(file) == "table" and inspected.entries[file.name] or nil
    if type(file) ~= "table" or not safeName(file.name) or file.name == "manifest.json" or seen[file.name]
      or type(content) ~= "string" or tonumber(file.bytes) ~= #content
      or type(file.sha256) ~= "string" or not file.sha256:match("^[0-9a-fA-F]+$") or #file.sha256 ~= 64
    then return false, "vdna_package_manifest_file_invalid" end
    local actual = sha256(content)
    if type(actual) ~= "string" or actual:lower() ~= file.sha256:lower() then return false, "vdna_package_manifest_checksum_mismatch" end
    seen[file.name] = true
  end
  for name in pairs(inspected.entries) do
    if name ~= "manifest.json" and not seen[name] then return false, "vdna_package_manifest_file_missing" end
  end
  return true
end

local function envelope(entry)
  return {
    format = "SoturineVehicleDNAShare",
    shareVersion = 1,
    vehicleDNA = util.deepCopy(entry),
  }
end

M.build = build
M.inspect = inspect
M.validateManifest = validateManifest
M.crc32 = crc32
M.envelope = envelope
M.allowedEntry = safeName

return M
