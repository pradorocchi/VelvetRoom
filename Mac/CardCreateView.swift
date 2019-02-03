import AppKit

class CardCreateView:CreateView {
    override init(_ selector:Selector) {
        super.init(selector)
        let button = NSButton()
        button.title = String()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isBordered = false
        button.target = self
        button.action = #selector(shortcut)
        button.keyEquivalent = "n"
        button.keyEquivalentModifierMask = [.shift, .command]
        addSubview(button)
    }
    
    required init?(coder:NSCoder) { return nil }
    
    @objc private func shortcut() {
        Application.view.perform(selector)
    }
}
