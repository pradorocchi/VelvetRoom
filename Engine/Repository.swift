import Foundation

public class Repository {
    public var list:(([Board]) -> Void)!
    public var select:((Board) -> Void)!
    var boards = [Board]()
    var account = Account()
    var storage:Storage = LocalStorage()
    var synch:Synch = CloudSynch()
    
    public init() { }
    
    public func load() {
        account = (try? storage.account()) ?? account
        loadBoards()
        synchBoards()
        list(boards)
    }
    
    public func newBoard(_ name:String, template:Template) {
        var board = Board()
        board.id = UUID().uuidString
        board.name = name
        board.created = Date().timeIntervalSince1970
        board.updated = board.created
        
        switch template {
        case .triple: board.columns = [column("Backlog"), column("Active"), column("Done")]
        case .double: board.columns = [column("Backlog"), column("Done")]
        case .single: board.columns = [column("List")]
        default: break
        }
        
        boards.append(board)
        sortBoards()
        account.boards.append(board.id)
        storage.save(board)
        storage.save(account)
        synch.save(board)
        synchUpdates()
        
        list(boards)
        select(board)
    }
    
    public func rename(_ board:Board, name:String) {
        var board = board
        board.name = name
        board.updated = Date().timeIntervalSince1970
        boards[boards.firstIndex(where: { $0.id == board.id } )!] = board
        storage.save(board)
        synch.save(board)
        synchUpdates()
    }
    
    private func loadBoards() {
        account.boards.forEach { id in boards.append(storage.board(id)) }
        sortBoards()
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
    
    private func sortBoards() {
        boards.sort { $0.name.compare($1.name, options:.caseInsensitive) == .orderedAscending }
    }
    
    private func synchUpdates() {
        synch.save(boards.reduce(into:[:], { result, board in result[board.id] = board.updated } ))
    }
    
    private func column(_ name:String) -> Column {
        var column = Column()
        column.name = name
        column.created = Date().timeIntervalSince1970
        return column
    }
}
