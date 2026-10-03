import Testing
@testable import TrainingApp

struct RoutineCatalogTests {
    @Test func bundledWeekHasSevenOrderedDaysAndFiveStrengthDays() {
        let catalog = RoutineCatalog.bundled

        #expect(catalog.days.map(\.id) == ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"])
        #expect(catalog.days.filter { $0.kind == .strength }.count == 5)
        #expect(catalog.days.filter { $0.kind != .strength }.count == 2)
        #expect(catalog.days.map(\.kind) == [.strength, .strength, .recovery, .strength, .rest, .strength, .strength])
    }

    @Test func bundledStrengthPrescriptionsAreCompleteAndRepresentativeSourceTextIsLiteral() {
        let exercises = RoutineCatalog.bundled.days.flatMap(\.exercises)

        #expect(exercises.count == 30)
        #expect(exercises.first?.name == "Press de pecho en máquina")
        #expect(exercises.first?.prescription == "3 × 8–12")
        #expect(exercises.first?.rest == "90–120 s")
        #expect(exercises.first?.cue == "RIR 2 · Alternativa: press con mancuernas")

        let plank = exercises.first { $0.id == "sunday-plank" }
        #expect(plank?.name == "Plancha")
        #expect(plank?.prescription == "3 × 25–45 s")
        #expect(plank?.rest == "60 s")
        #expect(plank?.cue == "Respira y mantén postura")
    }

    @Test func bundledCatalogHasExplicitVersionAndPassesValidation() {
        #expect(RoutineCatalog.bundled.contentVersion == "1.0.0")
        #expect(RoutineCatalog.bundled.days.map(\.title) == [
            "Push", "Pull", "Recuperación", "Pierna A", "Descanso completo", "Upper completo", "Lower B + Core",
        ])
        #expect(RoutineCatalog.bundled.validate().isEmpty)
    }

    @Test func duplicateDayAndExerciseIDsAreRejected() {
        let catalog = catalogWith(days: [
            day("monday", exercises: [exercise("shared")]),
            day("monday", exercises: [exercise("shared")]),
            day("wednesday", kind: .recovery, recoveryItems: [recoveryItem()]),
            day("thursday"), day("friday", kind: .rest, recoveryItems: [recoveryItem()]),
            day("saturday"), day("sunday"),
        ])

        let issues = catalog.validate()
        #expect(issues.contains(.duplicateDayID))
        #expect(issues.contains(.duplicateExerciseID))
    }

    @Test func missingOrMisorderedDaysAreRejected() {
        let missing = catalogWith(days: Array(RoutineCatalog.bundled.days.dropLast()))
        let reordered = catalogWith(days: RoutineCatalog.bundled.days.reversed())

        #expect(missing.validate().contains(.missingDays))
        #expect(reordered.validate().contains(.invalidDayOrder))
    }

    @Test func strengthEntriesRequireNamePrescriptionRestAndCue() {
        let incomplete = PrescribedExercise(id: "monday-test", name: " ", prescription: "", rest: "\n", cue: " ")
        let incompleteNameDay = RoutineDay(
            id: "monday", name: " ", title: " ", subtitle: "Source subtitle", kind: .strength, note: nil,
            exercises: [incomplete], recoveryItems: []
        )
        let catalog = catalogWith(days: [incompleteNameDay, day("tuesday", exercises: [])])

        let issues = catalog.validate()
        #expect(issues.contains(.emptyDayName))
        #expect(issues.contains(.emptyDayTitle))
        #expect(issues.contains(.emptyExerciseName))
        #expect(issues.contains(.emptyStrengthExercises))
        #expect(issues.contains(.missingStrengthPrescription))
        #expect(issues.contains(.missingStrengthRest))
        #expect(issues.contains(.missingCue))
    }

    @Test func recoveryAndRestDaysRequireSourceTextWithoutStrengthEntries() {
        let invalidRecovery = day("wednesday", kind: .recovery)
        let invalidRest = day("friday", kind: .rest, exercises: [exercise("friday-strength")])
        let catalog = catalogWith(days: [
            day("monday"), day("tuesday"), invalidRecovery, day("thursday"), invalidRest, day("saturday"), day("sunday"),
        ])

        #expect(catalog.validate().contains(.invalidRecoveryContent))

        let missingRecoveryText = RoutineDay(
            id: "wednesday", name: "Wednesday", title: "Recovery", subtitle: "Recovery", kind: .recovery, note: nil,
            exercises: [],
            recoveryItems: [RecoveryItem(id: "wednesday-walk", name: "Walk", target: "", reference: "Easy pace", cue: "Optional")]
        )
        let malformedCatalog = catalogWith(days: [
            day("monday"), day("tuesday"), missingRecoveryText, day("thursday"),
            day("friday", kind: .rest, recoveryItems: [recoveryItem()]), day("saturday"), day("sunday"),
        ])
        #expect(malformedCatalog.validate().contains(.invalidRecoveryContent))
    }

    @Test func recoveryTextFixturePreservesReferenceCopy() {
        let recovery = RoutineCatalog.bundled.days[2].recoveryItems
        #expect(recovery.map(\.name) == ["Caminata suave", "Movilidad general", "Sueño e hidratación"])
        #expect(recovery[0].target == "15–30 min")
        #expect(recovery[0].reference == "Ritmo cómodo")
        #expect(recovery[0].cue == "Opcional")
    }

    private func catalogWith(days: [RoutineDay]) -> RoutineCatalog {
        RoutineCatalog(contentVersion: "test", days: days)
    }

    private func day(
        _ id: String,
        kind: RoutineDayKind = .strength,
        exercises: [PrescribedExercise]? = nil,
        recoveryItems: [RecoveryItem] = []
    ) -> RoutineDay {
        let entries = exercises ?? (kind == .strength ? [exercise("\(id)-test")] : [])
        return RoutineDay(id: id, name: "Day", title: "Routine title", subtitle: "Source subtitle", kind: kind, note: nil, exercises: entries, recoveryItems: recoveryItems)
    }

    private func exercise(_ id: String) -> PrescribedExercise {
        PrescribedExercise(id: id, name: "Exercise", prescription: "3 × 8–12", rest: "60 s", cue: "Cue")
    }

    private func recoveryItem() -> RecoveryItem {
        RecoveryItem(id: "recovery-test", name: "Recovery", target: "Some time", reference: "Easy pace", cue: "Optional")
    }
}
