import Foundation

public class Repository {
    let json = """
{"name":"Learnings","columns":[{"name":"To do","cards":[{"content":"guard case"},{"content":"Switch nil"},{"content":"**App delegate**\n- willEncodeRestorable\n- didDecodeRestorable"},{"content":"State restoration"},{"content":"enum M {\n    case a(B)\n}\n\nswitch m {\n    case .a(let b):\n        break\n}"},{"content":"indirect enum A<B> {\n    case _c(D)\n}\n\nswitch a {\n    case let ._c(d): return d\n}"},{"content":"_IsDebug"},{"content":"Firebase cloud functions"},{"content":"Layer.contents = UIImage.decodedImage().cgimage"},{"content":"Pthread. Condition. Mutex"},{"content":"Assert()"},{"content":".random\n.shuffle"}]},{"name":"In progress","cards":[]},{"name":"Done","cards":[{"content":"CaseIterable"},{"content":"Date interval formatter.\nDate interval\nDateComponentsFormatter\nMeasurementFormatter\nPersonNameComponentsFormatter"},{"content":"Store\nDataStore"},{"content":"Default type for associated types"},{"content":"extension MyProtocol where Self:Any {"},{"content":"Storing data in the Keychain"},{"content":"try?"},{"content":"Keypaths"}]}],"syncstamp":560106546.16624796}
"""
    
    public var list:(([Board]) -> Void)!
    public var select:((Board) -> Void)!
    var boards = [Board]()
    var account = Account()
    var storage:Storage = LocalStorage()
    var synch:Synch = CloudSynch()
    var wait = 1.0
    private let timer = DispatchSource.makeTimerSource(queue:.global(qos:.background))
    
    public init() {
        timer.resume()
    }
    
    public func load() {
        account = (try? storage.account()) ?? account
        account.boards.forEach { id in boards.append(storage.board(id)) }
        listBoards()
        synchBoards()
    }
    
    public func load(_ id:String) {
        synch.load(id)
    }
    
    public func newBoard(_ name:String, template:Template) {
        var json = self.json.replacingOccurrences(of:"_", with:"").replacingOccurrences(of:"\n", with:"\\n")
        let catban = try! JSONDecoder().decode(Catban.self, from:Data(json.utf8))
        let board = Board()
        board.id = UUID().uuidString
        board.name = catban.name
        board.created = Date().timeIntervalSince1970
        catban.columns.enumerated().forEach { column in
            let newColumn = self.newColumn(board)
            newColumn.name = column.element.name
            column.element.cards.forEach { card in
                let newCard = try! self.newCard(board)
                newCard.content = card.content
                newCard.column = column.offset
            }
        }
        
        boards.append(board)
        account.boards.append(board.id)
        storage.save(account)
        update(board)
        
        listBoards()
        select(board)
        
        /*
        let board = Board()
        board.id = UUID().uuidString
        board.name = name
        board.created = Date().timeIntervalSince1970
        add(template, board:board)
        
        boards.append(board)
        account.boards.append(board.id)
        storage.save(account)
        update(board)
        
        listBoards()
        select(board)*/
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
        listBoards()
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
        synch.start()
    }
    
    private func update(_ board:Board) {
        board.updated = Date().timeIntervalSince1970
        storage.save(board)
        synch.save(board)
        synchUpdates()
    }
    
    private func listBoards() {
        list(boards.sorted { $0.name.compare($1.name, options:.caseInsensitive) == .orderedAscending })
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
        storage.save(board)
        storage.save(account)
        listBoards()
        select(board)
    }
    
    private func synchUpdates() {
        synch.save(boards.reduce(into:[:], { result, board in result[board.id] = board.updated } ))
    }
    
    private func column(_ name:String) -> Column {
        let column = Column()
        column.name = name
        column.created = Date().timeIntervalSince1970
        return column
    }
    
    private func move(_ card:Card, board:Board, column:Int, index:Int) {
        card.position(column:column, index:index)
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
