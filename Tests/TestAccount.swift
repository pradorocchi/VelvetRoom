import XCTest
@testable import VelvetRoom

class TestAccount:XCTestCase {
    func testParsing() {
        let json = """
{
"boards": ["lorem ipsum"],
"rates": [],
"rateTries": 1,
"appearance": 1,
"font": 30
}
"""
        let account = try! JSONDecoder().decode(Account.self, from:Data(json.utf8))
        XCTAssertEqual("lorem ipsum", account.boards.first!)
        XCTAssertTrue(account.rates.isEmpty)
        XCTAssertEqual(1, account.rateTries)
        XCTAssertEqual(30, account.font)
        XCTAssertEqual(.light, account.appearance)
    }
    
    func testSerialise() {
        let json = """
{"boards":["hello world"],"rates":[-978307200],"rateTries":10,"font":30,"appearance":0}
"""
        var account = Account()
        account.font = 30
        account.appearance = .dark
        account.rates = [Date(timeIntervalSince1970:0)]
        account.rateTries = 10
        account.boards = ["hello world"]
        XCTAssertEqual(json, String(decoding:try! JSONEncoder().encode(account), as:UTF8.self))
    }
}
