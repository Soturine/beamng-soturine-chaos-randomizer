# Safety Model

`Protect Critical Parts` is a conservative metadata safeguard. It does not certify drivability, physics stability, control availability, or compatibility with every third-party script.

## Evidence graph

Each fresh parts-tree snapshot becomes a graph of slot nodes and parent-child edges. Nodes retain required/core flags, selected part, evidence source, and zero or more functional roles:

- electric, fuel, or other energy storage;
- electric, combustion, or other propulsion;
- power path, transmission, transfer, differential, and driven axle;
- steering, suspension, hub, wheel, tire/contact, and braking;
- control and attachment/tow linkage.

Evidence precedence is loaded candidate-part sections, hierarchy and required/core metadata, exact model type/category, then exact normalized slot terms as a conservative fallback. The fallback is recorded in `heuristicPaths`; broad substring matching is not used.

Candidate evidence belongs to that candidate. A current part's roles and source are never copied onto a replacement. When the current selection has a proven functional role, a protected replacement must expose all of those roles or the current/default part is preserved with a reason code.

## Dynamic profiles

| Profile | Evidence | Applicable policy |
| --- | --- | --- |
| `standard_road` | exact Car, Truck, Bus, or Motorcycle type | preserve baseline-proven energy/propulsion/power-path roles |
| `electric` | loaded electric storage or motor evidence | preserve baseline electric energy/propulsion/path; no fuel or gearbox requirement |
| `hybrid` | loaded electric and combustion propulsion evidence | preserve both baseline-proven paths |
| `automation` | exact Automation type | road evidence applies only when actually present |
| `trailer` | exact Trailer type | no engine/drivetrain requirement; required attachment roles remain protected |
| `prop` | exact Prop type | vehicle-system concepts are not applicable; required/core structure still applies |
| `special` | another exact nonempty type | conservative `uncertain` result unless structural evidence is unsafe |
| `unknown` | insufficient type/evidence | conservative `uncertain` result unless structural evidence is unsafe |

No profile assumes four wheels, a single motor, one storage device, a gearbox, a driveshaft, one differential, exactly two axles, steering, or a seat.

## Validation points and results

The baseline graph is captured from the loaded base state. A new graph is built after every verified parts reload and again before completion. Validation always rejects missing required/core slots and loss of required-role counts. With protection enabled, it also rejects loss of baseline-proven applicable energy, propulsion, and power-path roles.

Internal results are:

- `safe`: applicable baseline evidence remains present;
- `uncertain`: no unsafe loss was found, but metadata cannot support a stronger claim;
- `unsafe`: required/core or baseline-proven applicable evidence was lost; rollback is started;
- `not_applicable`: a prop has no applicable vehicle-function assertion, while structural checks still passed.

An `uncertain` or `not_applicable` result is never described as drivable. Only an interactive BeamNG test with logs can provide gameplay evidence, and the current matrix remains Pending.

## Determinism and scope

Safety inspection consumes no random values. Parent replacement still defers descendants, reloads once, and rebuilds both candidates and evidence before the next bounded pass. The graph evaluates only mounted metadata exposed by BeamNG; it does not open archives, download content, infer relationships from brands, or execute unbounded probes.
