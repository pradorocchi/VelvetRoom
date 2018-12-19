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
    
    func testRenameBoardSynchsBoard() {
        let expect = expectation(description:String())
        var board = Board()
        board.name = "hello world"
        repository.boards = [board]
        synch.onSaveBoard = { item in
            XCTAssertEqual("lorem ipsum", item.name)
            expect.fulfill()
        }
        repository.rename(board, name:"lorem ipsum")
        waitForExpectations(timeout:1)
    }
    
    func testRenameBoardSynchsAccount() {
        let expect = expectation(description:String())
        let time = Date().timeIntervalSince1970
        synch.onSaveAccount = { items in
            XCTAssertEqual("some", items.first!.key)
            XCTAssertLessThanOrEqual(time, items.first!.value)
            expect.fulfill()
        }
        var board = Board()
        board.id = "some"
        board.name = "hello world"
        repository.boards = [board]
        repository.rename(board, name:"lorem ipsum")
        waitForExpectations(timeout:1)
    }
}
