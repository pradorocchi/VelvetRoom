import Foundation

public class Card:Codable {
    public internal(set) var position = [Position]()
    public internal(set) var content = [Content]()
}
