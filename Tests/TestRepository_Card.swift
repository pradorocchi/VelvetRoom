import XCTest
@testable import VelvetRoom

class TestRepository_Card:XCTestCase {
    private var repository:Repository!
    
    override func setUp() {
        repository = Repository()
        repository.storage = MockStorage()
        repository.synch = MockSynch()
        repository.group = MockGroup()
        repository.list = { _ in }
        repository.select = { _ in }
    }
    
    func testNewCardNoColumnThrows() {
        XCTAssertThrowsError(try repository.newCard(Board()))
    }
    
    func testNewCard() {
        let time = Date().timeIntervalSince1970
        let board = Board()
        board.columns = [Column()]
        repository.boards = [board]
        var card:Card!
        XCTAssertNoThrow(try card = repository.newCard(board))
        XCTAssertTrue(card === repository.boards.first!.cards.first!)
        XCTAssertLessThan(time, card.positions.first!.time)
        XCTAssertEqual(0, card.positions.first!.column)
        XCTAssertEqual(0, card.index)
    }
    
    func testNewCardOrdering() {
        let board = Board()
        board.columns = [Column()]
        let cardFirst = try! repository.newCard(board)
        let cardSecond = try! repository.newCard(board)
        let cardThird = try! repository.newCard(board)
        XCTAssertEqual(0, cardThird.column)
        XCTAssertEqual(0, cardThird.index)
        XCTAssertEqual(0, cardSecond.column)
        XCTAssertEqual(1, cardSecond.index)
        XCTAssertEqual(0, cardFirst.column)
        XCTAssertEqual(2, cardFirst.index)
    }
    
    func testMove() {
        let board = Board()
        let column = Column()
        board.columns = [column]
        let cardFirst = try! repository.newCard(board)
        let cardSecond = try! repository.newCard(board)
        let cardThird = try! repository.newCard(board)
        repository.move(cardThird, board:board, column:column, after:cardFirst)
        XCTAssertEqual(0, cardSecond.column)
        XCTAssertEqual(0, cardSecond.index)
        XCTAssertEqual(0, cardFirst.column)
        XCTAssertEqual(1, cardFirst.index)
        XCTAssertEqual(0, cardThird.column)
        XCTAssertEqual(2, cardThird.index)
    }
    
    func testMoveWithNoAfter() {
        let board = Board()
        let column = Column()
        board.columns = [column]
        let cardFirst = try! repository.newCard(board)
        let cardSecond = try! repository.newCard(board)
        let cardThird = try! repository.newCard(board)
        repository.move(cardFirst, board:board, column:column)
        XCTAssertEqual(2, cardSecond.index)
        XCTAssertEqual(0, cardFirst.index)
        XCTAssertEqual(1, cardThird.index)
    }
    
    func testMoveOtherColumn() {
        let board = Board()
        let columnA = Column()
        let columnB = Column()
        board.columns = [columnA, columnB]
        let cardFirst = try! repository.newCard(board)
        let cardSecond = try! repository.newCard(board)
        let cardThird = try! repository.newCard(board)
        repository.move(cardThird, board:board, column:columnB)
        XCTAssertEqual(0, cardSecond.column)
        XCTAssertEqual(0, cardSecond.index)
        XCTAssertEqual(0, cardFirst.column)
        XCTAssertEqual(1, cardFirst.index)
        XCTAssertEqual(1, cardThird.column)
        XCTAssertEqual(0, cardThird.index)
    }
    
    func testDeleteCard() {
        let board = Board()
        board.columns = [Column()]
        let cardFirst = try! repository.newCard(board)
        let cardSecond = try! repository.newCard(board)
        XCTAssertEqual(0, cardSecond.index)
        XCTAssertEqual(1, cardFirst.index)
        repository.delete(cardSecond, board:board)
        XCTAssertEqual(0, cardFirst.index)
        XCTAssertEqual(1, board.cards.count)
    }
}
