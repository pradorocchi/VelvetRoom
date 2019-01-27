import XCTest
@testable import VelvetRoom

class TestRepository_Board:XCTestCase {
    private var repository:Repository!

    override func setUp() {
        repository = Repository()
        repository.storage = MockStorage()
        repository.synch = MockSynch()
        repository.group = MockGroup()
        repository.list = { _ in }
        repository.select = { _ in }
    }
    
    func testNewBoard() {
        let time = Date().timeIntervalSince1970
        repository.newBoard("test", template:.none)
        XCTAssertFalse(repository.boards.first!.id.isEmpty)
        XCTAssertEqual("test", repository.boards.first!.name)
        XCTAssertLessThan(time, repository.boards.first!.created)
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
        repository.load()
        repository.boards = [board]
        repository.wait = 0
        repository.scheduleUpdate(board)
        DispatchQueue.global(qos:.background).asyncAfter(deadline:.now() + 0.01) {
            XCTAssertLessThan(time, self.repository.boards[0].updated)
            expect.fulfill()
        }
        waitForExpectations(timeout:1)
    }
    
    func testFiresSchedule() {
        let expect = expectation(description:String())
        let time = Date().timeIntervalSince1970
        let board = Board()
        repository.load()
        repository.boards = [board]
        repository.wait = 100
        repository.scheduleUpdate(board)
        repository.fireSchedule()
        DispatchQueue.global(qos:.background).asyncAfter(deadline:.now() + 0.01) {
            XCTAssertLessThan(time, self.repository.boards[0].updated)
            expect.fulfill()
        }
        waitForExpectations(timeout:1)
    }
    
    func testDeleteBoard() {
        repository.newBoard("test", template:.none)
        let board = repository.boards.first!
        repository.delete(board)
        XCTAssertTrue(repository.boards.isEmpty)
        XCTAssertTrue(repository.account.boards.isEmpty)
    }
    
    func testDeleteBoardLists() {
        let expect = expectation(description:String())
        repository.list = { boards in
            XCTAssertTrue(boards.isEmpty)
            expect.fulfill()
        }
        let board = Board()
        board.id = "hello world"
        repository.boards = [board]
        repository.delete(board)
        waitForExpectations(timeout:1)
    }
    
    func testSortedAfterLoad() {
        let a = Board()
        let b = Board()
        a.name = "A"
        b.name = "B"
        repository.boards = [b, a]
        repository.load()
        XCTAssertEqual("A", repository.boards[0].name)
        XCTAssertEqual("B", repository.boards[1].name)
    }
    
    func testSortedAfterSynch() {
        let expect = expectation(description:String())
        let a = Board()
        let b = Board()
        a.name = "A"
        a.id = "a"
        b.name = "B"
        b.id = "b"
        repository.boards = [b]
        let group = MockGroup()
        repository.group = group
        group.onShare = {
            XCTAssertEqual("A", self.repository.boards[0].name)
            XCTAssertEqual("B", self.repository.boards[1].name)
            expect.fulfill()
        }
        let mock = MockSynch()
        repository.synch = mock
        repository.synchBoards()
        mock.loaded(a)
        waitForExpectations(timeout:1)
    }
}
