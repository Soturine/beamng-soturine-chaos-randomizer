# v0.7.2 performance report

Automated status: **within the 50 ms local UI p95 budget in mounted jsdom
tests**. The release run measured tab-switch p95 9.9531 ms and local-button p95
8.1742 ms (synthetic jsdom timing). Live FPS/1% low/frame-time status:
**Pending owner validation**.

Tab and Details changes mutate local layout state. They do not fetch or apply a
full backend snapshot. Protocol diffs are domain-addressed and preserve other
domain object identities. Resize observation is deduplicated and committed by
one animation-frame callback; teardown cancels that callback and disconnects
the observer. Event subscriptions retain their unsubscribe handles and remove
them on unmount.

Race generation queues bounded work and advances at most the configured number
of jobs per frame. Retries, slots, candidates, operation time, callback count,
owned temporaries, and frame-budget overruns have explicit caps and telemetry.
Automated timing is a regression signal, not a BeamNG performance result.
