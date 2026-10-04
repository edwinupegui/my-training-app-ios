# Product scope and acceptance

## Outcome

Build a native, private training companion that lets one person follow a familiar weekly routine, adapt an active session, record sets, and recover data without a service account. The F1/F2 shell, B1/B2 offline routine browsing, separately authorized offline exercise-guide catalog/navigation slice, pure session domain, and bounded U3a persistence adapter are implemented in slices. The adapter exposes begin/record/recover but is not composed into app UI; set editing and lifecycle closure remain later work.

## Product baseline

| Area | Planned behavior | Boundary |
|---|---|---|
| Routine | Show five strength sessions plus two recovery/rest days; begin from the current routine. | Per-session adjustments only in the initial product. Full routine authoring is deferred. |
| Session logging | Record exercise, set order, load, repetitions, and optional RIR; resume an unfinished session. | No coaching claims or automatic progression. |
| Context | See the most recent comparable performance and browse session history. | Do not silently treat changed exercise variants or units as directly comparable. |
| Rest | Start a rest interval after a set; retain its deadline across app suspension and relaunch. | No guarantee of continuous background execution. |
| Guides | Present exercise purpose, equipment, cues, common errors, and breathing guidance. | Implemented as immutable bundled original Spanish content with variant-specific navigation; no sessions, persistence, or assets. Reuse meaning, not HTML/CSS or reference images. |
| Backup | Explicitly export and import a portable, versioned file. | No automatic cloud sync or backend. User chooses the destination. |
| Language | Initial UI may be Spanish, matching the existing reference. | Localization structure and additional languages are not a launch blocker unless later decided. |
| Design | Native SwiftUI with a deliberate Liquid Glass visual hierarchy. | Do not approximate system materials with web CSS blur. |
| F1/F2 shell, B1/B2 routine browsing, and bounded guide slice | Show native Routine, History and Settings tabs; browse seven bundled days, source prescriptions/recovery rows, and linked exercise guides offline. | Guide slice adds original Spanish guide content and variant navigation only; session UI, history records, settings actions, timer and backup remain unimplemented. The separate U3a adapter is not wired into this shell. |

