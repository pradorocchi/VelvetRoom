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
        text.onDelete = { if !self.text.text.isEmpty { self.askDelete() } }
        self.column = column
        
        text.heightAnchor.constraint(equalToConstant:22).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func beginEditing() {
        super.beginEditing()
        text.alpha = 1
    }
    
    override func textViewDidEndEditing(_ textView:UITextView) {
        if text.text.isEmpty {
            UIApplication.shared.keyWindow!.endEditing(true)
            askDelete()
        } else {
            column.name = text.text
            text.alpha = 0.4
            super.textViewDidEndEditing(textView)
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
    
    private func askDelete() {
        Application.view.present(DeleteView { self.confirmDelete() }, animated:true)
    }
    
    private func confirmDelete() {
        Application.view.delete(self)
    }
}
