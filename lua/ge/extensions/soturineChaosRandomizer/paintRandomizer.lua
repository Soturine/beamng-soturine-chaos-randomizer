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

local function randomize(paints, policy, generator, options)
  options = options or {}
  if type(paints) ~= "table" or #paints == 0 then return util.deepCopy(paints or {}), 0, {} end
  local result = util.deepCopy(paints)
  local changed = 0
  local selectedLayers = {}
  local baseHue = generator:float(0, 1)

  for index = 1, #result do
    local layerGenerator = generator
    if options.independentSubstreams and type(generator.fork) == "function" then
      layerGenerator = generator:fork("paint:" .. tostring(index))
    end
    local allLocked = options.isFieldLocked
      and options.isFieldLocked(index, "baseColor") and options.isFieldLocked(index, "metallic")
      and options.isFieldLocked(index, "roughness") and options.isFieldLocked(index, "clearcoat")
      and options.isFieldLocked(index, "clearcoatRoughness")
    if not allLocked and layerGenerator:boolean(policy.paintMutationChance) then
      local paint = type(result[index]) == "table" and result[index] or {}
      local colorGenerator = options.independentSubstreams and layerGenerator:fork("field:baseColor") or layerGenerator
      local offset = (index - 1) * colorGenerator:float(0.04, 0.42) * policy.paintContrast
      local hue = ((options.independentSubstreams and colorGenerator:float(0, 1) or baseHue) + offset) % 1
      local saturation = colorGenerator:float(0.25, 0.70 + 0.30 * policy.chaos)
      local value = colorGenerator:float(0.35, 0.85 + 0.15 * policy.chaos)
      local red, green, blue = hsvToRgb(hue, saturation, value)
      local alpha = paint.baseColor and tonumber(paint.baseColor[4]) or 1
      if not options.isFieldLocked or not options.isFieldLocked(index, "baseColor") then
        paint.baseColor = {red, green, blue, util.clamp(alpha or 1, 0, 2)}
      end
      local fields = {
        {name = "metallic", minimum = 0, maximum = 0.35 + 0.65 * policy.chaos},
        {name = "roughness", minimum = 0.15, maximum = 0.85},
        {name = "clearcoat", minimum = 0.25, maximum = 1},
        {name = "clearcoatRoughness", minimum = 0, maximum = 0.60},
      }
      for _, field in ipairs(fields) do
        if not options.isFieldLocked or not options.isFieldLocked(index, field.name) then
          local fieldGenerator = options.independentSubstreams and layerGenerator:fork("field:" .. field.name) or layerGenerator
          paint[field.name] = fieldGenerator:float(field.minimum, field.maximum)
        end
      end
      result[index] = paint
      changed = changed + 1
      selectedLayers[index] = true
    end
  end
  return result, changed, selectedLayers
end

M.hsvToRgb = hsvToRgb
M.randomize = randomize

return M
