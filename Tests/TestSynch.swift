import XCTest
@testable import VelvetRoom

class TestSynch:XCTestCase {
    private var repository:Repository!
    private var synch:MockSynch!
    private var storage:MockStorage!
    
    override func setUp() {
        synch = MockSynch()
        storage = MockStorage()
        repository = Repository()
        repository.storage = storage
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
        repository.load()
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
        repository.load()
        repository.wait = 0
        repository.boards = [board]
        repository.scheduleUpdate(board)
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
    
    func testUpdateItems() {
        let expectBoard = expectation(description:String())
        let expectAccount = expectation(description:String())
        let expectUpdate = expectation(description:String())
        synch.items = ["a":1]
        synch.board = Board()
        synch.board!.id = "a"
        synch.onLoad = { id in XCTAssertEqual("a", id) }
        storage.onSaveBoard = { _ in expectBoard.fulfill() }
        storage.onSaveAccount = {
            XCTAssertEqual("a", self.repository.account.boards.first)
            expectAccount.fulfill()
        }
        repository.list = {
            XCTAssertEqual(1, $0.count)
            expectUpdate.fulfill()
        }
        repository.synchBoards()
        waitForExpectations(timeout:1)
    }
    
    func testReplacesIfExist() {
        let syncA = Board()
        syncA.id = "a"
        syncA.updated = 5
        let a = Board()
        a.id = "a"
        repository.account.boards.append(a.id)
        repository.boards.append(a)
        synch.items = [syncA.id:syncA.updated]
        synch.board = syncA
        repository.synchBoards()
        XCTAssertEqual(1, repository.account.boards.count)
        XCTAssertEqual(1, repository.boards.count)
        XCTAssertEqual("a", repository.account.boards.first!)
        XCTAssertEqual("a", repository.boards.first!.id)
        XCTAssertEqual(5, repository.boards.first!.updated)
    }
    
    func testNotUpdatingIfCurrentIsSame() {
        let syncA = Board()
        syncA.id = "a"
        syncA.updated = 5
        syncA.name = "lorem ipsum"
        let a = Board()
        a.id = "a"
        a.updated = 5
        a.name = "hello world"
        repository.account.boards.append(a.id)
        repository.boards.append(a)
        synch.items = [syncA.id:syncA.updated]
        synch.board = syncA
        repository.synchBoards()
        XCTAssertEqual(1, repository.account.boards.count)
        XCTAssertEqual(1, repository.boards.count)
        XCTAssertEqual("hello world", repository.boards.first!.name)
    }
    
    func testNotUpdatingIfCurrentIsNewer() {
        let syncA = Board()
        syncA.id = "a"
        syncA.updated = 5
        syncA.name = "lorem ipsum"
        let a = Board()
        a.id = "a"
        a.updated = 7
        a.name = "hello world"
        repository.account.boards.append(a.id)
        repository.boards.append(a)
        synch.items = [syncA.id:syncA.updated]
        synch.board = syncA
        repository.synchBoards()
        XCTAssertEqual(1, repository.account.boards.count)
        XCTAssertEqual(1, repository.boards.count)
        XCTAssertEqual("hello world", repository.boards.first!.name)
    }
    
    func testNotRemovingIfCloudFails() {
        let syncA = Board()
        syncA.id = "a"
        syncA.updated = 5
        let a = Board()
        a.name = "hello world"
        a.id = "a"
        a.updated = 1
        repository.account.boards.append(a.id)
        repository.boards.append(a)
        synch.items = [syncA.id:syncA.updated]
        repository.synchBoards()
        XCTAssertEqual(1, repository.account.boards.count)
        XCTAssertEqual(1, repository.boards.count)
        XCTAssertEqual("a", repository.account.boards.first!)
        XCTAssertEqual("a", repository.boards.first!.id)
        XCTAssertEqual(1, repository.boards.first!.updated)
        XCTAssertEqual("hello world", repository.boards.first!.name)
    }
    
    func testLoadImported() {
        let expect = expectation(description:String())
        synch.onLoad = { id in
            XCTAssertEqual("hello world", id)
            expect.fulfill()
        }
        repository.load("hello world")
        waitForExpectations(timeout:1)
    }
    
    func testNotifiesRepositoryOnError() {
        let expect = expectation(description:String())
        synch.exception = Exception.unknown
        repository.error = { _ in expect.fulfill() }
        repository.synchBoards()
        waitForExpectations(timeout:1)
    }
}
