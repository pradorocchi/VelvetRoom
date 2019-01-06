import XCTest
@testable import VelvetRoom

class TestSharer:XCTestCase {
    func testGeneratesImage() {
        XCTAssertNotNil(Sharer.export(Board()))
    }
    
    func testImageSize() {
        let board = Board()
        let image = Sharer.export(board)
        XCTAssertLessThan(200, image.width)
        XCTAssertLessThan(200, image.height)
    }
}
