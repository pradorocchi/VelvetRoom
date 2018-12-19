import Foundation
@testable import VelvetRoom

class MockStorage:Storage {
    var onAccount:(() -> Void)?
    var onBoard:((String) -> Void)?
    var onSaveAccount:(() -> Void)?
    var onSaveBoard:((Board) -> Void)?
    var onDeleteBoard:(() -> Void)?
    var returnAccount = Account()
    var returnBoard = Board()
    var error:Error?
    
    required init() { }
    
    func account() throws -> Account {
        onAccount?()
        if let error = self.error {
            throw error
        } else {
            return returnAccount
        }
    }
    
    func board(_ id:String) -> Board {
        onBoard?(id)
        return returnBoard
    }
    
    func save(_ account:Account) {
        onSaveAccount?()
    }
    
    func save(_ board:Board) {
        onSaveBoard?(board)
    }
    
    func delete(_ board:Board) {
        onDeleteBoard?()
    }
}
