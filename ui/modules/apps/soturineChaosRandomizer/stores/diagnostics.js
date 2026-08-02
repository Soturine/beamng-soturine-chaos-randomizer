import { createDomainStore } from "./domainStore.js"
export const createDiagnosticsStore = state => createDomainStore("diagnostics", state)
