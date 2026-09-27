local util = require("ge/extensions/soturineChaosRandomizer/util")
local formationEnum = require("ge/extensions/soturineChaosRandomizer/formationEnum")

local M = {}

-- The draw list is derived once per preview change, never per rendered frame.
local drawLists = setmetatable({}, {__mode = "k"})

local STATES = {
  PREVIEW_DISABLED = true,
  PREVIEW_DATA_READY = true,
  PREVIEW_RENDERING = true,
  PREVIEW_RENDERED = true,
  PREVIEW_FAILED = true,
  PREVIEW_STALE = true,
}

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
  local source = tostring(raw.source or "")
  local actual = util.isFinite(width) and util.isFinite(length)
    and source ~= "" and not source:find("fallback", 1, true)
    and not source:find("estimated", 1, true)
  return {
    width = util.clamp(width or 2, 0.5, 8),
    length = util.clamp(length or 4.8, 1, 30),
    source = actual and source or "estimated_fallback",
    actual = actual,
  }
end

local function slot(index, name, status, placement, margin, rawDimensions)
  placement = type(placement) == "table" and placement or {}
  local bounds = dimensions(rawDimensions or placement.dimensions)
  local groundKnown = type(placement.normal) == "table"
    and util.isFinite(tonumber(placement.normal.z))
  local overlapStatus = placement.overlapStatus == "blocked" and "blocked" or "clear"
  local positionStatus = not groundKnown and "unknown"
    or overlapStatus == "blocked" and "blocked"
    or placement.tight == true and "tight" or "valid"
  return {
    slot = index,
    slotId = tostring(index),
    name = tostring(name or (index == 0 and "Player" or "Competitor " .. tostring(index))),
    status = tostring(status or "planned"),
    transform = {
      position = util.deepCopy(placement.position or {x = 0, y = 0, z = 0}),
      forward = util.deepCopy(placement.forward or {x = 0, y = 1, z = 0}),
    },
    bounds = bounds,
    estimatedBounds = bounds.actual and nil or util.deepCopy(bounds),
    actualBoundsKnown = bounds.actual,
    clearance = tonumber(margin) or 1.5,
    ground = {normal = util.deepCopy(placement.normal), valid = groundKnown},
    groundStatus = groundKnown and "valid" or "unknown",
    overlap = {detected = overlapStatus == "blocked"},
    overlapStatus = overlapStatus,
    positionStatus = positionStatus,
    visual = STATUS_VISUAL[status] or "planned",
    visualStatus = STATUS_VISUAL[status] or "planned",
    label = tostring(index == 0 and "P" or index) .. " - " .. tostring(name or ""),
  }
end

