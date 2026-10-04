# Architecture and data plan

## Direction

**Planned stack:** first-party SwiftUI, SwiftData, Charts, Swift Testing, and XCTest. Keep domain rules independent of view code and persistent-store APIs; use Apple frameworks only unless an evidenced requirement warrants a separately approved dependency. This is not an implemented architecture.

- SwiftUI presents navigation, session controls, and accessible forms.
- A domain layer owns validation, session lifecycle, comparable-performance rules, timer calculations, and backup DTO validation.
- A persistence adapter owns SwiftData models, transactions, fetches, and version migrations.
- A backup service maps between persistence and a portable domain format. It does not expose a raw SwiftData database.
- Charts may visualize saved local records; every displayed value must have a clear unit and date range.

Keep interactions testable through injected store/clock/notification abstractions where useful. Do not introduce a service layer that implies a network backend.

## Planned domain model

| Entity | Purpose and key fields |
|---|---|
| `Routine` | Stable ID, title, weekday/order, version, and ordered prescribed days. The initial routine is bundled content, not a mutable record of completed work. |
| `RoutineExercise` | Stable ID, exercise reference, order, set/rep range, suggested rest, cue, and prescription version. |
| `ExerciseDefinition` | Stable ID, display name, equipment, target areas, guide text, and optional asset reference. Keep content identity separate from a particular prescription. |
| `TrainingSession` | Stable ID, lifecycle (`active`, `completed`, or `abandoned`), start/end instants, relevant local-day key/time zone, and immutable routine snapshot/version used at start. At most one active session. |
| `SessionExercise` | Stable ID and order, reference/variant, copied prescription and unit context, plus session-only adjustments. It belongs to the snapshot, not a live routine row. |
| `SetEntry` | Stable ID, order, exercise ID, repetitions, load value/unit/mode, optional RIR, completion instant, and optional left/right/both-side designation. Validate at the domain boundary. |
| `RestTimerState` | Session/exercise/set association where available, configured duration, absolute deadline instant, and lifecycle. Remaining time is derived; no per-second persistence loop. |
| `BodyMeasurement` (optional; decision pending) | Do not implement until the owner selects whether measurements are in scope and which fields. Never place real values in seed data. |

### Identity, time, units, and comparability

- Use stable UUID-like identifiers for domain entities; never use display names or array positions as identity.
- Persist absolute instants for session and set events. Preserve the time-zone identifier and a local calendar-day key for grouping; do not assume a day is always 24 hours or infer the historical zone from today's setting.
- Declare units on every load/value. A bodyweight movement, external load, assisted load, and left/right unilateral work are distinct modes. Do not invent conversion factors or compare unlike modes.
- Optional RIR must stay optional; a missing value is not zero. Reject invalid negative reps/load, impossible ordering, or out-of-policy magnitudes with a visible validation error.
- “Last performance” means the most recent completed comparable set/session for the same stable exercise/variant, compatible mode and units. If equivalence is uncertain, show no comparison rather than a misleading number.

## Snapshot and lifecycle invariants

Starting a session copies the selected routine version and its relevant prescription into a session snapshot. Session-only changes modify that copy. Routine updates affect future starts only; they never rewrite performed history. A migration may change storage representation but must preserve the recorded meaning and provenance.

A domain operation should enforce these invariants:

1. Begin only when there is no other active session; repeat begin requests return the existing active session or a clear conflict, never a duplicate.
2. Set edits and session transitions are validated and saved transactionally. A save error remains visible; do not optimistically imply durability.
3. Complete/abandon is idempotent or rejected explicitly. History includes only completed sessions unless the user separately opens an active/abandoned record.
4. Set order and entity references remain valid after edits, migration, and restore.
5. Rest state stores a deadline. Foreground refresh, relaunch, and timer callbacks recompute against the current clock; a stale callback cannot alter another set's timer.

## Persistence and migrations

