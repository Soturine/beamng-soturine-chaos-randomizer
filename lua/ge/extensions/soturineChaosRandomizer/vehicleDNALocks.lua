local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

M.PROFILE_VERSION = 1
M.MAX_SLOT_LOCKS = 2048
M.MAX_TUNING_LOCKS = 2048
M.MAX_PAINT_LAYERS = 32

M.CATEGORIES = {
  "body", "engine", "transmission", "drivetrain", "suspension", "brakes", "steering",
  "wheels", "tires", "aero", "interior", "electronics", "accessories", "props", "other",
  "tuning", "paint",
}

local CATEGORY_SET = {}
for _, category in ipairs(M.CATEGORIES) do CATEGORY_SET[category] = true end

-- Classify the most specific evidence first. A tire slot commonly contains
-- "wheel" in its ancestry, for example, so public display order is not a safe
-- classifier priority.
local CLASSIFICATION_ORDER = {
  "tires", "wheels", "transmission", "drivetrain", "suspension", "brakes", "steering",
  "engine", "aero", "interior", "electronics", "accessories", "props", "body",
}

local CATEGORY_TOKENS = {
  body = {"body", "frame", "chassis", "cab", "bed", "bumper", "hood", "door", "fender", "glass"},
  engine = {"engine", "motor", "intake", "exhaust", "turbo", "supercharger", "radiator", "fuel"},
  transmission = {"transmission", "gearbox", "clutch", "torque converter"},
  drivetrain = {"drivetrain", "differential", "transfercase", "transfer case", "driveshaft", "axle", "final drive"},
  suspension = {"suspension", "spring", "shock", "coilover", "sway bar", "control arm"},
  brakes = {"brake", "rotor", "caliper"},
  steering = {"steering", "steer", "rack"},
  wheels = {"wheel", "rim"},
  tires = {"tire", "tyre"},
  aero = {"aero", "wing", "spoiler", "splitter", "diffuser"},
  interior = {"interior", "seat", "dashboard", "dash", "steering wheel", "cage"},
  electronics = {"electronic", "ecu", "controller", "abs", "esc", "traction control"},
  accessories = {"accessory", "accessories", "roof rack", "lightbar", "light bar", "cargo"},
  props = {"prop", "coupler", "hitch", "trailer"},
}

local function emptyProfile()
  return {
    kind = "soturineVehicleDNALockProfile",
    profileVersion = M.PROFILE_VERSION,
    vehicle = false,
    configuration = false,
    categories = {},
    slots = {},
    parts = {},
    tuning = {all = false, variables = {}, normalized = {}},
    paints = {all = false, layers = {}, fields = {}},
    updatedAt = 0,
  }
end

local function safeText(value, maximum)
  if type(value) ~= "string" or value == "" or #value > (maximum or 512) then return nil end
  if value:find("[%z\1-\31]") then return nil end
  return value
end

local function normalizeBooleanMap(source, allowed, maximum)
  local result, count = {}, 0
  if type(source) ~= "table" then return result end
  for _, key in ipairs(util.sortedKeys(source)) do
    if source[key] == true and (not allowed or allowed[key]) then
      count = count + 1
      if count > maximum then break end
      result[key] = true
    end
  end
  return result
end

local function normalizeSlotLocks(source)
  local result, count = {}, 0
  if type(source) ~= "table" then return result end
  for _, path in ipairs(util.sortedKeys(source)) do
    local value = source[path]
    if safeText(path, 512) and not path:find("..", 1, true) and (value == true or type(value) == "table") then
      count = count + 1
      if count > M.MAX_SLOT_LOCKS then break end
      local record = type(value) == "table" and value or {}
      result[path] = {
        path = path,
        slotId = safeText(record.slotId, 256),
        parentPath = safeText(record.parentPath, 512),
        parentPart = safeText(record.parentPart, 256),
        partName = safeText(record.partName, 256),
      }
    end
  end
  return result
end

