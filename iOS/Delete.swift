import UIKit

class Delete:Sheet {
    private let confirm:(() -> Void)
    
    @discardableResult init(_ confirm:@escaping(() -> Void)) {
        self.confirm = confirm
        super.init()
        
        let delete = Link(.local("Delete.delete"), target:self, selector:#selector(remove))
        addSubview(delete)
        
        let cancel = Link(.local("Delete.cancel"), target:self, selector:#selector(close))
        cancel.backgroundColor = .clear
        cancel.setTitleColor(Skin.shared.text.withAlphaComponent(0.6), for:.normal)
        cancel.setTitleColor(Skin.shared.text.withAlphaComponent(0.15), for:.highlighted)
        addSubview(cancel)
        
        delete.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        delete.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        
        cancel.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        cancel.topAnchor.constraint(equalTo:delete.bottomAnchor, constant:20).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    @objc private func remove() {
        confirm()
        close()
    }
}
