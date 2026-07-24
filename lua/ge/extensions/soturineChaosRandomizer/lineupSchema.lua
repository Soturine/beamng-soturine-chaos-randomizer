local util = require("ge/extensions/soturineChaosRandomizer/util")
local dnaSchema = require("ge/extensions/soturineChaosRandomizer/vehicleDNASchema")

local M = {}

M.SCHEMA_VERSION = 1
M.MIN_COMPETITORS = 2
M.MAX_COMPETITORS = 16

local STATUSES = {
  Pending = true, Generating = true, Ready = true, ["Ready with warnings"] = true,
  Partial = true, Failed = true, Skipped = true,
  ["Quarantined candidate replaced"] = true, Spawned = true, Destroyed = true,
}
local RACE_STATUSES = {
  Pending = true, Ready = true, Eliminated = true, Qualified = true,
  Winner = true, DNS = true, DNF = true,
}

local function text(value, maximum)
  return type(value) == "string" and #value > 0 and #value <= maximum
end

local function validate(lineup, options)
  options = options or {}
  if type(lineup) ~= "table" or lineup.kind ~= "soturineChaosLineup" then return false, "lineup_format_invalid" end
  if tonumber(lineup.lineupSchemaVersion) ~= M.SCHEMA_VERSION then return false, "lineup_schema_unsupported" end
  if tonumber(lineup.generatorVersion) ~= 6 then return false, "lineup_generator_unsupported" end
  if not text(lineup.id, 128) or not text(lineup.name, 80) or not text(lineup.episodeSeed, 64) then return false, "lineup_identity_invalid" end
  if type(lineup.competitors) ~= "table" then return false, "lineup_competitors_invalid" end
  for _, field in ipairs({"settings", "varietyRules", "spawnPlan", "aiPlan", "warnings", "dependencies"}) do
    if type(lineup[field]) ~= "table" then return false, "lineup_" .. field .. "_invalid" end
  end
  local minimum = options.allowOne == true and 1 or M.MIN_COMPETITORS
  if #lineup.competitors < minimum or #lineup.competitors > M.MAX_COMPETITORS then return false, "lineup_competitor_limit" end
  local seen = {}
  for index, competitor in ipairs(lineup.competitors) do
    if type(competitor) ~= "table" or tonumber(competitor.index) ~= index then return false, "lineup_competitor_index_invalid" end
    if not text(competitor.id, 128) or seen[competitor.id] then return false, "lineup_competitor_id_invalid" end
    seen[competitor.id] = true
    if not text(competitor.seed, 64) or not text(competitor.name, 80) or not STATUSES[competitor.status] then
      return false, "lineup_competitor_invalid"
    end
    if competitor.dna ~= nil then
      local valid = dnaSchema.validateEntry(competitor.dna)
      if not valid then return false, "lineup_dna_invalid" end
    end
    if competitor.compatibility ~= nil and type(competitor.compatibility) ~= "table" then return false, "lineup_compatibility_invalid" end
    if competitor.traits ~= nil and type(competitor.traits) ~= "table" then return false, "lineup_traits_invalid" end
    if competitor.raceStatus ~= nil and not RACE_STATUSES[competitor.raceStatus] then return false, "lineup_race_status_invalid" end
    if competitor.position ~= nil and (tonumber(competitor.position) ~= index or index < 1) then return false, "lineup_position_invalid" end
    if competitor.targetGeneration ~= nil and (not util.isFinite(tonumber(competitor.targetGeneration)) or tonumber(competitor.targetGeneration) < 0) then return false, "lineup_generation_invalid" end
    if competitor.vehicleDNAId ~= nil and not text(competitor.vehicleDNAId, 128) then return false, "lineup_dna_identity_invalid" end
    if competitor.notes ~= nil and (type(competitor.notes) ~= "string" or #competitor.notes > 2048) then return false, "lineup_notes_invalid" end
    if competitor.thumbnail ~= nil and type(competitor.thumbnail) ~= "table" then return false, "lineup_thumbnail_invalid" end
  end
  if lineup.createdAt ~= nil and not util.isFinite(tonumber(lineup.createdAt)) then return false, "lineup_timestamp_invalid" end
  return true
end

local function sanitizedImport(lineup)
  if type(lineup) ~= "table" then return nil, "lineup_format_invalid" end
  local copy = {
    kind = lineup.kind, lineupSchemaVersion = lineup.lineupSchemaVersion,
    generatorVersion = lineup.generatorVersion,
    id = lineup.id, name = lineup.name, episodeSeed = lineup.episodeSeed,
    preset = lineup.preset, createdAt = lineup.createdAt, updatedAt = lineup.updatedAt,
    settings = util.deepCopy(lineup.settings), varietyRules = util.deepCopy(lineup.varietyRules),
    spawnPlan = util.deepCopy(lineup.spawnPlan), aiPlan = util.deepCopy(lineup.aiPlan),
    warnings = util.deepCopy(lineup.warnings), dependencies = util.deepCopy(lineup.dependencies),
    collectionName = lineup.collectionName,
    maxAttemptsPerCompetitor = lineup.maxAttemptsPerCompetitor,
    maxConsecutiveFailures = lineup.maxConsecutiveFailures,
    competitors = {},
  }
  for _, competitor in ipairs(type(lineup.competitors) == "table" and lineup.competitors or {}) do
    copy.competitors[#copy.competitors + 1] = {
      index = competitor.index, id = competitor.id, name = competitor.name,
      seed = competitor.seed, status = competitor.status, warning = competitor.warning,
      dnaId = competitor.dnaId, vehicleDNAId = competitor.vehicleDNAId or competitor.dnaId,
      dna = util.deepCopy(competitor.dna),
      traits = util.deepCopy(competitor.traits), raceStatus = competitor.raceStatus,
      position = competitor.position, attemptCount = competitor.attemptCount,
      modelKey = competitor.modelKey, configuration = competitor.configuration,
      source = util.deepCopy(competitor.source), dependencies = util.deepCopy(competitor.dependencies),
      coverage = util.deepCopy(competitor.coverage), generationStatus = competitor.generationStatus,
      thumbnail = util.deepCopy(competitor.thumbnail), notes = competitor.notes,
      targetGeneration = competitor.targetGeneration,
      compatibility = {status = "requires_local_recompute"},
    }
  end
  local valid, reason = validate(copy, {allowOne = true})
  if not valid then return nil, reason end
  return copy
end

M.validate = validate
M.sanitizedImport = sanitizedImport
M.STATUSES = STATUSES
M.RACE_STATUSES = RACE_STATUSES

return M
