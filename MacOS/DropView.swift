import AppKit

class DropView:NSView {
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        registerForDraggedTypes([.png, .pdf, .tiff])
        
        let image = NSImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleNone
        image.image = NSImage(named:"dropOff")
        addSubview(image)
        
        image.topAnchor.constraint(equalTo:topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        image.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        image.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return true
    }
    
    override func draggingEntered(_:NSDraggingInfo) -> NSDragOperation {
        return .copy
    }
    
    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .copy
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return true
    }
    
    override func concludeDragOperation(_ sender: NSDraggingInfo?) {
        NSLog("concludeDragOperation")
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        NSLog("draggingExited")
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo?) {
        NSLog("draggingEnded")
    }
}
