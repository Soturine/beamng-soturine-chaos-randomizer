local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local function valuesSorted(source, keyFunction)
  local result = {}
  if type(source) ~= "table" then return result end
  for _, value in pairs(source) do
    if type(value) == "table" then result[#result + 1] = value end
  end
  table.sort(result, function(a, b)
    local aKey = keyFunction(a)
    local bKey = keyFunction(b)
    return aKey < bKey
  end)
  return result
end

local OFFICIAL_SOURCE_ALIASES = {
  ["beamng - official"] = true,
  official = true,
}

local SUSPECT_LIMIT = 128
local SUSPECT_TTL = 900
local FINGERPRINT_LIMIT = 8
local SUSPECT_PROMOTION_SCORE = 1.5
local SUSPECT_SUPPRESSION_SCORE = 1.0

local function sourceKind(item)
  item = type(item) == "table" and item or {}
  local label = util.normalizeText(item.Source or item.source or item.sourceLabel)
  if item.userSaved == true or item.player == true or label == "custom" then return "user" end
  if item.modID ~= nil or item.modId ~= nil then return "mod" end
  if type(item.pathOwnership) == "table" and item.pathOwnership.kind == "mod" then return "mod" end
  if OFFICIAL_SOURCE_ALIASES[label] then return "official" end
  if label == "mod" then return "mod" end
  return "unknown"
end

local function sourceStrategy(item)
  item = type(item) == "table" and item or {}
  local label = util.normalizeText(item.Source or item.source or item.sourceLabel)
  if item.userSaved == true or item.player == true or label == "custom" then return "explicit_user" end
  if item.modID ~= nil or item.modId ~= nil then return "explicit_config_mod_identity" end
  if type(item.pathOwnership) == "table" and item.pathOwnership.kind == "mod" then
    return item.pathOwnership.strategy or "confirmed_path_ownership"
  end
  if OFFICIAL_SOURCE_ALIASES[label] then return "explicit_official" end
  if label == "mod" then return "explicit_mod_label" end
  return "unknown"
end

local function normalizeModel(raw)
  local key = raw.key or raw.model_key or raw.modelKey
  if type(key) ~= "string" or key == "" then return nil end
  local itemType = raw.Type or raw.type or raw.Category or raw.category or "Unknown"
  local source = raw.Source or raw.source or "Unknown"
  local normalizedType = util.normalizeText(itemType)

  return {
    key = key,
    name = raw.Name or raw.name or key,
    brand = raw.Brand or raw.brand or "",
    type = itemType,
    sourceKind = sourceKind(raw),
    sourceLabel = source,
    sourceStrategy = sourceStrategy(raw),
    isAutomation = raw.isAutomation == true or normalizedType == "automation",
    isTrailer = raw.isTrailer == true or normalizedType == "trailer",
    isProp = raw.isProp == true or normalizedType == "prop" or normalizedType == "props",
    defaultConfig = raw.default_pc or raw.defaultConfig,
    configs = {},
    raw = util.deepCopy(raw),
  }
end

local function normalizeConfig(raw, modelsByKey)
  local modelKey = raw.model_key or raw.modelKey or raw.model
  local key = raw.key or raw.config_key or raw.configKey
  if type(modelKey) ~= "string" or modelKey == "" or type(key) ~= "string" or key == "" then return nil end
  local model = modelsByKey[modelKey]
  if not model then return nil end

  local source = raw.Source or raw.source or raw.sourceLabel
  if (source == nil or util.normalizeText(source) == "unknown") and type(raw.pathOwnership) == "table" then
    source = raw.pathOwnership.sourceLabel
  end
  source = source or "Unknown"
  local kind = sourceKind(raw)
  return {
    modelKey = modelKey,
    key = key,
    name = raw.Name or raw.Configuration or raw.name or key,
    path = raw.pcFilename or raw.path or key,
    sourceKind = kind,
    sourceLabel = source,
    sourceStrategy = sourceStrategy(raw),
    pathOwnership = util.deepCopy(raw.pathOwnership),
    userSaved = kind == "user" or raw.userSaved == true or raw.player == true,
    valid = raw.valid ~= false,
    failureCount = 0,
    raw = util.deepCopy(raw),
  }
end

local function create()
  return {
    valid = false,
    builtAt = nil,
    duration = 0,
    models = {},
    modelsByKey = {},
    allConfigs = {},
    failures = {},
    blacklists = {model = {}, config = {}, part = {}, tuning = {}},
    suspects = {part = {}},
    lastSuspect = nil,
    lastBlocked = nil,
    failureThreshold = 3,
  }
end

local function build(index, rawModels, rawConfigs, builtAt, duration)
  index.models = {}
  index.modelsByKey = {}
  index.allConfigs = {}

  local models = valuesSorted(rawModels, function(raw)
    return tostring(raw.key or raw.model_key or raw.modelKey or "")
  end)
  for _, raw in ipairs(models) do
    local model = normalizeModel(raw)
    if model then
      index.models[#index.models + 1] = model
      index.modelsByKey[model.key] = model
    end
  end

  local configs = valuesSorted(rawConfigs, function(raw)
    return tostring(raw.model_key or raw.modelKey or raw.model or "") .. "/" .. tostring(raw.key or raw.config_key or raw.configKey or "")
  end)
  for _, raw in ipairs(configs) do
    local config = normalizeConfig(raw, index.modelsByKey)
    if config then
      local model = index.modelsByKey[config.modelKey]
      model.configs[#model.configs + 1] = config
      index.allConfigs[#index.allConfigs + 1] = config
    end
  end

  for _, model in ipairs(index.models) do
    table.sort(model.configs, function(a, b) return a.key < b.key end)
  end
  index.valid = #index.models > 0 and #index.allConfigs > 0
  index.builtAt = builtAt
  index.duration = tonumber(duration) or 0
  return index.valid, {
    models = #index.models,
    configurations = #index.allConfigs,
    duration = index.duration,
  }
end

local function contentAllowed(kind, filter)
  if filter == "official" then return kind == "official" end
  if filter == "mods" then return kind == "mod" end
  return true
end

local function identifier(kind, context)
  context = type(context) == "table" and context or {key = context}
  if kind == "model" then return "model:" .. tostring(context.modelKey or context.key or "") end
  if kind == "config" then
    return "config:" .. tostring(context.modelKey or "") .. "/" .. tostring(context.configKey or context.key or "")
  end
  if kind == "part" then
    return "part:" .. tostring(context.modelKey or "") .. ":" .. tostring(context.slotPath or "") .. ":" .. tostring(context.candidate or context.key or "")
  end
  if kind == "tuning" then
    return "tuning:" .. tostring(context.modelKey or "") .. ":" .. tostring(context.tuningVariable or context.key or "")
  end
  return tostring(kind) .. ":" .. tostring(context.key or "")
end

local function isBlacklisted(index, kind, context)
  local bucket = index.blacklists and index.blacklists[kind]
  return type(bucket) == "table" and bucket[identifier(kind, context)] ~= nil
end


local function fingerprintCount(record)
  local count = 0
  for _ in pairs(record.batchFingerprints or {}) do count = count + 1 end
  return count
end

local function suspectCount(index)
  local count = 0
  for _ in pairs(index.suspects and index.suspects.part or {}) do count = count + 1 end
  return count
end

local function pruneSuspects(index, now)
  now = tonumber(now) or os.time()
  local records = {}
  for id, record in pairs(index.suspects.part or {}) do
    if now - (tonumber(record.lastSeenAt) or now) > SUSPECT_TTL then
      index.suspects.part[id] = nil
    else
      records[#records + 1] = record
    end
  end
  table.sort(records, function(a, b)
    if a.lastSeenAt ~= b.lastSeenAt then return a.lastSeenAt < b.lastSeenAt end
    return a.id < b.id
  end)
  while #records > SUSPECT_LIMIT do
    local record = table.remove(records, 1)
    index.suspects.part[record.id] = nil
  end
end

local function suspectRecord(index, id, context)
  local record = index.suspects.part[id]
  if not record then
    record = {
      id = id,
      modelKey = context.modelKey,
      slotPath = context.slotPath,
      candidate = context.candidate,
      suspicionScore = 0,
      failedBatchCount = 0,
      singleFailureCount = 0,
      successfulUseCount = 0,
      suppressionsRemaining = 0,
      batchFingerprints = {},
    }
    index.suspects.part[id] = record
  end
  return record
end

local function rememberFingerprint(record, fingerprint, now)
  if type(fingerprint) ~= "string" or fingerprint == "" then return end
  record.batchFingerprints[fingerprint] = now
  local values = {}
  for value, seenAt in pairs(record.batchFingerprints) do values[#values + 1] = {value = value, seenAt = seenAt} end
  table.sort(values, function(a, b)
    if a.seenAt ~= b.seenAt then return a.seenAt < b.seenAt end
    return a.value < b.value
  end)
  while #values > FINGERPRINT_LIMIT do
    record.batchFingerprints[table.remove(values, 1).value] = nil
  end
end

local function blockPart(index, id, record, failure, reason)
  index.blacklists.part[id] = {
    id = id,
    type = "part",
    reason = reason or failure and (failure.code or failure.reason) or "suspect_evidence_threshold",
    failureCount = record.singleFailureCount + record.failedBatchCount,
    suspicionScore = record.suspicionScore,
    seed = failure and failure.seed or record.lastSeed,
    timestamp = failure and failure.timestamp or record.lastSeenAt,
  }
  index.lastBlocked = util.deepCopy(index.blacklists.part[id])
end

local function isCandidateEligible(index, context)
  if isBlacklisted(index, "part", context) then return false, "candidate_blacklisted" end
  local record = index.suspects.part[identifier("part", context)]
  if record and (record.suppressionsRemaining or 0) > 0 then
    record.suppressionsRemaining = record.suppressionsRemaining - 1
    index.lastSuspect = util.deepCopy(record)
    return false, "candidate_suspect_suppressed"
  end
  return true
end

local function eligibleModels(index, settings)
  settings = settings or {}
  local result = {}
  for _, model in ipairs(index.models) do
    if #model.configs > 0
      and (settings.includeAutomation or not model.isAutomation)
      and (settings.includeTrailers or not model.isTrailer)
      and (settings.includeProps or not model.isProp)
      and not isBlacklisted(index, "model", {modelKey = model.key})
    then
      local copy = util.deepCopy(model)
      copy.configs = {}
      for _, config in ipairs(model.configs) do
        if config.valid and contentAllowed(config.sourceKind, settings.contentFilter)
          and not isBlacklisted(index, "config", {modelKey = config.modelKey, configKey = config.key})
        then
          copy.configs[#copy.configs + 1] = util.deepCopy(config)
        end
      end
      if #copy.configs > 0 then result[#result + 1] = copy end
    end
  end
  return result
end

local function eligibleConfigs(index, settings)
  local result = {}
  for _, model in ipairs(eligibleModels(index, settings)) do
    for _, config in ipairs(model.configs) do result[#result + 1] = config end
  end
  table.sort(result, function(a, b)
    if a.modelKey == b.modelKey then return a.key < b.key end
    return a.modelKey < b.modelKey
  end)
  return result
end

local function recordFailure(index, kind, context, failure)
  context = type(context) == "table" and context or {key = context}
  local id = identifier(kind, context)
  local now = tonumber(failure and failure.timestamp or context.timestamp) or os.time()
  local threshold = tonumber(context.threshold) or index.failureThreshold
  if kind == "part" then
    local record = suspectRecord(index, id, context)
    record.lastSeenAt = now
    record.lastFailureCode = failure and (failure.code or failure.reason) or context.reason
    record.lastSeed = failure and failure.seed or context.seed
    if context.suspectBatch == true then
      local batchSize = math.max(2, math.floor(tonumber(context.batchSize) or 2))
      record.failedBatchCount = record.failedBatchCount + 1
      record.suspicionScore = record.suspicionScore + (1 / batchSize)
      rememberFingerprint(record, context.batchFingerprint, now)
      index.failures[id] = record.singleFailureCount + record.failedBatchCount
      if record.failedBatchCount >= threshold and record.suspicionScore >= SUSPECT_PROMOTION_SCORE
        and fingerprintCount(record) >= 2
      then
        blockPart(index, id, record, failure)
      elseif record.suspicionScore >= SUSPECT_SUPPRESSION_SCORE and fingerprintCount(record) >= 2 then
        record.suppressionsRemaining = math.max(record.suppressionsRemaining or 0, 1)
      end
    else
      record.singleFailureCount = record.singleFailureCount + 1
      record.suspicionScore = record.suspicionScore + 1
      index.failures[id] = record.singleFailureCount + record.failedBatchCount
      if record.singleFailureCount >= threshold then blockPart(index, id, record, failure) end
    end
    index.lastSuspect = util.deepCopy(record)
    pruneSuspects(index, now)
    return index.failures[id], isBlacklisted(index, kind, context), id, util.deepCopy(record)
  end

  index.failures[id] = (index.failures[id] or 0) + 1
  if index.failures[id] >= threshold then
    index.blacklists[kind][id] = {
      id = id,
      type = kind,
      reason = failure and (failure.code or failure.reason) or context.reason or "failure_threshold",
      failureCount = index.failures[id],
      seed = failure and failure.seed or context.seed,
      timestamp = failure and failure.timestamp or context.timestamp,
    }
    index.lastBlocked = util.deepCopy(index.blacklists[kind][id])
  end
  return index.failures[id], isBlacklisted(index, kind, context), id
end

local function recordSuccess(index, kind, context, timestamp)
  if kind ~= "part" then return false end
  local id = identifier(kind, context)
  local record = index.suspects.part[id]
  if not record then return false end
  local previousScore = record.suspicionScore
  record.successfulUseCount = record.successfulUseCount + 1
  record.suspicionScore = math.max(0, record.suspicionScore - 1)
  record.suppressionsRemaining = 0
  record.lastSeenAt = tonumber(timestamp) or os.time()
  if record.suspicionScore <= 0 and record.singleFailureCount == 0 then
    record.resolution = "cleared_by_success"
    index.lastSuspect = util.deepCopy(record)
    index.suspects.part[id] = nil
  else
    record.resolution = "reduced_by_success"
    index.lastSuspect = util.deepCopy(record)
  end
  pruneSuspects(index, record.lastSeenAt)
  return true, {
    id = id,
    previousScore = previousScore,
    suspicionScore = record.suspicionScore,
    successfulUseCount = record.successfulUseCount,
    resolution = record.resolution,
  }
end

local function clearFailures(index)
  index.failures = {}
  index.blacklists = {model = {}, config = {}, part = {}, tuning = {}}
  index.suspects = {part = {}}
  index.lastBlocked = nil
  index.lastSuspect = nil
end

local function blacklistCounts(index)
  local result = {model = 0, config = 0, part = 0, tuning = 0, total = 0}
  for kind, bucket in pairs(index.blacklists or {}) do
    for _ in pairs(bucket) do
      result[kind] = (result[kind] or 0) + 1
      result.total = result.total + 1
    end
  end
  return result
end

M.create = create
M.build = build
M.eligibleModels = eligibleModels
M.eligibleConfigs = eligibleConfigs
M.recordFailure = recordFailure
M.clearFailures = clearFailures
M.identifier = identifier
M.isBlacklisted = isBlacklisted
M.blacklistCounts = blacklistCounts
M.normalizeModel = normalizeModel
M.normalizeConfig = normalizeConfig
M.sourceKind = sourceKind
M.sourceStrategy = sourceStrategy
M.officialSourceAliases = OFFICIAL_SOURCE_ALIASES
M.recordSuccess = recordSuccess
M.pruneSuspects = pruneSuspects
M.suspectCount = suspectCount
M.isCandidateEligible = isCandidateEligible
M.suspectLimits = {
  records = SUSPECT_LIMIT,
  ttl = SUSPECT_TTL,
  fingerprints = FINGERPRINT_LIMIT,
}

return M
