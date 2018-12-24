import Foundation

public class Card:Codable {
    public var column:Int {
        get { return positions.last!.column }
        set { position(column:newValue, index:index) }
    }
    
    public var index:Int {
        get { return positions.last!.index }
        set { position(column:column, index:newValue) }
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
    
    func position(column:Int, index:Int) {
        var new = Position()
        new.column = column
        new.index = index
        new.time = Date().timeIntervalSince1970
        positions.append(new)
    }
}
