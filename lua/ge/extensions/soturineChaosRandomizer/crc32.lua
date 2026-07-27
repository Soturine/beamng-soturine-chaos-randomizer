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

local TABLE = {}
for index = 0, 255 do
  local value = index
  for _ = 1, 8 do
    if value % 2 == 1 then value = bxor(math.floor(value / 2), 3988292384)
    else value = math.floor(value / 2) end
  end
  TABLE[index] = value
end

local function digest(data)
  if type(data) ~= "string" then return nil, "crc32_data_invalid" end
  local crc = 4294967295
  for index = 1, #data do
    local lookup = bxor(crc % 256, data:byte(index))
    crc = bxor(math.floor(crc / 256), TABLE[lookup])
  end
  return bxor(crc, 4294967295)
end

M.digest = digest

return M
