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
        super.textDidEndEditing(notification)
        if column.name.isEmpty {
            Application.shared.view.delete(self)
        }
    }
    
    override func beginDrag() {
        super.beginDrag()
        Application.shared.view.detach(self)
    }
    
    override func endDrag(_ event:NSEvent) {
        super.endDrag(event)
        Application.shared.view.endDrag(self)
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
            Application.shared.view.makeFirstResponder(nil)
            return true
        }
        return false
    }
}
