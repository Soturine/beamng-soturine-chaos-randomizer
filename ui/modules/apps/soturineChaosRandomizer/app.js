(function () {
  'use strict'

  var appModule = angular.module('beamng.apps')

  appModule.directive('scrImageFallback', [function () {
    return {
      restrict: 'A',
      link: function (scope, element) {
        element.on('error', function () { element.addClass('is-missing') })
        scope.$on('$destroy', function () { element.off('error') })
      }
    }
  }])

  appModule.directive('soturineChaosRandomizer', ['$timeout', function ($timeout) {
    return {
      templateUrl: '/ui/modules/apps/soturineChaosRandomizer/app.html',
      replace: false,
      restrict: 'E',
      scope: false,
      link: function (scope) {
        var settingsTimer = null
        var queryTimer = null

        scope.chaos = {
          view: 'randomize',
          navigation: [
            {id: 'randomize', label: 'Randomize', help: 'Random Car loads a normal configuration; Scramble transforms the current vehicle; Full Random loads a new vehicle and scrambles its reachable tree.'},
            {id: 'locks', label: 'Locks'},
            {id: 'garage', label: 'Garage'},
            {id: 'compare', label: 'Compare'},
            {id: 'share', label: 'Share'},
            {id: 'lineup', label: 'Lineup', help: 'Generate a reusable roster of independently randomized competitors.'},
            {id: 'spawn', label: 'Spawn', help: 'Place confirmed lineup or Vehicle DNA entries safely and sequentially.'},
            {id: 'ai', label: 'AI', help: 'Drive confirmed managed vehicles to a destination or along a route.'}
          ],
          lockPresets: ['Everything', 'Visual', 'Mechanical', 'Accessories'],
          lockCategories: [
            {id: 'body', label: 'Body'}, {id: 'engine', label: 'Engine'},
            {id: 'transmission', label: 'Transmission'}, {id: 'drivetrain', label: 'Drivetrain'},
            {id: 'suspension', label: 'Suspension'}, {id: 'brakes', label: 'Brakes'},
            {id: 'steering', label: 'Steering'}, {id: 'wheels', label: 'Wheels'},
            {id: 'tires', label: 'Tires'}, {id: 'aero', label: 'Aero'},
            {id: 'interior', label: 'Interior'}, {id: 'electronics', label: 'Electronics'},
            {id: 'accessories', label: 'Accessories'}, {id: 'props', label: 'Props'},
            {id: 'other', label: 'Other'}, {id: 'tuning', label: 'Tuning'},
            {id: 'paint', label: 'Paint'}
          ],
          mutationStrengths: [
            {id: 'small', label: 'Small', help: 'Subtle 25% variation'},
            {id: 'medium', label: 'Medium', help: 'Noticeable 60% variation'},
            {id: 'wild', label: 'Wild', help: 'Maximum 100% variation'}
          ],
          advancedOpen: false,
          copyStatus: '',
          transferStatus: '',
          allowPartial: false,
          importText: '',
          exportText: '',
          dnaName: '',
          garageView: 'grid',
          garageQuery: {search: '', filter: 'all', sort: 'updated', model: '', tag: '', collection: ''},
          replayPolicy: 'original',
          lockData: null,
          dnaDetails: null,
          comparison: null,
          comparisonSection: '',
          mutationDNA: null,
          compareLeft: '',
          compareRight: '',
          shareId: '',
          metadata: {rating: '0', collection: '', tags: '', notes: ''},
          lineupPage: 0,
          managedIndex: 0,
          lineupOptions: {count: 4, preset: 'Balanced', episodeSeed: '', acceptPartial: false, acceptMetadataUncertain: false, acceptPotentiallyUndrivable: false, avoidDuplicateModels: true, avoidDuplicateConfigurations: true, avoidDuplicateFamilies: false, maximumSameFamily: 2, diversifyVehicleClasses: true, diversifyPropulsion: false, diversifyDrivetrain: false, diversifySource: true, diversifyWheelStyles: false, diversifyBodyTypes: false, allowOfficialVehicles: true, allowModVehicles: true, allowAutomationVehicles: false, allowTrailers: false, allowProps: false, maxAttemptsPerCompetitor: 3, maxConsecutiveFailures: 4},
          spawnOptions: {mode: 'Grid', count: 4, spacing: 7, rows: 2, columns: 2, radius: 14, headingMode: 'camera', headingOffset: 0, groundOffset: 0.2, minimumObjectDistance: 3, interval: 0.75, spawnAll: true, useNextLineupCompetitor: true, selectedDNAId: '', customPointX: 0, customPointY: 0, customPointZ: 0},
          aiOptions: {mode: 'Destination', speedKph: 65, speedMode: 'limit', aggression: 0.5, driveInLane: true, avoidCars: true, delay: 0, stagger: 0.5, arrivalRadius: 8, timeout: 600, finishAction: 'stop', loop: false, recoveryWhenStuck: false, stuckAction: 'none', stuckTimeout: 12, maxReplans: 2, allowDamagedVehicles: true, targetVehicleId: null, handles: []},
          state: {
            busy: false,
            uiMode: 'standard',
            operationState: 'loading',
            lifecyclePhase: 'idle',
            clocks: {paused: false, pauseKnown: false, realDelta: 0, simulationDelta: 0, frameCounter: 0},
            stalled: false,
            stalledWarning: false,
            progress: {label: 'Loading extension', value: 0},
            capabilities: {},
            lifecycle: {},
            transaction: null,
            locks: {summary: {}, categories: {}, vehicle: false, configuration: false},
            index: {models: 0, configurations: 0, blacklists: {}, sources: {}},
            garage: {entries: [], total: 0, page: 0, pageCount: 1, pendingSave: false, storage: {}},
            history: [],
            lineup: {current: null},
            spawnDirector: {managed: [], run: null},
            aiDirector: {capabilities: {}, vehicles: [], destination: {status: 'empty'}, route: {points: []}},
            settings: {
              schemaVersion: 5,
              chaos: 75,
              allowMissingParts: true,
              protectCriticalParts: false,
              contentFilter: 'everything',
              includeAutomation: false,
              includeTrailers: false,
              includeProps: false,
              selectionFairness: 'vehicle',
              diagnosticLogging: false,
              manualSeed: '',
              dnaLibraryLimit: 100,
              autoSaveDNA: false,
              defaultRestoreMode: 'exact',
              extremeTuning: false,
              allowPartialResult: false
            }
          }
        }

        function engineCall(method) {
          var allowed = {requestState: true, cancelCurrentOperation: true, getVehicleDNALocks: true, confirmVehicleDNAPackageImport: true, copyDiagnostics: true, spawnSafeVehicle: true, retryQuarantinedConfigurations: true, exportChaosLineup: true, importChaosLineup: true, cancelLineupSpawn: true, placeAIDestination: true, clearAIDestination: true, addAIRoutePoint: true, pauseManagedAI: true, resumeManagedAI: true, stopManagedAI: true, resetManagedAI: true}
          if (!allowed[method]) return
          bngApi.engineLua('if soturineChaosRandomizer then soturineChaosRandomizer.' + method + '() end')
        }

        function callWithArgs(method, args) {
          var allowed = {
            runAction: true,
            rerollUnlocked: true,
            saveVehicleDNA: true,
            deleteVehicleDNA: true,
            renameVehicleDNA: true,
            setVehicleDNAFavorite: true,
            setVehicleDNAPinned: true,
            setVehicleDNARating: true,
            setVehicleDNATags: true,
            setVehicleDNACollection: true,
            setVehicleDNANotes: true,
            duplicateVehicleDNA: true,
            setVehicleDNAQuery: true,
            getVehicleDNADetails: true,
            compareVehicleDNA: true,
            importVehicleDNA: true,
            exportVehicleDNAJson: true,
            exportVehicleDNAPackage: true,
            importVehicleDNAPackage: true,
            captureVehicleDNAThumbnail: true,
            removeVehicleDNAThumbnail: true,
            preflightVehicleDNA: true,
            replayVehicleDNAGeneration: true,
            pureSeedReplayVehicleDNA: true,
            mutateVehicleDNA: true,
            restoreVehicleDNA: true,
            setVehicleDNAPage: true,
            lockVehicle: true,
            lockConfiguration: true,
            lockCategory: true,
            lockSlot: true,
            unlockSlot: true,
            lockPart: true,
            lockCurrentParts: true,
            lockTuning: true,
            lockPaint: true,
            applyLockPreset: true,
            updateLockProfile: true,
            setUICompactMode: true,
            createChaosLineup: true,
            renameLineupCompetitor: true,
            resolveLineupFailure: true,
            previewLineupSpawn: true,
            startLineupSpawn: true,
            removeManagedVehicle: true,
            respawnManagedVehicle: true,
            confirmAIDestination: true,
            editAIRoute: true,
            startManagedAI: true,
            setAIRecording: true
          }
          if (!allowed[method]) return
          var serialized = (args || []).map(function (value) { return bngApi.serializeToLua(value) })
          bngApi.engineLua('if soturineChaosRandomizer then soturineChaosRandomizer.' + method + '(' + serialized.join(', ') + ') end')
        }

        function cancelSettingsTimer() {
          if (!settingsTimer) return
          $timeout.cancel(settingsTimer)
          settingsTimer = null
        }

        function cancelQueryTimer() {
          if (!queryTimer) return
          $timeout.cancel(queryTimer)
          queryTimer = null
        }

        function requestState() { engineCall('requestState') }

        function applyState(data) {
          if (!data) return
          scope.$evalAsync(function () {
            scope.chaos.state = data
            if (!scope.chaos.dnaName && data.garage && data.garage.pending) scope.chaos.dnaName = data.garage.pending.name || ''
            if (!scope.chaos.shareId && data.garage && data.garage.selectedId) scope.chaos.shareId = data.garage.selectedId
          })
        }

        function persistSettings() {
          settingsTimer = null
          var settings = angular.copy(scope.chaos.state.settings || {})
          bngApi.engineLua('if soturineChaosRandomizer then soturineChaosRandomizer.updateSettings(' + bngApi.serializeToLua(settings) + ') end')
        }

        function copyText(value, callback) {
          if (!value) { callback(false); return }
          var input = document.createElement('textarea')
          input.value = value
          input.setAttribute('readonly', '')
          input.style.position = 'fixed'
          input.style.opacity = '0'
          document.body.appendChild(input)
          input.select()
          var copied = false
          try { copied = document.execCommand('copy') } catch (error) { copied = false }
          document.body.removeChild(input)
          callback(copied)
        }

        function tagsFromText(text) {
          var unique = {}
          return String(text || '').split(',').map(function (tag) { return tag.trim() }).filter(function (tag) {
            var key = tag.toLowerCase()
            if (!tag || tag.length > 64 || unique[key]) return false
            unique[key] = true
            return true
          }).slice(0, 16)
        }

        function refreshLocksSoon() { $timeout(scope.chaos.requestLocks, 180) }

        scope.chaos.thumbnailUrl = function (dna) {
          var id = dna && dna.thumbnail && dna.thumbnail.kind === 'managed' ? String(dna.thumbnail.managedId || '') : ''
          if (!/^[A-Za-z0-9_-]{1,96}$/.test(id)) return ''
          return '/settings/soturineChaosRandomizer/vehicleDNA/thumbnails/' + id + '.png'
        }

        scope.chaos.fallbackColor = function (dna) {
          var color = dna && dna.thumbnail && dna.thumbnail.color
          if (!Array.isArray(color) || color.length < 3) return 'rgb(224, 91, 28)'
          var channels = color.slice(0, 3).map(function (value) { return Math.max(0, Math.min(255, Math.round(Number(value) * 255))) })
          return 'rgb(' + channels.join(',') + ')'
        }

        scope.chaos.scheduleSettings = function () {
          if (scope.chaos.state.busy) return
          cancelSettingsTimer()
          settingsTimer = $timeout(persistSettings, 250)
        }

        scope.chaos.run = function (action) {
          if (scope.chaos.state.busy) return
          var allowed = {randomConfig: true, scramble: true, fullRandom: true, undo: true, reindex: true}
          if (!allowed[action]) return
          cancelSettingsTimer()
          var settings = angular.copy(scope.chaos.state.settings || {})
          callWithArgs('runAction', [action, settings])
        }

        scope.chaos.toggleAdvanced = function () { scope.chaos.advancedOpen = !scope.chaos.advancedOpen }
        scope.chaos.setMode = function (mode) {
          var allowed = {collapsed: true, compact: true, standard: true, expanded: true}
          if (!allowed[mode]) return
          callWithArgs('setUICompactMode', [mode])
        }
        scope.chaos.spawnSafeVehicle = function () { if (!scope.chaos.state.busy) engineCall('spawnSafeVehicle') }
        scope.chaos.retryQuarantined = function () { if (!scope.chaos.state.busy) engineCall('retryQuarantinedConfigurations') }
        scope.chaos.copyDiagnostics = function () { engineCall('copyDiagnostics') }

        scope.chaos.rerollUnlocked = function () {
          if (scope.chaos.state.busy) return
          cancelSettingsTimer()
          callWithArgs('rerollUnlocked', [{}])
        }

        scope.chaos.rerollFromDNA = function (dna) {
          if (!dna || scope.chaos.state.busy) return
          callWithArgs('rerollUnlocked', [{parentDNAId: dna.id}])
          scope.chaos.dnaDetails = null
          scope.chaos.view = 'randomize'
        }

        scope.chaos.cancelCurrent = function () {
          if (scope.chaos.state.busy && window.confirm('Cancel this operation and restore the previous vehicle?')) engineCall('cancelCurrentOperation')
        }

        scope.chaos.openView = function (view) {
          var allowed = {randomize: true, locks: true, garage: true, compare: true, share: true, lineup: true, spawn: true, ai: true}
          if (!allowed[view]) return
          scope.chaos.view = view
          if (view === 'locks') $timeout(scope.chaos.requestLocks, 0)
        }

        scope.chaos.copySeed = function () {
          copyText(scope.chaos.state.seed || '', function (copied) {
            scope.chaos.copyStatus = copied ? 'Copied' : 'Copy unavailable'
            $timeout(function () { scope.chaos.copyStatus = '' }, 1800)
          })
        }

        scope.chaos.createLineup = function () { if (!scope.chaos.state.busy) callWithArgs('createChaosLineup', [angular.copy(scope.chaos.lineupOptions)]) }
        scope.chaos.exportLineup = function () { engineCall('exportChaosLineup') }
        scope.chaos.importLineup = function () { engineCall('importChaosLineup') }
        scope.chaos.renameCompetitor = function (competitor) {
          if (!competitor) return
          var name = window.prompt('Competitor name', competitor.name)
          if (name) callWithArgs('renameLineupCompetitor', [competitor.index, name])
        }
        scope.chaos.lineupFailure = function (competitor, action) {
          var allowed = {retry: true, skip: true, fallback: true, stop: true}
          if (competitor && allowed[action]) callWithArgs('resolveLineupFailure', [competitor.index, action])
        }
        scope.chaos.lineupPageCount = function () {
          var count = scope.chaos.state.lineup && scope.chaos.state.lineup.current && scope.chaos.state.lineup.current.competitors.length || 0
          return Math.max(1, Math.ceil(count / 8))
        }
        scope.chaos.previewSpawn = function () { callWithArgs('previewLineupSpawn', [angular.copy(scope.chaos.spawnOptions)]) }
        scope.chaos.startSpawn = function () { callWithArgs('startLineupSpawn', [angular.copy(scope.chaos.spawnOptions)]) }
        scope.chaos.cancelSpawn = function () { engineCall('cancelLineupSpawn') }
        scope.chaos.removeManaged = function (managed) {
          if (managed && window.confirm('Remove only this managed vehicle?')) callWithArgs('removeManagedVehicle', [managed.handle])
        }
        scope.chaos.respawnManaged = function (managed) {
          if (managed) callWithArgs('respawnManagedVehicle', [managed.handle])
        }
        scope.chaos.placeDestination = function () { engineCall('placeAIDestination') }
        scope.chaos.confirmDestination = function (mode) {
          if (mode === 'exact' || mode === 'snap') callWithArgs('confirmAIDestination', [mode])
        }
        scope.chaos.clearDestination = function () { engineCall('clearAIDestination') }
        scope.chaos.addRoutePoint = function () { engineCall('addAIRoutePoint') }
        scope.chaos.editRoute = function (action) {
          if ({remove: true, reverse: true, clear: true}[action]) callWithArgs('editAIRoute', [action])
        }
        scope.chaos.startAI = function () {
          var options = angular.copy(scope.chaos.aiOptions)
          options.speed = Math.max(0, Math.min(432, Number(options.speedKph) || 0)) / 3.6
          delete options.speedKph
          callWithArgs('startManagedAI', [options])
        }
        scope.chaos.aiControl = function (action) {
          var allowed = {pause: 'pauseManagedAI', resume: 'resumeManagedAI', stop: 'stopManagedAI', reset: 'resetManagedAI'}
          if (allowed[action]) engineCall(allowed[action])
        }
        scope.chaos.setRecording = function (managed, enabled) { if (managed) callWithArgs('setAIRecording', [managed.handle, enabled === true]) }
        scope.chaos.readyManagedCount = function () {
          return (scope.chaos.state.spawnDirector && scope.chaos.state.spawnDirector.managed || []).filter(function (entry) { return entry.status === 'ready' }).length
        }
        scope.chaos.managedStep = function (delta) {
          var managed = scope.chaos.state.spawnDirector && scope.chaos.state.spawnDirector.managed || []
          if (!managed.length) { scope.chaos.managedIndex = 0; return }
          scope.chaos.managedIndex = (scope.chaos.managedIndex + delta + managed.length) % managed.length
        }
        scope.chaos.compactManagedLabel = function () {
          var managed = scope.chaos.state.spawnDirector && scope.chaos.state.spawnDirector.managed || []
          if (!managed.length) return '0/0  No managed vehicle'
          var index = Math.max(0, Math.min(managed.length - 1, scope.chaos.managedIndex))
          var entry = managed[index]
          return (index + 1) + '/' + managed.length + '  ' + (entry.metadata && entry.metadata.name || entry.handle)
        }

        scope.chaos.saveDNA = function () {
          if (scope.chaos.state.busy) return
          callWithArgs('saveVehicleDNA', [scope.chaos.dnaName || 'Vehicle DNA'])
          scope.chaos.dnaName = ''
        }

        scope.chaos.requestLocks = function () { if (!scope.chaos.state.busy) engineCall('getVehicleDNALocks') }

        scope.chaos.setTopLock = function (kind, locked) {
          if (scope.chaos.state.busy) return
          if (kind === 'vehicle') callWithArgs('lockVehicle', [locked === true])
          if (kind === 'configuration') callWithArgs('lockConfiguration', [locked === true])
          refreshLocksSoon()
        }

        scope.chaos.toggleCategory = function (category) {
          if (scope.chaos.state.busy) return
          var categories = scope.chaos.state.locks.categories || {}
          callWithArgs('lockCategory', [category, categories[category] !== true])
          refreshLocksSoon()
        }

        scope.chaos.applyLockPreset = function (name) {
          if (!scope.chaos.state.busy) { callWithArgs('applyLockPreset', [String(name || '').toLowerCase()]); refreshLocksSoon() }
        }

        scope.chaos.lockAll = function () {
          var categories = {}
          scope.chaos.lockCategories.forEach(function (category) { categories[category.id] = true })
          callWithArgs('updateLockProfile', [{vehicle: true, configuration: true, categories: categories}])
          refreshLocksSoon()
        }

        scope.chaos.unlockAll = function () {
          callWithArgs('updateLockProfile', [{vehicle: false, configuration: false, categories: {}, slots: {}, parts: {}, tuning: {}, paints: {}}])
          refreshLocksSoon()
        }

        scope.chaos.invertCategories = function () {
          var current = scope.chaos.state.locks.categories || {}
          var categories = {}
          scope.chaos.lockCategories.forEach(function (category) { if (!current[category.id]) categories[category.id] = true })
          callWithArgs('updateLockProfile', [{categories: categories}])
          refreshLocksSoon()
        }

        scope.chaos.lockCategoryGroup = function (ids) {
          var categories = angular.copy(scope.chaos.state.locks.categories || {})
          ids.forEach(function (id) { categories[id] = true })
          callWithArgs('updateLockProfile', [{categories: categories}])
          refreshLocksSoon()
        }

        scope.chaos.lockCurrentParts = function () { if (!scope.chaos.state.busy) { callWithArgs('lockCurrentParts', []); refreshLocksSoon() } }

        scope.chaos.lockedSlotCount = function () {
          return (scope.chaos.lockData && scope.chaos.lockData.slots || []).filter(function (slot) { return slot.locked }).length
        }

        scope.chaos.unlockedSlotCount = function () {
          return (scope.chaos.lockData && scope.chaos.lockData.slots || []).filter(function (slot) { return !slot.locked }).length
        }

        scope.chaos.toggleSlot = function (slot) {
          if (!slot || scope.chaos.state.busy) return
          callWithArgs(slot.locked ? 'unlockSlot' : 'lockSlot', [slot.path])
          refreshLocksSoon()
        }

        scope.chaos.lockPart = function (slot) {
          if (!slot || !slot.partName || scope.chaos.state.busy) return
          callWithArgs('lockPart', [slot.path, true])
          refreshLocksSoon()
        }

        scope.chaos.scheduleGarageQuery = function () {
          cancelQueryTimer()
          queryTimer = $timeout(scope.chaos.sendGarageQuery, 220)
        }

        scope.chaos.sendGarageQuery = function () {
          cancelQueryTimer()
          callWithArgs('setVehicleDNAQuery', [angular.copy(scope.chaos.garageQuery)])
        }

        scope.chaos.selectDNA = function (dna) {
          if (!dna) return
          scope.chaos.shareId = dna.id
          callWithArgs('getVehicleDNADetails', [dna.id])
        }

        scope.chaos.closeDetails = function () { scope.chaos.dnaDetails = null }

        scope.chaos.restoreDNA = function (dna, mode) {
          if (!dna || scope.chaos.state.busy) return
          callWithArgs('preflightVehicleDNA', [dna.id, mode])
          scope.chaos.allowPartial = false
          scope.chaos.view = 'garage'
        }

        scope.chaos.confirmRestore = function (mode) {
          var garage = scope.chaos.state.garage || {}
          var report = garage.preflight
          var id = garage.selectedId
          if (!id || !report || scope.chaos.state.busy) return
          var message = mode === 'compatible'
            ? 'Apply this compatible restore? Every omission and clamp shown above will be recorded.'
            : 'Apply this exact Vehicle DNA snapshot? Any divergence will trigger rollback.'
          if (window.confirm(message)) callWithArgs('restoreVehicleDNA', [id, mode, mode === 'compatible' && scope.chaos.allowPartial === true])
        }

        scope.chaos.replayDNA = function (dna) {
          if (!dna || scope.chaos.state.busy) return
          callWithArgs('replayVehicleDNAGeneration', [dna.id, scope.chaos.replayPolicy === 'current' ? 'current' : 'original'])
        }

        scope.chaos.pureSeedReplayDNA = function (dna) {
          if (!dna || scope.chaos.state.busy) return
          if (window.confirm('Pure Seed Replay can select a different snapshot when content or algorithms changed. Continue?')) callWithArgs('pureSeedReplayVehicleDNA', [dna.id])
        }

        scope.chaos.prepareMutation = function (dna) { if (dna) scope.chaos.mutationDNA = dna }

        scope.chaos.mutateDNA = function (strength) {
          var dna = scope.chaos.mutationDNA
          if (!dna || scope.chaos.state.busy) return
          callWithArgs('mutateVehicleDNA', [dna.id, strength, {}])
          scope.chaos.mutationDNA = null
          scope.chaos.view = 'randomize'
        }

        scope.chaos.mutateSelectedDNA = function (strength) {
          var id = scope.chaos.state.garage && scope.chaos.state.garage.selectedId
          if (id && !scope.chaos.state.busy) callWithArgs('mutateVehicleDNA', [id, strength, {}])
        }

        scope.chaos.renameDNA = function (dna) {
          if (!dna || scope.chaos.state.busy) return
          var name = window.prompt('Vehicle DNA name', dna.name)
          if (name) callWithArgs('renameVehicleDNA', [dna.id, name])
        }

        scope.chaos.toggleFavoriteDNA = function (dna) { if (dna && !scope.chaos.state.busy) callWithArgs('setVehicleDNAFavorite', [dna.id, !dna.favorite]) }
        scope.chaos.togglePinnedDNA = function (dna) { if (dna && !scope.chaos.state.busy) callWithArgs('setVehicleDNAPinned', [dna.id, !dna.pinned]) }

        scope.chaos.duplicateDNA = function (dna) { if (dna && !scope.chaos.state.busy) callWithArgs('duplicateVehicleDNA', [dna.id]) }

        scope.chaos.deleteDNA = function (dna) {
          if (dna && !scope.chaos.state.busy && window.confirm('Delete "' + dna.name + '"? Its children will remain and record a missing parent.')) {
            callWithArgs('deleteVehicleDNA', [dna.id])
            scope.chaos.dnaDetails = null
          }
        }

        scope.chaos.saveRating = function () {
          if (scope.chaos.dnaDetails) callWithArgs('setVehicleDNARating', [scope.chaos.dnaDetails.entry.id, Number(scope.chaos.metadata.rating) || 0])
        }
        scope.chaos.saveCollection = function () {
          if (scope.chaos.dnaDetails) callWithArgs('setVehicleDNACollection', [scope.chaos.dnaDetails.entry.id, scope.chaos.metadata.collection || ''])
        }
        scope.chaos.saveTags = function () {
          if (scope.chaos.dnaDetails) callWithArgs('setVehicleDNATags', [scope.chaos.dnaDetails.entry.id, tagsFromText(scope.chaos.metadata.tags)])
        }
        scope.chaos.saveNotes = function () {
          if (scope.chaos.dnaDetails) callWithArgs('setVehicleDNANotes', [scope.chaos.dnaDetails.entry.id, scope.chaos.metadata.notes || ''])
        }

        scope.chaos.captureThumbnail = function (dna) { if (dna && !scope.chaos.state.busy) callWithArgs('captureVehicleDNAThumbnail', [dna.id]) }
        scope.chaos.captureNonExactThumbnail = function (dna) {
          if (dna && !scope.chaos.state.busy && window.confirm('Capture a clearly marked non-exact thumbnail for this Vehicle DNA?')) {
            callWithArgs('captureVehicleDNAThumbnail', [dna.id, {allowNonExact: true}])
          }
        }
        scope.chaos.removeThumbnail = function (dna) { if (dna && !scope.chaos.state.busy) callWithArgs('removeVehicleDNAThumbnail', [dna.id]) }

        scope.chaos.compareDNA = function () {
          if (scope.chaos.compareLeft && scope.chaos.compareRight && scope.chaos.compareLeft !== scope.chaos.compareRight) {
            callWithArgs('compareVehicleDNA', [scope.chaos.compareLeft, scope.chaos.compareRight])
          }
        }

        scope.chaos.differenceFilter = function (difference) {
          return !scope.chaos.comparisonSection || (difference && difference.section === scope.chaos.comparisonSection)
        }

        scope.chaos.displayDiff = function (value) {
          if (value === undefined || value === null) return '-'
          var result
          try { result = typeof value === 'object' ? JSON.stringify(value) : String(value) } catch (error) { result = '[unavailable]' }
          return result.length > 160 ? result.slice(0, 157) + '...' : result
        }

        scope.chaos.useLeftAsBase = function () {
          if (!scope.chaos.comparison || scope.chaos.state.busy) return
          callWithArgs('preflightVehicleDNA', [scope.chaos.comparison.leftId, 'compatible'])
          scope.chaos.view = 'garage'
        }

        scope.chaos.mutateComparisonBase = function () {
          if (!scope.chaos.comparison) return
          scope.chaos.mutationDNA = {id: scope.chaos.comparison.leftId, name: scope.chaos.comparison.left.name}
          scope.chaos.view = 'garage'
        }

        scope.chaos.useInCompare = function (dna) {
          if (!dna) return
          if (!scope.chaos.compareLeft || scope.chaos.compareLeft === dna.id) scope.chaos.compareLeft = dna.id
          else scope.chaos.compareRight = dna.id
          scope.chaos.view = 'compare'
        }

        scope.chaos.shareDNA = function (dna) {
          if (!dna) return
          scope.chaos.shareId = dna.id
          scope.chaos.view = 'share'
        }

        scope.chaos.exportDNA = function (dna, writeFile) {
          if (!dna) return
          scope.chaos.shareId = dna.id
          scope.chaos.exportDNAById(writeFile)
        }

        scope.chaos.exportDNAById = function (writeFile) {
          if (!scope.chaos.shareId) return
          callWithArgs('exportVehicleDNAJson', [scope.chaos.shareId, writeFile === true])
          scope.chaos.transferStatus = writeFile ? 'Writing the fixed .vdna.json export file...' : 'Preparing validated JSON...'
        }

        scope.chaos.exportPackage = function () {
          if (scope.chaos.shareId) callWithArgs('exportVehicleDNAPackage', [scope.chaos.shareId])
        }

        scope.chaos.copyExport = function () {
          copyText(scope.chaos.exportText || '', function (copied) {
            scope.chaos.transferStatus = copied ? 'Vehicle DNA JSON copied.' : 'Clipboard copy is unavailable.'
          })
        }

        scope.chaos.importDNA = function () {
          var text = scope.chaos.importText || ''
          if (!text || text.length > 131072) { scope.chaos.transferStatus = 'Import must be between 1 and 131072 characters.'; return }
          var parsed
          try { parsed = JSON.parse(text) } catch (error) { scope.chaos.transferStatus = 'Import is not valid JSON.'; return }
          if (!parsed || Array.isArray(parsed) || typeof parsed !== 'object') { scope.chaos.transferStatus = 'Import must contain one JSON object.'; return }
          callWithArgs('importVehicleDNA', [parsed])
          scope.chaos.importText = ''
          scope.chaos.transferStatus = 'Import submitted for schema validation.'
        }

        scope.chaos.previewPackageImport = function () { callWithArgs('importVehicleDNAPackage', ['inbox']) }
        scope.chaos.confirmPackageImport = function () {
          if (scope.chaos.state.garage.importPreview && window.confirm('Import this validated Vehicle DNA package into the Garage?')) engineCall('confirmVehicleDNAPackageImport')
        }

        scope.chaos.dnaPage = function (delta) {
          var page = Math.max(0, (scope.chaos.state.garage.page || 0) + delta)
          callWithArgs('setVehicleDNAPage', [page])
        }

        scope.$on('SoturineChaosRandomizerState', function (event, data) { applyState(data) })
        scope.$on('SoturineChaosRandomizerLocks', function (event, data) { scope.$evalAsync(function () { scope.chaos.lockData = data }) })
        scope.$on('SoturineChaosRandomizerDNADetails', function (event, data) {
          scope.$evalAsync(function () {
            scope.chaos.dnaDetails = data
            var entry = data && data.entry ? data.entry : {}
            scope.chaos.metadata = {
              rating: String(entry.rating || 0),
              collection: entry.collection || '',
              tags: (entry.tags || []).join(', '),
              notes: entry.notes || ''
            }
          })
        })
        scope.$on('SoturineChaosRandomizerDNAComparison', function (event, data) { scope.$evalAsync(function () { scope.chaos.comparison = data }) })
        scope.$on('SoturineChaosRandomizerDNAExport', function (event, data) {
          scope.$evalAsync(function () { scope.chaos.exportText = data && data.text ? data.text : '' })
        })
        scope.$on('SoturineChaosRandomizerDiagnostics', function (event, data) {
          copyText(data && data.text ? data.text : '', function (copied) {
            scope.chaos.copyStatus = copied ? 'Diagnostics copied' : 'Copy unavailable'
          })
        })
        scope.$on('VehicleFocusChanged', function () { $timeout(requestState, 250) })
        scope.$on('$destroy', function () {
          cancelSettingsTimer()
          cancelQueryTimer()
        })

        bngApi.engineLua('extensions.load("soturineChaosRandomizer")')
        $timeout(requestState, 100)
        $timeout(requestState, 800)
      }
    }
  }])
})()
