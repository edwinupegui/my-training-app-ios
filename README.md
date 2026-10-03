# my-training-app-ios

**F1/F2 shell implemented:** this repository contains a minimal native SwiftUI app shell with localized Routine, History, and Settings tabs, a Training overview placeholder, and launch/navigation UI smoke tests. Actual routine browsing, workout tracking, history data, settings functions, persistence, timers, backup, and other product features remain unimplemented. The product described below is still a plan, not a claim that those capabilities exist.

The intended app starts from the current Spanish-language training routine, supports per-session adjustments, and records performed work without rewriting the prescription or history. The reference is a static Astro site; the plan reuses content semantics only, not its HTML, CSS, images, or personal measurements.

## Project guide

1. [Product scope](docs/product-scope.md) — users, boundaries, requirements, and acceptance.
2. [Architecture and data](docs/architecture.md) — planned Swift stack, entities, persistence, recovery, and backup.
3. [Liquid Glass design](docs/liquid-glass-design.md) — native surfaces, accessibility, and performance checks.
4. [Implementation roadmap](docs/implementation-roadmap.md) — gated work units and future RED/GREEN/device acceptance.
5. [iOS foundation record](docs/ios-foundation.md) — F1/F2 build/test commands, observed RED/GREEN results, and pending physical checks.
6. [Research and private installation](docs/research-and-private-installation.md) — evidence date, toolchain, unresolved choices, and signing/install steps.

Some source links point to the sibling `edwin-training-app` checkout and work only when both repositories are present in the expected local layout. GitHub cannot navigate those sibling paths from this repository alone; they are reference locators, not remote links or dependencies.

## Confirmed direction

| Topic | Current direction |
|---|---|
| Platform | iPhone only; iOS 27.0 minimum approved for the initial simulator-first foundation. |
| Product | Planned native SwiftUI experience with a strong, authentic Liquid Glass identity; the current app provides only native placeholder navigation and no feature behavior. |
| Data | Planned on-device data with explicit manual export/import; no account, backend, App Store, or TestFlight. No durable data store exists yet. |
| Training | Planned start from the current routine with session-only changes; routine editor deferred. |
| F1 authorization | Owner approved minimal simulator-first foundation on 2026-10-02. Bundle ID `org.example.trainingapp.simulator` is provisional and simulator-only; signing team/provisioning and owned bundle identity are deferred until physical installation. |
| F2 authorization | Owner authorized only the native placeholder tab/detail shell and navigation smoke tests; remaining product features are still planned. |
| Provenance | Foundation shell, localized placeholder tabs/detail, and launch/navigation smoke tests only; all product features remain planned. |

Recommendations needing a decision are labelled **Proposed**; do not treat them as approved requirements.

## Important limits

- The app provides native tab and detail navigation to honest placeholders; it does not yet provide routine content, workout tracking, history records, settings functions, or persistence.
- Do not place private body measurements, credentials, signing identities, real backups, or device identifiers in this repository or public sample data.
- “Local-only” means no app-operated service or sync. It does **not** currently mean records are excluded from iOS device backups.
- Manual file export can target a user-selected Files location, including a cloud-backed provider. The app will not sync automatically.
- Do not add production features until the open decisions in the [research guide](docs/research-and-private-installation.md) have been closed by the product owner.

## Reference and license

Read-only content reference: [`../edwin-training-app/src/pages/index.astro`](../edwin-training-app/src/pages/index.astro) and [`../edwin-training-app/src/data/exercises.ts`](../edwin-training-app/src/data/exercises.ts). These relative locators identify source context, not a dependency or permission to copy its presentation assets. No license or ownership claim is made here.
