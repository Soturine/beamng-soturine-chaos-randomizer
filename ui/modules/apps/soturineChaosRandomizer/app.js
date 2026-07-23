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
          advancedOpen: false,
          copyStatus: '',
          state: {
            busy: false,
            operationState: 'loading',
            progress: {label: 'Loading extension', value: 0},
            capabilities: {},
            index: {models: 0, configurations: 0, blacklisted: 0},
            history: [],
            settings: {
              chaos: 75,
              allowMissingParts: true,
              keepVehicleDrivable: false,
              contentFilter: 'everything',
              includeAutomation: false,
              includeTrailers: false,
              includeProps: false,
              selectionFairness: 'vehicle',
              diagnosticLogging: false,
              manualSeed: ''
            }
          }
        }

        function engineCall(method) {
          bngApi.engineLua('if soturineChaosRandomizer then soturineChaosRandomizer.' + method + '() end')
        }

        function requestState() {
          engineCall('requestState')
        }

        function applyState(data) {
          if (!data) return
          scope.$evalAsync(function () {
            scope.chaos.state = data
          })
        }

        function persistSettings() {
          settingsTimer = null
          var settings = angular.copy(scope.chaos.state.settings || {})
          bngApi.engineLua('if soturineChaosRandomizer then soturineChaosRandomizer.updateSettings(' + bngApi.serializeToLua(settings) + ') end')
        }

        scope.chaos.scheduleSettings = function () {
          if (scope.chaos.state.busy) return
          if (settingsTimer) $timeout.cancel(settingsTimer)
          settingsTimer = $timeout(persistSettings, 250)
        }

        scope.chaos.run = function (action) {
          if (scope.chaos.state.busy) return
          var allowed = {
            randomConfig: true,
            scramble: true,
            fullRandom: true,
            undo: true,
            reindex: true
          }
          if (allowed[action]) engineCall(action)
        }

        scope.chaos.toggleAdvanced = function () {
          scope.chaos.advancedOpen = !scope.chaos.advancedOpen
        }

        scope.chaos.copySeed = function () {
          var value = scope.chaos.state.seed || ''
          if (!value) return
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
          scope.chaos.copyStatus = copied ? 'Copied' : 'Copy unavailable'
          $timeout(function () { scope.chaos.copyStatus = '' }, 1800)
        }

        scope.$on('SoturineChaosRandomizerState', function (event, data) {
          applyState(data)
        })

        scope.$on('VehicleFocusChanged', function () {
          $timeout(requestState, 250)
        })

        scope.$on('$destroy', function () {
          if (settingsTimer) $timeout.cancel(settingsTimer)
        })

        bngApi.engineLua('extensions.load("soturineChaosRandomizer")')
        $timeout(requestState, 100)
        $timeout(requestState, 800)
      }
    }
  }])
})()
