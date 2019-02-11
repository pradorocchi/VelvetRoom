import UIKit
import VelvetRoom

class Alert {
    static let shared = Alert()
    private weak var view:UIView?
    private weak var bottom:NSLayoutConstraint?
    private var alert = [String]()
    private let messages:[Exception?:String] = [
        Exception.noIcloudToken: .local("Alert.noIcloudToken"),
        Exception.errorWhileLoadingFromIcloud: .local("Alert.errorWhileLoadingFromIcloud"),
        Exception.failedLoadingFromIcloud: .local("Alert.failedLoadingFromIcloud"),
        Exception.unableToSaveToIcloud: .local("Alert.unableToSaveToIcloud"),
        Exception.imageNotValid: .local("Alert.imageNotValid")]
    
    private init() { }
    
    func add(_ error:Error) {
        alert.append(messages[error as? Exception] ?? .local("Alert.unknown"))
        DispatchQueue.main.async { if self.view == nil { self.pop() } }
    }
    
    private func pop() {
        guard !alert.isEmpty else { return }
        let view = UIControl()
        view.addTarget(self, action:#selector(remove), for:.touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red:0.76, green:0.77, blue:0.78, alpha:0.94)
        view.layer.cornerRadius = 6
        view.alpha = 0
        App.shared.view.addSubview(view)
        self.view = view
        
        let message = UILabel()
        message.translatesAutoresizingMaskIntoConstraints = false
        message.font = .systemFont(ofSize:14, weight:.regular)
        message.textColor = .black
        message.numberOfLines = 0
        message.text = alert.removeFirst()
        view.addSubview(message)
        
        view.leftAnchor.constraint(equalTo:App.shared.view.leftAnchor, constant:10).isActive = true
        view.rightAnchor.constraint(equalTo:App.shared.view.rightAnchor, constant:-10).isActive = true
        view.heightAnchor.constraint(equalToConstant:70).isActive = true
        bottom = view.bottomAnchor.constraint(equalTo:App.shared.view.topAnchor)
        bottom!.isActive = true
        
        message.leftAnchor.constraint(equalTo:view.leftAnchor, constant:20).isActive = true
        message.rightAnchor.constraint(equalTo:view.rightAnchor, constant:-20).isActive = true
        message.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        
        App.shared.view.layoutIfNeeded()
        bottom!.constant = 100
        UIView.animate(withDuration:0.4, animations: {
            view.alpha = 1
            App.shared.view.layoutIfNeeded()
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline:.now() + 8) { [weak view] in
                if view != nil && view === self.view {
                    self.remove()
                }
            }
        }
    }
    
    @objc private func remove() {
        bottom?.constant = 0
        UIView.animate(withDuration:0.4, animations: {
            self.view?.alpha = 0
            App.shared.view.layoutIfNeeded()
        }) { _ in
            self.view?.removeFromSuperview()
            self.pop()
        }
    }
}
