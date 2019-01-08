import Foundation

struct Catban:Decodable {
    var columns = [ColumnCatban]()
}

struct ColumnCatban:Decodable {
    var name = String()
    var cards = [CardCatban]()
}

struct CardCatban:Decodable {
    var content = String()
}
