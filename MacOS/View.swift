import AppKit

class View:NSWindow {
    private let presenter = Presenter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .textBackgroundColor
        makeOutlets()
    }
    
    private func makeOutlets() {
        let border = NSView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.wantsLayer = true
        border.layer!.backgroundColor = NSColor.windowBackgroundColor.cgColor
        contentView!.addSubview(border)
        
        border.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:1).isActive = true
        border.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:1).isActive = true
        border.leftAnchor.constraint(equalTo:contentView!.leftAnchor, constant:200).isActive = true
        border.widthAnchor.constraint(equalToConstant:1).isActive = true
    }
    
    @IBAction private func newBoard(_ sender:NSButton) {
        presenter.newBoard()
    }
}
