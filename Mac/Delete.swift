import AppKit

class Delete:Sheet {
    private let confirm:(() -> Void)
    
    @discardableResult init(_ name:String, confirm:@escaping(() -> Void)) {
        self.confirm = confirm
        super.init()
        let message = Label(name, font:.systemFont(ofSize:22, weight:.bold))
        addSubview(message)
        
        let cancel = Link(.local("Delete.cancel"))
        cancel.target = self
        cancel.action = #selector(close)
        addSubview(cancel)
        
        let delete = Button(.local("Delete.delete"))
        delete.target = self
        delete.action = #selector(self.delete)
        delete.keyEquivalent = "\r"
        addSubview(delete)
        
        message.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        message.bottomAnchor.constraint(equalTo:delete.topAnchor, constant:-20).isActive = true
        
        cancel.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        cancel.topAnchor.constraint(equalTo:delete.bottomAnchor, constant:20).isActive = true
        
        delete.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        delete.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    @objc private func delete() {
        confirm()
        close()
    }
}
