import { createDomainStore } from "./domainStore.js"
export const createSettingsStore = state => createDomainStore("settings", state)
