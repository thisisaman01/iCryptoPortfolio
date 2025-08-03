//
//  AppDelegate.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Configure appearance for dark mode
        setupAppearance()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Setup theme manager with proper dark mode detection
        ThemeManager.shared.setupInitialTheme()
        
        // Check onboarding status
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        let rootViewController: UIViewController
        
        if hasSeenOnboarding {
            rootViewController = MainTabBarController()
        } else {
            rootViewController = OnboardingViewController()
        }
        
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func setupAppearance() {
        // Tab bar appearance
        if #available(iOS 15.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithTransparentBackground()
            tabBarAppearance.backgroundColor = UIColor.clear
            
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        
        // Navigation bar appearance
        if #available(iOS 15.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithTransparentBackground()
            navBarAppearance.backgroundColor = UIColor.clear
            
            UINavigationBar.appearance().standardAppearance = navBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        }
    }
}
