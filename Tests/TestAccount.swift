import XCTest
@testable import VelvetRoom

class TestAccount:XCTestCase {
    private var data:Data!
    private let json = """
{
"boards": ["lorem ipsum"],
"rates": [],
"rateTries": 1
}
"""
    override func setUp() {
        data = Data(json.utf8)
    }
    
    func testParsing() {
        let account = try! JSONDecoder().decode(Account.self, from:data)
        XCTAssertEqual("lorem ipsum", account.boards.first!)
        XCTAssertTrue(account.rates.isEmpty)
        XCTAssertEqual(1, account.rateTries)
    }
}
