import AppKit
import VelvetRoom

class BoardView:NSControl, NSTextViewDelegate {
    var selected = false { didSet { updateSkin() } }
    private(set) weak var board:Board!
    private weak var date:NSTextField!
    private weak var text:TextView!
    private let dateFormatter = DateFormatter()
    override var intrinsicContentSize:NSSize { return NSSize(width:NSView.noIntrinsicMetric, height:85) }
    
    init(_ board:Board) {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer!.cornerRadius = 6
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        self.board = board
        
        let text = TextView()
        text.textContainer!.size = NSSize(width:235, height:CGFloat(Application.view.repository.account.font + 16))
        text.font = .bold(CGFloat(Application.view.repository.account.font))
        text.delegate = self
        text.string = board.name
        text.update()
        addSubview(text)
        self.text = text
        
        let date = NSTextField()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.backgroundColor = .clear
        date.isBezeled = false
        date.isEditable = false
        date.font = .systemFont(ofSize:10, weight:.light)
        addSubview(date)
        self.date = date
        
        text.centerYAnchor.constraint(equalTo:centerYAnchor, constant:-8).isActive = true
        text.leftAnchor.constraint(equalTo:leftAnchor, constant:20).isActive = true
        
        date.topAnchor.constraint(equalTo:text.bottomAnchor, constant:-1).isActive = true
        date.leftAnchor.constraint(equalTo:text.leftAnchor, constant:4).isActive = true
        
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
        return (text.string as NSString).replacingCharacters(in:range, with:replacementString ?? String()).count < 26
    }
    
    private func updateSkin() {
        text.textColor = Application.skin.text
        date.textColor = Application.skin.text
        date.stringValue = dateFormatter.string(from:Date(timeIntervalSince1970:board.updated))
        if Application.view.firstResponder === text {
            layer!.backgroundColor = .black
            text.textColor = .white
            text.alphaValue = 1
            date.alphaValue = 0
        } else if selected {
            layer!.backgroundColor = Application.skin.text.withAlphaComponent(0.2).cgColor
            text.alphaValue = 0.8
            date.alphaValue = 0.8
        } else {
            layer!.backgroundColor = NSColor.clear.cgColor
            text.alphaValue = 0.8
            date.alphaValue = 0.8
        }
    }
}
