import AppKit
import VelvetRoom

class ColumnView:ItemView, NSTextViewDelegate {
    private(set) weak var column:Column!
    private weak var name:TextView!
    private weak var view:View!
    private let index:Int
    
    init(_ column:Column, index:Int, view:View) {
        self.index = index
        super.init()
        translatesAutoresizingMaskIntoConstraints = false
        self.column = column
        self.view = view
        
        let name = TextView(column.name, maxWidth:10000, maxHeight:40)
        name.font = .bold(18)
        name.textColor = NSColor.textColor.withAlphaComponent(0.4)
        name.delegate = self
        addSubview(name)
        self.name = name
        
        name.topAnchor.constraint(equalTo:topAnchor, constant:10).isActive = true
        name.bottomAnchor.constraint(equalTo:bottomAnchor, constant:-10).isActive = true
        name.rightAnchor.constraint(equalTo:rightAnchor, constant:-20).isActive = true
        name.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func mouseDown(with event:NSEvent) {
        if event.clickCount == 2 {
            name.isEditable = true
            Application.view.makeFirstResponder(name)
        }
    }
    
    func textDidChange(_:Notification) {
        view.canvasChanged()
    }
    
    func textDidEndEditing(_:Notification) {
        view.canvasChanged()
        column.name = name.string
        view.presenter.scheduleUpdate()
    }
    
    func textView(_:NSTextView, doCommandBy command:Selector) -> Bool {
        if (command == #selector(NSResponder.insertNewline(_:))) {
            Application.view.makeFirstResponder(nil)
            return true
        }
        return false
    }
}
