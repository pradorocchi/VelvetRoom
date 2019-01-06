import UIKit

@UIApplicationMain class Application:UIResponder, UIApplicationDelegate {
    private(set) static weak var view:View!
    var window:UIWindow?
    
    func application(_:UIApplication, didFinishLaunchingWithOptions:[UIApplication.LaunchOptionsKey:Any]?) -> Bool {
        window = UIWindow(frame:UIScreen.main.bounds)
        window!.backgroundColor = .black
        window!.makeKeyAndVisible()
        window!.rootViewController = View()
        Application.view = window!.rootViewController as? View
        return true
    }
}
