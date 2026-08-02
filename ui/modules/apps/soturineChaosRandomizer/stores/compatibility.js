import { createDomainStore } from "./domainStore.js"
export const createCompatibilityStore = state => createDomainStore("compatibility", state)
