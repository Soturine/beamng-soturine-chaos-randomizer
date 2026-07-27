local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local function nodeAt(tree, keys)
  local node = tree
  for _, key in ipairs(keys or {}) do node = node and node.children and node.children[key] end
  return node
end

local function failurePaths(failures)
  local result, seen = {}, {}
  for _, failure in ipairs(failures or {}) do
    local path = failure.slotPath or failure.path
    if type(path) == "string" and path ~= "" and not seen[path] then
      seen[path] = true
      result[#result + 1] = path
    end
  end
  table.sort(result)
  return result
end

local function repairTarget(currentScan, sourceScan, requestedPath)
  local source = sourceScan.byPath[requestedPath]
  local current = currentScan.byPath and currentScan.byPath[requestedPath] or nil
  if not source then return nil, nil, "repair_source_part_unavailable" end
  if current then return current, source, nil end

  -- A changed parent can remove the failed child slot from the current tree.
  -- Walk only as far as the nearest still-present ancestor and restore that
  -- one source part; the following reload recreates the dependency subtree.
  local parentPath = source.parentPath
  while type(parentPath) == "string" and parentPath ~= "" do
    local sourceParent = sourceScan.byPath[parentPath]
    local currentParent = currentScan.byPath and currentScan.byPath[parentPath] or nil
    if sourceParent and currentParent then return currentParent, sourceParent, nil end
    parentPath = sourceParent and sourceParent.parentPath or nil
  end
  return nil, source, "repair_target_path_unavailable"
end

local function plan(currentScan, sourceScan, failures, sourceType)
  if type(currentScan) ~= "table" or type(currentScan.tree) ~= "table" then
    return nil, "critical_repair_current_tree_missing"
  end
  if type(sourceScan) ~= "table" or type(sourceScan.byPath) ~= "table" then
    return nil, "critical_repair_source_scan_missing"
  end
  local tree, repairs, unresolved = util.deepCopy(currentScan.tree), {}, {}
  for _, path in ipairs(failurePaths(failures)) do
    local current, source, targetError = repairTarget(currentScan, sourceScan, path)
    if not source or type(source.currentPart) ~= "string" or source.currentPart == "" then
      unresolved[#unresolved + 1] = {slotPath = path, reason = "repair_source_part_unavailable"}
    elseif not current or targetError then
      unresolved[#unresolved + 1] = {slotPath = path, reason = targetError or "repair_target_path_unavailable"}
    else
      local node = nodeAt(tree, current.keys)
      if not node then
        unresolved[#unresolved + 1] = {slotPath = path, reason = "repair_tree_node_unavailable"}
      elseif node.chosenPartName ~= source.currentPart then
        repairs[#repairs + 1] = {
          slotPath = current.path or path, requestedSlotPath = path,
          keys = util.copyArray(current.keys),
          previousPart = node.chosenPartName, restoredPart = source.currentPart,
          dependencyPath = source.parentPath, sourceType = sourceType,
        }
        node.chosenPartName = source.currentPart
      end
    end
  end
  if #unresolved > 0 then return nil, "critical_repair_dependency_unresolved", {unresolved = unresolved} end
  if #repairs == 0 then return nil, "critical_repair_no_changes" end
  return {
    tree = tree, repairs = repairs, sourceType = sourceType,
    retainedMutationCount = math.max(0, #(currentScan.slots or {}) - #repairs),
  }
end

local function repairedPaths(planValue)
  local result = {}
  for _, repair in ipairs(type(planValue) == "table" and planValue.repairs or {}) do
    result[repair.slotPath] = true
  end
  return result
end

M.nodeAt = nodeAt
M.failurePaths = failurePaths
M.repairTarget = repairTarget
M.plan = plan
M.repairedPaths = repairedPaths

return M
