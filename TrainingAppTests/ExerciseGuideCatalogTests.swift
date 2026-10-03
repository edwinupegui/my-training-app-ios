import Testing
@testable import TrainingApp

struct ExerciseGuideCatalogTests {
    @Test func bundledGuidesResolveEveryStrengthPrescriptionAndKeepChoicesOrdered() {
        let catalog = ExerciseGuideCatalog.bundled
        let exercises = RoutineCatalog.bundled.days.flatMap(\.exercises)
        let references = exercises.flatMap(\.guideReferences)
        let guideIDs = Set(catalog.guides.map(\.id))

        #expect(exercises.count == 30)
        #expect(references.count == 37)
        #expect(catalog.guides.count == 36)
        #expect(exercises.allSatisfy { !$0.guideReferences.isEmpty })
        #expect(references.allSatisfy { guideIDs.contains($0.guideID) })
        #expect(catalog.validate(routineCatalog: .bundled).isEmpty)

        let chestPress = exercises.first { $0.id == "monday-machine-chest-press" }
        #expect(chestPress?.guideReferences.map(\.title) == ["Press en máquina", "Press con mancuernas"])
    }

    @Test func everyGuideHasAllRequiredConciseSpanishSections() {
        for guide in ExerciseGuideCatalog.bundled.guides {
            #expect(!guide.purpose.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            #expect(!guide.target.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            #expect(!guide.equipment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            #expect(!guide.setup.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            #expect(guide.steps.count >= 2)
            #expect(guide.steps.allSatisfy { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty })
            #expect(guide.commonErrors.count >= 1)
            #expect(guide.commonErrors.allSatisfy { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty })
            #expect(!guide.breathing.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }

    @Test func duplicateGuideAndReferenceIDsAreRejected() {
        let guide = sampleGuide(id: "valid-guide")
        let duplicateReference = ExerciseGuideReference(id: "same-reference", title: "Choice", guideID: guide.id)
        let exercise = prescribedExercise(references: [duplicateReference, duplicateReference])
        let routines = routineCatalog(exercises: [exercise])
        let catalog = ExerciseGuideCatalog(guides: [guide, guide])

        let issues = catalog.validate(routineCatalog: routines)
        #expect(issues.contains(.duplicateGuideID))
        #expect(issues.contains(.duplicateReferenceID))
    }

    @Test func missingAndMalformedGuideReferencesAreRejected() {
        let missing = ExerciseGuideReference(id: "missing-guide-ref", title: "Choice", guideID: "absent-guide")
        let malformed = ExerciseGuideReference(id: "Bad ID", title: " ", guideID: "")
        let routines = routineCatalog(exercises: [prescribedExercise(references: [missing, malformed])])

        let issues = ExerciseGuideCatalog(guides: [sampleGuide(id: "present-guide")]).validate(routineCatalog: routines)
        #expect(issues.contains(.missingGuideReference))
        #expect(issues.contains(.malformedReference))
    }

    @Test func everyPrescriptionRequiresAtLeastOneGuideChoice() {
        let catalog = ExerciseGuideCatalog(guides: [sampleGuide(id: "available-guide")])
        let issues = catalog.validate(routineCatalog: routineCatalog(exercises: [prescribedExercise(references: [])]))

        #expect(issues.contains(.emptyGuideReferences))
    }

    @Test func malformedGuideContentAndEmptyChoiceLabelsAreRejected() {
        let malformedGuide = ExerciseGuide(
            id: "bad-guide", purpose: " ", target: "Target", equipment: "Equipment", setup: "Setup",
            steps: [""], commonErrors: [], breathing: "Breathing"
        )
        let emptyChoice = ExerciseGuideReference(id: "bad-choice", title: " ", guideID: "bad-guide")
        let routines = routineCatalog(exercises: [prescribedExercise(references: [emptyChoice])])

        let issues = ExerciseGuideCatalog(guides: [malformedGuide]).validate(routineCatalog: routines)
        #expect(issues.contains(.malformedGuideContent))
        #expect(issues.contains(.malformedReference))
    }

    @Test func allRoutineNamedVariantsHaveDistinctOrderedGuideChoices() {
        let exercises = RoutineCatalog.bundled.days.flatMap(\.exercises)
        let expectedChoices: [(String, [String])] = [
            ("monday-machine-chest-press", ["monday-machine-chest-press", "monday-dumbbell-chest-press"]),
            ("monday-cable-or-machine-lateral-raise", ["monday-cable-lateral-raise", "monday-machine-lateral-raise"]),
            ("tuesday-scott-or-machine-curl", ["tuesday-scott-curl", "tuesday-machine-curl"]),
            ("thursday-hack-squat-guided-squat", ["thursday-hack-squat", "thursday-guided-squat"]),
            ("thursday-seated-or-lying-leg-curl", ["thursday-seated-leg-curl", "thursday-lying-leg-curl"]),
            ("saturday-dumbbell-or-machine-incline-press", ["saturday-dumbbell-incline-press", "monday-machine-incline-press"]),
            ("sunday-machine-or-cable-crunch", ["sunday-machine-crunch", "sunday-cable-crunch"]),
        ]
        let compositeExercises = exercises.filter { $0.guideReferences.count > 1 }

        #expect(compositeExercises.map(\.id) == expectedChoices.map(\.0))
        for (exerciseID, guideIDs) in expectedChoices {
            let exercise = exercises.first { $0.id == exerciseID }
            #expect(exercise?.guideReferences.map(\.guideID) == guideIDs)
        }
    }

    private func sampleGuide(id: String) -> ExerciseGuide {
        ExerciseGuide(
            id: id, purpose: "Propósito", target: "Zona", equipment: "Equipo", setup: "Preparación",
            steps: ["Paso uno", "Paso dos"], commonErrors: ["Error común"], breathing: "Exhala al esfuerzo."
        )
    }

    private func prescribedExercise(references: [ExerciseGuideReference]) -> PrescribedExercise {
        PrescribedExercise(
            id: "monday-test", name: "Exercise", prescription: "3 × 8–12", rest: "60 s", cue: "Cue",
            guideReferences: references
        )
    }

    private func routineCatalog(exercises: [PrescribedExercise]) -> RoutineCatalog {
        RoutineCatalog(contentVersion: "test", days: [
            RoutineDay(
                id: "monday", name: "Monday", title: "Push", subtitle: "Routine", kind: .strength, note: nil,
                exercises: exercises, recoveryItems: []
            ),
        ])
    }
}
