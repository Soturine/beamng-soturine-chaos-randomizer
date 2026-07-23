local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local DEFAULTS = {
  schemaVersion = 1,
  chaos = 75,
  allowMissingParts = true,
  keepVehicleDrivable = false,
  contentFilter = "everything",
  includeAutomation = false,
  includeTrailers = false,
  includeProps = false,
  selectionFairness = "vehicle",
  historyLimit = 10,
  diagnosticLogging = false,
  manualSeed = "",
}

local FILTERS = {everything = true, official = true, mods = true}
local FAIRNESS = {vehicle = true, configuration = true}

local function boolOrDefault(value, fallback)
  if type(value) == "boolean" then return value end
  return fallback
end

local function migrate(raw)
  raw = type(raw) == "table" and util.deepCopy(raw) or {}
  local version = math.floor(tonumber(raw.schemaVersion) or 0)

  if version < 1 then
    if raw.allowEmptyParts ~= nil and raw.allowMissingParts == nil then
      raw.allowMissingParts = raw.allowEmptyParts
    end
    if raw.fairMode ~= nil and raw.selectionFairness == nil then
      raw.selectionFairness = raw.fairMode and "vehicle" or "configuration"
    end
  end

  raw.schemaVersion = 1
  raw.allowEmptyParts = nil
  raw.fairMode = nil
  return raw
end

local function validate(raw)
  raw = migrate(raw)
  local result = util.deepCopy(DEFAULTS)

  result.chaos = math.floor(util.clamp(raw.chaos or result.chaos, 0, 100) + 0.5)
  result.allowMissingParts = boolOrDefault(raw.allowMissingParts, result.allowMissingParts)
  result.keepVehicleDrivable = boolOrDefault(raw.keepVehicleDrivable, result.keepVehicleDrivable)
  result.includeAutomation = boolOrDefault(raw.includeAutomation, result.includeAutomation)
  result.includeTrailers = boolOrDefault(raw.includeTrailers, result.includeTrailers)
  result.includeProps = boolOrDefault(raw.includeProps, result.includeProps)
  result.diagnosticLogging = boolOrDefault(raw.diagnosticLogging, result.diagnosticLogging)

  if FILTERS[raw.contentFilter] then result.contentFilter = raw.contentFilter end
  if FAIRNESS[raw.selectionFairness] then result.selectionFairness = raw.selectionFairness end
  result.historyLimit = math.floor(util.clamp(raw.historyLimit or result.historyLimit, 1, 50))
  if type(raw.manualSeed) == "string" then
    result.manualSeed = string.sub(raw.manualSeed:gsub("^%s+", ""):gsub("%s+$", ""), 1, 128)
  end
  return result
end

local function update(current, patch)
  return validate(util.shallowMerge(current or DEFAULTS, patch or {}))
end

M.defaults = function() return util.deepCopy(DEFAULTS) end
M.migrate = migrate
M.validate = validate
M.update = update

return M
