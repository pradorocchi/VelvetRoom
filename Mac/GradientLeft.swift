import AppKit

class GradientLeft:NSView {
    init() {
        super.init(frame:.zero)
        Skin.add(self, selector:#selector(updateSkin))
    }
    
    required init?(coder:NSCoder) { return nil }
    deinit { NotificationCenter.default.removeObserver(self) }
    
    @objc private func updateSkin() {
        
    }
}
