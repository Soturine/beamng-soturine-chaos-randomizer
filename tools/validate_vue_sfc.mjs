import { readdir, readFile } from "node:fs/promises"
import { join, resolve } from "node:path"
import { pathToFileURL } from "node:url"

const [sourceRootArg, dependencyRootArg] = process.argv.slice(2)
if (!sourceRootArg || !dependencyRootArg) {
  console.error("usage: node tools/validate_vue_sfc.mjs <source-root> <dependency-root>")
  process.exit(2)
}

const sourceRoot = resolve(sourceRootArg)
const compilerPath = join(
  resolve(dependencyRootArg),
  "node_modules",
  "@vue",
  "compiler-sfc",
  "dist",
  "compiler-sfc.cjs.js",
)
const { compileScript, compileStyleAsync, compileTemplate, parse } = await import(
  pathToFileURL(compilerPath).href
)

async function collect(directory) {
  const files = []
  for (const entry of await readdir(directory, { withFileTypes: true })) {
    const path = join(directory, entry.name)
    if (entry.isDirectory()) files.push(...await collect(path))
    else if (entry.isFile() && entry.name.endsWith(".vue")) files.push(path)
  }
  return files.sort()
}

const failures = []
const files = await collect(sourceRoot)
for (const filename of files) {
  const source = await readFile(filename, "utf8")
  const id = `scr-${Buffer.from(filename).toString("hex").slice(-16)}`
  const parsed = parse(source, { filename })
  if (parsed.errors.length) {
    failures.push(...parsed.errors.map(error => `${filename}: ${String(error)}`))
    continue
  }

  let bindings = {}
  try {
    if (parsed.descriptor.script || parsed.descriptor.scriptSetup) {
      bindings = compileScript(parsed.descriptor, { id }).bindings
    }
    if (parsed.descriptor.template) {
      const template = compileTemplate({
        source: parsed.descriptor.template.content,
        filename,
        id,
        compilerOptions: { bindingMetadata: bindings },
      })
      failures.push(...template.errors.map(error => `${filename}: ${String(error)}`))
    }
    for (const style of parsed.descriptor.styles) {
      const result = await compileStyleAsync({
        source: style.content,
        filename,
        id,
        scoped: style.scoped,
        modules: style.module,
        preprocessLang: style.lang,
      })
      failures.push(...result.errors.map(error => `${filename}: ${String(error)}`))
    }
  } catch (error) {
    failures.push(`${filename}: ${error?.stack || error}`)
  }
}

if (failures.length) {
  console.error(failures.join("\n"))
  process.exit(1)
}
console.log(`Validated ${files.length} Vue SFC files.`)
