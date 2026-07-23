local util = require("ge/extensions/soturineChaosRandomizer/util")
local compatibility = require("ge/extensions/soturineChaosRandomizer/vehicleDNACompatibility")
local mutationEngine = require("ge/extensions/soturineChaosRandomizer/mutationEngine")

local M = {}

local function desiredByResolvedPath(entry, scan, mode)
  local result = {}
  local issues = {}
  for _, saved in ipairs(entry.final and entry.final.slots or {}) do
    local current, strategy = compatibility.resolveSlot(saved, scan, entry.final.modelKey)
    if not current then
      issues[#issues + 1] = {
        path = saved.path, reason = strategy,
        blocking = saved.required == true or saved.coreSlot == true,
      }
    else
      local candidateAvailable = saved.partName == "" or current.currentPart == saved.partName
      for _, candidate in ipairs(current.candidates or {}) do if candidate == saved.partName then candidateAvailable = true end end
      if candidateAvailable then
        result[current.path] = {saved = saved, current = current, strategy = strategy}
      elseif mode == "exact" or saved.required or saved.coreSlot then
        issues[#issues + 1] = {
          path = saved.path, partName = saved.partName, reason = "part_missing",
          blocking = saved.required == true or saved.coreSlot == true,
        }
      end
    end
  end
  return result, issues
end

local function planPartsPass(entry, scan, mode)
  local desired, issues = desiredByResolvedPath(entry, scan, mode)
  local blocking = mode == "exact" and #issues > 0
  for _, issue in ipairs(issues) do if issue.blocking then blocking = true end end
  if blocking then return nil, nil, issues end
  local changed = {}
  local minimumDepth
  for path, item in pairs(desired) do
    if item.current.currentPart ~= item.saved.partName then
      minimumDepth = math.min(minimumDepth or item.current.depth, item.current.depth)
      changed[path] = item
    end
  end
  if not minimumDepth then return util.deepCopy(scan.tree), {}, issues end
  local tree = util.deepCopy(scan.tree)
  local batch = {}
  for _, slot in ipairs(scan.slots or {}) do
    local item = changed[slot.path]
    if item and slot.depth == minimumDepth then
      local node = mutationEngine.getTreeNode(tree, slot.keys)
      if node then
        node.chosenPartName = item.saved.partName
        batch[#batch + 1] = {
          slotPath = slot.path, slotId = slot.id, previousPart = slot.currentPart,
          selectedPart = item.saved.partName, resolutionStrategy = item.strategy,
        }
      end
    end
  end
  return tree, batch, issues
end

local function tuningValues(entry, variables, mode)
  local values = {}
  local issues = {}
  for _, saved in ipairs(entry.final and entry.final.tuning or {}) do
    local metadata = type(variables) == "table" and variables[saved.name] or nil
    if type(metadata) ~= "table" then
      issues[#issues + 1] = {name = saved.name, reason = "tuning_missing"}
    else
      local minimum, maximum = tonumber(metadata.min), tonumber(metadata.max)
      if minimum and maximum and saved.value >= minimum and saved.value <= maximum then
        values[saved.name] = saved.value
      elseif mode == "compatible" and minimum and maximum then
        values[saved.name] = util.clamp(saved.value, minimum, maximum)
        issues[#issues + 1] = {name = saved.name, reason = "tuning_clamped", selectedValue = values[saved.name]}
      else issues[#issues + 1] = {name = saved.name, reason = "tuning_out_of_range"} end
    end
  end
  return values, issues
end

M.planPartsPass = planPartsPass
M.tuningValues = tuningValues
M.desiredByResolvedPath = desiredByResolvedPath

return M
