---
name: training-workout-ux
description: "Trigger: workout UX, SwiftUI screen, set entry, accessibility, VoiceOver, Dynamic Type, Liquid Glass. Design clear and recoverable training flows."
---

## Activation Contract
Use when changing workout flows, set entry, guidance, timer presentation, navigation surfaces, or accessibility. Product behavior remains subject to scope decisions and implementation authorization.

## Hard Rules
- Prefer native controls and fast, one-hand set entry. Keep load, reps, units/mode, validation, save status, and correction affordances explicit.
- Preserve input and existing records through interruption and failure; communicate save success/failure and recovery state clearly.
- Never imply a true elapsed-session pause or choose pause semantics without owner approval. Resume after interruption is distinct from pausing.
- Keep dense entry, instructions and history on readable standard surfaces. Use Liquid Glass only on selected navigation/control surfaces; do not obscure content or focus.
- Support VoiceOver names/values/focus and meaningful announcements, Dynamic Type/reflow, sufficient contrast, Reduce Motion and Reduce Transparency with opaque alternatives. Do not encode status by color alone.
- Avoid unapproved clinical/coaching claims or ambiguous units and comparability.

## Decision Gates
Check the relevant product decision before presenting a new lifecycle or restore action. Ask whether action, error, correction and recovery are understandable one-handed and with assistive technology. Validate materials on supported hardware after support/API gates are known.

## Execution Steps
1. Read scope and design acceptance; identify the user task and failure/recovery path.
2. Specify control labels, units, focus, save feedback and correction before styling.
3. Use system controls; reserve glass for hierarchy/action and check safe areas, keyboard and focus.
4. Test VoiceOver, large text, contrast, Reduce Transparency/Motion and physical-device interaction; distinguish simulator evidence.

## Output Contract
Describe the flow, units/states, error and recovery feedback, accessibility checks, material use and unresolved product decisions. Mark unperformed physical checks explicitly.

## References
- [Research decisions](../../../docs/research/ios-development-standards.md)
- [Design and accessibility acceptance](../../../docs/liquid-glass-design.md)
- [Product scope and decisions](../../../docs/product-scope.md)
