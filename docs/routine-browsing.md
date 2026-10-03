# Offline routine browsing — B1/B2

## Current bounded feature

B1 supplies the immutable bundled catalog and validation. B2 adds native offline week → day → prescription browsing. Seven stable days appear in source order: Monday through Sunday; five are strength days, Wednesday is recovery, and Friday is rest. The catalog carries 30 ordered strength entries and six recovery rows. Day rows link to details; there are no exercise-guide links, session/start/save actions, logging, persistence, history records, timers, or backup behavior. Full guide prose remains future work.

The source-exact Spanish routine title, weekday, subtitle, note, exercise name, prescription, rest, cue, and recovery fields are displayed as literal content. Generic UI labels have English and Spanish localizations; source content is not translated, parsed, or treated as instructions for logging. A malformed bundled catalog displays a localized unavailable message rather than trapping. The catalog remains independent of SwiftUI/SwiftData and bundled content version `1.0.0` is not a storage-schema version.

## Provenance and boundaries

Source projection was checked 2026-10-02 against `const routines` in the read-only sibling reference `../edwin-training-app/src/pages/index.astro`. Its 30 strength tuples and six recovery tuples matched the Swift fixtures exactly and in order. The seven source titles are `Push`, `Pull`, `Recuperación`, `Pierna A`, `Descanso completo`, `Upper completo`, and `Lower B + Core`. Explicit stable day/exercise IDs are literal values, never derived from displayed names or array positions. No sibling writes, guide prose/assets, markup, nutrition/progress content, personal measurements, or clinical claims are included. Source content has not been translated or medically reviewed.

The catalog stores immutable values. Prescriptions and rest remain opaque strings; no reps, duration, or RIR values are parsed. Strength rows and recovery/rest rows are separate catalog data. No SwiftData schema or migration was added because this unit adds only static bundled content and presentation.

## UI and test contract

`RoutineView` directly renders the seven catalog days in a native `List` and links to `RoutineDayView`. The detail displays day name/title/subtitle/note and either the ordered strength prescription fields or the source recovery rows. Stable accessibility anchors are `routine.day.<id>`, `routine.day-detail.<id>`, `routine.entry`, and `foundation.entry`. There are no guide affordances or implied workout actions.

`TrainingAppTests` uses Swift Testing for eight catalog contracts. The hosted XCTest UI target retains launch and navigation/tab/back smoke coverage and adds week/detail plus Spanish recovery/rest/plank journeys: four UI tests total. UI checks pin English or Spanish explicitly and use finite `waitForExistence` calls, without sleeps. The final simulator run passed eight domain and four UI tests; this does not constitute physical-device accessibility or airplane-mode evidence.

## Observed RED/GREEN attempts

Before running the redacted command templates below, choose a simulator UUID from `xcrun simctl list devices available` and set `SIMULATOR_ID` to that selected device's UUID. These templates use `${SIMULATOR_ID}` instead of the originally observed simulator identity; the logged result counts, failures, and pass outcomes below remain the observed evidence and are unchanged.

B1's initial setup attempts were not behavior RED:

- `RoutineCatalogRED.xcresult` exited 74 because an omitted PBX semicolon made the project unreadable.
- `RoutineCatalogRED2.xcresult` exited 65 at compile: the app module lacked testability for `@testable import`.
- `RoutineCatalogRED3.xcresult` exited 65 at compile: a synthetic test helper used an invalid default argument referencing another parameter.
- After those fixes, `RoutineCatalogRED4.log` recorded six assertion failures against the empty catalog stub. That is the observed B1 RED. The exact focused invocation template uses the project/scheme above, destination `platform=iOS Simulator,id=${SIMULATOR_ID}`, `-parallel-testing-enabled NO -maximum-concurrent-test-simulator-destinations 1 -derivedDataPath build/RoutineDerivedData -resultBundlePath build/RoutineCatalogRED4.xcresult -only-testing:TrainingAppTests CODE_SIGNING_ALLOWED=NO test`. B1 GREEN used the same command with result path `build/RoutineCatalogGREEN3.xcresult` and passed eight Swift Testing tests (`RoutineCatalogGREEN` and two numbered follow-up runs also passed as content/fixture assertions were completed).

For the approved missing-title correction, the focused assertion ran against a compileable temporary empty title. `RoutineTitleRED.log` lines 322–347 record the named assertion failing: seven empty titles versus seven source literals; the suite completed nine tests with one issue in 0.026 seconds. Its exact invocation used the same focused domain command above with result path `build/RoutineTitleRED.xcresult`. The outer Python wrapper timed out at 600 seconds during finalization and the result bundle lacks final Info.plist metadata. R2 independently confirmed the assertion RED was completed. It was not rerun, and no process/environment intervention was performed. `RoutineTitleGREEN.xcresult` used that command with the GREEN result path and passed all nine tests. The title assertion was then consolidated into the existing catalog contract to retain eight domain tests.

The first focused UI RED was an actual assertion, not a compile failure: `RoutineBrowsingRED.log` records `testWeeklyRoutineAndDayDetails` finding zero of seven expected day links against the placeholder (one test, one failure, 10.132 seconds). Its exact command was `xcodebuild -project TrainingApp.xcodeproj -scheme TrainingApp -destination "platform=iOS Simulator,id=${SIMULATOR_ID}" -parallel-testing-enabled NO -maximum-concurrent-test-simulator-destinations 1 -derivedDataPath build/RoutineDerivedData -resultBundlePath build/RoutineBrowsingRED.xcresult -only-testing:TrainingAppUITests/NavigationSmokeTests/testWeeklyRoutineAndDayDetails CODE_SIGNING_ALLOWED=NO test`.

Final full GREEN after test consolidation:

```sh
xcodebuild -project TrainingApp.xcodeproj -scheme TrainingApp \
  -destination "platform=iOS Simulator,id=${SIMULATOR_ID}" \
  -parallel-testing-enabled NO \
  -maximum-concurrent-test-simulator-destinations 1 \
  -derivedDataPath build/RoutineDerivedData \
  -resultBundlePath build/RoutineBrowsingGREEN2.xcresult \
  CODE_SIGNING_ALLOWED=NO test
```

Observed result: exit 0; eight Swift Testing domain tests and four XCTest UI tests passed (`build/RoutineBrowsingGREEN2.log`). The earlier full run `RoutineBrowsingGREEN.xcresult` also passed before consolidating the title test (nine domain plus four UI tests).

Simulator build:

```sh
xcodebuild -project TrainingApp.xcodeproj -scheme TrainingApp \
  -destination "platform=iOS Simulator,id=${SIMULATOR_ID}" \
  -derivedDataPath build/RoutineDerivedData CODE_SIGNING_ALLOWED=NO build
```

Observed result: exit 0 (`build/RoutineBrowsingBUILD.log`). `plutil -lint TrainingApp.xcodeproj/project.pbxproj` and `git diff --check` passed. `plutil` does not accept the JSON `.xcstrings` input (`Unexpected character {`); Python `json.loads` parsed the string catalog successfully.

## Remaining checks

The Spanish UI journey observed localized generic labels plus literal source Spanish fixtures in the simulator; it is not full localization certification. No airplane-mode/manual offline test, physical-device VoiceOver/Dynamic Type/contrast/reduced-motion/transparency review, native material review, guide-content review, or workout behavior exists in B1/B2. Keep those checks separate and pending later authorized units.
