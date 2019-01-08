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
    
    func testRead() {
        let board = Board()
        board.id = UUID().uuidString
        XCTAssertEqual(board.id, try! Sharer.load(Sharer.export(board)))
    }
    
    func testInvalidImage() {
        let image = NSImage(size:NSSize(width:100, height:100))
        image.lockFocus()
        NSColor.white.drawSwatch(in:NSRect(x:0, y:0, width:100, height:100))
        image.unlockFocus()
        XCTAssertThrowsError(try Sharer.load(image.cgImage(forProposedRect:nil, context:nil, hints:nil)!))
    }
    
    func testInvalidQrCode() {
        let board = Board()
        board.id = "hello world"
        XCTAssertThrowsError(try Sharer.load(Sharer.export(board)))
    }
}
