-- Read-only world-space preview renderer.
--
-- Engine bindings are always injected by the GE caller; this module never reads
-- globals. BeamNG exposes ColorF/ColorI as C++ (LuaIntf) classes, i.e. callable
-- tables or userdata rather than Lua functions, so availability is proven by a
-- one-time probe that actually calls each binding instead of checking type().
local M = {}

local PALETTE = {
  player = {0.2, 0.7, 1}, planned = {0.7, 0.7, 0.7}, generating = {1, 0.72, 0.12},
  ready = {0.2, 0.9, 0.35}, ready_with_warnings = {0.95, 0.65, 0.15}, failed = {1, 0.2, 0.2},
}
local POSITION_SYMBOLS = {valid = "[OK]", tight = "[!]", blocked = "[X]", unknown = "[?]"}
local GENERATION_SYMBOLS = {
  player = "[P]", planned = "[.]", generating = "[~]",
  ready = "[OK]", ready_with_warnings = "[!]", failed = "[X]",
}

-- Colors are immutable engine values; allocate each one once per binding set.
local colorCache = setmetatable({}, {__mode = "k"})

local function probe(deps)
  deps = type(deps) == "table" and deps or {}
  local drawer = deps.debugDrawer
  local function method(name)
    if drawer == nil then return false end
    local ok, value = pcall(function() return drawer[name] end)
    return ok and value ~= nil
  end
  local result = {
    debugDrawer = drawer ~= nil,
    ColorF = pcall(deps.ColorF, 1, 1, 1, 1),
    ColorI = pcall(deps.ColorI, 0, 0, 0, 255),
    vec3 = pcall(deps.vec3, 0, 0, 0),
    drawSphere = method("drawSphere"),
    drawLine = method("drawLine"),
    drawTextAdvanced = method("drawTextAdvanced"),
  }
  result.missing = {}
  for _, name in ipairs({"debugDrawer", "ColorF", "vec3", "drawSphere", "drawLine", "ColorI", "drawTextAdvanced"}) do
    if result[name] ~= true then result.missing[#result.missing + 1] = name end
  end
  result.errorCode = not result.debugDrawer and "preview_debug_drawer_missing"
    or not result.ColorF and "preview_color_api_missing"
    or not result.vec3 and "preview_vector_api_missing"
    or not (result.drawSphere and result.drawLine) and "preview_draw_method_missing"
    or nil
  -- Text is optional: geometry markers remain usable without ColorI or text.
  result.textAvailable = result.ColorI and result.drawTextAdvanced
  result.available = result.errorCode == nil
  return result
end

local function colors(deps, visual)
  local cache = colorCache[deps]
  if not cache then cache = {}; colorCache[deps] = cache end
  local key = PALETTE[visual] and visual or "planned"
  local entry = cache[key]
  if not entry then
    local rgb = PALETTE[key]
    entry = {
      solid = deps.ColorF(rgb[1], rgb[2], rgb[3], 0.8),
      margin = deps.ColorF(rgb[1], rgb[2], rgb[3], 0.35),
    }
    cache[key] = entry
  end
  return entry
end

local function drawMarker(deps, placement, color)
  local drawer, vec3 = deps.debugDrawer, deps.vec3
  local origin = placement.position
  local forward = placement.forward or {x = 0, y = 1, z = 0}
  local width = tonumber(placement.dimensions and placement.dimensions.width) or 2
  local length = tonumber(placement.dimensions and placement.dimensions.length) or 4.8
  local fx, fy = tonumber(forward.x) or 0, tonumber(forward.y) or 1
  local magnitude = math.max(0.0001, math.sqrt(fx * fx + fy * fy))
  fx, fy = fx / magnitude, fy / magnitude
  local rx, ry = fy, -fx
  local function point(longitudinal, lateral, z)
    return vec3(origin.x + fx * longitudinal + rx * lateral,
      origin.y + fy * longitudinal + ry * lateral, origin.z + (z or 0.1))
  end
  local function box(halfLength, halfWidth, boxColor)
    local a, b = point(halfLength, halfWidth), point(halfLength, -halfWidth)
    local c, d = point(-halfLength, -halfWidth), point(-halfLength, halfWidth)
    drawer:drawLine(a, b, boxColor); drawer:drawLine(b, c, boxColor)
    drawer:drawLine(c, d, boxColor); drawer:drawLine(d, a, boxColor)
  end
  local center = vec3(origin.x, origin.y, origin.z)
  -- Order matters: the cheapest, most important primitives are drawn first.
  drawer:drawSphere(center, 0.35, color.solid)
  drawer:drawLine(center, point(length * 0.65, 0, 0.25), color.solid)
  box(length * 0.5, width * 0.5, color.solid)
  local clearance = math.max(0, tonumber(placement.clearance) or 0)
  if clearance > 0 then box(length * 0.5 + clearance, width * 0.5 + clearance, color.margin) end
  return point
end

local function draw(placements, deps, probeResult)
  placements = type(placements) == "table" and placements or {}
  deps = type(deps) == "table" and deps or {}
  probeResult = type(probeResult) == "table" and probeResult or probe(deps)
  local report = {
    rendererAvailable = probeResult.available == true,
    requestedMarkerCount = #placements, renderedMarkerCount = 0,
    errorCode = nil, errorMessage = nil, textErrorCode = nil,
    missing = probeResult.missing,
  }
  if not report.rendererAvailable then
    report.errorCode = probeResult.errorCode or "preview_draw_method_missing"
    report.errorMessage = "Missing preview binding: " .. table.concat(probeResult.missing or {}, ", ")
    return false, report
  end
  for _, placement in ipairs(placements) do
    local color
    local worked, pointOrFailure = pcall(function()
      color = colors(deps, placement.visual)
      return drawMarker(deps, placement, color)
    end)
    if worked then
      report.renderedMarkerCount = report.renderedMarkerCount + 1
      if probeResult.textAvailable and type(placement.label) == "string" then
        local symbol = POSITION_SYMBOLS[placement.positionStatus]
          or GENERATION_SYMBOLS[placement.visual] or "[.]"
        local textWorked = pcall(function()
          deps.debugDrawer:drawTextAdvanced(pointOrFailure(0, 0, 1.2), symbol .. " " .. placement.label,
            color.solid, true, false, deps.ColorI(0, 0, 0, 210))
        end)
        if not textWorked then report.textErrorCode = "preview_text_draw_failed" end
      end
    else
      report.errorCode, report.errorMessage = "preview_marker_draw_failed", tostring(pointOrFailure)
    end
  end
  if report.renderedMarkerCount == 0 then
    report.errorCode = report.errorCode or "preview_render_empty"
    report.errorMessage = report.errorMessage or "No preview marker was drawn"
    return false, report
  end
  return true, report
end

-- Minimal single-sphere primitive shared by the AI destination marker so there
-- is exactly one place that talks to debugDrawer.
local function drawPoint(point, deps, probeResult, radius, rgba)
  if type(point) ~= "table" or type(probeResult) ~= "table" or probeResult.available ~= true then
    return false
  end
  return (pcall(function()
    deps.debugDrawer:drawSphere(deps.vec3(point.x, point.y, point.z), radius or 1,
      deps.ColorF(rgba[1], rgba[2], rgba[3], rgba[4]))
  end))
end

M.probe = probe
M.draw = draw
M.drawPoint = drawPoint

return M
