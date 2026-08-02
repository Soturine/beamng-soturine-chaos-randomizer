import { createDomainStore } from "./domainStore"
export const createCompatibilityStore = state => createDomainStore("compatibility", state)
