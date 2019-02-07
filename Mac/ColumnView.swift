import AppKit
import VelvetRoom

class ColumnView:EditView {
    private(set) weak var column:Column!
    
    init(_ column:Column) {
        super.init()
        self.column = column
        updateSkin()
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func beginEditing() {
        super.beginEditing()
        text.textColor = Skin.shared.text
    }
    
    override func textDidEndEditing(_ notification:Notification) {
        column.name = text.string
        text.textColor = Skin.shared.text.withAlphaComponent(0.4)
        if column.name.isEmpty {
            Window.shared.makeFirstResponder(nil)
            Window.shared.beginSheet(DeleteView(.local("DeleteView.column")) { [weak self] in
                self?.confirmDelete()
            })
        } else {
            text.string = column.name
        }
        super.textDidEndEditing(notification)
    }
    
    override func beginDrag() {
        super.beginDrag()
        detach()
    }
    
    override func endDrag(_ event:NSEvent) {
        super.endDrag(event)
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
        Canvas.shared.update()
        Repository.shared.move(column, board:List.shared.current!.board, after:(after as? ColumnView)?.column)
        List.shared.scheduleUpdate()
        Progress.shared.update()
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
    
    override func updateSkin() {
        text.textColor = Skin.shared.text.withAlphaComponent(0.4)
        text.textContainer!.size = NSSize(width:10000, height:Skin.shared.font + 46)
        text.font = .bold(Skin.shared.font + 6)
        text.string = column.name
        super.updateSkin()
    }
    
    func textView(_:NSTextView, doCommandBy command:Selector) -> Bool {
        if (command == #selector(NSResponder.insertNewline(_:))) {
            Window.shared.makeFirstResponder(nil)
            return true
        }
        return false
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
            Repository.shared.delete(column, board:List.shared.current!.board)
            List.shared.scheduleUpdate()
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
