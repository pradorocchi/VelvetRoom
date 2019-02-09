import AppKit

class Toolbar:NSToolbar {
    static private(set) weak var shared:Toolbar!
    var enabled = false { didSet { validate() } }
    var extended = false { didSet { validate() } }
    @IBOutlet private(set) weak var list:NSButton!
    @IBOutlet private weak var settings:NSButton!
    @IBOutlet private weak var search:NSButton!
    @IBOutlet private weak var delete:NSButton!
    @IBOutlet private weak var chart:NSButton!
    @IBOutlet private weak var export:NSButton!
    @IBOutlet private weak var load:NSButton!
    @IBOutlet private weak var new:NSButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Toolbar.shared = self
        list.target = List.shared
        list.action = #selector(List.shared.toggle)
        settings.target = self
        settings.action = #selector(openSettings)
        delete.target = self
        delete.action = #selector(deleteBoard)
    }
    
    private func validate() {
        list.isEnabled = enabled
        settings.isEnabled = enabled
        search.isEnabled = enabled && extended
        delete.isEnabled = enabled && extended
        chart.isEnabled = enabled && extended
        export.isEnabled = enabled && extended
        load.isEnabled = enabled
        new.isEnabled = enabled
    }
    
    @objc func newBoard() {
        Window.shared.makeFirstResponder(nil)
        Window.shared.beginSheet(NewView())
    }
    
    @objc private func openSettings() {
        Settings()
    }
    
    @objc private func openChart() {
        Window.shared.makeFirstResponder(nil)
        Window.shared.beginSheet(ChartView(List.shared.current!.board))
    }
    
    @objc private func deleteBoard() {
        List.shared.current?.delete()
    }
}
