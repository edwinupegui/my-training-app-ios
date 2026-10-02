# my-training-app-ios

**Planning only:** this independent repository documents a proposed private, offline-first native iPhone training app. No app behavior, Swift source, or Xcode project is implemented here. Every feature below is planned until a later implementation and its acceptance checks exist.

The app is intended to start from the current Spanish-language training routine, support per-session adjustments, and record performed work without rewriting the prescription or history. Initial interface language may remain Spanish. The reference is a static Astro site; this plan reuses content semantics only, not its HTML, CSS, images, or personal measurements.

## Read this plan

1. [Product scope](docs/product-scope.md) — users, boundaries, requirements, and acceptance.
2. [Architecture and data](docs/architecture.md) — planned Swift stack, entities, persistence, recovery, and backup.
3. [Liquid Glass design](docs/liquid-glass-design.md) — native surfaces, accessibility, and performance checks.
4. [Implementation roadmap](docs/implementation-roadmap.md) — sequenced work units and future RED/GREEN and device acceptance.
5. [Research and private installation](docs/research-and-private-installation.md) — evidence date, toolchain, unresolved choices, and signing/install steps.

## Confirmed direction

| Topic | Current direction |
|---|---|
| Platform | iPhone 17; iOS 27.0.1 is user-reported, not independently device-verified. |
| Product | Native SwiftUI experience with a strong, authentic Liquid Glass identity. |
| Data | Local-only, with explicit manual export/import; no account, backend, App Store, or TestFlight. |
| Training | Start from the current routine; allow changes for a session. A full routine editor is deferred. |
| Provenance | The app and all described capabilities are planned, not implemented. |

Recommendations needing a decision are labelled **Proposed**; do not treat them as approved requirements.

## Important limits

- Do not place private body measurements, credentials, signing identities, real backups, or device identifiers in this repository or public sample data.
- “Local-only” means no app-operated service or sync. It does **not** currently mean records are excluded from iOS device backups.
- Manual file export can target a user-selected Files location, including a cloud-backed provider. The app will not sync automatically.
- Do not add production features until the open decisions in the [research guide](docs/research-and-private-installation.md) have been closed by the product owner.

## Reference and license

Read-only content reference: [`../edwin-training-app/src/pages/index.astro`](../edwin-training-app/src/pages/index.astro) and [`../edwin-training-app/src/data/exercises.ts`](../edwin-training-app/src/data/exercises.ts). These relative locators identify source context, not a dependency or permission to copy its presentation assets. No license or ownership claim is made here.
