import Foundation
import VelvetRoom

class Presenter {
    var list:(([Board]) -> Void)!
    var select:((Board) -> Void)!
    private let repository = Repository()
    
    init() {
//        repository.list = { boards in DispatchQueue.main.async { self.list(boards) } }
//        repository.select = { board in DispatchQueue.main.async { self.select(board) } }
    }
    
    func load() {
        DispatchQueue.global(qos:.background).async { self.repository.load() }
    }
    
    func newBoard() {
        
    }
}
