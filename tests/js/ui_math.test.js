'use strict'

const assert = require('assert')
const ui = require('../../ui/modules/apps/soturineChaosRandomizer/app.js')

assert.strictEqual(ui.sliderPercent(0), '0%')
assert.strictEqual(ui.sliderPercent(50), '50%')
assert.strictEqual(ui.sliderPercent(79), '79%')
assert.strictEqual(ui.sliderPercent(100), '100%')
assert.strictEqual(ui.sliderPercent(-5), '0%')
assert.strictEqual(ui.sliderPercent(150), '100%')
assert.strictEqual(ui.sliderPercent('invalid'), '0%')

assert.strictEqual(ui.contentHeight({mode: 'expanded', header: 48, navigation: 38, bodyContent: 250, frame: 4, maximum: 600}), 340)
assert.strictEqual(ui.contentHeight({mode: 'expanded', header: 48, navigation: 38, bodyContent: 900, frame: 4, maximum: 600}), 600)
assert.strictEqual(ui.contentHeight({mode: 'collapsed', collapsedContent: 160}), 160)
assert.strictEqual(ui.contentHeight({mode: 'collapsed', collapsedContent: 40}), 120)

assert.strictEqual(ui.resolvedHeight({mode: 'expanded', header: 48, navigation: 38, bodyContent: 490, frame: 4, maximum: 650}, {mode: 'auto'}), 580)
assert.strictEqual(ui.resolvedHeight({mode: 'expanded', header: 48, navigation: 38, bodyContent: 230, frame: 4, maximum: 650}, {mode: 'auto'}), 320)
assert.strictEqual(ui.resolvedHeight({mode: 'expanded', header: 48, navigation: 38, bodyContent: 230, frame: 4, maximum: 650}, {mode: 'user', userHeight: 580}), 580)
assert.strictEqual(ui.resolvedHeight({mode: 'collapsed', collapsedContent: 150, maximum: 650}, {mode: 'user', userHeight: 580}), 150)
assert.strictEqual(ui.resizeMode({currentMode: 'auto', source: 'content', currentHeight: 500, lastAppliedHeight: 320, elapsedSinceProgrammatic: 500}), 'auto')
assert.strictEqual(ui.resizeMode({currentMode: 'auto', source: 'external', currentHeight: 500, lastAppliedHeight: 320, elapsedSinceProgrammatic: 50}), 'auto')
assert.strictEqual(ui.resizeMode({currentMode: 'auto', source: 'external', currentHeight: 500, lastAppliedHeight: 320, elapsedSinceProgrammatic: 250}), 'user')
assert.strictEqual(ui.resizeMode({currentMode: 'auto', source: 'external', currentHeight: 321, lastAppliedHeight: 320, elapsedSinceProgrammatic: 250}), 'auto')
assert.strictEqual(ui.shouldApplyResize(340, 340), false)
assert.strictEqual(ui.shouldApplyResize(340, 420), true)

let tabHeight = 320
for (let index = 0; index < 20; index += 1) {
  tabHeight = ui.resolvedHeight({mode: 'expanded', header: 48, navigation: 38, bodyContent: index % 2 ? 490 : 230, frame: 4, maximum: 650}, {mode: 'auto'})
  assert.strictEqual(tabHeight, index % 2 ? 580 : 320)
}

assert.strictEqual(ui.sliderPercent(1), '1%')
assert.strictEqual(ui.sliderPercent(99), '99%')

const tabSizes = ui.tabSizes()
assert.strictEqual(tabSizes.expanded.chaos, 360)
assert.strictEqual(tabSizes.expanded.garage, 520)
assert.strictEqual(tabSizes.expanded.race, 620)
assert.strictEqual(tabSizes.expanded.settings, 640)
assert.strictEqual(tabSizes.collapsed.chaos, 180)
assert.strictEqual(tabSizes.collapsed.garage, 194)
assert.strictEqual(tabSizes.collapsed.race, 214)
assert.strictEqual(tabSizes.collapsed.settings, 220)
assert.strictEqual(ui.tabHeight('chaos', 'expanded', tabSizes), 360)
assert.strictEqual(ui.tabHeight('garage', 'expanded', tabSizes), 520)
assert.strictEqual(ui.tabHeight('race', 'expanded', tabSizes), 620)
assert.strictEqual(ui.tabHeight('settings', 'expanded', tabSizes), 640)
assert.strictEqual(ui.tabHeight('chaos', 'collapsed', tabSizes), 180)
assert.strictEqual(ui.tabHeight('garage', 'collapsed', tabSizes), 194)
assert.strictEqual(ui.tabHeight('race', 'collapsed', tabSizes), 214)
assert.strictEqual(ui.tabHeight('settings', 'collapsed', tabSizes), 220)

for (let index = 0; index < 50; index += 1) {
  const tab = ['chaos', 'garage', 'race', 'settings'][index % 4]
  const expanded = ui.tabHeight(tab, 'expanded', tabSizes, {open: true, measuredHeight: 700, maximum: 720})
  assert.ok(expanded >= tabSizes.expanded[tab])
  assert.strictEqual(ui.tabHeight(tab, 'expanded', tabSizes, {open: false, measuredHeight: expanded, maximum: 720}), tabSizes.expanded[tab])
  assert.strictEqual(ui.tabHeight(tab, 'collapsed', tabSizes, {open: true, measuredHeight: 700, maximum: 720}), tabSizes.collapsed[tab])
}

assert.strictEqual(ui.changedPolicyCount({a: true, b: 2}, {a: true, b: 2}), 0)
assert.strictEqual(ui.changedPolicyCount({a: false, b: 2}, {a: true, b: 2}), 1)
assert.strictEqual(ui.changedPolicyCount({a: false, b: 3}, {a: true, b: 2}), 2)

console.log('SCR_UI_JS_TESTS_PASSED 49')
