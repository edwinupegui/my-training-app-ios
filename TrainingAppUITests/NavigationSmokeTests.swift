import XCTest

@MainActor
final class NavigationSmokeTests: XCTestCase {
    func testLaunchShowsFoundationEntry() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.descendants(matching: .any)["foundation.entry"].exists)
    }

    func testNavigationDestinationsAndReturn() {
        let app = XCUIApplication()
        app.launchArguments += ["-AppleLanguages", "(en)", "-AppleLocale", "en_US"]
        app.launch()

        let tabs = app.tabBars.buttons
        let routineTab = tabs["Routine"]
        let historyTab = tabs["History"]
        let settingsTab = tabs["Settings"]

        guard routineTab.exists, historyTab.exists, settingsTab.exists else {
            XCTFail("Expected native Routine, History, and Settings tabs.")
            return
        }

        let routineEntry = app.descendants(matching: .any)["routine.entry"]
        let overviewLink = app.buttons["routine.training-overview.link"]
        let overviewEntry = app.descendants(matching: .any)["training-overview.entry"]
        let historyEntry = app.descendants(matching: .any)["history.entry"]
        let settingsEntry = app.descendants(matching: .any)["settings.entry"]

        XCTAssertTrue(routineEntry.exists)
        XCTAssertTrue(overviewLink.exists)
        overviewLink.tap()
        XCTAssertTrue(overviewEntry.exists)
        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(overviewLink.exists)

        historyTab.tap()
        XCTAssertTrue(historyEntry.exists)
        settingsTab.tap()
        XCTAssertTrue(settingsEntry.exists)
        routineTab.tap()
        XCTAssertTrue(routineEntry.exists)
        XCTAssertTrue(overviewLink.exists)
    }
}
