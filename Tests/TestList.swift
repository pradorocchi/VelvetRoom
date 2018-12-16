import XCTest
@testable import VelvetRoom

class TestList:XCTestCase {
    private var repository:Repository!
    
    override func setUp() {
        repository = Repository()
        repository.storage = MockStorage()
        repository.synch = MockSynch()
        repository.select = { _ in }
    }
    
    func testLoadLists() {
        let expect = expectation(description:String())
        repository.list = { _ in expect.fulfill() }
        repository.load()
        waitForExpectations(timeout:1)
    }
    
    func testNewBoardLists() {
        let expect = expectation(description:String())
        repository.list = { boards in
            XCTAssertEqual("lorem ipsum", boards.first!.name)
            expect.fulfill()
        }
        repository.newBoard("lorem ipsum")
        waitForExpectations(timeout:1)
    }
}
