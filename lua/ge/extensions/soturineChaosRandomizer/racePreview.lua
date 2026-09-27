local util = require("ge/extensions/soturineChaosRandomizer/util")
local formationEnum = require("ge/extensions/soturineChaosRandomizer/formationEnum")

local M = {}

-- Static per-marker draw data (bounds, labels, colours, local offsets) is built
-- once per preview; only the world transform is refreshed in place per frame.
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

-- Anchor modes: "player" and "camera" follow the live frame, "custom" and
-- "fixed" stay where they were planned.
local DYNAMIC_ANCHORS = {player = true, camera = true}

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

local function flatUnit(value, fallback)
  value = type(value) == "table" and value or {}
  local x, y = tonumber(value.x) or 0, tonumber(value.y) or 0
  local length = math.sqrt(x * x + y * y)
  if length < 1e-6 then return fallback end
  return {x = x / length, y = y / length}
end

local function normalizeAnchor(anchor, fallbackPosition)
  anchor = type(anchor) == "table" and anchor or {}
  local position = type(anchor.position) == "table" and anchor.position or fallbackPosition or {x = 0, y = 0, z = 0}
  local forward = flatUnit(anchor.forward, {x = 0, y = 1})
  return {
    mode = DYNAMIC_ANCHORS[anchor.mode] and anchor.mode or anchor.mode == "custom" and "custom" or "fixed",
    vehicleId = tonumber(anchor.vehicleId),
    position = {x = tonumber(position.x) or 0, y = tonumber(position.y) or 0, z = tonumber(position.z) or 0},
    forward = {x = forward.x, y = forward.y, z = 0},
  }
end

-- Offsets in the anchor frame: right = (forward.y, -forward.x).
local function localPose(anchor, position, forward)
  local fx, fy = anchor.forward.x, anchor.forward.y
  local rx, ry = fy, -fx
  local dx = (tonumber(position.x) or 0) - anchor.position.x
  local dy = (tonumber(position.y) or 0) - anchor.position.y
  local heading = flatUnit(forward, anchor.forward)
  return {
    longitudinal = dx * fx + dy * fy,
    lateral = dx * rx + dy * ry,
    vertical = (tonumber(position.z) or 0) - anchor.position.z,
    headingForward = heading.x * fx + heading.y * fy,
    headingRight = heading.x * rx + heading.y * ry,
  }
end

local function slot(index, name, status, placement, margin, rawDimensions, anchor)
  placement = type(placement) == "table" and placement or {}
  local bounds = dimensions(rawDimensions or placement.dimensions)
  local groundKnown = type(placement.normal) == "table"
    and util.isFinite(tonumber(placement.normal.z))
  local overlapStatus = placement.overlapStatus == "blocked" and "blocked" or "clear"
  local positionStatus = not groundKnown and "unknown"
    or overlapStatus == "blocked" and "blocked"
    or placement.tight == true and "tight" or "valid"
  local position = util.deepCopy(placement.position or {x = 0, y = 0, z = 0})
  local forward = util.deepCopy(placement.forward or {x = 0, y = 1, z = 0})
  return {
    slot = index,
    slotId = tostring(index),
    name = tostring(name or (index == 0 and "Player" or "Competitor " .. tostring(index))),
    status = tostring(status or "planned"),
    transform = {position = position, forward = forward},
    localPose = localPose(anchor, position, forward),
    followsPlayer = index == 0,
    bounds = bounds,
    actualBoundsKnown = bounds.actual,
    clearance = tonumber(margin) or 1.5,
    groundStatus = groundKnown and "valid" or "unknown",
    overlapStatus = overlapStatus,
    positionStatus = positionStatus,
    visual = STATUS_VISUAL[status] or "planned",
    label = tostring(index == 0 and "P" or index) .. " - " .. tostring(name or ""),
  }
end

