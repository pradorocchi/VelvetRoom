import XCTest
@testable import VelvetRoom

class TestSynch:XCTestCase {
    private var repository:Repository!
    private var synch:MockSynch!
    
    override func setUp() {
        synch = MockSynch()
        repository = Repository()
        repository.storage = MockStorage()
        repository.synch = synch
        repository.list = { _ in }
        repository.select = { _ in }
    }
    
    func testLoad() {
        let expect = expectation(description:String())
        synch.onStart = {
            XCTAssertNotNil(self.synch.notification)
            XCTAssertNotNil(self.synch.loaded)
            expect.fulfill()
        }
        repository.load()
        waitForExpectations(timeout:1)
    }
    
    func testNewBoardSynchsBoard() {
        let expect = expectation(description:String())
        synch.onSaveBoard = { item in
            XCTAssertEqual(self.repository.boards.first!.id, item.id)
            expect.fulfill()
        }
        repository.newBoard(String(), template:.none)
        waitForExpectations(timeout:1)
    }
    
    func testNewBoardSynchsAccount() {
        let expect = expectation(description:String())
        synch.onSaveAccount = { items in
            XCTAssertEqual(self.repository.boards.first!.id, items.first!.key)
            XCTAssertEqual(self.repository.boards.first!.updated, items.first!.value)
            expect.fulfill()
        }
        repository.newBoard(String(), template:.none)
        waitForExpectations(timeout:1)
    }
    
    func testUpdateBoardSynchsBoard() {
        let expect = expectation(description:String())
        synch.onSaveBoard = { item in
            XCTAssertEqual("lorem ipsum", item.name)
            expect.fulfill()
        }
        let board = Board()
        board.name = "hello world"
        repository.wait = 0
        board.name = "lorem ipsum"
        repository.scheduleUpdate(board)
        waitForExpectations(timeout:1)
    }
    
    func testUpdateBoardSynchsAccount() {
        let expect = expectation(description:String())
        let time = Date().timeIntervalSince1970
        synch.onSaveAccount = { items in
            XCTAssertEqual("some", items.first!.key)
            XCTAssertLessThan(time, items.first!.value)
            expect.fulfill()
        }
        let board = Board()
        board.id = "some"
        repository.wait = 0
        repository.boards = [board]
        repository.scheduleUpdate(board)
        waitForExpectations(timeout:1)
    }
    
    func testNewCardSynchsBoard() {
        let expect = expectation(description:String())
        synch.onSaveBoard = { item in
            XCTAssertFalse(item.cards.isEmpty)
            expect.fulfill()
        }
        let board = Board()
        board.columns = [Column()]
        repository.wait = 0
        _ = try! repository.newCard(board)
        waitForExpectations(timeout:1)
    }
    
    func testNewCardSynchsAccount() {
        let expect = expectation(description:String())
        let time = Date().timeIntervalSince1970
        synch.onSaveAccount = { items in
            XCTAssertEqual("some", items.first!.key)
            XCTAssertLessThan(time, items.first!.value)
            expect.fulfill()
        }
        let board = Board()
        board.id = "some"
        board.columns = [Column()]
        repository.wait = 0
        repository.boards = [board]
        _ = try! repository.newCard(board)
        waitForExpectations(timeout:1)
    }
    
    func testNewColumnSynchsBoard() {
        let expect = expectation(description:String())
        synch.onSaveBoard = { item in
            XCTAssertFalse(item.columns.isEmpty)
            expect.fulfill()
        }
        let board = Board()
        repository.wait = 0
        _ = repository.newColumn(board)
        waitForExpectations(timeout:1)
    }
    
    func testNewColumnSynchsAccount() {
        let expect = expectation(description:String())
        let time = Date().timeIntervalSince1970
        synch.onSaveAccount = { items in
            XCTAssertEqual("some", items.first!.key)
            XCTAssertLessThan(time, items.first!.value)
            expect.fulfill()
        }
        let board = Board()
        board.id = "some"
        repository.wait = 0
        repository.boards = [board]
        _ = repository.newColumn(board)
        waitForExpectations(timeout:1)
    }
    
    func testDeleteBoardSynchsAccount() {
        let expect = expectation(description:String())
        synch.onSaveAccount = { items in
            XCTAssertTrue(items.isEmpty)
            expect.fulfill()
        }
        let board = Board()
        board.id = "some"
        repository.wait = 0
        repository.boards = [board]
        repository.delete(board)
        waitForExpectations(timeout:1)
    }
}
