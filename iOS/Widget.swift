import Foundation

struct Widget:Codable {
    let id:String
    let name:String
    let columns:[Float]
    
    static func load() -> [Widget]? {
        if let data = UserDefaults(suiteName:"group.VelvetRoom")!.data(forKey:"widget") {
            return try! JSONDecoder().decode([Widget].self, from:data)
        }
        return nil
    }
    
    static func store(_ items:[Widget]) {
        UserDefaults(suiteName:"group.VelvetRoom")!.set(try! JSONEncoder().encode(items), forKey:"widget")
        UserDefaults(suiteName:"group.VelvetRoom")!.synchronize()
    }
}
