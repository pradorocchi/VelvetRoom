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
        string.indices.reduce(into: (string.startIndex, text!, [(NSFont, Range)]()) ) {
            if string.index(after:$1) == string.endIndex {
                $0.2.append((string[$1] == "#" ? header : $0.1, $0.0 ..< string.index(after:$1)))
            } else if string[$1] == "#" || string[$1] == "\n" {
                $0.2.append(($0.1, $0.0 ..< $1))
                $0.0 = $1
                $0.1 = string[$1] == "#" ? header : text
            } }.2.forEach { storage.addAttribute(.font, value:$0.0, range:NSRange($0.1, in:string)) }
    }
}