local function normalizePartLocks(source)
  local result, count = {}, 0
  if type(source) ~= "table" then return result end
  for _, path in ipairs(util.sortedKeys(source)) do
    local record = source[path]
    if safeText(path, 512) and not path:find("..", 1, true) and type(record) == "table"
      and safeText(record.partName, 256)
    then
      count = count + 1
      if count > M.MAX_SLOT_LOCKS then break end
      result[path] = {
        path = path,
        slotId = safeText(record.slotId, 256),
        parentPath = safeText(record.parentPath, 512),
        parentPart = safeText(record.parentPart, 256),
        partName = record.partName,
      }
    end
  end
  return result
end

local function normalize(profile)
  profile = type(profile) == "table" and profile or {}
  local result = emptyProfile()
  result.vehicle = profile.vehicle == true
  result.configuration = profile.configuration == true
  result.categories = normalizeBooleanMap(profile.categories, CATEGORY_SET, #M.CATEGORIES)
  result.slots = normalizeSlotLocks(profile.slots)
  result.parts = normalizePartLocks(profile.parts)
  local tuning = type(profile.tuning) == "table" and profile.tuning or {}
  result.tuning.all = tuning.all == true
  result.tuning.variables = normalizeBooleanMap(tuning.variables, nil, M.MAX_TUNING_LOCKS)
  result.tuning.normalized = {}
  for _, name in ipairs(util.sortedKeys(type(tuning.normalized) == "table" and tuning.normalized or {})) do
    local value = tonumber(tuning.normalized[name])
    if safeText(name, 256) and util.isFinite(value) then
      result.tuning.normalized[name] = util.clamp(value, 0, 1)
    end
  end
  local paints = type(profile.paints) == "table" and profile.paints or {}
  result.paints.all = paints.all == true
  for key, value in pairs(type(paints.layers) == "table" and paints.layers or {}) do
    local layer = math.floor(tonumber(key) or -1)
    if value == true and layer >= 1 and layer <= M.MAX_PAINT_LAYERS then result.paints.layers[layer] = true end
  end
  for key, values in pairs(type(paints.fields) == "table" and paints.fields or {}) do
    local layer = math.floor(tonumber(key) or -1)
    if layer >= 1 and layer <= M.MAX_PAINT_LAYERS then
      result.paints.fields[layer] = normalizeBooleanMap(values, {
        baseColor = true, metallic = true, roughness = true, clearcoat = true, clearcoatRoughness = true,
      }, 5)
    end
  end
  result.updatedAt = math.max(0, math.floor(tonumber(profile.updatedAt) or 0))
  return result
end

local function classifySlot(slot)
  if type(slot) ~= "table" then return "other", "no_slot_evidence" end
  local evidence = table.concat({
    tostring(slot.id or ""), tostring(slot.description or ""), tostring(slot.path or ""),
    table.concat(slot.allowTypes or {}, " "), table.concat(slot.denyTypes or {}, " "),
  }, " "):lower():gsub("[_%-%./]+", " ")
  for _, category in ipairs(CLASSIFICATION_ORDER) do
    for _, token in ipairs(CATEGORY_TOKENS[category] or {}) do
      if evidence:find(token, 1, true) then return category, "slot_metadata_token:" .. token end
    end
  end
  return "other", "unclassified_slot_metadata"
end

local function slotLock(profile, slot)
  profile = normalize(profile)
  if type(slot) ~= "table" then return false end
  local category = classifySlot(slot)
  if profile.categories[category] then return true, "category:" .. category end
  if profile.slots[slot.path] then return true, "slot:" .. tostring(slot.path) end
  local part = profile.parts[slot.path]
  if part then
    if part.slotId and part.slotId ~= slot.id then return true, "unresolved_part_lock" end
    if part.parentPart and slot.parentPart and part.parentPart ~= slot.parentPart then return true, "unresolved_part_lock" end
    return true, "part:" .. tostring(part.partName)
  end
  return false
end

local function tuningLock(profile, name)
  profile = normalize(profile)
  return profile.categories.tuning == true or profile.tuning.all == true or profile.tuning.variables[name] == true
end

local function paintLock(profile, layer, field)
  profile = normalize(profile)
  if profile.categories.paint or profile.paints.all or profile.paints.layers[layer] then return true end
  return type(profile.paints.fields[layer]) == "table" and profile.paints.fields[layer][field] == true
end

local function resolve(profile, scan)
  profile = normalize(profile)
  local byPath = type(scan) == "table" and scan.byPath or {}
  local unresolved = {}
  for path, record in pairs(profile.slots) do
    local slot = byPath[path]
    if not slot or (record.slotId and record.slotId ~= slot.id)
      or (record.parentPart and slot.parentPart and record.parentPart ~= slot.parentPart)
    then unresolved[#unresolved + 1] = {kind = "slot", path = path, slotId = record.slotId} end
  end
  for path, record in pairs(profile.parts) do
    local slot = byPath[path]
    local available = false
    if slot then
      if slot.currentPart == record.partName then available = true end
      for _, candidate in ipairs(slot.candidates or {}) do if candidate == record.partName then available = true; break end end
    end
    if not available then unresolved[#unresolved + 1] = {kind = "part", path = path, partName = record.partName} end
  end
  table.sort(unresolved, function(a, b) return tostring(a.path) < tostring(b.path) end)
  return {unresolved = unresolved, unresolvedCount = #unresolved}
end

local function summary(profile)
  profile = normalize(profile)
  local count = (profile.vehicle and 1 or 0) + (profile.configuration and 1 or 0)
  for _ in pairs(profile.categories) do count = count + 1 end
  for _ in pairs(profile.slots) do count = count + 1 end
  for _ in pairs(profile.parts) do count = count + 1 end
  for _ in pairs(profile.tuning.variables) do count = count + 1 end
  if profile.tuning.all then count = count + 1 end
  if profile.paints.all then count = count + 1 end
  for _ in pairs(profile.paints.layers) do count = count + 1 end
  for _, fields in pairs(profile.paints.fields) do for _ in pairs(fields) do count = count + 1 end end
  return {locked = count, vehicle = profile.vehicle, configuration = profile.configuration}
end

local function preset(profile, name)
  local result = normalize(profile)
  result.categories = {}
  local unlocked = {}
  if name == "visual" then
    unlocked = {body = true, wheels = true, tires = true, aero = true, interior = true, accessories = true, paint = true}
  elseif name == "mechanical" then
    unlocked = {engine = true, transmission = true, drivetrain = true, suspension = true, brakes = true, steering = true, tuning = true}
  elseif name == "accessories" then
    unlocked = {accessories = true, aero = true, interior = true, props = true}
  elseif name ~= "everything" then return nil, "lock_preset_invalid" end
  if name ~= "everything" then
    for _, category in ipairs(M.CATEGORIES) do if not unlocked[category] then result.categories[category] = true end end
  end
  result.updatedAt = os.time()
  return result
end

local function applyPatch(profile, patch)
  local result = normalize(profile)
  if type(patch) ~= "table" then return result end
  if patch.vehicle ~= nil then result.vehicle = patch.vehicle == true end
  if patch.configuration ~= nil then result.configuration = patch.configuration == true end
  if patch.categories ~= nil then result.categories = normalizeBooleanMap(patch.categories, CATEGORY_SET, #M.CATEGORIES) end
  if patch.slots ~= nil then result.slots = normalizeSlotLocks(patch.slots) end
  if patch.parts ~= nil then result.parts = normalizePartLocks(patch.parts) end
  if patch.tuning ~= nil then result.tuning = normalize({tuning = patch.tuning}).tuning end
  if patch.paints ~= nil then result.paints = normalize({paints = patch.paints}).paints end
  result.updatedAt = os.time()
  return normalize(result)
end

M.empty = emptyProfile
M.normalize = normalize
M.classifySlot = classifySlot
M.isSlotLocked = slotLock
M.isTuningLocked = tuningLock
M.isPaintLocked = paintLock
M.resolve = resolve
M.summary = summary
M.applyPreset = preset
M.applyPatch = applyPatch

return M
