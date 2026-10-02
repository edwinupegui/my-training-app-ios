# Product scope and acceptance

## Outcome

Plan a native, private training companion that lets one person follow a familiar weekly routine, adapt the active session, record each set, and recover data without a service account. This is a planning specification; no feature described here is implemented.

## Product baseline

| Area | Planned behavior | Boundary |
|---|---|---|
| Routine | Show five strength sessions plus two recovery/rest days; begin from the current routine. | Per-session adjustments only in the initial product. Full routine authoring is deferred. |
| Session logging | Record exercise, set order, load, repetitions, and optional RIR; resume an unfinished session. | No coaching claims or automatic progression. |
| Context | See the most recent comparable performance and browse session history. | Do not silently treat changed exercise variants or units as directly comparable. |
| Rest | Start a rest interval after a set; retain its deadline across app suspension and relaunch. | No guarantee of continuous background execution. |
| Guides | Present exercise purpose, equipment, cues, common errors, and breathing guidance. | Reuse meaning, not HTML/CSS or reference images. |
| Backup | Explicitly export and import a portable, versioned file. | No automatic cloud sync or backend. User chooses the destination. |
| Language | Initial UI may use Spanish, matching the existing reference. | Localization structure and additional languages are not a launch blocker unless later decided. |
| Design | Native SwiftUI with a deliberate Liquid Glass visual hierarchy. | Do not approximate system materials with web CSS blur. |

Reference evidence (read-only): the weekly split and prescribed routine data start in [`../edwin-training-app/src/pages/index.astro`](../../edwin-training-app/src/pages/index.astro#L5) and its routine definitions at [line 15](../../edwin-training-app/src/pages/index.astro#L15). Exercise-guide fields are represented in [`../edwin-training-app/src/data/exercises.ts`](../../edwin-training-app/src/data/exercises.ts#L1). Nutrition and progress advice are in the reference page at [nutrition](../../edwin-training-app/src/pages/index.astro#L167) and [progress](../../edwin-training-app/src/pages/index.astro#L175). These are reference semantics, not a request to copy personal metrics or assets.

The reference progress persistence is only four weekly checkbox booleans in browser `localStorage` ([read/write locations](../../edwin-training-app/src/pages/index.astro#L234)); it does not implement workout logging/history, accounts, or a backend. The native plan extends the product purpose; it must not claim these capabilities already exist.

## In scope for the planned first useful release

- Browse the prescribed week and open exercise guides.
- Start, pause/resume, finish, or abandon one active training session.
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

Local storage is not a promise that iOS device backups exclude app data. The device owner may also choose a cloud-backed Files destination for a manual export. The data-path distinction is described in [architecture](architecture.md#backup-format-and-restore-safety).

## Acceptance checklist for a future implementation

These checks are targets, not evidence that the app exists. Each applicable test/device check must be run and recorded in the implementation work.

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

1. **Proposed deployment minimum:** iOS 27.0. Confirm before project settings/API availability are set; the user-reported device OS is 27.0.1, which is not a deployment-target decision.
2. **Proposed restore semantics:** choose replace-all, merge, or a user-visible choice. Define conflict behavior and stable-ID collision handling before restore UI/data mutation.
3. **Proposed backup protection:** choose whether backups are encrypted and how keys/passphrases/recovery are handled. Do not select an algorithm/KDF or promise recovery until reviewed.
4. **Proposed device-backup policy:** decide whether ordinary iOS/iCloud device backups are acceptable. “Manual export only” does not exclude system backups.
5. **Proposed measurements scope:** decide whether to include user-entered body measurements at all, and which fields. Never seed real personal values into code or sample backups.
6. **Proposed signing path:** choose free Personal Team versus paid membership before detailed renewal instructions are tailored. Neither implies an App Store release.

Close each decision when the associated implementation unit reaches it; no new questionnaire is required now.
