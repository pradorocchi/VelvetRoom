import XCTest
@testable import VelvetRoom

class TestRepository_Column:XCTestCase {
    private var repository:Repository!
    
    override func setUp() {
        repository = Repository()
        repository.storage = MockStorage()
        repository.synch = MockSynch()
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
    
    func testMoveColumn() {
        let board = Board()
        let columnA = repository.newColumn(board)
        _ = repository.newColumn(board)
        let cardA = try! repository.newCard(board)
        let cardB = try! repository.newCard(board)
        XCTAssertTrue(columnA === board.columns[0])
        XCTAssertEqual(0, cardA.column)
        XCTAssertEqual(0, cardB.column)
        _ = repository.newColumn(board)
        repository.move(columnA, board:board, index:2)
        XCTAssertTrue(columnA === board.columns[2])
        XCTAssertEqual(2, cardA.column)
        XCTAssertEqual(2, cardB.column)
    }
}
