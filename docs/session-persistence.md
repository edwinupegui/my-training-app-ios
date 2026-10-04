# Session persistence: U3a boundary

U3a adds a narrow SwiftData adapter for starting a session, recording a set, and recovering the active session. The adapter is usable through its own API, but is not yet composed into app startup or UI (U4). Set editing, completion, and abandonment are outside this slice (U3b).

## Storage contract

- `SessionSchemaV1` is the initial versioned schema. One `PersistedSession` aggregate row contains identity, schema version, lifecycle/timestamps, and an internal encoded DTO for the immutable snapshot and ordered sets.
- Domain values do not conform to SwiftData or persistence `Codable` types. The private-to-feature DTO has explicit load-mode/unit/side fields; decoding reconstructs validated domain values and checks row/DTO identity and version, snapshot identities and order, set references/order/IDs, units, numeric values, lifecycle, and dates.
- Each `SessionPersistenceAdapter` owns a `ModelContainer` and `ModelContext` for its supplied store URL. The configuration explicitly sets `cloudKitDatabase: .none`; context autosave is disabled.
- Begin fetches and validates stored aggregates before checking for an active session. Main-actor synchronous check/insert/save operations serialize concurrent adapter calls in this process. Session-ID uniqueness is not used as an active-session upsert mechanism.
- Begin and record report success only after an explicit `ModelContext.save()`. On error, the adapter calls `rollback()` and surfaces the error. Fetch and stored-data validation errors are not treated as an empty store. There is no delete/recreate recovery path.

## Verification and limits

The synthetic temporary on-disk tests reopen a fresh adapter/context to verify begin + set durability, one-active behavior across separate concurrent adapters, rejection of unknown session/exercise, malformed stored DTO rejection, and preservation after injected save failure. A real `ModelConfiguration(allowsSave: false)` test confirms failed writes leave the previously durable session unchanged. Focused final verification passed 8 tests (`build/U3aDevice-green-final-20261004-writer-a46c.xcresult`); full `TrainingAppTests` passed 37 tests (`build/U3aDevice-regression-20261004-writer-b66d.xcresult`) and the physical-device build succeeded (`build/U3aDevice-build-20261004-writer-c40f.log`). These tests establish only the exercised save/reopen cases; they do not guarantee crash recovery, filesystem-level atomicity beyond SwiftData's save contract, or process/multi-device locking.

Schema v1 has no predecessor. A migration test now would invent a historical schema and would not test a real migration; add fixtures from an actual shipped prior version when schema v2 is introduced. This schema is not a portable backup/import format.

## Privacy and API evidence

The owner accepts ordinary iOS device backups, including enabled iCloud Backup. This app does not sync through CloudKit or another service, and this implementation does not set `isExcludedFromBackup`. Restore/conflict policy, encryption, and key recovery remain U6 decisions. On-device storage therefore may also exist in an owner-enabled system backup.

Source check date: 2026-10-04. Official Apple SwiftData JSON references reviewed: [ModelContext](https://developer.apple.com/tutorials/data/documentation/swiftdata/modelcontext.json), [ModelConfiguration](https://developer.apple.com/tutorials/data/documentation/swiftdata/modelconfiguration.json), and [VersionedSchema](https://developer.apple.com/tutorials/data/documentation/swiftdata/versionedschema.json). Apple HTML pages were JavaScript-rendered and inaccessible in that check; the official JSON pages supplied the stated contracts. The installed Xcode 27.0 (27A266a), Swift 6.4, iOS 27 SDK `SwiftData.swiftinterface` was checked for the exact URL/configuration, `allowsSave`, `cloudKitDatabase`, autosave, save, rollback, `ModelContainer`, and versioned-schema declarations used here. The transaction declaration was checked as an alternative; this adapter intentionally uses explicit `save()` with `rollback()` on failure.
