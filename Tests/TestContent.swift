import XCTest
@testable import VelvetRoom

class TestContent:XCTestCase {
    func testParsing() {
        let json = """
{
"value": "hello world",
"time": 123.0
}
"""
        let content = try! JSONDecoder().decode(Content.self, from:Data(json.utf8))
        XCTAssertEqual("hello world", content.value)
        XCTAssertEqual(123, content.time)
    }
}
