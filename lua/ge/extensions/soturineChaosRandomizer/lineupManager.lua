local util = require("ge/extensions/soturineChaosRandomizer/util")
local rng = require("ge/extensions/soturineChaosRandomizer/rng")
local schema = require("ge/extensions/soturineChaosRandomizer/lineupSchema")

local M = {}

local PRESETS = {Balanced = true, ["Maximum Chaos"] = true, ["Mods Showcase"] = true}
local RULE_DEFAULTS = {
  avoidDuplicateModels = true, avoidDuplicateConfigurations = true,
  avoidDuplicateFamilies = false, maximumSameFamily = 2,
  diversifyVehicleClasses = true, diversifyPropulsion = false,
  diversifyDrivetrain = false, diversifySource = true,
  diversifyWheelStyles = false, diversifyBodyTypes = false,
  allowOfficialVehicles = true, allowModVehicles = true,
  allowAutomationVehicles = false, allowTrailers = false, allowProps = false,
}

local TRAIT_FIELDS = {
  family = {"family", "Family", "platform", "Platform"},
  vehicleClass = {"vehicleClass", "VehicleClass", "class", "Class", "type", "Type"},
  propulsion = {"propulsion", "Propulsion", "fuelType", "FuelType"},
  drivetrain = {"drivetrain", "Drivetrain", "driveType", "DriveType"},
  wheelStyle = {"wheelStyle", "WheelStyle"},
  bodyType = {"bodyType", "BodyType", "bodyStyle", "BodyStyle"},
}

local function cleanEvidence(value)
  if type(value) ~= "string" and type(value) ~= "number" then return nil end
  value = tostring(value):gsub("[%z\1-\31]", " "):gsub("^%s+", ""):gsub("%s+$", "")
  local normalized = util.normalizeText(value)
  if value == "" or normalized == "unknown" or normalized == "unclassified" or normalized == "n/a" then return nil end
  return value:sub(1, 96)
end

local function firstEvidence(sources, keys)
  for _, source in ipairs(sources) do
    if type(source) == "table" then
      for _, key in ipairs(keys) do
        local value = cleanEvidence(source[key])
        if value then return value end
      end
    end
  end
  return nil
end

local function verifiedTraits(model, config)
  model = type(model) == "table" and model or {}
  config = type(config) == "table" and config or {}
  local sources = {config, config.raw, model, model.raw}
  local result = {
    modelKey = cleanEvidence(config.modelKey or model.key),
    configuration = cleanEvidence(config.key),
    sourceKind = cleanEvidence(config.sourceKind or model.sourceKind),
    automation = model.isAutomation == true or config.isAutomation == true,
    trailer = model.isTrailer == true or config.isTrailer == true,
    prop = model.isProp == true or config.isProp == true,
  }
  for field, keys in pairs(TRAIT_FIELDS) do result[field] = firstEvidence(sources, keys) end
  return result
end

local function metadataUncertain(traits)
  traits = type(traits) == "table" and traits or {}
  local source = util.normalizeText(traits.sourceKind)
  local sourceKnown = source == "official" or source == "mod" or source == "user"
  local descriptiveEvidence = traits.family or traits.vehicleClass or traits.propulsion
    or traits.drivetrain or traits.wheelStyle or traits.bodyType
  return not sourceKnown or descriptiveEvidence == nil
end

local function sameEvidence(left, right)
  local a, b = cleanEvidence(left), cleanEvidence(right)
  return a ~= nil and b ~= nil and util.normalizeText(a) == util.normalizeText(b)
end

