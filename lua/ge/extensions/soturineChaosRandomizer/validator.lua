local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local ROLE_ORDER = {
  "structure",
  "energy_electric",
  "energy_fuel",
  "energy_other",
  "propulsion_electric",
  "propulsion_combustion",
  "propulsion_other",
  "power_path",
  "transmission",
  "transfer",
  "differential",
  "driven_axle",
  "steering",
  "suspension",
  "hub",
  "wheel",
  "tire_contact",
  "braking",
  "control",
  "attachment",
}

local POWERTRAIN_TYPES = {
  combustionengine = "propulsion_combustion",
  combustionEngine = "propulsion_combustion",
  electricmotor = "propulsion_electric",
  electricMotor = "propulsion_electric",
  motor = "propulsion_other",
  manualgearbox = "transmission",
  automaticgearbox = "transmission",
  cvtgearbox = "transmission",
  dctgearbox = "transmission",
  sequentialgearbox = "transmission",
  gearbox = "transmission",
  transmission = "transmission",
  transfercase = "transfer",
  shaft = "transfer",
  driveshaft = "transfer",
  differential = "differential",
}

local ENERGY_TYPES = {
  electricbattery = "energy_electric",
  battery = "energy_electric",
  fueltank = "energy_fuel",
  fuelcell = "energy_fuel",
  n2otank = "energy_other",
}

local FALLBACK_TOKENS = {
  body = "structure",
  frame = "structure",
  unibody = "structure",
  energy = "energy_other",
  battery = "energy_electric",
  fuel = "energy_fuel",
  tank = "energy_fuel",
  engine = "propulsion_combustion",
  motor = "propulsion_other",
  powertrain = "power_path",
  transmission = "transmission",
  gearbox = "transmission",
  transfer = "transfer",
  differential = "differential",
  axle = "driven_axle",
  steering = "steering",
  suspension = "suspension",
  hub = "hub",
  wheel = "wheel",
  tire = "tire_contact",
  brake = "braking",
  brakes = "braking",
  seat = "control",
  tow = "attachment",
  hitch = "attachment",
}

local function roleSet(values)
  local result = {}
  if type(values) == "table" then
    for key, value in pairs(values) do
      if type(key) == "number" then result[value] = true elseif value == true then result[key] = true end
    end
  end
  return result
end

