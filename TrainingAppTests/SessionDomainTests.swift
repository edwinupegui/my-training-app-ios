import Foundation
import Testing
@testable import TrainingApp

struct SessionDomainTests {
    @Test func setRecordRejectsNonpositiveRepetitionsAndInvalidRIR() throws {
        #expect(throws: SessionDomainError.invalidRepetitions) {
            try SessionSetRecord(exerciseID: "monday-test", order: 1, load: .bodyweight(addedLoad: nil), repetitions: 0)
        }
        #expect(throws: SessionDomainError.invalidRepetitions) {
            try SessionSetRecord(exerciseID: "monday-test", order: 1, load: .bodyweight(addedLoad: nil), repetitions: -1)
        }
        #expect(throws: SessionDomainError.invalidRIR) {
            try SessionSetRecord(exerciseID: "monday-test", order: 1, load: .bodyweight(addedLoad: nil), repetitions: 1, rir: -1)
        }

        let absentRIR = try SessionSetRecord(exerciseID: "monday-test", order: 1, load: .bodyweight(addedLoad: nil), repetitions: 1)
        let zeroRIR = try SessionSetRecord(exerciseID: "monday-test", order: 1, load: .bodyweight(addedLoad: nil), repetitions: 1, rir: 0)
        #expect(absentRIR.rir == nil)
        #expect(zeroRIR.rir == 0)
        #expect(absentRIR != zeroRIR)
    }

    @Test func externalLoadsRequireFiniteNonnegativeValuesWithoutMagnitudeCap() throws {
        #expect(throws: SessionDomainError.invalidLoad) { try ExternalLoad(value: -0.1, unit: .kilograms) }
        #expect(throws: SessionDomainError.invalidLoad) { try ExternalLoad(value: .infinity, unit: .kilograms) }
        #expect(throws: SessionDomainError.invalidLoad) { try ExternalLoad(value: .nan, unit: .pounds) }
        let zero = try ExternalLoad(value: 0, unit: .kilograms)
        let large = try ExternalLoad(value: 1_000_000, unit: .pounds)
        #expect(zero.value == 0)
        #expect(large.value == 1_000_000)
    }

    @Test func setRecordRequiresPositiveOrderAndExerciseIdentity() throws {
        #expect(throws: SessionDomainError.invalidSetOrder) {
            try SessionSetRecord(exerciseID: "monday-test", order: 0, load: .bodyweight(addedLoad: nil), repetitions: 1)
        }
        #expect(throws: SessionDomainError.unknownExercise(" ")) {
            try SessionSetRecord(exerciseID: " ", order: 1, load: .bodyweight(addedLoad: nil), repetitions: 1)
        }
    }

    @Test func snapshotCopiesRoutineAndPrescriptionAndSessionCopiesStayIndependent() throws {
        let catalog = RoutineCatalog.bundled
        var first = try start(catalog: catalog, id: UUID())
        let second = try start(catalog: catalog, id: UUID())
        let originalPrescription = first.snapshot.exercises[0].prescription
        let set = try record(exerciseID: "monday-machine-chest-press", order: 1, weight: 25, rir: 2)

        try first.record(set)

        #expect(first.sets == [set])
        #expect(second.sets.isEmpty)
        #expect(first.snapshot.exercises[0].prescription == originalPrescription)
        #expect(catalog.days[0].exercises[0].prescription == originalPrescription)
        #expect(first.snapshot.routineVersion == catalog.contentVersion)
    }

    @Test func snapshotPreservesDayAndExerciseOrderAndOpaquePrescriptionText() throws {
        let session = try start(catalog: .bundled)
        #expect(session.snapshot.dayID == "monday")
        #expect(session.snapshot.exercises.map(\.order) == [1, 2, 3, 4, 5, 6])
        #expect(session.snapshot.exercises[0].prescription == "3 × 8–12")
        #expect(session.snapshot.exercises[0].cue == "RIR 2 · Alternativa: press con mancuernas")
        #expect(session.snapshot.exercises[0].selectedGuideID == "monday-machine-chest-press")
    }

    @Test func snapshotRequiresValidCatalogsStableReferencesAndStrengthDay() throws {
        #expect(throws: SessionDomainError.dayIsNotStrength("wednesday")) {
            try start(dayID: "wednesday")
        }
        #expect(throws: SessionDomainError.dayIsNotStrength("friday")) {
            try start(dayID: "friday")
        }
        #expect(throws: SessionDomainError.dayNotFound("holiday")) {
            try start(dayID: "holiday")
        }
        #expect(throws: SessionDomainError.missingGuideVariant("monday-machine-chest-press")) {
            try start(dayID: "monday", omitCompositeSelections: true)
        }
        #expect(throws: SessionDomainError.invalidGuideVariant(exerciseID: "monday-machine-chest-press", referenceID: "absent")) {
            try start(dayID: "monday", selected: ["monday-machine-chest-press": "absent"])
        }
        #expect(throws: SessionDomainError.unknownGuideVariantSelection("not-in-day")) {
            try start(dayID: "monday", selected: ["not-in-day": "variant"])
        }

        let invalidRoutine = RoutineCatalog(contentVersion: " ", days: RoutineCatalog.bundled.days)
        #expect(throws: SessionDomainError.invalidRoutineVersion) {
            try TrainingSession.start(routineCatalog: invalidRoutine, guideCatalog: .bundled, dayID: "monday")
        }

        let reorderedRoutine = RoutineCatalog(contentVersion: "test", days: Array(RoutineCatalog.bundled.days.reversed()))
        #expect(throws: SessionDomainError.invalidRoutineCatalog([.invalidDayOrder])) {
            try TrainingSession.start(routineCatalog: reorderedRoutine, guideCatalog: .bundled, dayID: "monday")
        }
    }

    @Test func snapshotRejectsRoutineDuplicatesAndMissingGuideReferences() throws {
        let source = RoutineCatalog.bundled
        let monday = source.days[0]
        let duplicateExercise = PrescribedExercise(
            id: monday.exercises[0].id, name: monday.exercises[1].name,
            prescription: monday.exercises[1].prescription, rest: monday.exercises[1].rest,
            cue: monday.exercises[1].cue, guideReferences: monday.exercises[1].guideReferences
        )
        var days = source.days
        days[0] = RoutineDay(
            id: monday.id, name: monday.name, title: monday.title, subtitle: monday.subtitle,
            kind: monday.kind, note: monday.note, exercises: [monday.exercises[0], duplicateExercise] + monday.exercises.dropFirst(2),
            recoveryItems: monday.recoveryItems
        )
        let duplicateCatalog = RoutineCatalog(contentVersion: source.contentVersion, days: days)
        do {
            _ = try TrainingSession.start(routineCatalog: duplicateCatalog, guideCatalog: .bundled, dayID: "monday")
            Issue.record("Duplicate source exercise IDs must reject a session snapshot")
        } catch let error as SessionDomainError {
            guard case let .invalidRoutineCatalog(issues) = error else {
                Issue.record("Expected routine validation failure, received \\(error)")
                return
            }
            #expect(issues.contains(.duplicateExerciseID))
        }

        let missingGuide = ExerciseGuideCatalog(guides: ExerciseGuideCatalog.bundled.guides.filter { $0.id != "monday-machine-chest-press" })
        do {
            _ = try TrainingSession.start(routineCatalog: .bundled, guideCatalog: missingGuide, dayID: "monday")
            Issue.record("Unresolved guide references must reject a session snapshot")
        } catch let error as SessionDomainError {
            guard case let .invalidGuideCatalog(issues) = error else {
                Issue.record("Expected guide validation failure, received \\(error)")
                return
            }
            #expect(issues.contains(.missingGuideReference))
        }
    }

    @Test func compositeGuideChoicesRequireAnExplicitStableReferenceAndSnapshotTheChoice() throws {
        #expect(throws: SessionDomainError.missingGuideVariant("monday-machine-chest-press")) {
            try start(dayID: "monday", omitCompositeSelections: true)
        }

        let machine = try start(dayID: "monday", selected: ["monday-machine-chest-press": "monday-machine-chest-press-machine"])
        let dumbbell = try start(dayID: "monday", selected: ["monday-machine-chest-press": "monday-machine-chest-press-dumbbell"])
        #expect(machine.snapshot.exercises[0].selectedGuideReferenceID == "monday-machine-chest-press-machine")
        #expect(machine.snapshot.exercises[0].selectedGuideID == "monday-machine-chest-press")
        #expect(dumbbell.snapshot.exercises[0].selectedGuideID == "monday-dumbbell-chest-press")
    }

    @Test func bodyweightAndExternalLoadAreExplicitAndUnilateralSidesStayDistinct() throws {
        let bodyweight = try SessionSetRecord(exerciseID: "monday-test", order: 1, load: .bodyweight(addedLoad: nil), repetitions: 8, side: .left)
        let weightedBodyweight = try SessionSetRecord(
            exerciseID: "monday-test", order: 1,
            load: .bodyweight(addedLoad: try ExternalLoad(value: 10, unit: .kilograms)), repetitions: 8, side: .right
        )
        let external = try record(exerciseID: "monday-test", order: 1, weight: 10)
        #expect(bodyweight.load.mode == .bodyweight)
        #expect(weightedBodyweight.load.mode == .bodyweight)
        #expect(external.load.mode == .external)
        #expect(bodyweight.side != weightedBodyweight.side)
    }

    @Test func comparabilityRequiresSameVariantModeUnitAndSideButIgnoresNamesAndOrder() throws {
        let monday = try start(dayID: "monday", selected: ["monday-machine-chest-press": "monday-machine-chest-press-machine"])
        let saturday = try start(dayID: "saturday", selected: ["saturday-dumbbell-or-machine-incline-press": "saturday-incline-press-machine"])
        let chest = try #require(monday.snapshot.exercise(id: "monday-machine-chest-press"))
        let machineIncline = try #require(saturday.snapshot.exercise(id: "saturday-dumbbell-or-machine-incline-press"))
        let leftKG = try record(exerciseID: chest.sourceExerciseID, order: 1, weight: 40, side: .left)
        let renamedAndReordered = SessionExerciseSnapshot(
            sourceExerciseID: chest.sourceExerciseID,
            displayName: "Renamed chest press",
            prescription: chest.prescription,
            rest: chest.rest,
            cue: chest.cue,
            order: 5,
            selectedGuideReferenceID: chest.selectedGuideReferenceID,
            selectedGuideID: chest.selectedGuideID
        )
        let sameExerciseSet = try record(exerciseID: chest.sourceExerciseID, order: 5, weight: 55, side: .left)
        #expect(leftKG.isComparable(to: sameExerciseSet, exercise: chest, otherExercise: renamedAndReordered))

        let mondayIncline = try #require(monday.snapshot.exercise(id: "monday-machine-incline-press"))
        let saturdayIncline = try #require(saturday.snapshot.exercise(id: "saturday-dumbbell-or-machine-incline-press"))
        #expect(mondayIncline.selectedGuideID == saturdayIncline.selectedGuideID)
        let mondayInclineSet = try record(exerciseID: mondayIncline.sourceExerciseID, order: 1, weight: 55, side: .left)
        let saturdayInclineSet = try record(exerciseID: saturdayIncline.sourceExerciseID, order: 1, weight: 55, side: .left)
        #expect(!mondayInclineSet.isComparable(to: saturdayInclineSet, exercise: mondayIncline, otherExercise: saturdayIncline))

        let dumbbell = try start(dayID: "monday", selected: ["monday-machine-chest-press": "monday-machine-chest-press-dumbbell"])
        let dumbbellExercise = try #require(dumbbell.snapshot.exercise(id: "monday-machine-chest-press"))
        #expect(!leftKG.isComparable(to: sameExerciseSet, exercise: chest, otherExercise: dumbbellExercise))

        let pounds = try SessionSetRecord(exerciseID: machineIncline.sourceExerciseID, order: 1, load: .external(try ExternalLoad(value: 55, unit: .pounds)), repetitions: 8, side: .left)
        #expect(!leftKG.isComparable(to: pounds, exercise: chest, otherExercise: machineIncline))
        let bodyweight = try SessionSetRecord(exerciseID: machineIncline.sourceExerciseID, order: 1, load: .bodyweight(addedLoad: nil), repetitions: 8, side: .left)
        #expect(!leftKG.isComparable(to: bodyweight, exercise: chest, otherExercise: machineIncline))
        let rightKG = try record(exerciseID: machineIncline.sourceExerciseID, order: 1, weight: 55, side: .right)
        #expect(!leftKG.isComparable(to: rightKG, exercise: chest, otherExercise: machineIncline))
    }

    @Test func setOrderIsSequentialPerExerciseAndDuplicateSetIDsAreRejected() throws {
        var session = try start(catalog: .bundled)
        let first = try record(exerciseID: "monday-machine-chest-press", order: 1, weight: 20)
        let outOfOrder = try record(exerciseID: "monday-machine-chest-press", order: 3, weight: 20)
        try session.record(first)
        #expect(throws: SessionDomainError.invalidSetOrder) { try session.record(outOfOrder) }
        #expect(throws: SessionDomainError.duplicateSetID) { try session.record(first) }

        let nextForAnotherExercise = try record(exerciseID: "monday-machine-incline-press", order: 1, weight: 20)
        try session.record(nextForAnotherExercise)
        #expect(session.sets.map(\.order) == [1, 1])
    }

    @Test func closedSessionsRejectSetAndRepeatedLifecycleMutations() throws {
        let instant = Date(timeIntervalSince1970: 1_800_000_000)
        var completed = try start(at: instant)
        try completed.complete(at: instant.addingTimeInterval(10))
        #expect(completed.lifecycle == .completed)
        #expect(completed.endedAt == instant.addingTimeInterval(10))
        #expect(throws: SessionDomainError.closedSession) { try completed.record(record(exerciseID: "monday-machine-chest-press", order: 1, weight: 1)) }
        #expect(throws: SessionDomainError.closedSession) { try completed.abandon(at: instant.addingTimeInterval(20)) }
        #expect(throws: SessionDomainError.closedSession) { try completed.complete(at: instant.addingTimeInterval(20)) }

        var abandoned = try start(at: instant)
        try abandoned.abandon(at: instant)
        #expect(abandoned.lifecycle == .abandoned)
        #expect(throws: SessionDomainError.closedSession) { try abandoned.record(record(exerciseID: "monday-machine-chest-press", order: 1, weight: 1)) }
    }

    @Test func lifecycleRejectsAnEndBeforeSessionStart() throws {
        let startedAt = Date(timeIntervalSince1970: 1_800_000_000)
        var session = try start(at: startedAt)
        #expect(throws: SessionDomainError.invalidLifecycleTransition) { try session.complete(at: startedAt.addingTimeInterval(-1)) }
        #expect(session.lifecycle == .active)
        #expect(session.endedAt == nil)
    }

    private func start(
        catalog: RoutineCatalog = .bundled,
        dayID: String = "monday",
        id: UUID = UUID(),
        at date: Date = Date(),
        selected: [String: String] = [:],
        omitCompositeSelections: Bool = false
    ) throws -> TrainingSession {
        var choices: [String: String] = [:]
        if !omitCompositeSelections, let day = catalog.days.first(where: { $0.id == dayID }) {
            for exercise in day.exercises where exercise.guideReferences.count > 1 {
                choices[exercise.id] = exercise.guideReferences[0].id
            }
        }
        choices.merge(selected) { _, requested in requested }
        return try TrainingSession.start(
            id: SessionID(rawValue: id), at: date, routineCatalog: catalog, guideCatalog: .bundled,
            dayID: dayID, selectedGuideReferenceIDs: choices
        )
    }

    private func record(
        exerciseID: String,
        order: Int,
        weight: Double,
        unit: SessionLoadUnit = .kilograms,
        rir: Int? = nil,
        side: SessionSide = .bilateral
    ) throws -> SessionSetRecord {
        try SessionSetRecord(
            exerciseID: exerciseID, order: order, load: .external(try ExternalLoad(value: weight, unit: unit)),
            repetitions: 8, rir: rir, side: side
        )
    }
}
