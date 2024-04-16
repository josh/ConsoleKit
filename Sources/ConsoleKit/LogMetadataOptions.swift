//
//  LogMetadataOptions.swift
//  ConsoleKit
//
//  Created by Joshua Peek on 4/6/24.
//

public struct LogMetadataOptions: OptionSet, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let type = Self(rawValue: 1 << 0)
    public static let timestamp = Self(rawValue: 1 << 1)
    public static let processName = Self(rawValue: 1 << 2)
    public static let library = Self(rawValue: 1 << 3)
    public static let pid = Self(rawValue: 1 << 4)
    public static let tid = Self(rawValue: 1 << 5)
    public static let subsystem = Self(rawValue: 1 << 6)
    public static let category = Self(rawValue: 1 << 7)

    public static let none: Self = []
    public static let all: Self = [.type, .timestamp, .processName, .library, .pid, .tid, .subsystem, .category]

    public static func show(_ options: Self...) -> Self {
        options.reduce(into: .none) { $0.formUnion($1) }
    }

    public static func hide(_ options: Self...) -> Self {
        options.reduce(into: .all) { $0.subtract($1) }
    }
}
