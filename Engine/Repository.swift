import Foundation

public class Repository {
    var storage:Storage = LocalStorage()
    var synch:Synch = CloudSynch()
    var account = Account()
    
    public init() { }
    
    public func load() {
        
    }
}
