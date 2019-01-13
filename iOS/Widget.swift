import Foundation

struct Widget:Codable {
    let name:String
    let columns:[Float]
    
    static var index:Int {
        get {
            return suite.integer(forKey:"index")
        }
        set {
            suite.set(newValue, forKey:"index")
            suite.synchronize()
        }
    }
    
    static var items:[Widget] {
        get {
            if let data = suite.data(forKey:"widget") {
                return try! JSONDecoder().decode([Widget].self, from:data)
            }
            return []
        }
        set {
            suite.set(try! JSONEncoder().encode(newValue), forKey:"widget")
            suite.synchronize()
        }
    }
    
    private static var suite:UserDefaults { return UserDefaults(suiteName:"group.VelvetRoom")! }
}
