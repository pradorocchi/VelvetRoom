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
    
    func testNotNewContentIfSame() {
        let card = Card()
        card.content = "hello world"
        card.content = "hello world"
        XCTAssertEqual(1, card.contents.count)
    }
    
    func testNewPosition() {
        let time = Date().timeIntervalSince1970
        let card = Card()
        card.position(column:1, index:1)
        card.position(column:2, index:2)
        XCTAssertEqual(2, card.positions.count)
        XCTAssertEqual(1, card.positions.first!.column)
        XCTAssertEqual(1, card.positions.first!.index)
        XCTAssertLessThanOrEqual(time, card.positions.first!.time)
        XCTAssertEqual(2, card.positions.last!.column)
        XCTAssertEqual(2, card.positions.last!.index)
        XCTAssertLessThanOrEqual(card.positions.first!.time, card.positions.last!.time)
    }
    
    func testNotNewPositionIfSame() {
        let card = Card()
        card.position(column:1, index:1)
        card.position(column:1, index:1)
        XCTAssertEqual(1, card.positions.count)
    }
    
    func testContentEndingWhiteSpace() {
        let card = Card()
        card.content = "hello world "
        XCTAssertEqual("hello world", card.contents.first!.value)
    }
    
    func testContentEndingMultipleWhiteSpace() {
        let card = Card()
        card.content = "hello world    "
        XCTAssertEqual("hello world", card.contents.first!.value)
    }
    
    func testContentEndingNewLine() {
        let card = Card()
        card.content = "hello world\n"
        XCTAssertEqual("hello world", card.contents.first!.value)
    }
    
    func testContentEndingCarriageReturn() {
        let card = Card()
        card.content = "hello world\r"
        XCTAssertEqual("hello world", card.contents.first!.value)
    }
    
    func testContentEndingTab() {
        let card = Card()
        card.content = "hello world\t"
        XCTAssertEqual("hello world", card.contents.first!.value)
    }
}
