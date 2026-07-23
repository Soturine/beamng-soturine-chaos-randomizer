# Deterministic Mutations

A mutation creates a new Vehicle DNA child while leaving its saved parent unchanged. The operation first performs a read-only Compatible preflight, automatically loads the parent's saved model and base configuration, inspects the real target, then runs the normal bounded parts/tuning/paint and safety pipeline.

## Strengths and seeds

| Strength | Effective Chaos | Intent |
| --- | ---: | --- |
| Small | 25 | Subtle variation |
| Medium | 60 | Noticeable variation |
| Wild | 100 | Maximum bounded variation |

The mutation seed is derived from the generator contract, parent seed, parent ID, mutation index, and strength. Repeating those inputs yields the same seed and project-owned decisions. Content, BeamNG, or generator changes can still change availability; deterministic does not mean portable snapshot equality.

Each child records `parentId`, `rootId`, `generation`, `mutationIndex`, `mutationStrength`, `mutationSeed`, `parentSeed`, and `createdFrom`. Indices advance per parent. Lineage depth is capped at 32, storage is capped at 100 entries, and deleting a parent preserves children with `parentMissing=true`.

Reroll Unlocked can also create a child lineage when invoked with `parentDNAId`. It uses its own derived seed namespace, so it cannot collide with Small/Medium/Wild mutations.

No saved parent is edited in place. The generated child remains pending until the user explicitly saves it, just like other randomizer results.
