import XCTest

@MainActor
final class NavigationSmokeTests: XCTestCase {
    func testLaunchShowsFoundationEntry() {
        let app = XCUIApplication()
        app.launchArguments += ["--training-ui-test-store-token", UUID().uuidString]
        app.launch()

        XCTAssertTrue(app.descendants(matching: .any)["foundation.entry"].exists)
    }

    func testWeeklyRoutineAndDayDetails() {
        let app = XCUIApplication()
        launchInEnglish(app)

        let dayIDs = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
        let availableLinks = dayIDs.filter { app.buttons["routine.day.\($0)"].exists }
        XCTAssertEqual(availableLinks.count, 7, "Expected all seven routine day links.")

        let mondayLink = app.buttons["routine.day.monday"]
        guard mondayLink.waitForExistence(timeout: 2) else { return }
        mondayLink.tap()

        XCTAssertTrue(app.descendants(matching: .any)["routine.day-detail.monday"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Push"].exists)
        XCTAssertTrue(app.staticTexts["Pecho, hombros y tríceps"].exists)
        XCTAssertTrue(app.staticTexts["Press de pecho en máquina"].exists)
        XCTAssertTrue(app.staticTexts["3 × 8–12"].exists)
        XCTAssertTrue(app.staticTexts["90–120 s"].exists)
        XCTAssertTrue(app.staticTexts["RIR 2 · Alternativa: press con mancuernas"].exists)
    }

    func testPrescriptionOpensItsExerciseGuide() {
        let app = XCUIApplication()
        launchInEnglish(app)

        app.buttons["routine.day.tuesday"].tap()
        XCTAssertTrue(app.descendants(matching: .any)["routine.day-detail.tuesday"].waitForExistence(timeout: 2))

        let exercise = app.staticTexts["routine.exercise.tuesday-lat-pulldown.name"]
        var swipes = 0
        while !exercise.exists && swipes < 3 {
            app.swipeUp()
            swipes += 1
        }
        XCTAssertTrue(exercise.waitForExistence(timeout: 2))
        exercise.tap()

        let guide = app.descendants(matching: .any)["exercise-guide.tuesday-lat-pulldown"]
        XCTAssertTrue(guide.waitForExistence(timeout: 2))
        assertGuideSectionIsVisible("Purpose", in: app)
        assertGuideSectionIsVisible("Equipment", in: app)
        assertGuideSectionIsVisible("Steps", in: app)
        assertGuideSectionIsVisible("Common errors", in: app)
        assertGuideSectionIsVisible("Breathing", in: app)
    }

    func testCompositePrescriptionOffersNamedVariantsAndReturnsSafely() {
        let app = XCUIApplication()
        launchInEnglish(app)

        app.buttons["routine.day.monday"].tap()
        let exercise = app.staticTexts["routine.exercise.monday-machine-chest-press.name"]
        XCTAssertTrue(exercise.waitForExistence(timeout: 2))
        exercise.tap()

        let choices = app.descendants(matching: .any)["exercise-guide.choices.monday-machine-chest-press"]
        XCTAssertTrue(choices.waitForExistence(timeout: 2))
        let machineChoice = app.buttons["exercise-guide.choice.monday-machine-chest-press-machine"]
        let dumbbellChoice = app.buttons["exercise-guide.choice.monday-machine-chest-press-dumbbell"]
        XCTAssertTrue(machineChoice.exists)
        XCTAssertTrue(dumbbellChoice.exists)
        XCTAssertTrue(app.staticTexts["Press en máquina"].exists)
        XCTAssertTrue(app.staticTexts["Press con mancuernas"].exists)

        dumbbellChoice.tap()
        XCTAssertTrue(app.descendants(matching: .any)["exercise-guide.monday-dumbbell-chest-press"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Empujar horizontalmente con cargas independientes."].exists)
        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(choices.waitForExistence(timeout: 2))
        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.descendants(matching: .any)["routine.day-detail.monday"].exists)
    }

    func testSpanishExerciseGuideLabelsAndBackNavigation() {
        let app = XCUIApplication()
        app.launchArguments += ["-AppleLanguages", "(es)", "-AppleLocale", "es_ES"]
        app.launch()

        app.buttons["routine.day.tuesday"].tap()
        app.staticTexts["routine.exercise.tuesday-lat-pulldown.name"].tap()
        XCTAssertTrue(app.descendants(matching: .any)["exercise-guide.tuesday-lat-pulldown"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Propósito"].exists)
        XCTAssertTrue(app.staticTexts["Músculos trabajados"].exists)
        XCTAssertTrue(app.staticTexts["Equipo"].exists)
        XCTAssertTrue(app.staticTexts["Preparación"].exists)
        XCTAssertTrue(app.staticTexts["Pasos"].exists)
        XCTAssertTrue(app.staticTexts["Jalón al pecho"].exists)
        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.descendants(matching: .any)["routine.day-detail.tuesday"].exists)
    }

    func testNavigationDestinationsAndReturn() {
        let app = XCUIApplication()
        launchInEnglish(app)

        let tabs = app.tabBars.buttons
        let routineTab = tabs["Routine"]
        let historyTab = tabs["History"]
        let settingsTab = tabs["Settings"]
        guard routineTab.exists, historyTab.exists, settingsTab.exists else {
            XCTFail("Expected native Routine, History, and Settings tabs.")
            return
        }

        let routineEntry = app.descendants(matching: .any)["routine.entry"]
        let mondayLink = app.buttons["routine.day.monday"]
        let historyEntry = app.descendants(matching: .any)["history.entry"]
        let settingsEntry = app.descendants(matching: .any)["settings.entry"]

        XCTAssertTrue(routineEntry.exists)
        XCTAssertTrue(mondayLink.exists)
        mondayLink.tap()
        XCTAssertTrue(app.descendants(matching: .any)["routine.day-detail.monday"].waitForExistence(timeout: 2))
        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(mondayLink.waitForExistence(timeout: 2))

        historyTab.tap()
        XCTAssertTrue(historyEntry.exists)
        settingsTab.tap()
        XCTAssertTrue(settingsEntry.exists)
        routineTab.tap()
        XCTAssertTrue(routineEntry.exists)
        XCTAssertTrue(mondayLink.exists)
    }

    func testSpanishRecoveryRestAndPlankDetails() {
        let app = XCUIApplication()
        app.launchArguments += ["-AppleLanguages", "(es)", "-AppleLocale", "es_ES"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Esta semana"].waitForExistence(timeout: 2))
        app.buttons["routine.day.wednesday"].tap()
        XCTAssertTrue(app.descendants(matching: .any)["routine.day-detail.wednesday"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Recuperación"].exists)
        XCTAssertTrue(app.staticTexts["Caminata suave"].exists)
        XCTAssertTrue(app.staticTexts["15–30 min"].exists)
        XCTAssertTrue(app.staticTexts["Objetivo"].exists)
        XCTAssertTrue(app.staticTexts["Referencia"].exists)
        app.navigationBars.buttons.element(boundBy: 0).tap()

        app.buttons["routine.day.friday"].tap()
        XCTAssertTrue(app.descendants(matching: .any)["routine.day-detail.friday"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Descanso completo"].exists)
        XCTAssertTrue(app.staticTexts["Descanso de fuerza"].exists)
        XCTAssertTrue(app.staticTexts["Todo el día"].exists)
        app.navigationBars.buttons.element(boundBy: 0).tap()

        app.buttons["routine.day.sunday"].tap()
        XCTAssertTrue(app.descendants(matching: .any)["routine.day-detail.sunday"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Prescripción"].exists)
        let plankPrescription = app.staticTexts["routine.exercise.sunday-plank.prescription"]
        var swipes = 0
        while !plankPrescription.exists && swipes < 3 {
            app.swipeUp()
            swipes += 1
        }
        XCTAssertTrue(plankPrescription.waitForExistence(timeout: 2))
        XCTAssertEqual(plankPrescription.label, "3 × 25–45 s")
        XCTAssertTrue(app.staticTexts["routine.exercise.sunday-plank.cue"].exists)
        XCTAssertTrue(app.staticTexts["Respira y mantén postura"].exists)
    }

    private func assertGuideSectionIsVisible(_ label: String, in app: XCUIApplication) {
        let section = app.staticTexts[label]
        var swipes = 0
        while !section.isHittable && swipes < 6 {
            app.swipeUp()
            swipes += 1
        }
        XCTAssertTrue(section.isHittable, "Expected guide section '\(label)' to be visible after at most six scrolls.")
    }

    private func launchInEnglish(_ app: XCUIApplication) {
        app.launchArguments += [
            "-AppleLanguages", "(en)", "-AppleLocale", "en_US",
            "--training-ui-test-store-token", UUID().uuidString
        ]
        app.launch()
    }
}