-- anchor: {mode = "player"|"camera"|"custom", vehicleId, position, forward},
-- the frame the plan was made in. Without one the preview is fixed in place.
local function build(kind, plan, lineup, playerPlacement, enabled, anchor)
  plan = type(plan) == "table" and plan or {options = {}, placements = {}}
  local options = type(plan.options) == "table" and plan.options or {}
  local firstPosition = playerPlacement and playerPlacement.position
    or plan.placements and plan.placements[1] and plan.placements[1].position
  local normalizedAnchor = normalizeAnchor(anchor, firstPosition)
  local preview = {
    enabled = enabled ~= false,
    state = enabled == false and "PREVIEW_DISABLED" or "PREVIEW_DATA_READY",
    kind = kind == "final_grid" and "finalGrid" or "staging",
    anchor = normalizedAnchor,
    heading = options.headingMode or "camera",
    formation = formationEnum.normalize(lineup and lineup.settings and lineup.settings.formation
      or options.requestedMode or options.mode),
    quality = plan.estimated == true and "estimated" or "validated",
    spacing = {
      mode = options.spacingMode or "automatic",
      lateral = tonumber(options.resolvedLateralSpacing or options.lateralSpacing) or 0,
      longitudinal = tonumber(options.resolvedLongitudinalSpacing or options.longitudinalSpacing) or 0,
      safetyMargin = tonumber(options.safetyMargin) or 1.5,
    },
    slots = {},
    renderer = {renderedMarkerCount = 0, requestedMarkerCount = 0, lastErrorCode = nil, missing = {}},
  }
  if playerPlacement then
    preview.slots[#preview.slots + 1] = slot(0, "Player", "player", playerPlacement,
      preview.spacing.safetyMargin, playerPlacement.dimensions, normalizedAnchor)
  end
  for index, placement in ipairs(plan.placements or {}) do
    local competitor = lineup and lineup.competitors and lineup.competitors[index] or nil
    preview.slots[#preview.slots + 1] = slot(index,
      competitor and competitor.name or "Competitor " .. tostring(index),
      competitor and competitor.status or "planned", placement,
      preview.spacing.safetyMargin, competitor and competitor.previewDimensions or placement.dimensions,
      normalizedAnchor)
  end
  return preview
end

local function isDynamic(preview)
  return type(preview) == "table" and DYNAMIC_ANCHORS[preview.anchor and preview.anchor.mode] == true
end

-- Records one onPreRender draw attempt. PREVIEW_RENDERED requires a frame that
-- actually drew at least one marker. Returns true only when the published
-- state or error changed; per-frame counters stay internal.
local function recordRender(preview, drawn, report, now)
  if type(preview) ~= "table" or preview.enabled ~= true then return false end
  report = type(report) == "table" and report or {errorCode = "preview_render_empty"}
  local renderer = preview.renderer or {}
  preview.renderer = renderer
  local previousState, previousError = preview.state, renderer.lastErrorCode
  local previousCount = renderer.renderedMarkerCount
  renderer.requestedMarkerCount = math.max(0, math.floor(tonumber(report.requestedMarkerCount) or 0))
  renderer.renderedMarkerCount = math.max(0, math.floor(tonumber(report.renderedMarkerCount) or 0))
  renderer.textErrorCode = report.textErrorCode
  renderer.missing = type(report.missing) == "table" and report.missing or renderer.missing
  if drawn == true and renderer.renderedMarkerCount > 0 then
    renderer.lastFrameAt = tonumber(now) or 0
    renderer.lastErrorCode, renderer.lastErrorMessage = nil, nil
    -- A stale plan keeps drawing but keeps saying so until it is rebuilt.
    if preview.state ~= "PREVIEW_STALE" then preview.state = "PREVIEW_RENDERED" end
  else
    renderer.lastErrorCode = report.errorCode or "preview_render_empty"
    renderer.lastErrorMessage = report.errorMessage
    preview.state = "PREVIEW_FAILED"
  end
  return previousState ~= preview.state or previousError ~= renderer.lastErrorCode
    or previousCount ~= renderer.renderedMarkerCount
end

-- The frame a dynamic preview follows no longer exists: draw nothing and say why.
local function recordAnchorUnavailable(preview, reason)
  if type(preview) ~= "table" or preview.enabled ~= true then return false end
  local renderer = preview.renderer or {}
  preview.renderer = renderer
  local code = "preview_anchor_unavailable"
  if preview.state == "PREVIEW_FAILED" and renderer.lastErrorCode == code then return false end
  renderer.lastErrorCode, renderer.lastErrorMessage = code, reason and tostring(reason) or nil
  renderer.renderedMarkerCount = 0
  preview.state = "PREVIEW_FAILED"
  return true
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

-- Stale means the plan no longer represents the chosen options or data;
-- following a moving anchor is normal behaviour, not staleness.
local function stale(preview, reason)
  if type(preview) ~= "table" or preview.enabled ~= true then return false end
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
        marker.label = tostring(marker.slot) .. " - " .. tostring(competitor.name)
        if competitor.previewDimensions then
          marker.bounds = dimensions(competitor.previewDimensions)
          marker.actualBoundsKnown = marker.bounds.actual
        end
      end
    end
  end
  return true