local function build(kind, plan, lineup, playerPlacement, enabled)
  plan = type(plan) == "table" and plan or {options = {}, placements = {}}
  local options = type(plan.options) == "table" and plan.options or {}
  local preview = {
    enabled = enabled ~= false,
    state = enabled == false and "PREVIEW_DISABLED" or "PREVIEW_DATA_READY",
    kind = kind == "final_grid" and "finalGrid" or "staging",
    phase = kind == "final_grid" and "final_grid" or "generation_staging",
    origin = util.deepCopy(playerPlacement and playerPlacement.position
      or plan.placements[1] and plan.placements[1].position or {x = 0, y = 0, z = 0}),
    heading = options.headingMode or "camera",
    formation = formationEnum.normalize(lineup and lineup.settings and lineup.settings.formation
      or options.requestedMode or options.mode),
    spacing = {
      mode = options.spacingMode or "automatic",
      lateral = tonumber(options.resolvedLateralSpacing or options.lateralSpacing) or 0,
      longitudinal = tonumber(options.resolvedLongitudinalSpacing or options.longitudinalSpacing) or 0,
      safetyMargin = tonumber(options.safetyMargin) or 1.5,
    },
    slots = {},
    clearedReason = nil,
    renderer = {
      attemptedFrames = 0,
      successfulFrames = 0,
      renderedMarkerCount = 0,
      requestedMarkerCount = 0,
      lastFrameAt = nil,
      lastErrorCode = nil,
      lastErrorMessage = nil,
      textErrorCode = nil,
      missing = {},
    },
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

-- Records one onPreRender draw attempt. PREVIEW_RENDERED requires a frame that
-- actually drew at least one marker; returns true only when the published
-- state or error changed so callers never publish per frame.
local function recordRender(preview, drawn, report, now)
  if type(preview) ~= "table" or preview.enabled ~= true then return false end
  report = type(report) == "table" and report or {errorCode = "preview_render_empty"}
  local renderer = preview.renderer or {}
  preview.renderer = renderer
  local previousState, previousError = preview.state, renderer.lastErrorCode
  renderer.attemptedFrames = (tonumber(renderer.attemptedFrames) or 0) + 1
  renderer.requestedMarkerCount = math.max(0, math.floor(tonumber(report.requestedMarkerCount) or 0))
  renderer.renderedMarkerCount = math.max(0, math.floor(tonumber(report.renderedMarkerCount) or 0))
  renderer.textErrorCode = report.textErrorCode
  renderer.missing = type(report.missing) == "table" and util.deepCopy(report.missing) or {}
  if drawn == true and renderer.renderedMarkerCount > 0 then
    renderer.successfulFrames = (tonumber(renderer.successfulFrames) or 0) + 1
    renderer.lastFrameAt = tonumber(now) or 0
    renderer.lastErrorCode, renderer.lastErrorMessage = nil, nil
    -- Stale markers stay visible until the preview is rebuilt, but keep saying so.
    if preview.state ~= "PREVIEW_STALE" then preview.state = "PREVIEW_RENDERED" end
  else
    renderer.lastErrorCode = report.errorCode or "preview_render_empty"
    renderer.lastErrorMessage = report.errorMessage
    preview.state = "PREVIEW_FAILED"
  end
  return previousState ~= preview.state or previousError ~= renderer.lastErrorCode
end

-- The render callback was never observed although the preview is enabled.
local function recordMissingCallback(preview)
  if type(preview) ~= "table" or preview.enabled ~= true or preview.state ~= "PREVIEW_DATA_READY" then
    return false
  end
  preview.renderer = preview.renderer or {}
  preview.renderer.lastErrorCode = "preview_render_callback_missing"
  preview.state = "PREVIEW_FAILED"
  return true
end

local function stale(preview, reason)
  if type(preview) ~= "table" or preview.enabled ~= true then return false end
  drawLists[preview] = nil
  preview.state = "PREVIEW_STALE"
  preview.staleReason = tostring(reason or "preview_data_stale")
  return true
end

local function update(preview, lineup)
  if type(preview) ~= "table" or type(lineup) ~= "table" then return false end
  drawLists[preview] = nil
  for _, marker in ipairs(preview.slots or {}) do
    if marker.slot ~= 0 then
      local competitor = lineup.competitors and lineup.competitors[marker.slot]
      if competitor then
        marker.name = competitor.name
        marker.status = competitor.status
        marker.visual = STATUS_VISUAL[competitor.status] or "planned"
        marker.visualStatus = marker.visual
        marker.label = tostring(marker.slot) .. " - " .. tostring(competitor.name)
        if competitor.previewDimensions then
          marker.bounds = dimensions(competitor.previewDimensions)
          marker.actualBoundsKnown = marker.bounds.actual
          marker.estimatedBounds = marker.bounds.actual and nil or util.deepCopy(marker.bounds)
        end
      end
    end
  end
  return true
end

local function placements(preview)
  if type(preview) ~= "table" or preview.enabled ~= true then return {} end
  if drawLists[preview] then return drawLists[preview] end
  local result = {}
  for _, marker in ipairs(preview.slots or {}) do
    result[#result + 1] = {
      index = marker.slot, position = util.deepCopy(marker.transform.position),
      forward = util.deepCopy(marker.transform.forward), dimensions = util.deepCopy(marker.bounds),
      clearance = marker.clearance, positionStatus = marker.positionStatus,
      groundStatus = marker.groundStatus, overlapStatus = marker.overlapStatus,
      label = marker.label, visual = marker.visual,
    }
  end
  drawLists[preview] = result
  return result
end

local function clear(preview, reason)
  if type(preview) ~= "table" then return nil end
  drawLists[preview] = nil
  preview.enabled = false
  preview.state = "PREVIEW_DISABLED"
  preview.renderer = preview.renderer or {}
  preview.clearedReason = tostring(reason or "preview_cleared")
  preview.slots = {}
  return preview
end

M.STATUS_VISUAL = STATUS_VISUAL
M.STATES = STATES
M.build = build
M.update = update
M.placements = placements
M.recordRender = recordRender
M.recordMissingCallback = recordMissingCallback
M.stale = stale
M.clear = clear

return M
