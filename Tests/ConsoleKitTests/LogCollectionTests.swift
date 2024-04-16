@testable import ConsoleKit
import XCTest

final class LogCollectionTests: XCTestCase {
    func testEmpty() {
        let c = LogCollection()
        XCTAssertEqual(c.dates.count, 0)
        XCTAssertEqual(c.logs.count, 0)
        XCTAssertTrue(c.isEmpty)
    }

    func testInitFromEmptySequence() {
        let c = LogCollection([])
        XCTAssertEqual(c.dates.count, 0)
        XCTAssertEqual(c.logs.count, 0)
        XCTAssertTrue(c.isEmpty)
    }

    func testInitFromSequence() {
        let c = LogCollection([
            Log(message: "#1", date: Date(timeIntervalSince1970: 0)),
            Log(message: "#2", date: Date(timeIntervalSince1970: 100_000)),
            Log(message: "#3", date: Date(timeIntervalSince1970: 100_001)),
            Log(message: "#4", date: Date(timeIntervalSince1970: 100_002)),
            Log(message: "#5", date: Date(timeIntervalSince1970: 200_000)),
        ])
        XCTAssertEqual(c.dates.count, 3)
        XCTAssertEqual(c.logs.count, 5)
        XCTAssertEqual(c[0].logs.count, 1)
        XCTAssertEqual(c[1].logs.count, 3)
        XCTAssertEqual(c[2].logs.count, 1)
        XCTAssertEqual(["#1"], c[0].logs.map(\.message))
        XCTAssertEqual(["#2", "#3", "#4"], c[1].logs.map(\.message))
        XCTAssertEqual(["#5"], c[2].logs.map(\.message))
    }

    func testAppend() {
        var c = LogCollection()

        c.append(Log(message: "#1", date: Date(timeIntervalSince1970: 0)))
        XCTAssertEqual(c.dates.count, 1)
        XCTAssertEqual(c.logs.count, 1)
        XCTAssertFalse(c.isEmpty)
        XCTAssertEqual(c[0].logs.count, 1)

        c.append(Log(message: "#2", date: Date(timeIntervalSince1970: 100_000)))
        XCTAssertEqual(c.dates.count, 2)
        XCTAssertEqual(c.logs.count, 2)
        XCTAssertEqual(c[0].logs.count, 1)
        XCTAssertEqual(c[1].logs.count, 1)

        c.append(Log(message: "#3", date: Date(timeIntervalSince1970: 100_001)))
        XCTAssertEqual(c.dates.count, 2)
        XCTAssertEqual(c.logs.count, 3)
        XCTAssertEqual(c[0].logs.count, 1)
        XCTAssertEqual(c[1].logs.count, 2)

        c.append(Log(message: "#4", date: Date(timeIntervalSince1970: 100_002)))
        XCTAssertEqual(c.dates.count, 2)
        XCTAssertEqual(c.logs.count, 4)
        XCTAssertEqual(c[0].logs.count, 1)
        XCTAssertEqual(c[1].logs.count, 3)

        c.append(Log(message: "#5", date: Date(timeIntervalSince1970: 200_000)))
        XCTAssertEqual(c.dates.count, 3)
        XCTAssertEqual(c.logs.count, 5)
        XCTAssertEqual(c[0].logs.count, 1)
        XCTAssertEqual(c[1].logs.count, 3)
        XCTAssertEqual(c[2].logs.count, 1)
    }

    func testAppendContentsOf() {
        var c = LogCollection()

        c.append(contentsOf: [
            Log(message: "#1", date: Date(timeIntervalSince1970: 0)),
            Log(message: "#2", date: Date(timeIntervalSince1970: 100_000)),
            Log(message: "#3", date: Date(timeIntervalSince1970: 100_001)),
            Log(message: "#4", date: Date(timeIntervalSince1970: 100_002)),
            Log(message: "#5", date: Date(timeIntervalSince1970: 200_000)),
        ])
        XCTAssertEqual(c.dates.count, 3)
        XCTAssertEqual(c.logs.count, 5)
        XCTAssertEqual(c[0].logs.count, 1)
        XCTAssertEqual(c[1].logs.count, 3)
        XCTAssertEqual(c[2].logs.count, 1)

        c.append(contentsOf: [])
        XCTAssertEqual(c.logs.count, 5)

        c.append(contentsOf: [
            Log(message: "#6", date: Date(timeIntervalSince1970: 200_001)),
        ])
        XCTAssertEqual(c.dates.count, 3)
        XCTAssertEqual(c.logs.count, 6)
        XCTAssertEqual(c[0].logs.count, 1)
        XCTAssertEqual(c[1].logs.count, 3)
        XCTAssertEqual(c[2].logs.count, 2)
    }

    func testReversed() {
        let c = LogCollection(
            [
                Log(message: "#1", date: Date(timeIntervalSince1970: 0)),
                Log(message: "#2", date: Date(timeIntervalSince1970: 100_000)),
                Log(message: "#3", date: Date(timeIntervalSince1970: 100_001)),
                Log(message: "#4", date: Date(timeIntervalSince1970: 100_002)),
                Log(message: "#5", date: Date(timeIntervalSince1970: 200_000)),
            ], reversed: true
        )
        XCTAssertEqual(c.dates.count, 3)
        XCTAssertEqual(c.logs.count, 5)
        XCTAssertEqual(c[0].logs.count, 1)
        XCTAssertEqual(c[1].logs.count, 3)
        XCTAssertEqual(c[2].logs.count, 1)
        XCTAssertEqual(["#5"], c[0].logs.map(\.message))
        XCTAssertEqual(["#4", "#3", "#2"], c[1].logs.map(\.message))
        XCTAssertEqual(["#1"], c[2].logs.map(\.message))
    }

    func testLogSliceEmpty() {
        let slice = LogSlice([], startIndex: 0, endIndex: 0)
        XCTAssertEqual(slice.count, 0)
        XCTAssertEqual(Array(slice).count, 0)

        let slice2 = LogSlice([Log(message: "#1")], startIndex: 1, endIndex: 1)
        XCTAssertEqual(slice2.count, 0)
        XCTAssertEqual(Array(slice2).count, 0)
    }

    func testLogSlice() {
        let logs = [
            Log(message: "#1"),
            Log(message: "#2"),
            Log(message: "#3"),
            Log(message: "#4"),
            Log(message: "#5"),
        ]

        let slice = LogSlice(logs, startIndex: 1, endIndex: 4)
        XCTAssertEqual(slice.count, 3)
        XCTAssertEqual(Array(slice).count, 3)
        XCTAssertEqual(slice[0].message, "#2")
        XCTAssertEqual(slice[1].message, "#3")
        XCTAssertEqual(slice[2].message, "#4")
    }

    func testLogSliceReversed() {
        let logs = [
            Log(message: "#1"),
            Log(message: "#2"),
            Log(message: "#3"),
            Log(message: "#4"),
            Log(message: "#5"),
        ]

        let slice = LogSlice(logs, startIndex: 4, endIndex: 1)
        XCTAssertEqual(slice.count, 3)
        XCTAssertEqual(Array(slice).count, 3)
        XCTAssertEqual(slice[0].message, "#4")
        XCTAssertEqual(slice[1].message, "#3")
        XCTAssertEqual(slice[2].message, "#2")
    }
}