end

-- groundZ: when set, markers keep their planned height (camera anchors fly;
-- the ground does not). Throttled re-validation re-grounds them after drift.
local function place(target, frame, pose, groundZ)
  local fx, fy = frame.forward.x, frame.forward.y
  local rx, ry = fy, -fx
  target.position.x = frame.position.x + fx * pose.longitudinal + rx * pose.lateral
  target.position.y = frame.position.y + fy * pose.longitudinal + ry * pose.lateral
  target.position.z = (groundZ or frame.position.z) + pose.vertical
  target.forward.x = fx * pose.headingForward + rx * pose.headingRight
  target.forward.y = fy * pose.headingForward + ry * pose.headingRight
end

local ZERO_POSE = {longitudinal = 0, lateral = 0, vertical = 0, headingForward = 1, headingRight = 0}

-- frames: {anchor = {position, forward}, player = {position, forward}} read by
-- the caller this frame. Nil frames draw the plan where it was made.
local function placements(preview, frames)
  if type(preview) ~= "table" or preview.enabled ~= true then return {} end
  local list = drawLists[preview]
  if not list then
    list = {}
    for _, marker in ipairs(preview.slots or {}) do
      list[#list + 1] = {
        index = marker.slot, position = {x = 0, y = 0, z = 0}, forward = {x = 0, y = 1, z = 0},
        dimensions = marker.bounds, clearance = marker.clearance, positionStatus = marker.positionStatus,
        label = marker.label, visual = marker.visual, pose = marker.localPose, followsPlayer = marker.followsPlayer,
      }
    end
    drawLists[preview] = list
  end
  frames = type(frames) == "table" and frames or {}
  local anchorFrame = frames.anchor or preview.anchor
  local groundZ = preview.anchor.mode == "camera" and preview.anchor.position.z or nil
  for _, item in ipairs(list) do
    if item.followsPlayer and frames.player then place(item, frames.player, ZERO_POSE)
    else place(item, anchorFrame, item.pose, groundZ) end
  end
  return list
end

-- Distance (m) and yaw change (radians) of a live anchor frame from the frame
-- the plan was validated in; drives throttled re-validation, never per-frame planning.
local function drift(preview, frame)
  if not isDynamic(preview) or type(frame) ~= "table" or type(frame.position) ~= "table" then return 0, 0 end
  local anchor = preview.anchor
  local dx, dy = frame.position.x - anchor.position.x, frame.position.y - anchor.position.y
  local forward = flatUnit(frame.forward, anchor.forward)
  local dot = util.clamp(forward.x * anchor.forward.x + forward.y * anchor.forward.y, -1, 1)
  return math.sqrt(dx * dx + dy * dy), math.acos(dot)
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

-- Serializable snapshot for the UI: no per-frame counters, no draw caches.
local function public(preview)
  if type(preview) ~= "table" then return nil end
  local renderer = preview.renderer or {}
  local slots = {}
  for _, marker in ipairs(preview.slots or {}) do
    slots[#slots + 1] = {
      slot = marker.slot, slotId = marker.slotId, name = marker.name, status = marker.status,
      transform = util.deepCopy(marker.transform), actualBoundsKnown = marker.actualBoundsKnown,
      positionStatus = marker.positionStatus,
    }
  end
  return {
    enabled = preview.enabled == true, state = preview.state, kind = preview.kind,
    formation = preview.formation, heading = preview.heading, quality = preview.quality,
    anchorMode = preview.anchor and preview.anchor.mode, staleReason = preview.staleReason,
    slots = slots,
    renderer = {
      renderedMarkerCount = renderer.renderedMarkerCount or 0,
      requestedMarkerCount = renderer.requestedMarkerCount or 0,
      lastErrorCode = renderer.lastErrorCode, textErrorCode = renderer.textErrorCode,
      missing = util.deepCopy(renderer.missing or {}),
    },
  }
end

M.STATUS_VISUAL = STATUS_VISUAL
M.STATES = STATES
M.build = build
M.update = update
M.placements = placements
M.isDynamic = isDynamic
M.drift = drift
M.recordRender = recordRender
M.recordAnchorUnavailable = recordAnchorUnavailable
M.recordMissingCallback = recordMissingCallback
M.stale = stale
M.clear = clear
M.public = public

return M
