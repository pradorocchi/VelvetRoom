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
}
