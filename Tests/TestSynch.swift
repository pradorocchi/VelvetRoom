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
}
