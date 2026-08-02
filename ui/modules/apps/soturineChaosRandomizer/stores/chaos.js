import { createDomainStore } from "./domainStore"
export const createChaosStore = state => createDomainStore("chaos", state)
