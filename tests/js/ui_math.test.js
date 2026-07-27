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

assert.strictEqual(ui.manualHeight(500, 340, null), 500)
assert.strictEqual(ui.manualHeight(340, 340, 500), 500)
assert.strictEqual(ui.shouldApplyResize(340, 340), false)
assert.strictEqual(ui.shouldApplyResize(340, 420), true)

console.log('SCR_UI_JS_TESTS_PASSED 17')
