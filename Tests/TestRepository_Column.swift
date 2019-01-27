import XCTest
@testable import VelvetRoom

class TestRepository_Column:XCTestCase {
    private var repository:Repository!
    
    override func setUp() {
        repository = Repository()
        repository.storage = MockStorage()
        repository.synch = MockSynch()
        repository.group = MockGroup()
        repository.list = { _ in }
        repository.select = { _ in }
    }
    
    func testNewColumn() {
        let time = Date().timeIntervalSince1970
        let board = Board()
        let columnA = repository.newColumn(board)
        let columnB = repository.newColumn(board)
        let columnC = repository.newColumn(board)
        XCTAssertTrue(columnA === board.columns[0])
        XCTAssertTrue(columnB === board.columns[1])
        XCTAssertTrue(columnC === board.columns[2])
        XCTAssertLessThanOrEqual(time, columnA.created)
    }
    
    func testMoveColumnWithAfter() {
        let board = Board()
        let columnA = repository.newColumn(board)
        _ = repository.newColumn(board)
        let cardA = try! repository.newCard(board)
        let cardB = try! repository.newCard(board)
        XCTAssertTrue(columnA === board.columns[0])
        XCTAssertEqual(0, cardA.column)
        XCTAssertEqual(0, cardB.column)
        let columnC = repository.newColumn(board)
        repository.move(columnA, board:board, after:columnC)
        XCTAssertTrue(columnA === board.columns[2])
        XCTAssertEqual(2, cardA.column)
        XCTAssertEqual(2, cardB.column)
    }
    
    func testMoveColumnNoAfter() {
        let board = Board()
        let columnA = repository.newColumn(board)
        let cardA = try! repository.newCard(board)
        let columnB = repository.newColumn(board)
        let columnC = repository.newColumn(board)
        repository.move(columnC, board:board)
        XCTAssertTrue(columnA === board.columns[1])
        XCTAssertTrue(columnB === board.columns[2])
        XCTAssertTrue(columnC === board.columns[0])
        XCTAssertEqual(1, cardA.column)
    }
    
    func testMoveAndRearrange() {
        let board = Board()
        let columnA = repository.newColumn(board)
        let cardX = try! repository.newCard(board)
        let cardY = try! repository.newCard(board)
        let cardZ = try! repository.newCard(board)
        let columnB = repository.newColumn(board)
        let columnC = repository.newColumn(board)
        repository.move(cardX, board:board, column:columnB)
        XCTAssertEqual(1, cardX.column)
        repository.move(cardY, board:board, column:columnC)
        XCTAssertEqual(2, cardY.column)
        XCTAssertEqual(0, cardZ.column)
        repository.move(columnA, board:board, after:columnC)
        XCTAssertTrue(columnA === board.columns[2])
        XCTAssertTrue(columnB === board.columns[0])
        XCTAssertTrue(columnC === board.columns[1])
        XCTAssertEqual(0, cardX.column)
        XCTAssertEqual(1, cardY.column)
        XCTAssertEqual(2, cardZ.column)
    }
    
    func testDeleteColumn() {
        let board = Board()
        let columnA = repository.newColumn(board)
        _ = try! repository.newCard(board)
        let cardB = try! repository.newCard(board)
        let columnB = repository.newColumn(board)
        repository.move(cardB, board:board, column:columnB)
        repository.delete(columnA, board:board)
        XCTAssertEqual(1, board.cards.count)
        XCTAssertEqual(1, board.columns.count)
        XCTAssertEqual(0, cardB.column)
    }
}
