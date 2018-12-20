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
            fireSchedule()
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
    
    func update(_ board:Board) {
        DispatchQueue.global(qos:.background).async { self.repository.update(board) }
    }
    
    func scheduleUpdate(_ board:Board) {
        DispatchQueue.global(qos:.background).async { self.repository.scheduleUpdate(board) }
    }
    
    func fireSchedule() {
        repository.fireSchedule()
    }
}
