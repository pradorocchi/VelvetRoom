import Foundation

protocol Synch {
    var notification:(([String:TimeInterval]) -> Void)! { get set }
    var loaded:((Board) -> Void)! { get set }
    var error:((Error) -> Void)! { get set }
    
    func start()
    func load(_ id:String)
    func save(_ account:[String:TimeInterval])
    func save(_ board:Board)
}
