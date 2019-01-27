import XCTest
@testable import VelvetRoom

class TestGroup:XCTestCase {
    private var repository:Repository!
    private var group:MockGroup!
    
    override func setUp() {
        group = MockGroup()
        repository = Repository()
        repository.storage = MockStorage()
        repository.synch = MockSynch()
        repository.group = group
        repository.list = { _ in }
        repository.select = { _ in }
    }
    
    func testLoadShares() {
        let expect = expectation(description:String())
        group.onShare = { expect.fulfill() }
        repository.load()
        waitForExpectations(timeout:1)
    }
    
    func testDeleteShares() {
        let expect = expectation(description:String())
        group.onShare = { expect.fulfill() }
        repository.delete(Board())
        waitForExpectations(timeout:1)
    }
    
    func testNewShares() {
        let expect = expectation(description:String())
        group.onShare = { expect.fulfill() }
        repository.newBoard(String(), template:.none)
        waitForExpectations(timeout:1)
    }
    
    func testSynchedShares() {
        let expect = expectation(description:String())
        group.onShare = { expect.fulfill() }
        let mock = MockSynch()
        repository.synch = mock
        repository.synchBoards()
        mock.loaded(Board())
        waitForExpectations(timeout:1)
    }
    
    func testUpdateShares() {
        let expect = expectation(description:String())
        repository.load()
        group.onShare = { expect.fulfill() }
        repository.wait = 0
        repository.scheduleUpdate(Board())
        waitForExpectations(timeout:1)
    }
}
