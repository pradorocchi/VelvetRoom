import Foundation

public struct Widget {
    public static var group = String() { didSet { suite = UserDefaults(suiteName:group)! } }
    private static var suite = UserDefaults.standard
    
    static var index:Int {
        get {
            return suite.integer(forKey:"index")
        } set {
            suite.set(newValue, forKey:"index")
            suite.synchronize()
        }
    }
    
    static var items:[String:[WidgetItem]] {
        get {
            if let data = suite.data(forKey:"widget") {
                return try! JSONDecoder().decode([String:[WidgetItem]].self, from:data)
            }
            return [:]
        } set {
            suite.set(try! JSONEncoder().encode(newValue), forKey:"widget")
            suite.synchronize()
        }
    }
}
