//
//  RemoteConfigManager.swift
//  OrderFoodApp
//
//  Created by Phincon on 09/10/24.
//

import Foundation
import FirebaseRemoteConfig
import Foundation

class RemoteConfigManager {
    
    static let shared = RemoteConfigManager()
    private var remoteConfig: RemoteConfig
    
    // Example of remote config values
    var welcomeMessage: String = "Welcome!"
    var featureEnabled: Bool = false
    var generalBackroundColor: String = "#000000"
    var versionApp: String = ""
    
    private init() {
        remoteConfig = RemoteConfig.remoteConfig()
        let defaults: [String: NSObject] = [
            "welcome_message": "Welcome to my app!" as NSObject,
            "feature_enabled": false as NSObject,
            "general_background_color": "#000000" as NSObject,
            "version_app": "" as NSObject
        ]
        remoteConfig.setDefaults(defaults)
        loadFromCache()
    }
    
    // Function to fetch and store remote config values
    func fetchAndStoreRemoteConfig() {
        // Set the minimum fetch interval for development (set higher for production)
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0 // For development purposes
        remoteConfig.configSettings = settings
        
        // Fetch remote config data
        remoteConfig.fetch { [weak self] (status, error) in
            guard let self = self else { return }
            if status == .success {
                print("Remote config fetched successfully!")
                
                // Activate fetched values
                self.remoteConfig.activate { (changed, error) in
                    
                    guard error == nil else {
                        print("Error activating remote config")
                        return}

                    let welcomeMessage = self.remoteConfig["welcome_message"].stringValue
                    let featureEnabled = self.remoteConfig["feature_enabled"].boolValue
                    let generalBackgroundColor = self.remoteConfig["general_background_color"].stringValue
                    
                    let versionApp = self.remoteConfig["version_app"].stringValue
                    
                    self.updateConfig(welcomeMessage: welcomeMessage,
                                      featureEnabled: featureEnabled,
                                      generalBackgroundColor: generalBackgroundColor, versionApp: versionApp)
                }
            } else {
                print("Failed to fetch remote config: \(error?.localizedDescription ?? "No error")")
            }
        }
    }
    
    // Update singleton values and save to cache
    private func updateConfig(welcomeMessage: String,
                              featureEnabled: Bool,
                              generalBackgroundColor: String,
                              versionApp: String) {
        self.welcomeMessage = welcomeMessage
        self.featureEnabled = featureEnabled
        self.generalBackroundColor = generalBackgroundColor
        self.versionApp = versionApp
        
        // Save values to UserDefaults as cache
        UserDefaults.standard.set(welcomeMessage, forKey: "welcome_message")
        UserDefaults.standard.set(featureEnabled, forKey: "feature_enabled")
        UserDefaults.standard.set(generalBackgroundColor, forKey: "general_background_color")
        UserDefaults.standard.set(versionApp, forKey: "version_app")
        
    }
    
    // Load cached values from UserDefaults
    private func loadFromCache() {
        self.welcomeMessage = UserDefaults.standard.string(forKey: "welcome_message") ?? "Welcome!"
        self.featureEnabled = UserDefaults.standard.bool(forKey: "feature_enabled")
        self.generalBackroundColor = UserDefaults.standard.string(forKey: "general_background_color") ?? "#000000"
        self.versionApp = UserDefaults.standard.string(forKey: "version_app") ?? ""
    }
    
    
}
