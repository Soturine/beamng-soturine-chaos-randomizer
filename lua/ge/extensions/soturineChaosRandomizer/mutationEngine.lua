local util = require("ge/extensions/soturineChaosRandomizer/util")
local mutationPolicy = require("ge/extensions/soturineChaosRandomizer/mutationPolicy")
local validator = require("ge/extensions/soturineChaosRandomizer/validator")

local M = {}

local function getTreeNode(tree, keys)
  local node = tree
  for _, key in ipairs(keys or {}) do
    node = node and node.children and node.children[key]
  end
  return node
end

local function cleanCandidates(source, current, isBlacklisted)
  local result = {}
  local seen = {}
  for _, candidate in ipairs(util.copyArray(source)) do
    if type(candidate) == "string" and candidate ~= "" and not seen[candidate]
      and (not isBlacklisted or not isBlacklisted(candidate))
    then
      seen[candidate] = true
      if candidate ~= current then result[#result + 1] = candidate end
    end
  end
  table.sort(result)
  return result
end

local function plan(scan, eligiblePaths, policy, generator, options)
  options = options or {}
  local tree = util.deepCopy(scan.tree)
  local decisions = {}
  local passNumber = tonumber(options.passNumber) or 1

  for _, slot in ipairs(scan.slots or {}) do
    if (not eligiblePaths or eligiblePaths[slot.path])
      and generator:boolean(mutationPolicy.mutationChance(policy, slot, passNumber))
    then
      local alternatives = cleanCandidates(slot.candidates, slot.currentPart, options.isBlacklisted)
      local canEmpty, emptyReason = validator.canEmpty(slot, policy.keepVehicleDrivable)
      local chooseEmpty = policy.allowMissingParts and canEmpty and generator:boolean(policy.emptySlotChance)
      local selected
      local reason

      if chooseEmpty and slot.currentPart ~= "" then
        selected = ""
        reason = "chaos_missing_part"
      elseif #alternatives > 0 then
        selected = generator:choice(alternatives)
        reason = "compatible_alternative"
      end

      if selected ~= nil and selected ~= slot.currentPart then
        local valid, validationReason = validator.validateSelection(slot, selected, policy.keepVehicleDrivable)
        if valid then
          local node = getTreeNode(tree, slot.keys)
          if node then
            node.chosenPartName = selected
            decisions[#decisions + 1] = {
              slotName = slot.id,
              slotPath = slot.path,
              previousPart = slot.currentPart,
              selectedPart = selected,
              source = slot.source,
              wasRemoved = selected == "",
              passNumber = passNumber,
              reason = reason,
            }
          end
        else
          decisions[#decisions + 1] = {
            slotName = slot.id,
            slotPath = slot.path,
            previousPart = slot.currentPart,
            selectedPart = slot.currentPart,
            passNumber = passNumber,
            skipped = true,
            reason = validationReason or emptyReason or "validation_rejected",
          }
        end
      end
    end
  end

  return tree, decisions
end

M.plan = plan
M.cleanCandidates = cleanCandidates
M.getTreeNode = getTreeNode

return M
