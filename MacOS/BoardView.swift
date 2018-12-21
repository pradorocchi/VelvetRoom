import AppKit
import VelvetRoom

class BoardView:NSControl, NSTextFieldDelegate {
    var selected = false { didSet { update() } }
    private(set) weak var board:Board!
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
        name.font = .systemFont(ofSize:12, weight:.regular)
        name.stringValue = board.name
        name.delegate = self
        name.lineBreakMode = .byTruncatingTail
        name.maximumNumberOfLines = 1
        addSubview(name)
        self.name = name
        
        name.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        name.leftAnchor.constraint(equalTo:leftAnchor, constant:12).isActive = true
        name.rightAnchor.constraint(equalTo:rightAnchor, constant:-6).isActive = true
        
        update()
    }
    
    required init?(coder:NSCoder) { return nil }
    override func cancelOperation(_:Any?) { Application.view.makeFirstResponder(nil) }
    
    override func mouseDown(with event:NSEvent) {
        if event.clickCount == 2 {
            name.isEditable = true
            Application.view.makeFirstResponder(name)
            name.currentEditor()?.selectedRange = NSMakeRange(name.stringValue.count, 0)
        } else if !selected {
            DispatchQueue.main.async {
                self.sendAction(self.action, to:self.target)
            }
        }
    }
    
    func controlTextDidEndEditing(_:Notification) {
        name.isEditable = false
        board.name = name.stringValue
        presenter.scheduleUpdate()
    }
    
    func control(_:NSControl, textView:NSTextView, doCommandBy selector:Selector) -> Bool {
        if (selector == #selector(NSResponder.insertNewline(_:))) {
            Application.view.makeFirstResponder(nil)
            return true
        }
        return false
    }
    
    private func update() {
        if selected {
            layer!.backgroundColor = NSColor.windowBackgroundColor.cgColor
            name.textColor = NSColor.textColor.withAlphaComponent(0.7)
        } else {
            layer!.backgroundColor = NSColor.clear.cgColor
            name.textColor = NSColor.textColor.withAlphaComponent(0.4)
        }
    }
}
