---
name: training-swift-quality
description: "Trigger: Swift code review, Swift API design, concurrency, Sendable, compiler diagnostics, code quality. Apply focused idioms and safety checks to this iPhone app."
---

## Activation Contract
Use when authoring or reviewing Swift implementation. This project is planning-only; use these standards only within a separately authorized app work unit.

## Hard Rules
- Prefer intent-revealing names, value semantics and narrow functions. Keep APIs small and make invalid states difficult to represent where practical.
- Apply KISS and DRY to actual repeated behavior with the same meaning; do not extract lookalike flows with different policy.
- Handle errors exhaustively at boundaries; preserve actionable failure information instead of swallowing errors or asserting on expected input.
- Make ownership and mutation explicit. Respect actor isolation and `Sendable`; avoid data races, detached work without a clear need, and `@unchecked Sendable` escape hatches.
- `async` does not automatically move CPU work off the main actor. Verify executor/isolation behavior and move expensive work only with safe data crossings.
- Do not assume language, SDK, or API versions. Check the project's compiler settings, deployment target, and availability before selecting syntax or APIs.

## Decision Gates
Before adding abstraction, prove a semantic reuse, substitution, isolation, or testability need. Before changing concurrency, identify executor, data ownership, cancellation behavior, and framework contract. Escalate unresolved target/toolchain choices rather than guessing.

## Execution Steps
1. Read current project architecture decisions and check source freshness for API-sensitive work; record the check date.
2. Inspect surrounding style and target/compiler settings before choosing syntax or isolation annotations.
3. Keep changes focused; validate compiler diagnostics and focused tests using commands approved for the work unit.
4. Explain errors, cancellation and isolation behavior at the boundary.

## Output Contract
Summarize the API and ownership choices, relevant concurrency/cancellation behavior, exact checks run, and any version-dependent assumptions still requiring verification. Do not claim compiler validation unless observed.

## References
- [Research decisions](../../../docs/research/ios-development-standards.md)
- [Architecture and data](../../../docs/architecture.md)
- [Implementation gates](../../../docs/implementation-roadmap.md)
