import Foundation
import VelvetRoom

class Presenter {
    weak var selected:BoardView! {
        willSet {
            if let previous = selected {
                previous.selected = false
            }
        }
        didSet {
            selected.selected = true
//            saveIfNeeded()
        }
    }
    
    var list:(([Board]) -> Void)!
    var select:((Board) -> Void)!
    private let repository = Repository()
    
    init() {
        repository.list = { boards in DispatchQueue.main.async { self.list(boards) } }
        repository.select = { board in DispatchQueue.main.async { self.select(board) } }
    }
    
    func load() {
        DispatchQueue.global(qos:.background).async { self.repository.load() }
    }
    
    func newBoard(_ name:String, template:Template) {
        DispatchQueue.global(qos:.background).async { self.repository.newBoard(name, template:template) }
    }
}
