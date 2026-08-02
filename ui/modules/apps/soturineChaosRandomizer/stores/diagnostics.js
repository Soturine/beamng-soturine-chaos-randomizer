import { createDomainStore } from "./domainStore"
export const createDiagnosticsStore = state => createDomainStore("diagnostics", state)
