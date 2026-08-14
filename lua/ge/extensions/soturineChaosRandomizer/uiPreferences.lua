local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

M.SCHEMA_VERSION = 2

local SUPPORTED_LOCALES = { ["en-US"] = true, ["pt-BR"] = true, ["es-ES"] = true }

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
  formation = "AUTO_BEST_FIT",
  previewEnabled = true,
  previewOrigin = "automatic",
  headingMode = "camera",
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
  "allowTrailers", "allowProps", "retainAcceptedOnCancel", "previewEnabled",
}

local function defaults()
  return {
    schemaVersion = M.SCHEMA_VERSION,
    localeMode = "auto",
    manualLocale = "en-US",
    race = util.deepCopy(DEFAULT_RACE),
    compatibilityWarningDismissed = false,
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
  if raw.localeMode == "manual" and SUPPORTED_LOCALES[raw.manualLocale] then
    result.localeMode = "manual"
    result.manualLocale = raw.manualLocale
  elseif raw.localeMode == "auto" then
    result.localeMode = "auto"
    if SUPPORTED_LOCALES[raw.manualLocale] then result.manualLocale = raw.manualLocale end
  elseif SUPPORTED_LOCALES[raw.locale] then
    result.localeMode = "manual"
    result.manualLocale = raw.locale
  elseif raw.locale == "auto" then
    result.localeMode = "auto"
  end
  result.legacyRacePolicyImported = raw.legacyRacePolicyImported == true
  result.compatibilityWarningDismissed = raw.compatibilityWarningDismissed == true
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
  local formation = require("ge/extensions/soturineChaosRandomizer/formationEnum")
  race.formation = formation.normalize(source.formation or race.formation)
  local origins = {automatic = true, player_front = true, player_behind = true,
    camera = true, custom = true}
  local headings = {camera = true, player = true, road = true, destination = true}
  if origins[source.previewOrigin] then race.previewOrigin = source.previewOrigin end
  if headings[source.headingMode] then race.headingMode = source.headingMode end
  for _, field in ipairs({"customPointX", "customPointY", "customPointZ"}) do
    if tonumber(source[field]) then race[field] = tonumber(source[field]) end
  end
  if source.spacingMode == "automatic" or source.spacingMode == "manual" then race.spacingMode = source.spacingMode end
  if type(source.episodeSeed) == "string" then race.episodeSeed = source.episodeSeed:sub(1, 128) end
  return result
end

local function patch(current, value)
  local merged = normalize(current)
  value = type(value) == "table" and value or {}
  if value.localeMode ~= nil then merged.localeMode = value.localeMode end
  if value.manualLocale ~= nil then merged.manualLocale = value.manualLocale end
  if value.locale ~= nil then
    if value.locale == "auto" then merged.localeMode = "auto"
    elseif SUPPORTED_LOCALES[value.locale] then
      merged.localeMode = "manual"
      merged.manualLocale = value.locale
    end
  end
  if type(value.race) == "table" then merged.race = util.shallowMerge(merged.race, value.race) end
  if value.legacyRacePolicyImported ~= nil then
    merged.legacyRacePolicyImported = value.legacyRacePolicyImported == true
  end
  if value.compatibilityWarningDismissed ~= nil then
    merged.compatibilityWarningDismissed = value.compatibilityWarningDismissed == true
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
