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

local function sourceKind(item)
  item = type(item) == "table" and item or {}
  local label = util.normalizeText(item.Source or item.source or item.sourceLabel)
  if item.userSaved == true or item.player == true or label == "custom" then return "user" end
  if item.modID ~= nil or item.modId ~= nil then return "mod" end
  if OFFICIAL_SOURCE_ALIASES[label] then return "official" end
  if label == "mod" then return "mod" end
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

  local source = raw.Source or raw.source or raw.sourceLabel or "Unknown"
  local kind = sourceKind(raw)
  return {
    modelKey = modelKey,
    key = key,
    name = raw.Name or raw.Configuration or raw.name or key,
    path = raw.pcFilename or raw.path or key,
    sourceKind = kind,
    sourceLabel = source,
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
  index.failures[id] = (index.failures[id] or 0) + 1
  local threshold = tonumber(context.threshold) or index.failureThreshold
  if context.suspectBatch == true and kind == "part" then
    index.suspects.part[id] = (index.suspects.part[id] or 0) + 1
  elseif index.failures[id] >= threshold then
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

local function clearFailures(index)
  index.failures = {}
  index.blacklists = {model = {}, config = {}, part = {}, tuning = {}}
  index.suspects = {part = {}}
  index.lastBlocked = nil
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
M.officialSourceAliases = OFFICIAL_SOURCE_ALIASES

return M
