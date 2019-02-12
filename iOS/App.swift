import UIKit
import VelvetRoom

@UIApplicationMain class App:UIViewController, UIApplicationDelegate {
    static private(set) weak var shared:App!
    var window:UIWindow?
    var margin = UIEdgeInsets.zero
    private weak var splash:Splash?
    
    func application(_:UIApplication, didFinishLaunchingWithOptions:[UIApplication.LaunchOptionsKey:Any]?) -> Bool {
        window = UIWindow(frame:UIScreen.main.bounds)
        window!.makeKeyAndVisible()
        window!.rootViewController = self
        App.shared = self
        return true
    }
    
    override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.viewSafeAreaInsetsDidChange()
            margin = view.safeAreaInsets
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) { margin = view.safeAreaInsets }
        
        let splash = Splash()
        view.addSubview(splash)
        self.splash = splash
        
        splash.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        splash.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        splash.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        splash.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        Repository.shared.error = { Alert.shared.add($0) }
        Skin.add(self)
        DispatchQueue.global(qos:.background).async {
            Repository.shared.load()
            DispatchQueue.main.async {
                self.outlets()
                DispatchQueue.global(qos:.background).async {
                    Skin.update()
                }
            }
        }
    }
    
    override func viewWillTransition(to:CGSize, with:UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:to, with:with)
        if List.shared.right.constant > 0 {
            List.shared.right.constant = to.width
        }
    }
    
    private func outlets() {
        let list = List.shared
        let canvas = Canvas.shared
        let gradientTop = Gradient([0, 1])
        let gradientBottom = Gradient([1, 0])
        let progress = Progress.shared
        let search = SearchView.shared
        
        view.addSubview(list)
        view.addSubview(canvas)
        view.addSubview(gradientTop)
        view.addSubview(gradientBottom)
        view.addSubview(progress)
        view.addSubview(search)
        
        gradientTop.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        gradientTop.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        gradientTop.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        gradientTop.heightAnchor.constraint(equalToConstant:60).isActive = true
        
        gradientBottom.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        gradientBottom.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        gradientBottom.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        gradientBottom.heightAnchor.constraint(equalToConstant:20).isActive = true
        
        list.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        list.widthAnchor.constraint(equalTo:view.widthAnchor).isActive = true
        
        canvas.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        canvas.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        canvas.widthAnchor.constraint(equalTo:view.widthAnchor).isActive = true
        canvas.rightAnchor.constraint(equalTo:list.leftAnchor).isActive = true
        
        progress.bottomAnchor.constraint(equalTo:view.bottomAnchor, constant:-10).isActive = true
        progress.leftAnchor.constraint(equalTo:view.leftAnchor, constant:5).isActive = true
        progress.rightAnchor.constraint(equalTo:view.rightAnchor, constant:-5).isActive = true
        
        search.leftAnchor.constraint(equalTo:view.leftAnchor, constant:10).isActive = true
        search.rightAnchor.constraint(equalTo:view.rightAnchor, constant:-10).isActive = true
    }
    
    @objc private func updateSkin() {
        view.backgroundColor = Skin.shared.background
    }
    
    @objc private func help() {
        UIApplication.shared.keyWindow!.endEditing(true)
        present(HelpView(), animated:true)
    }
    
    @objc private func settings() {
        UIApplication.shared.keyWindow!.endEditing(true)
        present(SettingsView(), animated:true)
    }
    
    @objc private func new() {
        UIApplication.shared.keyWindow!.endEditing(true)
        present(NewView(), animated:true)
    }
    
//    @objc private func chart() {
//        UIApplication.shared.keyWindow!.endEditing(true)
//        present(ChartView(selected!), animated:true)
//    }
}
