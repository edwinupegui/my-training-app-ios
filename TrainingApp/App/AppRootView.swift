import SwiftUI

struct AppRootView: View {
    @State private var selectedTab: TrainingTab = .routine

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(value: .routine) {
                NavigationStack {
                    RoutineView()
                }
            } label: {
                Label("tab.routine", systemImage: "figure.strengthtraining.traditional")
            }

            Tab(value: .history) {
                NavigationStack {
                    HistoryView()
                }
            } label: {
                Label("tab.history", systemImage: "clock.arrow.circlepath")
            }

            Tab(value: .settings) {
                NavigationStack {
                    SettingsView()
                }
            } label: {
                Label("tab.settings", systemImage: "gearshape")
            }
        }
    }
}

private enum TrainingTab: Hashable {
    case routine
    case history
    case settings
}
