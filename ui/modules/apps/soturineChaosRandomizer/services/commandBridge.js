export const UI_PROTOCOL_VERSION = 2
export const MAX_COMMAND_BYTES = 131072

export const COMMAND_SCHEMAS = Object.freeze({
  requestState: [0, 0], runAction: [1, 2], updateSettings: [1, 1],
  updateUIPreferences: [1, 1], migrateLegacyUIPreferences: [1, 1], setUICompactMode: [1, 1],
  cancelCurrentOperation: [0, 0], cancelRaceGeneration: [0, 0], getVehicleDNALocks: [0, 1],
  copyDiagnostics: [0, 0], spawnSafeVehicle: [0, 0], retryQuarantinedConfigurations: [0, 0],
  rerollUnlocked: [0, 1], saveVehicleDNA: [1, 1], deleteVehicleDNA: [1, 1],
  renameVehicleDNA: [2, 2], setVehicleDNAFavorite: [2, 2], setVehicleDNAPinned: [2, 2],
  setVehicleDNARating: [2, 2], setVehicleDNATags: [2, 2], setVehicleDNACollection: [2, 2],
  setVehicleDNANotes: [2, 2], duplicateVehicleDNA: [1, 1], setVehicleDNAQuery: [1, 1],
  getVehicleDNADetails: [1, 1], compareVehicleDNA: [2, 2], importVehicleDNA: [1, 1],
  exportVehicleDNAJson: [1, 2], exportVehicleDNAPackage: [1, 1], importVehicleDNAPackage: [1, 1],
  confirmVehicleDNAPackageImport: [0, 0], captureVehicleDNAThumbnail: [1, 2],
  removeVehicleDNAThumbnail: [1, 1], preflightVehicleDNA: [2, 2],
  replayVehicleDNAGeneration: [1, 2], pureSeedReplayVehicleDNA: [1, 1],
  mutateVehicleDNA: [2, 3], restoreVehicleDNA: [2, 3], setVehicleDNAPage: [1, 1],
  lockVehicle: [1, 1], lockConfiguration: [1, 1], lockCategory: [2, 2], lockSlot: [1, 2],
  unlockSlot: [1, 1], lockPart: [1, 2], lockCurrentParts: [0, 0], lockTuning: [2, 3],
  lockPaint: [3, 3], applyLockPreset: [1, 1], updateLockProfile: [1, 1],
  createChaosLineup: [1, 1], renameLineupCompetitor: [2, 2], reorderLineupCompetitor: [2, 2],
  resolveLineupFailure: [2, 2], exportChaosLineup: [0, 0], importChaosLineup: [0, 0],
  previewLineupSpawn: [1, 1], startLineupSpawn: [1, 1], cancelLineupSpawn: [0, 0],
  removeManagedVehicle: [1, 1], respawnManagedVehicle: [1, 1], focusManagedVehicle: [1, 1],
  placeAIDestination: [0, 0], confirmAIDestination: [1, 1], clearAIDestination: [0, 0],
  addAIRoutePoint: [0, 0], editAIRoute: [1, 1], startManagedAI: [1, 1],
  pauseManagedAI: [0, 0], resumeManagedAI: [0, 0], stopManagedAI: [0, 0],
  resetManagedAI: [0, 0], setAIRecording: [2, 2],
})

const safeView = value => /^[A-Za-z0-9_.:-]{1,32}$/.test(String(value || ""))

export function createCommandBridge(api, sourceView = () => "shell") {
  let commandSequence = 0
  let disposed = false

  async function send(command, args = []) {
    if (disposed) throw new Error("command_bridge_disposed")
    const schema = COMMAND_SCHEMAS[command]
    if (!schema) throw new Error("command_not_allowed")
    if (!Array.isArray(args) || args.length < schema[0] || args.length > schema[1]) {
      throw new Error("command_arguments_invalid")
    }
    const view = String(sourceView() || "shell")
    if (!safeView(view)) throw new Error("command_source_invalid")
    const envelope = {
      command,
      commandId: `scr-vue-${Date.now()}-${++commandSequence}`,
      protocolVersion: UI_PROTOCOL_VERSION,
      arguments: args,
      sourceView: view,
    }
    if (JSON.stringify(envelope).length > MAX_COMMAND_BYTES) throw new Error("command_payload_oversize")
    const serialized = api.serializeToLua(envelope)
    const target = `extensions.soturineChaosRandomizer.dispatchUICommand(${serialized})`
    return new Promise(resolve => api.engineLua(target, resolve))
  }

  return { send, dispose: () => { disposed = true }, get disposed() { return disposed } }
}
