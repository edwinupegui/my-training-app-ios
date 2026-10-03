# iOS development standards — research and decisions

**Research snapshot: 2026-10-02.** This is S1 of the iOS development-standards task.
It records project recommendations, not Apple requirements or implementation authorization.
The app remains unimplemented; see [scope](../product-scope.md),
[architecture](../architecture.md), [design](../liquid-glass-design.md), and
[roadmap](../implementation-roadmap.md).

## Decision summary

Use native SwiftUI with feature-first organization in one app target. Keep domain values and
rules independent of SwiftUI and SwiftData; compose dependencies at the app boundary; add
small observable UI state only where a view needs mutable presentation state. Put persistence
invariants and schema evolution in a focused adapter. Use actors/isolation to make a
well-defined boundary safe, not as a blanket store architecture. Measure SwiftUI performance
and validate access needs on supported hardware. These are project decisions informed by
Apple guidance, not Apple-prescribed architecture.

| Problem | Use | Avoid |
|---|---|---|
| Feature ownership/navigation | Group by feature in the single target; share domain concepts at stable boundaries. | Mirroring every framework as a layer, or coordinators/use-case-per-action without need. |
| View-facing changing state | Use `@Observable` where SwiftUI must track mutations; keep state local when view ownership suffices. | MVVM for every view, duplicate sources of truth, or making all domain data observable by default. |
| Domain rules and persistence | Pure value/domain types for validation, lifecycle, comparability, timer calculations; focused SwiftData adapter for mapping, transactions, migrations. | SwiftData leaking across features; generic repository/protocol layers without multiple implementations or a testing need. |
| Construction and dependencies | Inject store/clock at composition boundaries when substitution or lifecycle control is useful. | Global DI container, service locator, or an abstraction for every dependency. |
| Concurrency and storage | Start with clear isolation; add actor isolation at shared mutable-state or responsiveness boundaries, preserving `Sendable`. | Detached tasks, redundant actors, or serializing all store access before knowing framework contracts or contention. |
| Reuse and simplification | Apply KISS/DRY to stable domain knowledge and repeated behavior with the same meaning. | Premature generic frameworks or deduplicating similar-looking flows whose policies differ. |
| Session transitions and time | Model permitted transitions explicitly; inject a clock for deadline/recovery logic. | Boolean combinations, assumed background execution, or wall-clock waits in tests. |

## Platform guidance applied

### Observation and state

Apple's WWDC23 Observation session describes `@Observable` as tracking changes to properties
of ordinary Swift types and demonstrates a simpler SwiftUI model path than `ObservableObject`.
Adopt that capability for presentation state where useful; it does not remove the need to define
ownership, persistence, or domain boundaries. Do not create an observable wrapper per screen by
rule.

### Concurrency and isolation

WWDC25's concurrency session recommends approachable default isolation for UI-oriented
modules and says concurrency should be introduced when needed to improve performance. It
explains `Sendable` value types and actor isolation. Its SwiftUI session discusses main-actor
behavior and moving work off the main thread.

Therefore, keep UI mutations appropriately main-actor isolated and expensive work off the UI
executor. Let compiler isolation diagnostics guide safe crossings. Define store isolation from
actual SwiftData/API guarantees and measured use, not by mandating a universal `StoreActor`.

### SwiftData schema and recovery

WWDC25's SwiftData migration session demonstrates versioned schemas and custom migration
stages for real data changes, including deduplication. WWDC23 provides schema/migration
foundations. Treat migration as explicit data-preservation work: version schemas, migrate known
historical shapes, test representative prior stores, and preserve recoverable originals on
failure.

A staged plan is warranted for changes requiring transformation or validation, not every
additive field. SwiftData migration APIs do not define this app's backup format or decide its
restore policy.

### Tests

Apple's WWDC26 *Migrate to Swift Testing* says Swift Testing works alongside XCTest and
presents incremental migration/interoperability, not an all-at-once replacement. Use Swift
Testing for focused domain, state-transition, clock, validation and migration tests; retain
XCTest where UI automation or existing tooling fits. Use synthetic fixtures only.

Tests should establish transaction/recovery contracts and accessibility-critical flows;
screenshots alone cannot establish usability.

### SwiftUI performance and Liquid Glass

WWDC25's SwiftUI Instruments session introduces the SwiftUI instrument and examines long body
updates and unnecessary updates. Profile observed problems—especially session input, scrolling
and history growth—before optimizing; record device/build context and avoid speculative blanket
micro-optimization.

Apple's WWDC25 Liquid Glass sessions describe an adaptive material for controls/navigation,
keeping content prominent, and call out legibility and accessibility adjustments including
Reduce Transparency and increased contrast. Reserve glass for selected navigation/actions;
keep dense set entry, instructions and history on readable surfaces. Verify VoiceOver, large
text, contrast, transparency/motion settings, focus and real-device compositing.

