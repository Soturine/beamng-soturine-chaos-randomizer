import { createDomainStore } from "./domainStore"
export const createRaceStore = state => createDomainStore("race", state)
