import UIKit
import VelvetRoom

class Errors {
    private weak var view:UIView?
    private weak var viewBottom:NSLayoutConstraint?
    private var errors = [Error]()
    
    func add(_ error:Error) {
        errors.append(error)
        if view == nil {
            pop()
        }
    }
    
    private func pop() {
        guard !errors.isEmpty else { return }
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white:1, alpha:0.9)
        view.layer.cornerRadius = 6
        view.alpha = 0
        Application.view.view.addSubview(view)
        self.view = view
        
        let message = UILabel()
        message.isUserInteractionEnabled = false
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
        
        switch errors.removeFirst() {
        case Exception.noIcloudToken: message.text = .local("Errors.noIcloudToken")
        case Exception.errorWhileLoadingFromIcloud: message.text = .local("Errors.errorWhileLoadingFromIcloud")
        case Exception.failedLoadingFromIcloud: message.text = .local("Errors.failedLoadingFromIcloud")
        case Exception.unableToSaveToIcloud: message.text = .local("Errors.unableToSaveToIcloud")
        default: message.text = .local("Errors.unknown")
        }
        
        Application.view.view.layoutIfNeeded()
        viewBottom!.constant = 100
        UIView.animate(withDuration:0.4, animations: {
            view.alpha = 1
            Application.view.view.layoutIfNeeded()
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline:.now() + 8) { self.remove() }
        }
    }
    
    private func remove() {
        viewBottom!.constant = 0
        UIView.animate(withDuration:0.4, animations: {
            self.view!.alpha = 0
            Application.view.view.layoutIfNeeded()
        }) { _ in
            self.view?.removeFromSuperview()
            self.pop()
        }
    }
}
