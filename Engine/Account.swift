import Foundation

public struct Account:Codable {
    public var appearance = Appearance.system
    public var font = 14
    var boards = [String]()
    var rates = [Date]()
    var rateTries = 0
}
