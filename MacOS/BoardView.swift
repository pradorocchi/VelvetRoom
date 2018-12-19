import AppKit
import VelvetRoom

class BoardView:NSControl, NSTextFieldDelegate {
    var selected = false { didSet { update() } }
    private(set) var board:Board!
    private(set) weak var edit:NSButton!
    private weak var presenter:Presenter!
    private weak var name:NSTextField!
    override var intrinsicContentSize:NSSize { return NSSize(width:NSView.noIntrinsicMetric, height:50) }
    
    init(_ board:Board, presenter:Presenter) {
        self.board = board
        self.presenter = presenter
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        
        let name = NSTextField()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.drawsBackground = false
        name.isBezeled = false
        name.isEditable = false
        name.focusRingType = .none
        name.font = .systemFont(ofSize:16, weight:.medium)
        name.stringValue = board.name
        name.delegate = self
        name.lineBreakMode = .byTruncatingTail
        name.maximumNumberOfLines = 1
        addSubview(name)
        self.name = name
        
        let edit = NSButton()
        edit.isBordered = false
        edit.image = NSImage(named:"edit")
        edit.imageScaling = .scaleNone
        edit.translatesAutoresizingMaskIntoConstraints = false
        edit.setButtonType(.momentaryChange)
        addSubview(edit)
        self.edit = edit
        
        name.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        name.leftAnchor.constraint(equalTo:leftAnchor, constant:12).isActive = true
        name.rightAnchor.constraint(equalTo:edit.leftAnchor).isActive = true
        
        edit.topAnchor.constraint(equalTo:topAnchor).isActive = true
        edit.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        edit.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
        edit.widthAnchor.constraint(equalToConstant:24).isActive = true
        
        update()
    }
    
    required init?(coder:NSCoder) { return nil }
    override func cancelOperation(_:Any?) { Application.view.makeFirstResponder(nil) }
    
    override func mouseDown(with:NSEvent) {
        if !selected {
            sendAction(action, to:target)
        }
    }
    
    func controlTextDidEndEditing(_:Notification) {
        name.isEditable = false
        presenter.rename(board, name:name.stringValue)
    }
    
    func control(_:NSControl, textView:NSTextView, doCommandBy selector:Selector) -> Bool {
        if (selector == #selector(NSResponder.insertNewline(_:))) {
            Application.view.makeFirstResponder(nil)
            return true
        }
        return false
    }
    
    func editName() {
        name.isEditable = true
        Application.view.makeFirstResponder(name)
        name.currentEditor()!.selectedRange = NSMakeRange(name.stringValue.count, 0)
    }
    
    private func update() {
        if selected {
            layer!.backgroundColor = NSColor.windowBackgroundColor.cgColor
            name.alphaValue = 0.7
        } else {
            layer!.backgroundColor = NSColor.clear.cgColor
            name.alphaValue = 0.4
        }
    }
}
