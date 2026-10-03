---
name: training-ios-performance
description: "Trigger: SwiftUI performance, Instruments, hitch, body update, memory, energy, history growth, timer. Measure this iPhone app before optimizing."
---

## Activation Contract
Use for hot paths, rendering/input responsiveness, timer behavior, memory/energy, or growing history. Performance claims require observed evidence on stated hardware/build conditions.

## Hard Rules
- Establish a measurable physical-device Release-like baseline for the affected flow before claiming improvement; record device, OS, build configuration and workload.
- Use Instruments to inspect SwiftUI body updates, hitches, main-thread work, memory, energy and history growth as relevant.
- Prefer stable identity and appropriately scoped observation. Use lazy or bounded fetches only when profiling/data growth justifies them; preserve ordering and correctness.
- Do not add arbitrary microbenchmarks, speculative caches, broad actorization, or unsupported performance claims.
- Rest timers derive from absolute deadlines on foreground/relaunch. Never depend on continuous background ticking or animation frames.
- Glass is selective; keep dense workout content readable and bound expensive effect regions.

## Decision Gates
Name the user-visible symptom and repeatable workload. Choose the metric and acceptable threshold before optimization. If no measured bottleneck exists, avoid speculative changes; if hardware is unavailable, state the device-check gap.

## Execution Steps
1. Read design, architecture and roadmap guidance; verify current API availability before platform-sensitive changes.
2. Capture the same baseline and after-change workload with Instruments on a physical device using a Release-like build.
3. Attribute the bottleneck before changing observation, fetching, computation or composition.
4. Re-run relevant correctness/accessibility checks and compare measured results under the same conditions.

## Output Contract
Report exact hardware/build/workload, tool/trace observations, before/after measurements, trade-offs and unrun checks. Do not extrapolate simulator results to physical-device glass or energy behavior.

## References
- [Research decisions](../../../docs/research/ios-development-standards.md)
- [Design and device checks](../../../docs/liquid-glass-design.md)
- [Performance work-unit gates](../../../docs/implementation-roadmap.md)
