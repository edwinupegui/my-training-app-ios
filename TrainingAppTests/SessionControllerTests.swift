import Foundation
import Testing
@testable import TrainingApp

@MainActor
struct SessionControllerTests {
    @Test func testStoreTokenSelectsOnlyItsFixedIsolatedDirectory() throws {
        let support = FileManager.default.temporaryDirectory.appending(path: "SessionControllerTests-\(UUID().uuidString)")
        let temporary = support.appending(path: "tmp", directoryHint: .isDirectory)
        let token = UUID().uuidString
        let args = ["--training-ui-test-store-token", token]
        let first = try SessionStoreConfiguration.resolve(
            arguments: args,
            applicationSupportDirectory: support,
            temporaryDirectory: temporary,
            isDebugBuild: true
        )
        let reopened = try SessionStoreConfiguration.resolve(
            arguments: args,
            applicationSupportDirectory: support,
            temporaryDirectory: temporary,
            isDebugBuild: true
        )

        #expect(first.storeURL == reopened.storeURL)
        #expect(first.storeURL == temporary.appending(path: "TrainingAppUITestStores/\(token)/TrainingSessions.store"))
        #expect(first.storeURL.path.hasPrefix(temporary.path))
    }

    @Test func malformedOrUnsupportedTestFlagsNeverSelectProductionStorage() throws {
        let support = FileManager.default.temporaryDirectory.appending(path: "SessionControllerTests-\(UUID().uuidString)")
        let temporary = support.appending(path: "tmp", directoryHint: .isDirectory)

        #expect(throws: SessionStoreConfigurationError.invalidTestArguments) {
            try SessionStoreConfiguration.resolve(
                arguments: ["--training-ui-test-write-failure"],
                applicationSupportDirectory: support,
                temporaryDirectory: temporary,
                isDebugBuild: true
            )
        }
        #expect(throws: SessionStoreConfigurationError.invalidTestArguments) {
            try SessionStoreConfiguration.resolve(
                arguments: ["--training-ui-test-store-token", "not-a-uuid"],
                applicationSupportDirectory: support,
                temporaryDirectory: temporary,
                isDebugBuild: true
            )
        }
        #expect(throws: SessionStoreConfigurationError.unsupportedTestArguments) {
            try SessionStoreConfiguration.resolve(
                arguments: ["--training-ui-test-store-token", UUID().uuidString],
                applicationSupportDirectory: support,
                temporaryDirectory: temporary,
                isDebugBuild: false
            )
        }
        #expect(!FileManager.default.fileExists(atPath: support.path))
    }

    @Test func startRecoversSnapshotAndRejectsRepeatedBegin() throws {
        let configuration = try configuration()
        let controller = SessionController(configurationProvider: { configuration })
        let choices = selectedChoices(for: "monday")

        #expect(controller.start(dayID: "monday", selectedGuideReferenceIDs: choices))
        let original = controller.activeSession
        #expect(original?.snapshot.exercises.count == RoutineCatalog.bundled.days.first { $0.id == "monday" }?.exercises.count)
        #expect(!controller.start(dayID: "tuesday", selectedGuideReferenceIDs: selectedChoices(for: "tuesday")))
        #expect(controller.message == .activeSessionExists)
        #expect(controller.activeSession == original)

        let relaunched = SessionController(configurationProvider: { configuration })
        #expect(relaunched.activeSession == original)
    }

    @Test func failedFirstWriteKeepsNoFalseActiveStateAndCanRetry() throws {
        let configuration = try configuration(failFirstWrite: true)
        let controller = SessionController(configurationProvider: { configuration })
        let choices = selectedChoices(for: "monday")

        #expect(!controller.start(dayID: "monday", selectedGuideReferenceIDs: choices))
        #expect(controller.activeSession == nil)
        #expect(controller.message == .startFailed)
        #expect(controller.start(dayID: "monday", selectedGuideReferenceIDs: choices))
        #expect(controller.activeSession?.snapshot.dayID == "monday")

        let reopened = SessionController(configurationProvider: { configuration })
        #expect(reopened.activeSession == controller.activeSession)
    }

    @Test func finishAndAbandonClearActiveOnlyAfterDurableTransition() throws {
        let finishConfiguration = try configuration()
        let finishing = SessionController(configurationProvider: { finishConfiguration })
        #expect(finishing.start(dayID: "monday", selectedGuideReferenceIDs: selectedChoices(for: "monday")))
        #expect(finishing.finishActiveSession())
        #expect(finishing.activeSession == nil)
        #expect(SessionController(configurationProvider: { finishConfiguration }).activeSession == nil)

        let abandonConfiguration = try configuration()
        let abandoning = SessionController(configurationProvider: { abandonConfiguration })
        #expect(abandoning.start(dayID: "tuesday", selectedGuideReferenceIDs: selectedChoices(for: "tuesday")))
        #expect(abandoning.abandonActiveSession())
        #expect(abandoning.activeSession == nil)
        #expect(SessionController(configurationProvider: { abandonConfiguration }).activeSession == nil)
    }

    private func configuration(failFirstWrite: Bool = false) throws -> SessionStoreConfiguration {
        let directory = FileManager.default.temporaryDirectory.appending(path: "SessionControllerTests-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        return SessionStoreConfiguration(
            storeURL: directory.appending(path: "TrainingSessions.store"),
            failFirstWrite: failFirstWrite
        )
    }

    private func selectedChoices(for dayID: String) -> [String: String] {
        guard let day = RoutineCatalog.bundled.days.first(where: { $0.id == dayID }) else { return [:] }
        return Dictionary(uniqueKeysWithValues: day.exercises.compactMap { exercise in
            exercise.guideReferences.count > 1 ? (exercise.id, exercise.guideReferences[0].id) : nil
        })
    }
}
