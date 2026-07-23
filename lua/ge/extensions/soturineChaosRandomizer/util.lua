local M = {}

local function clamp(value, minimum, maximum)
  value = tonumber(value) or minimum
  if value < minimum then return minimum end
  if value > maximum then return maximum end
  return value
end

local function isFinite(value)
  return type(value) == "number" and value == value and value ~= math.huge and value ~= -math.huge
end

local function deepCopy(value, seen)
  if type(value) ~= "table" then return value end
  seen = seen or {}
  if seen[value] then return seen[value] end

  local copy = {}
  seen[value] = copy
  for key, child in pairs(value) do
    copy[deepCopy(key, seen)] = deepCopy(child, seen)
  end
  return copy
end

local function copyArray(source)
  local result = {}
  if type(source) ~= "table" then return result end
  for index = 1, #source do
    result[index] = source[index]
  end
  return result
end

local function sortedKeys(source)
  local keys = {}
  if type(source) ~= "table" then return keys end
  for key in pairs(source) do
    keys[#keys + 1] = key
  end
  table.sort(keys, function(a, b)
    return tostring(a) < tostring(b)
  end)
  return keys
end

local function arrayContains(source, value)
  if type(source) ~= "table" then return false end
  for index = 1, #source do
    if source[index] == value then return true end
  end
  return false
end

local function shallowMerge(base, patch)
  local result = deepCopy(base or {})
  if type(patch) == "table" then
    for key, value in pairs(patch) do
      result[key] = deepCopy(value)
    end
  end
  return result
end

local function roundToStep(value, step, origin)
  if not isFinite(value) then return value end
  if not isFinite(step) or step <= 0 then return value end
  origin = isFinite(origin) and origin or 0
  return origin + math.floor(((value - origin) / step) + 0.5) * step
end

local function normalizeText(value)
  if value == nil then return "" end
  return tostring(value):lower():gsub("^%s+", ""):gsub("%s+$", "")
end

M.clamp = clamp
M.isFinite = isFinite
M.deepCopy = deepCopy
M.copyArray = copyArray
M.sortedKeys = sortedKeys
M.arrayContains = arrayContains
M.shallowMerge = shallowMerge
M.roundToStep = roundToStep
M.normalizeText = normalizeText

return M
