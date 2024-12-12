

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
    
}

@main
struct PhotoEditor1_0App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var canvasVM = CanvasViewModel()
    @StateObject private var viewModel = AuthViewModel()
    var body: some Scene {
        WindowGroup {
            
                LogInView()
           
                    .environmentObject(viewModel)
                    .environmentObject(canvasVM)
                   
        }
    }
}
