import AppKit
import VelvetRoom

struct Skin {
    static func appearance(_ appearance:Appearance) -> Skin {
        switch appearance {
        case .system: return system()
        case .light: return light()
        case .dark: return dark()
        }
    }
    
    static func system() -> Skin {
        var skin = Skin()
        skin.background = .textBackgroundColor
        return skin
    }
    
    private static func light() -> Skin {
        var skin = Skin()
        skin.background = .white
        return skin
    }
    
    private static func dark() -> Skin {
        var skin = Skin()
        skin.background = NSColor(red:0.117647, green:0.117647, blue:0.117647, alpha:1)
        return skin
    }
    
    private(set) var background = NSColor()
}
