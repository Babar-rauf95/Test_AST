//
//  SceneDelegate.swift
//  FoodOrdering
//
//  Created by M Usman Bin Rehan on 16/03/2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    static let shared = SceneDelegate()
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
         
         // Create a new UIWindow with the scene
         self.window = UIWindow(windowScene: windowScene)
         self.changeRootViewController()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

//MARK: - Application Flow
extension SceneDelegate {
    func changeRootViewController() {
        let session = CoreDataManager.shared.getUserSession()
        if let _ = session {
            print("User is logged in")
            self.showHome()
            
        } else {
            print("No active session, show login screen")
            self.showLogin()
        }
    }
    
    func resetWindow(to viewController: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = viewController
        self.window = window
        window.makeKeyAndVisible()
    }

    private func showLogin (){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = sb.instantiateViewController(withIdentifier: LoginVC.name) as! LoginVC
        
        let viewModel = LoginViewModel(delegate: vc)
        vc.setupViewModel(viewModel: viewModel)
        
        let nvc = UINavigationController(rootViewController: vc)
        
        self.resetWindow(to: nvc)
    }
    private func showHome (){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = sb.instantiateViewController(withIdentifier: ResturantVC.name) as! ResturantVC
        
        let viewModel = RestaurantViewModel(delegate: vc)
        vc.setupViewModel(viewModel: viewModel)
        
        let nvc = UINavigationController(rootViewController: vc)
        
        self.resetWindow(to: nvc)
    }
}
