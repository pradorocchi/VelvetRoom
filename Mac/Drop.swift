import AppKit

class Drop:NSView {
    private weak var image:NSImageView!
    private let selected:((URL) -> Void)
    
    init(_ image:NSImageView, selected:@escaping((URL) -> Void)) {
        self.selected = selected
        self.image = image
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        if #available(OSX 10.13, *) {
            registerForDraggedTypes([.fileURL])
        } else {
            registerForDraggedTypes([NSPasteboard.PasteboardType(kUTTypeFileURL as String)])
        }
        widthAnchor.constraint(equalToConstant:120).isActive = true
        heightAnchor.constraint(equalToConstant:120).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func draggingEntered(_ sender:NSDraggingInfo) -> NSDragOperation {
        if url(sender).contains(".png") {
            image.image = NSImage(named:"dropOn")
            return .copy
        } else {
            return NSDragOperation()
        }
    }
    
    override func performDragOperation(_ sender:NSDraggingInfo) -> Bool {
        let url = self.url(sender)
        if url.contains(".png") {
            selected(URL(fileURLWithPath:url))
            return true
        }
        return false
    }
    
    override func draggingExited(_:NSDraggingInfo?) {
        image.image = NSImage(named:"dropOff")
    }
    
    override func draggingEnded(_:NSDraggingInfo) {
        image.image = NSImage(named:"dropOff")
    }
    
    private func url(_ sender:NSDraggingInfo) -> String {
        return (sender.draggingPasteboard.propertyList(
            forType:NSPasteboard.PasteboardType(rawValue:"NSFilenamesPboardType")) as! NSArray)[0] as! String
    }
}
