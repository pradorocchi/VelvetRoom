import Foundation

public class Board:Codable {
    public var name = String()
    public internal(set) var id = String()
    public internal(set) var created = 0.0
    public internal(set) var updated = 0.0
    public internal(set) var columns = [Column]()
    public internal(set) var cards = [Card]()
    
    public var progress:Float {
        guard !cards.isEmpty else { return 0 }
        return cards.reduce(into:0, { result, card in
            if card.column == columns.count - 1 {
                result += 1
            }
        }) / Float(cards.count)
    }
    
    public var chart:[Float] {
        guard !cards.isEmpty else { return [] }
        return cards.reduce(into:[Int](repeating:0, count:columns.count), { result, card in
            result[card.column] += 1
        }).map { Float($0) / Float(cards.count)  }
    }
}
