import UIKit
import VelvetRoom

class ColumnView:EditView {
    private(set) weak var column:Column!
    
    init(_ column:Column) {
        super.init()
        text.font = .bold(CGFloat(Application.view.repository.account.font + 6))
        text.alpha = 0.4
        text.text = column.name
        text.textContainer.maximumNumberOfLines = 1
        text.onDelete = { if !self.text.text.isEmpty { self.askDelete() } }
        self.column = column
        
//        text.heightAnchor.constraint(equalToConstant:24).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func beginEditing() {
        super.beginEditing()
        text.alpha = 1
    }
    
    override func textViewDidEndEditing(_ textView:UITextView) {
        column.name = text.text
        if column.name.isEmpty {
            UIApplication.shared.keyWindow!.endEditing(true)
            askDelete()
        } else {
            text.text = column.name
            text.alpha = 0.4
        }
        super.textViewDidEndEditing(textView)
    }
    
    override func beginDrag() {
        super.beginDrag()
        detach()
    }
    
    override func endDrag() {
        super.endDrag()
        var after = Application.view.root
        if Application.view.root! is CreateView || Application.view.root!.frame.maxX > frame.midX {
            sibling = Application.view.root
            Application.view.root = self
            after = nil
            if sibling?.child is CreateView {
                sibling?.child?.removeFromSuperview()
                sibling?.child = sibling?.child?.child
            }
        } else {
            while after!.sibling is ColumnView {
                guard after!.sibling!.left.constant < frame.minX else { break }
                after = after!.sibling
            }
            sibling = after!.sibling
            after!.sibling = self
        }
        Application.view.canvasChanged()
        Application.view.repository.move(column, board:Application.view.selected!, after:(after as? ColumnView)?.column)
        Application.view.scheduleUpdate()
        Application.view.progressButton.progress = Application.view.selected!.progress
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
        detach()
        var child = self.child
        while child != nil {
            child!.removeFromSuperview()
            child = child!.child
        }
        DispatchQueue.global(qos:.background).async {
            Application.view.repository.delete(self.column, board:Application.view.selected!)
            Application.view.scheduleUpdate()
            DispatchQueue.main.async {
                Application.view.progressButton.progress = Application.view.selected!.progress
                self.removeFromSuperview()
            }
        }
    }
    
    private func detach() {
        if self === Application.view.root {
            child!.removeFromSuperview()
            child = child!.child
            Application.view.root = sibling
        } else {
            var sibling = Application.view.root
            while sibling != nil && sibling!.sibling !== self {
                sibling = sibling!.sibling
            }
            sibling?.sibling = self.sibling
        }
        Application.view.canvasChanged()
    }
}
