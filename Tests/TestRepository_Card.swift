import XCTest
@testable import VelvetRoom

class TestRepository_Card:XCTestCase {
    private var repository:Repository!
    
    override func setUp() {
        repository = Repository()
        repository.storage = MockStorage()
        repository.synch = MockSynch()
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
        XCTAssertEqual(0, card.positions.first!.index)
    }
    
    func testNewCardOrdering() {
        let board = Board()
        board.columns = [Column()]
        repository.boards = [board]
        var cardFirst:Card!
        XCTAssertNoThrow(try cardFirst = repository.newCard(board))
        var cardSecond:Card!
        XCTAssertNoThrow(try cardSecond = repository.newCard(board))
        var cardThird:Card!
        XCTAssertNoThrow(try cardThird = repository.newCard(board))
        XCTAssertEqual(0, cardThird.column)
        XCTAssertEqual(0, cardThird.index)
        XCTAssertEqual(0, cardSecond.column)
        XCTAssertEqual(1, cardSecond.index)
        XCTAssertEqual(0, cardFirst.column)
        XCTAssertEqual(2, cardFirst.index)
    }
    
    func testDetach() {
        let board = Board()
        board.columns = [Column()]
        repository.boards = [board]
        var cardFirst:Card!
        XCTAssertNoThrow(try cardFirst = repository.newCard(board))
        var cardSecond:Card!
        XCTAssertNoThrow(try cardSecond = repository.newCard(board))
        var cardThird:Card!
        XCTAssertNoThrow(try cardThird = repository.newCard(board))
        repository.detach(cardThird, board:board)
        XCTAssertEqual(0, cardSecond.column)
        XCTAssertEqual(0, cardSecond.index)
        XCTAssertEqual(0, cardFirst.column)
        XCTAssertEqual(1, cardFirst.index)
    }
    
    func testAttachNoAfter() {
        let board = Board()
        let column = Column()
        board.columns = [column]
        repository.boards = [board]
        var cardFirst:Card!
        XCTAssertNoThrow(try cardFirst = repository.newCard(board))
        var cardSecond:Card!
        XCTAssertNoThrow(try cardSecond = repository.newCard(board))
        let card = Card()
        repository.attach(card, board:board, column:column, after:nil)
        XCTAssertEqual(0, card.index)
        XCTAssertEqual(0, card.column)
        XCTAssertEqual(1, cardSecond.index)
        XCTAssertEqual(2, cardFirst.index)
    }
    
    func testAttachWithAfter() {
        let board = Board()
        let column = Column()
        board.columns = [column]
        repository.boards = [board]
        var cardFirst:Card!
        XCTAssertNoThrow(try cardFirst = repository.newCard(board))
        var cardSecond:Card!
        XCTAssertNoThrow(try cardSecond = repository.newCard(board))
        let card = Card()
        repository.attach(card, board:board, column:column, after:cardSecond)
        XCTAssertEqual(0, cardSecond.index)
        XCTAssertEqual(0, card.column)
        XCTAssertEqual(1, card.index)
        XCTAssertEqual(2, cardFirst.index)
    }
    
    func testAttachOtherColumn() {
        let board = Board()
        let column = Column()
        board.columns = [Column(), column, Column()]
        repository.boards = [board]
        let card = Card()
        repository.attach(card, board:board, column:column, after:nil)
        XCTAssertEqual(0, card.index)
        XCTAssertEqual(1, card.column)
    }
}
