import Foundation

public class Column:Clean, Codable {
    public var name = String() { didSet { name = clean(name) } }
    public internal(set) var created = 0.0
}
