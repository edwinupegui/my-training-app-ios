# Offline exercise guides — implementation and recovery evidence

## Scope and model

G1 adds immutable, bundled Spanish guide values and stable literal identities under the Routine feature. Each guide has purpose, target, equipment, setup, ordered steps, common errors, and breathing. Every prescribed exercise carries an explicit ordered array of stable guide-reference IDs and display titles; neither identity nor lookup is derived from exercise names or array positions. The pure catalog validator checks unique guide/reference IDs, valid stable-ID syntax, required nonblank guide fields and ordered content, nonempty prescription references, malformed references, and dangling guide IDs.

The 30 strength prescriptions resolve through 37 references to 36 distinct guides. Seven composite prescriptions expose the alternatives already stated in their names/cues: Monday machine/dumbbell chest press and cable/machine lateral raise; Tuesday Scott/machine curl; Thursday hack/guided squat and seated/lying leg curl; Saturday dumbbell/machine incline press; Sunday machine/cable crunch. Monday's incline-machine guide is intentionally reused by Saturday's machine choice because the equipment and movement are the same. No routine prescription text, IDs, names, rest, or cues were rewritten; a read-only comparison against the prior tracked `RoutineContent.swift` confirmed all 30 rows match after excluding only the added references.

Guide prose is original and concise, semantically informed by the read-only sibling reference `../edwin-training-app/src/data/exercises.ts`; reference wording and images are not copied. No personal data, clinical claims, network, persistence, schema, migration, session behavior, or new package is introduced. Immutable bundled content needs no schema/migration. New Swift files are explicit members of the existing app/test targets.

## G1 implementation evidence — 2026-10-03

Toolchain freshness check: Xcode 27.0 (27A266a), Swift 6.4 (`swift-driver 1.168.6`), iOS/iOS Simulator SDK 27.0. The focused simulator was an available iPhone 17e; command examples keep its identifier private as `${SIMULATOR_ID}`.

- **RED:** justified exception. Before G1 there was no guide model, reference field, or callable guide-validation behavior in the app. A test written against that absent API could only fail to compile, which is not a behavioral RED. No compile failure or deliberately broken helper is claimed as RED.
- **GREEN:** `xcodebuild -project TrainingApp.xcodeproj -scheme TrainingApp -destination "platform=iOS Simulator,id=${SIMULATOR_ID}" -parallel-testing-enabled NO -maximum-concurrent-test-simulator-destinations 1 -derivedDataPath build/GuideDerivedData -resultBundlePath build/GuideDomainGREEN5.xcresult CODE_SIGNING_ALLOWED=NO -only-testing:TrainingAppTests test` — passed, finalized result bundle: 15 tests passed, 0 failures, 0 skipped, 0 result-bundle runtime warnings (8 existing routine tests plus 7 guide tests). Build emitted the non-blocking Xcode notice `Metadata extraction skipped, no AppIntents.framework dependency found`; it is not a test failure. Simulator console also printed `[API] cannot add handler to 0 from 0 - dropping` and `non-launching port is incompatible with service identifier "com.apple.PointerUI.pointeruid.default-service"`; no corresponding test failures or result-bundle runtime warnings.
- An initial invocation using an inline environment assignment expanded `${SIMULATOR_ID}` before assignment; `xcodebuild` reported “missing value for key 'id' of option 'Destination'” and ran no tests. The corrected exported variable was used for GREEN; the setup error is not RED evidence.
- `git diff --check` passed. A bounded read-only baseline check verified all 30 routine prescription lines remain identical apart from the appended guide-reference arrays.

## G2 implementation and focused UI evidence — 2026-10-03

G2 adds direct navigation for single-guide prescriptions, a native ordered chooser for composite prescriptions, scrollable native guide sections, localized English/Spanish generic labels and an unavailable-guide fallback. Routine text, identifiers, prescriptions and recovery rows remain unchanged. Three focused UI tests cover the direct guide path, variant selection/back navigation, and Spanish labels/content. The guide view is explicitly added to the app target.

