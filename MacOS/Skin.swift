import AppKit
import VelvetRoom

struct Skin {
    static func appearance(_ appearance:Appearance) -> Skin {
        switch appearance {
        case .system: return Skin()
        case .light: return light()
        case .dark: return dark()
        }
    }
    
    private static func light() -> Skin {
        var skin = Skin()
        skin.background = .white
        skin.text = NSColor(red:0, green:0, blue:0, alpha:1)
        return skin
    }
    
    private static func dark() -> Skin {
        var skin = Skin()
        skin.background = NSColor(red:0.117647, green:0.117647, blue:0.117647, alpha:1)
        skin.text = NSColor(red:1, green:1, blue:1, alpha:1)
        skin.windowFrame = NSColor(red:0.666667, green:0.666667, blue:0.666667, alpha:1)
        skin.windowFrameText = NSColor(red:1, green:1, blue:1, alpha:0.847059)
        skin.selectedTextBackground = NSColor(red:0.247059, green:0.388235, blue:0.545098, alpha:1)
        return skin
    }
    
    private(set) var background = NSColor.textBackgroundColor
    private(set) var text = NSColor.textColor
    private(set) var windowFrame = NSColor.windowFrameTextColor
    private(set) var windowFrameText = NSColor.windowFrameTextColor
    private(set) var selectedTextBackground = NSColor.selectedTextBackgroundColor
}
