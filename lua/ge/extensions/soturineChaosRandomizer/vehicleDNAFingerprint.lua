local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local DEFAULT_LIMITS = {
  maxDepth = 32,
  maxElements = 10000,
  maxStringLength = 4096,
  maxPathLength = 512,
}

local function escapeString(value)
  return '"' .. value:gsub('[%z\1-\31\\"]', function(character)
    local replacements = {['"'] = '\\"', ['\\'] = '\\\\', ['\b'] = '\\b', ['\f'] = '\\f', ['\n'] = '\\n', ['\r'] = '\\r', ['\t'] = '\\t'}
    return replacements[character] or string.format("\\u%04x", string.byte(character))
  end) .. '"'
end

local function arrayLength(value)
  local maximum = 0
  local count = 0
  for key in pairs(value) do
    if type(key) ~= "number" or key < 1 or key ~= math.floor(key) then return nil end
    maximum = math.max(maximum, key)
    count = count + 1
  end
  if maximum ~= count then return nil end
  return maximum
end

local function canonicalize(value, options)
  options = util.shallowMerge(DEFAULT_LIMITS, options or {})
  local seen = {}
  local elements = 0

  local function encode(current, depth, path)
    if depth > options.maxDepth then return nil, "canonical_depth_limit:" .. path end
    local kind = type(current)
    if kind == "nil" then return "null" end
    if kind == "boolean" then return current and "true" or "false" end
    if kind == "number" then
      if not util.isFinite(current) then return nil, "canonical_non_finite_number:" .. path end
      if current == 0 then return "0" end
      if current == math.floor(current) then return string.format("%.0f", current) end
      return string.format("%.12g", current)
    end
    if kind == "string" then
      if #current > options.maxStringLength then return nil, "canonical_string_limit:" .. path end
      return escapeString(current)
    end
    if kind ~= "table" then return nil, "canonical_unsupported_type:" .. kind .. ":" .. path end
    if seen[current] then return nil, "canonical_cycle:" .. path end
    seen[current] = true
    elements = elements + 1
    if elements > options.maxElements then seen[current] = nil; return nil, "canonical_element_limit" end

    local length = arrayLength(current)
    local output = {}
    if length ~= nil then
      for index = 1, length do
        local encoded, err = encode(current[index], depth + 1, path .. "[" .. index .. "]")
        if not encoded then seen[current] = nil; return nil, err end
        output[#output + 1] = encoded
      end
      seen[current] = nil
      return "[" .. table.concat(output, ",") .. "]"
    end

    for _, key in ipairs(util.sortedKeys(current)) do
      if type(key) ~= "string" then seen[current] = nil; return nil, "canonical_object_key_type:" .. path end
      local childPath = path .. "." .. key
      if #childPath > options.maxPathLength then seen[current] = nil; return nil, "canonical_path_limit" end
      local encoded, err = encode(current[key], depth + 1, childPath)
      if not encoded then seen[current] = nil; return nil, err end
      output[#output + 1] = escapeString(key) .. ":" .. encoded
    end
    seen[current] = nil
    return "{" .. table.concat(output, ",") .. "}"
  end

  local canonical, err = encode(value, 0, "$")
  return canonical, err, {elements = elements}
end

local function digest(text)
  local first = 5381
  local second = 52711
  local modulus = 2147483647
  for index = 1, #text do
    local byte = string.byte(text, index)
    first = (first * 33 + byte) % modulus
    second = (second * 131 + byte + index) % modulus
  end
  return string.format("scrfp1-%08X%08X", first, second)
end

local function fingerprint(value, options)
  local canonical, err, metrics = canonicalize(value, options)
  if not canonical then return nil, err end
  return digest(canonical), canonical, metrics
end

M.defaults = DEFAULT_LIMITS
M.canonicalize = canonicalize
M.fingerprint = fingerprint
M.digest = digest

return M
