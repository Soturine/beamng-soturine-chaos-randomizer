local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local CRITICAL_TERMS = {
  "engine", "motor", "battery", "fuel", "tank", "transmission", "gearbox",
  "clutch", "converter", "driveshaft", "halfshaft", "transfer", "differential",
  "finaldrive", "suspension", "spring", "shock", "steer", "hub", "wheel", "tire",
}

local function combinedMetadata(slot)
  local values = {slot.description, slot.id}
  for _, value in ipairs(slot.allowTypes or {}) do values[#values + 1] = value end
  return util.normalizeText(table.concat(values, " "))
end

local function isCritical(slot)
  local text = combinedMetadata(slot)
  for _, term in ipairs(CRITICAL_TERMS) do
    if text:find(term, 1, true) then return true, term end
  end
  return false
end

local function canEmpty(slot, keepVehicleDrivable)
  if slot.coreSlot or slot.required or slot.depth == 0 then return false, "required_or_core" end
  if keepVehicleDrivable then
    local critical, term = isCritical(slot)
    if critical then return false, "drivability:" .. term end
  end
  return true
end

local function validateSelection(slot, candidate, keepVehicleDrivable)
  if candidate == "" then return canEmpty(slot, keepVehicleDrivable) end
  if type(candidate) ~= "string" then return false, "invalid_candidate" end
  if not util.arrayContains(slot.candidates, candidate) then return false, "incompatible_candidate" end
  return true
end

M.isCritical = isCritical
M.canEmpty = canEmpty
M.validateSelection = validateSelection

return M
