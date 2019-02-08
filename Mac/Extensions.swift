import AppKit

extension NSFont {
    class func light(_ size:CGFloat) -> NSFont { return NSFont(name:"SFMono-Light", size:size)! }
    class func bold(_ size:CGFloat) -> NSFont { return NSFont(name:"SFMono-Bold", size:size)! }
}

extension NSColor {
    static let velvetBlue = #colorLiteral(red: 0.231372549, green: 0.7215686275, blue: 1, alpha: 1)
}
