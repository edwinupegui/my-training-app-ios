# Liquid Glass design plan

## Intent

The planned interface should feel unmistakably native and use Liquid Glass to clarify navigation, hierarchy, and actions—not as a decorative coating on every card. Build with SwiftUI and system materials/APIs. Do not port web CSS blur, translucent panels, or copied reference styling.

## Screen map

| Screen | Planned content | Glass role |
|---|---|---|
| Home / week | Today's session or recovery, week overview, resume active-session action. | System tab/navigation chrome; one restrained prominent action. Keep routine facts on readable standard surfaces. |
| Session | Ordered exercises, prescribed target, per-session adjustment, logged sets, last comparable performance. | Use glass for floating high-priority session controls only where it remains legible and does not obscure data entry. |
| Set entry | Load/mode, reps, optional RIR, save, and rest action. | Prefer clear native form controls and strong contrast over a custom glass form. Numeric entry must remain easy to operate. |
| Rest | Remaining time derived from deadline; pause/skip/adjust if approved. | A focused, high-emphasis control may use glass; no continuous background animation assumption. |
| Exercise guide | Technique, equipment, cues, errors, breathing; optional later-reviewed art. | Standard reading surface; avoid overlaying long text on translucent material. |
| History / progress | Dated sessions and modest comparable trends. | Charts remain readable and correctly labeled; glass may frame navigation or filters, not data marks. |
| Backup/settings | Export/import, privacy explanation, storage and version context. | System presentation and accessible native buttons; destructive restore requires explicit confirmation. |

Use native `TabView`, navigation containers, toolbar/system controls, and platform-standard sheets where appropriate. The exact screen hierarchy remains subject to prototype review on supported hardware.

## Native APIs and composition rules

- Use SwiftUI's system Liquid Glass behavior for system controls and bars; adopt `glassEffect` for selected custom interactive controls and `GlassEffectContainer` when related effects should compose together.
- Prefer native glass variants and shape/interaction APIs over handmade blur materials. Avoid layering one glass surface over another or applying the effect to every table row/card.
- Reserve the strongest material for a small number of high-priority navigation/action elements. Keep exercise prescription, set values, errors, and history on stable, opaque/readable backgrounds.
- Ensure content has safe-area separation from system glass bars and floating actions. Do not let glass obscure a set-save target, accessibility focus, chart labels, or critical text.
- Use consistent spacing, grouped sections, short labels, and progressive disclosure. Keep action labels explicit; an icon alone is not sufficient for a critical action.
- Motion should communicate state change, not decoration. Respect Reduce Motion and do not make rest timing depend on animation frames.

References: [SwiftUI: applying Liquid Glass to custom views](https://developer.apple.com/documentation/swiftui/applying-liquid-glass-to-custom-views), [GlassEffectContainer](https://developer.apple.com/documentation/swiftui/glasseffectcontainer), and [Human Interface Guidelines: Materials](https://developer.apple.com/design/human-interface-guidelines/materials). These official linked references inform investigation; this planning pass did not fully review every page or validate API availability against a built target.

## Accessibility and legibility acceptance

- Verify VoiceOver names, values, hints, focus order, rotor/navigation structure, and announcements for save success/error, session recovery, timer changes, and restore confirmation.
- Support Dynamic Type without clipping exercise names, instructions, load/reps controls, alerts, or glass-backed actions. Scrolling and layout reflow must remain usable at the largest supported sizes.
- Check text and control contrast over both light and dark content, bright/highly detailed backgrounds, and system appearance changes. Do not rely on translucency alone to distinguish controls.
- Honor Reduce Transparency by providing a clear opaque alternative; honor Reduce Motion by removing nonessential transitions and animation.
- Ensure touch targets and hit areas are sufficiently large and do not overlap; keyboard focus, hardware keyboard, and switch/accessibility interaction must remain possible.
- Communicate validation with text and focus, not color alone. Use visible units and explicit unilateral/bodyweight mode selection.

## Performance and device verification

Liquid Glass is a visual treatment, not permission for expensive composition. Keep blur/effect regions bounded; avoid many overlapping animated layers, repeated geometry work, or large translucent surfaces behind dense content. Keep scrolling and set entry responsive while history data grows. Profile release-like builds on physical hardware, not only a simulator.

Future device acceptance on a supported iPhone:

1. Inspect system bars, tab/navigation transitions, sheets, custom `glassEffect` controls, safe areas, keyboard, and orientation/layout conditions relevant to the app.
2. Exercise session logging, rest countdown, and restore flow under both appearance modes and with long labels/instructions.
3. Repeat with large Dynamic Type, VoiceOver, Reduce Transparency, and Reduce Motion; confirm opaque fallbacks and focus never disappear behind glass.
4. Check scrolling/input responsiveness and memory/energy behavior during normal session and history use; reduce effects if measurements or thermal behavior regress.
5. Capture screenshots and record OS/device/build details only after implementation exists. No such review has been performed for these planning docs.

## Non-goals

- Do not claim Liquid Glass fidelity from static mockups or a simulator screenshot alone.
- Do not retrofit reference CSS or its imagery.
- Do not use glass as a substitute for hierarchy, contrast, accessibility, or performance testing.
- Do not add Live Activities or background execution guarantees for rest timers; those are deferred and outside this plan.
