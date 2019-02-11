import UIKit

class Bar:UIView {
    static let shared = Bar()
    private weak var loadLeft:NSLayoutConstraint! { willSet { newValue.isActive = true } }
    private weak var chartLeft:NSLayoutConstraint! { willSet { newValue.isActive = true } }
    private weak var title:UILabel!
    
    private init() {
        super.init(frame:.zero)
    }
    
    required init?(coder:NSCoder) { return nil }
}
