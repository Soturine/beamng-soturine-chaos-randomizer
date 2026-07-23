local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

M.MAX_DIFFERENCES = 4096

local function scalarDifference(section, key, left, right)
  if util.deepEqual(left, right, 1e-8) then return nil end
  local status = left == nil and "added" or right == nil and "removed" or "changed"
  return {section = section, key = tostring(key), status = status, left = util.deepCopy(left), right = util.deepCopy(right)}
end

local function keyed(values, keyName)
  local result = {}
  for index, value in ipairs(type(values) == "table" and values or {}) do
    local key = type(value) == "table" and value[keyName] or nil
    if key == nil then key = tostring(index) end
    result[tostring(key)] = value
  end
  return result
end

local function append(result, difference)
  if not difference or #result.differences >= M.MAX_DIFFERENCES then return end
  result.differences[#result.differences + 1] = difference
  result.counts[difference.status] = (result.counts[difference.status] or 0) + 1
end

local function compareMap(result, section, left, right)
  local keys = {}
  for key in pairs(left or {}) do keys[key] = true end
  for key in pairs(right or {}) do keys[key] = true end
  for _, key in ipairs(util.sortedKeys(keys)) do append(result, scalarDifference(section, key, left[key], right[key])) end
end

local function deviationStatus(entry, path, fallback)
  for _, deviation in ipairs(type(entry) == "table" and entry.deviations or {}) do
    if deviation.savedPath == path or deviation.resolvedPath == path then
      if deviation.reason == "slot_remapped" then return "remapped" end
      if deviation.reason and deviation.reason:find("clamp", 1, true) then return "clamped" end
      if deviation.reason and deviation.reason:find("missing", 1, true) then return "unavailable" end
    end
  end
  return fallback
end

local function compare(left, right)
  if type(left) ~= "table" or type(right) ~= "table" then return nil, "dna_compare_invalid" end
  local result = {
    leftId = left.id,
    rightId = right.id,
    equal = true,
    truncated = false,
    counts = {changed = 0, added = 0, removed = 0, unavailable = 0, remapped = 0, clamped = 0},
    differences = {},
  }
  append(result, scalarDifference("model", "modelKey", left.final and left.final.modelKey, right.final and right.final.modelKey))
  append(result, scalarDifference("configuration", "base", left.base, right.base))

  local sections = {
    {name = "slots", left = keyed(left.final and left.final.slots, "path"), right = keyed(right.final and right.final.slots, "path")},
    {name = "tuning", left = keyed(left.final and left.final.tuning, "name"), right = keyed(right.final and right.final.tuning, "name")},
    {name = "paints", left = keyed(left.final and left.final.paints, "layer"), right = keyed(right.final and right.final.paints, "layer")},
  }
  for _, section in ipairs(sections) do
    local keys = {}
    for key in pairs(section.left) do keys[key] = true end
    for key in pairs(section.right) do keys[key] = true end
    for _, key in ipairs(util.sortedKeys(keys)) do
      local difference = scalarDifference(section.name, key, section.left[key], section.right[key])
      if difference then difference.status = deviationStatus(right, key, difference.status) end
      append(result, difference)
    end
  end

  compareMap(result, "dependencies", left.dependencies or {}, right.dependencies or {})
  append(result, scalarDifference("safety", "safety", left.safety, right.safety))
  append(result, scalarDifference("environment", "environment", left.environment, right.environment))
  append(result, scalarDifference("locks", "lockProfile", left.lockProfile, right.lockProfile))
  append(result, scalarDifference("lineage", "lineage", left.lineage, right.lineage))
  result.equal = #result.differences == 0
  result.truncated = #result.differences >= M.MAX_DIFFERENCES
  return result
end

M.compare = compare

return M
