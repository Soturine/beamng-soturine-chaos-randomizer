import { createDomainStore } from "./domainStore"
export const createPerformanceStore = state => createDomainStore("performance", state)
