# Pure session domain

The session feature currently contains a Foundation-only value model for creating an immutable routine snapshot, validating set values, recording ordered sets, and closing a session. It has no SwiftUI, persistence, or adjustment UI.

## Current contract

- Session snapshots copy routine version, day/exercise identity, prescription text, order, and the explicitly selected guide reference and guide identity. Composite guide choices must be selected; source catalogs are validated before snapshot creation.
- Set records require a nonblank exercise identity, positive per-exercise order and repetitions, finite nonnegative load, and nonnegative optional RIR. Missing RIR remains distinct from zero. There is no arbitrary upper magnitude limit.
- Load mode (external or bodyweight), unit, optional added bodyweight load, and bilateral/left/right side are explicit values.
- Comparability requires the set records to match their snapshots, the same stable source exercise ID, the same selected guide reference and guide identity, compatible load mode/unit/added-load status, and the same side. Names and ordering do not establish identity.
- Sessions accept sequential sets and transition from active to completed or abandoned; closed sessions reject further mutations, duplicate set IDs are rejected, and end times cannot precede start times.

## Deliberate boundary

Routine and guide catalogs remain immutable bundled content. Prescription strings are copied as opaque text, not parsed into set targets. This domain does not implement persistence, transactions, recovery, active-session uniqueness across stored sessions, session adjustments, set editing/deletion, timers, history lookup, UI, or backup. Those behaviors remain later work units; no elapsed-time pause lifecycle is defined.

## Verification evidence

On 2026-10-04, the focused 13-test session-domain suite and the 28-test unit-test target passed on the paired iPhone 17 (iOS 27.0.1). The physical-device app build succeeded. The focused test includes a negative regression for distinct exercise identities that reuse the same selected guide, and a positive case showing display-name/order changes do not affect the same exercise's comparison. See `build/U2Device-red3-20261004-writer-b653.xcresult`, `build/U2Device-green-20261004-writer-1d93.xcresult`, `build/U2Device-regression-20261004-writer-8eb5.xcresult`, and `build/U2Device-build-20261004-writer-9e21.log`.

These functional checks do not certify persistence/recovery, session UI, accessibility, or owner signing/distribution acceptance. The app's configured bundle/signing choice and any separate owner confirmation remain separate from domain test results.
