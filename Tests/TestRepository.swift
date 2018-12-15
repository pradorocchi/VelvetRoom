import XCTest
@testable import VelvetRoom

class TestRepository:XCTestCase {
    private var repository:Repository!

    override func setUp() {
        repository = Repository()
        repository.storage = MockStorage()
        repository.synch = MockSynch()
    }
    
    func testNewBoard() {
        
    }
}
