local M = {}

local PALETTE = {
  player = {0.2, 0.7, 1}, planned = {0.7, 0.7, 0.7}, generating = {1, 0.72, 0.12},
  ready = {0.2, 0.9, 0.35}, ready_with_warnings = {0.95, 0.65, 0.15}, failed = {1, 0.2, 0.2},
}

local function draw(placements, environment)
  placements = type(placements) == "table" and placements or {}
  environment = type(environment) == "table" and environment or _G
  local drawer = environment.debugDrawer
  local colorF = environment.ColorF
  local colorI = environment.ColorI
  local vectorFactory = environment.vec3
  local function vector(value)
    if type(vectorFactory) == "function" then return vectorFactory(value.x, value.y, value.z) end
    return {value.x, value.y, value.z}
  end
  local report = {
    rendererAvailable = drawer ~= nil and type(colorF) == "function",
    requestedMarkerCount = #placements, renderedMarkerCount = 0,
    errorCode = nil, errorMessage = nil,
  }
  if not report.rendererAvailable then
    report.errorCode = "preview_renderer_unavailable"
    report.errorMessage = "The world debug renderer is unavailable"
    return false, report
  end
  for _, placement in ipairs(placements) do
    local worked, failure = pcall(function()
      local rgb = PALETTE[placement.visual] or PALETTE.planned
      local color = colorF(rgb[1], rgb[2], rgb[3], 0.8)
      local marginColor = colorF(rgb[1], rgb[2], rgb[3], 0.35)
      local position = vector(placement.position)
      local forward = placement.forward or {x = 0, y = 1, z = 0}
      local width = tonumber(placement.dimensions and placement.dimensions.width) or 2
      local length = tonumber(placement.dimensions and placement.dimensions.length) or 4.8
      local fx, fy = tonumber(forward.x) or 0, tonumber(forward.y) or 1
      local magnitude = math.max(0.0001, math.sqrt(fx * fx + fy * fy))
      fx, fy = fx / magnitude, fy / magnitude
      local rx, ry = fy, -fx
      local function point(longitudinal, lateral, z)
        return vector({
          x = placement.position.x + fx * longitudinal + rx * lateral,
          y = placement.position.y + fy * longitudinal + ry * lateral,
          z = placement.position.z + (z or 0.1),
        })
      end
      local a, b = point(length * 0.5, width * 0.5), point(length * 0.5, -width * 0.5)
      local c, d = point(-length * 0.5, -width * 0.5), point(-length * 0.5, width * 0.5)
      local clearance = math.max(0, tonumber(placement.clearance) or 0)
      local marginLength, marginWidth = length * 0.5 + clearance, width * 0.5 + clearance
      local ma, mb = point(marginLength, marginWidth), point(marginLength, -marginWidth)
      local mc, md = point(-marginLength, -marginWidth), point(-marginLength, marginWidth)
      drawer:drawSphere(position, 0.35, color)
      drawer:drawLine(a, b, color); drawer:drawLine(b, c, color)
      drawer:drawLine(c, d, color); drawer:drawLine(d, a, color)
      drawer:drawLine(ma, mb, marginColor); drawer:drawLine(mb, mc, marginColor)
      drawer:drawLine(mc, md, marginColor); drawer:drawLine(md, ma, marginColor)
      drawer:drawLine(position, point(length * 0.65, 0, 0.25), color)
      if type(placement.label) == "string" and type(colorI) == "function" then
        local positionSymbols = {valid = "[OK]", tight = "[!]", blocked = "[X]", unknown = "[?]"}
        local generationSymbols = {player = "[P]", planned = "[.]", generating = "[~]",
          ready = "[OK]", ready_with_warnings = "[!]", failed = "[X]"}
        local symbol = positionSymbols[placement.positionStatus]
          or generationSymbols[placement.visual] or "[.]"
        drawer:drawTextAdvanced(point(0, 0, 1.2), symbol .. " " .. placement.label, color,
          true, false, colorI(0, 0, 0, 210), false, true)
      end
    end)
    if worked then report.renderedMarkerCount = report.renderedMarkerCount + 1
    else report.errorCode, report.errorMessage = "preview_marker_render_failed", tostring(failure) end
  end
  if report.renderedMarkerCount == 0 and report.requestedMarkerCount > 0 then
    report.errorCode = report.errorCode or "preview_render_empty"
    report.errorMessage = report.errorMessage or "No preview marker was drawn"
    return false, report
  end
  return report.renderedMarkerCount > 0, report
end

M.draw = draw

return M
