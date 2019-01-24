import Foundation

public struct Account:Codable {
    public var appearance = Appearance.system
    public var font = 14
    var boards = [String]()
    var rates = [Date]()
    var rateTries = 0
    
    public init() { }
    
    public init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy:Keys.self)
        boards = try values.decode([String].self, forKey:.boards)
        rates = try values.decode([Date].self, forKey:.rates)
        rateTries = try values.decode(Int.self, forKey:.rateTries)
        if let appearance = try? values.decode(Appearance.self, forKey:.appearance) {
            self.appearance = appearance
        }
        if let font = try? values.decode(Int.self, forKey:.font) {
            self.font = font
        }
    }
    
    public func encode(to encoder:Encoder) throws {
        var container = encoder.container(keyedBy:Keys.self)
        try container.encode(boards, forKey:.boards)
        try container.encode(rates, forKey:.rates)
        try container.encode(rateTries, forKey:.rateTries)
        try container.encode(appearance, forKey:.appearance)
        try container.encode(font, forKey:.font)
    }
    
    private enum Keys:CodingKey {
        case boards
        case rates
        case appearance
        case rateTries
        case font
    }
}
