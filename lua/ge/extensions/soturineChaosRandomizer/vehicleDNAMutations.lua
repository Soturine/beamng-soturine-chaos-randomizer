local util = require("ge/extensions/soturineChaosRandomizer/util")
local rng = require("ge/extensions/soturineChaosRandomizer/rng")

local M = {}

M.MAX_LINEAGE_DEPTH = 32
M.STRENGTHS = {
  small = {chaos = 25, label = "Small Mutation"},
  medium = {chaos = 60, label = "Medium Mutation"},
  wild = {chaos = 100, label = "Wild Mutation"},
}

local function validateStrength(strength)
  return M.STRENGTHS[strength] and strength or nil
end

local function deriveSeed(parentSeed, parentId, mutationIndex, strength)
  strength = validateStrength(strength)
  mutationIndex = math.floor(tonumber(mutationIndex) or 0)
  if not strength or mutationIndex < 1 then return nil, "mutation_parameters_invalid" end
  local source = table.concat({
    "SCRDNA-MUTATION-1", tostring(parentSeed or ""), tostring(parentId or ""),
    tostring(mutationIndex), strength,
  }, ":")
  return rng.new(source).seed
end

local function nextIndex(library, parentId)
  local maximum = 0
  for _, entry in ipairs(type(library) == "table" and library.entries or {}) do
    local lineage = type(entry.lineage) == "table" and entry.lineage or {}
    if lineage.parentId == parentId then maximum = math.max(maximum, math.floor(tonumber(lineage.mutationIndex) or 0)) end
  end
  return maximum + 1
end

local function lineage(parent, mutationIndex, strength, createdFrom)
  if type(parent) ~= "table" or not validateStrength(strength) then return nil, "mutation_parent_invalid" end
  local parentLineage = type(parent.lineage) == "table" and parent.lineage or {}
  local generation = math.floor(tonumber(parentLineage.generation) or 0) + 1
  if generation > M.MAX_LINEAGE_DEPTH then return nil, "mutation_lineage_limit" end
  return {
    parentId = parent.id,
    rootId = parentLineage.rootId or parent.id,
    generation = generation,
    mutationIndex = mutationIndex,
    mutationStrength = strength,
    createdFrom = createdFrom or "mutation",
    parentSeed = parent.generation and parent.generation.seed,
  }
end

local function settingsForStrength(settings, strength)
  local definition = M.STRENGTHS[validateStrength(strength)]
  if not definition then return nil, "mutation_strength_invalid" end
  local result = util.deepCopy(settings or {})
  result.chaos = definition.chaos
  return result
end

M.validateStrength = validateStrength
M.deriveSeed = deriveSeed
M.nextIndex = nextIndex
M.lineage = lineage
M.settingsForStrength = settingsForStrength

return M
