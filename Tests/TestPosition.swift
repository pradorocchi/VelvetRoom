import XCTest
@testable import VelvetRoom

class TestPosition:XCTestCase {
    func testParsing() {
        let json = """
{
"column": 1,
"time": 123.0
}
"""
        let position = try! JSONDecoder().decode(Position.self, from:Data(json.utf8))
        XCTAssertEqual(1, position.column)
        XCTAssertEqual(123, position.time)
    }
}
