import AppKit

class DropView:NSView {
    weak var image:NSImageView!
    
    init(_ image:NSImageView) {
        super.init(frame:.zero)
        self.image = image
        translatesAutoresizingMaskIntoConstraints = false
        if #available(OSX 10.13, *) {
            registerForDraggedTypes([.fileURL])
        } else {
            registerForDraggedTypes([NSPasteboard.PasteboardType(kUTTypeFileURL as String)])
        }
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
            print(URL(fileURLWithPath:url))
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
