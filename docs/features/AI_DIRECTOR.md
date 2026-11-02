# AI Director

AI Director controls only confirmed managed vehicles. Destination, Route, Chase, Follow, Traffic, group controls, stagger, arrival, and stuck policies are enabled only when their BeamNG capabilities are available.

An AI pause command does not pause game simulation. Recorded route replays a path the player drove (BeamNG scriptai recorder, bounded to 600 points). Scripted (free-form) paths are not offered: Route already drives user-placed points. The AI mode of each car is confirmed from Vehicle Lua `ai.mode`; no reply stays unconfirmed, never "running" by assumption.

See [AI Director details](../AI_DIRECTOR.md) and [NavGraph and Routes](../NAVGRAPH_AND_ROUTES.md).
