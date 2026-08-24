local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local MODES = {
  Front = true, Behind = true, Left = true, Right = true,
  ["Front Left"] = true, ["Front Right"] = true,
  ["Behind Left"] = true, ["Behind Right"] = true,
  Line = true, Grid = true, Circle = true, Custom = true,
  ["Left of Origin"] = true, ["Right of Origin"] = true,
  ["Split Left and Right"] = true, ["Single File Behind"] = true,
  ["Single File Ahead"] = true, ["Staggered Grid"] = true,
  ["Side-by-side Grid"] = true, ["Circular / Radial"] = true,
  ["Automatic Best Fit"] = true,
}
local MODE_ALIASES = {
  ["Front-left"] = "Front Left", ["Front-right"] = "Front Right",
  ["Back-left"] = "Behind Left", ["Back-right"] = "Behind Right",
  ["Custom point"] = "Custom", ["Left of player/origin"] = "Left of Origin",
  ["Right of player/origin"] = "Right of Origin",
  ["Split left and right"] = "Split Left and Right",
  ["Single file behind"] = "Single File Behind",
  ["Single file ahead"] = "Single File Ahead",
  ["Staggered grid"] = "Staggered Grid",
  ["Side-by-side grid"] = "Side-by-side Grid",
  ["Circular / radial"] = "Circular / Radial",
  ["Automatic best fit"] = "Automatic Best Fit",
}
local HEADING_MODES = {
  camera = true, player = true, road = true, destination = true, custom = true,
}
local HEADING_ALIASES = {
  ["Same as camera"] = "camera", ["Same as player vehicle"] = "player",
  ["Road direction"] = "road", ["Face destination"] = "destination",
  ["Custom yaw"] = "custom",
}

local function offset(mode, index, count, options)
  local spacing = options.spacing
  local lateralSpacing = options.resolvedLateralSpacing or spacing
  local longitudinalSpacing = options.resolvedLongitudinalSpacing or spacing
  if mode == "Left of Origin" then return -lateralSpacing * index, 0 end
  if mode == "Right of Origin" then return lateralSpacing * index, 0 end
  if mode == "Split Left and Right" then
    local rank = math.ceil(index * 0.5)
    return (index % 2 == 1 and -1 or 1) * lateralSpacing * rank, 0
  end
  if mode == "Single File Behind" then return 0, -longitudinalSpacing * index end
  if mode == "Single File Ahead" then return 0, longitudinalSpacing * index end
  if mode == "Staggered Grid" or mode == "Side-by-side Grid" then
    local columns = math.max(1, options.columns)
    local row, column = math.floor((index - 1) / columns), (index - 1) % columns
    local stagger = mode == "Staggered Grid" and row % 2 == 1 and lateralSpacing * 0.5 or 0
    return (column - (columns - 1) * 0.5) * lateralSpacing + stagger,
      (row + 1) * longitudinalSpacing
  end
  if mode == "Circular / Radial" then
    local angle = (index - 1) * math.pi * 2 / count
    return math.cos(angle) * options.radius, math.sin(angle) * options.radius
  end
  if mode == "Front" then return 0, spacing * index end
  if mode == "Behind" then return 0, -spacing * index end
  if mode == "Left" then return -spacing * index, 0 end
  if mode == "Right" then return spacing * index, 0 end
  if mode == "Front Left" then return -spacing * index, spacing * index end
  if mode == "Front Right" then return spacing * index, spacing * index end
  if mode == "Behind Left" then return -spacing * index, -spacing * index end
  if mode == "Behind Right" then return spacing * index, -spacing * index end
  if mode == "Line" then return (index - (count + 1) * 0.5) * lateralSpacing, longitudinalSpacing end
  if mode == "Grid" then
    local columns = math.max(1, options.columns)
    local row, column = math.floor((index - 1) / columns), (index - 1) % columns
    return (column - (columns - 1) * 0.5) * lateralSpacing, (row + 1) * longitudinalSpacing
  end
  if mode == "Circle" then
    local angle = (index - 1) * math.pi * 2 / count
    return math.cos(angle) * options.radius, math.sin(angle) * options.radius
  end
  if mode == "Custom" and type(options.custom) == "table" and type(options.custom[index]) == "table" then
    return tonumber(options.custom[index].x) or 0, tonumber(options.custom[index].y) or 0
  end
  return 0, spacing * index
end

