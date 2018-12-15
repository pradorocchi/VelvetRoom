import Foundation

public struct Board:Codable {
    public internal(set) var id = String()
    public internal(set) var created = 0.0
    public internal(set) var synchstamp = 0.0
    public internal(set) var name = String()
    public internal(set) var columns = [Column]()
    public internal(set) var cards = [Card]()
}
