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
}
