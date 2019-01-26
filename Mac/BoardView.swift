import AppKit
import VelvetRoom

class BoardView:NSControl, NSTextViewDelegate {
    var selected = false { didSet { updateSkin() } }
    private(set) weak var board:Board!
    private weak var text:TextView!
    override var intrinsicContentSize:NSSize { return NSSize(width:NSView.noIntrinsicMetric, height:85) }
    
    init(_ board:Board) {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        self.board = board
        
        let text = TextView()
        text.textContainer!.size = NSSize(width:250, height:CGFloat(Application.view.repository.account.font + 16))
        text.font = .bold(CGFloat(Application.view.repository.account.font))
        text.delegate = self
        text.string = board.name
        text.update()
        addSubview(text)
        self.text = text
        
        text.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        text.leftAnchor.constraint(equalTo:leftAnchor, constant:12).isActive = true
        
        updateSkin()
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func mouseDown(with event:NSEvent) {
        if event.clickCount == 2 {
            text.isEditable = true
            Application.view.makeFirstResponder(text)
            updateSkin()
        } else if !selected {
            sendAction(action, to:target)
        }
    }
    
    func delete() {
        Application.view.makeFirstResponder(nil)
        Application.view.beginSheet(DeleteView(.local("DeleteView.board")) {
            Application.view.repository.delete(self.board)
        })
    }
    
    func textDidEndEditing(_:Notification) {
        board.name = text.string
        if board.name.isEmpty {
            delete()
        } else {
            text.string = board.name
            text.update()
        }
        Application.view.scheduleUpdate(board)
        DispatchQueue.main.async { [weak self] in self?.updateSkin() }
    }
    
    func textView(_:NSTextView, doCommandBy command:Selector) -> Bool {
        if (command == #selector(NSResponder.insertNewline(_:))) {
            Application.view.makeFirstResponder(nil)
            return true
        }
        return false
    }
    
    func textView(_:NSTextView, shouldChangeTextIn range:NSRange, replacementString:String?) -> Bool {
        return (text.string as NSString).replacingCharacters(in:range, with:replacementString ?? String()).count < 28
    }
    
    private func updateSkin() {
        text.textColor = Application.skin.text
        if Application.view.firstResponder === text {
            layer!.backgroundColor = .black
            text.textColor = .white
            text.alphaValue = 1
        } else if selected {
            layer!.backgroundColor = Application.skin.text.withAlphaComponent(0.2).cgColor
            text.alphaValue = 0.8
        } else {
            layer!.backgroundColor = NSColor.clear.cgColor
            text.alphaValue = 0.8
        }
    }
}