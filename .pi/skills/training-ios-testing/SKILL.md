---
name: training-ios-testing
description: "Trigger: Swift testing, XCTest UI, regression tests, persistence tests, migration, recovery, device validation. Verify app behavior with honest evidence."
---

## Activation Contract
Use for behavior changes, test planning, failure-path validation, or reporting verification. Do not fabricate lifecycle evidence; passive standards documentation has no meaningful behavior-level RED.

## Hard Rules
- For meaningful behavior, observe a focused failing test before implementation and passing evidence afterward; otherwise state the narrow reason RED is inapplicable.
- Use Swift Testing for focused domain/state contracts where suitable; retain XCTest for UI automation and cases it serves. They can coexist.
- Inject a fake clock, temporary store and failure seams where useful. Use synthetic migration fixtures; never real personal data.
- Test validation, stable identity/snapshots, comparability, transaction failure, rollback, cancellation, import invariants, lifecycle recovery, idempotence and interrupted migration where relevant.
- Avoid flaky sleeps; calculate time from fake-clock deadlines. Keep physical-device checks separate from simulator/test results.
- Report exact commands and observed results. Do not claim build, accessibility, performance, or hardware checks that were not run.

## Decision Gates
Select tests from changed contracts and failure modes, not coverage targets alone. Decide whether behavior has a meaningful pre-implementation assertion. Identify any test requiring hardware or a resolved product policy and keep it explicitly pending.

## Execution Steps
1. Read the implementation roadmap and relevant architecture/safety decision.
2. Add the smallest focused behavior test; observe and record RED if meaningful.
3. Implement, observe GREEN, then test material alternate/negative cases.
4. Run authorized exact commands; report simulator and physical-device evidence separately.

## Output Contract
List contract tested, RED/GREEN evidence or justified exception, exact command/result, injected failure/alternate cases, and remaining device/runtime checks. Never infer success from authored tests alone.

## References
- [Research decisions](../../../docs/research/ios-development-standards.md)
- [Testing matrix and work-unit evidence](../../../docs/implementation-roadmap.md)
- [Architecture and recovery invariants](../../../docs/architecture.md)
