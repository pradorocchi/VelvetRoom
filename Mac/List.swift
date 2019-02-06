import AppKit

class List:ScrollView {
    static let shared = List()
    private(set) weak var left:NSLayoutConstraint!
    
    private override init() {
        super.init()
        List.shared = self
    }
    
    required init?(coder:NSCoder) { return nil }
}
