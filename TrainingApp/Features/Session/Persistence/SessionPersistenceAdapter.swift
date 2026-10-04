import Foundation
import SwiftData

// Main-actor operations use a fresh context so separate adapters observe the latest durable rows.
enum SessionPersistenceError: Error, Equatable {
    case activeSessionExists
    case unknownSession
    case invalidStoredSession
    case multipleActiveSessions
}

@MainActor
final class SessionPersistenceAdapter {
    private let container: ModelContainer
    private let saveOperation: (ModelContext) throws -> Void
    private let decoder = JSONDecoder()

    init(storeURL: URL, allowsSave: Bool = true, save: ((ModelContext) throws -> Void)? = nil) throws {
        let schema = Schema(versionedSchema: SessionSchemaV1.self)
        let configuration = ModelConfiguration(
            "TrainingSessions", schema: schema, url: storeURL, allowsSave: allowsSave, cloudKitDatabase: .none
        )
        container = try ModelContainer(for: schema, configurations: configuration)
        saveOperation = save ?? { try $0.save() }
    }

    @discardableResult
    func begin(dayID: String, selectedGuideReferenceIDs: [String: String] = [:]) throws -> TrainingSession {
        let context = makeContext()
        let sessions = try fetchAll(in: context).map(decode)
        let activeCount = sessions.filter { $0.lifecycle.isOpen }.count
        guard activeCount <= 1 else { throw SessionPersistenceError.multipleActiveSessions }
        guard activeCount == 0 else { throw SessionPersistenceError.activeSessionExists }
        let session = try TrainingSession.start(
            routineCatalog: .bundled, guideCatalog: .bundled, dayID: dayID,
            selectedGuideReferenceIDs: selectedGuideReferenceIDs
        )
        let row = try row(from: SessionPersistenceDTO(session: session))
        context.insert(row)
        try commitOrRollback(context)
        return session
    }

    func record(_ set: SessionSetRecord, in id: SessionID) throws {
        try mutate(id: id) { try $0.record(set) }
    }

    func edit(_ set: SessionSetRecord, in id: SessionID) throws {
        try mutate(id: id) { try $0.replace(set) }
    }

    func finish(_ id: SessionID, at date: Date = Date()) throws {
        try mutate(id: id) { try $0.complete(at: date) }
    }

    func abandon(_ id: SessionID, at date: Date = Date()) throws {
        try mutate(id: id) { try $0.abandon(at: date) }
    }

    func recoverActive() throws -> TrainingSession? {
        let sessions = try fetchAll(in: makeContext()).map(decode)
        let active = sessions.filter { $0.lifecycle.isOpen }
        guard active.count <= 1 else { throw SessionPersistenceError.multipleActiveSessions }
        return active.first
    }

    func session(id: SessionID) throws -> TrainingSession {
        guard let row = try fetchAll(in: makeContext()).first(where: { $0.id == id.rawValue.uuidString }) else {
            throw SessionPersistenceError.unknownSession
        }
        return try decode(row)
    }

    func activeSessionCount() throws -> Int {
        try fetchAll(in: makeContext()).map(decode).filter { $0.lifecycle.isOpen }.count
    }

    private func mutate(id: SessionID, operation: (inout TrainingSession) throws -> Void) throws {
        let context = makeContext()
        guard let row = try fetchAll(in: context).first(where: { $0.id == id.rawValue.uuidString }) else {
            throw SessionPersistenceError.unknownSession
        }
        var session = try decode(row)
        try operation(&session)
        try update(row, with: SessionPersistenceDTO(session: session))
        try commitOrRollback(context)
    }

    private func makeContext() -> ModelContext {
        let context = ModelContext(container)
        context.autosaveEnabled = false
        return context
    }

    private func fetchAll(in context: ModelContext) throws -> [PersistedSession] {
        try context.fetch(FetchDescriptor<PersistedSession>())
    }

    private func decode(_ row: PersistedSession) throws -> TrainingSession {
        do {
            guard row.payload.count <= SessionPersistenceDTO.maximumPayloadBytes else {
                throw SessionPersistenceError.invalidStoredSession
            }
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
        let payload = try validatedPayload(dto)
        return PersistedSession(
            id: dto.id.uuidString,
            schemaVersion: dto.version,
            lifecycle: dto.lifecycle,
            startedAt: dto.startedAt,
            endedAt: dto.endedAt,
            payload: payload
        )
    }

    private func update(_ row: PersistedSession, with dto: SessionPersistenceDTO) throws {
        let payload = try validatedPayload(dto)
        row.schemaVersion = dto.version
        row.lifecycle = dto.lifecycle
        row.startedAt = dto.startedAt
        row.endedAt = dto.endedAt
        row.payload = payload
    }

    private func validatedPayload(_ dto: SessionPersistenceDTO) throws -> Data {
        try dto.encodedPayload()
    }

    private func commitOrRollback(_ context: ModelContext) throws {
        do {
            try saveOperation(context)
        } catch {
            context.rollback()
            throw error
        }
    }
}
