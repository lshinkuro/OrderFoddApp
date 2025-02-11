//
//  DeepLinkManager.swift
//  OrderFoodApp
//
//  Created by Phincon on 13/12/24.
//


import UIKit

class DeepLinkManager {
    
    static let shared = DeepLinkManager()
    
    enum DeepLink {
        case product(id: String)
        case profile(username: String)
        case message(conversationId: String)
    }
    
    func handleDeepLink(_ url: URL) -> DeepLink? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return nil
        }
        
        switch components.host {
        case "product":
            return components.queryItems?.first(where: { $0.name == "id" })
                .map { .product(id: $0.value ?? "") }
        case "profile":
            return components.queryItems?.first(where: { $0.name == "username" })
                .map { .profile(username: $0.value ?? "") }
        case "message":
            return components.queryItems?.first(where: { $0.name == "conversationId" })
                .map { .message(conversationId: $0.value ?? "") }
        default:
            return nil
        }
    }
    
    func navigateToDeepLink(_ deepLink: DeepLink) {
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        switch deepLink {
        case .product(let id):
            navigateToProductDetail(id: id, from: rootViewController)
        case .profile(let username):
            navigateToProfile(username: username, from: rootViewController)
        case .message(let conversationId):
            navigateToMessage(conversationId: conversationId, from: rootViewController)
        }
    }

}

extension DeepLinkManager {
    private func navigateToProductDetail(id: String, from viewController: UIViewController) {
        let productVC = ProductDetailViewController()
        productVC.productId = id
        
        DispatchQueue.main.async {
            if let navigationController = viewController as? UINavigationController {
                navigationController.pushViewController(productVC, animated: true)
            } else if let tabBarController = viewController as? UITabBarController {
                tabBarController.selectedViewController?
                    .navigationController?
                    .pushViewController(productVC, animated: true)
            }
        }
    }
    
    private func navigateToProfile(username: String, from viewController: UIViewController) {
        let profileVC = ProfileViewController()
        
        DispatchQueue.main.async {
            if let navigationController = viewController as? UINavigationController {
                navigationController.pushViewController(profileVC, animated: true)
            } else if let tabBarController = viewController as? UITabBarController {
                tabBarController.selectedViewController?
                    .navigationController?
                    .pushViewController(profileVC, animated: true)
            }
        }
    }
    
    private func navigateToMessage(conversationId: String, from viewController: UIViewController) {
        let messageVC = MessageViewController()
        messageVC.conversationId = conversationId
        
        DispatchQueue.main.async {
            if let navigationController = viewController as? UINavigationController {
                navigationController.pushViewController(messageVC, animated: true)
            } else if let tabBarController = viewController as? UITabBarController {
                tabBarController.selectedViewController?
                    .navigationController?
                    .pushViewController(messageVC, animated: true)
            }
        }
    }
}

class ProductDetailViewController: UIViewController {
    var productId: String = ""
}

class MessageViewController: UIViewController {
    var conversationId: String = ""
}

class ProfilesViewController: UIViewController {
    var username: String = ""
    
    func nav() {
        
        let url = URL(string: "myapp://product?id=123")!
        if let deepLink = DeepLinkManager.shared.handleDeepLink(url) {
            DeepLinkManager.shared.navigateToDeepLink(deepLink)
        }
        
    }
}



