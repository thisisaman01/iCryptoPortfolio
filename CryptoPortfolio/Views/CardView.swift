//
//  CardView.swift
//  CryptoPortfolio
//
//  Created by AMAN K.A on 03/08/25.
//

import Foundation
import UIKit


class CardView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCard()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCard()
    }
    
    private func setupCard() {
        backgroundColor = Constants.Colors.cardBackground
        layer.cornerRadius = Constants.Layout.cornerRadius
        layer.masksToBounds = false
        
        // Enhanced shadow for better depth
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 12
        
        // Add theme change observer
        ThemeManager.shared.addDelegate(self)
    }
    
    deinit {
        ThemeManager.shared.removeDelegate(self)
    }
}

extension CardView: ThemeManagerDelegate {
    func themeDidChange() {
        backgroundColor = Constants.Colors.cardBackground
        
        // Adjust shadow for dark mode
        if ThemeManager.shared.isDarkMode {
            layer.shadowOpacity = 0.3
            layer.shadowColor = UIColor.black.cgColor
        } else {
            layer.shadowOpacity = 0.1
            layer.shadowColor = UIColor.black.cgColor
        }
    }
}
