import XCTest
@testable import VelvetRoom

class TestRating:XCTestCase {
    private var repository:Repository!
    
    override func setUp() {
        repository = Repository()
        repository.storage = MockStorage()
        repository.synch = MockSynch()
        repository.group = MockGroup()
        repository.list = { _ in }
        repository.select = { _ in }
    }
    
    func testNoRateAtFirst() {
        XCTAssertFalse(repository.rate())
    }
    
    func testRateIfMoreContinuesModulesThree() {
        repository.account.rateTries = 2
        XCTAssertTrue(repository.rate())
        XCTAssertFalse(repository.account.rates.isEmpty)
    }
    
    func testNoRateIfRatedRecently() {
        repository.account.rateTries = 2
        repository.account.rates = [Date()]
        XCTAssertFalse(repository.rate())
    }
    
    func testRateIfRatedMoreThan2MonthsAgo() {
        var components = DateComponents()
        components.month = 3
        let date = Calendar.current.date(byAdding:components, to:Date())!
        repository.account.rateTries = 2
        repository.account.rates = [date]
        XCTAssertEqual(date, repository.account.rates.last!)
        XCTAssertTrue(repository.rate())
        XCTAssertNotEqual(date, repository.account.rates.last!)
    }
}
