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
}
