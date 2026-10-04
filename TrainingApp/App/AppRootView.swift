import SwiftUI

struct AppRootView: View {
    @Environment(SessionController.self) private var sessionController
    @State private var selectedTab: TrainingTab = .routine

    var body: some View {
        Group {
            if sessionController.startupFailed {
                storageRecoveryView
            } else {
                tabNavigation
            }
        }
    }

    private var tabNavigation: some View {
        TabView(selection: $selectedTab) {
            Tab(value: .routine) {
                NavigationStack {
                    RoutineView()
                        .safeAreaInset(edge: .top, spacing: 0) {
                            if sessionController.activeSession != nil {
                                NavigationLink {
                                    ActiveSessionView()
                                } label: {
                                    Label("routine.session.continue", systemImage: "play.fill")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal)
                                        .padding(.vertical, 10)
                                }
                                .accessibilityIdentifier("routine.session.continue")
                            }
                        }
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

    private var storageRecoveryView: some View {
        ContentUnavailableView {
            Label("session.storage.unavailable.title", systemImage: "externaldrive.badge.exclamationmark")
        } description: {
            Text("session.storage.unavailable.message")
        } actions: {
            Button("session.storage.retry") {
                sessionController.retryStoreAccess()
            }
            .accessibilityIdentifier("session.storage.retry")
        }
        .accessibilityIdentifier("session.storage.unavailable")
    }
}

private enum TrainingTab: Hashable {
    case routine
    case history
    case settings
}
