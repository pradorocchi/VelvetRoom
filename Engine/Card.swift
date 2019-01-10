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
    
    public init() { }
    
    required public init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy:Keys.self)
        contents = try values.decode([Content].self, forKey:.contents)
        if let positions = try? values.decode([Position].self, forKey:.positions),
            let index = try? values.decode(Int.self, forKey:.index) {
            self.positions = positions
            self.index = index
        } else {
            let oldPositions = try values.decode([OldPosition].self, forKey:.positions)
            if !oldPositions.isEmpty {
                index = oldPositions.last!.index
                column = oldPositions.last!.column
            }
        }
    }
    
    public func encode(to encoder:Encoder) throws {
        var container = encoder.container(keyedBy:Keys.self)
        try container.encode(contents, forKey:.contents)
        try container.encode(positions, forKey:.positions)
        try container.encode(index, forKey:.index)
    }
    
    private enum Keys:CodingKey {
        case contents
        case positions
        case index
    }
}
