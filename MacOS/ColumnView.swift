import AppKit
import VelvetRoom

class ColumnView:EditView {
    private(set) weak var column:Column!
    
    init(_ column:Column, view:View) {
        super.init(view)
        text.textContainer!.size = NSSize(width:10000, height:40)
        text.font = .bold(18)
        text.textColor = NSColor.textColor.withAlphaComponent(0.4)
        text.string = column.name
        text.update()
        self.column = column
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func textDidEndEditing(_ notification:Notification) {
        column.name = text.string
        super.textDidEndEditing(notification)
    }
    
    func textView(_:NSTextView, doCommandBy command:Selector) -> Bool {
        if (command == #selector(NSResponder.insertNewline(_:))) {
            Application.view.makeFirstResponder(nil)
            return true
        }
        return false
    }
}
