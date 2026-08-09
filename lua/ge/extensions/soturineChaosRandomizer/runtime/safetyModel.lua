local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

M.RUNTIME_INTEGRITY = {
  HEALTHY = "HEALTHY",
  UNKNOWN_OR_PENDING = "UNKNOWN_OR_PENDING",
  INVALID_CONFIRMED = "INVALID_CONFIRMED",
}

M.DRIVABILITY = {
  DRIVABLE = "DRIVABLE",
  PARTIAL = "PARTIAL",
  UNDRIVABLE = "UNDRIVABLE",
  UNKNOWN = "UNKNOWN",
  NOT_APPLICABLE = "NOT_APPLICABLE",
}

M.CHAOS_ACCEPTANCE = {
  ACCEPT = "ACCEPT",
  ACCEPT_WITH_WARNING = "ACCEPT_WITH_WARNING",
  REJECT_BY_POLICY = "REJECT_BY_POLICY",
}

local function integrity(evidence, validation)
  evidence = type(evidence) == "table" and evidence or {}
  if evidence.objectExists == false then return M.RUNTIME_INTEGRITY.INVALID_CONFIRMED, "object_missing" end
  if evidence.ownershipCurrent == false then return M.RUNTIME_INTEGRITY.INVALID_CONFIRMED, "operation_ownership_lost" end
  if evidence.bindDeadlineExpired == true and evidence.bindConverged ~= true then
    return M.RUNTIME_INTEGRITY.INVALID_CONFIRMED, "bind_deadline_without_convergence"
  end
  if evidence.convergenceDeadlineExpired == true and evidence.treeConverged ~= true then
    return M.RUNTIME_INTEGRITY.INVALID_CONFIRMED, "tree_deadline_without_convergence"
  end
  if evidence.objectExists ~= true or evidence.ownershipCurrent ~= true
    or evidence.bindConverged ~= true or evidence.treeConverged ~= true
  then return M.RUNTIME_INTEGRITY.UNKNOWN_OR_PENDING, "runtime_evidence_pending" end
  if validation and validation.decision == "UNKNOWN_OR_PENDING" then
    return M.RUNTIME_INTEGRITY.UNKNOWN_OR_PENDING, validation.reason or "validation_evidence_pending"
  end
  return M.RUNTIME_INTEGRITY.HEALTHY, "runtime_identity_and_tree_converged"
end

local function drivability(validation)
  validation = type(validation) == "table" and validation or {}
  local classification = tostring(validation.classification or "unknown")
  if classification == "prop" or classification == "trailer" then
    return M.DRIVABILITY.NOT_APPLICABLE, "non_drivable_profile"
  end
  if validation.decision == "UNKNOWN_OR_PENDING" or validation.valid == nil then
    return M.DRIVABILITY.UNKNOWN, validation.reason or "drivability_evidence_pending"
  end
  if validation.valid == false or #(validation.failures or {}) > 0 then
    return M.DRIVABILITY.UNDRIVABLE, "functional_evidence_missing"
  end
  if #(validation.warnings or {}) > 0 or #(validation.missingParts or {}) > 0
    or classification == "intentional_non_drivable_shell"
  then return M.DRIVABILITY.PARTIAL, "functional_warnings_present" end
  if classification == "unknown" then return M.DRIVABILITY.UNKNOWN, "classification_unknown" end
  return M.DRIVABILITY.DRIVABLE, "functional_evidence_present"
end

local function acceptance(runtimeIntegrity, vehicleDrivability, policy)
  policy = type(policy) == "table" and policy or {}
  if runtimeIntegrity == M.RUNTIME_INTEGRITY.INVALID_CONFIRMED then
    return M.CHAOS_ACCEPTANCE.REJECT_BY_POLICY, "runtime_integrity_invalid"
  end
  if runtimeIntegrity == M.RUNTIME_INTEGRITY.UNKNOWN_OR_PENDING then
    return M.CHAOS_ACCEPTANCE.REJECT_BY_POLICY, "runtime_integrity_pending"
  end
  if vehicleDrivability == M.DRIVABILITY.DRIVABLE
    or vehicleDrivability == M.DRIVABILITY.NOT_APPLICABLE
  then return M.CHAOS_ACCEPTANCE.ACCEPT, "policy_requirements_satisfied" end
  local permissive = policy.allowMissingParts == true or policy.allowPartialResult == true
    or tonumber(policy.chaos or policy.slider) == 100 or policy.maximumChaos == true
  if permissive then
    return M.CHAOS_ACCEPTANCE.ACCEPT_WITH_WARNING, "permissive_chaos_policy"
  end
  if vehicleDrivability == M.DRIVABILITY.UNKNOWN and policy.protectCriticalParts ~= true then
    return M.CHAOS_ACCEPTANCE.ACCEPT_WITH_WARNING, "unknown_drivability_non_strict_policy"
  end
  return M.CHAOS_ACCEPTANCE.REJECT_BY_POLICY, "strict_drivability_policy"
end

local function layer(validation, policy, evidence)
  validation = util.deepCopy(type(validation) == "table" and validation or {})
  local originalValid = validation.valid
  local runtimeIntegrity, integrityReason = integrity(evidence, validation)
  local vehicleDrivability, drivabilityReason = drivability(validation)
  local chaosAcceptance, acceptanceReason = acceptance(runtimeIntegrity, vehicleDrivability, policy)
  if runtimeIntegrity == M.RUNTIME_INTEGRITY.HEALTHY and originalValid == true then
    local warned = #(validation.warnings or {}) > 0 or validation.status == "uncertain"
      or vehicleDrivability == M.DRIVABILITY.PARTIAL
    chaosAcceptance = warned and M.CHAOS_ACCEPTANCE.ACCEPT_WITH_WARNING
      or M.CHAOS_ACCEPTANCE.ACCEPT
    acceptanceReason = warned and "validated_result_with_warnings" or "validated_result"
  end
  validation.runtimeIntegrity = runtimeIntegrity
  validation.drivability = vehicleDrivability
  validation.chaosAcceptance = chaosAcceptance
  validation.safetyReasons = {
    integrity = integrityReason,
    drivability = drivabilityReason,
    acceptance = acceptanceReason,
  }
  validation.destructiveRollbackAuthorized = runtimeIntegrity == M.RUNTIME_INTEGRITY.INVALID_CONFIRMED
  if runtimeIntegrity == M.RUNTIME_INTEGRITY.INVALID_CONFIRMED then
    validation.decision, validation.valid = "INVALID_CONFIRMED", false
  elseif runtimeIntegrity == M.RUNTIME_INTEGRITY.UNKNOWN_OR_PENDING then
    validation.decision, validation.valid = "UNKNOWN_OR_PENDING", nil
  elseif runtimeIntegrity == M.RUNTIME_INTEGRITY.HEALTHY then
    -- Functional/metadata validation is not runtime integrity. A stable odd
    -- vehicle can be accepted by chaos policy, while a strict policy can
    -- reject it without authorizing destructive rollback.
    validation.decision, validation.valid = "VALID", true
    if chaosAcceptance == M.CHAOS_ACCEPTANCE.ACCEPT_WITH_WARNING then
      validation.status = "accepted_with_warning"
    elseif chaosAcceptance == M.CHAOS_ACCEPTANCE.REJECT_BY_POLICY then
      validation.status = "rejected_by_policy"
    end
  end
  return validation
end

M.integrity = integrity
M.drivability = drivability
M.acceptance = acceptance
M.layer = layer

return M
