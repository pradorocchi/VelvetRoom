import Foundation

struct Account:Codable {
    var boards = [String]()
    var rates = [Date]()
    var rateTries = Int()
}
