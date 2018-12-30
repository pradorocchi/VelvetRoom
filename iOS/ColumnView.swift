import UIKit
import VelvetRoom

class ColumnView:EditView {
    private(set) weak var column:Column!
    
    init(_ column:Column) {
        super.init()
        text.font = .bold(18)
        text.alpha = 0.4
        text.text = column.name
        text.textContainer.maximumNumberOfLines = 1
        self.column = column
        
        text.heightAnchor.constraint(equalToConstant:22).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func beginEditing() {
        super.beginEditing()
        text.alpha = 1
    }
    
    override func textViewDidEndEditing(_ textView:UITextView) {
        column.name = text.text
        super.textViewDidEndEditing(textView)
        text.alpha = 0.4
        if column.name.isEmpty {
//            Application.shared.view.delete(self)
        }
    }
    
    override func beginDrag() {
        super.beginDrag()
//        Application.shared.view.beginDrag(self)
    }
    
    override func endDrag() {
        super.endDrag()
//        Application.shared.view.endDrag(self)
    }
    
    override func drag(deltaX:CGFloat, deltaY:CGFloat) {
        super.drag(deltaX:deltaX, deltaY:deltaY)
        var child = self.child
        while child != nil {
            child!.left.constant += deltaX
            child!.top.constant += deltaY
            child = child!.child
        }
    }
    
    func textView(_:UITextView, shouldChangeTextIn:NSRange, replacementText string:String) -> Bool {
        if string == "\n" {
            text.resignFirstResponder()
            return false
        }
        return true
    }
}
