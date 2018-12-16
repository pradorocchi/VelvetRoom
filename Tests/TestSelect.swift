import XCTest
@testable import VelvetRoom

class TestSelect:XCTestCase {
    private var repository:Repository!
    
    override func setUp() {
        repository = Repository()
        repository.storage = MockStorage()
        repository.synch = MockSynch()
        repository.list = { _ in }
    }
    
    func testNewBoardSelects() {
        let expect = expectation(description:String())
        repository.select = { board in
            XCTAssertEqual("lorem ipsum", board.name)
            expect.fulfill()
        }
        repository.newBoard("lorem ipsum")
        waitForExpectations(timeout:1)
    }
}
