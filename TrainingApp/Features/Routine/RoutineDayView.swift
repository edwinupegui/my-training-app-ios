import SwiftUI

struct RoutineDayView: View {
    @Environment(SessionController.self) private var sessionController
    @State private var showsSessionStart = false

    let day: RoutineDay
    let guideCatalog: ExerciseGuideCatalog

    init(day: RoutineDay, guideCatalog: ExerciseGuideCatalog = .bundled) {
        self.day = day
        self.guideCatalog = guideCatalog
    }

    var body: some View {
        List {
            Section {
                Text(day.name)
                    .font(.headline)
                    .accessibilityIdentifier("routine.day.name")
                Text(day.subtitle)
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier("routine.day.subtitle")
                Text(kindLabel(for: day.kind))
                    .font(.subheadline)
                    .accessibilityIdentifier("routine.day.kind")
                if let note = day.note {
                    Text(note)
                        .accessibilityIdentifier("routine.day.note")
                }
            } header: {
                Text(day.title)
                    .accessibilityIdentifier("routine.day.title")
            }

            if day.kind == .strength {
                Section("routine.section.exercises") {
                    ForEach(day.exercises, id: \.id) { exercise in
                        exerciseRow(exercise)
                    }
                }
                Section {
                    if sessionController.activeSession != nil {
                        Text("session.error.active-exists")
                            .foregroundStyle(.secondary)
                    } else {
                        Button("session.start.action") {
                            showsSessionStart = true
                        }
                        .accessibilityIdentifier("session.start.\(day.id)")
                    }
                }
            } else {
                Section(day.kind == .recovery ? "routine.section.recovery" : "routine.section.rest") {
                    ForEach(day.recoveryItems, id: \.id) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(item.name)
                                .font(.headline)
                                .accessibilityIdentifier("routine.recovery.\(item.id).name")
                            field("routine.field.target", value: item.target, id: "routine.recovery.\(item.id).target")
                            field("routine.field.reference", value: item.reference, id: "routine.recovery.\(item.id).reference")
                            field("routine.field.cue", value: item.cue, id: "routine.recovery.\(item.id).cue")
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
        }
        .accessibilityIdentifier("routine.day-detail.\(day.id)")
        .navigationTitle(day.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showsSessionStart) {
            NavigationStack {
                SessionStartView(day: day)
            }
        }
    }

    @ViewBuilder
    private func exerciseRow(_ exercise: PrescribedExercise) -> some View {
        let label = exerciseContent(exercise)
        switch exercise.guideReferences.count {
        case 1:
            NavigationLink {
                ExerciseGuideView(reference: exercise.guideReferences[0], catalog: guideCatalog)
            } label: {
                label
            }
            .accessibilityIdentifier("routine.exercise.\(exercise.id)")
        case 2...:
            NavigationLink {
                ExerciseGuideChoicesView(exercise: exercise, catalog: guideCatalog)
            } label: {
                label
            }
            .accessibilityIdentifier("routine.exercise.\(exercise.id)")
        default:
            label
            Text("exercise-guide.unavailable.message")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .accessibilityIdentifier("routine.exercise.\(exercise.id).guide-unavailable")
        }
    }

    private func exerciseContent(_ exercise: PrescribedExercise) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(exercise.name)
                .font(.headline)
                .accessibilityIdentifier("routine.exercise.\(exercise.id).name")
            field("routine.field.prescription", value: exercise.prescription, id: "routine.exercise.\(exercise.id).prescription")
            field("routine.field.rest", value: exercise.rest, id: "routine.exercise.\(exercise.id).rest")
            field("routine.field.cue", value: exercise.cue, id: "routine.exercise.\(exercise.id).cue")
        }
        .padding(.vertical, 6)
    }

    private func field(_ label: LocalizedStringKey, value: String, id: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .accessibilityIdentifier(id)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func kindLabel(for kind: RoutineDayKind) -> LocalizedStringKey {
        switch kind {
        case .strength: "routine.kind.strength"
        case .recovery: "routine.kind.recovery"
        case .rest: "routine.kind.rest"
        }
    }
}
