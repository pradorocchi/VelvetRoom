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
    
    func newColumn() -> Column { return repository.newColumn(selected.board) }
    func newCard() -> Card { return try! repository.newCard(selected.board) }
    
    func move(_ card:Card, column:Column, after:Card?) {
        repository.move(card, board:selected.board, column:column, after:after)
    }
    
    func move(_ column:Column, after:Column?) {
        repository.move(column, board:selected.board, after:after)
    }
    
    func scheduleUpdate() {
        DispatchQueue.global(qos:.background).async { self.repository.scheduleUpdate(self.selected.board) }
    }
    
    func fireSchedule() {
        repository.fireSchedule()
    }
}
