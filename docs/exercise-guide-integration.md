# Exercise-guide integration: review tracker

> **Planning tracker only.** This document records a proposed three-part review chain; it is not evidence that guide integration is complete, and it is not merge-ready. No merge is authorized. The tracker is proposed on `feat/exercise-guides-integration`, based on `12c336c5943dbecbcc54fdbd9fd8d9a848a6da10`; it is intended to remain a sibling of the G1 geometry work, not a descendant of it.

## Proposed review units

| Unit | Branch and endpoint | Base / dependency | Planned diff |
|---|---|---|---:|
| Catalog | `feat/exercise-guides-01-catalog` → `86161a225e3dcf9b903e7a163806954e21197434` | `feat/exercise-guides-integration` / tracker | 571 changed lines, 7 files |
| Navigation | `feat/exercise-guides-02-navigation` → `d8db1012045143ad1962f9589c791de0578d5056` | Catalog endpoint `86161a225e3dcf9b903e7a163806954e21197434` | 302 changed lines, 6 files |
| Docs | `feat/exercise-guides-03-docs` → `20554fd93c2eab17946ff4f94baf8f3660f3d87c` | Navigation endpoint `d8db1012045143ad1962f9589c791de0578d5056` | 54 changed lines, 3 files |

The catalog unit intentionally retains its cohesive validation/test coverage despite exceeding the advisory 400-line review budget; splitting those validation tests would redo cohesive work rather than make a smaller independently reviewable unit. These are recorded source endpoints and planned boundaries, not evidence of publication or current PR state.

## Scope and boundaries

- Preserve the 36 original Spanish guides immutably, their 37 references, 30 unchanged prescriptions, and seven variant choices. One incline-machine reuse is the legitimate exception to otherwise distinct variants.
- No session behavior, persistence, assets, networking, timers, backups, dependencies, or new app behavior are authorized by this plan.
- The plan does not authorize merging any child or the tracker. The first child is explicitly **not** a descendant of the tracker commit; this sibling-base geometry arrangement is accepted for the proposed review chain. Any later child merge requires fresh human permission.
- Follow-up links point to branch URLs so publication does not require editing this tracker merely to insert PR numbers: [catalog](https://github.com/edwinupegui/my-training-app-ios/tree/feat/exercise-guides-01-catalog), [navigation](https://github.com/edwinupegui/my-training-app-ios/tree/feat/exercise-guides-02-navigation), [docs](https://github.com/edwinupegui/my-training-app-ios/tree/feat/exercise-guides-03-docs).

## Evidence and review status

G1 lineage `review-2f81f531be923a47` and G2 lineage `review-655d41a2675a9549` were approved and acknowledged; the review authorities are burned. That approval applies to the exact source candidates only. Passive checks on this planning document do not reapprove those sources or the feature. Earlier domain (15) and UI (7) passes were separate runs. The prior standalone build succeeded, but was not rerun for this documentation; do not describe the historical runs as a combined-suite run.

R3-001 is an informational reliability warning at `ExerciseGuideView.swift:79–81`, nonblocking and a follow-up; no correction is included here. The recorded 571-line catalog diff remains cohesive because it contains its validation tests; do not split or redo that work just to meet a heuristic.

Still pending: physical signing and installation, VoiceOver, actual Dynamic Type, contrast, Reduce Motion/Reduce Transparency, materials, airplane-mode behavior, and runtime-injected fallback. Until those checks and the required human review are complete, the chain is not merge-ready.

## Repository and publication constraints

No guide document existed at the tracker base. Until the docs unit lands, use the immutable source link [exercise guides at the documented endpoint](https://github.com/edwinupegui/my-training-app-ios/blob/20554fd93c2eab17946ff4f94baf8f3660f3d87c/docs/exercise-guides.md), not a broken relative link.

No generic-repository PR template, workflow, branch rule, required CI, approved issue, or label policy has been observed. Do not invent issue references, labels, or automated-check claims. This document records owner-approved planning scope; the four companion files are draft publication bodies. No merge is authorized, and labels are not authorized. The tracker does not claim that guide features are integrated.

## Review gates

1. Review each child against its stated immediate base and verify the diff contains only its named unit.
2. Keep the tracker and all children draft/no-merge while required human review and device/runtime checks remain outstanding.
3. Record actual verification when performed; do not convert historical separate passes into a new combined-suite claim.
4. Obtain explicit human permission before merging any child or the tracker. Publication of branches or PRs does not grant merge permission.
