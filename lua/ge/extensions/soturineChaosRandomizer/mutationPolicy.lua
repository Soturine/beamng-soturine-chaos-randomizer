local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local function fromSettings(settings)
  settings = settings or {}
  local slider = util.clamp(settings.chaos or 75, 0, 100)
  local chaos = slider / 100
  local allowMissing = settings.allowMissingParts == true

  return {
    slider = slider,
    chaos = chaos,
    partMutationChance = 0.05 + 0.95 * chaos,
    parentMutationChance = 0.05 + 0.80 * chaos,
    nestedMutationChance = 0.10 + 0.90 * chaos,
    extremeTuningChance = chaos * chaos,
    paintMutationChance = 0.20 + 0.80 * chaos,
    -- Normal completion is governed by tree convergence. This value remains
    -- only as a compatibility field for older callers and mirrors the hard
    -- safety ceiling rather than a five-pass success condition.
    maxMutationPasses = 48,
    emptySlotChance = allowMissing and math.max(0, (chaos - 0.25) / 0.75) * 0.35 or 0,
    tuningSpread = 0.05 + 0.95 * chaos,
    paintContrast = 0.10 + 0.90 * chaos,
    allowMissingParts = allowMissing,
    protectCriticalParts = settings.protectCriticalParts == true,
  }
end

local function mutationChance(policy, slot, passNumber)
  if tonumber(policy.slider) == 100 then return 1 end
  local chance = policy.partMutationChance
  if slot and slot.depth == 1 then
    chance = chance * policy.parentMutationChance
  elseif slot and slot.depth and slot.depth > 1 then
    chance = chance * policy.nestedMutationChance
  end
  if (passNumber or 1) > 1 then
    chance = chance * policy.nestedMutationChance
  end
  return util.clamp(chance, 0, 1)
end

M.fromSettings = fromSettings
M.mutationChance = mutationChance

return M
