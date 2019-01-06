import AppKit
import VelvetRoom

class ColumnView:EditView {
    private(set) weak var column:Column!
    
    init(_ column:Column) {
        super.init()
        text.textContainer!.size = NSSize(width:10000, height:40)
        text.font = .bold(18)
        text.textColor = NSColor.textColor.withAlphaComponent(0.4)
        text.string = column.name
        text.update()
        self.column = column
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func beginEditing() {
        super.beginEditing()
        text.textColor = .textColor
    }
    
    override func textDidEndEditing(_ notification:Notification) {
        column.name = text.string
        text.textColor = NSColor.textColor.withAlphaComponent(0.4)
        if column.name.isEmpty {
            Application.view.makeFirstResponder(nil)
            Application.view.beginSheet(DeleteView(.local("DeleteView.column")) { [weak self] in
                self?.confirmDelete()
            })
        } else {
            text.string = column.name
            text.update()
        }
        super.textDidEndEditing(notification)
    }
    
    override func beginDrag() {
        super.beginDrag()
        detach()
    }
    
    override func endDrag(_ event:NSEvent) {
        super.endDrag(event)
        var after = Application.view.root
        if Application.view.root is CreateView || Application.view.root!.frame.maxX > frame.midX {
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
        Application.view.repository.move(column, board:Application.view.selected.board,
                                         after:(after as? ColumnView)?.column)
        Application.view.scheduleUpdate()
        Application.view.progress.progress = Application.view.selected.board.progress
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
    
    func textView(_:NSTextView, doCommandBy command:Selector) -> Bool {
        if (command == #selector(NSResponder.insertNewline(_:))) {
            Application.view.makeFirstResponder(nil)
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
        DispatchQueue.global(qos:.background).async {
            Application.view.repository.delete(self.column, board:Application.view.selected.board)
            Application.view.scheduleUpdate()
            DispatchQueue.main.async {
                Application.view.progress.progress = Application.view.selected.board.progress
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
