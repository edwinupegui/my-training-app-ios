import SwiftUI

struct ExerciseGuideChoicesView: View {
    let exercise: PrescribedExercise
    let catalog: ExerciseGuideCatalog

    var body: some View {
        List {
            Section {
                ForEach(exercise.guideReferences, id: \.id) { reference in
                    NavigationLink {
                        ExerciseGuideView(reference: reference, catalog: catalog)
                    } label: {
                        Text(reference.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .accessibilityIdentifier("exercise-guide.choice.\(reference.id)")
                }
            } header: {
                Text("exercise-guide.choices.section")
            }
        }
        .accessibilityIdentifier("exercise-guide.choices.\(exercise.id)")
        .navigationTitle("exercise-guide.choices.title")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ExerciseGuideView: View {
    let reference: ExerciseGuideReference
    let catalog: ExerciseGuideCatalog

    private var guide: ExerciseGuide? {
        catalog.guides.first { $0.id == reference.guideID }
    }

    var body: some View {
        List {
            if let guide {
                Section("exercise-guide.section.purpose") {
                    Text(guide.purpose)
                }

                Section("exercise-guide.section.target") {
                    Text(guide.target)
                }

                Section("exercise-guide.section.equipment") {
                    Text(guide.equipment)
                }

                Section("exercise-guide.section.preparation") {
                    Text(guide.setup)
                }

                Section("exercise-guide.section.steps") {
                    ForEach(Array(guide.steps.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .firstTextBaseline, spacing: 12) {
                            Text("\(index + 1).")
                                .foregroundStyle(.secondary)
                                .accessibilityHidden(true)
                            Text(step)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .accessibilityElement(children: .combine)
                    }
                }

                Section("exercise-guide.section.common-errors") {
                    ForEach(Array(guide.commonErrors.enumerated()), id: \.offset) { _, error in
                        Text(error)
                    }
                }

                Section("exercise-guide.section.breathing") {
                    Text(guide.breathing)
                }
            } else {
                Section {
                    Text("exercise-guide.unavailable.message")
                        .accessibilityIdentifier("exercise-guide.unavailable")
                }
            }
        }
        .accessibilityIdentifier("exercise-guide.\(reference.guideID)")
        .navigationTitle(reference.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
