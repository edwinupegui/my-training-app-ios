import SwiftUI

struct HistoryView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("history.placeholder.title")
                    .font(.title2.weight(.semibold))
                    .accessibilityIdentifier("history.entry")

                Text("history.placeholder.message")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle("tab.history")
        .navigationBarTitleDisplayMode(.large)
    }
}
