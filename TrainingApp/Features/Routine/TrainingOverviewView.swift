import SwiftUI

struct TrainingOverviewView: View {
    var body: some View {
        ScrollView {
            Text("training-overview.placeholder.message")
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
        .accessibilityIdentifier("training-overview.entry")
        .navigationTitle("training-overview.title")
        .navigationBarTitleDisplayMode(.inline)
    }
}
