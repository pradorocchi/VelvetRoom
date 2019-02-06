import AppKit

class Menu:NSMenu {
    static private(set) weak var shared:Menu!
    @IBOutlet private weak var list:NSMenuItem!
    @IBOutlet private weak var column:NSMenuItem!
    @IBOutlet private weak var card:NSMenuItem!
    @IBOutlet private weak var find:NSMenuItem!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Menu.shared = self
    }
}
