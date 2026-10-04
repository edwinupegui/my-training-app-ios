import Foundation

struct SessionPersistenceDTO: Codable {
    // Shared read/write safety envelope for one persisted session aggregate.
    static let maximumPayloadBytes = 1_048_576
    static let maximumSetCount = 10_000
    static let maximumExerciseCount = 1_000

    let version: Int
    let id: UUID
    let startedAt: Date
    let lifecycle: String
    let endedAt: Date?
    let snapshot: Snapshot
    let sets: [Set]

    struct Snapshot: Codable {
        let routineVersion: String
        let dayID: String
        let dayName: String
        let dayTitle: String
        let daySubtitle: String
        let dayNote: String?
        let exercises: [Exercise]
    }

    struct Exercise: Codable {
        let sourceExerciseID: String
        let displayName: String
        let prescription: String
        let rest: String
        let cue: String
        let order: Int
        let selectedGuideReferenceID: String
        let selectedGuideID: String
    }

    struct Set: Codable {
        let id: UUID
        let exerciseID: String
        let order: Int
        let loadMode: String
        let loadValue: Double?
        let loadUnit: String?
        let repetitions: Int
        let rir: Int?
        let side: String
    }

    init(session: TrainingSession) {
        version = 1
        id = session.id.rawValue
        startedAt = session.startedAt
        lifecycle = Self.lifecycleName(session.lifecycle)
        endedAt = session.endedAt
        snapshot = Snapshot(
            routineVersion: session.snapshot.routineVersion,
            dayID: session.snapshot.dayID,
            dayName: session.snapshot.dayName,
            dayTitle: session.snapshot.dayTitle,
            daySubtitle: session.snapshot.daySubtitle,
            dayNote: session.snapshot.dayNote,
            exercises: session.snapshot.exercises.map {
                Exercise(
                    sourceExerciseID: $0.sourceExerciseID,
                    displayName: $0.displayName,
                    prescription: $0.prescription,
                    rest: $0.rest,
                    cue: $0.cue,
                    order: $0.order,
                    selectedGuideReferenceID: $0.selectedGuideReferenceID,
                    selectedGuideID: $0.selectedGuideID
                )
            }
        )
        sets = session.sets.map { set in
            switch set.load {
            case let .external(load):
                Set(id: set.id, exerciseID: set.exerciseID, order: set.order, loadMode: "external", loadValue: load.value, loadUnit: load.unit.rawValue, repetitions: set.repetitions, rir: set.rir, side: Self.sideName(set.side))
            case let .bodyweight(addedLoad):
                Set(id: set.id, exerciseID: set.exerciseID, order: set.order, loadMode: "bodyweight", loadValue: addedLoad?.value, loadUnit: addedLoad?.unit.rawValue, repetitions: set.repetitions, rir: set.rir, side: Self.sideName(set.side))
            }
        }
    }

    func encodedPayload() throws -> Data {
        _ = try validatedSession(
            rowID: id.uuidString, rowVersion: version, rowLifecycle: lifecycle,
            rowStartedAt: startedAt, rowEndedAt: endedAt
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        let payload = try encoder.encode(self)
        guard payload.count <= Self.maximumPayloadBytes else {
            throw SessionPersistenceError.invalidStoredSession
        }
        return payload
    }

    func validatedSession(rowID: String, rowVersion: Int, rowLifecycle: String, rowStartedAt: Date, rowEndedAt: Date?) throws -> TrainingSession {
        guard version == 1, rowVersion == version,
              rowID == id.uuidString,
              rowLifecycle == lifecycle,
              rowStartedAt == startedAt,
              rowEndedAt == endedAt,
              startedAt.timeIntervalSince1970.isFinite,
              sets.count <= Self.maximumSetCount,
              snapshot.exercises.count <= Self.maximumExerciseCount else { throw SessionPersistenceError.invalidStoredSession }

        let exercises = snapshot.exercises.map {
            SessionExerciseSnapshot(
                sourceExerciseID: $0.sourceExerciseID,
                displayName: $0.displayName,
                prescription: $0.prescription,
                rest: $0.rest,
                cue: $0.cue,
                order: $0.order,
                selectedGuideReferenceID: $0.selectedGuideReferenceID,
                selectedGuideID: $0.selectedGuideID
            )
        }
        let domainSets = try sets.map { set -> SessionSetRecord in
            let load: SessionLoad
            switch set.loadMode {
            case "external":
                guard let value = set.loadValue, let unitRaw = set.loadUnit,
                      let unit = SessionLoadUnit(rawValue: unitRaw) else {
                    throw SessionPersistenceError.invalidStoredSession
                }
                load = .external(try ExternalLoad(value: value, unit: unit))
            case "bodyweight":
                if let value = set.loadValue, let unitRaw = set.loadUnit,
                   let unit = SessionLoadUnit(rawValue: unitRaw) {
                    load = .bodyweight(addedLoad: try ExternalLoad(value: value, unit: unit))
                } else if set.loadValue == nil, set.loadUnit == nil {
                    load = .bodyweight(addedLoad: nil)
                } else {
                    throw SessionPersistenceError.invalidStoredSession
                }
            default:
                throw SessionPersistenceError.invalidStoredSession
            }
            let side: SessionSide
            switch set.side {
            case "bilateral": side = .bilateral
            case "left": side = .left
            case "right": side = .right
            default: throw SessionPersistenceError.invalidStoredSession
            }
            return try SessionSetRecord(
                id: set.id, exerciseID: set.exerciseID, order: set.order, load: load,
                repetitions: set.repetitions, rir: set.rir, side: side
            )
        }
        let lifecycle: SessionLifecycle
        switch self.lifecycle {
        case "active": lifecycle = .active
        case "completed": lifecycle = .completed
        case "abandoned": lifecycle = .abandoned
        default: throw SessionPersistenceError.invalidStoredSession
        }
        return try TrainingSession.recovered(
            id: SessionID(rawValue: id), startedAt: startedAt,
            snapshot: SessionRoutineSnapshot(
                routineVersion: snapshot.routineVersion,
                dayID: snapshot.dayID,
                dayName: snapshot.dayName,
                dayTitle: snapshot.dayTitle,
                daySubtitle: snapshot.daySubtitle,
                dayNote: snapshot.dayNote,
                exercises: exercises
            ),
            sets: domainSets, lifecycle: lifecycle, endedAt: endedAt
        )
    }

    private static func lifecycleName(_ lifecycle: SessionLifecycle) -> String {
        switch lifecycle {
        case .active: "active"
        case .completed: "completed"
        case .abandoned: "abandoned"
        }
    }

    private static func sideName(_ side: SessionSide) -> String {
        switch side {
        case .bilateral: "bilateral"
        case .left: "left"
        case .right: "right"
        }
    }
}
