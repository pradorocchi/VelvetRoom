import Foundation

public class Card:Codable {
    public var position:(Int, Int) {
        get { return (positions.last!.column, positions.last!.index) }
        set {
            var new = Position()
            new.column = newValue.0
            new.index = newValue.1
            new.time = Date().timeIntervalSince1970
            positions.append(new)
        }
    }
    
    public var content:String {
        get { return contents.last?.value ?? String() }
        set {
            var new = Content()
            new.value = newValue
            new.time = Date().timeIntervalSince1970
            contents.append(new)
        }
    }
    
    public private(set) var positions = [Position]()
    public private(set) var contents = [Content]()
}
