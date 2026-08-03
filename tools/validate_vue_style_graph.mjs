#!/usr/bin/env node

import process from "node:process"
import path from "node:path"
import { readFile, readdir, stat } from "node:fs/promises"
import { parse as parseSfc } from "@vue/compiler-sfc"

const DEFAULT_APP_ROOT = "ui/modules/apps/soturineChaosRandomizer"
const SOURCE_EXTENSIONS = new Set([".vue", ".js", ".mjs", ".css", ".scss"])
const STYLE_EXTENSIONS = new Set([".css", ".scss"])
const ASSET_EXTENSIONS = new Set([".svg", ".png", ".jpg", ".jpeg", ".webp", ".gif", ".woff", ".woff2", ".ttf", ".otf"])

function parseArguments(argv) {
  let appRoot = DEFAULT_APP_ROOT
  let mode = "source"
  let json = false
  for (const arg of argv) {
    if (arg === "--json") json = true
    else if (arg === "--mode=zip") mode = "zip"
    else if (arg === "--mode=source") mode = "source"
    else if (arg.startsWith("--")) throw new Error(`Unknown option: ${arg}`)
    else appRoot = arg
  }
  if (!new Set(["source", "zip"]).has(mode)) throw new Error(`Unsupported mode: ${mode}`)
  return { appRoot: path.resolve(appRoot), mode, json }
}

async function walk(directory) {
  const result = []
  for (const entry of await readdir(directory, { withFileTypes: true })) {
    const current = path.join(directory, entry.name)
    if (entry.isDirectory()) result.push(...await walk(current))
    else if (entry.isFile() && SOURCE_EXTENSIONS.has(path.extname(entry.name).toLowerCase())) result.push(current)
  }
  return result.sort((left, right) => left.localeCompare(right, "en"))
}

async function exactPathStatus(appRoot, candidate) {
  const relative = path.relative(appRoot, candidate)
  if (relative.startsWith(`..${path.sep}`) || path.isAbsolute(relative)) return { outside: true }
  let current = appRoot
  for (const segment of relative.split(path.sep).filter(Boolean)) {
    let entries
    try { entries = await readdir(current, { withFileTypes: true }) }
    catch { return { exists: false } }
    const exact = entries.find(entry => entry.name === segment)
    if (!exact) {
      const folded = entries.find(entry => entry.name.toLowerCase() === segment.toLowerCase())
      return folded ? { exists: false, caseMismatch: folded.name } : { exists: false }
    }
    current = path.join(current, exact.name)
  }
  try {
    const value = await stat(current)
    return { exists: true, type: value.isFile() ? "file" : "directory", path: current }
  } catch {
    return { exists: false }
  }
}

