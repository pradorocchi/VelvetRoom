import AppKit
import VelvetRoom

class BoardView:NSControl, NSTextViewDelegate {
    var selected = false { didSet { update() } }
    private(set) weak var board:Board!
    private weak var presenter:Presenter!
    private weak var name:TextView!
    override var intrinsicContentSize:NSSize { return NSSize(width:NSView.noIntrinsicMetric, height:50) }
    
    init(_ board:Board, presenter:Presenter) {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        self.board = board
        self.presenter = presenter
        
        let name = TextView(board.name, maxWidth:130, maxHeight:30)
        name.font = .systemFont(ofSize:12, weight:.regular)
        name.delegate = self
        addSubview(name)
        self.name = name
        
        name.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        name.leftAnchor.constraint(equalTo:leftAnchor, constant:12).isActive = true
        
        update()
    }
    
    required init?(coder:NSCoder) { return nil }
    override func cancelOperation(_:Any?) { Application.view.makeFirstResponder(nil) }
    
    override func mouseDown(with event:NSEvent) {
        if event.clickCount == 2 {
            name.isEditable = true
            Application.view.makeFirstResponder(name)
        } else if !selected {
            sendAction(self.action, to:self.target)
        }
    }
    
    func textDidEndEditing(_:Notification) {
        board.name = name.string
        presenter.scheduleUpdate()
    }
    
    func textView(_:NSTextView, doCommandBy command:Selector) -> Bool {
        if (command == #selector(NSResponder.insertNewline(_:))) {
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
