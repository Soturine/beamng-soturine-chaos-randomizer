import { createDomainStore } from "./domainStore"
export const createGarageStore = state => createDomainStore("garage", state)
