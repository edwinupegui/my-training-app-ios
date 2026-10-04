import Foundation
import SwiftData

// One adapter owns one container/context. Main-actor serialization makes check-and-save
// begin operations atomic across adapter instances in this process.
enum SessionPersistenceError: Error, Equatable {
    case activeSessionExists
    case unknownSession
    case invalidStoredSession
    case multipleActiveSessions
}

@MainActor
final class SessionPersistenceAdapter {
    private let container: ModelContainer
    private let context: ModelContext
    private let saveOperation: (ModelContext) throws -> Void
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(storeURL: URL, allowsSave: Bool = true, save: ((ModelContext) throws -> Void)? = nil) throws {
        let schema = Schema(versionedSchema: SessionSchemaV1.self)
        let configuration = ModelConfiguration(
            "TrainingSessions", schema: schema, url: storeURL, allowsSave: allowsSave, cloudKitDatabase: .none
        )
        container = try ModelContainer(for: schema, configurations: configuration)
        context = ModelContext(container)
        context.autosaveEnabled = false
        saveOperation = save ?? { try $0.save() }
        encoder.outputFormatting = [.sortedKeys]
    }

    @discardableResult
    func begin(dayID: String, selectedGuideReferenceIDs: [String: String] = [:]) throws -> TrainingSession {
        let records = try fetchAll()
        let sessions = try records.map(decode)
        let activeCount = sessions.filter { $0.lifecycle.isOpen }.count
        guard activeCount <= 1 else { throw SessionPersistenceError.multipleActiveSessions }
        guard activeCount == 0 else { throw SessionPersistenceError.activeSessionExists }
        let session = try TrainingSession.start(
            routineCatalog: .bundled, guideCatalog: .bundled, dayID: dayID,
            selectedGuideReferenceIDs: selectedGuideReferenceIDs
        )
        let dto = SessionPersistenceDTO(session: session)
        let row = try row(from: dto)
        context.insert(row)
        try commitOrRollback()
        return session
    }

    func record(_ set: SessionSetRecord, in id: SessionID) throws {
        let records = try fetchAll()
        guard let row = records.first(where: { $0.id == id.rawValue.uuidString }) else {
            throw SessionPersistenceError.unknownSession
        }
        var session = try decode(row)
        try session.record(set)
        let dto = SessionPersistenceDTO(session: session)
        try update(row, with: dto)
        try commitOrRollback()
    }

    func recoverActive() throws -> TrainingSession? {
        let sessions = try fetchAll().map(decode)
        let active = sessions.filter { $0.lifecycle.isOpen }
        guard active.count <= 1 else { throw SessionPersistenceError.multipleActiveSessions }
        return active.first
    }

    func session(id: SessionID) throws -> TrainingSession {
        guard let row = try fetchAll().first(where: { $0.id == id.rawValue.uuidString }) else {
            throw SessionPersistenceError.unknownSession
        }
        return try decode(row)
    }

    func activeSessionCount() throws -> Int {
        try fetchAll().map(decode).filter { $0.lifecycle.isOpen }.count
    }

    private func fetchAll() throws -> [PersistedSession] {
        try context.fetch(FetchDescriptor<PersistedSession>())
    }

    private func decode(_ row: PersistedSession) throws -> TrainingSession {
        do {
            let dto = try decoder.decode(SessionPersistenceDTO.self, from: row.payload)
            return try dto.validatedSession(
                rowID: row.id,
                rowVersion: row.schemaVersion,
                rowLifecycle: row.lifecycle,
                rowStartedAt: row.startedAt,
                rowEndedAt: row.endedAt
            )
        } catch let error as SessionPersistenceError {
            throw error
        } catch {
            throw SessionPersistenceError.invalidStoredSession
        }
    }

    private func row(from dto: SessionPersistenceDTO) throws -> PersistedSession {
        PersistedSession(
            id: dto.id.uuidString,
            schemaVersion: dto.version,
            lifecycle: dto.lifecycle,
            startedAt: dto.startedAt,
            endedAt: dto.endedAt,
            payload: try encoder.encode(dto)
        )
    }

    private func update(_ row: PersistedSession, with dto: SessionPersistenceDTO) throws {
        row.schemaVersion = dto.version
        row.lifecycle = dto.lifecycle
        row.startedAt = dto.startedAt
        row.endedAt = dto.endedAt
        row.payload = try encoder.encode(dto)
    }

    private func commitOrRollback() throws {
        do {
            try saveOperation(context)
        } catch {
            context.rollback()
            throw error
        }
    }
}
