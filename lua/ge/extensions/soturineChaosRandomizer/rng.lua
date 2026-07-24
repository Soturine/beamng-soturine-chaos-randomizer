local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local MODULUS = 2147483647
local MULTIPLIER = 48271

local function hashText(value)
  local hash = 5381
  local text = tostring(value or "")
  for index = 1, #text do
    hash = (hash * 33 + string.byte(text, index)) % MODULUS
  end
  if hash == 0 then hash = 1 end
  return hash
end

local function parseSeed(value)
  if type(value) == "number" then
    if value ~= value or value == math.huge or value == -math.huge then return 1 end
    local seed = math.floor(math.abs(value)) % MODULUS
    return seed == 0 and 1 or seed
  end

  local text = tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", "")
  local compactHex = text:gsub("^[Ss][Cc][Rr][45]%-", ""):gsub("%-", "")
  if compactHex:match("^%x%x%x%x%x%x%x%x$") then
    local seed = tonumber(compactHex, 16) % MODULUS
    return seed == 0 and 1 or seed
  end

  local numeric = tonumber(text)
  if numeric then return parseSeed(numeric) end
  return hashText(text)
end

local function formatSeed(seed)
  local compact = string.format("%08X", parseSeed(seed))
  return "SCR5-" .. string.sub(compact, 1, 4) .. "-" .. string.sub(compact, 5, 8)
end

local Generator = {}
Generator.__index = Generator

function Generator:nextUInt()
  self.state = (self.state * MULTIPLIER) % MODULUS
  return self.state
end

function Generator:float(minimum, maximum)
  minimum = tonumber(minimum) or 0
  maximum = tonumber(maximum) or 1
  if maximum < minimum then minimum, maximum = maximum, minimum end
  local unit = (self:nextUInt() - 1) / (MODULUS - 1)
  return minimum + (maximum - minimum) * unit
end

function Generator:integer(minimum, maximum)
  minimum = math.floor(tonumber(minimum) or 0)
  maximum = math.floor(tonumber(maximum) or minimum)
  if maximum < minimum then minimum, maximum = maximum, minimum end
  local span = maximum - minimum + 1
  return minimum + math.floor(self:float(0, 1) * span)
end

function Generator:boolean(probability)
  probability = util.clamp(probability, 0, 1)
  return self:float(0, 1) < probability
end

function Generator:choice(items)
  if type(items) ~= "table" or #items == 0 then return nil end
  return items[self:integer(1, #items)]
end

function Generator:weightedChoice(items, weights)
  if type(items) ~= "table" or #items == 0 then return nil end
  local total = 0
  local normalized = {}
  for index = 1, #items do
    local weight = weights and weights[index]
    if weight == nil and type(items[index]) == "table" then weight = items[index].weight end
    weight = tonumber(weight) or 0
    if weight < 0 then weight = 0 end
    normalized[index] = weight
    total = total + weight
  end
  if total <= 0 then return self:choice(items) end

  local cursor = self:float(0, total)
  for index = 1, #items do
    cursor = cursor - normalized[index]
    if cursor < 0 then return items[index] end
  end
  return items[#items]
end

function Generator:shuffle(items)
  local result = util.copyArray(items)
  for index = #result, 2, -1 do
    local swapIndex = self:integer(1, index)
    result[index], result[swapIndex] = result[swapIndex], result[index]
  end
  return result
end

function Generator:fork(label)
  return M.new(self.legacySeed .. ":" .. tostring(label or ""))
end

local function new(seed)
  local numeric = parseSeed(seed)
  return setmetatable({
    state = numeric,
    numericSeed = numeric,
    seed = formatSeed(numeric),
    legacySeed = string.sub(string.format("%08X", numeric), 1, 4) .. "-" .. string.sub(string.format("%08X", numeric), 5, 8),
  }, Generator)
end

M.new = new
M.normalizeSeed = formatSeed
M.seedToNumber = parseSeed
M.hashText = hashText
M.MODULUS = MODULUS

return M
