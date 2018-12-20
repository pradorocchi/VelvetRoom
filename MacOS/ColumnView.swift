import AppKit
import VelvetRoom

class ColumnView:NSControl, NSTextFieldDelegate {
    private(set) weak var column:Column!
    private weak var name:NSTextField!
    private weak var nameWidth:NSLayoutConstraint!
    private weak var presenter:Presenter!
    private let index:Int
    
    init(_ column:Column, index:Int, presenter:Presenter) {
        self.column = column
        self.index = index
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.presenter = presenter
        
        let name = NSTextField()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.drawsBackground = false
        name.isBezeled = false
        name.isEditable = false
        name.focusRingType = .none
        name.font = .bold(16)
        name.stringValue = column.name
        name.alphaValue = 0.6
        name.maximumNumberOfLines = 1
        name.lineBreakMode = .byTruncatingTail
        name.delegate = self
        addSubview(name)
        self.name = name
        
        name.topAnchor.constraint(equalTo:topAnchor).isActive = true
        name.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        name.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        name.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
        nameWidth = name.widthAnchor.constraint(greaterThanOrEqualToConstant:0)
        nameWidth.isActive = true
        
        updateWidth()
    }
    
    required init?(coder:NSCoder) { return nil }
    override func cancelOperation(_:Any?) { Application.view.makeFirstResponder(nil) }
    
    override func mouseDown(with event:NSEvent) {
        if event.clickCount == 2 {
            name.isEditable = true
            Application.view.makeFirstResponder(name)
            name.currentEditor()!.selectedRange = NSMakeRange(name.stringValue.count, 0)
        }
    }
    
    func controlTextDidEndEditing(_:Notification) {
        name.isEditable = false
        column.name = name.stringValue
        presenter.scheduleUpdate()
        updateWidth()
    }
    
    func control(_:NSControl, textView:NSTextView, doCommandBy selector:Selector) -> Bool {
        if (selector == #selector(NSResponder.insertNewline(_:))) {
            Application.view.makeFirstResponder(nil)
            return true
        }
        return false
    }
    
    private func updateWidth() {
        nameWidth.constant = name.sizeThatFits(NSSize(width:900, height:30)).width
    }
}
