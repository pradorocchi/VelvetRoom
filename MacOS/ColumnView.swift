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
        name.drawsBackground = false
        name.isBezeled = false
        name.focusRingType = .none
        name.font = .bold(18)
        name.stringValue = column.name
        name.alphaValue = 0.4
        name.maximumNumberOfLines = 1
        addSubview(name)
        self.name = name
        
        name.topAnchor.constraint(equalTo:topAnchor).isActive = true
        name.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        name.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        name.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
}
