import Foundation

struct RoutineCatalog: Sendable {
    let contentVersion: String
    let days: [RoutineDay]

    static let bundled = RoutineCatalog(contentVersion: "1.0.0", days: RoutineContent.days)

    func validate() -> [RoutineCatalogValidationIssue] {
        let expectedIDs = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
        var issues = Set<RoutineCatalogValidationIssue>()
        let dayIDs = days.map(\.id)

        if Set(dayIDs).count != dayIDs.count { issues.insert(.duplicateDayID) }
        if expectedIDs.contains(where: { !dayIDs.contains($0) }) { issues.insert(.missingDays) }
        if dayIDs != expectedIDs { issues.insert(.invalidDayOrder) }

        let strengthDays = days.filter { $0.kind == .strength }
        let recoveryDays = days.filter { $0.kind == .recovery }
        let restDays = days.filter { $0.kind == .rest }
        if strengthDays.count != 5 || recoveryDays.count != 1 || restDays.count != 1 {
            issues.insert(.invalidDayKindCounts)
        }

        var exerciseIDs = Set<String>()
        for day in days {
            if day.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                issues.insert(.emptyDayName)
            }
            if day.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                issues.insert(.emptyDayTitle)
            }

            if day.kind == .strength {
                if day.exercises.isEmpty { issues.insert(.emptyStrengthExercises) }
                if !day.recoveryItems.isEmpty { issues.insert(.invalidRecoveryContent) }
                for exercise in day.exercises {
                    if !exerciseIDs.insert(exercise.id).inserted { issues.insert(.duplicateExerciseID) }
                    if exercise.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        issues.insert(.emptyExerciseName)
                    }
                    if exercise.prescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        issues.insert(.missingStrengthPrescription)
                    }
                    if exercise.rest.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        issues.insert(.missingStrengthRest)
                    }
                    if exercise.cue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        issues.insert(.missingCue)
                    }
                }
            } else {
                if day.exercises.isEmpty == false || day.recoveryItems.isEmpty {
                    issues.insert(.invalidRecoveryContent)
                }
                for item in day.recoveryItems {
                    if item.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                        item.target.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                        item.reference.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                        item.cue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        issues.insert(.invalidRecoveryContent)
                    }
                }
            }
        }

        return RoutineCatalogValidationIssue.allCases.filter { issues.contains($0) }
    }
}

struct RoutineDay: Sendable {
    let id: String
    let name: String
    let title: String
    let subtitle: String
    let kind: RoutineDayKind
    let note: String?
    let exercises: [PrescribedExercise]
    let recoveryItems: [RecoveryItem]
}

enum RoutineDayKind: String, Sendable {
    case strength
    case recovery
    case rest
}

struct PrescribedExercise: Sendable {
    let id: String
    let name: String
    let prescription: String
    let rest: String
    let cue: String
    let guideReferences: [ExerciseGuideReference]

    init(
        id: String,
        name: String,
        prescription: String,
        rest: String,
        cue: String,
        guideReferences: [ExerciseGuideReference] = []
    ) {
        self.id = id
        self.name = name
        self.prescription = prescription
        self.rest = rest
        self.cue = cue
        self.guideReferences = guideReferences
    }
}

struct RecoveryItem: Sendable {
    let id: String
    let name: String
    let target: String
    let reference: String
    let cue: String
}

enum RoutineCatalogValidationIssue: CaseIterable, Equatable, Sendable {
    case duplicateDayID
    case duplicateExerciseID
    case missingDays
    case invalidDayOrder
    case invalidDayKindCounts
    case emptyDayName
    case emptyDayTitle
    case emptyExerciseName
    case emptyStrengthExercises
    case missingStrengthPrescription
    case missingStrengthRest
    case missingCue
    case invalidRecoveryContent
}
