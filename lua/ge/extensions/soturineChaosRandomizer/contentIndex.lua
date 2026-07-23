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

local function sourceKind(item)
  local label = util.normalizeText(item.Source or item.source or item.sourceLabel)
  if label == "beamng - official" or label == "official" then return "official" end
  if label == "custom" or item.userSaved == true or item.player == true then return "user" end
  if item.modID or item.modId or label == "mod" then return "mod" end
  if label ~= "" and label ~= "unknown" then return "mod" end
  return "unknown"
end

local function truthyText(value, term)
  return util.normalizeText(value):find(term, 1, true) ~= nil
end

local function normalizeModel(raw)
  local key = raw.key or raw.model_key or raw.modelKey
  if type(key) ~= "string" or key == "" then return nil end
  local itemType = raw.Type or raw.type or raw.Category or raw.category or "Unknown"
  local source = raw.Source or raw.source or "Unknown"
  local normalizedType = util.normalizeText(itemType)
  local normalizedKey = util.normalizeText(key)

  return {
    key = key,
    name = raw.Name or raw.name or key,
    brand = raw.Brand or raw.brand or "",
    type = itemType,
    sourceKind = sourceKind(raw),
    sourceLabel = source,
    isAutomation = raw.isAutomation == true or truthyText(itemType, "automation") or normalizedKey:find("automation", 1, true) == 1,
    isTrailer = raw.isTrailer == true or normalizedType:find("trailer", 1, true) ~= nil,
    isProp = raw.isProp == true or normalizedType == "prop" or normalizedType == "props" or normalizedType:find("prop", 1, true) ~= nil,
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

  local source = raw.Source or raw.source or model.sourceLabel or "Unknown"
  local kind = sourceKind(raw)
  if kind == "unknown" then kind = model.sourceKind end
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
    blacklist = {},
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

local function eligibleModels(index, settings)
  settings = settings or {}
  local result = {}
  for _, model in ipairs(index.models) do
    if #model.configs > 0
      and (settings.includeAutomation or not model.isAutomation)
      and (settings.includeTrailers or not model.isTrailer)
      and (settings.includeProps or not model.isProp)
      and not index.blacklist["model:" .. model.key]
    then
      local copy = util.deepCopy(model)
      copy.configs = {}
      for _, config in ipairs(model.configs) do
        local id = "config:" .. config.modelKey .. "/" .. config.key
        if config.valid and contentAllowed(config.sourceKind, settings.contentFilter) and not index.blacklist[id] then
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

local function recordFailure(index, kind, key)
  local id = tostring(kind) .. ":" .. tostring(key)
  index.failures[id] = (index.failures[id] or 0) + 1
  if index.failures[id] >= index.failureThreshold then index.blacklist[id] = true end
  return index.failures[id], index.blacklist[id] == true
end

local function clearFailures(index)
  index.failures = {}
  index.blacklist = {}
end

M.create = create
M.build = build
M.eligibleModels = eligibleModels
M.eligibleConfigs = eligibleConfigs
M.recordFailure = recordFailure
M.clearFailures = clearFailures
M.normalizeModel = normalizeModel
M.normalizeConfig = normalizeConfig
M.sourceKind = sourceKind

return M
