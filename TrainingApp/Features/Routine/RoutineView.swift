import SwiftUI

struct RoutineView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("routine.placeholder.title")
                    .font(.title2.weight(.semibold))
                    .accessibilityIdentifier("routine.entry")

                Text("routine.placeholder.message")
                    .foregroundStyle(.secondary)

                NavigationLink {
                    TrainingOverviewView()
                } label: {
                    Text("routine.training-overview.link")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                }
                .accessibilityIdentifier("routine.training-overview.link")
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityIdentifier("foundation.entry")
        .navigationTitle("tab.routine")
        .navigationBarTitleDisplayMode(.large)
    }
}
