import SwiftUI

struct SettingsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("settings.placeholder.title")
                    .font(.title2.weight(.semibold))
                    .accessibilityIdentifier("settings.entry")

                Text("settings.placeholder.message")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle("tab.settings")
        .navigationBarTitleDisplayMode(.large)
    }
}
