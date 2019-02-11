import UIKit
import VelvetRoom

class Canvas:UIView {
    static let shared = Canvas()
    weak var root:ItemView?
    private weak var canvasWidth:NSLayoutConstraint? { didSet {
        oldValue?.isActive = false; canvasWidth!.isActive = true } }
    private weak var canvasHeight:NSLayoutConstraint? { didSet {
        oldValue?.isActive = false; canvasHeight!.isActive = true } }
    
    private init() {
        super.init(frame:.zero)
    }
    
    required init?(coder:NSCoder) { return nil }
}
