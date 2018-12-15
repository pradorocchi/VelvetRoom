import Foundation

public class Repository {
    var boards = [Board]()
    var account = Account()
    var storage:Storage = LocalStorage()
    var synch:Synch = CloudSynch()
    
    public init() { }
    
    public func load() {
        synch.notification = synchNotification
        synch.loaded = synchLoaded
        account = (try? storage.account()) ?? account
        loadBoards()
        synch.start()
    }
    
    private func loadBoards() {
        var boards = [Board]()
        account.boards.forEach { id in
            boards.append(storage.board(id))
        }
        self.boards = boards.sorted { $0.name.compare($1.name, options:.caseInsensitive) == .orderedAscending }
    }
    
    private func synchNotification(_ items:[String:TimeInterval]) {
        
    }
    
    private func synchLoaded(_ board:Board) {
        
    }
}
