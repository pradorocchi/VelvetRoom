import XCTest
@testable import VelvetRoom

class TestRepository_Account:XCTestCase {
    private var repository:Repository!
    
    override func setUp() {
        repository = Repository()
        repository.storage = MockStorage()
        repository.synch = MockSynch()
        repository.group = MockGroup()
        repository.list = { _ in }
        repository.select = { _ in }
    }
    
    func testChangeFontLists() {
        let expect = expectation(description:String())
        repository.list = { _ in expect.fulfill() }
        repository.change(0)
        waitForExpectations(timeout:1)
    }
    
    func testChangeAppearanceLists() {
        let expect = expectation(description:String())
        repository.list = { _ in expect.fulfill() }
        repository.change(.dark)
        waitForExpectations(timeout:1)
    }
}
