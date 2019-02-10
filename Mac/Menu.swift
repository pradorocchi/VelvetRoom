import AppKit

class Menu:NSMenu {
    static private(set) weak var shared:Menu!
    var enabled = true { didSet { validate() } }
    var extended = false { didSet { validate() } }
    
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
        find.target = Search.shared
        find.action = #selector(Search.shared.active)
        board.target = Window.shared
        board.action = #selector(Window.shared.newBoard)
        column.target = Canvas.shared
        column.action = #selector(Canvas.shared.newColumn)
        card.target = Canvas.shared
        card.action = #selector(Canvas.shared.newCard)
    }
    
    private func validate() {
        list.isEnabled = enabled
        find.isEnabled = enabled && extended
        column.isEnabled = enabled && extended
        card.isEnabled = enabled && extended
    }
}
