# Implementation roadmap

## Delivery and authorization gate

This repository contains the F1/F2 native shell, bounded B1/B2 offline routine browsing, the separately authorized offline guide catalog/navigation slice, pure session domain, and the U3a/U3b persistence adapter (begin/record/edit/finish/abandon/recover). The guide delivery chain (PR2–PR5) is merged; baseline main is `691b915`. The verified stable-main cutoff is U1/U2 and U3a/U3b at `14e4599`. The owner authorized incremental implementation of the first useful offline release on 2026-10-04; remaining session and durable-data behavior is ordered by dependencies. Each behavior unit must add focused tests before or alongside behavior, demonstrate a passing result, and preserve an honest record of unrun device checks. “RED/GREEN” means a behavior-level test fails before its implementation and passes after; it is not evidence for documentation changes.

The owner approved the simulator-first F1 shell, F2 navigation, and bounded B1/B2 catalog-and-routine-browsing work on 2026-10-02. On 2026-10-03 the owner authorized the bounded guide slice: original Spanish guide content and variant-specific navigation, with no sessions, persistence, or assets. On 2026-10-04 the owner authorized incremental first useful offline release implementation, including sessions/set logging, local persistence/recovery, rest/performance/history, versioned manual backup, and accessibility. This authorization is not implementation evidence. No elapsed-duration pause state is authorized; interrupted active sessions may continue. Close relevant backup/privacy decisions in [scope](product-scope.md#decisions-required-before-affected-work) before dependent work. Do not add a framework/package dependency without a separately approved need.

## Work units

### 0. Project foundation and support decision — F1/F2 shell established

**Depends on:** owner approval for this bounded work unit. The owner approved iPhone-only, iOS 27.0 minimum, simulator-first foundation on 2026-10-02. The provisional bundle identifier is `org.example.trainingapp.simulator`; signing team, provisioning, and owned bundle identity remain deferred until physical installation.

- Create a native Xcode project with one app target, one XCTest UI target, shared scheme, Swift 6 language mode/strict concurrency, and no third-party dependencies.
- Establish the minimal SwiftUI placeholder, localization catalog, accessibility identifiers, build configuration, and local build/test command record.
- Add native Routine, History, and Settings tabs, each with its own `NavigationStack`; Routine links to one honest Training overview placeholder detail. These views own only static local presentation state.
- Keep the shell direct: no domain/service/layer abstraction, training function, or durable store is justified at this stage; therefore no schema or migration is introduced.
- Routine content and its bounded browsing UI were authorized separately as B1/B2 below. Workout/session behavior, stored history, settings functions, timers, backup, and store/schema decisions remain pending units.

**F1 evidence:** setup-only configuration has no meaningful pre-code behavioral RED; its entry-existence UI test remains in the suite. iOS 27.0 is the approved project minimum.

**F2 RED/GREEN:** the focused navigation assertion RED was independently recovered by R1 from the partial result's staged runner diagnostics: `testNavigationDestinationsAndReturn` failed because native tabs were missing (11.191 seconds of test execution; wrapper timeout happened later during finalization). The navigation UI was then added; the first GREEN attempt exposed that accessibility identifiers on custom tab labels do not map to native tab buttons, so the test now pins English locale and queries native tab labels while retaining identifiers for content anchors. The subsequent simulator run passed both UI tests. Exact commands, evidence, warnings, and bundle paths are recorded in [`ios-foundation.md`](ios-foundation.md).

**Acceptance boundary:** simulator build and launch/navigation smoke tests on the declared toolchain. Physical-device install/signing, owned bundle identity, VoiceOver, Dynamic Type, Reduce Motion/Transparency, and native material review remain pending. No credentials, personal metrics, generated state, or private backups are tracked.

### Bounded routine browsing — B1/B2 implemented

- B1 adds the immutable versioned bundled catalog, stable literal day/exercise IDs, pure validation, source title correction, eight Swift Testing tests, and the hosted test target.
- B2 provides offline native week → day navigation with source-exact Spanish routine titles, subtitles, notes, prescriptions, rest strings, cues and recovery rows. Generic UI labels are localized in English and Spanish; source copy is not parsed, translated or treated as guide/session behavior.
- Validation failure is shown as a localized fallback, not an assertion or precondition. There are no guide links, session/start/save actions, persistence, history records, timers or backup behavior.
- The original B1/B2 validation record remains eight domain and four UI tests; exact commands/results, setup failures, observed REDs, warnings, and pending device checks are recorded in [routine browsing evidence](routine-browsing.md). This historical B1/B2 result is separate from the later guide recovery results.
- No SwiftData schema or migration was added because these values are bundled, immutable content.

### Bounded offline exercise-guide catalog and navigation — authorized 2026-10-03

This is a distinct content/navigation slice, not session-domain behavior. It adds 36 immutable original Spanish guides, 37 stable references across 30 prescriptions, seven composite variant choices, and native guide navigation. One machine-incline guide is intentionally reused. It adds no sessions, persistence, assets, schema, or migration. The 30 source prescription rows remain unchanged.

- Finalized recovery results: 15 domain tests passed (8 routine + 7 guide) and 7 UI tests passed (4 prior + 3 guide), in two separate invocations; each result has zero failures, skipped tests, and runtime warnings. These are not a single combined full-suite result. A separate standalone simulator build reported `BUILD SUCCEEDED`.
- Initial/partial attempts and the bounded recovery history are retained, including the meaningful missing-destination UI RED, UI runner startup incident, wrong-locale assertion correction, and the timed-out combined attempt. The runner incident's cause was not established. See [exercise-guide implementation and recovery evidence](exercise-guides.md).
- Native G1 (`review-2f81f531be923a47`, `12c`→`861`) and G2 (`review-655d41a2675a9549`, `861`→`d8`) reviews are approved and acknowledged; their authorities are burned. Advisory R3-001 at `ExerciseGuideView.swift:79-81` is informational and nonblocking; no correction is required, and any follow-up is separate. Runtime injected fallback, physical signing/install, VoiceOver, actual Dynamic Type, contrast, Reduce Motion/Transparency, native materials, and airplane-mode checks remain pending.
- The owner-selected feature-branch chain was delivered as PR2–PR5 and merged; baseline main is `691b915`. G1 and G2 reviews were approved and their acknowledgement authorities are burned; these are historical evidence, not reusable approval. The owner separately authorized the 2026-10-04 verified cutoff on stable main and preservation of U4a as feature-branch WIP. U4a remains paused, incomplete, and unverified; no distribution or additional feature work is authorized. This documentation records the intended boundary and is not confirmation that remote publication occurred.

### 1. Pure session domain — verified 2026-10-04

The bounded Foundation-only slice defines set/load/side values, immutable routine snapshots with explicit guide choices, set validation/order, active/completed/abandoned transitions, and stable comparability. Prescription text is opaque and no arbitrary magnitude caps are added. Comparisons require the same source exercise and selected guide reference/identity plus compatible load mode/unit/added-load status and side; display names and order do not confer identity.

- Focused physical iPhone 17 run: 13 domain tests passed; the full domain unit-test target: 28 passed; physical-device app build succeeded. Exact results and the observed same-guide/distinct-exercise RED/GREEN are recorded in [session-domain.md](session-domain.md).
- Routine and guide catalogs remain immutable. U3a later added a local persistence adapter; this pure domain module has no UI, adjustments, timer, history, or portable backup behavior.
- Functional verification is distinct from signing/distribution owner confirmation and all pending accessibility/release acceptance.

### 2. Local persistence, migrations, and session recovery — U3a/U3b adapter implemented

`SessionSchemaV1` remains the initial schema and stores one session aggregate. The adapter exposes begin, record-set, set replacement, finish, abandon, and active recovery; it is not composed into app UI (U4). Each main-actor operation uses a fresh context, validates latest rows, and commits through explicit save. Edit/finish/abandon operate on a domain copy, and save failure rolls back and preserves the prior durable aggregate. Repeated terminal actions consistently reject as closed; a terminal session permits a new begin. Set replacement retains set/exercise/order identity. DTO read and write share limits of 1 MiB encoded payload, 10,000 sets, and 1,000 snapshot exercises; invalid or oversized payloads reject without truncation. No arbitrary numeric magnitude limits or schema migration were added.

- Physical iPhone 17 focused tests: U3a RED showed the non-durable stub fail reopen and failed-set-preservation behavior (2 failed, 3 passed); the first attempt had an invalid fixture and is not counted as RED. GREEN passed 6 tests; final focused run passed 8. Triangulation passed 8 tests, including concurrent begins through separate adapters, malformed stored DTO rejection, injected failure preservation, and an actual read-only `allowsSave: false` store rejecting a set write without changing the reopened session. Exact bundles: `build/U3aDevice-red-20261004-writer-d7e4.xcresult`, `build/U3aDevice-green-final-20261004-writer-a46c.xcresult`, and `build/U3aDevice-triangulate-20261004-writer-f901.xcresult` (the earlier 6-test GREEN is `...green-20261004-writer-b08a.xcresult`). Full `TrainingAppTests` regression passed 37/0/0 at `build/U3aDevice-regression-20261004-writer-b66d.xcresult`; physical-device build succeeded in `build/U3aDevice-build-20261004-writer-c40f.log`. Test logs use the matching phase prefixes. These establish tested reopen/save cases, not crash-recovery guarantees.
- Initial SwiftData v1 has no predecessor. Fabricated migration fixtures would not test a real migration; add historical store fixtures and migration/interruption coverage only when a subsequent schema has an actual previous version.
- U3a device evidence and exact bundle names are preserved in `docs/session-persistence.md`. U3b restored behavior passed focused tests 13/0/0 and full `TrainingAppTests` 43/0/0 on iPhone 17; physical-device build succeeded. A postimplementation no-op sensitivity check failed 4/13 tests, confirming test detection but not preimplementation RED. The original test-first sequencing defect remains disclosed and unresolved in `docs/session-persistence.md`.
- The two informational U3a advisories are separate-slice improvements, not corrections/reopening of U3a review: fresh contexts address live-context coherence, and shared DTO structural/byte limits address write/read asymmetry.
- Initial SwiftData v1 has no predecessor. Do not fabricate migration fixtures; add historical fixtures only after a subsequent schema has an actual predecessor.

**Acceptance still pending:** app composition/UI relaunch flow and future force-quit/restart acceptance. Do not infer those product-level guarantees from the focused adapter tests.

### 3. Rest timer, performance lookup, and history

- Persist configured duration and absolute deadline. Derive displayed remaining time from an injected clock on foregrounding/relaunch.
- Implement only explicitly comparable last-performance lookup using stable exercise/variant identity, compatible units/load mode, and completed sessions.
- Add chronological history and Charts-based trend(s) only for values that have clear units, source, and date range.
- Decide whether local notifications are needed; if adopted, handle authorization denial and stale/delayed delivery without depending on them.

**RED:** fake-clock tests fail if elapsed/background time is added incorrectly, if a stale timer callback targets another set, or if unlike unit/mode/variant values are compared. Include deadline passed, clock/time-zone boundary, and missing prior performance.

**GREEN:** timer shows correct remaining/elapsed state after simulated suspension/relaunch; lookup picks only the latest compatible completed performance; histories sort/group by explicit date semantics.

**Acceptance:** interrupt app, lock device, and resume after both before and after deadline. Confirm display recalculates; notification delivery, if implemented, is helpful but not required for correctness. Verify chart labels and accessibility summaries on device.

### 4. Versioned export/import and recovery

**Gate:** close encryption/key handling, restore/conflict policy, and included data scope. The owner accepts ordinary iOS device backups, including enabled iCloud Backup; this is not app sync. The file format/version is independent of SwiftData schema.

- Define portable DTO and bounds; encode/export via system document picker, respecting user-selected destination.
- Decode into temporary state, validate full graph, preview intended change, create safety rollback point, and commit only after approval.
- Implement cancellation, unsupported-version behavior, interrupted restore detection, rollback/recovery, and actionable errors. Never mutate live data during parse/validation.

**RED:** tests fail for corrupt/oversized files, unknown versions, duplicate IDs, orphan references, invalid units, cancellation, failed commit, and process interruption before/after commit boundary. Assert exact preservation of live state on all abort/failure paths.

**GREEN:** round-trip restores approved entities and meaning; valid restore follows chosen merge/replace policy; injected failures preserve or recover a consistent store.

**Acceptance:** export to and import from user-selected Files destinations; test cancellation and malformed file; verify preview, backup rollback, and existing data after failure. Test a cloud-backed destination only as user-initiated file handling, not app sync.

### 5. Native Liquid Glass, accessibility, privacy, and release readiness

- Implement the screen hierarchy and only selected native Glass APIs after deployment/API support is confirmed. Prefer system controls and standard surfaces for dense data.
- Add VoiceOver semantics, Dynamic Type/reflow, contrast, Reduce Transparency/Motion alternatives, keyboard and touch checks.
- Explain on-device storage, device backups, manual export, and any chosen encryption/restore behavior in product UI.
- Profile on physical device; keep screenshots, performance observations, and test environment in a later implementation record, not claims in this planning document.

**RED/GREEN:** accessibility/UI tests should first expose missing labels, inaccessible controls, clipped large text, or unavailable recovery/error announcements, then pass after remediation. Snapshot tests may supplement but cannot replace hardware/material checks.

**Acceptance:** physical-device review in light/dark modes and accessibility settings; no critical action obscured by glass; interactions, scrolling, timer, and charts remain responsive; no misleading offline/privacy wording. Independently verify a fresh install, session persistence, backup/restore, and update path before considering any private distribution ready.

## Cross-cutting test matrix

| Layer | Planned tools | Example contract |
|---|---|---|
| Domain | Swift Testing | Validation, snapshot immutability, session invariants, comparison policy, absolute deadline calculations. |
| Persistence | Swift Testing/XCTest as appropriate | Transaction failures, reopen/relaunch, migrations, interruption and rollback fixtures. |
| Backup | Swift Testing | DTO round-trip, bounds, unsupported formats, integrity checks, cancellation, unchanged store on rejection. |
| UI | XCTest UI tests plus targeted Swift Testing support | Navigation, set entry, resume/error announcements, restore confirmation, accessibility identifiers only where stable. |
| Device | Manual physical-device checklist | Liquid Glass compositing, VoiceOver, Dynamic Type, transparency/motion fallbacks, lock/relaunch, responsiveness. |

Use test fixtures with synthetic data only. Keep automated and manual evidence separate: a simulator pass does not certify native glass performance or signing/install behavior on the user's device.

## Definition of done per future unit

- Acceptance criteria and failure paths are covered; meaningful tests show observed RED then GREEN where applicable.
- The schema/content change has a migration or an explicit rationale why one is not needed.
- No secrets, real personal metrics, or private export files enter version control.
- Offline use, accessibility implications, error visibility, and recovery behavior are reviewed.
- The change records exact commands/results and lists device checks that remain unperformed.
- No unit claims completion until its relevant tests and acceptance checks actually run.
