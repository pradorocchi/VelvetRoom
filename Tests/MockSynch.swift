import Foundation
@testable import VelvetRoom

class MockSynch:Synch {
    var notification:(([String:TimeInterval]) -> Void)!
    var loaded:((Board) -> Void)!
    var onStart:(() -> Void)?
    var onLoad:((String) -> Void)?
    var onSaveAccount:(([String:TimeInterval]) -> Void)?
    var onSaveBoard:((Board) -> Void)?
    var items:[String:Double]?
    var board:Board?
    
    func start() {
        if let items = self.items {
            notification(items)
        }
        onStart?()
    }
    
    func load(_ id:String) {
        onLoad?(id)
        if let board = self.board {
            loaded(board)
        }
    }
    
    func save(_ account:[String:TimeInterval]) {
        onSaveAccount?(account)
    }
    
    func save(_ board:Board) {
        onSaveBoard?(board)
    }
}
