import UIKit
import VelvetRoom

struct Skin {
    static func appearance(_ appearance:Appearance) -> Skin {
        switch appearance {
        case .light: return light()
        default: return Skin()
        }
    }
    
    private static func light() -> Skin {
        var skin = Skin()
        skin.background = .white
        skin.over = .velvetLight
        skin.text = .black
        skin.scroll = .black
        skin.keyboard = .light
        return skin
    }
    
    private(set) var background = UIColor.black
    private(set) var over = UIColor.velvetShade
    private(set) var text = UIColor.white
    private(set) var scroll = UIScrollView.IndicatorStyle.white
    private(set) var keyboard = UIKeyboardAppearance.dark
}
