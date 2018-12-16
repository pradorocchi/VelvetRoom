import XCTest
@testable import VelvetRoom

class TestRepository:XCTestCase {
    private var repository:Repository!

    override func setUp() {
        repository = Repository()
        repository.storage = MockStorage()
        repository.synch = MockSynch()
        repository.list = { _ in }
        repository.select = { _ in }
    }
    
    func testNewBoard() {
        let time = Date().timeIntervalSince1970
        repository.newBoard("test", template:.none)
        XCTAssertFalse(repository.boards.first!.id.isEmpty)
        XCTAssertEqual("test", repository.boards.first!.name)
        XCTAssertLessThanOrEqual(time, repository.boards.first!.created)
        XCTAssertLessThanOrEqual(time, repository.boards.first!.updated)
        XCTAssertEqual(repository.boards.first!.id, repository.account.boards.first!)
    }
    
    func testNewBoardIsSorted() {
        var boardA = Board()
        boardA.name = "A"
        var boardC = Board()
        boardC.name = "C"
        repository.boards = [boardA, boardC]
        repository.newBoard("B", template:.none)
        XCTAssertEqual("B", repository.boards[1].name)
    }
}
