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
        skin.background = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        skin.text = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return skin
    }
    
    private static func dark() -> Skin {
        var skin = Skin()
        skin.background = #colorLiteral(red: 0.1215686275, green: 0.1450980392, blue: 0.1647058824, alpha: 1)
        skin.text = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return skin
    }
    
    private(set) var background = NSColor.textBackgroundColor
    private(set) var text = NSColor.textColor
}
