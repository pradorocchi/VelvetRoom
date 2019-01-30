import XCTest
@testable import VelvetRoom

class TestCard:XCTestCase {
    func testParsing() {
        let json = """
{
"index": 0,
"positions": [],
"contents": []
}
"""
        let card = try! JSONDecoder().decode(Card.self, from:Data(json.utf8))
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
        card.column = 1
        card.column = 2
        XCTAssertEqual(2, card.positions.count)
        XCTAssertEqual(1, card.positions.first!.column)
        XCTAssertLessThanOrEqual(time, card.positions.first!.time)
        XCTAssertEqual(2, card.positions.last!.column)
        XCTAssertLessThanOrEqual(card.positions.first!.time, card.positions.last!.time)
    }
    
    func testNotNewPositionIfSame() {
        let card = Card()
        card.column = 1
        card.column = 1
        XCTAssertEqual(1, card.positions.count)
    }
    
    func testNotNewPositionMovingIndex() {
        let card = Card()
        card.index = 1
        card.index = 2
        card.index = 3
        XCTAssertTrue(card.positions.isEmpty)
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
    
    func testCleanBeforeComparingContent() {
        let card = Card()
        card.content = "hello world"
        card.content = "hello world "
        XCTAssertEqual(1, card.contents.count)
    }
}
