---
name: training-local-data-safety
description: "Trigger: SwiftData persistence, local data, migration, import/export, restore, transactions, recovery. Protect this app's offline training records and unresolved privacy choices."
---

## Activation Contract
Use for persistence, schema, migration, export/import, or durable-state changes. Implementation requires its own approved work unit and closure of relevant product decisions.

## Hard Rules
- Keep SwiftData behind a focused adapter; domain rules and portable DTOs must not depend on storage representation.
- Define transaction/save boundaries explicitly. Save related changes atomically where supported; surface errors, roll back or preserve recoverable state, and never imply success before durability.
- Version schema and test migrations with synthetic historical fixtures. Preserve original records on failure; never silently delete/recreate the store as recovery.
- Bound and validate imported DTOs completely—version, size/counts, IDs, references, units, ranges and ordering—before any live mutation. Cancellation/rejection leaves current data unchanged.
- No backend, CloudKit, automatic sync, or raw-store backup. Do not assume “on device” excludes iOS device backups.
- Encryption, key recovery, device-backup policy, and restore merge/replace behavior are unresolved gates. Do not invent a policy or claim protection.

## Decision Gates
Before writing, identify mutation boundary, rollback/recovery route, schema/format version, and failure behavior. Stop for owner decisions on encryption, restore policy, or system-backup stance when affected. Keep portable backup version independent of SwiftData schema.

## Execution Steps
1. Read architecture and scope decisions; confirm relevant choices before implementation.
2. Define a bounded staging/validation path and transaction boundary.
3. Exercise migration, failure injection, cancellation, interrupted recovery and unchanged-live-data invariants with synthetic data.
4. Report exact tests and unresolved recovery/privacy choices.

## Output Contract
State what is durable, when it commits, how failure preserves data, migration/import evidence, and unresolved policy. Never describe untested recovery as guaranteed.

## References
- [Research decisions](../../../docs/research/ios-development-standards.md)
- [Architecture and data safety](../../../docs/architecture.md)
- [Scope and decisions](../../../docs/product-scope.md)
