import { createDomainStore } from "./domainStore.js"
export const createCoreStore = state => createDomainStore("core", state)
