import { createDomainStore } from "./domainStore"
export const createSettingsStore = state => createDomainStore("settings", state)
