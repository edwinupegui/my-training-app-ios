import SwiftUI

struct ActiveSessionView: View {
    @Environment(SessionController.self) private var controller
    @Environment(\.dismiss) private var dismiss
    @State private var confirmsFinish = false
    @State private var confirmsAbandon = false

    var body: some View {
        Group {
            if let session = controller.activeSession {
                sessionSummary(session)
            } else {
                ContentUnavailableView("session.active.unavailable.title", systemImage: "figure.strengthtraining.traditional")
            }
        }
        .navigationTitle("session.active.title")
        .navigationBarTitleDisplayMode(.inline)
        .alert("session.finish.confirmation.title", isPresented: $confirmsFinish) {
            Button("session.finish.confirm", role: .destructive) {
                if controller.finishActiveSession() { dismiss() }
            }
            .accessibilityIdentifier("session.finish.confirm")
            Button("common.cancel", role: .cancel) { }
        } message: {
            Text("session.finish.confirmation.message")
        }
        .alert("session.abandon.confirmation.title", isPresented: $confirmsAbandon) {
            Button("session.abandon.confirm", role: .destructive) {
                if controller.abandonActiveSession() { dismiss() }
            }
            .accessibilityIdentifier("session.abandon.confirm")
            Button("common.cancel", role: .cancel) { }
        } message: {
            Text("session.abandon.confirmation.message")
        }
    }

    private func sessionSummary(_ session: TrainingSession) -> some View {
        List {
            Section {
                Text(session.snapshot.dayName)
                    .font(.headline)
                Text(session.snapshot.daySubtitle)
                    .foregroundStyle(.secondary)
                Text(session.startedAt, format: .dateTime.hour().minute())
                    .accessibilityLabel(Text("session.active.started-at"))
                Text("session.active.set-count \(session.sets.count)")
                    .accessibilityIdentifier("session.active.set-count")
            } header: {
                Text(session.snapshot.dayTitle)
                    .accessibilityIdentifier("session.active")
            } footer: {
                Text("session.set-entry.unavailable.message")
            }

            Section("routine.section.exercises") {
                ForEach(session.snapshot.exercises, id: \.sourceExerciseID) { exercise in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(exercise.displayName)
                            .font(.headline)
                            .accessibilityIdentifier("session.active.exercise.\(exercise.sourceExerciseID)")
                        Text(exercise.prescription)
                        Text(selectedVariantTitle(for: exercise))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .accessibilityIdentifier("session.active.variant.\(exercise.selectedGuideReferenceID)")
                        Text(exercise.cue)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }

            if let message = controller.message {
                Section {
                    Text(messageKey(for: message))
                        .foregroundStyle(.red)
                        .accessibilityIdentifier("session.error.active")
                }
            }

            Section {
                Button("session.finish", role: .destructive) { confirmsFinish = true }
                    .accessibilityIdentifier("session.finish")
                Button("session.abandon", role: .destructive) { confirmsAbandon = true }
                    .accessibilityIdentifier("session.abandon")
            }
        }
        .accessibilityIdentifier("session.active.summary")
    }

    private func selectedVariantTitle(for snapshot: SessionExerciseSnapshot) -> String {
        let exercise = RoutineCatalog.bundled.days
            .flatMap(\.exercises)
            .first { $0.id == snapshot.sourceExerciseID }
        return exercise?.guideReferences.first { $0.id == snapshot.selectedGuideReferenceID }?.title
            ?? String(localized: "session.active.variant-selected")
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
