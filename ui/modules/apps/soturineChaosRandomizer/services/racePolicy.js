// Race candidate policy. Fixed presets are backend-owned templates published in
// state.lineup.presetPolicies; Custom keeps its own persisted customPolicy.
export const RACE_PRESETS = Object.freeze(["Balanced", "Maximum Chaos", "Mods Showcase", "Custom"])

export const effectivePolicy = (options, presetPolicies) => {
  if (options?.preset === "Custom") return options?.customPolicy || {}
  return presetPolicies?.[options?.preset] || {}
}

export const policyConflict = policy => policy?.allowOfficialVehicles === false && policy?.allowModVehicles === false

// Editing any policy field starts from what is currently in effect and makes
// the selection explicitly Custom; the fixed template itself never changes.
export const customizedPolicy = (options, presetPolicies, field, value) => ({
  ...effectivePolicy(options, presetPolicies),
  [field]: value,
})
