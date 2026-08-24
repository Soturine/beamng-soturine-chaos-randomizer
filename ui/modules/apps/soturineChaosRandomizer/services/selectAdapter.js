export const normalizeSelectItems = value => {
  const source = Array.isArray(value) ? value
    : value && typeof value === "object" ? Object.keys(value).sort()
      .map(key => value[key] && typeof value[key] === "object"
        ? { value: key, ...value[key] } : { value: key, label: value[key] })
      : []
  return source.map(item => {
    if (item && typeof item === "object") {
      const itemValue = item.value ?? item.id ?? item.label
      if (itemValue === undefined || itemValue === null) return null
      return { ...item, value: itemValue, label: String(item.label ?? itemValue) }
    }
    if (item === undefined || item === null) return null
    return { value: item, label: String(item) }
  }).filter(Boolean)
}
