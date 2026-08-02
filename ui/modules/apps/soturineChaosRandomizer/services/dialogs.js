export function confirmDialog(layout, title, message, confirmLabel, returnFocus = document.activeElement) {
  return new Promise(resolve => {
    layout.dialog = { title, message, confirmLabel, returnFocus, resolve }
  })
}
