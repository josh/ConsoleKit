//
//  LogListView.swift
//  ConsoleKit
//
//  Created by Joshua Peek on 4/5/24.
//

import SwiftUI

public struct LogListView: View {
    let logs: LogCollection
    let metadata: LogMetadataOptions
    let reversed: Bool

    public init(
        _ logs: LogCollection,
        metadata: LogMetadataOptions = .none,
        reversed: Bool = false
    ) {
        self.logs = reversed ? logs.reversed() : logs
        self.metadata = metadata
        self.reversed = reversed
    }

    init<S>(
        _ logs: S,
        metadata: LogMetadataOptions = .none
    ) where S: Sequence, S.Element == Log {
        self.init(LogCollection(logs), metadata: metadata)
    }

    public var body: some View {
        if logs.isEmpty {
            ProgressView()
        } else {
            List {
                ForEach(logs, id: \.date) { date, logs in
                    Section(header: Text(date.formatted(dateFormatStyle))) {
                        ForEach(logs) { log in
                            LogRowView(log, metadata: metadata)
                        }
                    }
                }
            }
            #if !os(visionOS)
            .listStyle(.bordered)
            #endif
        }
    }
}

private let dateFormatStyle = Date.ISO8601FormatStyle(timeZone: .current).year().month().day()

#Preview("Loading") {
    LogListView([])
}

#Preview("Groups") {
    LogListView(
        [
            Log(
                message: "Hello, World!",
                level: .notice,
                date: Calendar.current.date(byAdding: .day, value: -1, to: .now)!
            ),
            Log(
                message: "Something went wrong",
                level: .error,
                date: Calendar.current.date(byAdding: .day, value: -1, to: .now)!
            ),
            Log(
                message: "Something happened",
                level: .debug,
                date: Calendar.current.date(byAdding: .day, value: -1, to: .now)!
            ),
            Log(
                message: "Crash",
                level: .fault,
                date: Calendar.current.date(byAdding: .day, value: -2, to: .now)!
            ),
        ])
}
