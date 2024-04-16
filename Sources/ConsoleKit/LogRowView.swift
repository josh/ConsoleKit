//
//  LogRowView.swift
//  ConsoleKit
//
//  Created by Joshua Peek on 4/5/24.
//

import SwiftUI

public struct LogRowView: View {
    let log: Log
    let metadata: LogMetadataOptions

    public init(_ log: Log, metadata: LogMetadataOptions = .none) {
        self.log = log
        self.metadata = metadata
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(log.message)
                .foregroundColor(.primary)
                .font(.body)
                .fontDesign(.monospaced)

            HStack(alignment: .center, spacing: 5) {
                LogRowIconView(level: log.level)

                HStack(alignment: .center) {
                    if metadata.contains(.timestamp) {
                        Text(log.timestamp.formatted(timestampFormatStyle))
                    }

                    if metadata.contains(.processName) {
                        HStack(alignment: .center, spacing: 2) {
                            Image(systemName: "apple.terminal")
                            Text(log.process)
                        }
                    }

                    if metadata.contains(.library) {
                        HStack(alignment: .center, spacing: 2) {
                            Image(systemName: "building.columns")
                            Text(log.library)
                        }
                    }

                    if metadata.contains(.pid) || metadata.contains(.tid) {
                        HStack(alignment: .center, spacing: 2) {
                            Image(systemName: "tag")
                            if metadata.contains(.pid) {
                                Text(String(log.pid))
                            }
                            if metadata.contains(.pid) && metadata.contains(.tid) {
                                Text(":")
                            }
                            if metadata.contains(.tid) {
                                Text(String(format: "0x%02x", log.tid))
                            }
                        }
                    }

                    if metadata.contains(.subsystem) {
                        HStack(alignment: .center, spacing: 2) {
                            Image(systemName: "gearshape.2")
                            Text(log.subsystem)
                        }
                    }

                    if metadata.contains(.category) {
                        HStack(alignment: .center, spacing: 2) {
                            Image(systemName: "square.grid.3x3")
                            Text(log.category)
                        }
                    }
                }

                Spacer()
            }
            .lineLimit(1)
            .foregroundColor(.secondary.opacity(0.75))
            .fontWeight(.semibold)
            .font(.caption)
        }
        .listRowBackground(background)
    }

    var background: Color {
        switch log.level {
        case .error: .yellow.opacity(0.10)
        case .fault: .red.opacity(0.10)
        default: .clear
        }
    }
}

private let timestampFormatStyle = Date.ISO8601FormatStyle(timeZone: .current).time(includingFractionalSeconds: true)

#Preview("No Metadata") {
    LogRowView(
        Log(message: "Hello, World!"),
        metadata: .none
    )
}

#Preview("All Metadata") {
    LogRowView(
        Log(message: "Hello, World!"),
        metadata: .all
    )
}

#Preview("Some Metadata") {
    LogRowView(
        Log(message: "Hello, World!"),
        metadata: .show(.type, .timestamp, .pid, .tid, .category)
    )
}
