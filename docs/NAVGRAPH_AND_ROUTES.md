# NavGraph and Routes

BeamNG's NavGraph is the internal drivable-road network used by AI, navigation,
and traffic. It is not the visual GPS line drawn on screen.

## Destination placement

`PLACE DESTINATION` uses the current camera position/forward vector and an
audited world raycast. The result is a preview, not an active destination. The
UI shows an exact surface point, the nearest available NavGraph point and snap
distance, then requires either **Use exact world point** or **Snap to
NavGraph**. Cancel/Clear removes the temporary marker and data.

The exact point is useful as user intent, but Destination mode still requires a
reachable NavGraph route. Choosing exact does not turn an off-road point into a
road path.

## Path calculation

`routePlanner.lua` finds the nearest road nodes for origin and destination and
calls the audited `map.getPath`. It rejects a missing/empty path as
`navgraph_route_unreachable`, rendered as **No reachable NavGraph route**. It
never draws or claims a route that was not returned.

User routes contain bounded inert `{x,y,z}` points. Each segment is calculated
against the NavGraph, adjacent duplicate nodes are removed, and a central node
limit prevents unbounded paths. Reverse operates on route points. Loop appends
the first point as the final segment and requests multiple laps only through
the audited path-driving API.

## Static destination versus moving target

- Destination and Route use static points/waypoints and NavGraph paths.
- Chase and Follow use a real vehicle target ID.
- A destination marker is never spawned as a fake vehicle or permanent prop.

When no route exists, the user can move the destination, add custom route
points, or use a capability-gated recorded/scripted path if a future audited
build supports it. Version 0.6.0 reports recorded/scripted playback unavailable.

## Cleanup and limitations

Markers use temporary debug drawing when present and are cleared by explicit
Clear and director stop/reset paths. No map files, roads, waypoints, or triggers
are permanently modified. Route reachability and AI interpretation depend on
the current map/build; automated graph doubles do not prove live behavior.
