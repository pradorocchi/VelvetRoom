import Foundation

public class Board:Codable {
    public var name = String()
    public internal(set) var id = String()
    public internal(set) var created = 0.0
    public internal(set) var updated = 0.0
    public internal(set) var columns = [Column]()
    public internal(set) var cards = [Card]()
}
