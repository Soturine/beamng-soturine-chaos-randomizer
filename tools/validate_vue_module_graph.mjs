#!/usr/bin/env node

import process from "node:process"
import path from "node:path"
import { readFile, readdir, stat } from "node:fs/promises"
import { parse as parseSfc } from "@vue/compiler-sfc"

const DEFAULT_APP_ROOT = "ui/modules/apps/soturineChaosRandomizer"
const AUDITED_EXTENSIONS = new Set([".vue", ".js", ".json", ".scss"])
const PROJECT_EXTENSIONS = new Set([".vue", ".js", ".mjs", ".json", ".scss"])
const RUNTIME_ALIASES = new Set([
  "@/bridge",
  "@/services/events",
  "@/services/settings",
  "@/common/directives",
  "@/common/components/base",
])

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
    else if (entry.isFile() && AUDITED_EXTENSIONS.has(path.extname(entry.name))) result.push(current)
  }
  return result.sort((left, right) => left.localeCompare(right, "en"))
}

function scriptImports(source) {
  const imports = []
  const staticPattern = /\bimport[ \t]+(?!\s*\()(?:(.*?)[ \t]+from[ \t]+)?(["'])([^"'\r\n]+)\2/g
  const reexportPattern = /\bexport[ \t]+(?:\*|\{([^}]*)\})[ \t]+from[ \t]+(["'])([^"'\r\n]+)\2/g
  const dynamicPattern = /\bimport\s*\(\s*(["'])([^"'\r\n]+)\1\s*\)/g
  let match
  while ((match = staticPattern.exec(source)) !== null) {
    const clause = (match[1] || "").trim()
    const named = []
    const namedMatch = clause.match(/\{([^}]*)\}/)
    if (namedMatch) {
      for (const item of namedMatch[1].split(",")) {
        const name = item.trim().split(/\s+as\s+/)[0]
        if (name) named.push(name)
      }
    }
    const first = clause.replace(/\{[^}]*\}/, "").split(",")[0].trim()
    imports.push({ specifier: match[3], named, wantsDefault: Boolean(first && !first.startsWith("*")), kind: "static" })
  }
  while ((match = reexportPattern.exec(source)) !== null) {
    const named = (match[1] || "").split(",").map(item => item.trim().split(/\s+as\s+/)[0]).filter(Boolean)
    imports.push({ specifier: match[3], named, wantsDefault: false, kind: "reexport" })
  }
  while ((match = dynamicPattern.exec(source)) !== null) {
    imports.push({ specifier: match[2], named: [], wantsDefault: false, kind: "dynamic" })
  }
  const literalDynamicCount = imports.filter(item => item.kind === "dynamic").length
  const allDynamicCount = (source.match(/\bimport\s*\(/g) || []).length
  for (let index = literalDynamicCount; index < allDynamicCount; index += 1) {
    imports.push({ specifier: "<nonliteral>", named: [], wantsDefault: false, kind: "dynamic-nonliteral" })
  }
  return imports
}

function styleImports(source) {
  const imports = []
  const pattern = /@(use|forward|import)\s+(["'])([^"'\r\n]+)\2/g
  let match
  while ((match = pattern.exec(source)) !== null) {
    imports.push({ specifier: match[3], named: [], wantsDefault: false, kind: `scss-${match[1]}` })
  }
  return imports
}

async function importsFor(file) {
  const source = await readFile(file, "utf8")
  const extension = path.extname(file)
  if (extension === ".js" || extension === ".mjs") return scriptImports(source)
  if (extension === ".scss") return styleImports(source)
  if (extension !== ".vue") return []
  const parsed = parseSfc(source, { filename: file })
  if (parsed.errors.length) throw new Error(`SFC parse failed: ${file}: ${parsed.errors.join("; ")}`)
  const result = []
  if (parsed.descriptor.script?.content) result.push(...scriptImports(parsed.descriptor.script.content))
  if (parsed.descriptor.scriptSetup?.content) result.push(...scriptImports(parsed.descriptor.scriptSetup.content))
  for (const style of parsed.descriptor.styles) {
    if (style.src) result.push({ specifier: style.src, named: [], wantsDefault: false, kind: "style-src" })
    result.push(...styleImports(style.content || ""))
  }
  return result
}

async function exactPathStatus(appRoot, candidate) {
  const relative = path.relative(appRoot, candidate)
  if (!relative || relative === ".") return { exists: true, type: "directory" }
  if (relative.startsWith(`..${path.sep}`) || path.isAbsolute(relative)) return { outside: true }
  let current = appRoot
  for (const segment of relative.split(path.sep)) {
    let entries
    try { entries = await readdir(current, { withFileTypes: true }) }
    catch { return { exists: false } }
    const exact = entries.find(entry => entry.name === segment)
    if (!exact) {
      const folded = entries.find(entry => entry.name.toLocaleLowerCase("en") === segment.toLocaleLowerCase("en"))
      return folded ? { exists: false, caseMismatch: folded.name } : { exists: false }
    }
    current = path.join(current, exact.name)
  }
  const value = await stat(current)
  return { exists: true, type: value.isDirectory() ? "directory" : "file", path: current }
}

async function exportedNames(file) {
  const extension = path.extname(file)
  if (extension === ".vue" || extension === ".json") return { names: new Set(), hasDefault: true }
  if (extension !== ".js" && extension !== ".mjs") return { names: new Set(), hasDefault: false }
  const source = await readFile(file, "utf8")
  const names = new Set()
  let match
  const declaration = /\bexport\s+(?:async\s+)?(?:function|class|const|let|var)\s+([A-Za-z_$][\w$]*)/g
  while ((match = declaration.exec(source)) !== null) names.add(match[1])
  const lists = /\bexport\s*\{([^}]*)\}/g
  while ((match = lists.exec(source)) !== null) {
    for (const item of match[1].split(",")) {
      const parts = item.trim().split(/\s+as\s+/)
      const name = parts.at(-1)
      if (name) names.add(name)
    }
  }
  return { names, hasDefault: /\bexport\s+default\b/.test(source) }
}

function issue(report, source, specifier, reason, detail = "") {
  report.issues.push({ source, specifier, reason, detail })
}

async function validateGraph(appRoot, mode) {
  const auditedFiles = await walk(appRoot)
  const entry = path.join(appRoot, "app.vue")
  const entryStatus = await exactPathStatus(appRoot, entry)
  const report = {
    mode,
    filesScanned: auditedFiles.length,
    reachableFiles: 0,
    importsScanned: 0,
    runtimeAliases: 0,
    vuePackageImports: 0,
    projectImports: 0,
    projectVueImports: 0,
    projectJavaScriptImports: 0,
    projectJsonImports: 0,
    projectScssImports: 0,
    dynamicImports: 0,
    reexports: 0,
    directoryImports: 0,
    missingModules: 0,
    caseMismatches: 0,
    zipMissingModules: 0,
    cycles: 0,
    namedExportErrors: 0,
    issues: [],
  }
  if (!entryStatus.exists || entryStatus.type !== "file") {
    issue(report, "app.vue", "app.vue", "entry_missing")
    report.missingModules += 1
    if (mode === "zip") report.zipMissingModules += 1
    return report
  }

  const importMap = new Map()
  const exportMap = new Map()
  for (const file of auditedFiles) {
    const relativeSource = path.relative(appRoot, file).split(path.sep).join("/")
    let imports
    try { imports = await importsFor(file) }
    catch (error) {
      issue(report, relativeSource, "<parse>", "parse_error", error.message)
      imports = []
    }
    importMap.set(file, [])
    report.importsScanned += imports.length
    for (const item of imports) {
      const specifier = item.specifier
      if (item.kind === "dynamic") report.dynamicImports += 1
      if (item.kind === "reexport") report.reexports += 1
      if (item.kind === "dynamic-nonliteral") {
        issue(report, relativeSource, specifier, "nonliteral_dynamic_import")
        continue
      }
      if (/^(?:https?:)?\/\//i.test(specifier) || /^[a-z][a-z0-9+.-]*:/i.test(specifier)) {
        issue(report, relativeSource, specifier, "remote_or_unsupported_scheme")
        continue
      }
      if (specifier === "vue") {
        report.vuePackageImports += 1
        continue
      }
      if (specifier.startsWith("@/")) {
        if (RUNTIME_ALIASES.has(specifier)) report.runtimeAliases += 1
        else issue(report, relativeSource, specifier, "runtime_alias_not_allowlisted")
        continue
      }
      if (!specifier.startsWith("./") && !specifier.startsWith("../")) {
        issue(report, relativeSource, specifier, specifier.startsWith("/") ? "absolute_local_import" : "unsupported_bare_module")
        continue
      }
      if (specifier.includes("\\")) {
        issue(report, relativeSource, specifier, "backslash_import")
        continue
      }

      report.projectImports += 1
      const candidate = path.resolve(path.dirname(file), ...specifier.split("/"))
      const outside = path.relative(appRoot, candidate)
      if (outside.startsWith(`..${path.sep}`) || path.isAbsolute(outside)) {
        issue(report, relativeSource, specifier, "import_outside_app_root")
        continue
      }
      const extension = path.extname(specifier)
      if (!extension) {
        const literalStatus = await exactPathStatus(appRoot, candidate)
        if (literalStatus.exists && literalStatus.type === "directory") {
          report.directoryImports += 1
          report.missingModules += 1
          if (mode === "zip") report.zipMissingModules += 1
          issue(report, relativeSource, specifier, "directory_import")
        } else {
          report.missingModules += 1
          if (mode === "zip") report.zipMissingModules += 1
          issue(report, relativeSource, specifier, "missing_explicit_extension")
        }
        continue
      }
      if (!PROJECT_EXTENSIONS.has(extension)) {
        issue(report, relativeSource, specifier, "unsupported_project_extension")
        continue
      }
      if (extension === ".vue") report.projectVueImports += 1
      else if (extension === ".js" || extension === ".mjs") report.projectJavaScriptImports += 1
      else if (extension === ".json") report.projectJsonImports += 1
      else if (extension === ".scss") report.projectScssImports += 1
      const status = await exactPathStatus(appRoot, candidate)
      if (status.caseMismatch) {
        report.caseMismatches += 1
        issue(report, relativeSource, specifier, "case_mismatch", `actual=${status.caseMismatch}`)
        continue
      }
      if (!status.exists || status.type !== "file") {
        report.missingModules += 1
        if (mode === "zip") report.zipMissingModules += 1
        issue(report, relativeSource, specifier, "missing_module")
        continue
      }
      importMap.get(file).push(status.path)

      if (item.named.length || item.wantsDefault) {
        if (!exportMap.has(status.path)) exportMap.set(status.path, await exportedNames(status.path))
        const available = exportMap.get(status.path)
        if (item.wantsDefault && !available.hasDefault) {
          report.namedExportErrors += 1
          issue(report, relativeSource, specifier, "missing_default_export")
        }
        for (const name of item.named) {
          if (!available.names.has(name)) {
            report.namedExportErrors += 1
            issue(report, relativeSource, specifier, "missing_named_export", `export=${name}`)
          }
        }
      }
    }
  }

  const visiting = new Set()
  const visited = new Set()
  async function visit(file, chain) {
    if (visiting.has(file)) {
      report.cycles += 1
      issue(report, path.relative(appRoot, chain.at(-1)).split(path.sep).join("/"), path.relative(appRoot, file).split(path.sep).join("/"), "initialization_cycle")
      return
    }
    if (visited.has(file)) return
    visiting.add(file)
    for (const dependency of importMap.get(file) || []) await visit(dependency, [...chain, file])
    visiting.delete(file)
    visited.add(file)
  }
  await visit(entry, [])
  report.reachableFiles = visited.size
  return report
}

function printReport(report, json) {
  if (json) {
    process.stdout.write(`${JSON.stringify(report)}\n`)
    return
  }
  console.log(report.issues.length ? "SCR_VUE_MODULE_GRAPH_INVALID" : "SCR_VUE_MODULE_GRAPH_VALID")
  for (const value of report.issues) {
    console.log(`source=${value.source}`)
    console.log(`specifier=${value.specifier}`)
    console.log(`reason=${value.reason}${value.detail ? ` ${value.detail}` : ""}`)
  }
  console.log(`Files scanned: ${report.filesScanned}`)
  console.log(`Reachable files: ${report.reachableFiles}`)
  console.log(`Imports scanned: ${report.importsScanned}`)
  console.log(`Runtime aliases: ${report.runtimeAliases}`)
  console.log(`Vue package imports: ${report.vuePackageImports}`)
  console.log(`Project imports: ${report.projectImports}`)
  console.log(`Project .vue imports: ${report.projectVueImports}`)
  console.log(`Project JavaScript imports: ${report.projectJavaScriptImports}`)
  console.log(`Project JSON imports: ${report.projectJsonImports}`)
  console.log(`Project SCSS imports: ${report.projectScssImports}`)
  console.log(`Dynamic imports: ${report.dynamicImports}`)
  console.log(`Reexports: ${report.reexports}`)
  console.log(`Directory imports: ${report.directoryImports}`)
  console.log(`Missing modules: ${report.missingModules}`)
  console.log(`Case mismatches: ${report.caseMismatches}`)
  console.log(`ZIP missing modules: ${report.zipMissingModules}`)
  console.log(`Initialization cycles: ${report.cycles}`)
  console.log(`Named export errors: ${report.namedExportErrors}`)
}

try {
  const options = parseArguments(process.argv.slice(2))
  const report = await validateGraph(options.appRoot, options.mode)
  printReport(report, options.json)
  if (report.issues.length) process.exitCode = 1
} catch (error) {
  console.error("SCR_VUE_MODULE_GRAPH_INVALID")
  console.error(`reason=validator_error ${error.message}`)
  process.exitCode = 1
}
