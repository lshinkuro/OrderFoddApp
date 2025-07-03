//
//  SceneDelegate.swift
//  OrderFoodApp
//
//  Created by Phincon on 30/09/24.
//

import UIKit
import MidtransKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var coordinator: MainCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        setupMidtransConfig()
        
        RemoteConfigManager.shared.fetchAndStoreRemoteConfig()

        // MARK: methode use main coordinator
        let navController = UINavigationController()
        coordinator = MainCoordinator(navigationController: navController, window: window)
        coordinator?.start()
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        
        /*if let tokenData = KeychainHelper.shared.read(forKey: KeychainHelperKey.firebaseAuthToken),
           let _ = String(data: tokenData, encoding: .utf8) {
            let tabBar = MainTabBarController()
            tabBar.modalPresentationStyle = .fullScreen
            let navigation = UINavigationController(rootViewController: tabBar)
            window?.rootViewController = navigation
            UINavigationBar.appearance().isHidden = false
            
        } else {
            let vc = OnBoardingViewController()
            let navigation = UINavigationController(rootViewController: vc)
            window?.rootViewController = navigation
        }*/
        
        /*AppSettings.shared.isFirstTime = true
         if AppSettings.shared.isFirstTime {
         let vc = OnBoardingViewController()
         let navigation = UINavigationController(rootViewController: vc)
         window.rootViewController = navigation
         window.makeKeyAndVisible()
         self.window = window
         } else {
         let tabBar = MainTabBarController()
         tabBar.modalPresentationStyle = .fullScreen
         
         let navigation = UINavigationController(rootViewController: tabBar)
         window.rootViewController = navigation
         window.makeKeyAndVisible()
         self.window = window
         UINavigationBar.appearance().isHidden = false
         }*/
    }
    
    private func setupMidtransConfig() {
        MidtransConfig.shared().setClientKey("SB-Mid-client-DMzFzhAUqMIxUcTC", environment: .sandbox, merchantServerURL:"https://merchant-url-sandbox.com"
      )

        //enable logger for debugging purpose
      MidtransNetworkLogger.shared()?.startLogging()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
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
    }
    
    // Handle logout and navigate to onboarding
    func handleLogout() {
        // Remove the Firebase Auth token from Keychain
        KeychainHelper.shared.delete(forKey: "firebaseAuthToken")
        
        // Navigate to the onboarding screen
        /*let vc = OnBoardingViewController()
        let navigation = UINavigationController(rootViewController: vc)
        window?.rootViewController = navigation*/
        
        
        let navController = UINavigationController()
        coordinator = MainCoordinator(navigationController: navController, window: window)
        coordinator?.start()
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
    
    
}

