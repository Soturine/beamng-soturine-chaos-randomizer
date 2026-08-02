import { createDomainStore } from "./domainStore.js"
export const createRaceStore = state => createDomainStore("race", state)
