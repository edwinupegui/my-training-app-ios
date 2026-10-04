import Foundation

struct SessionID: Hashable, Sendable {
    let rawValue: UUID

    init(rawValue: UUID = UUID()) {
        self.rawValue = rawValue
    }
}

enum SessionLifecycle: Equatable, Sendable {
    case active
    case completed
    case abandoned

    var isOpen: Bool { self == .active }
}

enum SessionDomainError: Error, Equatable, Sendable {
    case invalidRoutineVersion
    case invalidSourceID(String)
    case invalidRoutineCatalog([RoutineCatalogValidationIssue])
    case invalidGuideCatalog([ExerciseGuideCatalogIssue])
    case dayNotFound(String)
    case dayIsNotStrength(String)
    case unknownGuideVariantSelection(String)
    case missingGuideVariant(String)
    case invalidGuideVariant(exerciseID: String, referenceID: String)
    case invalidLoad
    case invalidRepetitions
    case invalidRIR
    case invalidSetOrder
    case unknownExercise(String)
    case duplicateSetID
    case unknownSet
    case setIdentityChange
    case invalidLifecycleTransition
    case closedSession
    case invalidRecoveredData
}

enum SessionLoadUnit: String, Equatable, Sendable {
    case kilograms
    case pounds
}

struct ExternalLoad: Equatable, Sendable {
    let value: Double
    let unit: SessionLoadUnit

    init(value: Double, unit: SessionLoadUnit) throws {
        guard value.isFinite, value >= 0 else { throw SessionDomainError.invalidLoad }
        self.value = value
        self.unit = unit
    }
}

enum SessionLoad: Equatable, Sendable {
    case external(ExternalLoad)
    case bodyweight(addedLoad: ExternalLoad?)

    var mode: Mode {
        switch self {
        case .external: .external
        case .bodyweight: .bodyweight
        }
    }

    enum Mode: Equatable, Sendable {
        case external
        case bodyweight
    }

    fileprivate var comparisonUnit: SessionLoadUnit? {
        switch self {
        case let .external(load): load.unit
        case let .bodyweight(addedLoad): addedLoad?.unit
        }
    }

    fileprivate var hasAddedBodyweightLoad: Bool {
        guard case let .bodyweight(addedLoad) = self else { return false }
        return addedLoad != nil
    }
}

enum SessionSide: Equatable, Sendable {
    case bilateral
    case left
    case right
}

struct SessionSetRecord: Equatable, Sendable {
    let id: UUID
    let exerciseID: String
    let order: Int
    let load: SessionLoad
    let repetitions: Int
    let rir: Int?
    let side: SessionSide

    init(
        id: UUID = UUID(),
        exerciseID: String,
        order: Int,
        load: SessionLoad,
        repetitions: Int,
        rir: Int? = nil,
        side: SessionSide = .bilateral
    ) throws {
        guard !exerciseID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw SessionDomainError.unknownExercise(exerciseID)
        }
        guard order > 0 else { throw SessionDomainError.invalidSetOrder }
        guard repetitions > 0 else { throw SessionDomainError.invalidRepetitions }
        if let rir, rir < 0 { throw SessionDomainError.invalidRIR }

        self.id = id
        self.exerciseID = exerciseID
        self.order = order
        self.load = load
        self.repetitions = repetitions
        self.rir = rir
        self.side = side
    }

    func isComparable(
        to other: SessionSetRecord,
        exercise: SessionExerciseSnapshot,
        otherExercise: SessionExerciseSnapshot
    ) -> Bool {
        guard exerciseID == exercise.sourceExerciseID,
              other.exerciseID == otherExercise.sourceExerciseID,
              exercise.sourceExerciseID == otherExercise.sourceExerciseID,
              exercise.selectedGuideReferenceID == otherExercise.selectedGuideReferenceID,
              exercise.selectedGuideID == otherExercise.selectedGuideID,
              load.mode == other.load.mode,
              load.comparisonUnit == other.load.comparisonUnit,
              load.hasAddedBodyweightLoad == other.load.hasAddedBodyweightLoad,
              side == other.side else { return false }
        return true
    }
}

