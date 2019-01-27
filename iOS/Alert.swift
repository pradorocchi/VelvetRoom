import UIKit
import VelvetRoom

class Alert {
    private weak var view:UIView?
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
        let view = UIControl()
        view.addTarget(self, action:#selector(remove), for:.touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red:0.76, green:0.77, blue:0.78, alpha:0.94)
        view.layer.cornerRadius = 6
        view.alpha = 0
        Application.view.view.addSubview(view)
        self.view = view
        
        let message = UILabel()
        message.translatesAutoresizingMaskIntoConstraints = false
        message.font = .systemFont(ofSize:14, weight:.regular)
        message.textColor = .black
        message.numberOfLines = 0
        view.addSubview(message)
        
        viewBottom = view.bottomAnchor.constraint(equalTo:Application.view.view.topAnchor)
        view.leftAnchor.constraint(equalTo:Application.view.view.leftAnchor, constant:10).isActive = true
        view.rightAnchor.constraint(equalTo:Application.view.view.rightAnchor, constant:-10).isActive = true
        view.heightAnchor.constraint(equalToConstant:70).isActive = true
        viewBottom!.isActive = true
        
        message.leftAnchor.constraint(equalTo:view.leftAnchor, constant:20).isActive = true
        message.rightAnchor.constraint(equalTo:view.rightAnchor, constant:-20).isActive = true
        message.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        
        switch alert.removeFirst() {
        case Exception.noIcloudToken: message.text = .local("Alert.noIcloudToken")
        case Exception.errorWhileLoadingFromIcloud: message.text = .local("Alert.errorWhileLoadingFromIcloud")
        case Exception.failedLoadingFromIcloud: message.text = .local("Alert.failedLoadingFromIcloud")
        case Exception.unableToSaveToIcloud: message.text = .local("Alert.unableToSaveToIcloud")
        case Exception.imageNotValid: message.text = .local("Alert.imageNotValid")
        default: message.text = .local("Alert.unknown")
        }
        
        Application.view.view.layoutIfNeeded()
        viewBottom!.constant = 100
        UIView.animate(withDuration:0.4, animations: {
            view.alpha = 1
            Application.view.view.layoutIfNeeded()
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline:.now() + 8) { [weak view] in
                if view != nil && view === self.view {
                    self.remove()
                }
            }
        }
    }
    
    @objc private func remove() {
        viewBottom?.constant = 0
        UIView.animate(withDuration:0.4, animations: {
            self.view?.alpha = 0
            Application.view.view.layoutIfNeeded()
        }) { _ in
            self.view?.removeFromSuperview()
            self.pop()
        }
    }
}
