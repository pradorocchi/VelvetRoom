import AppKit

class Storage:NSTextStorage {
    var text:NSFont!
    var header:NSFont!
    override var string:String { return storage.string }
    private let storage = NSTextStorage()
    
    override func attributes(at:Int, effectiveRange:NSRangePointer?) -> [NSAttributedString.Key:Any] {
        return storage.attributes(at:at, effectiveRange:effectiveRange)
    }
    
    override func replaceCharacters(in range:NSRange, with:String) {
        storage.replaceCharacters(in:range, with:with)
        edited(.editedCharacters, range:range, changeInLength:(with as NSString).length - range.length)
    }
    
    override func setAttributes(_ attrs:[NSAttributedString.Key:Any]?, range:NSRange) {
        storage.setAttributes(attrs, range:range)
    }
    
    override func processEditing() {
        super.processEditing()
        storage.removeAttribute(.font, range:NSMakeRange(0, storage.length))
        var start = string.startIndex
        while let index = string[start...].firstIndex(of:"#") {
            storage.addAttribute(.font, value:text, range:NSRange(start ..< index, in:string))
            if let endHeading = string[index...].firstIndex(of:"\n") {
                storage.addAttribute(.font, value:header, range:NSRange(index ... endHeading, in:string))
                start = endHeading
            } else {
                storage.addAttribute(.font, value:header, range:NSRange(index..., in:string))
                start = string.endIndex
            }
        }
        storage.addAttribute(.font, value:text, range:NSRange(start..., in:string))
    }
}
