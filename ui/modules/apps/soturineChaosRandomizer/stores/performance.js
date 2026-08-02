import { createDomainStore } from "./domainStore.js"
export const createPerformanceStore = state => createDomainStore("performance", state)
