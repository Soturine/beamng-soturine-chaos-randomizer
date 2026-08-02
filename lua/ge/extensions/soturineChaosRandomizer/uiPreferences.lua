local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

M.SCHEMA_VERSION = 1

local DEFAULT_RACE = {
  count = 4,
  participationMode = "spectator",
  preset = "Balanced",
  episodeSeed = "",
  acceptPartial = false,
  acceptMetadataUncertain = false,
  acceptPotentiallyUndrivable = false,
  avoidDuplicateModels = true,
  avoidDuplicateConfigurations = true,
  avoidDuplicateFamilies = false,
  maximumSameFamily = 2,
  diversifyVehicleClasses = true,
  diversifyPropulsion = false,
  diversifyDrivetrain = false,
  diversifySource = true,
  diversifyWheelStyles = false,
  diversifyBodyTypes = false,
  allowOfficialVehicles = true,
  allowModVehicles = true,
  allowAutomationVehicles = false,
  allowTrailers = false,
  allowProps = false,
  maxAttemptsPerCompetitor = 3,
  maxConsecutiveFailures = 4,
  retainAcceptedOnCancel = true,
  formation = "Automatic Best Fit",
  spacingMode = "automatic",
  longitudinalSpacing = 8,
  lateralSpacing = 5,
  safetyMargin = 1.5,
}

local BOOLEAN_RACE_FIELDS = {
  "acceptPartial", "acceptMetadataUncertain", "acceptPotentiallyUndrivable",
  "avoidDuplicateModels", "avoidDuplicateConfigurations", "avoidDuplicateFamilies",
  "diversifyVehicleClasses", "diversifyPropulsion", "diversifyDrivetrain",
  "diversifySource", "diversifyWheelStyles", "diversifyBodyTypes",
  "allowOfficialVehicles", "allowModVehicles", "allowAutomationVehicles",
  "allowTrailers", "allowProps", "retainAcceptedOnCancel",
}

local function defaults()
  return {
    schemaVersion = M.SCHEMA_VERSION,
    locale = "auto",
    race = util.deepCopy(DEFAULT_RACE),
    legacyRacePolicyImported = false,
  }
end

local function boundedNumber(value, fallback, minimum, maximum, integer)
  value = tonumber(value)
  if not value then return fallback end
  value = util.clamp(value, minimum, maximum)
  return integer and math.floor(value + 0.5) or value
end

local function normalize(raw)
  raw = type(raw) == "table" and raw or {}
  local result = defaults()
  if raw.locale == "en-US" or raw.locale == "pt-BR" then result.locale = raw.locale end
  result.legacyRacePolicyImported = raw.legacyRacePolicyImported == true
  local source = type(raw.race) == "table" and raw.race or {}
  local race = result.race
  for _, field in ipairs(BOOLEAN_RACE_FIELDS) do
    if type(source[field]) == "boolean" then race[field] = source[field] end
  end
  race.count = boundedNumber(source.count, race.count, 1, 32, true)
  race.maximumSameFamily = boundedNumber(source.maximumSameFamily, race.maximumSameFamily, 1, 32, true)
  race.maxAttemptsPerCompetitor = boundedNumber(source.maxAttemptsPerCompetitor, race.maxAttemptsPerCompetitor, 1, 10, true)
  race.maxConsecutiveFailures = boundedNumber(source.maxConsecutiveFailures, race.maxConsecutiveFailures, 1, 32, true)
  race.longitudinalSpacing = boundedNumber(source.longitudinalSpacing, race.longitudinalSpacing, 2, 50, false)
  race.lateralSpacing = boundedNumber(source.lateralSpacing, race.lateralSpacing, 1, 25, false)
  race.safetyMargin = boundedNumber(source.safetyMargin, race.safetyMargin, 0, 10, false)
  if source.participationMode == "player" or source.participationMode == "spectator" then
    race.participationMode = source.participationMode
  end
  local presets = {Balanced = true, ["Maximum Chaos"] = true, ["Mods Showcase"] = true, Custom = true}
  if presets[source.preset] then race.preset = source.preset end
  local formations = {
    ["Automatic Best Fit"] = true, ["Split Left and Right"] = true,
    ["Single File Behind"] = true, ["Single File Ahead"] = true,
    ["Staggered Grid"] = true, ["Side-by-side Grid"] = true,
    ["Circular / Radial"] = true,
  }
  if formations[source.formation] then race.formation = source.formation end
  if source.spacingMode == "automatic" or source.spacingMode == "manual" then race.spacingMode = source.spacingMode end
  if type(source.episodeSeed) == "string" then race.episodeSeed = source.episodeSeed:sub(1, 128) end
  return result
end

local function patch(current, value)
  local merged = normalize(current)
  value = type(value) == "table" and value or {}
  if value.locale ~= nil then merged.locale = value.locale end
  if type(value.race) == "table" then merged.race = util.shallowMerge(merged.race, value.race) end
  if value.legacyRacePolicyImported ~= nil then
    merged.legacyRacePolicyImported = value.legacyRacePolicyImported == true
  end
  return normalize(merged)
end

local function importLegacy(current, legacy)
  current = normalize(current)
  if current.legacyRacePolicyImported then return current, false end
  local nextValue = patch(current, {race = type(legacy) == "table" and legacy or {}})
  nextValue.legacyRacePolicyImported = true
  return nextValue, true
end

M.DEFAULT_RACE = DEFAULT_RACE
M.defaults = defaults
M.normalize = normalize
M.patch = patch
M.importLegacy = importLegacy

return M
