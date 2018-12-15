import Foundation

class CloudSynch:Synch {
    var notification:(([String:TimeInterval]) -> Void)!
    var loaded:((Board) -> Void)!
    private var started = false
    
    func start() {
        DispatchQueue.global(qos:.background).async {
            self.register()
            self.fetch()
        }
    }
    
    func load(_ id:String) {

    }
    
    func save(_ account:[String:TimeInterval]) {

    }
    
    func save(_ board:Board) {

    }
    
    private func register() {
        
    }
    
    private func fetch() {

    }
}
