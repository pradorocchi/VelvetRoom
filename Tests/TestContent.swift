import XCTest
@testable import VelvetRoom

class TestContent:XCTestCase {
    private var data:Data!
    private let json = """
{
"value": "hello world",
"time": 123.0
}
"""
    override func setUp() {
        data = Data(json.utf8)
    }
    
    func testParsing() {
        let content = try! JSONDecoder().decode(Content.self, from:data)
        XCTAssertEqual("hello world", content.value)
        XCTAssertEqual(123, content.time)
    }
}
