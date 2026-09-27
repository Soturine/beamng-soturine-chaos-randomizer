import { computed } from "vue"

// Presents the backend's canonical Race summary; readiness rules live in Lua.
export function useRaceReadiness(stores) {
  const lineup = computed(() => stores.race.state.lineup?.current)
  const summary = computed(() => lineup.value?.summary || {})
  const aiReady = computed(() => Number(summary.value.aiReady || 0))
  const plannedOpponents = computed(() => Number(summary.value.plannedOpponents || 0))
  const generating = computed(() => lineup.value?.generationState === "lineup_processing")
  const blocked = computed(() => !lineup.value || generating.value || aiReady.value === 0)
  return { lineup, summary, aiReady, plannedOpponents, generating, blocked }
}
