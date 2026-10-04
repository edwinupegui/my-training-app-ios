# my-training-app-ios

**Current delivery:** the native SwiftUI shell, offline routine browsing, and offline exercise-guide catalog/navigation are implemented. The guide slice includes original bundled Spanish content and variant-specific navigation. Session logging, durable history, settings actions, persistence/recovery, rest timers, and backup are not implemented.

The owner authorized the first useful offline release incrementally on 2026-10-04. Its implementation is future work; this authorization is not evidence that those capabilities exist. Interrupted active sessions may continue, but no elapsed-duration pause state is authorized. The guide delivery chain (PR2–PR5) is merged; current main is `691b915`. iOS 27.0 is approved as the deployment minimum. See [scope](docs/product-scope.md) and the [roadmap](docs/implementation-roadmap.md) for boundaries and pending device checks.

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
| Product | Native shell, offline routine browsing, and offline guide catalog/navigation are implemented; first useful offline release behavior is authorized incrementally but not yet implemented. |
| Data | Planned on-device data with explicit manual export/import; no account, backend, App Store, or TestFlight. No durable data store exists yet. |
| Training | Planned start from the current routine with session-only changes; routine editor deferred. |
| F1 authorization | Owner approved minimal simulator-first foundation on 2026-10-02. Bundle ID `org.example.trainingapp.simulator` is provisional and simulator-only; signing team/provisioning and owned bundle identity are deferred until physical installation. |
| B1/B2 and guide authorizations | Owner authorized routine browsing, then the bounded offline guide catalog/navigation slice; both are implemented. |
| Provenance | Bundled routine titles, day labels, prescriptions and recovery rows come from the read-only source projection; no assets, markup, nutrition, metrics or personal data are copied. |

Recommendations needing a decision are labelled **Proposed**; do not treat them as approved requirements.

## Important limits

- Routine browsing and bundled exercise-guide navigation are available offline; workout tracking, durable history, settings actions, persistence/recovery, timers, and backup are not implemented.
- Do not place private body measurements, credentials, signing identities, real backups, or device identifiers in this repository or public sample data.
- “Local-only” means no app-operated service or sync. It does **not** currently mean records are excluded from iOS device backups.
- Manual file export can target a user-selected Files location, including a cloud-backed provider. The app will not sync automatically.
- The first useful offline release is authorized for incremental implementation, but that authorization does not close relevant backup/privacy choices or imply implementation is complete. No elapsed-duration pause state is authorized. Physical-device checks and signing/install choices remain open where applicable.

## Reference and license

Read-only content reference: [`../edwin-training-app/src/pages/index.astro`](../edwin-training-app/src/pages/index.astro) and [`../edwin-training-app/src/data/exercises.ts`](../edwin-training-app/src/data/exercises.ts). These relative locators identify source context, not a dependency or permission to copy its presentation assets. No license or ownership claim is made here.
