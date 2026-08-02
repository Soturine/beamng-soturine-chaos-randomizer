import { createDomainStore } from "./domainStore.js"
export const createChaosStore = state => createDomainStore("chaos", state)
