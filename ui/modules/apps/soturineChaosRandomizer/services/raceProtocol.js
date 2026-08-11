export const RACE_FORMATION_CODES = Object.freeze([
  "AUTO_BEST_FIT", "GRID", "LINE", "SIDE_BY_SIDE_GRID", "STAGGERED_GRID",
  "SPLIT_LEFT_RIGHT", "SINGLE_FILE_BEHIND", "SINGLE_FILE_AHEAD", "RADIAL",
])

export const PREVIEW_ORIGIN_CODES = Object.freeze([
  "automatic", "player_front", "player_behind", "camera", "custom",
])

export const HEADING_MODE_CODES = Object.freeze(["camera", "player", "road", "destination"])
export const PLACEMENT_HEADING_MODE_CODES = Object.freeze([...HEADING_MODE_CODES, "custom"])
export const SPACING_MODE_CODES = Object.freeze(["automatic", "manual"])

const FORMATION_RUNTIME_NAMES = Object.freeze({
  AUTO_BEST_FIT: "Automatic Best Fit",
  GRID: "Grid",
  LINE: "Line",
  SIDE_BY_SIDE_GRID: "Side-by-side Grid",
  STAGGERED_GRID: "Staggered Grid",
  SPLIT_LEFT_RIGHT: "Split Left and Right",
  SINGLE_FILE_BEHIND: "Single File Behind",
  SINGLE_FILE_AHEAD: "Single File Ahead",
  RADIAL: "Circular / Radial",
})

export const formationRuntimeName = value => FORMATION_RUNTIME_NAMES[value] || FORMATION_RUNTIME_NAMES.AUTO_BEST_FIT
export const isRaceFormation = value => RACE_FORMATION_CODES.includes(value)
export const isPreviewOrigin = value => PREVIEW_ORIGIN_CODES.includes(value)
export const isHeadingMode = value => HEADING_MODE_CODES.includes(value)
export const isSpacingMode = value => SPACING_MODE_CODES.includes(value)

const PREVIEW_FAILURE_KEYS = Object.freeze({
  preview_renderer_unavailable: "race.previewFailure.rendererUnavailable",
  preview_renderer_threw: "race.previewFailure.rendererThrew",
  preview_renderer_returned_false: "race.previewFailure.rendererReturnedFalse",
  preview_marker_render_failed: "race.previewFailure.markerFailed",
  preview_render_empty: "race.previewFailure.renderEmpty",
})

export const previewStatusKey = preview => {
  const state = String(preview?.state || "PREVIEW_DATA_READY")
  if (state === "PREVIEW_FAILED") {
    return PREVIEW_FAILURE_KEYS[preview?.renderer?.lastErrorCode] || "race.previewState.PREVIEW_FAILED"
  }
  return `race.previewState.${state}`
}
