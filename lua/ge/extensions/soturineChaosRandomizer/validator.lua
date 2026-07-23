local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local CRITICAL_TERMS = {
  "energy", "powertrain", "propulsion", "engine", "motor", "battery", "fuel", "tank", "transmission", "gearbox",
  "clutch", "converter", "driveshaft", "halfshaft", "transfer", "differential",
  "finaldrive", "axle", "brake", "suspension", "spring", "shock", "steer", "hub", "wheel", "tire",
}

local function combinedMetadata(slot)
  local values = {tostring(slot.description or ""), tostring(slot.id or "")}
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

local function canEmpty(slot, protectCriticalParts)
  if slot.coreSlot or slot.required or slot.depth == 0 then return false, "required_or_core" end
  if protectCriticalParts then
    local critical, term = isCritical(slot)
    if critical then return false, "drivability:" .. term end
  end
  return true
end

local function validateSelection(slot, candidate, protectCriticalParts)
  if candidate == "" then return canEmpty(slot, protectCriticalParts) end
  if type(candidate) ~= "string" then return false, "invalid_candidate" end
  if not util.arrayContains(slot.candidates, candidate) then return false, "incompatible_candidate" end
  if protectCriticalParts then
    local critical, term = isCritical(slot)
    if critical and candidate ~= slot.currentPart and candidate ~= slot.defaultPart then
      return false, "critical_candidate_unproven:" .. tostring(term)
    end
  end
  return true
end

local function protectedSelection(slot, protectCriticalParts)
  if not protectCriticalParts then return nil end
  local critical, term = isCritical(slot)
  if not critical then return nil end
  if type(slot.currentPart) == "string" and slot.currentPart ~= "" then
    return slot.currentPart, "critical_current_preserved:" .. tostring(term)
  end
  if type(slot.defaultPart) == "string" and slot.defaultPart ~= ""
    and util.arrayContains(slot.candidates, slot.defaultPart)
  then
    return slot.defaultPart, "critical_default_restored:" .. tostring(term)
  end
  return slot.currentPart or "", "critical_safe_replacement_unproven:" .. tostring(term)
end

local function validateProtectedScan(scan, protectCriticalParts)
  local failures = {}
  for _, slot in ipairs(type(scan) == "table" and scan.slots or {}) do
    if (slot.required or slot.coreSlot) and (slot.currentPart == nil or slot.currentPart == "") then
      failures[#failures + 1] = {slotPath = slot.path, reason = "required_or_core_missing"}
    elseif protectCriticalParts then
      local critical, term = isCritical(slot)
      if critical and (slot.currentPart == nil or slot.currentPart == "") then
        failures[#failures + 1] = {slotPath = slot.path, reason = "critical_missing:" .. tostring(term)}
      end
    end
  end
  return #failures == 0, failures
end

M.isCritical = isCritical
M.canEmpty = canEmpty
M.validateSelection = validateSelection
M.protectedSelection = protectedSelection
M.validateProtectedScan = validateProtectedScan

return M
