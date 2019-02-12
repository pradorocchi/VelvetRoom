import UIKit
import VelvetRoom

class ColumnView:EditView {
    private(set) weak var column:Column!
    
    init(_ column:Column) {
        super.init()
        text.font = .bold(CGFloat(Repository.shared.account.font + 6))
        text.alpha = 0.4
        text.text = column.name
        text.textContainer.maximumNumberOfLines = 1
        text.onDelete = { [weak self] in
            guard self?.text.text.isEmpty == false else { return }
            self?.askDelete()
        }
        self.column = column
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
        var after = Canvas.shared.root
        if after is CreateView || after!.frame.maxX > frame.midX {
            sibling = after
            Canvas.shared.root = self
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
        Repository.shared.move(column, board:List.shared.selected.board, after:(after as? ColumnView)?.column)
        super.endDrag()
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
//        Application.view.present(DeleteView { [weak self] in self?.confirmDelete() }, animated:true)
    }
    
    private func confirmDelete() {
        detach()
        var child = self.child
        while child != nil {
            child!.removeFromSuperview()
            child = child!.child
        }
        DispatchQueue.global(qos:.background).async { [weak self] in
            guard let column = self?.column else { return }
            Repository.shared.delete(column, board:List.shared.selected.board)
            Repository.shared.scheduleUpdate(List.shared.selected.board)
            DispatchQueue.main.async { [weak self] in
                Progress.shared.update()
                self?.removeFromSuperview()
            }
        }
    }
    
    private func detach() {
        if self === Canvas.shared.root {
            child!.removeFromSuperview()
            child = child!.child
            Canvas.shared.root = sibling
        } else {
            var sibling = Canvas.shared.root
            while sibling != nil && sibling!.sibling !== self {
                sibling = sibling!.sibling
            }
            sibling?.sibling = self.sibling
        }
        Canvas.shared.update()
    }
}
