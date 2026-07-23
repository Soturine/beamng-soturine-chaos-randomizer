local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local function slotSignature(slot)
  local candidates = util.copyArray(slot.candidates)
  table.sort(candidates)
  return table.concat({
    tostring(slot.path or ""),
    tostring(slot.id or ""),
    tostring(slot.currentPart or ""),
    slot.coreSlot and "1" or "0",
    slot.required and "1" or "0",
    tostring(slot.defaultPart or ""),
    table.concat(candidates, ","),
  }, "|")
end

local function scan(tree, metadataByPath)
  if type(tree) ~= "table" then return nil, "missing_parts_tree" end
  metadataByPath = type(metadataByPath) == "table" and metadataByPath or {}
  local slots = {}
  local byPath = {}

  local function visit(node, depth, keys)
    local childKeys = util.sortedKeys(node.children or {})
    for _, childKey in ipairs(childKeys) do
      local child = node.children[childKey]
      if type(child) == "table" then
        local childPath = child.path or (tostring(node.path or "/") .. tostring(childKey) .. "/")
        local metadata = metadataByPath[childPath] or {}
        local childNodeKeys = util.copyArray(keys)
        childNodeKeys[#childNodeKeys + 1] = childKey
        local slot = {
          id = child.id or childKey,
          path = childPath,
          depth = depth,
          keys = childNodeKeys,
          currentPart = child.chosenPartName or "",
          candidates = util.copyArray(child.suitablePartNames or metadata.candidates or {}),
          coreSlot = metadata.coreSlot == true,
          required = metadata.required == true or metadata.coreSlot == true,
          defaultPart = metadata.defaultPart,
          description = metadata.description,
          allowTypes = util.copyArray(metadata.allowTypes or {}),
          denyTypes = util.copyArray(metadata.denyTypes or {}),
          parentPart = metadata.parentPart,
          source = metadata.source,
        }
        slot.signature = slotSignature(slot)
        slots[#slots + 1] = slot
        byPath[slot.path] = slot
        visit(child, depth + 1, childNodeKeys)
      end
    end
  end

  visit(tree, 1, {})
  table.sort(slots, function(a, b)
    if a.depth ~= b.depth then return a.depth < b.depth end
    if a.path ~= b.path then return a.path < b.path end
    return tostring(a.id) < tostring(b.id)
  end)
  local signatureParts = {}
  for _, slot in ipairs(slots) do signatureParts[#signatureParts + 1] = slot.signature end
  return {
    tree = util.deepCopy(tree),
    slots = slots,
    byPath = byPath,
    signature = table.concat(signatureParts, "\n"),
  }
end

local function changedPaths(previousScan, currentScan)
  local result = {}
  if not previousScan then
    for _, slot in ipairs(currentScan.slots or {}) do result[slot.path] = true end
    return result
  end
  for _, slot in ipairs(currentScan.slots or {}) do
    local previous = previousScan.byPath and previousScan.byPath[slot.path]
    if not previous or previous.signature ~= slot.signature then result[slot.path] = true end
  end
  return result
end

local function eligiblePaths(previousScan, currentScan, deferredPaths, mutatedPaths)
  local result = changedPaths(previousScan, currentScan)
  for path in pairs(deferredPaths or {}) do
    if currentScan.byPath[path] then result[path] = true end
  end
  for path in pairs(mutatedPaths or {}) do result[path] = nil end
  return result
end

M.scan = scan
M.slotSignature = slotSignature
M.changedPaths = changedPaths
M.eligiblePaths = eligiblePaths

return M