local function previousTraits(previous)
  local result = {}
  for _, competitor in ipairs(type(previous) == "table" and previous or {}) do
    local verified = competitor.traits and competitor.traits.verified
    if type(verified) == "table" then result[#result + 1] = verified end
  end
  return result
end

local function hardAllowed(rules, candidate, previous)
  if candidate.sourceKind == "official" and rules.allowOfficialVehicles == false then return false, "official_source_disabled" end
  if candidate.sourceKind == "mod" and rules.allowModVehicles == false then return false, "mod_source_disabled" end
  if candidate.automation and rules.allowAutomationVehicles == false then return false, "automation_disabled" end
  if candidate.trailer and rules.allowTrailers == false then return false, "trailer_disabled" end
  if candidate.prop and rules.allowProps == false then return false, "prop_disabled" end
  local familyCount = 0
  for _, old in ipairs(previous) do
    if rules.avoidDuplicateModels and sameEvidence(candidate.modelKey, old.modelKey) then return false, "duplicate_model" end
    if rules.avoidDuplicateConfigurations and sameEvidence(candidate.modelKey, old.modelKey)
      and sameEvidence(candidate.configuration, old.configuration)
    then return false, "duplicate_configuration" end
    if sameEvidence(candidate.family, old.family) then familyCount = familyCount + 1 end
  end
  if candidate.family and rules.avoidDuplicateFamilies and familyCount > 0 then return false, "duplicate_family" end
  if candidate.family and familyCount >= (tonumber(rules.maximumSameFamily) or 2) then return false, "maximum_same_family" end
  return true
end

local DIVERSITY_FIELDS = {
  {rule = "diversifyVehicleClasses", field = "vehicleClass"},
  {rule = "diversifyPropulsion", field = "propulsion"},
  {rule = "diversifyDrivetrain", field = "drivetrain"},
  {rule = "diversifySource", field = "sourceKind"},
  {rule = "diversifyWheelStyles", field = "wheelStyle"},
  {rule = "diversifyBodyTypes", field = "bodyType"},
}

local function diversityScore(rules, candidate, previous)
  local score = 0
  for _, descriptor in ipairs(DIVERSITY_FIELDS) do
    local value = candidate[descriptor.field]
    if rules[descriptor.rule] and value ~= nil then
      local duplicate = false
      for _, old in ipairs(previous) do if sameEvidence(value, old[descriptor.field]) then duplicate = true; break end end
      if not duplicate then score = score + 1 end
    end
  end
  return score
end

local function filterModels(models, rules, acceptedCompetitors)
  rules = type(rules) == "table" and rules or RULE_DEFAULTS
  local old = previousTraits(acceptedCompetitors)
  local allowed, bestScore = {}, -1
  for _, model in ipairs(type(models) == "table" and models or {}) do
    local configs = {}
    for _, config in ipairs(model.configs or {}) do
      local traits = verifiedTraits(model, config)
      local ok = hardAllowed(rules, traits, old)
      if ok then
        local score = diversityScore(rules, traits, old)
        configs[#configs + 1] = {config = config, score = score}
        if score > bestScore then bestScore = score end
      end
    end
    if #configs > 0 then allowed[#allowed + 1] = {model = model, configs = configs} end
  end
  local result = {}
  for _, group in ipairs(allowed) do
    local copy = util.deepCopy(group.model)
    copy.configs = {}
    for _, item in ipairs(group.configs) do
      -- Diversity rules are preferences. Unknown metadata is never invented or
      -- rejected, and hard allow/duplicate rules remain authoritative.
      if bestScore <= 0 or item.score == bestScore then copy.configs[#copy.configs + 1] = util.deepCopy(item.config) end
    end
    if #copy.configs > 0 then result[#result + 1] = copy end
  end
  return result, {eligible = #result, bestDiversityScore = math.max(0, bestScore), previousWithEvidence = #old}
end

local function domainSeed(lineup, competitor, domain, attempt)
  if type(lineup) ~= "table" or type(competitor) ~= "table" then return nil, "lineup_seed_context_invalid" end
  local normalizedDomain = cleanEvidence(domain)
  if not normalizedDomain then return nil, "lineup_seed_domain_invalid" end
  local suffix = ":competitor:" .. string.format("%02d", tonumber(competitor.index) or 0)
    .. ":" .. util.normalizeText(normalizedDomain):gsub("%s+", "_")
    .. ":attempt:" .. tostring(math.max(1, math.floor(tonumber(attempt) or 1)))
  return rng.new(tostring(lineup.episodeSeed) .. suffix).seed
end

local function raceSeed(value)
  local numeric = rng.hashText(value or (tostring(os.time()) .. ":lineup"))
  local compact = string.format("%08X", numeric)
  return "RACE-" .. compact:sub(1, 4) .. "-" .. compact:sub(5, 8)
end

local function create(options)
  options = type(options) == "table" and options or {}
  local count = math.floor(tonumber(options.count) or 2)
  local minimum = options.advancedAllowOne == true and 1 or schema.MIN_COMPETITORS
  if count < minimum or count > schema.MAX_COMPETITORS then return nil, "lineup_competitor_limit" end
  local episodeSeed = raceSeed(options.episodeSeed)
  local preset = PRESETS[options.preset] and options.preset or "Balanced"
  local varietyRules = {}
  for key, default in pairs(RULE_DEFAULTS) do
    if type(default) == "boolean" then varietyRules[key] = options[key] == nil and default or options[key] == true
    else varietyRules[key] = math.max(1, math.min(16, math.floor(tonumber(options[key]) or default))) end
  end
  local lineup = {
    kind = "soturineChaosLineup", lineupSchemaVersion = schema.SCHEMA_VERSION,
    generatorVersion = 6,
    id = "lineup-" .. string.format("%08X", rng.hashText(episodeSeed .. ":" .. tostring(os.time()))),
    name = type(options.name) == "string" and options.name:sub(1, 80) or "Chaos Lineup",
    episodeSeed = episodeSeed, preset = preset, createdAt = os.time(), updatedAt = os.time(),
    settings = {
      preset = preset, count = count,
      acceptPartial = options.acceptPartial == true,
      acceptMetadataUncertain = options.acceptMetadataUncertain == true,
      acceptPotentiallyUndrivable = options.acceptPotentiallyUndrivable == true,
      maxAttemptsPerCompetitor = math.max(1, math.min(10, math.floor(tonumber(options.maxAttemptsPerCompetitor) or 3))),
      maxConsecutiveFailures = math.max(1, math.min(16, math.floor(tonumber(options.maxConsecutiveFailures) or 4))),
    }, varietyRules = varietyRules,
    spawnPlan = {}, aiPlan = {}, warnings = {}, dependencies = {},
    collectionName = "Chaos Lineup — " .. os.date("%Y-%m-%d"),
    competitors = {}, nextIndex = 1, active = true,
    acceptPartial = options.acceptPartial == true,
    acceptMetadataUncertain = options.acceptMetadataUncertain == true,
    acceptPotentiallyUndrivable = options.acceptPotentiallyUndrivable == true,
    maxAttemptsPerCompetitor = math.max(1, math.min(10, math.floor(tonumber(options.maxAttemptsPerCompetitor) or 3))),
    maxConsecutiveFailures = math.max(1, math.min(16, math.floor(tonumber(options.maxConsecutiveFailures) or 4))),
    consecutiveFailures = 0,
  }
  for index = 1, count do
    local seed = rng.new(episodeSeed .. ":competitor:" .. tostring(index)).seed
    lineup.competitors[index] = {
      index = index, id = lineup.id .. "-" .. tostring(index),
      name = "Competitor " .. tostring(index), seed = seed,
      status = "Pending", raceStatus = "Pending", traits = {verified = {}},
      compatibility = {status = "local"},
      attemptCount = 0, position = index, targetGeneration = 0,
      generationClosed = false,
      vehicleDNAId = nil, thumbnail = nil, notes = "",
    }
  end
  return lineup
end

local function nextCompetitor(lineup)
  if not lineup or not lineup.active then return nil end
  for index = lineup.nextIndex or 1, #lineup.competitors do
    local competitor = lineup.competitors[index]
    if competitor.status == "Pending" then
      competitor.targetGeneration = (competitor.targetGeneration or 0) + 1
      competitor.generationToken = competitor.id .. ":target:" .. tostring(competitor.targetGeneration)
      competitor.pendingWrites = 0
      competitor.pendingTimers = 0
      competitor.pendingCallbacks = 0
      competitor.status = "Generating"
      lineup.nextIndex = index
      lineup.updatedAt = os.time()
      return competitor
    end
  end
  lineup.active = false
  lineup.updatedAt = os.time()
  return nil
end

local function record(lineup, index, result, dna, targetGeneration)
  local competitor = lineup and lineup.competitors and lineup.competitors[index]
  if not competitor then return false, "lineup_competitor_missing" end
  if targetGeneration ~= nil and competitor.targetGeneration ~= targetGeneration then
    return false, "stale_callback_ignored"
  end
  result = type(result) == "table" and result or {}
  local details = type(result.details) == "table" and result.details or {}
  competitor.attemptCount = (competitor.attemptCount or 0) + 1
  local hasWarnings = type(details.warnings) == "table" and #details.warnings > 0
  local lifecycle = type(details.lifecycleAcceptance) == "table" and details.lifecycleAcceptance or {}
  competitor.pendingWrites = tonumber(lifecycle.pendingWrites) or 0
  competitor.pendingTimers = tonumber(lifecycle.pendingTimers) or 0
  competitor.pendingCallbacks = tonumber(lifecycle.pendingCallbacks) or 0
  local verified = type(details.verifiedTraits) == "table" and util.deepCopy(details.verifiedTraits) or {}
  local uncertain = details.metadataUncertain == true or metadataUncertain(verified)
  local potentiallyUndrivable = details.potentiallyUndrivable == true
  local acceptanceBlocked = (uncertain and not lineup.acceptMetadataUncertain)
    or (potentiallyUndrivable and not lineup.acceptPotentiallyUndrivable)
  local acceptedWarning = (uncertain and lineup.acceptMetadataUncertain)
    or (potentiallyUndrivable and lineup.acceptPotentiallyUndrivable)
  local ready = result.success == true and details.partial ~= true and not acceptanceBlocked
    and lifecycle.finalValidationPassed == true and lifecycle.busy == false
    and competitor.pendingWrites == 0 and competitor.pendingTimers == 0 and competitor.pendingCallbacks == 0
    and dna ~= nil
  competitor.status = result.success == true and (
    details.partial and "Partial"
    or ready and ((hasWarnings or acceptedWarning) and "Ready with warnings" or "Ready")
    or "Partial"
  ) or "Failed"
  competitor.generationStatus = competitor.status
  competitor.warning = result.success == true and details.partial and result.message or (result.success and nil or result.message)
  competitor.dna = dna and util.deepCopy(dna) or nil
  competitor.dnaId = dna and dna.id or nil
  competitor.vehicleDNAId = competitor.dnaId
  competitor.thumbnail = dna and util.deepCopy(dna.thumbnail) or nil
  competitor.modelKey = dna and dna.final and dna.final.modelKey or details.model
  competitor.configuration = details.configuration or dna and dna.base and (dna.base.configKey or dna.base.configPath)
  competitor.source = details.baseConfiguration and {kind = details.baseConfiguration.sourceKind, label = details.baseConfiguration.sourceLabel} or nil
  competitor.dependencies = dna and util.deepCopy(dna.dependencies or {}) or {}
  competitor.coverage = util.deepCopy(details.coverage)
  competitor.raceStatus = "Pending"
  competitor.traits = {
    verified = verified,
    metadataUncertain = uncertain,
    potentiallyUndrivable = potentiallyUndrivable,
  }
  competitor.generationClosed = true
  if acceptanceBlocked then
    competitor.warning = uncertain and not lineup.acceptMetadataUncertain
      and "Metadata-uncertain result requires explicit acceptance"
      or "Potentially undrivable result requires explicit acceptance"
  elseif competitor.status == "Partial" and not lineup.acceptPartial then
    competitor.warning = "Partial result requires explicit acceptance"
  elseif acceptedWarning and not competitor.warning then
    competitor.warning = uncertain and "Metadata uncertainty was explicitly accepted"
      or "Potentially undrivable status was explicitly accepted"
  end
  lineup.nextIndex = index + 1
  lineup.updatedAt = os.time()
  return true
end

local function resolveFailure(lineup, index, action)
  local competitor = lineup and lineup.competitors and lineup.competitors[index]
  if not competitor then return false, "lineup_competitor_missing" end
  if competitor.status ~= "Failed" and competitor.status ~= "Partial" then return false, "lineup_competitor_not_failed" end
  if action == "retry" then
    if (competitor.attemptCount or 0) >= (lineup.maxAttemptsPerCompetitor or 3) then return false, "lineup_attempt_limit" end
    competitor.status, competitor.generationStatus, competitor.generationClosed = "Pending", "Pending", false
    competitor.warning = "Retry requested with a new target generation and independent retry substream"
    lineup.nextIndex, lineup.active = index, true
  elseif action == "fallback" then
    competitor.status, competitor.generationStatus, competitor.generationClosed = "Pending", "Pending", false
    competitor.forceOfficialFallback = true
    competitor.warning = "Verified official fallback requested"
    lineup.nextIndex, lineup.active = index, true
  elseif action == "skip" then
    competitor.status, competitor.generationStatus, competitor.generationClosed = "Skipped", "Skipped", true
    competitor.warning = "Slot skipped by user"
    lineup.nextIndex, lineup.active = math.max(lineup.nextIndex or 1, index + 1), true
  elseif action == "stop" then
    lineup.active = false
    competitor.warning = "Generation stopped by user"
  else
    return false, "lineup_failure_action_invalid"
  end
  lineup.updatedAt = os.time()
  return true
end

local function summary(lineup)
  local result = {
    active = lineup and lineup.active == true, total = 0, ready = 0, partial = 0,
    failed = 0, pending = 0, retries = 0, quarantinedCandidates = 0,
    totalGenerationTime = lineup and math.max(0, os.time() - (tonumber(lineup.createdAt) or os.time())) or 0,
  }
  for _, competitor in ipairs(lineup and lineup.competitors or {}) do
    result.total = result.total + 1
    if competitor.status == "Ready" or competitor.status == "Ready with warnings" then result.ready = result.ready + 1
    elseif competitor.status == "Partial" then result.partial = result.partial + 1
    elseif competitor.status == "Failed" then result.failed = result.failed + 1
    else result.pending = result.pending + 1 end
    result.retries = result.retries + math.max(0, (competitor.attemptCount or 0) - 1)
    if competitor.forceOfficialFallback or competitor.quarantinedCandidateReplaced then
      result.quarantinedCandidates = result.quarantinedCandidates + 1
    end
  end
  return result
end

M.PRESETS = PRESETS
M.RULE_DEFAULTS = RULE_DEFAULTS
M.raceSeed = raceSeed
M.verifiedTraits = verifiedTraits
M.metadataUncertain = metadataUncertain
M.filterModels = filterModels
M.domainSeed = domainSeed
M.create = create
M.nextCompetitor = nextCompetitor
M.record = record
M.resolveFailure = resolveFailure
M.summary = summary

return M