SwiftData is the proposed on-device store, not the domain contract. Define explicit schema versions and migration plans before shipping a schema change. Prefer additive optional fields when semantics allow; for destructive or meaning-changing changes, use a staged migration that can validate records and report failure without silently dropping data. Backup format versions are independent of SwiftData schema versions.

- Keep bundled baseline routine/guide content versioned separately from user session data.
- Write logically related changes (set, order, session state) in one transaction where supported; surface storage failures and preserve a recoverable active-session state.
- Test first launch, existing-store migration, interrupted migration/relaunch, duplicate IDs, orphan references, and invalid records.
- Do not delete or recreate a store as a recovery shortcut. If migration fails, preserve original bytes and guide the user to export/diagnostics or restore from a verified backup.
- Define retention/deletion and any measurement schema only after the product decisions are closed.

## Offline behavior and interruption recovery

Core routine, guides, logging, history, timer display, and export/import should be usable without connectivity. There is no account, backend, remote analytics, push service, or CloudKit sync in this plan.

Save meaningful actions promptly. An unfinished session survives force quit, memory pressure, and device restart. On return, recover the existing single active session and show its last durable set state. A timer is an absolute deadline plus duration, not a promise that code runs in the background. Optional local notifications may signal an expected deadline if permission and platform behavior allow; the app must still recompute correctly when opened, and notifications are not guaranteed.

## Backup format and restore safety

Export a documented, versioned, portable domain DTO containing only selected app data and stable references—not a raw SwiftData database, signing data, caches, or unrelated device state. The format should include a format version, creation instant, units/time-zone context as needed, and a bounded collection of routine snapshots, sessions, sets, and explicitly approved optional records.

### Import pipeline

1. Let the user choose a file using the system document picker; support cancellation as a no-op.
2. Enforce reasonable file size, collection count, string length, and nesting limits before decoding to avoid unbounded resource use.
3. Decode into a temporary DTO and validate version support, IDs/uniqueness, required fields, numeric ranges, ordering, references, units, and cross-entity invariants.
4. Present a clear preview and the selected restore policy. **Policy is unresolved**: replace-all, merge, or a user choice must be approved before implementation. Define collision and duplicate handling first.
5. Create a pre-restore safety export or equivalent verified rollback point. Prepare changes off the live store, then commit atomically where possible.
6. If validation, cancellation, persistence, or process recovery fails before commit, leave existing live data unchanged. On crash/relaunch, detect incomplete restore state and either roll forward a fully validated staged restore or roll back safely.
7. Report the result and retain a path to recovery instructions. Test empty files, unsupported versions, corruption, hostile/oversized records, duplicate IDs, missing references, and interrupted restore.

### Confidentiality and destination

Encryption is **not selected**. Documented options may include platform-provided file protection and/or an encrypted export envelope. CryptoKit supplies cryptographic primitives but does not by itself provide a password-based key derivation function. Do not invent or imply an approved KDF, iteration count, cipher suite, key escrow, recovery mechanism, or algorithm API. A design review must choose these details and threat model before encrypted backups are claimed.

Manual export uses the user's chosen Files destination. A cloud-backed Files provider can sync that chosen file; this app does not sync it automatically. The owner accepts ordinary iOS/iCloud device backups, and this app does not exclude its store from OS backups. This is not app sync; never describe local-only storage as equivalent to no cloud copies.

## Data access and privacy

No account or remote data path is planned. Ask for no data that is not needed for logging. Keep health/body measurements out until explicitly approved, and keep private values, user identifiers, signing material, and real backup files out of source control. Give the user understandable export, restore, and deletion behavior before storing durable history.

## References

- [SwiftData](https://developer.apple.com/documentation/swiftdata) — API reference; linked, not fully reviewed for a particular schema design.
- [CryptoKit](https://developer.apple.com/documentation/cryptokit) — API reference; does not settle the backup cryptography choice.
- [Charts](https://developer.apple.com/documentation/charts) — proposed first-party visualization framework.
