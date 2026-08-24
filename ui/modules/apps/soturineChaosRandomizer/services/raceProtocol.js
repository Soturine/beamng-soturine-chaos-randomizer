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

const FORMATION_ALIASES = new Map()
Object.entries(FORMATION_RUNTIME_NAMES).forEach(([code, name]) => {
  FORMATION_ALIASES.set(code.toLowerCase(), code)
  FORMATION_ALIASES.set(name.toLowerCase(), code)
})
Object.entries({
  "automatic best fit": "AUTO_BEST_FIT", "automatic best-fit": "AUTO_BEST_FIT",
  "melhor ajuste automático": "AUTO_BEST_FIT", "mejor ajuste automático": "AUTO_BEST_FIT",
  "grid": "GRID", "parrilla": "GRID", "line": "LINE", "linha": "LINE", "línea": "LINE",
  "split left and right": "SPLIT_LEFT_RIGHT", "dividir à esquerda e à direita": "SPLIT_LEFT_RIGHT",
  "dividir a izquierda y derecha": "SPLIT_LEFT_RIGHT",
  "single file behind": "SINGLE_FILE_BEHIND", "fila única atrás": "SINGLE_FILE_BEHIND",
  "fila única detrás": "SINGLE_FILE_BEHIND", "single file ahead": "SINGLE_FILE_AHEAD",
  "fila única à frente": "SINGLE_FILE_AHEAD", "fila única delante": "SINGLE_FILE_AHEAD",
  "staggered grid": "STAGGERED_GRID", "grid escalonado": "STAGGERED_GRID",
  "parrilla escalonada": "STAGGERED_GRID", "side-by-side grid": "SIDE_BY_SIDE_GRID",
  "grid lado a lado": "SIDE_BY_SIDE_GRID", "parrilla en paralelo": "SIDE_BY_SIDE_GRID",
  "circular / radial": "RADIAL", "circular/radial": "RADIAL",
}).forEach(([name, code]) => FORMATION_ALIASES.set(name, code))

export const normalizeFormationCode = (value, fallback = RACE_FORMATION_CODES[0]) => {
  const normalized = String(value ?? "").trim().toLowerCase()
  return FORMATION_ALIASES.get(normalized) || (RACE_FORMATION_CODES.includes(fallback)
    ? fallback : RACE_FORMATION_CODES[0])
}

export const formationRuntimeName = value => FORMATION_RUNTIME_NAMES[normalizeFormationCode(value)]
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