struct SessionExerciseSnapshot: Equatable, Sendable {
    let sourceExerciseID: String
    let displayName: String
    let prescription: String
    let rest: String
    let cue: String
    let order: Int
    let selectedGuideReferenceID: String
    let selectedGuideID: String
}

struct SessionRoutineSnapshot: Equatable, Sendable {
    let routineVersion: String
    let dayID: String
    let dayName: String
    let dayTitle: String
    let daySubtitle: String
    let dayNote: String?
    let exercises: [SessionExerciseSnapshot]

    func exercise(id: String) -> SessionExerciseSnapshot? {
        exercises.first { $0.sourceExerciseID == id }
    }
}

struct TrainingSession: Equatable, Sendable {
    let id: SessionID
    let startedAt: Date
    let snapshot: SessionRoutineSnapshot
    private(set) var sets: [SessionSetRecord] = []
    private(set) var lifecycle: SessionLifecycle = .active
    private(set) var endedAt: Date?

    static func recovered(
        id: SessionID,
        startedAt: Date,
        snapshot: SessionRoutineSnapshot,
        sets: [SessionSetRecord],
        lifecycle: SessionLifecycle,
        endedAt: Date?
    ) throws -> TrainingSession {
        guard startedAt.timeIntervalSince1970.isFinite,
              !snapshot.routineVersion.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              isStableID(snapshot.dayID),
              !snapshot.exercises.isEmpty,
              snapshot.exercises.map(\.order) == Array(1...snapshot.exercises.count),
              Set(snapshot.exercises.map(\.sourceExerciseID)).count == snapshot.exercises.count,
              snapshot.exercises.allSatisfy({
                  isStableID($0.sourceExerciseID) && isStableID($0.selectedGuideReferenceID) && isStableID($0.selectedGuideID)
              }) else { throw SessionDomainError.invalidRecoveredData }

        var restored = TrainingSession(id: id, startedAt: startedAt, snapshot: snapshot)
        for set in sets {
            guard let exercise = snapshot.exercise(id: set.exerciseID),
                  set.exerciseID == exercise.sourceExerciseID else { throw SessionDomainError.invalidRecoveredData }
            try restored.record(set)
        }
        switch lifecycle {
        case .active:
            guard endedAt == nil else { throw SessionDomainError.invalidRecoveredData }
        case .completed, .abandoned:
            guard let endedAt, endedAt.timeIntervalSince1970.isFinite, endedAt >= startedAt else {
                throw SessionDomainError.invalidRecoveredData
            }
            restored.lifecycle = lifecycle
            restored.endedAt = endedAt
        }
        return restored
    }

    static func start(
        id: SessionID = SessionID(),
        at startedAt: Date = Date(),
        routineCatalog: RoutineCatalog,
        guideCatalog: ExerciseGuideCatalog,
        dayID: String,
        selectedGuideReferenceIDs: [String: String] = [:]
    ) throws -> TrainingSession {
        let snapshot = try makeSnapshot(
            routineCatalog: routineCatalog,
            guideCatalog: guideCatalog,
            dayID: dayID,
            selectedGuideReferenceIDs: selectedGuideReferenceIDs
        )
        return TrainingSession(id: id, startedAt: startedAt, snapshot: snapshot)
    }

    mutating func record(_ set: SessionSetRecord) throws {
        try requireActive()
        guard let exercise = snapshot.exercise(id: set.exerciseID) else {
            throw SessionDomainError.unknownExercise(set.exerciseID)
        }
        guard !sets.contains(where: { $0.id == set.id }) else { throw SessionDomainError.duplicateSetID }
        let nextOrder = sets.filter { $0.exerciseID == exercise.sourceExerciseID }.count + 1
        guard set.order == nextOrder else { throw SessionDomainError.invalidSetOrder }
        sets.append(set)
    }

    mutating func replace(_ replacement: SessionSetRecord) throws {
        try requireActive()
        guard let index = sets.firstIndex(where: { $0.id == replacement.id }) else {
            throw SessionDomainError.unknownSet
        }
        let existing = sets[index]
        guard replacement.exerciseID == existing.exerciseID, replacement.order == existing.order else {
            throw SessionDomainError.setIdentityChange
        }
        guard snapshot.exercise(id: replacement.exerciseID) != nil else {
            throw SessionDomainError.unknownExercise(replacement.exerciseID)
        }
        sets[index] = replacement
    }

