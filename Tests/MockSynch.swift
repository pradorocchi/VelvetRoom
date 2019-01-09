import Foundation
@testable import VelvetRoom

class MockSynch:Synch {
    var notification:(([String:TimeInterval]) -> Void)!
    var loaded:((Board) -> Void)!
    var error:((Error) -> Void)!
    var onStart:(() -> Void)?
    var onLoad:((String) -> Void)?
    var onSaveAccount:(([String:TimeInterval]) -> Void)?
    var onSaveBoard:((Board) -> Void)?
    var items:[String:Double]?
    var exception:Error?
    var board:Board?
    
    func start() {
        onStart?()
        if let exception = self.exception {
            error(exception)
        } else if let items = self.items {
            notification(items)
        }
    }
    
    func load(_ id:String) {
        onLoad?(id)
        if let exception = self.exception {
            error(exception)
        } else if let board = self.board {
            loaded(board)
        }
    }
    
    func save(_ account:[String:TimeInterval]) {
        onSaveAccount?(account)
        if let exception = self.exception {
            error(exception)
        }
    }
    
    func save(_ board:Board) {
        onSaveBoard?(board)
        if let exception = self.exception {
            error(exception)
        }
    }
}
