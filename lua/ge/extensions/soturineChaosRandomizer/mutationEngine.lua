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

local function cleanCandidates(source, current, isBlacklisted, slot)
  local result = {}
  local seen = {}
  local rejected = {}
  for _, candidate in ipairs(util.copyArray(source)) do
    if type(candidate) == "string" and candidate ~= "" and not seen[candidate]
    then
      seen[candidate] = true
      if isBlacklisted and isBlacklisted(slot, candidate) then
        rejected[#rejected + 1] = candidate
      elseif candidate ~= current then
        result[#result + 1] = candidate
      end
    end
  end
  table.sort(result)
  table.sort(rejected)
  return result, rejected
end

local function isDescendant(slot, ancestor)
  if not slot or not ancestor or #slot.keys <= #ancestor.keys then return false end
  for index = 1, #ancestor.keys do
    if slot.keys[index] ~= ancestor.keys[index] then return false end
  end
  return true
end

local function plan(scan, eligiblePaths, policy, generator, options)
  options = options or {}
  local tree = util.deepCopy(scan.tree)
  local decisions = {}
  local passNumber = tonumber(options.passNumber) or 1
  local changedAncestors = {}

  for _, slot in ipairs(scan.slots or {}) do
    local eligible = not eligiblePaths or eligiblePaths[slot.path]
    local deferredBy
    if eligible then
      for _, ancestor in ipairs(changedAncestors) do
        if isDescendant(slot, ancestor) then deferredBy = ancestor; break end
      end
    end
    if deferredBy then
      decisions[#decisions + 1] = {
        slotName = slot.id,
        slotPath = slot.path,
        previousPart = slot.currentPart,
        selectedPart = slot.currentPart,
        passNumber = passNumber,
        skipped = true,
        deferred = true,
        ancestorPath = deferredBy.path,
        reason = "deferred_due_to_ancestor_change",
      }
    elseif eligible and generator:boolean(mutationPolicy.mutationChance(policy, slot, passNumber)) then
      local alternatives, rejected = cleanCandidates(slot.candidates, slot.currentPart, options.isBlacklisted, slot)
      for _, candidate in ipairs(rejected) do
        decisions[#decisions + 1] = {
          slotName = slot.id,
          slotPath = slot.path,
          previousPart = slot.currentPart,
          selectedPart = slot.currentPart,
          candidate = candidate,
          passNumber = passNumber,
          skipped = true,
          reason = "candidate_blacklisted",
        }
      end
      local canEmpty, emptyReason = validator.canEmpty(slot, policy.protectCriticalParts)
      local chooseEmpty = policy.allowMissingParts and canEmpty and generator:boolean(policy.emptySlotChance)
      local selected
      local reason

      local protected, protectionReason = validator.protectedSelection(slot, policy.protectCriticalParts)
      if protected ~= nil then
        selected = protected
        reason = protectionReason
      end

      if selected == nil and chooseEmpty and slot.currentPart ~= "" then
        selected = ""
        reason = "chaos_missing_part"
      elseif selected == nil and #alternatives > 0 then
        selected = generator:choice(alternatives)
        reason = "compatible_alternative"
      end

      if selected ~= nil and selected ~= slot.currentPart then
        local valid, validationReason = validator.validateSelection(slot, selected, policy.protectCriticalParts)
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
            changedAncestors[#changedAncestors + 1] = slot
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
      elseif protectionReason then
        decisions[#decisions + 1] = {
          slotName = slot.id,
          slotPath = slot.path,
          previousPart = slot.currentPart,
          selectedPart = slot.currentPart,
          passNumber = passNumber,
          skipped = true,
          protected = true,
          reason = protectionReason,
        }
      end
    end
  end

  return tree, decisions
end

M.plan = plan
M.cleanCandidates = cleanCandidates
M.getTreeNode = getTreeNode
M.isDescendant = isDescendant

return M
