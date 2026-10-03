# Implementation roadmap

## Delivery and authorization gate

This repository contains the F1/F2 native shell, the bounded B1/B2 offline routine-browsing slice, and the separately authorized offline guide catalog/navigation slice; session and durable-data behavior remain future work ordered by dependencies. Each behavior unit must add focused tests before or alongside behavior, demonstrate a passing result, and preserve an honest record of unrun device checks. “RED/GREEN” means a behavior-level test fails before its implementation and passes after; it is not evidence for documentation changes.

The owner approved the simulator-first F1 shell, F2 navigation, and bounded B1/B2 catalog-and-routine-browsing work on 2026-10-02. On 2026-10-03 the owner authorized only the bounded guide slice: original Spanish guide content and variant-specific navigation, with no sessions, persistence, or assets. Neither authorization covers session behavior/logging, persistence, timers, backup, or unrelated training behavior. Before those units, obtain explicit authorization and close relevant decisions in [scope](product-scope.md#decisions-required-before-affected-work), including session pause semantics where lifecycle/timer behavior is involved. Do not add a framework/package dependency without a separately approved need.

## Work units

### 0. Project foundation and support decision — F1/F2 shell established

**Depends on:** owner approval for this bounded work unit. The owner approved iPhone-only, iOS 27.0 minimum, simulator-first foundation on 2026-10-02. The provisional bundle identifier is `org.example.trainingapp.simulator`; signing team, provisioning, and owned bundle identity remain deferred until physical installation.

- Create a native Xcode project with one app target, one XCTest UI target, shared scheme, Swift 6 language mode/strict concurrency, and no third-party dependencies.
- Establish the minimal SwiftUI placeholder, localization catalog, accessibility identifiers, build configuration, and local build/test command record.
- Add native Routine, History, and Settings tabs, each with its own `NavigationStack`; Routine links to one honest Training overview placeholder detail. These views own only static local presentation state.
- Keep the shell direct: no domain/service/layer abstraction, training function, or durable store is justified at this stage; therefore no schema or migration is introduced.
- Routine content and its bounded browsing UI were authorized separately as B1/B2 below. Workout/session behavior, stored history, settings functions, timers, backup, and store/schema decisions remain pending units.

**F1 evidence:** setup-only configuration has no meaningful pre-code behavioral RED; its entry-existence UI test remains in the suite.

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
- Native approval remains pending: G1 produced no verdict after its host-consent windows expired without a native invocation; G2's medium-risk, under-budget review was deferred to a future PR slice. Independent verification was completed for both slices; this is not native approval. Runtime injected fallback, physical signing/install, VoiceOver, actual Dynamic Type, contrast, Reduce Motion/Transparency, native materials, and airplane-mode checks remain pending.
- The owner authorized local commits and selected the feature-branch chain. G1 and G2 are committed as recorded in [exercise-guide evidence](exercise-guides.md); the G3 documentation-only closeout commit is forthcoming. No push, PR, merge, or release is authorized by this closeout.

### 1. Future session domain model, validation, and prescribed behavior

- Define session-domain identity and behavior, explicit units, load modes, unilateral sides, optional RIR, and session state transitions; do not duplicate the separately implemented immutable guide catalog.
- Import only approved routine/session semantics from the reference. Do not copy the entire site, guide assets, or private measures.
- Keep routine version and completed snapshot immutable; validate bounds, order, IDs, and references at domain boundaries.

**RED:** tests fail for invalid reps/load, ambiguous units, invalid RIR, duplicate IDs, a missing reference, and comparing distinct modes. A valid bodyweight/external-load/unilateral case should also be specified.

**GREEN:** domain tests pass for accepted/rejected records, stable identity and order, and creation of an independent session snapshot.

**Acceptance:** session-domain behavior meets its approved contract without changing the source routine or guide catalog; no personal values are seeded.

### 2. Local persistence, migrations, and session recovery

- Implement the persistence adapter and versioned SwiftData schema; keep domain operations independent of SwiftData details.
- Implement transactional begin, set-save/edit, completion, and abandonment; enforce the single-active-session invariant.
- Add migration fixtures and interrupted-migration safeguards. Surface failure without deleting/recreating user data.
- Persist enough active-session state to restore after force quit, process death, or restart.

**RED:** store/domain tests fail for duplicate active sessions, partial set writes, repeated completion, invalid references, and migration of known prior schema fixtures. Simulate a write failure and an interrupted migration.

**GREEN:** each failure case leaves consistent durable state; successful set saves appear after a fresh store/relaunch; migration preserves values and provenance.

**Acceptance:** airplane-mode session create/edit/resume/complete/history flow works on device. Force quit and relaunch during an active session; verify the last durable action and clear recovery state. No unrelated history is rewritten by a routine update.

### 3. Rest timer, performance lookup, and history

- Persist configured duration and absolute deadline. Derive displayed remaining time from an injected clock on foregrounding/relaunch.
- Implement only explicitly comparable last-performance lookup using stable exercise/variant identity, compatible units/load mode, and completed sessions.
- Add chronological history and Charts-based trend(s) only for values that have clear units, source, and date range.
- Decide whether local notifications are needed; if adopted, handle authorization denial and stale/delayed delivery without depending on them.

**RED:** fake-clock tests fail if elapsed/background time is added incorrectly, if a stale timer callback targets another set, or if unlike unit/mode/variant values are compared. Include deadline passed, clock/time-zone boundary, and missing prior performance.

**GREEN:** timer shows correct remaining/elapsed state after simulated suspension/relaunch; lookup picks only the latest compatible completed performance; histories sort/group by explicit date semantics.

**Acceptance:** interrupt app, lock device, and resume after both before and after deadline. Confirm display recalculates; notification delivery, if implemented, is helpful but not required for correctness. Verify chart labels and accessibility summaries on device.

### 4. Versioned export/import and recovery

**Gate:** close encryption/key handling, restore policy, device-backup stance, and included data scope. The file format/version is independent of SwiftData schema.

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
