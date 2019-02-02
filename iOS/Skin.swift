import UIKit
import VelvetRoom

struct Skin {
    static func add(_ observer:Any, selector:Selector) {
        NotificationCenter.default.addObserver(observer, selector:selector, name:.init("skin"), object:nil)
    }
    
    static func post() {
        DispatchQueue.main.async { NotificationCenter.default.post(name:.init("skin"), object:nil) }
    }
    
    static func appearance(_ appearance:Appearance, font:Int) -> Skin {
        var skin:Skin
        switch appearance {
        case .light: skin = light()
        default: skin = Skin()
        }
        skin.font = CGFloat(font)
        return skin
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
    var font = CGFloat(14)
}
