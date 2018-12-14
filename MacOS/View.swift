import AppKit

class View:NSWindow {
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .textBackgroundColor
        makeOutlets()
    }
    
    private func makeOutlets() {
        let board = BoardView("Roadmap")
        contentView!.addSubview(board)
        
        let border = NSView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.wantsLayer = true
        border.layer!.backgroundColor = NSColor.windowBackgroundColor.cgColor
        contentView!.addSubview(border)
        
        let column = ColumnView("Do")
        contentView!.addSubview(column)
        
        let columnB = ColumnView("Progress")
        contentView!.addSubview(columnB)
        
        let columnC = ColumnView("Done")
        contentView!.addSubview(columnC)
        
        board.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:50).isActive = true
        board.leftAnchor.constraint(equalTo:contentView!.leftAnchor, constant:1).isActive = true
        board.rightAnchor.constraint(equalTo:border.leftAnchor).isActive = true
        
        border.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:1).isActive = true
        border.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:1).isActive = true
        border.leftAnchor.constraint(equalTo:contentView!.leftAnchor, constant:200).isActive = true
        border.widthAnchor.constraint(equalToConstant:1).isActive = true
        
        column.topAnchor.constraint(equalTo:border.topAnchor, constant:40).isActive = true
        column.leftAnchor.constraint(equalTo:border.leftAnchor, constant:40).isActive = true
        
        columnB.topAnchor.constraint(equalTo:column.topAnchor).isActive = true
        columnB.leftAnchor.constraint(equalTo:column.rightAnchor, constant:40).isActive = true
        
        columnC.topAnchor.constraint(equalTo:column.topAnchor).isActive = true
        columnC.leftAnchor.constraint(equalTo:columnB.rightAnchor, constant:40).isActive = true
    }
}
