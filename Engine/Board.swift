import Foundation

public class Board:Clean, Codable {
    public var name = String() { didSet { name = clean(name) } }
    public internal(set) var id = String()
    public internal(set) var created = TimeInterval()
    public internal(set) var updated = TimeInterval()
    public internal(set) var columns = [Column]()
    public internal(set) var cards = [Card]()

    public var chart:[(String, Float)] {
        return cards.reduce(into:columns.map( { ($0.name, 0) } ), {
            $0[$1.column].1 += 1
        }).compactMap { $0.1 > 0 ? ($0.0, Float($0.1) / Float(cards.count)) : nil }
    }
}
