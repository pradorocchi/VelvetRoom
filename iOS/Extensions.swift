import UIKit

extension UIColor {
    static let velvetBlue = #colorLiteral(red: 0.231372549, green: 0.7215686275, blue: 1, alpha: 1)
    static let velvetShade = #colorLiteral(red: 0.1176470588, green: 0.137254902, blue: 0.1568627451, alpha: 1)
    static let velvetLight = #colorLiteral(red: 0.9019607843, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
}

extension UIFont {
    class func light(_ size:CGFloat) -> UIFont { return UIFont(name:"SFMono-Light", size:size)! }
    class func bold(_ size:CGFloat) -> UIFont { return UIFont(name:"SFMono-Bold", size:size)! }
}
