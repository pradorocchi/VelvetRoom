import UIKit

class TextView:UITextView {
    var onDelete:(() -> Void)!
    private weak var deleteButton:UIButton!
    override var font:UIFont? {
        didSet {
            let storage = textStorage as! TextStorage
            storage.text = font
            storage.header = .bold(font!.pointSize)
        }
    }
    
    init() {
        let container = NSTextContainer()
        let storage = TextStorage()
        let layout = TextLayout()
        storage.addLayoutManager(layout)
        layout.addTextContainer(container)
        container.lineBreakMode = .byTruncatingTail
        super.init(frame:.zero, textContainer:container)
        translatesAutoresizingMaskIntoConstraints = false
        bounces = false
        isScrollEnabled = false
        isUserInteractionEnabled = false
        backgroundColor = .clear
        tintColor = .velvetBlue
        textColor = .white
        returnKeyType = .default
        keyboardAppearance = .dark
        autocorrectionType = .yes
        spellCheckingType = .yes
        autocapitalizationType = .sentences
        keyboardType = .alphabet
        contentInset = .zero
        textContainerInset = .zero
        inputAccessoryView = UIView(frame:CGRect(x:0, y:0, width:0, height:54))
        inputAccessoryView!.backgroundColor = .velvetShade
        
        let doneButton = UIButton()
        doneButton.layer.cornerRadius = 4
        doneButton.backgroundColor = .velvetBlue
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.addTarget(self, action:#selector(resignFirstResponder), for:.touchUpInside)
        doneButton.setTitle(.local("TextView.done"), for:[])
        doneButton.setTitleColor(.black, for:.normal)
        doneButton.setTitleColor(UIColor(white:0, alpha:0.2), for:.highlighted)
        doneButton.titleLabel!.font = .systemFont(ofSize:12, weight:.medium)
        inputAccessoryView!.addSubview(doneButton)
        
        let deleteButton = UIButton()
        deleteButton.addTarget(self, action:#selector(remove), for:.touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setImage(#imageLiteral(resourceName: "delete.pdf"), for:.normal)
        deleteButton.imageView!.clipsToBounds = true
        deleteButton.imageView!.contentMode = .center
        inputAccessoryView!.addSubview(deleteButton)
        self.deleteButton = deleteButton
        
        doneButton.rightAnchor.constraint(equalTo:inputAccessoryView!.rightAnchor, constant:-20).isActive = true
        doneButton.centerYAnchor.constraint(equalTo:inputAccessoryView!.centerYAnchor).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant:56).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant:30).isActive = true
        
        deleteButton.topAnchor.constraint(equalTo:inputAccessoryView!.topAnchor, constant:2).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo:inputAccessoryView!.bottomAnchor).isActive = true
        deleteButton.leftAnchor.constraint(equalTo:inputAccessoryView!.leftAnchor).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant:60).isActive = true
        
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func caretRect(for position:UITextPosition) -> CGRect {
        var rect = super.caretRect(for:position)
        rect.size.width += 4
        return rect
    }
    
    @objc private func remove() {
        resignFirstResponder()
        onDelete()
    }
}