- **RED:** `xcodebuild -project TrainingApp.xcodeproj -scheme TrainingApp -destination "platform=iOS Simulator,id=${SIMULATOR_ID}" -parallel-testing-enabled NO -maximum-concurrent-test-simulator-destinations 1 -derivedDataPath build/GuideDerivedData -resultBundlePath build/GuideUIRED.xcresult CODE_SIGNING_ALLOWED=NO -only-testing:TrainingAppUITests/NavigationSmokeTests/testPrescriptionOpensItsExerciseGuide test` — finalized result: 1 test, 0 passed, 1 failed. `testPrescriptionOpensItsExerciseGuide()` failed at line 49 because tapping the Tuesday prescription did not open the expected `exercise-guide.tuesday-lat-pulldown` destination. This is the observed behavior-level RED; no artificial RED rerun was performed.
- **GREEN2 partial/recovery:** the independent retry at `build/GuideUIGREEN2.xcresult` finalized 3 tests: 2 passed, 1 failed. Composite-choice/back navigation and Spanish guide labels passed. Direct navigation also succeeded, but its English-locale launch asserted Spanish section labels at lines 51–55. The failure was in the test's expected localization, not the guide destination.
- **Correction:** direct-guide assertions now use English labels (`Purpose`, `Equipment`, `Steps`, `Common errors`, `Breathing`) and bounded scrolling to make lower List sections visible before asserting them. Assertions remain intact.
- **GREEN3:** `xcodebuild -project TrainingApp.xcodeproj -scheme TrainingApp -destination "platform=iOS Simulator,id=${SIMULATOR_ID}" -parallel-testing-enabled NO -maximum-concurrent-test-simulator-destinations 1 -derivedDataPath build/GuideDerivedData -resultBundlePath build/GuideUIGREEN3.xcresult CODE_SIGNING_ALLOWED=NO -only-testing:TrainingAppUITests/NavigationSmokeTests/testPrescriptionOpensItsExerciseGuide -only-testing:TrainingAppUITests/NavigationSmokeTests/testCompositePrescriptionOffersNamedVariantsAndReturnsSafely -only-testing:TrainingAppUITests/NavigationSmokeTests/testSpanishExerciseGuideLabelsAndBackNavigation test` — finalized xcresult on an iPhone 17e / iOS 27.0: 3 passed, 0 failed, 0 skipped, no runtime warnings. `xcresulttool get test-results tests` confirms each selected test passed.
- The earlier GREEN attempt at `build/GuideUIGREEN.xcresult` had a simulator runner startup failure and diagnostic timeout; the subsequent independent retry recovered execution. Separate non-blocking diagnostics: AppIntents metadata extraction was skipped because no `AppIntents.framework` dependency exists; the G1 record separately notes simulator API/PointerUI console diagnostics.

## G3 bounded recovery and remaining review — 2026-10-03

Recovery is finalized; it is not a single combined full-suite result. The finalized immutable summaries report:

| Invocation | Result | Composition | Failures | Skipped | Runtime warnings |
|---|---|---|---:|---:|---:|
| Domain (`build/GuideRecoveryDomain.xcresult`) | 15 passed | 8 routine + 7 guide | 0 | 0 | 0 |
| UI (`build/GuideRecoveryUI.xcresult`) | 7 passed | 4 prior + 3 guide | 0 | 0 | 0 |

A separate standalone simulator build reported `BUILD SUCCEEDED`. These separate results do not establish that a combined full-suite invocation passed. The earlier combined attempt timed out after 1200 seconds without `Info.plist`; its partial result remains preserved, and no success or test count is inferred from it.

The history above remains intact: the guide-domain RED was narrowly inapplicable because no behavior existed before implementation; the G2 missing-destination assertion was a meaningful observed UI RED. The first UI GREEN attempt had a runner startup failure; the later wrong-locale assertion was corrected to match English labels and bounded scrolling. Initial shell/environment setup errors and nonblocking runner/diagnostic incidents are retained as historical attempts, not recast as product failures. The independent simulator restart was authorized as recovery, but the incident's cause was not established.

### Review and delivery status

- **G1 — approved and acknowledged:** `review-2f81f531be923a47`, base `12c336c5943dbecbcc54fdbd9fd8d9a848a6da10` → `86161a225e3dcf9b903e7a163806954e21197434`. The native acknowledgement completed; authority is burned, consumed revision `249e09eae038282768e3d30a30e306c7f5b3c18d16a16a5d0c5fc30410303c56`. The two earlier host-consent windows expired without invocation or lineage; that is historical, not a current failure. Existing independent verification remains separate from the native review.
- **G2 — approved and acknowledged:** `review-655d41a2675a9549`, base `86161a225e3dcf9b903e7a163806954e21197434` → `d8db1012045143ad1962f9589c791de0578d5056`. The native acknowledgement completed; authority is burned, consumed revision `bff1edeaea08b575515380f2d31ecc09f0e68d206db38cffff13ee50802a0bf2`.
- **G2 advisory:** R3-001, reliability WARNING, informational and expressly nonblocking, at `ExerciseGuideView.swift:79-81`. No correction is required; any follow-up is separate. No rationale is inferred from the location, and this advisory does not reopen review.
- **G3 and delivery:** The owner-selected feature-branch chain is a future plan only; no branches were created. G3 records the documentation-only closeout. Approval is not delivery authorization: no push, PR, merge, or release is authorized.
- Runtime injected-fallback behavior, physical signing/install, VoiceOver, actual Dynamic Type, contrast, Reduce Motion/Transparency, native materials, and airplane-mode checks remain pending. Simulator results are not physical-device evidence.

## Current delivery status — 2026-10-04

The guide delivery chain (PR2–PR5) is merged; current main is `691b915`. The historical G1/G2 acknowledgements remain burned and cannot authorize or be replayed for new work. The owner has separately authorized incremental implementation of the first useful offline release; it is not implemented yet. iOS 27.0 is approved. Physical-device checks listed above remain pending. This status supersedes the historical delivery-planning statements above without changing the recorded test, review, or recovery evidence.
