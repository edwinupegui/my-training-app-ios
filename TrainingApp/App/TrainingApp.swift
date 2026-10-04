import SwiftUI

@main
struct TrainingApp: App {
    @State private var sessionController: SessionController

    init() {
        _sessionController = State(initialValue: SessionController())
    }

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environment(sessionController)
        }
    }
}
