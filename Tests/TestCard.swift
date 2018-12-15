import XCTest
@testable import VelvetRoom

class TestCard:XCTestCase {
    private var data:Data!
    private let json = """
{
"position": [],
"content": []
}
"""
    override func setUp() {
        data = Data(json.utf8)
    }
    
    func testParsing() {
        let card = try! JSONDecoder().decode(Card.self, from:data)
        XCTAssertTrue(card.position.isEmpty)
        XCTAssertTrue(card.content.isEmpty)
    }
}
