import XCTest
@testable import VelvetRoom

class TestColumn:XCTestCase {
    private var data:Data!
    private let json = """
{
"name": "hello world",
"created": 123.0
}
"""
    override func setUp() {
        data = Data(json.utf8)
    }
    
    func testParsing() {
        let column = try! JSONDecoder().decode(Column.self, from:data)
        XCTAssertEqual("hello world", column.name)
        XCTAssertEqual(123, column.created)
    }
    
    func testNameEndingWhiteSpace() {
        let column = Column()
        column.name = "hello world "
        XCTAssertEqual("hello world", column.name)
    }
    
    func testNameEndingMultipleWhiteSpace() {
        let column = Column()
        column.name = "hello world     "
        XCTAssertEqual("hello world", column.name)
    }
    
    func testNameEndingNewLine() {
        let column = Column()
        column.name = "hello world\n"
        XCTAssertEqual("hello world", column.name)
    }
    
    func testNameEndingCarriageReturn() {
        let column = Column()
        column.name = "hello world\r"
        XCTAssertEqual("hello world", column.name)
    }
    
    func testNameEndingTab() {
        let column = Column()
        column.name = "hello world\t"
        XCTAssertEqual("hello world", column.name)
    }
}