local function roleList(values)
  local source = roleSet(values)
  local result = {}
  for _, role in ipairs(ROLE_ORDER) do if source[role] then result[#result + 1] = role end end
  for _, role in ipairs(util.sortedKeys(source)) do
    if not util.arrayContains(result, role) then result[#result + 1] = role end
  end
  return result
end

local function normalizeType(value)
  return util.normalizeText(value):gsub("[^a-z0-9]", "")
end

local function valuesFromSection(section)
  local result = {}
  if type(section) ~= "table" then return result end
  for key, value in pairs(section) do
    if type(value) == "table" and (type(key) ~= "number" or key > 1) then result[#result + 1] = value end
  end
  return result
end

local function evidenceFromPart(part)
  part = type(part) == "table" and part or {}
  local roles = {}
  local evidence = {}
  local function add(role, source, value)
    if role then
      roles[role] = true
      evidence[#evidence + 1] = {role = role, source = source, value = value}
    end
  end

  local powertrain = valuesFromSection(part.powertrain)
  if #powertrain > 0 then add("power_path", "part.powertrain", "present") end
  for _, device in ipairs(powertrain) do
    local deviceType = normalizeType(device.type or device.deviceType)
    add(POWERTRAIN_TYPES[deviceType], "part.powertrain.type", device.type or device.deviceType)
  end
  for _, storage in ipairs(valuesFromSection(part.energyStorage)) do
    local storageType = normalizeType(storage.type or storage.storageType)
    add(ENERGY_TYPES[storageType] or "energy_other", "part.energyStorage.type", storage.type or storage.storageType)
  end
  if type(part.brakes) == "table" then add("braking", "part.brakes", "present") end
  if type(part.wheels) == "table" or type(part.pressureWheels) == "table" then
    add("wheel", "part.wheels", "present")
    add("tire_contact", "part.wheels", "present")
  end
  if type(part.hydros) == "table" then add("steering", "part.hydros", "present") end
  if type(part.controller) == "table" then add("control", "part.controller", "present") end

  -- Structural evidence must come from the loaded part, not merely its name.
  -- A part that owns both nodes and beams/flexbodies contributes to the
  -- vehicle's physical structure. Name tokens remain a lower-confidence
  -- fallback for content whose JBeam metadata cannot be read.
  if type(part.nodes) == "table"
    and (type(part.beams) == "table" or type(part.flexbodies) == "table")
  then add("structure", "part.nodes_and_structure", "present") end

  return {roles = roleList(roles), evidence = evidence, heuristic = false}
end

local function fallbackEvidence(slot)
  local roles = {}
  local evidence = {}
  local values = {slot.id, slot.description}
  for _, value in ipairs(slot.allowTypes or {}) do values[#values + 1] = value end
  for _, value in ipairs(values) do
    local text = util.normalizeText(value):gsub("[^a-z0-9]+", " ")
    for token in text:gmatch("%S+") do
      local role = FALLBACK_TOKENS[token]
      if role then
        roles[role] = true
        evidence[#evidence + 1] = {role = role, source = "normalized_slot_fallback", value = token}
      end
    end
  end
  return {roles = roleList(roles), evidence = evidence, heuristic = next(roles) ~= nil}
end

local function selectedEvidence(slot, candidate)
  local metadata = type(slot.candidateMetadata) == "table" and slot.candidateMetadata[candidate or slot.currentPart] or nil
  if type(metadata) == "table" and type(metadata.roles) == "table" and #metadata.roles > 0 then
    return {roles = roleList(metadata.roles), evidence = util.deepCopy(metadata.evidence or {}), heuristic = metadata.heuristic == true}
  end
  if candidate == nil or candidate == slot.currentPart then return fallbackEvidence(slot) end
  return {roles = {}, evidence = {}, heuristic = false}
end

local function isCritical(slot)
  if slot.coreSlot or slot.required then return true, "required_or_core" end
  local evidence = selectedEvidence(slot)
  if #evidence.roles > 0 then return true, evidence.roles[1] end
  return false
end

local function canEmpty(slot, protectCriticalParts)
  if slot.coreSlot or slot.required or slot.depth == 0 then return false, "required_or_core" end
  if protectCriticalParts then
    local evidence = selectedEvidence(slot)
    if #evidence.roles > 0 then return false, "safety_role:" .. evidence.roles[1] end
  end
  return true
end

local function rolesContain(candidateRoles, requiredRoles)
  local candidates = roleSet(candidateRoles)
  for _, role in ipairs(requiredRoles or {}) do if not candidates[role] then return false, role end end
  return true
end

local function validateSelection(slot, candidate, protectCriticalParts)
  if candidate == "" then return canEmpty(slot, protectCriticalParts) end
  if type(candidate) ~= "string" then return false, "invalid_candidate" end
  if not util.arrayContains(slot.candidates, candidate) then return false, "incompatible_candidate" end
  if protectCriticalParts then
    local current = selectedEvidence(slot)
    if #current.roles > 0 then
      local replacement = selectedEvidence(slot, candidate)
      local contains, missingRole = rolesContain(replacement.roles, current.roles)
      if not contains then return false, "safety_evidence_unproven:" .. tostring(missingRole) end
    end
  end
  return true
end

local function protectedSelection(slot, protectCriticalParts)
  if not protectCriticalParts then return nil end
  local current = selectedEvidence(slot)
  if #current.roles == 0 and not slot.required and not slot.coreSlot then return nil end
  if type(slot.currentPart) == "string" and slot.currentPart ~= "" then
    return slot.currentPart, "critical_current_preserved:" .. tostring(current.roles[1] or "required_or_core")
  end
  if type(slot.defaultPart) == "string" and slot.defaultPart ~= ""
    and util.arrayContains(slot.candidates, slot.defaultPart)
  then
    return slot.defaultPart, "critical_default_restored:" .. tostring(current.roles[1] or "required_or_core")
  end
  return slot.currentPart or "", "critical_safe_replacement_unproven:" .. tostring(current.roles[1] or "required_or_core")
end

local function explicitProfile(context, roles)
  context = type(context) == "table" and context or {}
  local itemType = util.normalizeText(context.type or context.Type or context.category or context.Category)
  if context.isProp == true or itemType == "prop" or itemType == "props" then return "prop", "explicit_type" end
  if context.isTrailer == true or itemType == "trailer" then return "trailer", "explicit_type" end
  if context.isAutomation == true or itemType == "automation" then return "automation", "explicit_type" end
  if roles.propulsion_electric and roles.propulsion_combustion then return "hybrid", "loaded_part_metadata" end
  if roles.propulsion_electric or roles.energy_electric then return "electric", "loaded_part_metadata" end
  if itemType == "car" or itemType == "truck" or itemType == "bus" or itemType == "motorcycle" then
    return "standard_road", "explicit_type"
  end
  if itemType ~= "" and itemType ~= "unknown" then return "special", "explicit_type" end
  return "unknown", "insufficient_metadata"
end

local function candidateClassification(context, roles, graph)
  context = type(context) == "table" and context or {}
  roles = type(roles) == "table" and roles or {}
  local itemType = util.normalizeText(context.type or context.Type or context.category or context.Category)
  local configText = util.normalizeText(table.concat({
    tostring(context.configKey or ""), tostring(context.configName or ""),
    tostring(context.description or ""), tostring(context.usage or ""),
  }, " "))
  if context.isProp == true or itemType == "prop" or itemType == "props" then return "prop", "explicit_type" end
  if context.isTrailer == true or itemType == "trailer" then return "trailer", "explicit_type" end
  if context.intentionalNonDrivable == true
    or configText:find("rolling shell", 1, true)
    or configText:find("bare chassis", 1, true)
    or configText:find("display shell", 1, true)
  then return "intentional_non_drivable_shell", "explicit_configuration_metadata" end
  if roles.propulsion_combustion and (roles.propulsion_electric or roles.energy_electric) then
    return "drivable_hybrid", "loaded_part_metadata"
  end
  if roles.propulsion_combustion then return "drivable_combustion", "loaded_part_metadata" end
  if roles.propulsion_electric then return "drivable_electric", "loaded_part_metadata" end
  if graph and graph.slotCount > 0 and (itemType == "car" or itemType == "truck" or itemType == "bus") then
    return "unknown", "road_type_without_propulsion_evidence"
  end
  return "unknown", "insufficient_metadata"
end

local FUNCTIONAL_CORE_ROLES = roleSet({
  "structure", "energy_electric", "energy_fuel", "propulsion_electric",
  "propulsion_combustion", "power_path", "transmission", "transfer",
  "differential", "driven_axle", "steering", "hub", "wheel",
  "tire_contact", "braking", "control",
})

local function nodeHasFunctionalCore(node)
  if type(node) ~= "table" or node.heuristic == true then return false end
  for _, role in ipairs(node.roles or {}) do if FUNCTIONAL_CORE_ROLES[role] then return true end end
  return false
end

local function buildGraph(scan, context, options)
  options = type(options) == "table" and options or {}
  local graph = {
    nodes = {},
    edges = {},
    roles = {},
    requiredRoles = {},
    missingRequired = {},
    missingParts = {},
    heuristicPaths = {},
    slotCount = 0,
    candidateCount = 0,
    maxDepth = 0,
    roleEvidence = {},
  }
  for _, slot in ipairs(type(scan) == "table" and scan.slots or {}) do
    local selected = selectedEvidence(slot)
    local node = {
      path = slot.path,
      parentPath = slot.parentPath,
      part = slot.currentPart,
      required = slot.required == true,
      coreSlot = slot.coreSlot == true,
      declaredRequired = slot.declaredRequired == true,
      roles = util.deepCopy(selected.roles),
      evidence = util.deepCopy(selected.evidence),
      heuristic = selected.heuristic,
    }
    graph.nodes[slot.path] = node
    graph.slotCount = graph.slotCount + 1
    graph.candidateCount = graph.candidateCount + #(slot.candidates or {})
    graph.maxDepth = math.max(graph.maxDepth, tonumber(slot.depth) or 0)
    if slot.parentPath then graph.edges[#graph.edges + 1] = {from = slot.parentPath, to = slot.path, kind = "slot_parent"} end
    if slot.currentPart == nil or slot.currentPart == "" then
      local classification = (slot.coreSlot or slot.required) and "core_infrastructure_missing"
        or slot.declaredRequired and "mod_metadata_required_unproven"
        or options.allowMissingParts == true and "optional_missing_allowed"
        or "optional_missing"
      local missing = {
        slotPath = slot.path, classification = classification,
        fatal = classification == "core_infrastructure_missing",
      }
      graph.missingParts[#graph.missingParts + 1] = missing
      if missing.fatal then graph.missingRequired[#graph.missingRequired + 1] = slot.path end
    end
    for _, role in ipairs(selected.roles) do
      graph.roles[role] = (graph.roles[role] or 0) + 1
      graph.roleEvidence[role] = graph.roleEvidence[role] or {structural = 0, heuristic = 0}
      if selected.heuristic then graph.roleEvidence[role].heuristic = graph.roleEvidence[role].heuristic + 1
      else graph.roleEvidence[role].structural = graph.roleEvidence[role].structural + 1 end
      if slot.required or slot.coreSlot then graph.requiredRoles[role] = (graph.requiredRoles[role] or 0) + 1 end
    end
    if selected.heuristic then graph.heuristicPaths[#graph.heuristicPaths + 1] = slot.path end
  end
  local rolePresence = {}
  for role, count in pairs(graph.roles) do rolePresence[role] = count > 0 end
  graph.profile, graph.profileStrategy = explicitProfile(context, rolePresence)
  graph.classification, graph.classificationStrategy = candidateClassification(context, rolePresence, graph)
  return graph
end

local function applicableRoles(profile)
  if profile == "trailer" or profile == "prop" then return {} end
  if profile == "electric" then return {"energy_electric", "propulsion_electric", "power_path"} end
  if profile == "hybrid" then
    return {"energy_electric", "energy_fuel", "propulsion_electric", "propulsion_combustion", "power_path"}
  end
  return {"energy_fuel", "energy_electric", "propulsion_combustion", "propulsion_electric", "power_path"}
end

local function validateGraph(graph, baseline, protectCriticalParts)
  graph = type(graph) == "table" and graph or {}
  baseline = type(baseline) == "table" and baseline or graph
  local failures = {}
  local warnings = {}
  for _, path in ipairs(graph.missingRequired or {}) do
    failures[#failures + 1] = {slotPath = path, reason = "core_infrastructure_missing"}
  end
  for _, missing in ipairs(graph.missingParts or {}) do
    if missing.fatal ~= true then
      warnings[#warnings + 1] = {
        slotPath = missing.slotPath, reason = missing.classification,
      }
    end
  end
  for _, role in ipairs(util.sortedKeys(baseline.requiredRoles or {})) do
    local requiredCount = baseline.requiredRoles[role]
    if (graph.roles and graph.roles[role] or 0) < requiredCount then
      failures[#failures + 1] = {reason = "required_role_missing:" .. role, role = role, expected = requiredCount}
    end
  end
  if protectCriticalParts then
    -- Protect exact, evidence-backed functional paths before comparing coarse
    -- aggregate roles. This gives repair code a concrete slot/dependency chain
    -- and prevents Allow Missing Parts from winning over critical protection.
    for _, path in ipairs(util.sortedKeys(baseline.nodes or {})) do
      local expectedNode = baseline.nodes[path]
      local currentNode = graph.nodes and graph.nodes[path] or nil
      local pathRequired = expectedNode.coreSlot == true or expectedNode.required == true
        or expectedNode.declaredRequired == true or nodeHasFunctionalCore(expectedNode)
      if pathRequired and type(expectedNode.part) == "string" and expectedNode.part ~= "" then
        if not currentNode or type(currentNode.part) ~= "string" or currentNode.part == "" then
          failures[#failures + 1] = {
            slotPath = path, reason = "protected_functional_slot_missing",
            expectedPart = expectedNode.part, roles = util.deepCopy(expectedNode.roles or {}),
            dependencyPath = expectedNode.parentPath,
          }
        elseif nodeHasFunctionalCore(expectedNode) then
          local contains, missingRole = rolesContain(currentNode.roles, expectedNode.roles)
          if not contains then
            failures[#failures + 1] = {
              slotPath = path, reason = "protected_functional_evidence_lost:" .. tostring(missingRole),
              role = missingRole, expectedPart = expectedNode.part, currentPart = currentNode.part,
              dependencyPath = expectedNode.parentPath,
            }
          end
        end
      end
    end
    for _, role in ipairs(applicableRoles(baseline.profile)) do
      local expected = baseline.roles and baseline.roles[role] or 0
      local structural = baseline.roleEvidence and baseline.roleEvidence[role]
        and baseline.roleEvidence[role].structural or 0
      local legacyExplicitEvidence = baseline.roleEvidence == nil
      if expected > 0 and (structural > 0 or legacyExplicitEvidence)
        and (graph.roles and graph.roles[role] or 0) <= 0
      then
        failures[#failures + 1] = {reason = "baseline_safety_role_lost:" .. role, role = role}
      end
    end
  end
  if #failures > 0 then
    return {status = "unsafe", valid = false, profile = baseline.profile,
      classification = baseline.classification or graph.classification, failures = failures,
      warnings = warnings, missingParts = util.deepCopy(graph.missingParts or {})}
  end
  if baseline.profile == "prop" then
    return {status = "not_applicable", valid = true, profile = baseline.profile,
      classification = baseline.classification or graph.classification, failures = {},
      warnings = warnings, missingParts = util.deepCopy(graph.missingParts or {})}
  end
  if baseline.profile == "unknown" or baseline.profile == "special" then
    return {status = "uncertain", valid = true, profile = baseline.profile,
      classification = baseline.classification or graph.classification, failures = {}, reason = "insufficient_profile_evidence",
      warnings = warnings, missingParts = util.deepCopy(graph.missingParts or {})}
  end
  if baseline.profile == "standard_road" or baseline.profile == "automation" then
    local applicableEvidence = 0
    for _, role in ipairs(applicableRoles(baseline.profile)) do
      applicableEvidence = applicableEvidence + (baseline.roles and baseline.roles[role] or 0)
    end
    if applicableEvidence == 0 then
      return {status = "uncertain", valid = true, profile = baseline.profile,
        classification = baseline.classification or graph.classification, failures = {}, reason = "insufficient_functional_evidence",
        warnings = warnings, missingParts = util.deepCopy(graph.missingParts or {})}
    end
  end
  local hasUnprovenMetadata = false
  for _, warning in ipairs(warnings) do
    if warning.reason == "mod_metadata_required_unproven" then hasUnprovenMetadata = true; break end
  end
  return {status = hasUnprovenMetadata and "uncertain" or "safe", valid = true,
    profile = baseline.profile, classification = baseline.classification or graph.classification,
    failures = {}, warnings = warnings,
    reason = hasUnprovenMetadata and "mod_metadata_incomplete" or nil,
    missingParts = util.deepCopy(graph.missingParts or {})}
end

local function validateProtectedScan(scan, protectCriticalParts, context, baseline, options)
  local graph = buildGraph(scan, context, options)
  local result = validateGraph(graph, baseline or graph, protectCriticalParts)
  return result.valid, result.failures, result, graph
end

M.roleOrder = ROLE_ORDER
M.evidenceFromPart = evidenceFromPart
M.selectedEvidence = selectedEvidence
M.isCritical = isCritical
M.canEmpty = canEmpty
M.validateSelection = validateSelection
M.protectedSelection = protectedSelection
M.validateProtectedScan = validateProtectedScan
M.buildGraph = buildGraph
M.validateGraph = validateGraph
M.candidateClassification = candidateClassification
M.nodeHasFunctionalCore = nodeHasFunctionalCore

return M
