import { createDomainStore } from "./domainStore.js"
export const createGarageStore = state => createDomainStore("garage", state)
