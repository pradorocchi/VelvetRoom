import AppKit

class Toolbar:NSToolbar {
    static private(set) weak var shared:Toolbar!
    @IBOutlet private weak var list:NSButton!
    @IBOutlet private weak var search:NSButton!
    @IBOutlet private weak var delete:NSButton!
    @IBOutlet private weak var export:NSButton!
    @IBOutlet private weak var chart:NSButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Toolbar.shared = self
    }
}
