import XCTest
@testable import VelvetRoom

class TestStorage:XCTestCase {
    private var repository:Repository!
    private var storage:MockStorage!
    
    override func setUp() {
        storage = MockStorage()
        repository = Repository()
        repository.synch = MockSynch()
        repository.group = MockGroup()
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
        repository.load()
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
        repository.load()
        repository.wait = 0
        board.name = "some"
        repository.scheduleUpdate(board)
        board.name = "lorem ipsum"
        repository.scheduleUpdate(board)
        waitForExpectations(timeout:1)
    }
    
    func testDeleteBoard() {
        let expect = expectation(description:String())
        storage.onDeleteBoard = { expect.fulfill() }
        repository.delete(Board())
        waitForExpectations(timeout:1)
    }
    
    func testDeleteBoardSavesAccount() {
        let expect = expectation(description:String())
        storage.onSaveAccount = { expect.fulfill() }
        repository.delete(Board())
        waitForExpectations(timeout:1)
    }
    
    func testRateSavesAccount() {
        let expect = expectation(description:String())
        storage.onSaveAccount = { expect.fulfill() }
        repository.account.rateTries = 2
        _ = repository.rate()
        waitForExpectations(timeout:1)
    }
    
    func testNotRateSavesAccount() {
        let expect = expectation(description:String())
        storage.onSaveAccount = { expect.fulfill() }
        _ = repository.rate()
        waitForExpectations(timeout:1)
    }
    
    func testAppearanceSavesAccount() {
        let expect = expectation(description:String())
        storage.onSaveAccount = {
            XCTAssertEqual(.dark, self.repository.account.appearance)
            expect.fulfill()
        }
        repository.change(.dark)
        waitForExpectations(timeout:1)
    }
    
    func testFontSavesAccount() {
        let expect = expectation(description:String())
        storage.onSaveAccount = {
            XCTAssertEqual(30, self.repository.account.font)
            expect.fulfill()
        }
        repository.change(30)
        waitForExpectations(timeout:1)
    }
}
