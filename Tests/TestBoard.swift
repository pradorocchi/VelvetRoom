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
    
    func testChartNoColumns() {
        let board = Board()
        XCTAssertTrue(board.chart.isEmpty)
    }
    
    func testChartOneColumnNoCards() {
        let board = Board()
        board.columns = [Column()]
        XCTAssertTrue(board.chart.isEmpty)
    }
    
    func testChartOneColumnWithCards() {
        let board = Board()
        let cardA = Card()
        let cardB = Card()
        cardA.column = 0
        cardB.column = 0
        board.columns = [Column()]
        board.cards = [cardA, cardB]
        XCTAssertEqual(1, board.chart[0].1)
    }
    
    func testChartTwoColumnNoCards() {
        let board = Board()
        board.columns = [Column(), Column()]
        XCTAssertTrue(board.chart.isEmpty)
    }
    
    func testChartTwoColumnsWithCards() {
        let board = Board()
        let cardA = Card()
        let cardB = Card()
        cardA.column = 0
        cardB.column = 1
        board.columns = [Column(), Column()]
        board.cards = [cardA, cardB]
        XCTAssertEqual(0.5, board.chart[0].1)
        XCTAssertEqual(0.5, board.chart[1].1)
    }
    
    func testChartThreeColumnsWithCards() {
        let board = Board()
        let cardA = Card()
        let cardB = Card()
        cardA.column = 0
        cardB.column = 1
        board.columns = [Column(), Column(), Column()]
        board.cards = [cardA, cardB]
        XCTAssertEqual(0.5, board.chart[0].1)
        XCTAssertEqual(0.5, board.chart[1].1)
        XCTAssertEqual(0, board.chart[2].1)
    }
    
    func testChartThreeColumnsWithCardsCompleted() {
        let board = Board()
        let cardA = Card()
        let cardB = Card()
        cardA.column = 2
        cardB.column = 2
        board.columns = [Column(), Column(), Column()]
        board.cards = [cardA, cardB]
        XCTAssertEqual(0, board.chart[0].1)
        XCTAssertEqual(0, board.chart[1].1)
        XCTAssertEqual(1, board.chart[2].1)
    }
    
    func testNameEndingWhiteSpace() {
        let board = Board()
        board.name = "hello world "
        XCTAssertEqual("hello world", board.name)
    }
    
    func testNameEndingMultipleWhiteSpace() {
        let board = Board()
        board.name = "hello world     "
        XCTAssertEqual("hello world", board.name)
    }
    
    func testNameEndingNewLine() {
        let board = Board()
        board.name = "hello world\n"
        XCTAssertEqual("hello world", board.name)
    }
    
    func testNameEndingCarriageReturn() {
        let board = Board()
        board.name = "hello world\r"
        XCTAssertEqual("hello world", board.name)
    }
    
    func testNameEndingTab() {
        let board = Board()
        board.name = "hello world\t"
        XCTAssertEqual("hello world", board.name)
    }
}
