import Foundation
import Observation
import SwiftData

@MainActor
@Observable
final class SessionController {
    typealias ConfigurationProvider = () throws -> SessionStoreConfiguration
    typealias AdapterFactory = (SessionStoreConfiguration) throws -> SessionPersistenceAdapter

    private let configurationProvider: ConfigurationProvider
    private let adapterFactory: AdapterFactory
    private var adapter: SessionPersistenceAdapter?

    private(set) var activeSession: TrainingSession?
    private(set) var startupFailed = false
    private(set) var message: SessionControllerMessage?

    init(
        configurationProvider: @escaping ConfigurationProvider = SessionStoreConfiguration.fromLaunchArguments,
        adapterFactory: AdapterFactory? = nil
    ) {
        self.configurationProvider = configurationProvider
        self.adapterFactory = adapterFactory ?? Self.makeAdapter
        openStore()
    }

    func retryStoreAccess() {
        openStore()
    }

    @discardableResult
    func start(dayID: String, selectedGuideReferenceIDs: [String: String]) -> Bool {
        guard !startupFailed, let adapter else {
            message = .storeUnavailable
            return false
        }
        guard activeSession == nil else {
            message = .activeSessionExists
            return false
        }

        do {
            let session = try adapter.begin(dayID: dayID, selectedGuideReferenceIDs: selectedGuideReferenceIDs)
            activeSession = session
            message = nil
            return true
        } catch SessionPersistenceError.activeSessionExists {
            do {
                activeSession = try adapter.recoverActive()
                message = .activeSessionExists
            } catch {
                message = .storageReadFailed
            }
            return false
        } catch {
            message = .startFailed
            return false
        }
    }

    @discardableResult
    func finishActiveSession() -> Bool {
        guard let activeSession, let adapter else {
            message = .storeUnavailable
            return false
        }
        do {
            try adapter.finish(activeSession.id)
            self.activeSession = nil
            message = nil
            return true
        } catch {
            message = .finishFailed
            return false
        }
    }

    @discardableResult
    func abandonActiveSession() -> Bool {
        guard let activeSession, let adapter else {
            message = .storeUnavailable
            return false
        }
        do {
            try adapter.abandon(activeSession.id)
            self.activeSession = nil
            message = nil
            return true
        } catch {
            message = .abandonFailed
            return false
        }
    }

    private func openStore() {
        do {
            let configuration = try configurationProvider()
            let openedAdapter = try adapterFactory(configuration)
            let recoveredSession = try openedAdapter.recoverActive()
            adapter = openedAdapter
            activeSession = recoveredSession
            startupFailed = false
            message = nil
        } catch {
            adapter = nil
            activeSession = nil
            startupFailed = true
            message = .storageReadFailed
        }
    }

    private static func makeAdapter(configuration: SessionStoreConfiguration) throws -> SessionPersistenceAdapter {
        guard configuration.failFirstWrite else {
            return try SessionPersistenceAdapter(storeURL: configuration.storeURL)
        }

        var shouldFail = true
        return try SessionPersistenceAdapter(storeURL: configuration.storeURL) { context in
            if shouldFail {
                shouldFail = false
                throw SessionStoreTestFailure.injectedWriteFailure
            }
            try context.save()
        }
    }
}

enum SessionControllerMessage: Equatable {
    case storeUnavailable
    case storageReadFailed
    case activeSessionExists
    case startFailed
    case finishFailed
    case abandonFailed
}

struct SessionStoreConfiguration: Equatable {
    let storeURL: URL
    let failFirstWrite: Bool

    static func fromLaunchArguments() throws -> SessionStoreConfiguration {
        let fileManager = FileManager.default
        #if DEBUG
        let isDebugBuild = true
        #else
        let isDebugBuild = false
        #endif
        return try resolve(
            arguments: ProcessInfo.processInfo.arguments,
            applicationSupportDirectory: try fileManager.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ),
            temporaryDirectory: fileManager.temporaryDirectory,
            isDebugBuild: isDebugBuild,
            fileManager: fileManager
        )
    }

    static func resolve(
        arguments: [String],
        applicationSupportDirectory: URL,
        temporaryDirectory: URL,
        isDebugBuild: Bool,
        fileManager: FileManager = .default
    ) throws -> SessionStoreConfiguration {
        let testArguments = arguments.filter { $0.hasPrefix("--training-ui-test-") }
        guard !testArguments.isEmpty else {
            let storeDirectory = applicationSupportDirectory.appending(path: "TrainingApp", directoryHint: .isDirectory)
            try fileManager.createDirectory(at: storeDirectory, withIntermediateDirectories: true)
            return SessionStoreConfiguration(
                storeURL: storeDirectory.appending(path: "TrainingSessions.store"),
                failFirstWrite: false
            )
        }

        guard isDebugBuild else { throw SessionStoreConfigurationError.unsupportedTestArguments }
        let tokenFlag = "--training-ui-test-store-token"
        let failureFlag = "--training-ui-test-write-failure"
        let allowedFlags: Set<String> = [tokenFlag, failureFlag]
        guard testArguments.allSatisfy(allowedFlags.contains),
              testArguments.filter({ $0 == tokenFlag }).count == 1,
              testArguments.filter({ $0 == failureFlag }).count <= 1,
              let tokenIndex = arguments.firstIndex(of: tokenFlag),
              arguments.indices.contains(tokenIndex + 1),
              let token = UUID(uuidString: arguments[tokenIndex + 1]),
              !arguments[tokenIndex + 1].hasPrefix("--") else {
            throw SessionStoreConfigurationError.invalidTestArguments
        }

        let storeDirectory = temporaryDirectory
            .appending(path: "TrainingAppUITestStores", directoryHint: .isDirectory)
            .appending(path: token.uuidString, directoryHint: .isDirectory)
        try fileManager.createDirectory(at: storeDirectory, withIntermediateDirectories: true)
        return SessionStoreConfiguration(
            storeURL: storeDirectory.appending(path: "TrainingSessions.store"),
            failFirstWrite: testArguments.contains(failureFlag)
        )
    }
}

enum SessionStoreConfigurationError: Error {
    case invalidTestArguments
    case unsupportedTestArguments
}

private enum SessionStoreTestFailure: Error {
    case injectedWriteFailure
}
