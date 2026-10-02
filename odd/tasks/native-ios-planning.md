# Native iOS planning documentation

## Objective
Create a local, independent `my-training-app-ios` repository beside `edwin-training-app`, containing actionable planning only for a private native iPhone training app.

## Problem and rationale
The reference app supplies a static training program and exercise guides but no workout/session history. The native app needs recoverable offline logging, an authentic Liquid Glass interface, and reliable manual backups before optional integrations.

## Authorization and constraints
- User authorized local repository creation and documentation only; subsequently authorized configuring `origin` as `git@github.com:edwinupegui/my-training-app-ios.git`, renaming the current branch to `main`, and pushing it. No Swift code, Xcode project, app installation, dependency installation, implementation, or GitHub repository creation is authorized.
- Do not modify the reference repository or include personal metrics, credentials, device identifiers, signing identities, or real backups.
- User explicitly authorized the initial documentation commit and push, then confirmed keeping the GitHub repository public with the selected author identity. Use the repository-local personal Git identity, preserve global configuration, and publish only the reviewed documentation/ignore files. No app development is authorized.
- Technical documentation is in English; user-facing conversation remains Spanish. Initial UI language follows the Spanish reference.
- Confirmed: iPhone 17, user-reported iOS 27.0.1; strong native Liquid Glass identity; local data with manual export/import; no App Store/TestFlight; current routine plus per-session adjustments, full routine editor deferred.
- Stable toolchain research as of 2026-10-01: Xcode 27 build 27A266a, Swift 6.4.0 upstream / bundled Apple Swift 6.4, iOS SDK 27.0. Installed Xcode/compiler/SDK match. Device validation has not happened.
- Proposed, not independently approved: iOS 27.0 deployment minimum, encryption details, excluding data from automatic device backups, exact signing membership choice, measurements extent and restore policy.

## Tasks
- [x] P1 Initialize an independent local Git repository on `docs/native-plan` and establish this task document.
- [x] P2 Write a cohesive planning package: README, scope, architecture/data/backups, Liquid Glass design, delivery/testing roadmap, and evidence/private-installation research.
- [x] P3 Independently verify documentation, local links, requirements consistency, no implementation artifacts, and repository isolation; reconcile findings and report pending decisions.
- [x] P4 Rename the repository to `my-training-app-ios`, update applicable current references, preserve Git/project identity and historical evidence, and verify links.
- [ ] P5 Configure the user-selected SSH origin and `main` branch; publish documentation only after initial commit authorization and a pre-publication privacy check.

## Acceptance and checks
- Repository is rooted at `my-training-app-ios`, not the ancestor home-directory Git repository.
- Documentation distinguishes verified research, user-confirmed requirements, recommendations, and unresolved decisions.
- Scope covers offline session/set logging, RIR/load/repetitions, recovery, timestamp-based rest timers, last performance/history, exercise guides, versioned export/import, and privacy.
- Architecture separates prescribed routine versions/snapshots from performed sessions; backup restoration validates before modifying live data.
- Liquid Glass plan uses native APIs with legibility, accessibility, physical-device performance, and no stacked-glass blanket treatment.
- Plan includes phased actionable implementation units and measurable future checks; no checkbox implies implemented functionality.
- Private installation documents free seven-day signing vs paid membership, Developer Mode, renewal without deletion, and no App Store requirement.
- Relative Markdown links resolve; only documentation and ignore configuration are authored.
- No behavior changed: RED/GREEN/build/UI checks are not applicable in this documentation-only stage. Future functional checks remain explicitly pending.

## Progress and evidence
- P1: independent Git initialization succeeded on `docs/native-plan` under the original directory name. That historical command is unchanged evidence; P4 renames the existing repository without reinitializing it.
- Commit evidence: initial documentation commit and public publication authorized; commit creation and push are in progress. Record the resulting immutable commit identity locally after verification.
- Engram mirror: pending. Save to the new project was rejected because the installed server does not advertise `capabilities.isolated_session_registration`; no cross-project mirror was claimed or substituted.
- P2: documentation writer produced README, five linked planning documents, and a narrow `.gitignore`; 409 Markdown lines across README/docs. Parent read back README and architecture. Writer and parent observed `git diff --check` with no output (untracked-file coverage requires P3's explicit scan). `git rev-parse --show-toplevel` resolves to the new repository; branch has no commits. No implementation files were created.
- P3: independent verifier PASS. Eight expected authored files; 16 local links and eight fragments/source-line references resolve. Explicit all-file scan found no trailing whitespace, missing final newlines, CR characters, flagged private values, or unexpected implementation artifacts. Git root is independent; zero commits and no remotes. Scope, source freshness, signing limits, data recovery, and Liquid Glass accessibility are coherent. External sources were not re-fetched; no app build/device installation was performed.
- Native read-only ASSESS: unavailable (`unassessable`) because the new files are untracked without a review declaration. Its conservative independent-verifier plan was fulfilled by the writer checks plus separate verifier; no native approval is claimed. Native review is skipped for this passive documentation-only candidate.
- App builds, behavior tests, on-device visual/performance checks, signing, and installation remain future work, not failures in this documentation-only stage.
- P5: `origin` configured to the owner-selected SSH URL and branch renamed to `main`. Independent pre-publication verification passed eight-file privacy/whitespace scans and 16 links/eight fragments. `git ls-remote` succeeded with no refs; GitHub reports the repository is public. User confirmed public visibility; commit and push are in progress. Verify the advertised remote `main` commit before marking P5 complete.
- P4: directory renamed without Git reinitialization; README, current task references, and local Engram project label updated while preserving its stable ID. Independent verification PASS: old directory absent, correct independent root and branch, no old-name references across ten checked text files, 16 local links and eight fragments resolve, and explicit untracked-file whitespace checks pass. No implementation artifacts, commits, or remotes.

## Next step
Owner reviews the planning package and resolves decisions before the relevant implementation unit: deployment minimum, signing membership, backup encryption/recovery, restore policy, automatic device backups, and measurements. Implementation requires separate authorization and must not start before GitHub setup is completed and the owner explicitly permits development. The explicit origin/branch/push request and subsequent initial-commit approval authorize documentation publication only, not app implementation. Resynchronize the full Engram mirror when isolated project registration becomes available.
