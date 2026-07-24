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

local function cleanCandidates(source, current, isBlacklisted, slot, validateCandidate)
  local result = {}
  local seen = {}
  local rejected = {}
  for _, candidate in ipairs(util.copyArray(source)) do
    if type(candidate) == "string" and candidate ~= "" and not seen[candidate]
    then
      seen[candidate] = true
      local blocked, blockedReason = false, nil
      if isBlacklisted then blocked, blockedReason = isBlacklisted(slot, candidate) end
      if blocked then
        rejected[#rejected + 1] = {
          candidate = candidate,
          reason = blockedReason or "candidate_blacklisted",
        }
      elseif candidate ~= current then
        local valid, reason = true, nil
        if validateCandidate then valid, reason = validateCandidate(slot, candidate) end
        if valid then
          result[#result + 1] = candidate
        else
          rejected[#rejected + 1] = {candidate = candidate, reason = reason or "candidate_unproven"}
        end
      end
    end
  end
  table.sort(result)
  table.sort(rejected, function(a, b)
    local left = type(a) == "table" and a.candidate or a
    local right = type(b) == "table" and b.candidate or b
    return tostring(left) < tostring(right)
  end)
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
    local locked, lockReason = false, nil
    if eligible and options.isLocked then locked, lockReason = options.isLocked(slot) end
    local deferredBy
    if eligible then
      for _, ancestor in ipairs(changedAncestors) do
        if isDescendant(slot, ancestor) then deferredBy = ancestor; break end
      end
    end
    if locked then
      decisions[#decisions + 1] = {
        slotName = slot.id,
        slotPath = slot.path,
        previousPart = slot.currentPart,
        selectedPart = slot.currentPart,
        passNumber = passNumber,
        skipped = true,
        locked = true,
        reason = lockReason or "locked",
      }
    elseif deferredBy then
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
    else
      local slotGenerator = generator
      if eligible and options.independentSubstreams and type(generator.fork) == "function" then
        local category = options.categoryForSlot and options.categoryForSlot(slot) or "other"
        slotGenerator = generator:fork("category:" .. tostring(category)):fork("slot:" .. tostring(slot.path))
      end
    local selectedByChaos = eligible and slotGenerator:boolean(mutationPolicy.mutationChance(policy, slot, passNumber))
    if eligible and selectedByChaos then
      local alternatives, rejected = cleanCandidates(
        slot.candidates,
        slot.currentPart,
        options.isBlacklisted,
        slot,
        function(currentSlot, candidate)
          return validator.validateSelection(currentSlot, candidate, policy.protectCriticalParts)
        end
      )
      for _, rejectedCandidate in ipairs(rejected) do
        local candidate = type(rejectedCandidate) == "table" and rejectedCandidate.candidate or rejectedCandidate
        decisions[#decisions + 1] = {
          slotName = slot.id,
          slotPath = slot.path,
          previousPart = slot.currentPart,
          selectedPart = slot.currentPart,
          candidate = candidate,
          passNumber = passNumber,
          skipped = true,
          reason = type(rejectedCandidate) == "table" and rejectedCandidate.reason or "candidate_blacklisted",
        }
      end
      local canEmpty, emptyReason = validator.canEmpty(slot, policy.protectCriticalParts)
      local chooseEmpty = policy.allowMissingParts and canEmpty and slotGenerator:boolean(policy.emptySlotChance)
      local selected
      local reason

      if chooseEmpty and slot.currentPart ~= "" then
        selected = ""
        reason = "chaos_missing_part"
      elseif #alternatives > 0 then
        selected = slotGenerator:choice(alternatives)
        reason = "compatible_alternative"
      end

      local protectionReason
      if selected == nil and policy.protectCriticalParts then
        local protected
        protected, protectionReason = validator.protectedSelection(slot, true)
        selected = protected
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
              keys = util.copyArray(slot.keys),
              previousPart = slot.currentPart,
              selectedPart = selected,
              previousSource = util.deepCopy(slot.currentSource),
              selectedSource = util.deepCopy(slot.candidateMetadata and slot.candidateMetadata[selected] or {
                sourceKind = "unknown", sourceLabel = "Unknown",
              }),
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
      elseif selected == nil then
        decisions[#decisions + 1] = {
          slotName = slot.id,
          slotPath = slot.path,
          previousPart = slot.currentPart,
          selectedPart = slot.currentPart,
          passNumber = passNumber,
          skipped = true,
          reason = #alternatives == 0 and "no_alternative" or "unchanged_same_selection",
        }
      end
    elseif eligible then
      decisions[#decisions + 1] = {
        slotName = slot.id,
        slotPath = slot.path,
        previousPart = slot.currentPart,
        selectedPart = slot.currentPart,
        passNumber = passNumber,
        skipped = true,
        reason = "not_selected_by_chaos",
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
