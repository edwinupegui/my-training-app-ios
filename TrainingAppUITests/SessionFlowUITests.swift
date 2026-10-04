import XCTest

@MainActor
final class SessionFlowUITests: XCTestCase {
    func testStrengthDayOffersStartControl() {
        let app = launchIsolatedEnglishApp()
        app.buttons["routine.day.monday"].tap()

        XCTAssertTrue(app.buttons["session.start.monday"].exists, "A strength day should offer a session start action.")
    }

    func testRequiredVariantsStartRecoverAndFinish() {
        let token = UUID().uuidString
        let app = launchIsolatedEnglishApp(token: token)
        app.buttons["routine.day.monday"].tap()
        app.buttons["session.start.monday"].tap()

        let start = app.buttons["session.start.confirm"]
        XCTAssertFalse(start.isEnabled, "Every composite exercise needs an explicit variant choice.")
        let machine = app.buttons["session.variant.monday-machine-chest-press.monday-machine-chest-press-machine"]
        let dumbbells = app.buttons["session.variant.monday-machine-chest-press.monday-machine-chest-press-dumbbell"]
        machine.tap()
        dumbbells.tap()
        app.buttons["session.variant.monday-cable-or-machine-lateral-raise.monday-lateral-raise-machine"].tap()
        XCTAssertTrue(start.isEnabled)
        start.tap()

        let continueAction = app.buttons["routine.session.continue"]
        XCTAssertTrue(continueAction.waitForExistence(timeout: 3))
        continueAction.tap()
        XCTAssertTrue(app.descendants(matching: .any)["session.active"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["Press con mancuernas"].exists)
        XCTAssertTrue(app.staticTexts["session.set-entry.unavailable.message"].exists)

        app.terminate()
        let relaunched = launchIsolatedEnglishApp(token: token)
        XCTAssertTrue(relaunched.buttons["routine.session.continue"].waitForExistence(timeout: 5))
        relaunched.buttons["routine.session.continue"].tap()
        XCTAssertTrue(relaunched.descendants(matching: .any)["session.active"].waitForExistence(timeout: 3))
        XCTAssertTrue(relaunched.staticTexts["Press con mancuernas"].exists)

        relaunched.buttons["session.finish"].tap()
        relaunched.buttons["session.finish.confirm"].tap()
        XCTAssertFalse(relaunched.buttons["routine.session.continue"].waitForExistence(timeout: 2))
    }

    func testAbandonRequiresConfirmationAndClosesSession() {
        let app = launchIsolatedEnglishApp()
        startMondaySession(in: app)
        app.buttons["routine.session.continue"].tap()
        app.buttons["session.abandon"].tap()
        XCTAssertTrue(app.alerts["session.abandon.confirmation.title"].exists)
        app.alerts.buttons["common.cancel"].tap()
        XCTAssertTrue(app.descendants(matching: .any)["session.active"].exists)

        app.buttons["session.abandon"].tap()
        app.alerts.buttons["session.abandon.confirm"].tap()
        XCTAssertFalse(app.buttons["routine.session.continue"].waitForExistence(timeout: 2))
    }

    func testWriteFailureKeepsVariantChoiceAndAllowsRetry() {
        let app = launchIsolatedEnglishApp(token: UUID().uuidString, failFirstWrite: true)
        app.buttons["routine.day.monday"].tap()
        app.buttons["session.start.monday"].tap()
        let dumbbells = app.buttons["session.variant.monday-machine-chest-press.monday-machine-chest-press-dumbbell"]
        dumbbells.tap()
        app.buttons["session.variant.monday-cable-or-machine-lateral-raise.monday-lateral-raise-cable"].tap()
        let start = app.buttons["session.start.confirm"]
        XCTAssertTrue(start.isEnabled)
        start.tap()

        XCTAssertTrue(app.staticTexts["session.error.start"].waitForExistence(timeout: 3))
        XCTAssertEqual(dumbbells.value as? String, "Selected")
        XCTAssertFalse(app.buttons["routine.session.continue"].exists)
        start.tap()
        XCTAssertTrue(app.buttons["routine.session.continue"].waitForExistence(timeout: 3))
    }

    private func startMondaySession(in app: XCUIApplication) {
        app.buttons["routine.day.monday"].tap()
        app.buttons["session.start.monday"].tap()
        app.buttons["session.variant.monday-machine-chest-press.monday-machine-chest-press-machine"].tap()
        app.buttons["session.variant.monday-cable-or-machine-lateral-raise.monday-lateral-raise-cable"].tap()
        app.buttons["session.start.confirm"].tap()
    }

    private func launchIsolatedEnglishApp(token: String = UUID().uuidString, failFirstWrite: Bool = false) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments += [
            "-AppleLanguages", "(en)", "-AppleLocale", "en_US",
            "--training-ui-test-store-token", token
        ]
        if failFirstWrite {
            app.launchArguments.append("--training-ui-test-write-failure")
        }
        app.launch()
        return app
    }
}
