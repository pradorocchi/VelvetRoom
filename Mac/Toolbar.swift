import AppKit

class Toolbar:NSToolbar {
    static private(set) weak var shared:Toolbar!
    
    var extended = false { willSet {
        delete.isEnabled = newValue
        search.isEnabled = newValue
        export.isEnabled = newValue
        chart.isEnabled = newValue
    } }
    
    @IBOutlet private(set) weak var list:NSButton!
    @IBOutlet private weak var search:NSButton!
    @IBOutlet private weak var delete:NSButton!
    @IBOutlet private weak var export:NSButton!
    @IBOutlet private weak var chart:NSButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Toolbar.shared = self
        list.target = List.shared
        list.action = #selector(List.shared.toggle)
    }
}
