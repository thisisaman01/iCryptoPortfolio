//
//  Constants.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//


import UIKit

struct Constants {
    struct Colors {
        // Exact Figma colors
        static let primaryBlue = UIColor(red: 56/255, green: 90/255, blue: 219/255, alpha: 1.0) // #385ADB
        static let gradientStart = UIColor(red: 79/255, green: 97/255, blue: 227/255, alpha: 1.0) // #4F61E3
        static let gradientEnd = UIColor(red: 171/255, green: 82/255, blue: 227/255, alpha: 1.0) // #AB52E3
        
        // Dynamic colors for dark mode
        static let cardBackground = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ?
                UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 1.0) : // Dark mode card
                UIColor.systemBackground // Light mode card
        }
        
        static let backgroundColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ?
                UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0) : // Pure black for dark mode
                UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0) // Light gray for light mode
        }
        
        static let textPrimary = UIColor.label
        static let textSecondary = UIColor.secondaryLabel
        static let greenPositive = UIColor.systemGreen
        static let redNegative = UIColor.systemRed
        
        // Glass effect colors
        static let glassBackground = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ?
                UIColor.white.withAlphaComponent(0.1) :
                UIColor.white.withAlphaComponent(0.8)
        }
        
        static let glassBorder = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ?
                UIColor.white.withAlphaComponent(0.2) :
                UIColor.white.withAlphaComponent(0.3)
        }
    }
    
    struct Fonts {
        static let largeTitle = UIFont.systemFont(ofSize: 34, weight: .bold)
        static let title1 = UIFont.systemFont(ofSize: 28, weight: .bold)
        static let title2 = UIFont.systemFont(ofSize: 22, weight: .bold)
        static let title3 = UIFont.systemFont(ofSize: 20, weight: .semibold)
        static let body = UIFont.systemFont(ofSize: 17, weight: .regular)
        static let callout = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let subheadline = UIFont.systemFont(ofSize: 15, weight: .regular)
        static let footnote = UIFont.systemFont(ofSize: 13, weight: .regular)
        static let caption = UIFont.systemFont(ofSize: 12, weight: .regular)
        static let caption2 = UIFont.systemFont(ofSize: 11, weight: .regular)
    }
    
    struct Layout {
        static let cornerRadius: CGFloat = 16
        static let smallCornerRadius: CGFloat = 8
        static let largeCornerRadius: CGFloat = 24
        static let padding: CGFloat = 16
        static let smallPadding: CGFloat = 8
        static let largePadding: CGFloat = 24
        static let tabBarHeight: CGFloat = 88
        static let cardHeight: CGFloat = 80
        static let chartHeight: CGFloat = 200
    }
    
    struct Animation {
        static let defaultDuration: TimeInterval = 0.3
        static let springDuration: TimeInterval = 0.6
        static let dampingRatio: CGFloat = 0.8
        static let chartAnimationDuration: TimeInterval = 1.0
    }
}
