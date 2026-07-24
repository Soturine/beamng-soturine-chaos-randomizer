local util = require("ge/extensions/soturineChaosRandomizer/util")
local vehicleDNALocks = require("ge/extensions/soturineChaosRandomizer/vehicleDNALocks")

local M = {}

local DEFAULTS = {
  schemaVersion = 5,
  chaos = 75,
  allowMissingParts = true,
  protectCriticalParts = false,
  contentFilter = "everything",
  includeAutomation = false,
  includeTrailers = false,
  includeProps = false,
  selectionFairness = "vehicle",
  historyLimit = 10,
  diagnosticLogging = false,
  manualSeed = "",
  dnaLibraryLimit = 100,
  autoSaveDNA = false,
  defaultRestoreMode = "exact",
  extremeTuning = false,
  allowPartialResult = false,
  lockProfile = vehicleDNALocks.empty(),
}

local FILTERS = {everything = true, official = true, mods = true}
local FAIRNESS = {vehicle = true, configuration = true}
local RESTORE_MODES = {exact = true, compatible = true}

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

  if version < 2 and raw.protectCriticalParts == nil and raw.keepVehicleDrivable ~= nil then
    raw.protectCriticalParts = raw.keepVehicleDrivable
  end

  if version < 3 then
    if raw.dnaLimit ~= nil and raw.dnaLibraryLimit == nil then raw.dnaLibraryLimit = raw.dnaLimit end
  end

  if version < 4 and raw.lockProfile == nil then raw.lockProfile = vehicleDNALocks.empty() end

  raw.schemaVersion = 5
  raw.allowEmptyParts = nil
  raw.fairMode = nil
  raw.keepVehicleDrivable = nil
  raw.dnaLimit = nil
  return raw
end

local function validate(raw)
  raw = migrate(raw)
  local result = util.deepCopy(DEFAULTS)

  result.chaos = math.floor(util.clamp(raw.chaos or result.chaos, 0, 100) + 0.5)
  result.allowMissingParts = boolOrDefault(raw.allowMissingParts, result.allowMissingParts)
  result.protectCriticalParts = boolOrDefault(raw.protectCriticalParts, result.protectCriticalParts)
  result.includeAutomation = boolOrDefault(raw.includeAutomation, result.includeAutomation)
  result.includeTrailers = boolOrDefault(raw.includeTrailers, result.includeTrailers)
  result.includeProps = boolOrDefault(raw.includeProps, result.includeProps)
  result.diagnosticLogging = boolOrDefault(raw.diagnosticLogging, result.diagnosticLogging)
  result.autoSaveDNA = false
  result.extremeTuning = boolOrDefault(raw.extremeTuning, result.extremeTuning)
  result.allowPartialResult = boolOrDefault(raw.allowPartialResult, result.allowPartialResult)

  if FILTERS[raw.contentFilter] then result.contentFilter = raw.contentFilter end
  if FAIRNESS[raw.selectionFairness] then result.selectionFairness = raw.selectionFairness end
  result.historyLimit = math.floor(util.clamp(raw.historyLimit or result.historyLimit, 1, 50))
  result.dnaLibraryLimit = math.floor(util.clamp(raw.dnaLibraryLimit or result.dnaLibraryLimit, 1, 100))
  if RESTORE_MODES[raw.defaultRestoreMode] then result.defaultRestoreMode = raw.defaultRestoreMode end
  result.lockProfile = vehicleDNALocks.normalize(raw.lockProfile)
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
