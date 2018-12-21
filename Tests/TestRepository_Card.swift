import XCTest
@testable import VelvetRoom

class TestRepository_Card:XCTestCase {
    private var repository:Repository!
    
    override func setUp() {
        repository = Repository()
        repository.storage = MockStorage()
        repository.synch = MockSynch()
        repository.list = { _ in }
        repository.select = { _ in }
    }
    
    func testNewCardNoColumnThrows() {
        XCTAssertThrowsError(try repository.newCard(Board()))
    }
    
    func testNewCard() {
        let time = Date().timeIntervalSince1970
        let board = Board()
        board.columns = [Column()]
        repository.boards = [board]
        var card:Card!
        XCTAssertNoThrow(try card = repository.newCard(board))
        XCTAssertTrue(card === repository.boards.first!.cards.first!)
        XCTAssertLessThan(time, card.position.first!.time)
        XCTAssertEqual(0, card.position.first!.index)
        XCTAssertEqual(0, card.position.first!.column)
    }
    
    func testUpdateContent() {
        let time = Date().timeIntervalSince1970
        let card = Card()
        repository.update(Board(), card:card, content:"hello world")
        XCTAssertEqual("hello world", card.content.last!.value)
        XCTAssertLessThan(time, card.content.last!.time)
        repository.update(Board(), card:card, content:"lorem ipsum")
        XCTAssertEqual("lorem ipsum", card.content.last!.value)
        XCTAssertLessThan(card.content.first!.time, card.content.last!.time)
    }
}
