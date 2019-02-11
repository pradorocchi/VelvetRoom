import UIKit
import VelvetRoom

class Canvas:UIScrollView {
    static let shared = Canvas()
    weak var root:ItemView?
    private weak var content:UIView!
    private weak var width:NSLayoutConstraint? { didSet { oldValue?.isActive = false; width!.isActive = true } }
    private weak var height:NSLayoutConstraint? { didSet { oldValue?.isActive = false; height!.isActive = true } }
    
    private init() {
        super.init(frame:.zero)
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func update(_ animation:TimeInterval = 0.5) {
        addCarder()
        content.layoutIfNeeded()
        align()
        UIView.animate(withDuration:animation) {
            self.content.layoutIfNeeded()
            self.layoutIfNeeded()
        }
    }
}
