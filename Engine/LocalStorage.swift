import Foundation

class LocalStorage:Storage {
    private static let url = FileManager.default.urls(for:.documentDirectory, in:.userDomainMask)[0]
    private let accountUrl = LocalStorage.url("Account")
    
    class func url(_ id:String) -> URL { return url.appendingPathComponent(id + ".velvet") }
    
    func account() throws -> Account {
        avoidBackup()
        return try JSONDecoder().decode(Account.self, from:try Data(contentsOf:accountUrl))
    }
    
    func board(_ id:String) -> Board {
        return try! JSONDecoder().decode(Board.self, from:try Data(contentsOf:LocalStorage.url(id)))
    }
    
    func save(_ account:Account) {
        DispatchQueue.global(qos:.background).async {
            try! (try! JSONEncoder().encode(account)).write(to:self.accountUrl)
        }
    }
    
    func save(_ board:Board) {
        DispatchQueue.global(qos:.background).async {
            try! (try! JSONEncoder().encode(board)).write(to:LocalStorage.url(board.id))
        }
    }
    
    func delete(_ board:Board) {
        DispatchQueue.global(qos:.background).async {
            if FileManager.default.fileExists(atPath:LocalStorage.url(board.id).path) {
                try! FileManager.default.removeItem(at:LocalStorage.url(board.id))
            }
        }
    }
    
    private func avoidBackup() {
        var url = LocalStorage.url
        var resources = URLResourceValues()
        resources.isExcludedFromBackup = true
        try! url.setResourceValues(resources)
    }
}
