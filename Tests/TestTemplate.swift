import XCTest
@testable import VelvetRoom

class TestTemplate:XCTestCase {
    private var repository:Repository!
    
    override func setUp() {
        repository = Repository()
        repository.storage = MockStorage()
        repository.synch = MockSynch()
        repository.group = MockGroup()
        repository.list = { _ in }
        repository.select = { _ in }
    }
    
    func testTriple() {
        repository.newBoard("test", template:.triple)
        XCTAssertEqual(3, repository.boards.first!.columns.count)
        XCTAssertEqual("Backlog", repository.boards.first!.columns[0].name)
        XCTAssertEqual("Active", repository.boards.first!.columns[1].name)
        XCTAssertEqual("Done", repository.boards.first!.columns[2].name)
    }
    
    func testDouble() {
        repository.newBoard("test", template:.double)
        XCTAssertEqual(2, repository.boards.first!.columns.count)
        XCTAssertEqual("Backlog", repository.boards.first!.columns[0].name)
        XCTAssertEqual("Done", repository.boards.first!.columns[1].name)
    }
    
    func testSingle() {
        repository.newBoard("test", template:.single)
        XCTAssertEqual(1, repository.boards.first!.columns.count)
        XCTAssertEqual("List", repository.boards.first!.columns[0].name)
    }
    
    func testNone() {
        repository.newBoard("test", template:.none)
        XCTAssertEqual(0, repository.boards.first!.columns.count)
    }
}
