import XCTest
@testable import VelvetRoom

class TestStorage:XCTestCase {
    private var repository:Repository!
    private var storage:MockStorage!
    
    override func setUp() {
        storage = MockStorage()
        repository = Repository()
        repository.synch = MockSynch()
        repository.storage = storage
        repository.list = { _ in }
        repository.select = { _ in }
    }
    
    func testLoadsAccount() {
        let expect = expectation(description:String())
        storage.onAccount = { expect.fulfill() }
        repository.load()
        waitForExpectations(timeout:1)
    }
    
    func testLoadNotes() {
        let expect = expectation(description:String())
        storage.returnAccount.boards = ["lorem"]
        storage.onBoard = { id in
            XCTAssertEqual("lorem", id)
            expect.fulfill()
        }
        repository.load()
        waitForExpectations(timeout:1)
    }
    
    func testNewBoardSavesBoard() {
        let expect = expectation(description:String())
        storage.onSaveBoard = { _ in expect.fulfill() }
        repository.newBoard(String(), template:.none)
        waitForExpectations(timeout:1)
    }
    
    func testNewBoardSavesAccount() {
        let expect = expectation(description:String())
        storage.onSaveAccount = { expect.fulfill() }
        repository.newBoard(String(), template:.none)
        waitForExpectations(timeout:1)
    }
    
    func testUpdateBoardSavesBoard() {
        let expect = expectation(description:String())
        let board = Board()
        board.name = "hello world"
        storage.onSaveBoard = { item in
            XCTAssertEqual("lorem ipsum", item.name)
            expect.fulfill()
        }
        repository.wait = 0
        board.name = "lorem ipsum"
        repository.scheduleUpdate(board)
        waitForExpectations(timeout:1)
    }
    
    func testUpdateBoardSavesBoardOnlyOnce() {
        let expect = expectation(description:String())
        let board = Board()
        board.name = "hello world"
        storage.onSaveBoard = { item in
            XCTAssertEqual("lorem ipsum", item.name)
            expect.fulfill()
        }
        repository.wait = 0
        board.name = "some"
        repository.scheduleUpdate(board)
        board.name = "lorem ipsum"
        repository.scheduleUpdate(board)
        waitForExpectations(timeout:1)
    }
    
    func testNewCardSavesBoard() {
        let expect = expectation(description:String())
        let board = Board()
        board.columns = [Column()]
        storage.onSaveBoard = { item in
            XCTAssertFalse(item.cards.isEmpty)
            expect.fulfill()
        }
        repository.wait = 0
        _ = try! repository.newCard(board)
        waitForExpectations(timeout:1)
    }
}