local function normalize(options)
  options = type(options) == "table" and options or {}
  local mode = MODE_ALIASES[options.mode] or options.mode
  local headingMode = HEADING_ALIASES[options.headingMode or options.heading] or options.headingMode or options.heading
  local requestedMode = MODES[mode] and mode or "Grid"
  local spacingMode = options.spacingMode == "automatic" and "automatic" or "manual"
  local dimensions = {}
  local maximumWidth, maximumLength = 2, 4.8
  for index, raw in ipairs(type(options.vehicleDimensions) == "table" and options.vehicleDimensions or {}) do
    local width = util.clamp(tonumber(raw.width) or 2, 0.5, 8)
    local length = util.clamp(tonumber(raw.length) or 4.8, 1, 30)
    dimensions[index] = {width = width, length = length, source = raw.source}
    maximumWidth, maximumLength = math.max(maximumWidth, width), math.max(maximumLength, length)
  end
  local margin = util.clamp(tonumber(options.safetyMargin) or 1.5, 0.25, 10)
  local lateralSpacing = spacingMode == "automatic" and maximumWidth + margin
    or util.clamp(tonumber(options.lateralSpacing or options.spacing) or 6, 2, 40)
  local longitudinalSpacing = spacingMode == "automatic" and maximumLength + margin
    or util.clamp(tonumber(options.longitudinalSpacing or options.spacing) or 6, 3, 60)
  local effectiveMode, fallbackReason = requestedMode, nil
  local availableWidth = tonumber(options.availableWidth)
  local columns = math.max(1, math.min(8, math.floor(tonumber(options.columns) or 2)))
  if requestedMode == "Automatic Best Fit" then
    if util.isFinite(availableWidth) and availableWidth >= lateralSpacing * 2 then
      columns = math.max(2, math.min(columns, math.floor(availableWidth / lateralSpacing)))
      effectiveMode = "Staggered Grid"
    else
      effectiveMode = "Single File Behind"
      fallbackReason = util.isFinite(availableWidth) and "narrow_area_single_file"
        or "available_width_unknown_single_file"
      columns = 1
    end
  elseif (requestedMode == "Grid" or requestedMode == "Staggered Grid"
    or requestedMode == "Side-by-side Grid") and util.isFinite(availableWidth)
  then
    local fittingColumns = math.max(1, math.floor(availableWidth / lateralSpacing))
    if fittingColumns < columns then
      columns = fittingColumns
      fallbackReason = columns == 1 and "narrow_area_single_file" or "columns_reduced_for_available_width"
      if columns == 1 then effectiveMode = "Single File Behind" end
    end
  end
  local normalized = {
    mode = effectiveMode,
    requestedMode = requestedMode,
    fallbackReason = fallbackReason,
    count = math.max(1, math.min(16, math.floor(tonumber(options.count) or 1))),
    spacing = util.clamp(tonumber(options.spacing) or 6, 3, 40),
    spacingMode = spacingMode,
    lateralSpacing = lateralSpacing,
    longitudinalSpacing = longitudinalSpacing,
    resolvedLateralSpacing = lateralSpacing,
    resolvedLongitudinalSpacing = longitudinalSpacing,
    safetyMargin = margin,
    vehicleDimensions = dimensions,
    availableWidth = availableWidth,
    rows = math.max(1, math.min(8, math.floor(tonumber(options.rows) or 2))),
    columns = columns,
    radius = util.clamp(tonumber(options.radius) or 12, 5, 100),
    headingOffset = util.clamp(tonumber(options.headingOffset) or 0, -180, 180),
    groundOffset = util.clamp(tonumber(options.groundOffset) or 0.2, 0, 3),
    maxSlopeDegrees = util.clamp(tonumber(options.maxSlopeDegrees) or 25, 1, 60),
    minimumObjectDistance = util.clamp(tonumber(options.minimumObjectDistance) or 3, 1, 20),
    maxPlacementAttemptsPerSlot = math.max(1, math.min(24,
      math.floor(tonumber(options.maxPlacementAttemptsPerSlot) or 12))),
    maxPlacementDistance = util.clamp(tonumber(options.maxPlacementDistance) or 180, 20, 250),
    maxRejectedSamples = math.max(1, math.min(64,
      math.floor(tonumber(options.maxRejectedSamples) or 16))),
    interval = util.clamp(tonumber(options.interval) or 0.75, 0.25, 10),
    maxConcurrentLoads = 1,
    headingMode = HEADING_MODES[headingMode] and headingMode or "camera",
    destination = util.deepCopy(options.destination),
    spawnAll = options.spawnAll ~= false,
    useNextLineupCompetitor = options.useNextLineupCompetitor ~= false,
    selectedDNAId = type(options.selectedDNAId) == "string" and options.selectedDNAId:sub(1, 128) or nil,
    custom = util.deepCopy(options.custom),
    customPoint = util.deepCopy(options.customPoint),
  }
  if normalized.mode == "Custom" then normalized.count = 1 end
  return normalized
