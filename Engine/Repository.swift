import Foundation

public class Repository {
    static let queue = DispatchQueue(label:String(), qos:.background, target:.global(qos:.background))
    public var list:(([Board]) -> Void)!
    public var select:((Board) -> Void)!
    public var error:((Error) -> Void)!
    public internal(set) var account = Account()
    var boards = [Board]()
    var storage:Storage = LocalStorage()
    var synch:Synch = CloudSynch()
    var group:Group = WidgetGroup()
    var wait = 1.0
    private let timer = DispatchSource.makeTimerSource(queue:.global(qos:.background))
    
    public init() { }
    
    public func load() {
        timer.resume()
        account = (try? storage.account()) ?? account
        account.boards.forEach { id in boards.append(storage.board(id)) }
        boards.sort { $0.name.compare($1.name, options:.caseInsensitive) == .orderedAscending }
        list(boards)
        group.share(boards)
        synchBoards()
    }
    
    public func load(_ id:String) {
        synch.load(id)
    }
    
    public func newBoard(_ name:String, template:Template) {
        let board = Board()
        board.id = UUID().uuidString
        board.name = name
        board.created = Date().timeIntervalSince1970
        add(template, board:board)
        
        boards.append(board)
        boards.sort { $0.name.compare($1.name, options:.caseInsensitive) == .orderedAscending }
        account.boards.append(board.id)
        storage.save(account)
        update(board)
        
        list(boards)
        select(board)
    }
    
    public func newColumn(_ board:Board) -> Column {
        board.columns.append(column(String()))
        return board.columns.last!
    }
    
    public func newCard(_ board:Board) throws -> Card {
        if board.columns.isEmpty {
            throw Exception.noColumns
        }
        let card = Card()
        board.cards.append(card)
        move(card, board:board, column:0, index:0)
        return card
    }
    
    public func move(_ card:Card, board:Board, column:Column, after:Card? = nil) {
        board.cards.forEach { item in
            if item !== card {
                if item.column == card.column {
                    if item.index >= card.index {
                        item.index -= 1
                    }
                }
            }
        }
        var index = 0
        if let after = board.cards.first(where: { $0 === after } )?.index {
            index = after + 1
        }
        move(card, board:board, column:board.columns.firstIndex { $0 === column }!, index:index)
    }
    
    public func move(_ column:Column, board:Board, after:Column? = nil) {
        let old = board.columns.firstIndex { $0 === column }!
        board.columns.remove(at:old)
        var index = 0
        if let after = after {
            index = board.columns.firstIndex { $0 === after }! + 1
        }
        board.columns.insert(column, at:index)
        board.cards.forEach {
            if $0.column == old {
                $0.column = index
            } else {
                if $0.column > old {
                    $0.column -= 1
                }
                if $0.column >= index {
                    $0.column += 1
                }
            }
        }
    }
    
    public func delete(_ board:Board) {
        boards.removeAll { $0 === board }
        account.boards.removeAll { $0 == board.id }
        storage.save(account)
        storage.delete(board)
        synchUpdates()
        list(boards)
    }
    
    public func delete(_ column:Column, board:Board) {
        let index = board.columns.firstIndex { $0 === column }!
        board.columns.remove(at:index)
        board.cards = board.cards.compactMap {
            guard $0.column != index else { return nil }
            if $0.column > index {
                $0.column -= 1
            }
            return $0
        }
    }
    
    public func delete(_ card:Card, board:Board) {
        board.cards = board.cards.compactMap {
            guard $0 !== card else { return nil }
            if $0.column == card.column {
                if $0.index >= card.index {
                    $0.index -= 1
                }
            }
            return $0
        }
    }
    
    public func change(_ appearance:Appearance) {
        account.appearance = appearance
        storage.save(account)
        list(boards)
    }
    
    public func change(_ font:Int) {
        account.font = font
        storage.save(account)
        list(boards)
    }
    
    public func scheduleUpdate(_ board:Board) {
        timer.setEventHandler {
            self.update(board)
            self.timer.setEventHandler(handler:nil)
        }
        timer.schedule(deadline:.now() + wait)
    }
    
    public func fireSchedule() {
        timer.schedule(deadline:.now())
    }
    
    public func rate() -> Bool {
        var rating = false
        account.rateTries += 1
        if (account.rateTries % 3) == 0 {
            if let last = account.rates.last,
                let months = Calendar.current.dateComponents([.month], from:last, to:Date()).month {
                rating = months < -1
            } else {
                rating = true
            }
        }
        if rating {
            account.rates.append(Date())
        }
        storage.save(account)
        return rating
    }
    
    func synchBoards() {
        synch.notification = synchNotification
        synch.loaded = synchLoaded
        synch.error = error
        synch.start()
    }
    
    private func update(_ board:Board) {
        board.updated = Date().timeIntervalSince1970
        storage.save(board)
        synch.save(board)
        synchUpdates()
    }
    
    private func add(_ template:Template, board:Board) {
        switch template {
        case .triple: board.columns = [column("Backlog"), column("Active"), column("Done")]
        case .double: board.columns = [column("Backlog"), column("Done")]
        case .single: board.columns = [column("List")]
        default: break
        }
    }
    
    private func synchNotification(_ items:[String:TimeInterval]) {
        items.forEach { item in
            if let current = boards.first(where: { $0.id == item.key } ) {
                if current.updated < item.value {
                    synch.load(item.key)
                }
            } else {
                synch.load(item.key)
            }
        }
    }
    
    private func synchLoaded(_ board:Board) {
        if !account.boards.contains(board.id) {
            account.boards.append(board.id)
        }
        boards.removeAll { $0.id == board.id }
        boards.append(board)
        boards.sort { $0.name.compare($1.name, options:.caseInsensitive) == .orderedAscending }
        storage.save(board)
        storage.save(account)
        list(boards)
        group.share(boards)
    }
    
    private func synchUpdates() {
        synch.save(boards.reduce(into:[:], { result, board in result[board.id] = board.updated } ))
        group.share(boards)
    }
    
    private func column(_ name:String) -> Column {
        let column = Column()
        column.name = name
        column.created = Date().timeIntervalSince1970
        return column
    }
    
    private func move(_ card:Card, board:Board, column:Int, index:Int) {
        card.index = index
        card.column = column
        board.cards.forEach { item in
            if item !== card {
                if item.column == column {
                    if item.index >= index {
                        item.index += 1
                    }
                }
            }
        }
    }
}
