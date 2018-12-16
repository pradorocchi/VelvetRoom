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
        storage.onSaveBoard = { expect.fulfill() }
        repository.newBoard(String(), template:.none)
        waitForExpectations(timeout:1)
    }
    
    func testNewBoardSavesAccount() {
        let expect = expectation(description:String())
        storage.onSaveAccount = { expect.fulfill() }
        repository.newBoard(String(), template:.none)
        waitForExpectations(timeout:1)
    }
}
