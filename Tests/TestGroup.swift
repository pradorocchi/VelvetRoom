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
    
    func testNewColumnShares() {
        let expect = expectation(description:String())
        group.onShare = { expect.fulfill() }
        _ = repository.newColumn(Board())
        waitForExpectations(timeout:1)
    }
    
    func testNewCardShares() {
        let expect = expectation(description:String())
        group.onShare = { expect.fulfill() }
        let board = Board()
        board.columns = [Column()]
        _ = try! repository.newCard(board)
        waitForExpectations(timeout:1)
    }
    
    func testMoveCardShares() {
        let expect = expectation(description:String())
        group.onShare = { expect.fulfill() }
        let board = Board()
        board.columns = [Column()]
        board.cards = [Card()]
        repository.move(board.cards.first!, board:board, column:board.columns.first!)
        waitForExpectations(timeout:1)
    }
    
    func testMoveColumnShares() {
        let expect = expectation(description:String())
        group.onShare = { expect.fulfill() }
        let board = Board()
        board.columns = [Column()]
        repository.move(board.columns.first!, board:board)
        waitForExpectations(timeout:1)
    }
}
