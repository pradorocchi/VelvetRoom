import XCTest
@testable import VelvetRoom

class TestPosition:XCTestCase {
    private var data:Data!
    private let json = """
{
"column": 1,
"index": 2,
"time": 123.0
}
"""
    override func setUp() {
        data = Data(json.utf8)
    }
    
    func testParsing() {
        let position = try! JSONDecoder().decode(Position.self, from:data)
        XCTAssertEqual(1, position.column)
        XCTAssertEqual(2, position.index)
        XCTAssertEqual(123, position.time)
    }
}
