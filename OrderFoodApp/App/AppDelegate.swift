//
//  AppDelegate.swift
//  OrderFoodApp
//
//  Created by Phincon on 30/09/24.
//

import UIKit
import FirebaseAnalytics
import FirebaseCore
import FirebaseStorage
import FirebaseCrashlytics
import IQKeyboardManagerSwift
import netfox
import FLEX

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let myUrlScheme = "com.orderfoodapp"
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setTabbar()
        FirebaseApp.configure()
        
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        // Untuk Swift
        FirebaseConfiguration.shared.setLoggerLevel(.debug)
        IQKeyboardManager.shared.isEnabled = true
        NFX.sharedInstance().start()
        
        //        // Set default language
        //        let language = UserDefaults.standard.string(forKey: "appLanguage") ?? "id"
        //        Bundle.setLanguage(language)
        //
        // Swizzle localization behavior
        Bundle.swizzleLocalization
        
        // Atur bahasa default (misalnya: Bahasa Indonesia)
        if UserDefaults.standard.string(forKey: "appLanguage") == nil {
            UserDefaults.standard.set("id", forKey: "appLanguage")
        }
        Bundle.main.currentLanguage = UserDefaults.standard.string(forKey: "appLanguage")
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    private func setTabbar() {
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000.0, vertical: 0.0), for: .default)
        
    }
    
//    func application(_ app: UIApplication, open url: URL,
//                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        print(url.absoluteString)
//        return true
//    }
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        guard let scheme = url.scheme, scheme == "deeplink" else { return false }
//        guard let host = url.host else { return false }
//        
//        if host == "page1" {
//            // Navigasi ke halaman tertentu
//            //navigateToPage1()
//            print("Navigate to other Page")
//        }
//        return true
//    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let deepLink = DeepLinkManager.shared.handleDeepLink(url) {
            DeepLinkManager.shared.navigateToDeepLink(deepLink)
            return true
        }
        return false
    }
    
    
    
    
}

