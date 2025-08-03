//
//  ThemeManager.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import UIKit

protocol ThemeManagerDelegate: AnyObject {
    func themeDidChange()
}

class ThemeManager {
    static let shared = ThemeManager()
    
    private var delegates: [WeakThemeDelegate] = []
    
    private(set) var isDarkMode: Bool = false {
        didSet {
            notifyDelegates()
        }
    }
    
    private init() {}
    
    func addDelegate(_ delegate: ThemeManagerDelegate) {
        delegates.append(WeakThemeDelegate(delegate))
        cleanupDelegates()
    }
    
    func removeDelegate(_ delegate: ThemeManagerDelegate) {
        delegates.removeAll { $0.delegate === delegate }
    }
    
    private func cleanupDelegates() {
        delegates.removeAll { $0.delegate == nil }
    }
    
    private func notifyDelegates() {
        cleanupDelegates()
        delegates.forEach { $0.delegate?.themeDidChange() }
    }
    
    func setupInitialTheme() {
        // Check system preference first, then user preference
        if #available(iOS 13.0, *) {
            let systemStyle = UITraitCollection.current.userInterfaceStyle
            let userPreference = UserDefaults.standard.object(forKey: "userThemePreference") as? Int
            
            if let preference = userPreference {
                isDarkMode = preference == 1
            } else {
                isDarkMode = systemStyle == .dark
            }
        } else {
            isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        }
        
        applyTheme()
    }
    
    func toggleTheme() {
        isDarkMode.toggle()
        UserDefaults.standard.set(isDarkMode ? 1 : 0, forKey: "userThemePreference")
        
        UIView.animate(withDuration: Constants.Animation.defaultDuration) {
            self.applyTheme()
        }
        
        // Haptic feedback
        HapticManager.shared.impact(.medium)
    }
    
    private func applyTheme() {
        if #available(iOS 13.0, *) {
            let style: UIUserInterfaceStyle = isDarkMode ? .dark : .light
            
            DispatchQueue.main.async {
                UIApplication.shared.windows.forEach { window in
                    window.overrideUserInterfaceStyle = style
                }
            }
        }
    }
}

// Helper class for weak references
private class WeakThemeDelegate {
    weak var delegate: ThemeManagerDelegate?
    
    init(_ delegate: ThemeManagerDelegate) {
        self.delegate = delegate
    }
}
