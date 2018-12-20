import XCTest
@testable import VelvetRoom

class TestRepository_Board:XCTestCase {
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
        XCTAssertEqual(repository.boards.first!.id, repository.account.boards.first!)
    }
    
    func testNewBoardIsSorted() {
        let expect = expectation(description:String())
        repository.list = { boards in
            XCTAssertEqual("B", boards[1].name)
            expect.fulfill()
        }
        let boardA = Board()
        boardA.name = "A"
        let boardC = Board()
        boardC.name = "C"
        repository.boards = [boardA, boardC]
        repository.newBoard("B", template:.none)
        waitForExpectations(timeout:1)
    }
    
    func testScheduleUpdateBoard() {
        let expect = expectation(description:String())
        let time = Date().timeIntervalSince1970
        let board = Board()
        repository.boards = [board]
        repository.wait = 0
        repository.scheduleUpdate(board)
        DispatchQueue.global(qos:.background).asyncAfter(deadline:.now() + 0.01) {
            XCTAssertLessThanOrEqual(time, self.repository.boards[0].updated)
            expect.fulfill()
        }
        waitForExpectations(timeout:1)
    }
    
    func testFiresSchedule() {
        let expect = expectation(description:String())
        let time = Date().timeIntervalSince1970
        let board = Board()
        repository.boards = [board]
        repository.wait = 100
        repository.scheduleUpdate(board)
        repository.fireSchedule()
        DispatchQueue.global(qos:.background).asyncAfter(deadline:.now() + 0.01) {
            XCTAssertLessThanOrEqual(time, self.repository.boards[0].updated)
            expect.fulfill()
        }
        waitForExpectations(timeout:1)
    }
}
