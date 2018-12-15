import Foundation

protocol Storage {
    func account() throws -> Account
    func board(_ id:String) -> Board
    func save(_ account:Account)
    func save(_ board:Board)
    func delete(_ board:Board)
}
