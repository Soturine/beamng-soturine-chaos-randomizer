local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local SUPPORTED_FIELDS = {
  "baseColor",
  "metallic",
  "roughness",
  "clearcoat",
  "clearcoatRoughness",
}

local FIELD_TOLERANCE = {
  baseColor = 1e-5,
  metallic = 1e-5,
  roughness = 1e-5,
  clearcoat = 1e-5,
  clearcoatRoughness = 1e-5,
}

local function component(value, index, named)
  if type(value) ~= "table" then return nil end
  return tonumber(value[index]) or tonumber(value[named])
end

local function normalizeColor(value)
  local red = component(value, 1, "x") or component(value, 1, "r")
  local green = component(value, 2, "y") or component(value, 2, "g")
  local blue = component(value, 3, "z") or component(value, 3, "b")
  local alpha = component(value, 4, "w") or component(value, 4, "a")
  if not util.isFinite(red) or not util.isFinite(green) or not util.isFinite(blue) then return nil end
  if not util.isFinite(alpha) then alpha = 1 end
  return {red, green, blue, alpha}
end

local function normalizeRecord(record)
  if type(record) ~= "table" then return nil, "paint_record_invalid" end
  local normalized = {}
  if record.baseColor ~= nil then
    normalized.baseColor = normalizeColor(record.baseColor)
    if not normalized.baseColor then return nil, "paint_base_color_invalid" end
  end
  for _, field in ipairs(SUPPORTED_FIELDS) do
    if field ~= "baseColor" and record[field] ~= nil then
      local value = tonumber(record[field])
      if not util.isFinite(value) then return nil, "paint_field_invalid:" .. field end
      normalized[field] = value
    end
  end
  return normalized
end

local function normalizePaints(paints)
  if type(paints) ~= "table" then return nil, "paint_layers_invalid" end
  local result = {}
  for index = 1, #paints do
    local normalized, reason = normalizeRecord(paints[index])
    if not normalized then return nil, reason .. ":" .. tostring(index) end
    result[index] = normalized
  end
  return result
end

local function compareNumber(expected, actual, tolerance)
  expected = tonumber(expected)
  actual = tonumber(actual)
  return util.isFinite(expected) and util.isFinite(actual)
    and math.abs(expected - actual) <= tolerance
end

local function compare(requested, actual)
  local expected, expectedError = normalizePaints(requested)
  if not expected then return false, expectedError end
  local observed, observedError = normalizePaints(actual)
  if not observed then return false, observedError end
  if #observed < #expected then return false, "paint_layer_count_mismatch" end

  for index = 1, #expected do
    local expectedLayer = expected[index]
    local actualLayer = observed[index] or {}
    for _, field in ipairs(SUPPORTED_FIELDS) do
      local expectedValue = expectedLayer[field]
      if expectedValue ~= nil then
        if field == "baseColor" then
          local actualColor = actualLayer.baseColor
          if type(actualColor) ~= "table" then return false, "paint_field_missing:" .. index .. ":baseColor" end
          for componentIndex = 1, 4 do
            if not compareNumber(expectedValue[componentIndex], actualColor[componentIndex], FIELD_TOLERANCE.baseColor) then
              return false, "paint_field_mismatch:" .. index .. ":baseColor:" .. componentIndex
            end
          end
        elseif actualLayer[field] == nil then
          return false, "paint_field_missing:" .. index .. ":" .. field
        elseif not compareNumber(expectedValue, actualLayer[field], FIELD_TOLERANCE[field]) then
          return false, "paint_field_mismatch:" .. index .. ":" .. field
        end
      end
    end
  end
  return true, "requested_fields_match"
end

local function createDeferred(expected, now, timeout, interval, maxAttempts)
  return {
    expected = util.deepCopy(expected or {}),
    startedAt = tonumber(now) or 0,
    deadline = (tonumber(now) or 0) + (tonumber(timeout) or 2),
    interval = tonumber(interval) or 0.1,
    nextCheckAt = tonumber(now) or 0,
    attempts = 0,
    maxAttempts = math.floor(tonumber(maxAttempts) or 12),
    strategy = "bounded_readback",
  }
end

local function shouldCheck(state, now)
  if type(state) ~= "table" then return false end
  now = tonumber(now) or 0
  return state.attempts < state.maxAttempts and now >= state.nextCheckAt and now < state.deadline
end

local function recordAttempt(state, now)
  state.attempts = state.attempts + 1
  state.nextCheckAt = (tonumber(now) or 0) + state.interval
end

local function expired(state, now)
  if type(state) ~= "table" then return true end
  now = tonumber(now) or 0
  return now >= state.deadline or state.attempts >= state.maxAttempts
end

M.supportedFields = SUPPORTED_FIELDS
M.normalizeColor = normalizeColor
M.normalizeRecord = normalizeRecord
M.normalizePaints = normalizePaints
M.compare = compare
M.createDeferred = createDeferred
M.shouldCheck = shouldCheck
M.recordAttempt = recordAttempt
M.expired = expired

return M
