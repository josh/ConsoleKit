//
//  Log.swift
//  ConsoleKit
//
//  Created by Joshua Peek on 4/10/24.
//

import Foundation
import OSLog

public struct Log: Identifiable, Sendable, CustomStringConvertible {
    public let message: String
    public let level: OSLogEntryLog.Level
    public let date: Date
    public let process: String
    public let sender: String
    public let processIdentifier: Int32
    public let threadIdentifier: UInt64
    public let subsystem: String
    public let category: String

    public var pid: Int32 { processIdentifier }

    public var tid: UInt64 { threadIdentifier }

    public var timestamp: Date { date }

    public var library: String { sender }

    public static var processIdentifier: Int32 {
        ProcessInfo.processInfo.processIdentifier
    }

    public static var threadIdentifier: UInt64 {
        var tid: UInt64 = 0
        pthread_threadid_np(nil, &tid)
        return tid
    }

    public static var process: String {
        ProcessInfo.processInfo.processName
    }

    public static func sender(fileID: String = #fileID) -> String {
        return String(fileID.split(separator: "/").first!)
    }

    public static var subsystem: String {
        Bundle.main.bundleIdentifier!
    }

    public static func category(fileID: String = #fileID) -> String {
        let basename = fileID.split(separator: "/").last!
        return String(basename.split(separator: ".").first!)
    }

    public init(
        message: String,
        level: OSLogEntryLog.Level = .notice,
        date: Date = Date(),
        process: String = Self.process,
        sender: String = Self.sender(),
        processIdentifier: Int32 = Self.processIdentifier,
        threadIdentifier: UInt64 = Self.threadIdentifier,
        subsystem: String = Self.subsystem,
        category: String = Self.category()
    ) {
        self.message = message
        self.level = level
        self.date = date
        self.process = process
        self.sender = sender
        self.processIdentifier = processIdentifier
        self.threadIdentifier = threadIdentifier
        self.subsystem = subsystem
        self.category = category
    }

    public init(_ entryLog: OSLogEntryLog) {
        message = entryLog.composedMessage
        level = entryLog.level
        date = entryLog.date
        process = entryLog.process
        sender = entryLog.sender
        processIdentifier = entryLog.processIdentifier
        threadIdentifier = entryLog.threadIdentifier
        subsystem = entryLog.subsystem
        category = entryLog.category
    }

    public var id: Double {
        date.timeIntervalSinceReferenceDate
    }

    public var description: String {
        "[\(timestamp.formatted())] [\(category)] \(message)"
    }
}
