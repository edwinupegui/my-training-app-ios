# iOS foundation — F1 evidence

## Authorized boundary

On 2026-10-02 the owner approved the minimal simulator-first foundation and separately authorized F2's bounded placeholder navigation. Remaining product features remain unimplemented. It targets iPhone, sets iOS 27.0 as the minimum, uses the provisional simulator-only bundle ID `org.example.trainingapp.simulator`, and configures no signing team or provisioning profile. The owned bundle identity and signing choice remain deferred until physical installation. No third-party dependency, icon, domain model, service/layer abstraction, or durable store was added.

The F1 shell began with a static localized placeholder. F2 adds native Routine, History, and Settings tabs, each with an independent `NavigationStack`, and a Routine-to-Training overview placeholder route with system back navigation. These screens only present honest planned/not-implemented copy; there is no actual routine, training/session function, history data, or settings function. Stable accessibility identifiers mark the foundation entry and destination anchors. Tab controls retain their native localized labels; the UI test pins English to query their real labels consistently. The passing suite contains the F1 launch-existence regression plus one tab/detail/return journey test. There is no durable data and thus no schema or migration requirement.

API/toolchain freshness was checked locally on 2026-10-02: Xcode 27.0 (27A266a), Apple Swift 6.4.0 (`swiftlang-6.4.0.34.1`), iOS Simulator SDK 27.0. The installed SwiftUI arm64 simulator interface confirmed `TabView` (iOS 13+), `NavigationStack` (iOS 16+), and custom-label `Tab` APIs (iOS 18+). F2 uses the modern `Tab` initializer and compiler validation is recorded below. The generated app Info.plist confirms `UIDeviceFamily = [1]`, minimum OS 27.0, generated `UILaunchScreen`, and bundle ID above.

## Reproduction and observed results

Commands ran synchronously from the repository root. Logs are under `build/`; derived data and result bundles are scoped there. Before running a command, choose a simulator UUID from `xcrun simctl list devices available` and set `SIMULATOR_ID` to that selected device's UUID. The commands below are redacted templates using `${SIMULATOR_ID}`, not verbatim captured command lines; observed log and result evidence remains unchanged. `xcodebuild -showdestinations` succeeded and showed the specified booted iPhone 17 / iOS 27.0 destination. It also enumerated generic and iPad destinations; the built app's generated Info.plist confirms iPhone-only family.

```sh
xcodebuild -project TrainingApp.xcodeproj -scheme TrainingApp -showdestinations
```

**Passed (exit 0).** Log: `build/Foundation-showdestinations.log`.

```sh
xcodebuild -project TrainingApp.xcodeproj -scheme TrainingApp -destination "platform=iOS Simulator,id=${SIMULATOR_ID}" -derivedDataPath build/DerivedData CODE_SIGNING_ALLOWED=NO build
```

**BUILD SUCCEEDED (exit 0).** Log: `build/Foundation-build.log`. Xcode emitted the informational warning that AppIntents metadata extraction was skipped because there is no AppIntents dependency; no AppIntents behavior is used.

The first requested baseline test command was run with its requested result-bundle path, but Xcode rejected the initial UI-test target configuration (`USES_XCTRUNNER` cannot coexist with `TEST_HOST`/`RUNTIME_TEST_HOST`). This failed before test execution. The UI target was corrected by removing app-host settings, and the test was rerun to a distinct result path so no prior result could be overwritten.

```sh
xcodebuild -project TrainingApp.xcodeproj -scheme TrainingApp -destination "platform=iOS Simulator,id=${SIMULATOR_ID}" -parallel-testing-enabled NO -maximum-concurrent-test-simulator-destinations 1 -derivedDataPath build/DerivedData -resultBundlePath build/FoundationBaseline.xcresult CODE_SIGNING_ALLOWED=NO test
```

**Configuration failed before tests (exit 70)** with the UI-test host-setting conflict described above. Log: `build/Foundation-test.log`. The failed invocation produced no observed app behavior result.

```sh
xcodebuild -project TrainingApp.xcodeproj -scheme TrainingApp -destination "platform=iOS Simulator,id=${SIMULATOR_ID}" -parallel-testing-enabled NO -maximum-concurrent-test-simulator-destinations 1 -derivedDataPath build/DerivedData -resultBundlePath build/FoundationBaseline-2.xcresult CODE_SIGNING_ALLOWED=NO test
```

**TEST SUCCEEDED (exit 0): 1 test, 0 failures.** `testLaunchShowsFoundationEntry` launched `org.example.trainingapp.simulator` on the iPhone 17 simulator and found `foundation.entry`. Log: `build/Foundation-test-retry.log`; result bundle: `build/FoundationBaseline-2.xcresult`. Observed simulator/IDE diagnostics included duplicate `UIAccessibilityLoaderWebShared` class definitions in the iOS 27 runtime and unavailable debugger-version lookup (`noURL`); neither prevented the successful test.

