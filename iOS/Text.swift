import UIKit

class Text:UITextView {
    var delete:(() -> Void)! { didSet { deleteButton.isHidden = false } }
    private(set) weak var border:UIView!
    private weak var deleteButton:UIButton!
    override var font:UIFont? {
        didSet {
            let storage = textStorage as! Storage
            storage.text = font
            storage.header = .bold(font!.pointSize)
        }
    }
    
    init() {
        let container = NSTextContainer()
        let storage = Storage()
        let layout = Layout()
        storage.addLayoutManager(layout)
        layout.addTextContainer(container)
        container.lineBreakMode = .byTruncatingHead
        super.init(frame:.zero, textContainer:container)
        translatesAutoresizingMaskIntoConstraints = false
        bounces = false
        isScrollEnabled = false
        isUserInteractionEnabled = false
        backgroundColor = .clear
        tintColor = .velvetBlue
        textColor = Skin.shared.text
        returnKeyType = .default
        keyboardAppearance = Skin.shared.keyboard
        autocorrectionType = .yes
        spellCheckingType = .yes
        autocapitalizationType = .sentences
        keyboardType = .alphabet
        contentInset = .zero
        textContainerInset = .zero
        inputAccessoryView = UIView(frame:CGRect(x:0, y:0, width:0, height:54))
        inputAccessoryView!.backgroundColor = Skin.shared.over
        
        let doneButton = Link(.local("Text.done"), target:self, selector:#selector(resignFirstResponder))
        inputAccessoryView!.addSubview(doneButton)
        
        let deleteButton = UIButton()
        deleteButton.addTarget(self, action:#selector(remove), for:.touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setImage(#imageLiteral(resourceName: "delete.pdf"), for:.normal)
        deleteButton.imageView!.clipsToBounds = true
        deleteButton.imageView!.contentMode = .center
        deleteButton.isHidden = true
        inputAccessoryView!.addSubview(deleteButton)
        self.deleteButton = deleteButton
        
        let headerButton = UIButton()
        headerButton.addTarget(self, action:#selector(header), for:.touchUpInside)
        headerButton.translatesAutoresizingMaskIntoConstraints = false
        headerButton.setImage(#imageLiteral(resourceName: "header.pdf"), for:.normal)
        headerButton.imageView!.clipsToBounds = true
        headerButton.imageView!.contentMode = .center
        inputAccessoryView!.addSubview(headerButton)
        
        let listingButton = UIButton()
        listingButton.addTarget(self, action:#selector(listing), for:.touchUpInside)
        listingButton.translatesAutoresizingMaskIntoConstraints = false
        listingButton.setImage(#imageLiteral(resourceName: "listing.pdf"), for:.normal)
        listingButton.imageView!.clipsToBounds = true
        listingButton.imageView!.contentMode = .center
        inputAccessoryView!.addSubview(listingButton)
        
        let border = UIView()
        border.isUserInteractionEnabled = false
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = Skin.shared.background
        inputAccessoryView!.addSubview(border)
        self.border = border
        
        doneButton.rightAnchor.constraint(equalTo:inputAccessoryView!.rightAnchor, constant:-20).isActive = true
        doneButton.centerYAnchor.constraint(equalTo:inputAccessoryView!.centerYAnchor).isActive = true
        doneButton.width.constant = 60
        
        deleteButton.topAnchor.constraint(equalTo:inputAccessoryView!.topAnchor, constant:2).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo:inputAccessoryView!.bottomAnchor).isActive = true
        deleteButton.leftAnchor.constraint(equalTo:inputAccessoryView!.leftAnchor).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant:60).isActive = true
        
        headerButton.topAnchor.constraint(equalTo:inputAccessoryView!.topAnchor, constant:2).isActive = true
        headerButton.bottomAnchor.constraint(equalTo:inputAccessoryView!.bottomAnchor).isActive = true
        headerButton.leftAnchor.constraint(equalTo:inputAccessoryView!.centerXAnchor, constant:10).isActive = true
        headerButton.widthAnchor.constraint(equalToConstant:60).isActive = true
        
        listingButton.topAnchor.constraint(equalTo:inputAccessoryView!.topAnchor, constant:2).isActive = true
        listingButton.bottomAnchor.constraint(equalTo:inputAccessoryView!.bottomAnchor).isActive = true
        listingButton.rightAnchor.constraint(equalTo:inputAccessoryView!.centerXAnchor, constant:-10).isActive = true
        listingButton.widthAnchor.constraint(equalToConstant:60).isActive = true
        
        border.topAnchor.constraint(equalTo:inputAccessoryView!.topAnchor).isActive = true
        border.leftAnchor.constraint(equalTo:inputAccessoryView!.leftAnchor).isActive = true
        border.rightAnchor.constraint(equalTo:inputAccessoryView!.rightAnchor).isActive = true
        border.heightAnchor.constraint(equalToConstant:1).isActive = true
        
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
        delete()
    }
    
    @objc private func header() { insertText("#") }
    @objc private func listing() { insertText("-") }
}
