import UIKit

class SearchView:UIView, UITextViewDelegate {
    static let shared = SearchView()
    private(set) weak var text:TextView!
    private(set) weak var highlighter:UIView?
    private weak var bottom:NSLayoutConstraint!
    
    private init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 4
        layer.borderWidth = 1
        
        let image = UIImageView(image:#imageLiteral(resourceName: "searchIcon.pdf"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .center
        image.clipsToBounds = true
        addSubview(image)
        
        let text = TextView()
        text.font = .light(22)
        text.delegate = self
        text.deleteButton.isHidden = true
        self.text = text
        addSubview(text)
        
        let done = UIButton()
        done.translatesAutoresizingMaskIntoConstraints = false
        done.addTarget(self, action:#selector(self.done), for:.touchUpInside)
        done.setImage(#imageLiteral(resourceName: "delete.pdf"), for:.normal)
        done.imageView!.contentMode = .center
        done.imageView!.clipsToBounds = true
        addSubview(done)
        
        heightAnchor.constraint(equalToConstant:64).isActive = true
        
        image.topAnchor.constraint(equalTo:topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        image.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant:50).isActive = true
        
        text.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        text.leftAnchor.constraint(equalTo:image.rightAnchor).isActive = true
        text.rightAnchor.constraint(equalTo:done.leftAnchor).isActive = true
        text.heightAnchor.constraint(equalToConstant:34).isActive = true
        
        done.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
        done.widthAnchor.constraint(equalToConstant:50).isActive = true
        done.topAnchor.constraint(equalTo:topAnchor).isActive = true
        done.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        
        updateSkin()
        Skin.add(self)
    }
    
    required init?(coder:NSCoder) { return nil }
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        bottom = bottomAnchor.constraint(equalTo:superview!.topAnchor)
        bottom.isActive = true
    }
    
    func textViewDidEndEditing(_:UITextView) {
        unactive()
    }
    
    func textView(_:UITextView, shouldChangeTextIn:NSRange, replacementText text:String) -> Bool {
        if text == "\n" {
            self.text.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange(_:UITextView) {
        if self.highlighter == nil {
            let highlighter = UIView()
            highlighter.backgroundColor = .velvetBlue
            highlighter.layer.cornerRadius = 4
            Canvas.shared.addSubview(highlighter)
            Canvas.shared.sendSubviewToBack(highlighter)
            self.highlighter = highlighter
        }
        
        var range:Range<String.Index>!
        guard let view = Canvas.shared.content.subviews.first (where: {
            guard
                let view = $0 as? EditView,
                let textRange = view.text.text.range(of:text.text, options:.caseInsensitive)
            else { return false }
            range = textRange
            return true
        }) as? EditView else { return highlighter!.frame = .zero }
        var frame = Canvas.shared.content.convert(view.text.layoutManager.boundingRect(forGlyphRange:
            NSRange(range, in:view.text.text), in:view.text.textContainer), from:view.text)
        frame.origin.x -= 10
        frame.size.width += 20
        highlighter!.frame = frame
        
        frame.origin.x -= (App.shared.view.bounds.width - frame.size.width) / 2
        frame.origin.y -= (Canvas.shared.bounds.height - 20) / 2
        frame.size.width = App.shared.view.bounds.width
        frame.size.height = Canvas.shared.bounds.height - 20
        Canvas.shared.scrollRectToVisible(frame, animated:true)
    }
    
    @objc func active() {
        UIApplication.shared.keyWindow!.endEditing(true)
        if #available(iOS 11.0, *) {
            bottom.constant = 120 + superview!.safeAreaInsets.top
        } else {
            bottom.constant = 120
        }
        text.isEditable = true
        UIView.animate(withDuration:0.4, animations: {
            self.superview!.layoutIfNeeded()
        }) { _ in
            self.text.becomeFirstResponder()
        }
    }
    
    private func unactive() {
        bottom.constant = 0
        text.isEditable = false
        UIView.animate(withDuration:0.6, animations: {
            self.highlighter?.alpha = 0
            self.superview!.layoutIfNeeded()
        }) { _ in
            self.highlighter?.removeFromSuperview()
            self.text.text = String()
        }
    }
    
    @objc private func updateSkin() {
        backgroundColor = Skin.shared.background.withAlphaComponent(0.85)
        layer.borderColor = Skin.shared.text.withAlphaComponent(0.4).cgColor
        text.textColor = Skin.shared.text
    }
    
    @objc private func done() {
        text.resignFirstResponder()
    }
}