end

-- The first candidate preserves the requested formation exactly. Later
-- candidates expand in deterministic, bounded rings around that ideal point.
-- This keeps the solver reproducible while allowing a nearby obstacle or bad
-- ground sample to be bypassed without turning placement into an open-ended
-- world search.
local function fallbackOffset(attempt, options)
  if attempt <= 1 then return 0, 0 end
  local sequence = attempt - 2
  local ring = math.floor(sequence / 5) + 1
  local phase = sequence % 5
  local lateralStep = math.max(options.minimumObjectDistance,
    options.resolvedLateralSpacing or options.spacing)
  local longitudinalStep = math.max(options.minimumObjectDistance,
    options.resolvedLongitudinalSpacing or options.spacing)
  if phase == 0 then return -ring * lateralStep, (ring - 1) * longitudinalStep * 0.5 end
  if phase == 1 then return ring * lateralStep, (ring - 1) * longitudinalStep * 0.5 end
  if phase == 2 then return 0, ring * longitudinalStep end
  if phase == 3 then return -ring * lateralStep, ring * longitudinalStep end
  return ring * lateralStep, ring * longitudinalStep
end

local function noteRejected(planning, options, index, attempt, lateral, longitudinal, reason, position)
  planning.totalAttempts = planning.totalAttempts + 1
  planning.rejectedCandidates = planning.rejectedCandidates + 1
  planning.rejectionSummary[reason] = (planning.rejectionSummary[reason] or 0) + 1
  if #planning.rejectionSamples < options.maxRejectedSamples then
    planning.rejectionSamples[#planning.rejectionSamples + 1] = {
      slot = index, attempt = attempt, reason = reason,
      lateral = lateral, longitudinal = longitudinal,
      position = util.deepCopy(position),
    }
  end
end

local function planningReport(options)
  return {
    totalAttempts = 0,
    rejectedCandidates = 0,
    selectedCandidates = 0,
    fallbackDepth = 0,
    budgetExhausted = false,
    maxAttemptsPerSlot = options.maxPlacementAttemptsPerSlot,
    maxPlacementDistance = options.maxPlacementDistance,
    maxRejectedSamples = options.maxRejectedSamples,
    rejectionSummary = {},
    rejectionSamples = {},
  }
end

local function flatUnit(value)
  if type(value) ~= "table" then return nil end
  local x, y = tonumber(value.x or value[1]), tonumber(value.y or value[2])
  if not util.isFinite(x) or not util.isFinite(y) then return nil end
  local length = math.sqrt(x * x + y * y)
  if length < 1e-8 then return nil end
  return {x = x / length, y = y / length, z = 0}
end

local function headingVector(frame, options, position)
  local base
  if options.headingMode == "player" then
    base = flatUnit(frame.playerForward)
    if not base then return nil, "player_heading_unavailable" end
  elseif options.headingMode == "road" then
    base = flatUnit(frame.roadForward)
    if not base then return nil, "road_heading_unavailable" end
  elseif options.headingMode == "destination" and type(options.destination) == "table" then
    base = flatUnit({x = (tonumber(options.destination.x) or 0) - position.x, y = (tonumber(options.destination.y) or 0) - position.y})
    if not base then return nil, "destination_heading_unavailable" end
  elseif options.headingMode == "destination" then return nil, "destination_heading_unavailable"
  elseif options.headingMode == "custom" then base = {x = 0, y = 1, z = 0}
  else base = flatUnit(frame.forward)
  end
  if not base then return nil, "camera_heading_invalid" end
  local angle = math.rad(options.headingOffset)
  return {
    x = base.x * math.cos(angle) - base.y * math.sin(angle),
    y = base.x * math.sin(angle) + base.y * math.cos(angle), z = 0,
  }
end

