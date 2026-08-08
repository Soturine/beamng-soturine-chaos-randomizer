local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local STATUS_VISUAL = {
  player = "player",
  planned = "planned",
  selecting_vehicle = "generating",
  spawning_vehicle = "generating",
  binding_vehicle = "generating",
  randomizing = "generating",
  validating = "generating",
  ready = "ready",
  ready_with_warnings = "ready_with_warnings",
  partial = "ready_with_warnings",
  failed = "failed",
  cancelled = "failed",
  skipped = "failed",
}

local function dimensions(raw)
  raw = type(raw) == "table" and raw or {}
  local width, length = tonumber(raw.width), tonumber(raw.length)
  local actual = util.isFinite(width) and util.isFinite(length)
  return {
    width = util.clamp(width or 2, 0.5, 8),
    length = util.clamp(length or 4.8, 1, 30),
    source = actual and (raw.source or "actual") or "estimated_fallback",
  }
end

local function slot(index, name, status, placement, margin, rawDimensions)
  placement = type(placement) == "table" and placement or {}
  local bounds = dimensions(rawDimensions or placement.dimensions)
  return {
    slot = index,
    name = tostring(name or (index == 0 and "Player" or "Competitor " .. tostring(index))),
    status = tostring(status or "planned"),
    transform = {
      position = util.deepCopy(placement.position or {x = 0, y = 0, z = 0}),
      forward = util.deepCopy(placement.forward or {x = 0, y = 1, z = 0}),
    },
    bounds = bounds,
    clearance = tonumber(margin) or 1.5,
    ground = {normal = util.deepCopy(placement.normal or {x = 0, y = 0, z = 1}), valid = true},
    overlap = {detected = false},
    visual = STATUS_VISUAL[status] or "planned",
    label = tostring(index == 0 and "P" or index) .. " - " .. tostring(name or ""),
  }
end

local function build(kind, plan, lineup, playerPlacement, enabled)
  plan = type(plan) == "table" and plan or {options = {}, placements = {}}
  local options = type(plan.options) == "table" and plan.options or {}
  local preview = {
    enabled = enabled ~= false,
    kind = kind == "final_grid" and "final_grid" or "generation_staging",
    origin = util.deepCopy(playerPlacement and playerPlacement.position
      or plan.placements[1] and plan.placements[1].position or {x = 0, y = 0, z = 0}),
    heading = options.headingMode or "camera",
    formation = options.mode or options.requestedMode or "Grid",
    spacing = {
      mode = options.spacingMode or "automatic",
      lateral = tonumber(options.resolvedLateralSpacing or options.lateralSpacing) or 0,
      longitudinal = tonumber(options.resolvedLongitudinalSpacing or options.longitudinalSpacing) or 0,
      safetyMargin = tonumber(options.safetyMargin) or 1.5,
    },
    slots = {},
    clearedReason = nil,
  }
  if playerPlacement then
    preview.slots[#preview.slots + 1] = slot(0, "Player", "player", playerPlacement,
      preview.spacing.safetyMargin, playerPlacement.dimensions)
  end
  for index, placement in ipairs(plan.placements or {}) do
    local competitor = lineup and lineup.competitors and lineup.competitors[index] or nil
    preview.slots[#preview.slots + 1] = slot(index,
      competitor and competitor.name or "Competitor " .. tostring(index),
      competitor and competitor.status or "planned", placement,
      preview.spacing.safetyMargin, competitor and competitor.previewDimensions or placement.dimensions)
  end
  return preview
end

local function update(preview, lineup)
  if type(preview) ~= "table" or type(lineup) ~= "table" then return false end
  for _, marker in ipairs(preview.slots or {}) do
    if marker.slot ~= 0 then
      local competitor = lineup.competitors and lineup.competitors[marker.slot]
      if competitor then
        marker.name = competitor.name
        marker.status = competitor.status
        marker.visual = STATUS_VISUAL[competitor.status] or "planned"
        marker.label = tostring(marker.slot) .. " - " .. tostring(competitor.name)
        if competitor.previewDimensions then marker.bounds = dimensions(competitor.previewDimensions) end
      end
    end
  end
  return true
end

local function placements(preview)
  local result = {}
  if type(preview) ~= "table" or preview.enabled ~= true then return result end
  for _, marker in ipairs(preview.slots or {}) do
    result[#result + 1] = {
      index = marker.slot, position = util.deepCopy(marker.transform.position),
      forward = util.deepCopy(marker.transform.forward), dimensions = util.deepCopy(marker.bounds),
      label = marker.label, visual = marker.visual,
    }
  end
  return result
end

local function clear(preview, reason)
  if type(preview) ~= "table" then return nil end
  preview.enabled = false
  preview.clearedReason = tostring(reason or "preview_cleared")
  preview.slots = {}
  return preview
end

M.STATUS_VISUAL = STATUS_VISUAL
M.build = build
M.update = update
M.placements = placements
M.clear = clear

return M
