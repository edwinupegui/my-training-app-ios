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
