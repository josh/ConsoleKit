import Foundation
import OSLog

private let currentProcessIdentifier = ProcessInfo.processInfo.processIdentifier

public func logs() async throws -> [Log] {
    let task = Task<[Log], any Error>(priority: .background) {
        let store = try OSLogStore(scope: .currentProcessIdentifier)
        let position = store.position(date: .distantPast)

        return try store.getEntries(at: position).compactMap { entry in
            guard let entryLog = entry as? OSLogEntryLog else { return nil }
            let log = Log(entryLog)
            assert(log.processIdentifier == currentProcessIdentifier)
            return log
        }
    }

    return try await task.value
}

public func logUpdates(
    pollInterval: Duration = .seconds(5),
    pollTolerance: Duration = .seconds(1)
) -> AsyncThrowingStream<Log, any Error> {
    .init(bufferingPolicy: .unbounded) { continuation in
        let task = Task<Void, Never>(priority: .background) {
            do {
                let store = try OSLogStore(scope: .currentProcessIdentifier)
                var positionDate: Date = .distantPast

                while !Task.isCancelled {
                    let position = store.position(date: positionDate)
                    let entries = try store.getEntries(
                        at: position,
                        matching: NSPredicate(format: "date > %@", argumentArray: [positionDate])
                    )
                    var lastEntry: OSLogEntry?

                    for entry in entries {
                        assert(entry.date > positionDate, "expcted predicate to filter entries by date")
                        if let entryLog = entry as? OSLogEntryLog {
                            let log = Log(entryLog)
                            assert(log.processIdentifier == currentProcessIdentifier)
                            continuation.yield(log)
                        }
                        lastEntry = entry
                    }

                    if let lastEntry {
                        positionDate = lastEntry.date
                    }

                    try await Task.sleep(for: pollInterval, tolerance: pollTolerance)
                }

                try Task.checkCancellation()
                continuation.finish()
            } catch {
                continuation.finish(throwing: error)
            }
        }

        continuation.onTermination = { _ in
            task.cancel()
        }
    }
}
