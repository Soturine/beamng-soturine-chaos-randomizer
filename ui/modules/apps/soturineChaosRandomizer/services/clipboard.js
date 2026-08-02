export async function copyText(value) {
  const text = String(value || "")
  if (!text) return false
  if (globalThis.navigator?.clipboard?.writeText) {
    try { await globalThis.navigator.clipboard.writeText(text); return true } catch { /* use CEF fallback */ }
  }
  const input = document.createElement("textarea")
  input.value = text
  input.readOnly = true
  input.setAttribute("aria-hidden", "true")
  Object.assign(input.style, { position: "fixed", opacity: "0", pointerEvents: "none" })
  document.body.appendChild(input)
  input.select()
  let copied = false
  try { copied = document.execCommand("copy") === true } finally { input.remove() }
  return copied
}