This follows existing [design acceptance](../liquid-glass-design.md#accessibility-and-legibility-acceptance).
Supported OS/API availability remains a project gate.

## Project architecture and safety decisions

- **One app target, feature-first folders.** This fits a single-user offline product without
  framework-driven module proliferation. Share domain types by stable meaning, not by creating
  a layer for every feature.
- **Domain independent of UI/persistence.** Preserve routine snapshots, completed history,
  explicit units/comparability, session invariants and absolute timer deadlines in testable
  domain operations. SwiftUI renders/gathers intent; SwiftData is an implementation choice
  behind focused access and migration logic.
- **Injection at useful seams.** Supply store and clock at composition points; inject
  notification capability only if implemented. Use substitutes in tests without a container
  or protocol for every concrete dependency.
- **Actor boundaries by need.** Follow compiler isolation and framework contracts. Keep
  UI-facing state safely isolated; isolate mutable shared operations when justified. Do not
  mark the whole domain main-actor because views use it, nor move work off-main without
  considering `Sendable` and executor behavior.
- **Recovery is a data contract.** Persist meaningful session actions and recover the last
  durable state. Migrations and imports must not silently erase live/history data. Validate
  imports before mutation; cancellation/rejection leaves existing data unchanged. “On device”
  does not imply exclusion from iOS device backups. Encryption, restore merge/replace behavior,
  and system-backup policy remain undecided.
- **UX follows workout use.** Set saves need visible success/failure; controls remain usable
  during workout entry; timers recalculate from deadlines after interruption. Simulator passes
  do not validate material behavior or accessibility on hardware.

## Scope and unresolved gates

The owner selected support for the **current iPhone only**. This does not establish model/OS
compatibility or a minimum deployment target. At research time, local tools reported Xcode
27.0 (27A266a), Apple Swift 6.4.0 (`swiftlang-6.4.0.34.1`), and iOS SDK 27.0.
These are environment observations only—not a configured target or successful build.

Confirm exact supported device/OS, deployment minimum, API availability, signing/team and
bundle identity before project setup. Do not reuse the proposed iOS 27.0 minimum as approved.
Keep open: session pause semantics; backup encryption/key recovery; import replace/merge and
conflict behavior; iOS/iCloud device-backup inclusion; measurements scope; and whether local
notifications add value. Do not invent decisions. Resolve only those affecting a proposed
implementation unit, as directed by [scope decisions](../product-scope.md#decisions-required-before-affected-work)
and the [roadmap gate](../implementation-roadmap.md#delivery-and-authorization-gate).

## Source evidence and limits

Reviewed sources below are Apple video pages with accessible transcripts, except the Swift
guidelines page noted separately. Titles and transcripts were checked 2026-10-02. The [official
developer videos index](https://developer.apple.com/videos/) displayed WWDC26 featured sessions;
the 2026 Swift Testing title and transcript were verified, not inferred from search snippets.
This is proportionate research, not proof each is Apple's newest guidance on its topic.

**Transcripts reviewed**

- [Discover Observation in SwiftUI (WWDC23, 10149)](https://developer.apple.com/videos/play/wwdc2023/10149/)
  — observable model/property tracking and SwiftUI state integration.
- [Embracing Swift concurrency (WWDC25, 268)](https://developer.apple.com/videos/play/wwdc2025/268/)
  and [Explore concurrency in SwiftUI (WWDC25, 266)](https://developer.apple.com/videos/play/wwdc2025/266/)
  — default isolation, `Sendable`, main-actor behavior, and introducing concurrency deliberately.
- [Model your schema with SwiftData (WWDC23, 10195)](https://developer.apple.com/videos/play/wwdc2023/10195/)
  and [SwiftData: Dive into inheritance and schema migration (WWDC25, 291)](https://developer.apple.com/videos/play/wwdc2025/291/)
  — schema evolution and custom migration examples.
- [Migrate to Swift Testing (WWDC26, 267)](https://developer.apple.com/videos/play/wwdc2026/267/)
  — XCTest interoperability and incremental migration.
- [Optimize SwiftUI performance with Instruments (WWDC25, 306)](https://developer.apple.com/videos/play/wwdc2025/306/)
  — SwiftUI instrument, long body updates and unnecessary updates.
- [Meet Liquid Glass (WWDC25, 219)](https://developer.apple.com/videos/play/wwdc2025/219/)
  and [Build a SwiftUI app with the new design (WWDC25, 323)](https://developer.apple.com/videos/play/wwdc2025/323/)
  — adaptive material, content hierarchy, legibility and accessibility.

The [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/)
endpoint was reachable but its JS-rendered content was not verified; it is a **follow-up link,
not evidence used for a specific claim**. Apple API/design pages for Observation, SwiftData,
Swift Testing, SwiftUI Instruments and Liquid Glass were not fully reviewed here; follow official
references during implementation for exact API availability and details. This is not an
exhaustive latest-version audit. No Xcode/iOS release minimum is inferred from these sources.
