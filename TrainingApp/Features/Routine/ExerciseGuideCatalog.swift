import Foundation

struct ExerciseGuideCatalog: Sendable {
    let guides: [ExerciseGuide]

    static let bundled = ExerciseGuideCatalog(guides: ExerciseGuideContent.guides)

    func validate(routineCatalog: RoutineCatalog) -> [ExerciseGuideCatalogIssue] {
        var issues = Set<ExerciseGuideCatalogIssue>()
        let guideIDs = guides.map(\.id)
        let guideIDSet = Set(guideIDs)
        if guideIDSet.count != guideIDs.count { issues.insert(.duplicateGuideID) }

        for guide in guides {
            if !Self.isStableID(guide.id) { issues.insert(.malformedGuideID) }
            let requiredText = [guide.purpose, guide.target, guide.equipment, guide.setup, guide.breathing]
            if requiredText.contains(where: Self.isBlank) || guide.steps.count < 2 || guide.commonErrors.isEmpty ||
                guide.steps.contains(where: Self.isBlank) || guide.commonErrors.contains(where: Self.isBlank) {
                issues.insert(.malformedGuideContent)
            }
        }

        var referenceIDs = Set<String>()
        for exercise in routineCatalog.days.flatMap(\.exercises) {
            if exercise.guideReferences.isEmpty { issues.insert(.emptyGuideReferences) }
            for reference in exercise.guideReferences {
                if !Self.isStableID(reference.id) || Self.isBlank(reference.title) || !Self.isStableID(reference.guideID) {
                    issues.insert(.malformedReference)
                }
                if !referenceIDs.insert(reference.id).inserted { issues.insert(.duplicateReferenceID) }
                if !guideIDSet.contains(reference.guideID) { issues.insert(.missingGuideReference) }
            }
        }

        return ExerciseGuideCatalogIssue.allCases.filter { issues.contains($0) }
    }

    private static func isBlank(_ value: String) -> Bool {
        value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private static func isStableID(_ value: String) -> Bool {
        guard !value.isEmpty, value.first != "-", value.last != "-", !value.contains("--") else { return false }
        return value.unicodeScalars.allSatisfy { scalar in
            (scalar.value >= 97 && scalar.value <= 122) || (scalar.value >= 48 && scalar.value <= 57) || scalar == "-"
        }
    }
}

struct ExerciseGuide: Sendable {
    let id: String
    let purpose: String
    let target: String
    let equipment: String
    let setup: String
    let steps: [String]
    let commonErrors: [String]
    let breathing: String
}

struct ExerciseGuideReference: Sendable {
    let id: String
    let title: String
    let guideID: String
}

enum ExerciseGuideCatalogIssue: CaseIterable, Equatable, Sendable {
    case duplicateGuideID
    case malformedGuideID
    case malformedGuideContent
    case emptyGuideReferences
    case malformedReference
    case duplicateReferenceID
    case missingGuideReference
}
