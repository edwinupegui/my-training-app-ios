import SwiftUI

struct RoutineView: View {
    private let catalog: RoutineCatalog
    private let validationIssues: [RoutineCatalogValidationIssue]

    init(catalog: RoutineCatalog = .bundled) {
        self.catalog = catalog
        validationIssues = catalog.validate()
    }

    var body: some View {
        List {
            Section {
                if validationIssues.isEmpty {
                    ForEach(catalog.days, id: \.id) { day in
                        NavigationLink {
                            RoutineDayView(day: day)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(day.name)
                                        .font(.headline)
                                    Spacer()
                                    Text(kindLabel(for: day.kind))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Text(day.title)
                                    .font(.subheadline.weight(.semibold))
                                Text(day.subtitle)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                        }
                        .accessibilityIdentifier("routine.day.\(day.id)")
                    }
                } else {
                    Text("routine.catalog.unavailable.message")
                        .accessibilityIdentifier("routine.catalog.unavailable")
                }
            } header: {
                Text("routine.week.title")
                    .accessibilityIdentifier("routine.entry")
            }
        }
        .accessibilityIdentifier("foundation.entry")
        .navigationTitle("tab.routine")
        .navigationBarTitleDisplayMode(.large)
    }

    private func kindLabel(for kind: RoutineDayKind) -> LocalizedStringKey {
        switch kind {
        case .strength: "routine.kind.strength"
        case .recovery: "routine.kind.recovery"
        case .rest: "routine.kind.rest"
        }
    }
}
