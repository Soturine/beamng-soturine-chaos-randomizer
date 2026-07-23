(function () {
  'use strict'

  angular.module('beamng.apps').directive('soturineChaosRandomizer', ['$timeout', function ($timeout) {
    return {
      templateUrl: '/ui/modules/apps/soturineChaosRandomizer/app.html',
      replace: false,
      restrict: 'E',
      scope: false,
      link: function (scope) {
        var settingsTimer = null

        scope.chaos = {
          view: 'randomize',
          advancedOpen: false,
          copyStatus: '',
          transferStatus: '',
          importText: '',
          dnaName: '',
          state: {
            busy: false,
            operationState: 'loading',
            progress: {label: 'Loading extension', value: 0},
            capabilities: {},
            index: {models: 0, configurations: 0, blacklists: {}, sources: {}},
            garage: {entries: [], total: 0, page: 0, pageCount: 1, pendingSave: false},
            history: [],
            settings: {
              schemaVersion: 3,
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
              defaultRestoreMode: 'exact'
            }
          }
        }

        function engineCall(method) {
          bngApi.engineLua('if soturineChaosRandomizer then soturineChaosRandomizer.' + method + '() end')
        }

        function callWithArgs(method, args) {
          var allowed = {
            runAction: true,
            saveVehicleDNA: true,
            deleteVehicleDNA: true,
            renameVehicleDNA: true,
            setVehicleDNAFavorite: true,
            importVehicleDNA: true,
            exportVehicleDNA: true,
            preflightVehicleDNA: true,
            replayVehicleDNA: true,
            restoreVehicleDNA: true,
            setVehicleDNAPage: true
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

        function requestState() { engineCall('requestState') }

        function applyState(data) {
          if (!data) return
          scope.$evalAsync(function () {
            scope.chaos.state = data
            if (!scope.chaos.dnaName && data.garage && data.garage.pending) {
              scope.chaos.dnaName = data.garage.pending.name || ''
            }
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

        scope.chaos.openView = function (view) {
          if (view === 'randomize' || view === 'garage' || view === 'compatibility') scope.chaos.view = view
        }

        scope.chaos.toggleAdvanced = function () { scope.chaos.advancedOpen = !scope.chaos.advancedOpen }

        scope.chaos.copySeed = function () {
          copyText(scope.chaos.state.seed || '', function (copied) {
            scope.chaos.copyStatus = copied ? 'Copied' : 'Copy unavailable'
            $timeout(function () { scope.chaos.copyStatus = '' }, 1800)
          })
        }

        scope.chaos.saveDNA = function () {
          if (scope.chaos.state.busy) return
          callWithArgs('saveVehicleDNA', [scope.chaos.dnaName || 'Vehicle DNA'])
          scope.chaos.dnaName = ''
        }

        scope.chaos.selectDNA = function (dna) {
          if (!dna) return
          callWithArgs('preflightVehicleDNA', [dna.id, scope.chaos.state.settings.defaultRestoreMode || 'exact'])
          scope.chaos.view = 'compatibility'
        }

        scope.chaos.restoreDNA = function (dna, mode) {
          if (!dna || scope.chaos.state.busy) return
          callWithArgs('preflightVehicleDNA', [dna.id, mode])
          scope.chaos.view = 'compatibility'
        }

        scope.chaos.confirmRestore = function (mode) {
          var garage = scope.chaos.state.garage || {}
          var report = garage.preflight
          var id = garage.selectedId
          if (!id || !report || scope.chaos.state.busy) return
          var message = mode === 'compatible'
            ? 'Apply this compatible restore? Every omission and clamp shown in the preflight will be recorded.'
            : 'Apply this exact Vehicle DNA snapshot? Any divergence will trigger rollback.'
          if (window.confirm(message)) callWithArgs('restoreVehicleDNA', [id, mode, mode === 'compatible' && report.status === 'partial'])
        }

        scope.chaos.replayDNA = function (dna) { if (dna && !scope.chaos.state.busy) callWithArgs('replayVehicleDNA', [dna.id]) }

        scope.chaos.renameDNA = function (dna) {
          if (!dna || scope.chaos.state.busy) return
          var name = window.prompt('Vehicle DNA name', dna.name)
          if (name) callWithArgs('renameVehicleDNA', [dna.id, name])
        }

        scope.chaos.toggleFavoriteDNA = function (dna) {
          if (dna && !scope.chaos.state.busy) callWithArgs('setVehicleDNAFavorite', [dna.id, !dna.favorite])
        }

        scope.chaos.deleteDNA = function (dna) {
          if (dna && !scope.chaos.state.busy && window.confirm('Delete "' + dna.name + '"?')) callWithArgs('deleteVehicleDNA', [dna.id])
        }

        scope.chaos.exportDNA = function (dna, writeFile) {
          if (!dna) return
          callWithArgs('exportVehicleDNA', [dna.id, writeFile === true])
          scope.chaos.transferStatus = writeFile ? 'Writing the fixed Vehicle DNA export file…' : 'Preparing JSON…'
          scope.chaos.view = 'garage'
        }

        scope.chaos.copyExport = function () {
          copyText(scope.chaos.state.garage.exportText || '', function (copied) {
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

        scope.chaos.dnaPage = function (delta) {
          var page = Math.max(0, (scope.chaos.state.garage.page || 0) + delta)
          callWithArgs('setVehicleDNAPage', [page])
        }

        scope.$on('SoturineChaosRandomizerState', function (event, data) { applyState(data) })
        scope.$on('VehicleFocusChanged', function () { $timeout(requestState, 250) })
        scope.$on('$destroy', function () {
          cancelSettingsTimer()
        })

        bngApi.engineLua('extensions.load("soturineChaosRandomizer")')
        $timeout(requestState, 100)
        $timeout(requestState, 800)
      }
    }
  }])
})()
