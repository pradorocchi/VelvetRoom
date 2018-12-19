import AppKit
import VelvetRoom

class ColumnView:NSControl, NSTextFieldDelegate {
    let index:Int
    private(set) var column:Column!
    private weak var name:NSTextField!
    private weak var nameWidth:NSLayoutConstraint!
    
    init(_ column:Column, index:Int) {
        self.column = column
        self.index = index
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let name = NSTextField()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.drawsBackground = false
        name.isBezeled = false
        name.isEditable = false
        name.focusRingType = .none
        name.font = .bold(18)
        name.stringValue = column.name
        name.alphaValue = 0.4
        name.maximumNumberOfLines = 1
        name.lineBreakMode = .byTruncatingTail
        name.delegate = self
        addSubview(name)
        self.name = name
        
        let edit = NSButton()
        edit.isBordered = false
        edit.target = self
        edit.action = #selector(editName)
        edit.image = NSImage(named:"edit")
        edit.imageScaling = .scaleNone
        edit.translatesAutoresizingMaskIntoConstraints = false
        edit.setButtonType(.momentaryChange)
        addSubview(edit)
        
        name.topAnchor.constraint(equalTo:topAnchor).isActive = true
        name.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        name.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        name.rightAnchor.constraint(equalTo:edit.leftAnchor).isActive = true
        nameWidth = name.widthAnchor.constraint(greaterThanOrEqualToConstant:0)
        nameWidth.isActive = true
        
        edit.topAnchor.constraint(equalTo:topAnchor).isActive = true
        edit.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        edit.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
        edit.widthAnchor.constraint(equalToConstant:30).isActive = true
        
        updateWidth()
    }
    
    required init?(coder:NSCoder) { return nil }
    override func cancelOperation(_:Any?) { Application.view.makeFirstResponder(nil) }
    
    func controlTextDidEndEditing(_:Notification) {
        name.isEditable = false
//        presenter.rename(board, name:name.stringValue)
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
    
    @objc private func editName() {
        name.isEditable = true
        Application.view.makeFirstResponder(name)
        name.currentEditor()!.selectedRange = NSMakeRange(name.stringValue.count, 0)
    }
}
