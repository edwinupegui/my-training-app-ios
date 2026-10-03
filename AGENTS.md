# Project agent routing

## Before work
- Read `docs/product-scope.md` and `docs/implementation-roadmap.md` before any task; preserve the planning-only boundary and close only decisions that affect the proposed work unit.
- For code changes, load both `training-ios-architecture` and `training-swift-quality`, then add each relevant cross-cutting skill below.
- For planning or source checks, load only matching skills; recheck source freshness before API-sensitive implementation and record the check date. Do not infer current APIs, OS support, or toolchain from the research snapshot.
- For behavior changes, load testing. For UI changes, load workout UX. For hot paths/history growth, load performance. For persistence/import/migration, load local-data-safety.
- When delegating, the parent must forward exact relevant `.pi/skills/<name>/SKILL.md` paths to workers; workers must not rediscover skill scope.

## Skill routing
| Skill path | Trigger condition |
|---|---|
| `.pi/skills/training-ios-architecture/SKILL.md` | Feature boundaries, domain model, state ownership, architecture or composition decisions. |
| `.pi/skills/training-swift-quality/SKILL.md` | Swift implementation/review, API design, compiler settings, ownership, concurrency or Sendable. |
| `.pi/skills/training-local-data-safety/SKILL.md` | SwiftData, transactions, migrations, durable recovery, export/import or restore. |
| `.pi/skills/training-ios-performance/SKILL.md` | Measured hot paths, SwiftUI updates/hitches, memory/energy, timer or history growth. |
| `.pi/skills/training-workout-ux/SKILL.md` | Workout flow, set entry, screen/navigation design, accessibility or Liquid Glass. |
| `.pi/skills/training-ios-testing/SKILL.md` | Behavior changes, test strategy, failure injection, lifecycle/recovery or verification reporting. |

These are passive instructions and routing hints, not automatic quality enforcement or implementation authorization. Pi recursively discovers project skills in `.pi/skills/`; run `/reload` once after creation and validate runtime discovery separately. Keep this routing table synchronized when skills change. Product standards do not approve app code, distribution, or unresolved support/signing/bundle choices.
