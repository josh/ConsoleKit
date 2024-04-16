//
//  LogExport.swift
//  ConsoleKit
//
//  Created by Joshua Peek on 4/5/24.
//

import CoreTransferable
import Foundation

public struct LogExport: Sendable {
    public let logs: [Log]

    public init(logs: [Log]) {
        self.logs = logs
    }

    public init(logs: LogCollection) {
        self.logs = logs.logs
    }

    public init() {
        logs = []
    }
}

extension LogExport: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .plainText) { item in
            item.logs.map(\.description).joined(separator: "\n").data(using: .utf8) ?? Data()
        }
        // TODO: How to let caller customize this?
        .suggestedFileName("Aware.log")
    }
}
