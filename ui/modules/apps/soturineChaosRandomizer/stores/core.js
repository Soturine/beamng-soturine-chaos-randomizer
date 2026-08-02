import { createDomainStore } from "./domainStore"
export const createCoreStore = state => createDomainStore("core", state)
