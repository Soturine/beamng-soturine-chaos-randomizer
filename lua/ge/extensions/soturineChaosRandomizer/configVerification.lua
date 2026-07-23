local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local function normalizePath(value)
  if type(value) ~= "string" then return nil end
  local normalized = value:gsub("\\", "/"):gsub("/+", "/"):gsub("^%s+", ""):gsub("%s+$", "")
  if normalized == "" then return nil end
  if not normalized:lower():match("%.pc$") then normalized = normalized .. ".pc" end
  if normalized:sub(1, 1) ~= "/" and normalized:find("/", 1, true) then normalized = "/" .. normalized end
  return normalized:lower()
end

local function stableKey(value)
  local normalized = normalizePath(value)
  if not normalized then return nil end
  return normalized:match("([^/]+)%.pc$")
end

local function scopedKey(modelKey, value)
  local key = stableKey(value) or (type(value) == "string" and value:lower():gsub("%.pc$", "") or nil)
  if type(modelKey) ~= "string" or modelKey == "" or type(key) ~= "string" or key == "" then return nil end
  return modelKey:lower() .. "::" .. key
end

local function collectPartNames(config)
  local result = {}
  local seen = {}
  local function add(value)
    if type(value) == "string" and value ~= "" and not seen[value] then
      seen[value] = true
      result[#result + 1] = value
    end
  end
  local function visitTree(node)
    if type(node) ~= "table" then return end
    add(node.chosenPartName)
    for _, key in ipairs(util.sortedKeys(node.children or {})) do visitTree(node.children[key]) end
  end
  visitTree(type(config) == "table" and config.partsTree or nil)
  for _, key in ipairs(util.sortedKeys(type(config) == "table" and config.parts or {})) do
    add(config.parts[key])
  end
  table.sort(result)
  return result
end

local function signature(config)
  if type(config) ~= "table" then return nil end
  local parts = collectPartNames(config)
  local vars = {}
  for _, name in ipairs(util.sortedKeys(config.vars or {})) do
    local value = tonumber(config.vars[name])
    if util.isFinite(value) then vars[name] = value end
  end
  if #parts == 0 and next(vars) == nil then return nil end
  return {parts = parts, vars = vars}
end

local function arraySet(values)
  local result = {}
  for _, value in ipairs(values or {}) do result[value] = true end
  return result
end

local function signatureMatches(expected, actual)
  if type(expected) ~= "table" or type(actual) ~= "table" then return false end
  local actualParts = arraySet(actual.parts)
  for _, partName in ipairs(expected.parts or {}) do
    if not actualParts[partName] then return false end
  end
  for name, value in pairs(expected.vars or {}) do
    local observed = tonumber(actual.vars and actual.vars[name])
    if not util.isFinite(observed) or math.abs(observed - value) > 1e-8 then return false end
  end
  return (#(expected.parts or {}) > 0) or next(expected.vars or {}) ~= nil
end

local function expectation(record, loadedConfig)
  record = type(record) == "table" and record or {}
  local raw = type(record.raw) == "table" and record.raw or record
  local pathValue = record.path or raw.pcFilename or raw.path
  local key = record.key or raw.key or stableKey(pathValue)
  if key ~= nil then key = tostring(key):lower():gsub("%.pc$", "") end
  return {
    modelKey = record.modelKey or raw.model_key or raw.modelKey or raw.model,
    key = key,
    path = normalizePath(pathValue),
    sourceKind = record.sourceKind,
    sourceLabel = record.sourceLabel,
    signature = signature(loadedConfig or raw.config or raw.loadedConfig),
    registryIdentity = key ~= nil,
  }
end

local function verify(expected, state)
  expected = type(expected) == "table" and expected or {}
  state = type(state) == "table" and state or {}
  if expected.modelKey and state.modelKey ~= expected.modelKey then
    return false, "model_mismatch", {strategy = "model_identity", identityConfirmed = false}
  end

  local actualIdentity = type(state.configIdentity) == "table" and state.configIdentity or {}
  local actualPath = normalizePath(actualIdentity.path or state.configKey)
  if expected.path and actualPath and expected.path == actualPath then
    return true, nil, {strategy = "filename", identityConfirmed = true}
  end

  local actualKey = actualIdentity.key or stableKey(actualPath or state.configKey)
  local expectedScoped = scopedKey(expected.modelKey, expected.key)
  local actualScoped = scopedKey(state.modelKey, actualKey)
  if expected.registryIdentity and expectedScoped and actualScoped == expectedScoped then
    return true, nil, {strategy = "registry_identity", identityConfirmed = true}
  end

  local actualSignature = actualIdentity.signature or state.configSignature
  if expected.signature and signatureMatches(expected.signature, actualSignature) then
    return true, nil, {strategy = "state_signature", identityConfirmed = true}
  end

  return false, "config_identity_unverified", {
    strategy = "unverified",
    identityConfirmed = false,
    expectedPath = expected.path,
    actualPath = actualPath,
    expectedKey = expected.key,
    actualKey = actualKey,
  }
end

local function resolveRegistryConfig(modelKey, pathValue, keyValue, signatureValue, configs)
  if type(modelKey) ~= "string" or modelKey == "" then return nil, "model_missing" end
  local expectedPath = normalizePath(pathValue)
  local expectedScoped = scopedKey(modelKey, keyValue or pathValue)
  for _, config in ipairs(configs or {}) do
    if config.modelKey == modelKey and expectedPath and normalizePath(config.path or (config.raw and config.raw.pcFilename)) == expectedPath then
      return config, "normalized_path"
    end
  end
  for _, config in ipairs(configs or {}) do
    if config.modelKey == modelKey and expectedScoped and scopedKey(modelKey, config.key or config.path) == expectedScoped then
      return config, "model_scoped_key"
    end
  end
  if type(signatureValue) == "table" then
    local match
    for _, config in ipairs(configs or {}) do
      local candidateSignature = config.stateSignature or config.signature
      if config.modelKey == modelKey and candidateSignature and signatureMatches(signatureValue, candidateSignature) then
        if match then return nil, "signature_ambiguous" end
        match = config
      end
    end
    if match then return match, "state_signature" end
  end
  return nil, "config_identity_unverified"
end

M.normalizePath = normalizePath
M.stableKey = stableKey
M.scopedKey = scopedKey
M.signature = signature
M.signatureMatches = signatureMatches
M.expectation = expectation
M.verify = verify
M.resolveRegistryConfig = resolveRegistryConfig

return M
