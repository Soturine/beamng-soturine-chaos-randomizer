local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local function hsvToRgb(hue, saturation, value)
  hue = hue % 1
  saturation = util.clamp(saturation, 0, 1)
  value = util.clamp(value, 0, 1)
  local sector = math.floor(hue * 6)
  local fraction = hue * 6 - sector
  local p = value * (1 - saturation)
  local q = value * (1 - fraction * saturation)
  local t = value * (1 - (1 - fraction) * saturation)
  sector = sector % 6
  if sector == 0 then return value, t, p end
  if sector == 1 then return q, value, p end
  if sector == 2 then return p, value, t end
  if sector == 3 then return p, q, value end
  if sector == 4 then return t, p, value end
  return value, p, q
end

local function randomize(paints, policy, generator)
  if type(paints) ~= "table" or #paints == 0 then return util.deepCopy(paints or {}), 0 end
  local result = util.deepCopy(paints)
  local changed = 0
  local baseHue = generator:float(0, 1)

  for index = 1, #result do
    if generator:boolean(policy.paintMutationChance) then
      local paint = type(result[index]) == "table" and result[index] or {}
      local offset = (index - 1) * generator:float(0.04, 0.42) * policy.paintContrast
      local hue = (baseHue + offset) % 1
      local saturation = generator:float(0.25, 0.70 + 0.30 * policy.chaos)
      local value = generator:float(0.35, 0.85 + 0.15 * policy.chaos)
      local red, green, blue = hsvToRgb(hue, saturation, value)
      local alpha = paint.baseColor and tonumber(paint.baseColor[4]) or 1
      paint.baseColor = {red, green, blue, util.clamp(alpha or 1, 0, 2)}
      paint.metallic = generator:float(0, 0.35 + 0.65 * policy.chaos)
      paint.roughness = generator:float(0.15, 0.85)
      paint.clearcoat = generator:float(0.25, 1)
      paint.clearcoatRoughness = generator:float(0, 0.60)
      result[index] = paint
      changed = changed + 1
    end
  end
  return result, changed
end

M.hsvToRgb = hsvToRgb
M.randomize = randomize

return M
