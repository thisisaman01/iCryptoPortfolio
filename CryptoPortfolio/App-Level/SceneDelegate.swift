//
//  SceneDelegate.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//


import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        // Setup theme manager
        ThemeManager.shared.setupInitialTheme()
        
        // Configure initial view controller
        configureInitialViewController()
    }
    
    private func configureInitialViewController() {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        let rootViewController: UIViewController
        
        if hasSeenOnboarding {
            rootViewController = MainTabBarController()
        } else {
            rootViewController = OnboardingViewController()
        }
        
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        CoreDataManager.shared.saveContext()
    }
}
