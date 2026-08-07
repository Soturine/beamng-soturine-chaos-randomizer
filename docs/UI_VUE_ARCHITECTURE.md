# Native Vue UI architecture

One native Runtime UI Vue app is colocated with its stable `app.json`. There is
no Angular wrapper, iframe, secondary selector, runtime npm dependency, or
parallel event subscription.

```text
app.json -> app.vue -> AppShell
                    |-> app/tab/Race-step ErrorBoundary
                    |-> Chaos, Garage, Race, Settings views
                    |-> normalized domain stores
                    |-> commandBridge / stateProtocol / statusLifecycle
                    `-> internal i18n and responsive layout
```

`commandBridge` serializes one allowlisted protocol-v2 envelope and calls only
`dispatchUICommand`. `stateProtocol` accepts full/reset/diff envelopes, rejects
stale state, and requests one full snapshot after a version gap. Domain stores
own backend projections; ephemeral selection, disclosure, and layout state stay
local to components.

Map-or-array state from Lua is normalized at ingress. Components still accept
empty/malformed optional collections and surface a safe state instead of
throwing. Error boundaries preserve the shell, other tabs, and diagnostic
actions when a view render fails.

All selection controls use `ScrSelect` over BeamNG `BngSmartSelect`. UINav,
Back, focus, and disabled/empty behavior follow the host component. Compact mode
uses per-tab internal metrics and content changes. The AppHost retains authority
over the outer frame, UI scale, alignment, and safe zones.

`app.vue` imports one packaged plain-CSS asset. There is no SCSS runtime source,
Sass build step, remote asset, or source map in the mod ZIP. Graph/style gates
validate both source and packaged topology.

Every listener, observer, timer, status expiry, and bridge subscription returns
an explicit disposer. Automated mount/remount and 100-cycle tests verify the
resource baseline. Real AppHost layout and controller behavior remain
**Pending owner validation**.
