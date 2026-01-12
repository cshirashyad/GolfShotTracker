import UIKit
import FirebaseCore // Make sure to import FirebaseCore or just Firebase if you prefer

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure() // This line initializes Firebase
        print("Firebase has been configured!") // Optional: for debugging
        return true
    }
}


