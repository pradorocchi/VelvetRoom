import AppKit
import VelvetRoom

class Alert {
    private weak var view:NSView?
    private weak var viewBottom:NSLayoutConstraint?
    private var alert = [Error]()
    
    func add(_ error:Error) {
        alert.append(error)
        if view == nil {
            pop()
        }
    }
    
    private func pop() {
        guard !alert.isEmpty else { return }
        let view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsLayer = true
        view.layer!.backgroundColor = NSColor.windowFrameColor.withAlphaComponent(0.98).cgColor
        view.layer!.cornerRadius = 6
        view.alphaValue = 0
        Application.view.contentView!.addSubview(view)
        self.view = view
        
        let message = NSTextField()
        message.translatesAutoresizingMaskIntoConstraints = false
        message.backgroundColor = .clear
        message.isBezeled = false
        message.isEditable = false
        message.font = .systemFont(ofSize:16, weight:.regular)
        message.textColor = .windowFrameTextColor
        view.addSubview(message)
        
        viewBottom = view.bottomAnchor.constraint(equalTo:Application.view.contentView!.topAnchor)
        view.leftAnchor.constraint(equalTo:Application.view.contentView!.leftAnchor, constant:10).isActive = true
        view.rightAnchor.constraint(equalTo:Application.view.contentView!.rightAnchor, constant:-10).isActive = true
        view.heightAnchor.constraint(equalToConstant:60).isActive = true
        viewBottom!.isActive = true
        
        message.leftAnchor.constraint(equalTo:view.leftAnchor, constant:20).isActive = true
        message.rightAnchor.constraint(equalTo:view.rightAnchor, constant:-20).isActive = true
        message.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        
        switch alert.removeFirst() {
        case Exception.noIcloudToken: message.stringValue = .local("Alert.noIcloudToken")
        case Exception.errorWhileLoadingFromIcloud: message.stringValue = .local("Alert.errorWhileLoadingFromIcloud")
        case Exception.failedLoadingFromIcloud: message.stringValue = .local("Alert.failedLoadingFromIcloud")
        case Exception.unableToSaveToIcloud: message.stringValue = .local("Alert.unableToSaveToIcloud")
        case Exception.imageNotValid: message.stringValue = .local("Alert.imageNotValid")
        default: message.stringValue = .local("Alert.unknown")
        }
        
        Application.view.contentView!.layoutSubtreeIfNeeded()
        viewBottom!.constant = 100
        if #available(OSX 10.12, *) {
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.6
                context.allowsImplicitAnimation = true
                view.alphaValue = 1
                Application.view.contentView!.layoutSubtreeIfNeeded()
            }) {
                DispatchQueue.main.asyncAfter(deadline:.now() + 8) { self.remove() }
            }
        }
    }
    
    private func remove() {
        viewBottom!.constant = 0
        if #available(OSX 10.12, *) {
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.6
                context.allowsImplicitAnimation = true
                view!.alphaValue = 0
                Application.view.contentView!.layoutSubtreeIfNeeded()
            }) {
                self.view?.removeFromSuperview()
                self.pop()
            }
        }
    }
}
