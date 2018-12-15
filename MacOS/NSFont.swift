import AppKit

extension NSFont {
    class func light(_ size:CGFloat) -> NSFont { return NSFont(name:"SFMono-Light", size:size)! }
    class func lightItalic(_ size:CGFloat) -> NSFont { return NSFont(name:"SFMono-LightItalic", size:size)! }
    class func regular(_ size:CGFloat) -> NSFont { return NSFont(name:"SFMono-Regular", size:size)! }
    class func regularItalic(_ size:CGFloat) -> NSFont { return NSFont(name:"SFMono-RegularItalic", size:size)! }
    class func bold(_ size:CGFloat) -> NSFont { return NSFont(name:"SFMono-Bold", size:size)! }
    class func boldItalic(_ size:CGFloat) -> NSFont { return NSFont(name:"SFMono-BoldItalic", size:size)! }
}
