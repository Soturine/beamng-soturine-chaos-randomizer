# Race policy inventory — v0.6.7

The v0.6.7 redesign preserves every policy control present before the redesign
and adds explicit participation/placement lifecycle controls. Values are kept
in the Angular app scope, persisted in the WebView's local storage, passed to
Lua on Generate Cars, saved in `lineup.settings` / `lineup.varietyRules`, and
retained by validated data-only lineup export/import.

| Option | Default | Lua effect |
|---|---:|---|
| `avoidDuplicateModels` | true | Rejects a model already accepted in the lineup |
| `avoidDuplicateConfigurations` | true | Rejects an accepted model/config pair |
| `avoidDuplicateFamilies` | false | Rejects a repeated verified family |
| `maximumSameFamily` | 2 | Bounds accepted competitors from one verified family |
| `diversifyVehicleClasses` | true | Prefers an unseen verified class |
| `diversifyPropulsion` | false | Prefers unseen verified propulsion |
| `diversifyDrivetrain` | false | Prefers unseen verified drivetrain |
| `diversifySource` | true | Prefers unseen official/mod source |
| `diversifyWheelStyles` | false | Prefers unseen verified wheel style |
| `diversifyBodyTypes` | false | Prefers unseen verified body type |
| `allowOfficialVehicles` | true | Includes official content |
| `allowModVehicles` | true | Includes mod content |
| `allowAutomationVehicles` | false | Explicit Automation opt-in |
| `allowTrailers` | false | Explicit trailer opt-in |
| `allowProps` | false | Explicit prop opt-in |
| `acceptPartial` | false | Allows an explicitly partial Race competitor/formation |
| `acceptMetadataUncertain` | false | Allows an explicit unknown-metadata warning result |
| `acceptPotentiallyUndrivable` | false | Allows the explicit warning classification |
| `maxAttemptsPerCompetitor` | 3 | Bounds retry attempts per slot |
| `maxConsecutiveFailures` | 4 | Stops an unhealthy generation sequence |
| `retainAcceptedOnCancel` | true | Keeps accepted managed cars on Race-only cancel |

Participation uses `countSemantics = total_vehicles`. In Player participates,
AI opponents equal total minus one; in Spectator / camera only, AI opponents
equal total. Formation, automatic/manual spacing, longitudinal/lateral values,
and safety margin are deterministic lineup settings and survive export/import.

Unknown trait metadata is never invented to satisfy a diversity preference.
The hard allow/duplicate rules stay authoritative; diversity rules only rank
eligible candidates. A preset is visible, and any manual edit changes the UI
state to `Custom`.
