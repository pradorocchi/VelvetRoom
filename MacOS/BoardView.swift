import AppKit
import VelvetRoom

class BoardView:NSControl, NSTextViewDelegate {
    var selected = false { didSet { update() } }
    private(set) weak var board:Board!
    private weak var view:View!
    private weak var text:TextView!
    override var intrinsicContentSize:NSSize { return NSSize(width:NSView.noIntrinsicMetric, height:60) }
    
    init(_ board:Board, view:View) {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        self.board = board
        self.view = view
        
        let text = TextView()
        text.textContainer!.size = NSSize(width:250, height:30)
        text.font = .light(13)
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
            view.makeFirstResponder(text)
            update()
        } else if !selected {
            sendAction(self.action, to:self.target)
        }
    }
    
    func textDidEndEditing(_:Notification) {
        board.name = text.string
        if board.name.isEmpty {
            view.delete()
        } else {
            view.presenter.scheduleUpdate()
        }
        DispatchQueue.main.async { [weak self] in self?.update() }
    }
    
    func textView(_:NSTextView, doCommandBy command:Selector) -> Bool {
        if (command == #selector(NSResponder.insertNewline(_:))) {
            view.makeFirstResponder(nil)
            return true
        }
        return false
    }
    
    func textView(_:NSTextView, shouldChangeTextIn range:NSRange, replacementString:String?) -> Bool {
        return (text.string as NSString).replacingCharacters(in:range, with:replacementString ?? String()).count < 28
    }
    
    private func update() {
        if view.firstResponder === text {
            layer!.backgroundColor = NSColor.windowFrameColor.withAlphaComponent(0.2).cgColor
            text.alphaValue = 1
        } else if selected {
            layer!.backgroundColor = NSColor.windowBackgroundColor.cgColor
            text.alphaValue = 0.8
        } else {
            layer!.backgroundColor = NSColor.clear.cgColor
            text.alphaValue = 0.8
        }
    }
}
