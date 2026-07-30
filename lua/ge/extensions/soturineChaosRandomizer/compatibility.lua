local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local function tuple(value)
  if type(value) ~= "string" then return nil end
  local numbers = {}
  for number in value:gmatch("%d+") do
    numbers[#numbers + 1] = tonumber(number)
    if #numbers == 4 then break end
  end
  if #numbers < 2 then return nil end
  while #numbers < 4 do numbers[#numbers + 1] = 0 end
  return numbers
end

local function compare(left, right)
  local a, b = tuple(left), tuple(right)
  if not a or not b then return nil end
  for index = 1, 4 do
    if a[index] < b[index] then return -1 end
    if a[index] > b[index] then return 1 end
  end
  return 0
end

local function evaluate(metadata, detected)
  metadata = type(metadata) == "table" and metadata or {}
  local primary = metadata.primaryBeamNGTarget
  local minimum = metadata.minimumBeamNGVersion
  local warnings = {}
  local state = "unknown"
  if type(primary) ~= "string" or type(minimum) ~= "string" then
    warnings[#warnings + 1] = "Compatibility metadata is missing or malformed."
  elseif not tuple(detected) then
    warnings[#warnings + 1] = "The running BeamNG.drive version could not be detected."
  else
    local targetOrder, minimumOrder = compare(detected, primary), compare(detected, minimum)
    if targetOrder == 0 then
      state = "primary_target"
    elseif minimumOrder and minimumOrder < 0 then
      state = "older_unsupported"
      warnings[#warnings + 1] = "This BeamNG.drive build is older than the declared minimum."
    elseif targetOrder and targetOrder < 0 then
      state = "supported_legacy"
      warnings[#warnings + 1] = "This older build is supported best-effort; the primary target is newer."
    elseif targetOrder and targetOrder > 0 then
      state = "newer_unverified"
      warnings[#warnings + 1] = "This BeamNG.drive build is newer than the validated primary target."
    end
  end
  return {
    detectedGameVersion = tostring(detected or "unknown"),
    primaryTarget = primary,
    minimumSupported = minimum,
    compatibilityState = state,
    compatibilityWarnings = warnings,
    metadata = util.deepCopy(metadata),
  }
end

M.tuple = tuple
M.compare = compare
M.evaluate = evaluate

return M
