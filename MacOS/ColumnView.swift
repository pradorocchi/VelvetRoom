import AppKit
import VelvetRoom

class ColumnView:NSControl {
    let index:Int
    private(set) var column:Column!
    private weak var name:NSTextField!
    
    init(_ column:Column, index:Int) {
        self.column = column
        self.index = index
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let name = NSTextField()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.backgroundColor = .clear
        name.isBezeled = false
        name.isEditable = false
        name.font = .bold(18)
        name.stringValue = column.name
        name.alphaValue = 0.4
        name.maximumNumberOfLines = 1
        addSubview(name)
        self.name = name
        
        name.topAnchor.constraint(equalTo:topAnchor, constant:30).isActive = true
        name.bottomAnchor.constraint(equalTo:bottomAnchor, constant:-30).isActive = true
        name.leftAnchor.constraint(equalTo:leftAnchor, constant:30).isActive = true
        name.rightAnchor.constraint(equalTo:rightAnchor, constant:-30).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
}