### Baseline evidence and pending checks

Setup-only project configuration has no meaningful pre-implementation behavioral RED: **RED not applicable**. Strict TDD was not explicitly activated. The baseline launch test is an existence check, not proof of navigation or any feature; the passing launch test is the baseline GREEN/validation observation. There was no test-runner launch failure in the successful run.

Physical-device install/signing, confirmation of owned bundle identity, VoiceOver, Dynamic Type, contrast, Reduce Motion/Transparency, orientation/layout, and native-material performance remain pending. A simulator pass does not certify these checks.

## F2 navigation evidence

The first F2 navigation test was added before implementation. R1 independently recovered its actual assertion RED from `build/FoundationNavigationRED.xcresult/Staging/1_Test/Diagnostics/StandardOutputAndStandardError.txt`: `testNavigationDestinationsAndReturn` ran for 11.191 seconds and failed at `NavigationSmokeTests.swift:22` because the launch-only baseline had no native tabs. The outer Python wrapper timed out after 600 seconds after test execution; scheduling completed at 18:42:57 with `cancelledNo`, the partial bundle lacked `Info.plist`, and the precise result-finalization cause is unknown. The RED command was not rerun or the environment recovered.

The implementation's first GREEN attempt compiled and ran both tests, but failed the navigation assertion because identifiers on the custom `Tab` labels were not exposed as the native tab-button identifiers. The test was corrected to pin the launch language to English and query the actual Routine/History/Settings native tab labels; content anchors remain identifier-based. This was a query/identifier mismatch, not a missing navigation feature. The corrected run passed.

```sh
xcodebuild -project TrainingApp.xcodeproj -scheme TrainingApp -destination "platform=iOS Simulator,id=${SIMULATOR_ID}" -parallel-testing-enabled NO -maximum-concurrent-test-simulator-destinations 1 -derivedDataPath build/DerivedData -resultBundlePath build/FoundationNavigationRED.xcresult -only-testing:TrainingAppUITests/NavigationSmokeTests/testNavigationDestinationsAndReturn CODE_SIGNING_ALLOWED=NO test
```

**R1-recovered assertion RED:** one failed navigation assertion, 11.191 seconds test execution; wrapper later timed out after 600 seconds during result finalization (cause unknown). The partial RED bundle is preserved. R1 reported no stale test/app/Xcode processes and the simulator remained booted.

```sh
xcodebuild -project TrainingApp.xcodeproj -scheme TrainingApp -destination "platform=iOS Simulator,id=${SIMULATOR_ID}" -parallel-testing-enabled NO -maximum-concurrent-test-simulator-destinations 1 -derivedDataPath build/DerivedData -resultBundlePath build/FoundationNavigationGREEN.xcresult CODE_SIGNING_ALLOWED=NO test
```

**Initial implementation test failed (exit 65):** F1 launch test passed, navigation test failed because the native tab buttons did not expose the custom label identifiers. Log: `build/FoundationNavigationGREEN.log`; result: `build/FoundationNavigationGREEN.xcresult`.

```sh
xcodebuild -project TrainingApp.xcodeproj -scheme TrainingApp -destination "platform=iOS Simulator,id=${SIMULATOR_ID}" -parallel-testing-enabled NO -maximum-concurrent-test-simulator-destinations 1 -derivedDataPath build/DerivedData -resultBundlePath build/FoundationNavigationGREEN-2.xcresult CODE_SIGNING_ALLOWED=NO test
```

**GREEN passed (exit 0): 2 tests, 0 failures.** The navigation test visited Routine detail, used the native back button, switched to History and Settings, and returned to Routine. This passed first after correcting tab queries (`build/FoundationNavigationGREEN-2.log`, `build/FoundationNavigationGREEN-2.xcresult`), and again on the final source after removing non-propagating identifiers from custom tab labels (`build/FoundationNavigationGREEN-3.log`, `build/FoundationNavigationGREEN-3.xcresult`). The final run's navigation journey passed in 14.935 seconds; both tests completed in 32.420 seconds.

The test runner also logged duplicate `UIAccessibilityLoaderWebShared` definitions in the iOS 27 runtime and an unavailable debugger-version lookup (`noURL`). Xcode logged AppIntents metadata extraction skipped because no AppIntents dependency is used. These diagnostics did not block either passing run.

```sh
xcodebuild -project TrainingApp.xcodeproj -scheme TrainingApp -destination "platform=iOS Simulator,id=${SIMULATOR_ID}" -derivedDataPath build/DerivedData CODE_SIGNING_ALLOWED=NO build
```

**BUILD SUCCEEDED (exit 0).** The final build after the last source edit is logged at `build/FoundationNavigation-build-2.log`; the earlier build also succeeded (`build/FoundationNavigation-build.log`). AppIntents metadata extraction was skipped because there is no AppIntents dependency. These informational diagnostics did not prevent the successful build.
