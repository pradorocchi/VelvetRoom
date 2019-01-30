import AppKit

class ProgressSliceView:NSView {
    var width:NSLayoutConstraint?
    
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer!.backgroundColor = Application.skin.text.withAlphaComponent(0.2).cgColor
    }
    
    required init?(coder:NSCoder) { return nil }
}
