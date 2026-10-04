import Foundation
import SwiftData
import Testing
@testable import TrainingApp

struct SessionPersistenceTests {
    @Test func savedSessionAndSetRecoverAfterReopeningDiskStore() async throws {
        let storeURL = try temporaryDirectory().appending(path: "sessions.store")
        let first = try await SessionPersistenceAdapter(storeURL: storeURL)
        let started = try await first.begin(dayID: "monday", selectedGuideReferenceIDs: selections(for: "monday"))
        let set = try SessionSetRecord(
            exerciseID: "monday-machine-chest-press", order: 1,
            load: .external(try ExternalLoad(value: 25, unit: .kilograms)), repetitions: 8, rir: 2
        )
        try await first.record(set, in: started.id)

        let reopened = try await SessionPersistenceAdapter(storeURL: storeURL)
        let recovered = try #require(await reopened.recoverActive())
        let saved = try await first.session(id: started.id)
        #expect(recovered == saved)
        #expect(recovered.sets == [set])
        #expect(recovered.snapshot == started.snapshot)
    }

    @Test func editReopensThenFinishAllowsNextSessionAndPreservesHistorySnapshot() async throws {
        let url = try temporaryDirectory().appending(path: "sessions.store")
        let adapter = try await SessionPersistenceAdapter(storeURL: url)
        let started = try await adapter.begin(dayID: "monday", selectedGuideReferenceIDs: selections(for: "monday"))
        let sourceSnapshot = started.snapshot
        let original = try SessionSetRecord(
            exerciseID: "monday-machine-chest-press", order: 1,
            load: .external(try ExternalLoad(value: 20, unit: .kilograms)), repetitions: 8
        )
        try await adapter.record(original, in: started.id)
        let edited = try SessionSetRecord(
            id: original.id, exerciseID: original.exerciseID, order: original.order,
            load: .external(try ExternalLoad(value: 25, unit: .kilograms)), repetitions: 10, rir: 1
        )
        try await adapter.edit(edited, in: started.id)
        let reopened = try await SessionPersistenceAdapter(storeURL: url)
        let durableEdit = try await reopened.session(id: started.id)
        #expect(durableEdit.sets == [edited])
        #expect(durableEdit.snapshot == sourceSnapshot)

        try await adapter.finish(started.id, at: started.startedAt.addingTimeInterval(60))
        await #expect(throws: SessionDomainError.closedSession) {
            try await adapter.finish(started.id, at: started.startedAt.addingTimeInterval(61))
        }
        #expect(try await reopened.session(id: started.id).sets == [edited])
        #expect(try await reopened.recoverActive() == nil)
        let next = try await reopened.begin(dayID: "tuesday", selectedGuideReferenceIDs: selections(for: "tuesday"))
        #expect(next.id != started.id)
        #expect(try await reopened.session(id: started.id).snapshot == sourceSnapshot)
        #expect(try await reopened.activeSessionCount() == 1)
    }

    @Test func abandonIsDurableAndRepeatedTerminalActionsRejectWithoutDuplicatingHistory() async throws {
        let url = try temporaryDirectory().appending(path: "sessions.store")
        let adapter = try await SessionPersistenceAdapter(storeURL: url)
        let started = try await adapter.begin(dayID: "monday", selectedGuideReferenceIDs: selections(for: "monday"))
        try await adapter.abandon(started.id, at: started.startedAt.addingTimeInterval(20))
        await #expect(throws: SessionDomainError.closedSession) {
            try await adapter.abandon(started.id, at: started.startedAt.addingTimeInterval(21))
        }
        await #expect(throws: SessionDomainError.closedSession) {
            try await adapter.finish(started.id, at: started.startedAt.addingTimeInterval(21))
        }
        let reopened = try await SessionPersistenceAdapter(storeURL: url)
        #expect(try await reopened.session(id: started.id).lifecycle == .abandoned)
        #expect(try await reopened.activeSessionCount() == 0)
        #expect(try await reopened.recoverActive() == nil)
    }

    @Test func failedEditFinishAndAbandonPreserveLastDurableActiveState() async throws {
        let url = try temporaryDirectory().appending(path: "sessions.store")
        let initial = try await SessionPersistenceAdapter(storeURL: url)
        let session = try await initial.begin(dayID: "monday", selectedGuideReferenceIDs: selections(for: "monday"))
        let original = try SessionSetRecord(
            exerciseID: "monday-machine-chest-press", order: 1,
            load: .external(try ExternalLoad(value: 20, unit: .kilograms)), repetitions: 8
        )
        try await initial.record(original, in: session.id)
        let changed = try SessionSetRecord(
            id: original.id, exerciseID: original.exerciseID, order: original.order,
            load: .external(try ExternalLoad(value: 40, unit: .pounds)), repetitions: 12
        )
        let failing = try await SessionPersistenceAdapter(storeURL: url, save: { _ in throw TestSaveError.injected })
        await #expect(throws: TestSaveError.injected) { try await failing.edit(changed, in: session.id) }
        await #expect(throws: TestSaveError.injected) { try await failing.finish(session.id, at: session.startedAt.addingTimeInterval(20)) }
        await #expect(throws: TestSaveError.injected) { try await failing.abandon(session.id, at: session.startedAt.addingTimeInterval(20)) }

        let reopened = try await SessionPersistenceAdapter(storeURL: url)
        let durable = try await reopened.session(id: session.id)
        #expect(durable.sets == [original])
        #expect(durable.lifecycle == .active)
        #expect(durable.endedAt == nil)
        #expect(try await reopened.recoverActive() == durable)
    }

    @Test func separateAdaptersObserveLatestDurableContextForEditFinishAndNextStart() async throws {
        let url = try temporaryDirectory().appending(path: "sessions.store")
        let first = try await SessionPersistenceAdapter(storeURL: url)
        let second = try await SessionPersistenceAdapter(storeURL: url)
        let session = try await first.begin(dayID: "monday", selectedGuideReferenceIDs: selections(for: "monday"))
        #expect(try await second.session(id: session.id) == session)
        #expect(try await first.session(id: session.id) == session)

        let set = try SessionSetRecord(
            exerciseID: "monday-machine-chest-press", order: 1,
            load: .external(try ExternalLoad(value: 20, unit: .kilograms)), repetitions: 8
        )
        try await first.record(set, in: session.id)
        let edit = try SessionSetRecord(
            id: set.id, exerciseID: set.exerciseID, order: set.order,
            load: .external(try ExternalLoad(value: 30, unit: .kilograms)), repetitions: 9
        )
        try await second.edit(edit, in: session.id)
        #expect(try await first.session(id: session.id).sets == [edit])
        try await second.finish(session.id, at: session.startedAt.addingTimeInterval(30))
        let next = try await first.begin(dayID: "tuesday", selectedGuideReferenceIDs: selections(for: "tuesday"))
        #expect(try await second.session(id: session.id).sets == [edit])
        #expect(try await second.session(id: session.id).lifecycle == .completed)
        #expect(try await second.recoverActive() == next)
    }

    @Test func repeatedBeginCannotCreateAnotherActiveSession() async throws {
        let adapter = try await SessionPersistenceAdapter(storeURL: try temporaryDirectory().appending(path: "sessions.store"))
        _ = try await adapter.begin(dayID: "monday", selectedGuideReferenceIDs: selections(for: "monday"))
        await #expect(throws: SessionPersistenceError.activeSessionExists) {
            try await adapter.begin(dayID: "tuesday", selectedGuideReferenceIDs: selections(for: "tuesday"))
        }
        #expect(try await adapter.activeSessionCount() == 1)
    }

    @Test func concurrentBeginAttemptsThroughSeparateAdaptersCommitOnlyOneActiveSession() async throws {
        let storeURL = try temporaryDirectory().appending(path: "sessions.store")
        let firstAdapter = try await SessionPersistenceAdapter(storeURL: storeURL)
        let secondAdapter = try await SessionPersistenceAdapter(storeURL: storeURL)
        let choices = selections(for: "monday")
        let outcomes = await withTaskGroup(of: Bool.self, returning: [Bool].self) { group in
            for adapter in [firstAdapter, secondAdapter] {
                group.addTask {
                    do {
                        _ = try await adapter.begin(dayID: "monday", selectedGuideReferenceIDs: choices)
                        return true
                    } catch SessionPersistenceError.activeSessionExists {
                        return false
                    } catch {
                        Issue.record("Unexpected begin error: \(error)")
                        return false
                    }
                }
            }
            var results: [Bool] = []
            for await result in group { results.append(result) }
            return results
        }
        #expect(outcomes.filter { $0 }.count == 1)
        let reopened = try await SessionPersistenceAdapter(storeURL: storeURL)
        #expect(try await reopened.activeSessionCount() == 1)
    }

    @Test func unknownSessionAndUnknownExerciseAreRejectedWithoutMutation() async throws {
        let adapter = try await SessionPersistenceAdapter(storeURL: try temporaryDirectory().appending(path: "sessions.store"))
        let session = try await adapter.begin(dayID: "monday", selectedGuideReferenceIDs: selections(for: "monday"))
        let invalid = try SessionSetRecord(exerciseID: "not-in-snapshot", order: 1, load: .bodyweight(addedLoad: nil), repetitions: 3)
        await #expect(throws: SessionPersistenceError.unknownSession) {
            try await adapter.record(invalid, in: SessionID(rawValue: UUID()))
        }
        await #expect(throws: SessionDomainError.unknownExercise("not-in-snapshot")) {
            try await adapter.record(invalid, in: session.id)
        }
        #expect(try await adapter.session(id: session.id).sets.isEmpty)
    }

    @Test func injectedBeginSaveFailureDoesNotBecomeDurable() async throws {
        let url = try temporaryDirectory().appending(path: "sessions.store")
        let failing = try await SessionPersistenceAdapter(storeURL: url, save: { _ in throw TestSaveError.injected })
        await #expect(throws: TestSaveError.injected) {
            try await failing.begin(dayID: "monday", selectedGuideReferenceIDs: selections(for: "monday"))
        }
        let reopened = try await SessionPersistenceAdapter(storeURL: url)
        #expect(try await reopened.recoverActive() == nil)
        #expect(try await reopened.activeSessionCount() == 0)
    }

    @Test func serializerRejectsOversizePayloadUsingTheRecoveryByteLimit() async throws {
        let session = try TrainingSession.start(
            routineCatalog: .bundled, guideCatalog: .bundled, dayID: "monday",
            selectedGuideReferenceIDs: selections(for: "monday")
        )
        let baseSnapshot = session.snapshot
        let snapshot = SessionRoutineSnapshot(
            routineVersion: baseSnapshot.routineVersion, dayID: baseSnapshot.dayID, dayName: String(repeating: "x", count: 1_100_000),
            dayTitle: baseSnapshot.dayTitle, daySubtitle: baseSnapshot.daySubtitle, dayNote: baseSnapshot.dayNote,
            exercises: baseSnapshot.exercises
        )
        let oversized = try TrainingSession.recovered(
            id: session.id, startedAt: session.startedAt, snapshot: snapshot,
            sets: [], lifecycle: .active, endedAt: nil
        )
        #expect(throws: SessionPersistenceError.invalidStoredSession) {
            try SessionPersistenceDTO(session: oversized).encodedPayload()
        }
    }

    @Test func invalidPersistedPayloadIsRejectedInsteadOfSilentlyRecovered() async throws {
        let url = try temporaryDirectory().appending(path: "sessions.store")
        let schema = Schema(versionedSchema: SessionSchemaV1.self)
        let configuration = ModelConfiguration("TrainingSessions", schema: schema, url: url, cloudKitDatabase: .none)
        let container = try ModelContainer(for: schema, configurations: configuration)
        let context = ModelContext(container)
        context.autosaveEnabled = false
        context.insert(PersistedSession(
            id: UUID().uuidString, schemaVersion: 1, lifecycle: "active",
            startedAt: Date(timeIntervalSince1970: 1_800_000_000), endedAt: nil, payload: Data("bad DTO".utf8)
        ))
        try context.save()

        let adapter = try await SessionPersistenceAdapter(storeURL: url)
        await #expect(throws: SessionPersistenceError.invalidStoredSession) {
            try await adapter.recoverActive()
        }
    }

    @Test func actualReadOnlyConfigurationRejectsSetAndPreservesDurableSession() async throws {
        let url = try temporaryDirectory().appending(path: "sessions.store")
        let initial = try await SessionPersistenceAdapter(storeURL: url)
        let session = try await initial.begin(dayID: "monday", selectedGuideReferenceIDs: selections(for: "monday"))
        let readOnly = try await SessionPersistenceAdapter(storeURL: url, allowsSave: false)
        let set = try SessionSetRecord(
            exerciseID: "monday-machine-chest-press", order: 1,
            load: .external(try ExternalLoad(value: 15, unit: .kilograms)), repetitions: 6
        )
        var saveWasRejected = false
        do {
            try await readOnly.record(set, in: session.id)
        } catch {
            saveWasRejected = true
        }
        #expect(saveWasRejected)

        let writable = try await SessionPersistenceAdapter(storeURL: url)
        let recovered = try #require(await writable.recoverActive())
        #expect(recovered.id == session.id)
        #expect(recovered.sets.isEmpty)
    }

    @Test func failedSetSavePreservesPreviouslyDurableSessionAfterReopen() async throws {
        let url = try temporaryDirectory().appending(path: "sessions.store")
        let initial = try await SessionPersistenceAdapter(storeURL: url)
        let session = try await initial.begin(dayID: "monday", selectedGuideReferenceIDs: selections(for: "monday"))
        let failing = try await SessionPersistenceAdapter(storeURL: url, save: { _ in throw TestSaveError.injected })
        let set = try SessionSetRecord(
            exerciseID: "monday-machine-chest-press", order: 1,
            load: .external(try ExternalLoad(value: 20, unit: .kilograms)), repetitions: 8
        )
        await #expect(throws: TestSaveError.injected) { try await failing.record(set, in: session.id) }
        let reopened = try await SessionPersistenceAdapter(storeURL: url)
        let recovered = try #require(await reopened.recoverActive())
        #expect(recovered.id == session.id)
        #expect(recovered.sets.isEmpty)
    }

    private func selections(for dayID: String) -> [String: String] {
        guard let day = RoutineCatalog.bundled.days.first(where: { $0.id == dayID }) else { return [:] }
        return Dictionary(uniqueKeysWithValues: day.exercises.compactMap { exercise in
            exercise.guideReferences.count > 1 ? (exercise.id, exercise.guideReferences[0].id) : nil
        })
    }

    private func temporaryDirectory() throws -> URL {
        let directory = FileManager.default.temporaryDirectory.appending(path: "SessionPersistenceTests-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        return directory
    }
}

private enum TestSaveError: Error { case injected }
