import XCTest
@testable import VelvetRoom

class TestBoard:XCTestCase {
    private var data:Data!
    private let json = """
{
"id": "lorem ipsum",
"created": 123.0,
"updated": 345.0,
"name": "hello world",
"columns": [],
"cards": []
}
"""
    override func setUp() {
        data = Data(json.utf8)
    }
    
    func testParsing() {
        let board = try! JSONDecoder().decode(Board.self, from:data)
        XCTAssertEqual("lorem ipsum", board.id)
        XCTAssertEqual(123, board.created)
        XCTAssertEqual(345, board.updated)
        XCTAssertEqual("hello world", board.name)
        XCTAssertTrue(board.columns.isEmpty)
        XCTAssertTrue(board.cards.isEmpty)
    }
}
