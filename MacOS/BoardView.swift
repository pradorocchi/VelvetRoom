import AppKit
import VelvetRoom

class BoardView:NSControl, NSTextViewDelegate {
    var selected = false { didSet { update() } }
    private(set) weak var board:Board!
    private weak var presenter:Presenter!
    private weak var text:TextView!
    override var intrinsicContentSize:NSSize { return NSSize(width:NSView.noIntrinsicMetric, height:50) }
    
    init(_ board:Board, presenter:Presenter) {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        self.board = board
        self.presenter = presenter
        
        let text = TextView()
        text.textContainer!.size = NSSize(width:130, height:30)
        text.font = .systemFont(ofSize:12, weight:.regular)
        text.delegate = self
        text.string = board.name
        text.update()
        addSubview(text)
        self.text = text
        
        text.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        text.leftAnchor.constraint(equalTo:leftAnchor, constant:12).isActive = true
        
        update()
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func mouseDown(with event:NSEvent) {
        if event.clickCount == 2 {
            text.isEditable = true
            Application.view.makeFirstResponder(text)
        } else if !selected {
            sendAction(self.action, to:self.target)
        }
    }
    
    func textDidEndEditing(_:Notification) {
        board.name = text.string
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
            text.textColor = NSColor.textColor.withAlphaComponent(0.7)
        } else {
            layer!.backgroundColor = NSColor.clear.cgColor
            text.textColor = NSColor.textColor.withAlphaComponent(0.4)
        }
    }
}
