# my-training-app-ios

**Current delivery:** the native SwiftUI shell, offline routine browsing, and offline exercise-guide catalog/navigation are implemented. The guide slice includes original bundled Spanish content and variant-specific navigation. The pure session domain and U3a/U3b persistence adapter are implemented, but are not composed into session UI. Rest timers, history UI, settings actions, and backup remain future work.

The verified stable-main cutoff is U1/U2 and U3a/U3b at `14e4599` (baseline main: `691b915`). U4a is paused, incomplete, and unverified on `feat/first-useful-release`; it is not ready for acceptance or normal use. The owner authorized the first useful offline release incrementally on 2026-10-04, but authorization is not evidence of completed behavior. Interrupted active sessions may continue, but no elapsed-duration pause state is authorized. See the [development checkpoint](docs/development-checkpoint.md), [scope](docs/product-scope.md), and [roadmap](docs/implementation-roadmap.md) for boundaries and pending checks.

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
| Platform | iPhone only; iOS 27.0 minimum. Current execution and testing use the physical iPhone, not the simulator. |
| Product | Native shell, offline routine browsing, and offline guide catalog/navigation are implemented; the first useful offline release is not yet complete. |
| Data | Validated session snapshots and the durable SwiftData adapter are implemented and tested; session UI integration and manual export/import remain pending on main. No account or backend. |
| Training | The session domain is implemented; session start, recording controls, and session-only adjustment UI remain pending on main. Routine editor deferred. |
| Foundation and installation | The initial foundation was simulator-only; physical-device signing, installation, and app launch are now confirmed. No App Store or TestFlight distribution is authorized. |
| B1/B2 and guide authorizations | Owner authorized routine browsing, then the bounded offline guide catalog/navigation slice; both are implemented. |
| Provenance | Bundled routine titles, day labels, prescriptions and recovery rows come from the read-only source projection; no assets, markup, nutrition, metrics or personal data are copied. |

Recommendations needing a decision are labelled **Proposed**; do not treat them as approved requirements.

## Important limits

- Routine browsing and bundled exercise-guide navigation are available offline. Session-domain and persistence/recovery APIs are verified, but their user-facing session integration is not delivered on main. History UI, settings actions, timers, and manual backup remain pending.
- Do not place private body measurements, credentials, signing identities, real backups, or device identifiers in this repository or public sample data.
- “Local-only” means no app-operated service or sync. It does **not** currently mean records are excluded from iOS device backups.
- Manual file export can target a user-selected Files location, including a cloud-backed provider. The app will not sync automatically.
- The first useful offline release is authorized for incremental implementation, not declared complete. Ordinary OS-managed device backups are approved; manual restore/conflict and backup-protection choices remain open. No elapsed-duration pause state is authorized. Physical installation is confirmed; full offline, accessibility, and device acceptance checks remain pending.

## Reference and license

Read-only content reference: [`../edwin-training-app/src/pages/index.astro`](../edwin-training-app/src/pages/index.astro) and [`../edwin-training-app/src/data/exercises.ts`](../edwin-training-app/src/data/exercises.ts). These relative locators identify source context, not a dependency or permission to copy its presentation assets. No license or ownership claim is made here.
