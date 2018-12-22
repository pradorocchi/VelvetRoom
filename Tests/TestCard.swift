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
        XCTAssertLessThan(time, card.contents.first!.time)
        XCTAssertEqual("lorem ipsum", card.contents.last!.value)
        XCTAssertLessThan(card.contents.first!.time, card.contents.last!.time)
    }
}
