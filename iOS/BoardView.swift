import UIKit
import VelvetRoom

class BoardView:UIControl, UITextViewDelegate {
    override var isSelected:Bool { didSet { update() } }
    override var isHighlighted:Bool { didSet { update() } }
    private(set) weak var board:Board!
    private weak var text:TextView!
    override var intrinsicContentSize:CGSize { return CGSize(width:UIView.noIntrinsicMetric, height:54) }
    
    init(_ board:Board) {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 4
        addGestureRecognizer(UILongPressGestureRecognizer(target:self, action:#selector(longpressed(_:))))
        self.board = board
        
        let text = TextView()
        text.font = .regular(18)
        text.delegate = self
        text.text = board.name
        text.bounces = false
        text.isScrollEnabled = false
        text.isUserInteractionEnabled = false
        text.textContainer.maximumNumberOfLines = 1
        text.textContainer.lineBreakMode = .byTruncatingHead
        addSubview(text)
        self.text = text

        text.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        text.leftAnchor.constraint(equalTo:leftAnchor, constant:12).isActive = true
        text.rightAnchor.constraint(equalTo:rightAnchor, constant:-40).isActive = true
        text.heightAnchor.constraint(equalToConstant:22).isActive = true
        update()
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func textViewDidEndEditing(_:UITextView) {
        text.isUserInteractionEnabled = false
        board.name = text.text
        Application.view.scheduleUpdate()
        isSelected = false
        DispatchQueue.main.async {
            self.update()
        }
    }
    
    func textView(_:UITextView, shouldChangeTextIn:NSRange, replacementText string:String) -> Bool {
        if string == "\n" {
            text.resignFirstResponder()
            return false
        }
        return true
    }
    
    /*
    func textDidEndEditing(_:Notification) {
        board.name = text.string
        if board.name.isEmpty {
            Application.shared.view.delete()
        } else {
            Application.shared.view.presenter.scheduleUpdate()
        }
        DispatchQueue.main.async { [weak self] in self?.update() }
    }
    
    func textView(_:NSTextView, doCommandBy command:Selector) -> Bool {
        if (command == #selector(NSResponder.insertNewline(_:))) {
            Application.shared.view.makeFirstResponder(nil)
            return true
        }
        return false
    }
    
    func textView(_:NSTextView, shouldChangeTextIn range:NSRange, replacementString:String?) -> Bool {
        return (text.string as NSString).replacingCharacters(in:range, with:replacementString ?? String()).count < 28
    }
    */
    private func update() {
        if text.isFirstResponder {
            backgroundColor = .clear
            text.textColor = .white
        } else if isSelected || isHighlighted {
            backgroundColor = .velvetBlue
            text.textColor = .black
        } else {
            backgroundColor = .velvetShade
            text.textColor = .white
        }
    }
    
    @objc private func longpressed(_ gesture:UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        text.isUserInteractionEnabled = true
        text.becomeFirstResponder()
        update()
        Application.view.selected = self
    }
}
