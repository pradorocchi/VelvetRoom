import Foundation

public class Card:Clean, Codable {
    public var column:Int {
        get { return positions.last!.column }
        set {
            guard positions.isEmpty || newValue != positions.last!.column else { return }
            positions.append(Position(column:newValue, time:Date().timeIntervalSince1970))
        }
    }
    
    public var content:String {
        get { return contents.last?.value ?? String() }
        set {
            let newValue = clean(newValue)
            guard newValue != contents.last?.value else { return }
            var new = Content()
            new.value = newValue
            new.time = Date().timeIntervalSince1970
            contents.append(new)
        }
    }
    
    public private(set) var contents = [Content]()
    public private(set) var positions = [Position]()
    public var index = Int()
}