Reference evidence (read-only): the weekly split and prescribed routine data start in [`../edwin-training-app/src/pages/index.astro`](../../edwin-training-app/src/pages/index.astro#L5) and its routine definitions at [line 15](../../edwin-training-app/src/pages/index.astro#L15). Exercise-guide fields are represented in [`../edwin-training-app/src/data/exercises.ts`](../../edwin-training-app/src/data/exercises.ts#L1). Nutrition and progress advice are in the reference page at [nutrition](../../edwin-training-app/src/pages/index.astro#L167) and [progress](../../edwin-training-app/src/pages/index.astro#L175). These are reference semantics, not a request to copy personal metrics or assets.

The reference progress persistence is only four weekly checkbox booleans in browser `localStorage` ([read/write locations](../../edwin-training-app/src/pages/index.astro#L234)); it does not implement workout logging/history, accounts, or a backend. The native plan extends the product purpose; it must not claim these capabilities already exist.

## In scope for the planned first useful release

- Browse the prescribed week and open exercise guides.
- Start, continue after interruption, finish, or abandon one active training session. A distinct elapsed-duration pause/resume behavior is unresolved (see decisions below); do not imply an approved `paused` lifecycle state.
- Adjust exercise selection/order or prescription for that session without mutating the source routine or past sessions.
- Log sets with load, repetitions, and optional RIR; represent bodyweight and unilateral work without ambiguous units.
- View last performance and dated session history; provide a modest progress view derived from saved sessions.
- Run a rest timer whose end time survives suspension, process termination, and device restart as an absolute deadline.
- Keep data on device and let the user initiate export/import with clear success, failure, and cancellation handling.
- Make accessibility, offline operation, transaction safety, and recovery part of acceptance, not polish.

## Explicitly out of scope

- App Store, TestFlight, public release, advertising, monetization, remote APIs, sign-in, social features, push notifications, and CloudKit synchronization.
- HealthKit, Apple Watch, Live Activities, widgets, sensors, or automatic workout capture.
- Full routine editor, multi-user profiles, coach sharing, nutrition diary, or automatic recommendations.
- Clinical assessment, diagnosis, treatment, or guarantees about body composition or training outcomes.
- Copying the reference site's markup, styles, full exercise images, or personal measurements into source control.

Local storage is not a promise that iOS device backups exclude app data. The owner accepts ordinary iOS device backups, including enabled iCloud Backup; this app has no CloudKit/app sync and does not exclude the store from backups. The device owner may also choose a cloud-backed Files destination for a manual export. The data-path distinction is described in [architecture](architecture.md#backup-format-and-restore-safety). The architecture plan's earlier note that system-backup policy was unresolved predates the owner's 2026-10-04 decision; this section and [U3a persistence notes](session-persistence.md#privacy-and-api-evidence) record the current accepted policy.

## Current implementation authorizations

On 2026-10-02 the owner approved the iPhone-only, simulator-first F1/F2 shell (iOS 27.0 minimum; provisional simulator bundle identifier `org.example.trainingapp.simulator`; signing and owned bundle identity deferred until physical installation). The owner separately authorized B1 bundled routine catalog/validation and B2's bounded native week → day → prescribed-exercise browsing, including the explicit source-title model correction. On 2026-10-03 the owner authorized the distinct bounded guide slice: original Spanish guide content and variant-specific navigation, with no sessions, persistence, or assets. These slices keep presentation state local and use static bundled content; they introduce no durable store, schema, or migration. See [iOS foundation evidence](ios-foundation.md), [routine browsing evidence](routine-browsing.md), and [exercise-guide implementation and recovery evidence](exercise-guides.md).

On 2026-10-04 the owner authorized incremental implementation of the first useful offline release: sessions/set logging, local persistence/recovery, rest/performance/history, versioned manual backup, and accessibility. The pure session-domain slice provides validated value types and snapshots. U3a adds a versioned local adapter for durable begin/record/recover with an explicit save boundary and tested disk reopen; it is not connected to app composition or UI. Set editing/finish/abandon (U3b), session UI, rest/performance/history, backup, and accessibility remain future work. No elapsed-duration pause state is authorized; an interrupted active session may continue. The owner accepts ordinary OS-managed device backups, including enabled iCloud Backup; this does not authorize app sync. Restore/conflict policy, encryption and key recovery remain U6 gates. iOS 27.0 is approved. Physical functional test/build evidence does not resolve separate owner confirmation of signing/distribution acceptance. See the [session-domain contract](session-domain.md), [session persistence boundary](session-persistence.md), roadmap, and [exercise-guide evidence](exercise-guides.md).

## Acceptance checklist for future product implementation

These checks are targets, not evidence that product behavior exists. Each applicable test/device check must be run and recorded in the implementation work.

- [ ] With no network, the user can browse the baseline routine and guides, create a session, save sets, resume after relaunch, and inspect history.
- [ ] Session-specific edits never change the routine definition or any completed session snapshot.
- [ ] Load/repetition/RIR validation is explicit; bodyweight, external load, unilateral sides, and units cannot be confused.
- [ ] A set save is atomic from the user's perspective: either persisted and visible, or failed with an actionable error.
- [ ] At most one session is active; duplicate starts, repeated finish actions, and stale timer events cannot create inconsistent state.
- [ ] The displayed rest time is recalculated from an absolute deadline after app suspension/termination, not from a presumed background loop.
- [ ] An invalid or cancelled import leaves all existing data unchanged; a successful restore reports what changed.
- [ ] Exported data contains no hidden account/service dependency and can be validated before live records change.
- [ ] VoiceOver labels, Dynamic Type, contrast, reduced transparency/motion, and physical-device interaction meet the design checks.
- [ ] Privacy copy distinguishes on-device app storage, system device backups, and user-selected export destinations.

## Decisions required before affected work

1. **Deployment minimum:** iOS 27.0 is approved for this iPhone-only project; validate support/API choices against the installed SDK/compiler.
2. **Session pause semantics:** no elapsed-duration pause state is authorized. An interrupted active session may continue; do not add a `paused` state or describe true pause behavior.
3. **Proposed restore semantics:** choose replace-all, merge, or a user-visible choice. Define conflict behavior and stable-ID collision handling before restore UI/data mutation.
4. **Proposed backup protection:** choose whether backups are encrypted and how keys/passphrases/recovery are handled. Do not select an algorithm/KDF or promise recovery until reviewed.
5. **Device-backup policy (closed 2026-10-04):** ordinary iOS device backups, including enabled iCloud Backup, are accepted. This is distinct from app sync; do not exclude app data from OS backups. Restore semantics and data protection remain open.
6. **Proposed measurements scope:** decide whether to include user-entered body measurements at all, and which fields. Never seed real personal values into code or sample backups.
7. **Signing and bundle ownership:** simulator-only F1 identity is provisional. Choose an owned bundle ID and signing path before physical installation; neither implies an App Store release.

Close only decisions relevant to an implementation unit; no new questionnaire is required now. Product-plan approval alone does not authorize additional implementation.
