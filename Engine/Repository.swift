import Foundation

public class Repository {
    public var list:(([Board]) -> Void)!
    public var select:((Board) -> Void)!
    var boards = [Board]()
    var account = Account()
    var storage:Storage = LocalStorage()
    var synch:Synch = CloudSynch()
    var wait = 10.0
    private let timer = DispatchSource.makeTimerSource(queue:.global(qos:.background))
    
    public init() {
        timer.resume()
    }
    
    public func load() {
        account = (try? storage.account()) ?? account
        account.boards.forEach { id in boards.append(storage.board(id)) }
        synchBoards()
        listBoards()
    }
    
    public func newBoard(_ name:String, template:Template) {
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
        select(board)
    }
    
    public func scheduleUpdate(_ board:Board) {
        timer.setEventHandler { self.update(board) }
        timer.schedule(deadline:.now() + wait)
    }
    
    public func fireSchedule() {
        timer.schedule(deadline:.now())
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
    
    private func synchBoards() {
        synch.notification = synchNotification
        synch.loaded = synchLoaded
        synch.start()
    }
    
    private func synchNotification(_ items:[String:TimeInterval]) {
        
    }
    
    private func synchLoaded(_ board:Board) {
        
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
}
