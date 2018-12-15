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
}