function scriptImports(source) {
  const result = []
  const pattern = /\bimport[ \t]+(?!\s*\()(?:(?:.*?)\s+from\s+)?(["'])([^"'\r\n]+)\1/g
  let match
  while ((match = pattern.exec(source)) !== null) result.push(match[2])
  return result
}

function cssImports(source) {
  const result = []
  const pattern = /@import\s+(?:url\(\s*)?(["'])([^"'\r\n]+)\1\s*\)?[^;]*;/gi
  let match
  while ((match = pattern.exec(source)) !== null) result.push(match[2])
  return result
}

function cssUrls(source) {
  const result = []
  const pattern = /url\(\s*(?:(["'])(.*?)\1|([^)'"\s][^)]*?))\s*\)/gi
  let match
  while ((match = pattern.exec(source)) !== null) result.push((match[2] || match[3] || "").trim())
  return result
}

function templateAssets(source) {
  const result = []
  const pattern = /<(?:img|source)\b[^>]*\bsrc\s*=\s*(["'])([^"']+)\1/gi
  let match
  while ((match = pattern.exec(source)) !== null) result.push(match[2])
  return result
}

function isRemote(reference) {
  return /^(?:https?:)?\/\//i.test(reference) || /^data:/i.test(reference) || /^[a-z][a-z0-9+.-]*:/i.test(reference)
}

function addIssue(report, source, reference, reason, detail = "") {
  report.issues.push({ source, reference, reason, detail })
}

async function resolveReference(report, appRoot, sourceFile, reference, kind) {
  const clean = reference.split(/[?#]/, 1)[0]
  const source = path.relative(appRoot, sourceFile).split(path.sep).join("/")
  if (!clean) return null
  if (isRemote(clean)) {
    report.remoteReferences += 1
    addIssue(report, source, reference, "remote_reference")
    return null
  }
  if (!clean.startsWith("./") && !clean.startsWith("../")) {
    addIssue(report, source, reference, clean.startsWith("/") ? "absolute_local_reference" : "unsupported_bare_reference")
    return null
  }
  if (clean.includes("\\")) {
    addIssue(report, source, reference, "backslash_reference")
    return null
  }
  const candidate = path.resolve(path.dirname(sourceFile), ...clean.split("/"))
  const status = await exactPathStatus(appRoot, candidate)
  if (status.caseMismatch) {
    report.caseMismatches += 1
    addIssue(report, source, reference, "case_mismatch", `actual=${status.caseMismatch}`)
    return null
  }
  if (status.outside) {
    addIssue(report, source, reference, "reference_outside_app_root")
    return null
  }
  if (!status.exists || status.type !== "file") {
    if (kind === "style") {
      report.missingStyles += 1
      if (report.mode === "zip") report.zipMissingStyles += 1
    } else {
      report.missingAssets += 1
      if (report.mode === "zip") report.zipMissingAssets += 1
    }
    addIssue(report, source, reference, kind === "style" ? "missing_style" : "missing_asset")
    return null
  }
  return status.path
}

function ruleBodies(css, selector) {
  const result = []
  const pattern = /([^{}]+)\{([^{}]*)}/g
  let match
  while ((match = pattern.exec(css)) !== null) {
    const selectors = match[1].replace(/^\s*@[^\n]+/, "").split(",").map(value => value.trim())
    if (selectors.includes(selector)) result.push(match[2])
  }
  return result
}

function hasRule(css, selector, pattern) {
  return ruleBodies(css, selector).some(body => pattern.test(body))
}

function validateCriticalRules(report, css) {
  const checks = [
    ["app_shell", () => hasRule(css, ".scr-app", /overflow\s*:\s*hidden/i) && hasRule(css, ".scr-app", /background\s*:/i)],
    ["header", () => hasRule(css, ".scr-header", /background\s*:/i) && hasRule(css, ".scr-header", /border-bottom\s*:/i)],
    ["buttons", () => hasRule(css, ".scr-app button", /background\s*:/i) && hasRule(css, ".scr-app button", /border\s*:/i)],
    ["tabs", () => hasRule(css, ".scr-nav button.is-active", /background\s*:/i) && hasRule(css, ".scr-nav button.is-active", /border-bottom-color\s*:/i)],
    ["internal_scroll", () => hasRule(css, ".scr-body", /overflow\s*:\s*auto/i) && hasRule(css, ".scr-details", /overflow\s*:\s*auto/i)],
    ["cards", () => hasRule(css, ".scr-card", /background\s*:/i) && hasRule(css, ".scr-card", /border\s*:/i)],
    ["compact", () => hasRule(css, ".scr-compact", /overflow\s*:\s*auto/i)],
  ]
  const fox = ruleBodies(css, ".scr-header img").join("\n")
  const width = Number(fox.match(/\bwidth\s*:\s*(\d+(?:\.\d+)?)px/i)?.[1])
  const height = Number(fox.match(/\bheight\s*:\s*(\d+(?:\.\d+)?)px/i)?.[1])
  checks.push(["bounded_fox", () => width >= 24 && width <= 40 && height >= 24 && height <= 40])
  for (const [name, check] of checks) {
    if (check()) continue
    report.criticalRuleFailures += 1
    addIssue(report, "styles", name, "critical_rule_missing")
  }
}

async function validateStyleGraph(appRoot, mode) {
  const report = {
    mode,
    sourceFilesScanned: 0,
    vueFilesScanned: 0,
    styleBlocksScanned: 0,
    runtimeCssFiles: 0,
    cssFilesScanned: 0,
    cssImportsScanned: 0,
    assetReferences: 0,
    missingStyles: 0,
    missingAssets: 0,
    caseMismatches: 0,
    remoteReferences: 0,
    rawScssRuntimePaths: 0,
    emptyCssFiles: 0,
    sourceMapReferences: 0,
    criticalRuleFailures: 0,
    zipMissingStyles: 0,
    zipMissingAssets: 0,
    issues: [],
  }
  const files = await walk(appRoot)
  report.sourceFilesScanned = files.length
  const runtimeStyles = new Set()
  const templates = []

  for (const file of files) {
    const extension = path.extname(file).toLowerCase()
    const source = await readFile(file, "utf8")
    let imports = []
    if (extension === ".vue") {
      report.vueFilesScanned += 1
      const parsed = parseSfc(source, { filename: file })
      if (parsed.errors.length) {
        addIssue(report, path.relative(appRoot, file), "<parse>", "sfc_parse_error", parsed.errors.join("; "))
        continue
      }
      const descriptor = parsed.descriptor
      imports = [
        ...scriptImports(descriptor.script?.content || ""),
        ...scriptImports(descriptor.scriptSetup?.content || ""),
      ]
      templates.push([file, descriptor.template?.content || ""])
      for (const style of descriptor.styles) {
        report.styleBlocksScanned += 1
        const language = (style.lang || "css").toLowerCase()
        if (language !== "css") {
          report.rawScssRuntimePaths += 1
          addIssue(report, path.relative(appRoot, file), language, "runtime_style_preprocessor_forbidden")
        }
        if (style.src) {
          const resolved = await resolveReference(report, appRoot, file, style.src, "style")
          if (resolved) runtimeStyles.add(resolved)
        } else if (!style.content.trim()) {
          report.emptyCssFiles += 1
          addIssue(report, path.relative(appRoot, file), "<style>", "empty_inline_style")
        }
      }
    } else if (extension === ".js" || extension === ".mjs") {
      imports = scriptImports(source)
    }
    for (const reference of imports) {
      const importedExtension = path.extname(reference.split(/[?#]/, 1)[0]).toLowerCase()
      if (!STYLE_EXTENSIONS.has(importedExtension)) continue
      if (importedExtension === ".scss") {
        report.rawScssRuntimePaths += 1
        addIssue(report, path.relative(appRoot, file), reference, "runtime_scss_import_forbidden")
      }
      const resolved = await resolveReference(report, appRoot, file, reference, "style")
      if (resolved) runtimeStyles.add(resolved)
    }
  }

  const queue = [...runtimeStyles]
  const scanned = new Set()
  let combinedCss = ""
  while (queue.length) {
    const file = queue.shift()
    if (scanned.has(file)) continue
    scanned.add(file)
    const source = await readFile(file, "utf8")
    report.cssFilesScanned += 1
    if (!source.trim()) {
      report.emptyCssFiles += 1
      addIssue(report, path.relative(appRoot, file), "<file>", "empty_css_file")
    }
    if (/sourceMappingURL\s*=/i.test(source)) {
      report.sourceMapReferences += 1
      addIssue(report, path.relative(appRoot, file), "sourceMappingURL", "source_map_reference_forbidden")
    }
    if (path.extname(file).toLowerCase() === ".scss") {
      report.rawScssRuntimePaths += 1
      addIssue(report, path.relative(appRoot, file), "<file>", "raw_scss_runtime_file")
    } else {
      combinedCss += `\n${source}`
    }
    for (const reference of cssImports(source)) {
      report.cssImportsScanned += 1
      const importedExtension = path.extname(reference.split(/[?#]/, 1)[0]).toLowerCase()
      if (importedExtension === ".scss") {
        report.rawScssRuntimePaths += 1
        addIssue(report, path.relative(appRoot, file), reference, "runtime_scss_import_forbidden")
      }
      const resolved = await resolveReference(report, appRoot, file, reference, "style")
      if (resolved) queue.push(resolved)
    }
    for (const reference of cssUrls(source)) {
      if (reference.startsWith("#")) continue
      report.assetReferences += 1
      await resolveReference(report, appRoot, file, reference, "asset")
    }
  }
  report.runtimeCssFiles = scanned.size

  for (const [file, template] of templates) {
    for (const reference of templateAssets(template)) {
      if (!ASSET_EXTENSIONS.has(path.extname(reference.split(/[?#]/, 1)[0]).toLowerCase())) continue
      report.assetReferences += 1
      await resolveReference(report, appRoot, file, reference, "asset")
    }
  }

  if (report.runtimeCssFiles === 0) {
    report.missingStyles += 1
    if (mode === "zip") report.zipMissingStyles += 1
    addIssue(report, "app.vue", "<runtime-css>", "runtime_css_entry_missing")
  }
  validateCriticalRules(report, combinedCss)
  return report
}

function printReport(report, json) {
  if (json) {
    process.stdout.write(`${JSON.stringify(report)}\n`)
    return
  }
  console.log(report.issues.length ? "SCR_VUE_STYLE_GRAPH_INVALID" : "SCR_VUE_STYLE_GRAPH_VALID")
  for (const value of report.issues) {
    console.log(`source=${value.source}`)
    console.log(`reference=${value.reference}`)
    console.log(`reason=${value.reason}${value.detail ? ` ${value.detail}` : ""}`)
  }
  for (const [key, value] of Object.entries(report)) {
    if (key !== "issues" && key !== "mode") console.log(`${key}: ${value}`)
  }
}

try {
  const options = parseArguments(process.argv.slice(2))
  const report = await validateStyleGraph(options.appRoot, options.mode)
  printReport(report, options.json)
  if (report.issues.length) process.exitCode = 1
} catch (error) {
  console.error("SCR_VUE_STYLE_GRAPH_INVALID")
  console.error(`reason=validator_error ${error.message}`)
  process.exitCode = 1
}
