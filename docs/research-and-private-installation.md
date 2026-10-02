# Research and private installation

## Evidence status (checked 2026-10-01)

This section separates **verified release/account facts**, **local toolchain observation**, **user-reported device context**, and **open product choices**. It is a research snapshot, not a guarantee of future availability or an instruction that the planned app can already be installed.

| Claim | Evidence and status |
|---|---|
| Latest stable iOS release observed: 27.0.1 (24A446), dated Sep 28, 2026. | Parent checked the raw official [Apple releases RSS feed](https://developer.apple.com/news/releases/rss/releases.rss), whose `lastBuildDate` was Sep 28, and the [iOS 27.0.1 release page](https://developer.apple.com/news/releases/?id=09142026h). User separately reports an iPhone 17 on iOS 27.0.1; the device itself has not been inspected. |
| Stable Xcode observed: Xcode 27 (27A266a), released Sep 14, 2026. | Parent checked the official [Apple releases page](https://developer.apple.com/news/releases/?id=09142026h). Later Xcode 27.1 beta (Sep 18) and 27.2 beta 2 (Sep 28) were listed; they are not stable releases. |
| Local development environment observed: Xcode 27.0, exact build 27A266a; Apple Swift 6.4, `swiftlang-6.4.0.34.1`; iOS SDK 27.0 and macOS SDK 27.0.1. | Local parent observation; not a claim about a created app target or a successfully built app. |
| Upstream Swift release observed: Swift 6.4.0 is advertised by the [Swift install page](https://www.swift.org/install/) and its [6.4 release announcement](https://www.swift.org/blog/swift-6.4-released/) dates Sep 15, 2026. | Official Swift pages checked by parent. Upstream Swift version and bundled Apple Swift version are related but distinct labels. |
| Deployment target | **Unresolved recommendation:** iOS 27.0 was proposed, not approved. SDK version, installed OS version, and deployment minimum are separate settings. Decide supported devices/API availability before project setup. |

The parent verified the raw release feed, the cited Apple release record, Swift official pages, and account/help source text on the date above. The SwiftUI/SwiftData/Testing/CryptoKit and Human Interface Guidelines links elsewhere in this plan are official, source-linked API/design references; those full pages were not all reviewed as part of that raw release/signing verification. Recheck primary sources immediately before implementation or installation because release status, requirements, and fees can change.

## Private signing facts and limits

Apple documents free Personal Team provisioning as short-lived: development provisioning profiles expire after seven days and must be renewed. The documented free-account limits include up to three registered devices per platform, three apps per device, and ten App IDs. Check the current [developer account help](https://developer.apple.com/help/account/basics/about-your-developer-account/) before relying on these limits.

The paid Apple Developer Program is listed at USD 99 per membership year, with local pricing/tax potentially applicable ([program overview](https://developer.apple.com/programs/), [membership details](https://developer.apple.com/support/compare-memberships/)). Membership does not require App Store distribution; paid development profiles/certificates also expire and require renewal. Do not promise “permanent” installs: inspect the actual profile/certificate expiry and device behavior. Account membership, bundle ID, signing identity, and device pairing are not configured for this project.

No App Store or TestFlight release is planned. Distribution is private development installation to the owner's device. A signed development build is not an unsigned IPA that can be installed by copying a file onto a phone.

## Future private-installation checklist (not yet performed)

1. Choose free Personal Team or paid membership based on renewal cadence and current Apple terms. This signing choice remains open; neither choice entails public distribution.
2. When an implementation exists, configure its bundle identifier and signing team in Xcode without committing credentials, certificates, private keys, provisioning profiles, or account data.
3. Pair the iPhone with the development Mac using Xcode/device setup; connect by USB when needed and trust/pair as prompted. Confirm device OS and target support.
4. On device, enable Developer Mode through **Settings → Privacy & Security → Developer Mode**. Confirm the restart and final enable prompt. Apple describes this in [Enabling Developer Mode on a device](https://developer.apple.com/documentation/xcode/enabling-developer-mode-on-a-device).
5. In Xcode, select automatic signing for the development target, choose the paired iPhone as the run destination, resolve signing/profile errors, and run the app from Xcode. Keep the device unlocked for first pairing/install as Xcode requests.
6. Verify fresh launch, offline session save/relaunch, and backup/restore on the real device before relying on the build. Record actual OS, Xcode, profile expiry, and outcomes in the future implementation evidence.
7. Renew/rebuild/reinstall as required by the actual signing profile. Before updating, use the same bundle ID/team and verify installation behavior; do not uninstall the old app or promise that user data survives an update without testing the real path. Maintain a manual export before risky changes.

Specific Xcode labels and device prompts can change; follow current Apple docs and visible signing diagnostics rather than assuming a fixed UI. No signing or installation step above has been executed.

## Open choices — close at the relevant milestone

| Choice | Status | Needed before |
|---|---|---|
| iOS deployment minimum (iOS 27.0 proposed) | Not approved. | Project settings and API availability review. |
| Backup encryption and recovery | Not selected; no KDF, parameters, cipher, or recovery path approved. | Format/security implementation. |
| Restore behavior | Replace, merge, or explicit choice unresolved; collision rules unresolved. | Any live-data import implementation. |
| iOS/iCloud device-backup inclusion | Unresolved. Manual export does not exclude system backup. | Privacy copy and storage configuration. |
| Free vs paid signing membership | Unresolved. | Device provisioning and repeatable install procedure. |
| Measurements scope | Unresolved; do not assume or seed personal metrics. | Domain model, privacy copy, charts. |
| Local notifications for rest | Optional; no push/backend planned. | Timer implementation if user value warrants it. |

No extra approval is needed to write these planning documents. Close choices only before the dependent feature is implemented.
