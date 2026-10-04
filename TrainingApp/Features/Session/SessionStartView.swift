import SwiftUI

struct SessionStartView: View {
    @Environment(SessionController.self) private var controller
    @Environment(\.dismiss) private var dismiss

    let day: RoutineDay
    @State private var selectedGuideReferenceIDs: [String: String]

    init(day: RoutineDay) {
        self.day = day
        _selectedGuideReferenceIDs = State(initialValue: Dictionary(
            uniqueKeysWithValues: day.exercises.compactMap { exercise in
                guard exercise.guideReferences.count == 1, let reference = exercise.guideReferences.first else {
                    return nil
                }
                return (exercise.id, reference.id)
            }
        ))
    }

    private var hasRequiredChoices: Bool {
        day.exercises
            .filter { $0.guideReferences.count > 1 }
            .allSatisfy { selectedGuideReferenceIDs[$0.id] != nil }
    }

    var body: some View {
        Form {
            Section {
                Text(day.subtitle)
                if let note = day.note {
                    Text(note)
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text(day.name)
            }

            ForEach(day.exercises, id: \.id) { exercise in
                Section {
                    Text(exercise.prescription)
                        .font(.subheadline.weight(.semibold))
                    Text(exercise.cue)
                        .foregroundStyle(.secondary)
                    if exercise.guideReferences.count > 1 {
                        Text("session.variant.required")
                            .font(.subheadline.weight(.medium))
                        ForEach(exercise.guideReferences, id: \.id) { reference in
                            variantChoice(reference, for: exercise)
                        }
                    }
                } header: {
                    Text(exercise.name)
                } footer: {
                    Text(exercise.rest)
                }
            }

            if let message = controller.message {
                Section {
                    Text(messageKey(for: message))
                        .foregroundStyle(.red)
                        .accessibilityIdentifier("session.error.start")
                }
            }

            Section {
                Button("session.start.confirm") {
                    if controller.start(dayID: day.id, selectedGuideReferenceIDs: selectedGuideReferenceIDs) {
                        dismiss()
                    }
                }
                .disabled(!hasRequiredChoices || controller.activeSession != nil || controller.startupFailed)
                .accessibilityIdentifier("session.start.confirm")
            }
        }
        .navigationTitle("session.start.title")
        .navigationBarTitleDisplayMode(.inline)
        .accessibilityIdentifier("session.start.form")
    }

    private func variantChoice(_ reference: ExerciseGuideReference, for exercise: PrescribedExercise) -> some View {
        let isSelected = selectedGuideReferenceIDs[exercise.id] == reference.id
        return Button {
            selectedGuideReferenceIDs[exercise.id] = reference.id
        } label: {
            HStack {
                Text(reference.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .accessibilityHidden(true)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("session.variant.\(exercise.id).\(reference.id)")
        .accessibilityValue(Text(isSelected ? "session.variant.selected" : "session.variant.not-selected"))
    }

    private func messageKey(for message: SessionControllerMessage) -> LocalizedStringKey {
        switch message {
        case .storeUnavailable: "session.error.store-unavailable"
        case .storageReadFailed: "session.error.storage-read"
        case .activeSessionExists: "session.error.active-exists"
        case .startFailed: "session.error.start"
        case .finishFailed: "session.error.finish"
        case .abandonFailed: "session.error.abandon"
        }
    }
}
