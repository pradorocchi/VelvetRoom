import AppKit

class Menu:NSMenu {
    static private(set) weak var shared:Menu!
    
    var extended = false { willSet {
        find.isEnabled = newValue
        column.isEnabled = newValue
        card.isEnabled = newValue
    } }
    
    @IBOutlet private(set) weak var list:NSMenuItem!
    @IBOutlet private weak var board:NSMenuItem!
    @IBOutlet private weak var column:NSMenuItem!
    @IBOutlet private weak var card:NSMenuItem!
    @IBOutlet private weak var find:NSMenuItem!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Menu.shared = self
        list.target = List.shared
        list.action = #selector(List.shared.toggle)
    }
}
