//
//  LogCollection.swift
//  ConsoleKit
//
//  Created by Joshua Peek on 4/5/24.
//

import Foundation

public struct LogCollection: Sendable {
    public init() {}

    public init<S>(_ logs: S, reversed: Bool = false) where S: Sequence, S.Element == Log {
        _reversed = reversed
        append(contentsOf: logs)
    }

    let calendar = Calendar.current

    private(set) var logs: [Log] = []
    private(set) var dates: [Date] = []
    private var logsIndicies: [Int] = []
    private var _reversed: Bool = false

    func reversed() -> LogCollection {
        var reversedLogs = self
        reversedLogs._reversed = !reversedLogs._reversed
        return reversedLogs
    }

    public mutating func append(_ log: Log) {
        let date = calendar.startOfDay(for: log.date)
        let index = logs.endIndex

        assert(logs.last == nil || log.date > logs.last!.date, "appending out of order log")

        if date == dates.last {
            logs.append(log)
        } else {
            assert(dates.last == nil || date > dates.last!, "appending out of order log")
            logs.append(log)
            dates.append(date)
            logsIndicies.append(index)
        }

        assert(logs.count >= logsIndicies.count)
        assert(dates.count == logsIndicies.count)
    }

    public mutating func append<S>(contentsOf logs: S) where S: Sequence, S.Element == Log {
        let oldEndIndex = self.logs.endIndex

        self.logs.append(contentsOf: logs)

        for index in oldEndIndex ..< self.logs.endIndex {
            let log = self.logs[index]
            let date = calendar.startOfDay(for: log.date)

            assert(index == self.logs.startIndex || log.date > self.logs[index - 1].date, "appending out of order log")

            if date != dates.last {
                assert(dates.last == nil || date > dates.last!, "appending out of order log")
                dates.append(date)
                logsIndicies.append(index)
            }
        }

        assert(self.logs.count >= logsIndicies.count)
        assert(dates.count == logsIndicies.count)
    }
}

extension LogCollection: RandomAccessCollection {
    public typealias Element = (date: Date, logs: LogSlice)
    public typealias Index = Int

    public var startIndex: Int { 0 }
    public var endIndex: Int { dates.endIndex }

    public func index(after i: Int) -> Int {
        assert(i >= startIndex, "Index out of range")
        assert(i < endIndex, "Index out of range")
        return i + 1
    }

    public func index(before i: Int) -> Int {
        assert(i > startIndex, "Index out of range")
        assert(i <= endIndex, "Index out of range")
        return i - 1
    }

    public subscript(position: Int) -> (date: Date, logs: LogSlice) {
        precondition(position >= startIndex, "Index out of range")
        precondition(position < endIndex, "Index out of range")

        let index = _reversed ? endIndex - position - 1 : position
        let date = dates[index]
        var logStartIndex = logsIndicies[index]
        var logEndIndex = index + 1 < logsIndicies.endIndex ? logsIndicies[index + 1] : logs.endIndex
        if _reversed {
            swap(&logStartIndex, &logEndIndex)
        }
        let logSlice = LogSlice(logs, startIndex: logStartIndex, endIndex: logEndIndex)
        return (date: date, logs: logSlice)
    }
}

public struct LogSlice {
    private let base: [Log]
    private let _startIndex: Int
    private let _endIndex: Int
    private let _count: Int
    private let _reversed: Bool

    init(_ base: [Log], startIndex: Int, endIndex: Int) {
        self.base = base

        if startIndex > endIndex {
            _startIndex = endIndex
            _endIndex = startIndex
            _count = startIndex - endIndex
            _reversed = true
        } else {
            _startIndex = startIndex
            _endIndex = endIndex
            _count = endIndex - startIndex
            _reversed = false
        }

        assert(_startIndex <= _endIndex)
        assert(_count == 0 || base.indices.contains(_startIndex))
        assert(_count >= 0)
    }

    func reversed() -> LogSlice {
        LogSlice(base, startIndex: _endIndex, endIndex: _startIndex)
    }
}

extension LogSlice: RandomAccessCollection {
    public typealias Element = Log
    public typealias Index = Int

    public var startIndex: Int { 0 }
    public var endIndex: Int { _count }

    public func index(after i: Int) -> Int {
        assert(i >= startIndex, "Index out of range")
        assert(i < endIndex, "Index out of range")
        return i + 1
    }

    public func index(before i: Int) -> Int {
        assert(i > startIndex, "Index out of range")
        assert(i <= endIndex, "Index out of range")
        return i - 1
    }

    public subscript(position: Int) -> Log {
        precondition(position >= startIndex, "Index out of range")
        precondition(position < endIndex, "Index out of range")
        if _reversed {
            return base[_endIndex - position - 1]
        } else {
            return base[position + _startIndex]
        }
    }
}
