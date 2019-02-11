import UIKit
import VelvetRoom

struct Skin {
    static var shared = Skin() { didSet {
        DispatchQueue.main.async { NotificationCenter.default.post(name:name, object:nil) } } }
    private static let name = Notification.Name("skin")
    
    static func add(_ observer:Any, selector:Selector) {
        NotificationCenter.default.addObserver(observer, selector:selector, name:Skin.name, object:nil)
    }
    
    static func update() {
        update(Repository.shared.account.appearance, font:Repository.shared.account.font)
    }
    
    static func update(_ appearance:Appearance, font:Int) {
        var skin:Skin
        switch appearance {
        case .light: skin = light()
        default: skin = Skin()
        }
        skin.font = CGFloat(font)
        shared = skin
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