local function plan(frame, options, raycastGround, occupied)
  options = normalize(options)
  if type(frame) ~= "table" or type(frame.position) ~= "table" then return nil, "camera_frame_invalid" end
  if type(frame.right) ~= "table" or type(frame.forward) ~= "table"
    or not util.isFinite(tonumber(frame.position.x)) or not util.isFinite(tonumber(frame.position.y))
    or not util.isFinite(tonumber(frame.position.z))
    or not util.isFinite(tonumber(frame.right.x)) or not util.isFinite(tonumber(frame.right.y))
    or not util.isFinite(tonumber(frame.forward.x)) or not util.isFinite(tonumber(frame.forward.y))
  then return nil, "camera_frame_invalid" end
  if type(raycastGround) ~= "function" then return nil, "ground_raycast_unavailable" end
  local placements = {}
  local planning = planningReport(options)
  for index = 1, options.count do
    local idealLateral, idealLongitudinal = offset(options.mode, index, options.count, options)
    local customPoint = options.mode == "Custom" and type(options.customPoint) == "table"
      and {x = tonumber(options.customPoint.x), y = tonumber(options.customPoint.y), z = tonumber(options.customPoint.z)} or nil
    if options.mode == "Custom" and (not customPoint or not util.isFinite(customPoint.x)
      or not util.isFinite(customPoint.y) or not util.isFinite(customPoint.z))
    then return nil, "custom_point_invalid", planning end
    local selected, lastReason
    local attempts = options.mode == "Custom" and 1 or options.maxPlacementAttemptsPerSlot
    for attempt = 1, attempts do
      local fallbackLateral, fallbackLongitudinal = fallbackOffset(attempt, options)
      local lateral = idealLateral + fallbackLateral
      local longitudinal = idealLongitudinal + fallbackLongitudinal
      local raw = customPoint or {
          x = frame.position.x + frame.right.x * lateral + frame.forward.x * longitudinal,
          y = frame.position.y + frame.right.y * lateral + frame.forward.y * longitudinal,
          z = frame.position.z,
        }
      local distance = math.sqrt(lateral * lateral + longitudinal * longitudinal)
      local reason, position, ground
      if distance > options.maxPlacementDistance then
        reason = "outside_supported_area"
      else
        local okGround, groundOrReason = raycastGround(raw)
        if not okGround or type(groundOrReason) ~= "table"
          or type(groundOrReason.point) ~= "table" or type(groundOrReason.normal) ~= "table"
          or not util.isFinite(tonumber(groundOrReason.point.x))
          or not util.isFinite(tonumber(groundOrReason.point.y))
          or not util.isFinite(tonumber(groundOrReason.point.z))
          or not util.isFinite(tonumber(groundOrReason.normal.z))
        then
          reason = type(groundOrReason) == "string" and groundOrReason or "ground_not_found"
        else
          ground = groundOrReason
          if math.abs(ground.point.z - frame.position.z) > 250 then
            reason = "outside_supported_area"
          elseif ground.normal.z < math.cos(math.rad(options.maxSlopeDegrees)) then
            reason = "slope_too_high"
          else
            position = {x = ground.point.x, y = ground.point.y,
              z = ground.point.z + options.groundOffset}
            for _, existing in ipairs(type(occupied) == "table" and occupied or {}) do
              local dx = position.x - (tonumber(existing.x) or position.x)
              local dy = position.y - (tonumber(existing.y) or position.y)
              local clearance = math.max(options.minimumObjectDistance,
                tonumber(existing.radius) or 0, options.spacing * 0.6)
              if dx * dx + dy * dy < clearance * clearance then
                reason = "position_blocked"
                break
              end
            end
            if not reason then
              for _, existing in ipairs(placements) do
                local dx, dy = position.x - existing.position.x, position.y - existing.position.y
                if dx * dx + dy * dy < options.spacing * options.spacing * 0.36 then
                  reason = "position_blocked"
                  break
                end
              end
            end
          end
        end
      end
      if reason then
        lastReason = reason
        noteRejected(planning, options, index, attempt, lateral, longitudinal, reason, position or raw)
      else
        local forward, headingReason = headingVector(frame, options, position)
        if not forward then return nil, headingReason, planning end
        planning.totalAttempts = planning.totalAttempts + 1
        planning.selectedCandidates = planning.selectedCandidates + 1
        planning.fallbackDepth = math.max(planning.fallbackDepth, attempt - 1)
        selected = {
          index = index, position = position, normal = ground.normal,
          forward = forward, attempt = attempt, fallbackDepth = attempt - 1,
          dimensions = util.deepCopy(options.vehicleDimensions[index]
            or {width = 2, length = 4.8}),
        }
        break
      end
    end
    if not selected then
      planning.budgetExhausted = true
      planning.failedSlot = index
      planning.failureReason = planning.rejectionSummary.position_blocked and "position_blocked"
        or lastReason or "placement_budget_exhausted"
      return nil, planning.failureReason, planning
    end
    placements[#placements + 1] = selected
  end
  return {options = options, placements = placements, planning = planning,
    cursor = 1, active = false, nextAt = 0, spawned = {}, failures = {}}
end

M.MODES = MODES
M.HEADING_MODES = HEADING_MODES
M.normalize = normalize
M.plan = plan
M.headingVector = headingVector

return M
