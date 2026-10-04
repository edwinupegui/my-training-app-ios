import Foundation
import SwiftData

@Model
final class PersistedSession {
    @Attribute(.unique) var id: String
    var schemaVersion: Int
    var lifecycle: String
    var startedAt: Date
    var endedAt: Date?
    var payload: Data

    init(id: String, schemaVersion: Int, lifecycle: String, startedAt: Date, endedAt: Date?, payload: Data) {
        self.id = id
        self.schemaVersion = schemaVersion
        self.lifecycle = lifecycle
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.payload = payload
    }
}

enum SessionSchemaV1: VersionedSchema {
    static let versionIdentifier = Schema.Version(1, 0, 0)
    static var models: [any PersistentModel.Type] { [PersistedSession.self] }
}
