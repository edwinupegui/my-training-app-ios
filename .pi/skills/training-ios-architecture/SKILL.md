---
name: training-ios-architecture
description: "Trigger: iOS architecture, SwiftUI feature design, domain model, state ownership, persistence boundaries. Apply this project's feature-first single-target architecture without unnecessary layers."
---

## Activation Contract
Use for architecture or feature-boundary decisions in this planned native iPhone app. App implementation remains a separate authorized work unit; standards do not authorize app code.

## Hard Rules
- Organize by feature in one app target; keep domain values/rules independent of SwiftUI and SwiftData.
- Use stable IDs, explicit units/modes and comparability; never use display names or positions as identity.
- Snapshot routine/version and prescription when a session starts; edits must not rewrite routine definitions or completed history.
- Keep lifecycle states explicit and bounded. Do not invent approved pause semantics; interruption recovery is not elapsed-time pause.
- Use observation for changing view-facing state where useful, MVVM only when it earns a boundary, and adapters for concrete persistence/API seams.
- Inject clock/store at composition boundaries when substitution or lifecycle control matters. Avoid protocol-per-type, generic repositories, global containers, and layer-per-framework.

## Decision Gates
Ask whether a boundary protects a real invariant, supports a second implementation, or improves testing. If not, keep the smallest direct design. Add actor isolation only for framework-required or shared mutable-state safety; retain compiler-checked Sendable crossings.

## Execution Steps
1. Read the architecture and source decision record; recheck source freshness before API-sensitive implementation and record the date.
2. Map feature ownership, domain invariants, persistence adapter, and composition point.
3. State unresolved product/toolchain gates that affect the proposal; do not infer API availability or approved OS minimum.

## Output Contract
Report the proposed boundary, invariant it protects, alternatives rejected, tests needed, unresolved gates, and exact supporting sources. Distinguish proposal from implemented behavior.

## References
- [Research decisions](../../../docs/research/ios-development-standards.md)
- [Architecture and data](../../../docs/architecture.md)
- [Product scope and open decisions](../../../docs/product-scope.md)
