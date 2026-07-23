local util = require("ge/extensions/soturineChaosRandomizer/util")
local paintVerification = require("ge/extensions/soturineChaosRandomizer/paintVerification")

local M = {}

local function normalizeSlots(scan)
  local result = {}
  for _, slot in ipairs(type(scan) == "table" and scan.slots or {}) do
    local source = type(slot.currentSource) == "table" and slot.currentSource or {}
    result[#result + 1] = {
      path = tostring(slot.path),
      slotId = tostring(slot.id),
      parentPath = slot.parentPath,
      parentPart = slot.parentPart,
      partName = type(slot.currentPart) == "string" and slot.currentPart or "",
      defaultPart = slot.defaultPart,
      sourceKind = tostring(source.sourceKind or "unknown"),
      sourceLabel = tostring(source.sourceLabel or "Unknown"),
      modID = source.modID,
      required = slot.required == true,
      coreSlot = slot.coreSlot == true,
      resolutionStrategy = "exact_path_slot_parent",
    }
  end
  table.sort(result, function(a, b)
    if a.path ~= b.path then return a.path < b.path end
    return a.slotId < b.slotId
  end)
  return result
end

local function normalizeTuning(variables, values)
  local result = {}
  for _, name in ipairs(util.sortedKeys(values or {})) do
    local value = tonumber(values[name])
    if util.isFinite(value) then
      local metadata = type(variables) == "table" and type(variables[name]) == "table" and variables[name] or {}
      local record = {name = tostring(name), value = value}
      for source, target in pairs({min = "minimum", max = "maximum", default = "default", step = "step", stepDis = "displayStep"}) do
        local number = tonumber(metadata[source])
        if util.isFinite(number) then record[target] = number end
      end
      result[#result + 1] = record
    end
  end
  return result
end

local function normalizePaints(paints)
  local normalized = paintVerification.normalizePaints(paints or {})
  return normalized or {}
end

local function normalizeSettings(settings)
  local result = {}
  for _, key in ipairs({
    "chaos", "allowMissingParts", "protectCriticalParts", "contentFilter", "includeAutomation",
    "includeTrailers", "includeProps", "selectionFairness", "manualSeed",
  }) do result[key] = util.deepCopy(type(settings) == "table" and settings[key] or nil) end
  return result
end

M.normalizeSlots = normalizeSlots
M.normalizeTuning = normalizeTuning
M.normalizePaints = normalizePaints
M.normalizeSettings = normalizeSettings

return M
