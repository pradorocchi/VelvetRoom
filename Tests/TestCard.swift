import XCTest
@testable import VelvetRoom

class TestCard:XCTestCase {
    private var data:Data!
    private let json = """
{
"positions": [],
"contents": []
}
"""
    override func setUp() {
        data = Data(json.utf8)
    }
    
    func testParsing() {
        let card = try! JSONDecoder().decode(Card.self, from:data)
        XCTAssertTrue(card.positions.isEmpty)
        XCTAssertTrue(card.contents.isEmpty)
    }
    
    func testNewContent() {
        let time = Date().timeIntervalSince1970
        let card = Card()
        card.content = "hello world"
        card.content = "lorem ipsum"
        XCTAssertEqual(2, card.contents.count)
        XCTAssertEqual("hello world", card.contents.first!.value)
        XCTAssertLessThanOrEqual(time, card.contents.first!.time)
        XCTAssertEqual("lorem ipsum", card.contents.last!.value)
        XCTAssertLessThanOrEqual(card.contents.first!.time, card.contents.last!.time)
    }
    
    func testNewPosition() {
        let time = Date().timeIntervalSince1970
        let card = Card()
        card.position = (1, 1)
        card.position = (2, 2)
        XCTAssertEqual(2, card.positions.count)
        XCTAssertEqual(1, card.positions.first!.column)
        XCTAssertEqual(1, card.positions.first!.index)
        XCTAssertLessThanOrEqual(time, card.positions.first!.time)
        XCTAssertEqual(2, card.positions.last!.column)
        XCTAssertEqual(2, card.positions.last!.index)
        XCTAssertLessThanOrEqual(card.positions.first!.time, card.positions.last!.time)
    }
}