    mutating func complete(at date: Date = Date()) throws {
        try close(as: .completed, at: date)
    }

    mutating func abandon(at date: Date = Date()) throws {
        try close(as: .abandoned, at: date)
    }

    private mutating func close(as lifecycle: SessionLifecycle, at date: Date) throws {
        try requireActive()
        guard date >= startedAt else { throw SessionDomainError.invalidLifecycleTransition }
        self.lifecycle = lifecycle
        endedAt = date
    }

    private func requireActive() throws {
        guard lifecycle.isOpen else { throw SessionDomainError.closedSession }
    }

    private static func isStableID(_ value: String) -> Bool {
        guard !value.isEmpty, value.first != "-", value.last != "-", !value.contains("--") else { return false }
        return value.unicodeScalars.allSatisfy { scalar in
            (scalar.value >= 97 && scalar.value <= 122) || (scalar.value >= 48 && scalar.value <= 57) || scalar == "-"
        }
    }

    private static func makeSnapshot(
        routineCatalog: RoutineCatalog,
        guideCatalog: ExerciseGuideCatalog,
        dayID: String,
        selectedGuideReferenceIDs: [String: String]
    ) throws -> SessionRoutineSnapshot {
        guard !routineCatalog.contentVersion.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw SessionDomainError.invalidRoutineVersion
        }
        let routineIssues = routineCatalog.validate()
        guard routineIssues.isEmpty else { throw SessionDomainError.invalidRoutineCatalog(routineIssues) }
        let guideIssues = guideCatalog.validate(routineCatalog: routineCatalog)
        guard guideIssues.isEmpty else { throw SessionDomainError.invalidGuideCatalog(guideIssues) }
        guard let day = routineCatalog.days.first(where: { $0.id == dayID }) else {
            throw SessionDomainError.dayNotFound(dayID)
        }
        guard day.kind == .strength else { throw SessionDomainError.dayIsNotStrength(dayID) }

        for sourceDay in routineCatalog.days {
            guard isStableID(sourceDay.id) else { throw SessionDomainError.invalidSourceID(sourceDay.id) }
            for exercise in sourceDay.exercises where !isStableID(exercise.id) {
                throw SessionDomainError.invalidSourceID(exercise.id)
            }
            var recoveryIDs = Set<String>()
            for item in sourceDay.recoveryItems {
                guard isStableID(item.id), recoveryIDs.insert(item.id).inserted else {
                    throw SessionDomainError.invalidSourceID(item.id)
                }
            }
        }

        let exerciseIDs = Set(day.exercises.map(\.id))
        for exerciseID in selectedGuideReferenceIDs.keys where !exerciseIDs.contains(exerciseID) {
            throw SessionDomainError.unknownGuideVariantSelection(exerciseID)
        }

        let exerciseSnapshots = try day.exercises.enumerated().map { index, exercise in
            let selectedReferenceID: String
            if let requestedID = selectedGuideReferenceIDs[exercise.id] {
                selectedReferenceID = requestedID
            } else if exercise.guideReferences.count == 1, let onlyReference = exercise.guideReferences.first {
                selectedReferenceID = onlyReference.id
            } else {
                throw SessionDomainError.missingGuideVariant(exercise.id)
            }
            guard let selectedReference = exercise.guideReferences.first(where: { $0.id == selectedReferenceID }) else {
                throw SessionDomainError.invalidGuideVariant(exerciseID: exercise.id, referenceID: selectedReferenceID)
            }
            return SessionExerciseSnapshot(
                sourceExerciseID: exercise.id,
                displayName: exercise.name,
                prescription: exercise.prescription,
                rest: exercise.rest,
                cue: exercise.cue,
                order: index + 1,
                selectedGuideReferenceID: selectedReference.id,
                selectedGuideID: selectedReference.guideID
            )
        }

        return SessionRoutineSnapshot(
            routineVersion: routineCatalog.contentVersion,
            dayID: day.id,
            dayName: day.name,
            dayTitle: day.title,
            daySubtitle: day.subtitle,
            dayNote: day.note,
            exercises: exerciseSnapshots
        )
    }
}
