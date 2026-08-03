# v0.7.2 Runtime UI report

Automated status: **Passed in source tests**. Live status: **Pending owner
validation**.

- `app.vue` imports `./styles/app.css`; no runtime `.scss` file exists.
- Source and extracted-ZIP validators traverse CSS imports and `url()` assets,
  reject Sass/source maps/remote URLs/missing paths, and require critical style
  contracts for shell, navigation, buttons, cards, fox, and scroll container.
- Vue Test Utils mounts the real AppShell with runtime mocks and verifies panel
  navigation, language, details, state/diff application, ResizeObserver
  coalescing, subscription cleanup, and 100 mount/unmount cycles.
- Tab changes and Details are local UI state changes and do not request a full
  backend snapshot. Domain diffs update only the named store.

Headless visual screenshot tests: Not implemented

